import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManualDiagnosticScreen extends StatefulWidget {
  const ManualDiagnosticScreen({
    super.key,
    required this.vin,
    required this.onBeforeSend,
    required this.onAfterSend,
  });

  final String vin;
  final Future<void> Function() onBeforeSend;
  final Future<void> Function() onAfterSend;

  @override
  State<ManualDiagnosticScreen> createState() => _ManualDiagnosticScreenState();
}

class _ManualDiagnosticScreenState extends State<ManualDiagnosticScreen> {
  final _target = TextEditingController(text: '12');
  final _request = TextEditingController();
  String _requestMode = 'manual';
  bool _sending = false;
  String? _error;
  String? _sent;
  String? _response;
  final List<String> _sequenceResults = [];

  static const _preparationSequence = '''10 03
22 10 0A
31 01 0F 0C 03
85 02
28 01 01
31 01 10 03 01
10 01
10 03
10 02
27 11 FF FF FF FF''';

  @override
  void dispose() {
    _target.dispose();
    _request.dispose();
    super.dispose();
  }

  String _hex(List<int> bytes) => bytes
      .map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0'))
      .join(' ');

  Future<void> _send() async {
    if (_sending) return;
    final targetText = _target.text.trim().replaceFirst(RegExp(r'^0[xX]'), '');
    final target = RegExp(r'^[0-9a-fA-F]{1,2}$').hasMatch(targetText)
        ? int.parse(targetText, radix: 16)
        : null;
    final payload = _request.text
        .replaceAll(RegExp(r'[\s,]'), '')
        .replaceFirst(RegExp(r'^0[xX]'), '');
    if (target == null ||
        target == 0xDF ||
        target == 0xF4 ||
        !RegExp(r'^(?:[0-9a-fA-F]{2}){1,4096}$').hasMatch(payload)) {
      setState(
        () => _error =
            'Enter a physical ECU address (00–FF, excluding DF/F4) and 1–4096 hex bytes.',
      );
      return;
    }
    final bytes = <int>[
      for (var i = 0; i < payload.length; i += 2)
        int.parse(payload.substring(i, i + 2), radix: 16),
    ];
    // Any service outside the common read-only group may change ECU state.
    if (!{0x19, 0x22, 0x23}.contains(bytes.first)) {
      final approved = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Send diagnostic message?'),
          content: Text(
            'Service ${bytes.first.toRadixString(16).toUpperCase().padLeft(2, '0')} '
            'may change ECU state. Send ${_hex(bytes)} to ECU '
            '${target.toRadixString(16).toUpperCase().padLeft(2, '0')}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Send'),
            ),
          ],
        ),
      );
      if (approved != true || !mounted) return;
    }
    setState(() {
      _sending = true;
      _error = null;
      _response = null;
      _sent = _hex(bytes);
    });
    var paused = false;
    try {
      await widget.onBeforeSend();
      paused = true;
      final result = await sendManualDiagnosticMessage(
        target: target,
        request: bytes,
        expectedVin: widget.vin,
      );
      if (mounted) setState(() => _response = _hex(result));
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (paused) {
        try {
          await widget.onAfterSend();
        } catch (error) {
          if (mounted) setState(() => _error = 'Reconnect failed: $error');
        }
      }
      if (mounted) setState(() => _sending = false);
    }
  }

  List<List<int>> _parseSequence(String text) {
    final requests = <List<int>>[];
    for (final rawLine in text.split(RegExp(r'[\r\n;]+'))) {
      final payload = rawLine
          .replaceAll(RegExp(r'[#].*$'), '')
          .replaceAll(RegExp(r'[\s,]'), '')
          .replaceFirst(RegExp(r'^0[xX]'), '');
      if (payload.isEmpty) continue;
      if (!RegExp(r'^(?:[0-9a-fA-F]{2}){1,4096}$').hasMatch(payload)) {
        throw FormatException('Invalid hex request: $rawLine');
      }
      requests.add([
        for (var i = 0; i < payload.length; i += 2)
          int.parse(payload.substring(i, i + 2), radix: 16),
      ]);
    }
    if (requests.isEmpty)
      throw const FormatException('Enter at least one request line.');
    return requests;
  }

  Future<void> _sendSequence() async {
    if (_sending) return;
    final targetText = _target.text.trim().replaceFirst(RegExp(r'^0[xX]'), '');
    final target = RegExp(r'^[0-9a-fA-F]{1,2}$').hasMatch(targetText)
        ? int.parse(targetText, radix: 16)
        : null;
    if (target == null || target == 0xDF || target == 0xF4) {
      setState(
        () => _error = 'Enter a physical ECU address (00–FF, excluding DF/F4).',
      );
      return;
    }
    late final List<List<int>> requests;
    try {
      requests = _parseSequence(_request.text);
    } catch (error) {
      setState(() => _error = error.toString());
      return;
    }
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send diagnostic sequence?'),
        content: Text(
          '${requests.length} request(s) will be sent in order. Some services may change ECU state.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    setState(() {
      _sending = true;
      _error = null;
      _response = null;
      _sequenceResults.clear();
    });
    var paused = false;
    try {
      await widget.onBeforeSend();
      paused = true;
      for (var index = 0; index < requests.length; index++) {
        final request = requests[index];
        final requestHex = _hex(request);
        try {
          final result = await sendManualDiagnosticMessage(
            target: target,
            request: request,
            expectedVin: widget.vin,
          );
          if (!mounted) return;
          setState(
            () => _sequenceResults.add(
              '${index + 1}. Request: $requestHex\n   Response: ${_hex(result)}',
            ),
          );
        } catch (error) {
          if (mounted)
            setState(
              () => _sequenceResults.add(
                '${index + 1}. Request: $requestHex\n   Transport error: $error',
              ),
            );
          break;
        }
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (paused) {
        try {
          await widget.onAfterSend();
        } catch (error) {
          if (mounted) setState(() => _error = 'Reconnect failed: $error');
        }
      }
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Manual diagnostic message')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Enter UDS payload bytes in hex. The app adds ENET framing and sends one request to the chosen ECU. Default DME address: 12.',
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _target,
          enabled: !_sending,
          decoration: const InputDecoration(
            labelText: 'ECU address (hex)',
            hintText: '12',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _requestMode,
          decoration: const InputDecoration(
            labelText: 'Request source',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'manual', child: Text('Enter manually')),
            DropdownMenuItem(
              value: 'prepare',
              child: Text('Preparation sequence'),
            ),
          ],
          onChanged: _sending
              ? null
              : (value) {
                  if (value == null) return;
                  setState(() {
                    _requestMode = value;
                    if (value == 'prepare') {
                      _request.text = _preparationSequence;
                    }
                  });
                },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _request,
          enabled: !_sending,
          maxLines: 3,
          style: const TextStyle(fontFamily: 'monospace'),
          decoration: const InputDecoration(
            labelText: 'UDS request (hex bytes)',
            hintText: '22 F1 50, or one request per line for a sequence',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _sending || _requestMode != 'manual' ? null : _send,
          icon: _sending
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_rounded),
          label: Text(_sending ? 'Sending…' : 'Send one message'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _sending ? null : _sendSequence,
          icon: const Icon(Icons.playlist_play_rounded),
          label: const Text('Send sequence, one line at a time'),
        ),
        const SizedBox(height: 8),
        const Text(
          'For a sequence, put one UDS request per line. Lines beginning with # are comments. The next line is sent only after the previous response is received.',
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SelectableText(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (_sent != null) ...[
          const SizedBox(height: 20),
          Text(
            'Request: $_sent',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
        if (_response != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Response',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Copy response hex',
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: _response!)),
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
          SelectableText(
            _response!,
            style: const TextStyle(fontFamily: 'monospace', height: 1.5),
          ),
          if (_response!.startsWith('7F '))
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Negative response: 7F <request service> <response code>',
              ),
            ),
        ],
        if (_sequenceResults.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Sequence results',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final result in _sequenceResults)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SelectableText(
                result,
                style: const TextStyle(fontFamily: 'monospace', height: 1.4),
              ),
            ),
        ],
      ],
    ),
  );
}
