import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:bmw_app/diagnostics/security_response_provider.dart';
import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DmePreparation2Screen extends StatefulWidget {
  const DmePreparation2Screen({
    super.key,
    required this.vin,
    required this.currentBootloader,
    required this.connectionStatus,
    required this.isDark,
    required this.onBeforeSend,
    required this.onAfterSend,
  });

  final String vin;
  final String currentBootloader;
  final ValueListenable<String> connectionStatus;
  final bool isDark;
  final Future<void> Function() onBeforeSend;
  final Future<void> Function() onAfterSend;

  @override
  State<DmePreparation2Screen> createState() => _DmePreparation2ScreenState();
}

class _PreparationStep {
  const _PreparationStep(this.label, this.request);

  final String label;
  final List<int> request;
}

class _PreparationExchange {
  _PreparationExchange({required this.label, required this.request});

  final String label;
  final List<int> request;
  List<int>? response;
  String? error;
}

class _DmePreparation2ScreenState extends State<DmePreparation2Screen> {
  static const _target = 0x12;
  static const _steps = <_PreparationStep>[
    _PreparationStep('Extended diagnostic session', [0x10, 0x03]),
    _PreparationStep('Read energy-saving mode', [0x22, 0x10, 0x0A]),
    _PreparationStep('Set normal mode', [0x31, 0x01, 0x0F, 0x0C, 0x00]),
    _PreparationStep('Request flash mode', [0x31, 0x01, 0x0F, 0x0C, 0x03]),
    _PreparationStep('Disable DTC setting', [0x85, 0x02]),
    _PreparationStep('Communication control', [0x28, 0x01, 0x01]),
    _PreparationStep('Set operating mode 01', [0x31, 0x01, 0x10, 0x03, 0x01]),
    _PreparationStep('Request default session', [0x10, 0x01]),
    _PreparationStep('Re-enter extended session', [0x10, 0x03]),
    _PreparationStep('Request programming session', [0x10, 0x02]),
    _PreparationStep('Verify active session', [0x22, 0xF1, 0x86]),
    _PreparationStep('Request Security Challenge', [
      0x27,
      0x11,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
    ]),
  ];

  final List<_PreparationExchange> _exchanges = [];
  bool _running = false;
  bool _complete = false;
  int _stepIndex = 0;
  String? _error;

  String _hex(List<int> bytes) => bytes
      .map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0'))
      .join(' ');

  Future<bool> _confirmRun() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Start DME Preparation 2?'),
          content: const Text(
            'This sends the 12 listed UDS requests to DME 12 in order. After a valid 67 11 response, the app calculates a key using the current BTLD and sends one 27 12 response. Some requests change ECU state.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Start sequence'),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _runSequence() async {
    if (_running || _complete || !await _confirmRun() || !mounted) return;
    setState(() {
      _running = true;
      _error = null;
      _stepIndex = 0;
      _exchanges.clear();
    });

    var paused = false;
    try {
      await widget.onBeforeSend();
      paused = true;

      for (var index = 0; index < _steps.length; index++) {
        if (!mounted) return;
        final step = _steps[index];
        setState(() => _stepIndex = index);

        final response = await sendManualDiagnosticMessage(
          target: _target,
          request: step.request,
          expectedVin: widget.vin,
        );
        final exchange = _PreparationExchange(
          label: step.label,
          request: step.request,
        )..response = response;
        if (mounted) setState(() => _exchanges.add(exchange));
        _validateResponse(step.request, response);

        final key = await SecurityResponseProvider.calculateForChallenge(
          target: _target,
          request: step.request,
          response: response,
          currentBootloader: widget.currentBootloader,
        );
        if (key != null) {
          if (key.length > 4094) {
            throw StateError('The generated key is too long for one request.');
          }
          final keyExchange = _PreparationExchange(
            label: 'Send calculated Security Response',
            request: [0x27, 0x12, ...key],
          );
          if (mounted) setState(() => _exchanges.add(keyExchange));
          final keyResponse = await sendManualDiagnosticMessage(
            target: _target,
            request: [0x27, 0x12, ...key],
            expectedVin: widget.vin,
          );
          keyExchange.response = keyResponse;
          _validateResponse(keyExchange.request, keyResponse);
          if (mounted) setState(() {});
        }
      }
      if (mounted) setState(() => _complete = true);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString();
          if (_exchanges.isNotEmpty) {
            _exchanges.last.error ??= _error;
          }
        });
      }
    } finally {
      if (paused) {
        try {
          await widget.onAfterSend();
        } catch (error) {
          if (mounted) setState(() => _error = 'Reconnect failed: $error');
        }
      }
      if (mounted) setState(() => _running = false);
    }
  }

  void _validateResponse(List<int> request, List<int> response) {
    if (response.length >= 3 && response[0] == 0x7F) {
      throw StateError(
        'DME rejected ${_hex(request)} (NRC ${_hex([response[2]])}).',
      );
    }
    if (response.isEmpty || response[0] != ((request[0] + 0x40) & 0xFF)) {
      throw StateError('Unexpected DME response to ${_hex(request)}.');
    }
    if (request[0] == 0x22 &&
        (response.length < 3 ||
            response[1] != request[1] ||
            response[2] != request[2])) {
      throw StateError('DME response DID did not match ${_hex(request)}.');
    }
    if (const {0x10, 0x27, 0x28, 0x85}.contains(request[0]) &&
        (response.length < 2 || response[1] != request[1])) {
      throw StateError(
        'DME response subfunction did not match ${_hex(request)}.',
      );
    }
    if (request[0] == 0x31 &&
        (response.length < 2 || response[1] != request[1])) {
      throw StateError('DME routine response did not match ${_hex(request)}.');
    }
  }

  Widget _exchangeCard(_PreparationExchange exchange, int index) {
    final response = exchange.response;
    final status = exchange.error != null
        ? 'Failed'
        : response == null
        ? 'Waiting'
        : 'Received';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${index + 1}. ${exchange.label} · $status'),
            const SizedBox(height: 5),
            SelectableText(
              'TX: ${_hex(exchange.request)}',
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            if (response != null)
              SelectableText(
                'RX: ${_hex(response)}',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            if (exchange.error != null)
              Text(
                exchange.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_running,
    child: Scaffold(
      appBar: AppBar(title: const Text('DME Preparation 2')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('S55 DME · ECU 12 · VIN ${widget.vin}'),
            const SizedBox(height: 4),
            Text(
              'BTLD: ${widget.currentBootloader.isEmpty ? 'Not read' : widget.currentBootloader}',
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: widget.connectionStatus,
              builder: (context, status, _) => ConnectionStatusChip(
                label: status,
                isDark: widget.isDark,
                compact: true,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Runs the specified preparation requests in order. A valid 67 11 response is sent to SK Python with the current BTLD; the calculated 27 12 response is sent before the sequence finishes.',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: const SelectableText(
                  '10 03\n'
                  '22 10 0A\n'
                  '31 01 0F 0C 00\n'
                  '31 01 0F 0C 03\n'
                  '85 02\n'
                  '28 01 01\n'
                  '31 01 10 03 01\n'
                  '10 01\n'
                  '10 03\n'
                  '10 02\n'
                  '22 F1 86\n'
                  '27 11 FF FF FF FF\n'
                  '27 12 <calculated key>',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
            if (_running) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: (_stepIndex + 1) / _steps.length),
              const SizedBox(height: 8),
              Text('Request ${_stepIndex + 1} of ${_steps.length}'),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (_complete) ...[
              const SizedBox(height: 12),
              const Text(
                'Sequence completed and the DME accepted the security response.',
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _running || _complete ? null : _runSequence,
              icon: Icon(
                _complete
                    ? Icons.check_circle_outline
                    : Icons.play_arrow_rounded,
              ),
              label: Text(
                _running
                    ? 'Running sequence…'
                    : _complete
                    ? 'Completed'
                    : 'Start sequence',
              ),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < _exchanges.length; index++)
              _exchangeCard(_exchanges[index], index),
          ],
        ),
      ),
    ),
  );
}
