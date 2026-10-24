import 'dart:convert';
import 'dart:io';

import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:bmw_app/diagnostics/security_response_provider.dart';
import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:bmw_app/product/product_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PrepScreen extends StatefulWidget {
  const PrepScreen({
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
  State<PrepScreen> createState() => _PrepScreenState();
}

class _PrepExchange {
  _PrepExchange({
    required this.label,
    this.request,
    this.sensitiveRequest = false,
  });

  final String label;
  final List<int>? request;
  final bool sensitiveRequest;
  List<int>? response;
  String? transportError;
  bool skipped = false;
  bool sending = true;
}

class _GuidedPrepStep {
  const _GuidedPrepStep({
    required this.label,
    required this.request,
    required this.detail,
  });

  final String label;
  final List<int> request;
  final String detail;
}

class _GuidedPrepDraft {
  _GuidedPrepDraft({this.option});

  _GuidedPrepStep? option;
  final manualRequestController = TextEditingController();

  void dispose() => manualRequestController.dispose();
}

class _PrepScreenState extends State<PrepScreen> {
  static const _dmeAddress = 0x12;
  static const _customSequenceTemplate = '''10 03
22 10 0A
31 01 0F 0C 00
31 01 0F 0C 03
85 02
28 01 01
31 01 10 03 01
10 01
10 03
10 02
22 F1 86''';

  final List<_PrepExchange> _exchanges = [];
  final _customSequence = TextEditingController(text: _customSequenceTemplate);
  bool _editMessages = false;
  bool _running = false;
  bool _guidedActive = false;
  bool _guidedSessionPaused = false;
  bool _guidedStepSending = false;
  bool _guidedComplete = false;
  bool _guidedFailed = false;
  bool _stopRequested = false;
  int _guidedStepIndex = 0;
  final List<_GuidedPrepStep> _guidedSteps = [];
  final List<_GuidedPrepDraft> _guidedDraftSteps = [
    _GuidedPrepDraft(option: _enterExtendedSession),
    _GuidedPrepDraft(option: _readEnergySavingMode),
  ];
  String? _runError;
  String? _reportError;
  DateTime? _lastRunStartedAt;
  DateTime? _lastRunEndedAt;
  String? _lastRunMode;
  String? _lastRunConnectionAtStart;
  String? _lastRunConnectionAtEnd;
  String? _lastEditedSequence;

  static const _enterExtendedSession = _GuidedPrepStep(
    label: 'Enter extended diagnostic session',
    request: [0x10, 0x03],
    detail: 'Request diagnostic session 03 from DME 12.',
  );
  static const _readEnergySavingMode = _GuidedPrepStep(
    label: 'Read energy-saving mode',
    request: [0x22, 0x10, 0x0A],
    detail:
        'Read DID 0x100A. If it already reports mode 03, the two mode-change steps will be skipped.',
  );
  static const _setNormalMode = _GuidedPrepStep(
    label: 'Set normal mode before flash mode',
    request: [0x31, 0x01, 0x0F, 0x0C, 0x00],
    detail: 'Request operating mode 00 before requesting mode 03.',
  );
  static const _requestFlashMode = _GuidedPrepStep(
    label: 'Request flash mode',
    request: [0x31, 0x01, 0x0F, 0x0C, 0x03],
    detail: 'Request operating mode 03.',
  );
  static const _requestOperatingMode01 = _GuidedPrepStep(
    label: 'Request operating mode 01',
    request: [0x31, 0x01, 0x0F, 0x0C, 0x01],
    detail: 'Request operating mode 01.',
  );
  static const _manualUdsMessage = _GuidedPrepStep(
    label: 'Enter UDS message manually',
    request: [],
    detail: 'Enter a custom UDS request as hexadecimal bytes.',
  );
  static const _guidedMessageOptions = <_GuidedPrepStep>[
    _enterExtendedSession,
    _GuidedPrepStep(
      label: 'Request default session',
      request: [0x10, 0x01],
      detail: 'Request diagnostic session 01.',
    ),
    _GuidedPrepStep(
      label: 'Re-enter extended diagnostic session',
      request: [0x10, 0x03],
      detail: 'Request diagnostic session 03 again.',
    ),
    _GuidedPrepStep(
      label: 'Request programming session',
      request: [0x10, 0x02],
      detail: 'Request programming session 02.',
    ),
    _readEnergySavingMode,
    _GuidedPrepStep(
      label: 'Verify active session (BimmerScope check)',
      request: [0x22, 0xF1, 0x86],
      detail: 'Read DID 0xF186 and review the DME response.',
    ),
    _GuidedPrepStep(
      label: 'Request Security Challenge',
      request: [0x27, 0x11, 0xFF, 0xFF, 0xFF, 0xFF],
      detail:
          'Request a seed. A positive response is passed to SK Python and answered once.',
    ),
    _GuidedPrepStep(
      label: 'Communication control',
      request: [0x28, 0x01, 0x01],
      detail: 'Request the observed communication-control setting.',
    ),
    _setNormalMode,
    _requestOperatingMode01,
    _requestFlashMode,
    _GuidedPrepStep(
      label: 'Set operating mode 01',
      request: [0x31, 0x01, 0x10, 0x03, 0x01],
      detail: 'Request routine 0x1003 with mode 01.',
    ),
    _GuidedPrepStep(
      label: 'Disable DTC setting',
      request: [0x85, 0x02],
      detail: 'Request temporary disablement of DTC setting.',
    ),
    _manualUdsMessage,
  ];

  @override
  void dispose() {
    _customSequence.dispose();
    for (final draft in _guidedDraftSteps) {
      draft.dispose();
    }
    super.dispose();
  }

  String _hex(List<int> bytes) => bytes
      .map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0'))
      .join(' ');

  List<int> _parseManualUdsRequest(String input) {
    final payload = input
        .replaceAll(RegExp(r'[\s,:]'), '')
        .replaceFirst(RegExp(r'^0[xX]'), '');
    if (!RegExp(r'^(?:[0-9a-fA-F]{2}){1,4096}$').hasMatch(payload)) {
      throw const FormatException(
        'Enter one UDS message as hexadecimal bytes, for example 31 01 0F 0C 01.',
      );
    }
    return [
      for (var index = 0; index < payload.length; index += 2)
        int.parse(payload.substring(index, index + 2), radix: 16),
    ];
  }

  Future<bool> _confirmRun() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Start step-by-step DME preparation?'),
            content: const Text(
              'Each Next tap sends one selected UDS request to DME 12 and waits for its response. A positive 67 11 seed response triggers one SK Python calculation and one automatic 27 12 attempt. Some requests change ECU state. It does not send calibration or flash data.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Start guided steps'),
              ),
            ],
          ),
        ) ??
        false;
  }

  List<List<int>> _parseCustomSequence() {
    final requests = <List<int>>[];
    for (final rawLine in _customSequence.text.split(RegExp(r'[\r\n;]+'))) {
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
    if (requests.isEmpty) {
      throw const FormatException('Enter at least one request line.');
    }
    return requests;
  }

  Future<void> _runCustomSequence() async {
    if (_running) {
      setState(() => _stopRequested = true);
      return;
    }
    if (widget.vin.trim().length != 17) {
      setState(() => _runError = 'A verified 17-character VIN is required.');
      return;
    }
    late final List<List<int>> requests;
    try {
      requests = _parseCustomSequence();
    } catch (error) {
      setState(() => _runError = error.toString());
      return;
    }
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send editable preparation sequence?'),
        content: Text(
          '${requests.length} request(s) will be sent in order to DME 12. Some requests may change temporary ECU state. Review every line before sending.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send sequence'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;

    setState(() {
      _running = true;
      _stopRequested = false;
      _runError = null;
      _reportError = null;
      _lastRunStartedAt = DateTime.now();
      _lastRunEndedAt = null;
      _lastRunMode = 'Editable messages';
      _lastRunConnectionAtStart = widget.connectionStatus.value;
      _lastEditedSequence = _customSequence.text;
      _exchanges.clear();
    });
    var paused = false;
    try {
      await widget.onBeforeSend();
      paused = true;
      for (var index = 0; index < requests.length; index++) {
        if (_shouldStop) break;
        try {
          await _send('Editable request ${index + 1}', requests[index]);
        } catch (_) {
          // A transport failure is recorded on the exchange and ends the
          // sequence; ECU negative responses remain normal logged results.
          break;
        }
      }
    } catch (error) {
      if (mounted) setState(() => _runError = error.toString());
    } finally {
      if (paused) {
        try {
          await widget.onAfterSend();
        } catch (error) {
          if (mounted) setState(() => _runError = 'Reconnect failed: $error');
        }
      }
      if (mounted) {
        setState(() {
          _lastRunEndedAt = DateTime.now();
          _lastRunConnectionAtEnd = widget.connectionStatus.value;
          _running = false;
        });
      }
    }
  }

  Future<void> _runPreparation() async {
    if (_running || _guidedActive) return;
    if (widget.vin.trim().length != 17) {
      setState(() => _runError = 'A verified 17-character VIN is required.');
      return;
    }
    if (_guidedDraftSteps.isEmpty ||
        _guidedDraftSteps.any((draft) => draft.option == null)) {
      setState(() => _runError = 'Choose a message for every guided step.');
      return;
    }
    final selectedSteps = <_GuidedPrepStep>[];
    try {
      for (final draft in _guidedDraftSteps) {
        final option = draft.option!;
        if (identical(option, _manualUdsMessage)) {
          selectedSteps.add(
            _GuidedPrepStep(
              label: 'Custom UDS message',
              request: _parseManualUdsRequest(
                draft.manualRequestController.text,
              ),
              detail: 'Manually entered UDS request.',
            ),
          );
        } else {
          selectedSteps.add(option);
        }
      }
    } on FormatException catch (error) {
      setState(() => _runError = error.message);
      return;
    }
    if (!await _confirmRun() || !mounted) return;

    setState(() {
      _running = true;
      _guidedActive = true;
      _guidedSessionPaused = false;
      _guidedStepSending = false;
      _guidedComplete = false;
      _guidedFailed = false;
      _guidedStepIndex = 0;
      _guidedSteps
        ..clear()
        ..addAll(selectedSteps);
      _runError = null;
      _reportError = null;
      _lastRunStartedAt = DateTime.now();
      _lastRunEndedAt = null;
      _lastRunMode = 'Guided prep';
      _lastRunConnectionAtStart = widget.connectionStatus.value;
      _lastEditedSequence = null;
      _exchanges.clear();
    });

    try {
      await widget.onBeforeSend();
      if (mounted) setState(() => _guidedSessionPaused = true);
    } catch (error) {
      if (mounted) {
        setState(() {
          _runError = error.toString();
          _guidedFailed = true;
        });
      }
    }
  }

  Future<void> _advanceGuidedPrep() async {
    if (!_guidedActive || _guidedStepSending || _guidedFailed) return;

    if (_guidedStepIndex >= _guidedSteps.length) {
      setState(() => _guidedComplete = true);
      return;
    }

    final stepIndex = _guidedStepIndex;
    final step = _guidedSteps[stepIndex];
    setState(() {
      _guidedStepSending = true;
      _runError = null;
    });
    try {
      final response = await _send(step.label, step.request);
      if (!mounted) return;

      // A rejected preparation request can leave the ECU in a state that does
      // not satisfy later steps. Stop here instead of proceeding through the
      // sequence (or requesting a security key) after a negative response.
      final expectedPositiveSid = (step.request[0] + 0x40) & 0xFF;
      final hasFinalNegativeResponse =
          response != null &&
          response.length >= 3 &&
          response[0] == 0x7F &&
          response[2] != 0x78;
      final hasExpectedPositiveResponse =
          response != null &&
          response.isNotEmpty &&
          response[0] == expectedPositiveSid;
      if (hasFinalNegativeResponse || !hasExpectedPositiveResponse) {
        final reason = hasFinalNegativeResponse
            ? 'was rejected by the DME (NRC ${_hex([response[2]])})'
            : 'returned an unexpected response';
        setState(() {
          _guidedFailed = true;
          _runError = '${step.label} $reason. Guided steps stopped.';
        });
        return;
      }

      if (_isEnergySavingModeRead(step.request)) {
        final flashModeAlreadySet =
            response.length >= 4 &&
            response[0] == 0x62 &&
            response[1] == 0x10 &&
            response[2] == 0x0A &&
            response[3] == 0x03;
        if (flashModeAlreadySet) {
          _addSkipped(
            'Mode change skipped: DID 0x100A already reports flash mode 03',
          );
        } else {
          _guidedSteps.addAll([_setNormalMode, _requestFlashMode]);
        }
        _guidedSteps.addAll(_guidedStepsAfterMode);
      }

      final key = await SecurityResponseProvider.calculateForChallenge(
        target: _dmeAddress,
        request: step.request,
        response: response,
        currentBootloader: widget.currentBootloader,
      );
      if (key != null) {
        if (!mounted || _stopRequested) return;
        if (key.length > 4094) {
          throw StateError('The generated key is too long for one request.');
        }
        final keyResponse = await _send('Send calculated Security Response', [
          0x27,
          0x12,
          ...key,
        ], sensitiveRequest: true);
        if (keyResponse == null ||
            keyResponse.length < 2 ||
            keyResponse[0] != 0x67 ||
            keyResponse[1] != 0x12) {
          final detail =
              keyResponse != null &&
                  keyResponse.length >= 3 &&
                  keyResponse[0] == 0x7F
              ? ' (NRC ${_hex([keyResponse[2]])})'
              : '';
          throw StateError(
            'The DME did not accept the security response$detail.',
          );
        }
      } else if (listEquals(step.request, const [
        0x27,
        0x11,
        0xFF,
        0xFF,
        0xFF,
        0xFF,
      ])) {
        _guidedComplete = true;
        _runError =
            'The DME response did not contain a 67 11 seed. No key was sent.';
      }

      setState(() {
        _guidedStepIndex++;
        if (_guidedStepIndex >= _guidedSteps.length) {
          _guidedComplete = true;
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _runError = error.toString();
          _guidedFailed = true;
        });
      }
    } finally {
      if (mounted) setState(() => _guidedStepSending = false);
    }
  }

  static const _guidedStepsAfterMode = <_GuidedPrepStep>[
    _GuidedPrepStep(
      label: 'Disable DTC setting',
      request: [0x85, 0x02],
      detail: 'Request temporary disablement of DTC setting.',
    ),
    _GuidedPrepStep(
      label: 'Communication control',
      request: [0x28, 0x01, 0x01],
      detail: 'Request the observed communication-control setting.',
    ),
    _GuidedPrepStep(
      label: 'Set operating mode 01',
      request: [0x31, 0x01, 0x10, 0x03, 0x01],
      detail: 'Request routine 0x1003 with mode 01.',
    ),
    _GuidedPrepStep(
      label: 'Request default session',
      request: [0x10, 0x01],
      detail: 'Request diagnostic session 01.',
    ),
    _GuidedPrepStep(
      label: 'Re-enter extended diagnostic session',
      request: [0x10, 0x03],
      detail: 'Request diagnostic session 03 again.',
    ),
    _GuidedPrepStep(
      label: 'Request programming session',
      request: [0x10, 0x02],
      detail: 'Request programming session 02.',
    ),
    _GuidedPrepStep(
      label: 'Verify active session (BimmerScope check)',
      request: [0x22, 0xF1, 0x86],
      detail: 'Read DID 0xF186 and review the DME response.',
    ),
    _GuidedPrepStep(
      label: 'Request Security Challenge',
      request: [0x27, 0x11, 0xFF, 0xFF, 0xFF, 0xFF],
      detail: 'Request a seed. The next stage will display it for you.',
    ),
  ];

  bool _isEnergySavingModeRead(List<int> request) =>
      request.length == 3 &&
      request[0] == 0x22 &&
      request[1] == 0x10 &&
      request[2] == 0x0A;

  Future<void> _finishGuidedPrep() async {
    if (!_guidedActive || _guidedStepSending) return;
    final shouldReconnect = _guidedSessionPaused;
    setState(() {
      _guidedStepSending = true;
      if (!_guidedComplete && !_guidedFailed) _stopRequested = true;
    });
    try {
      if (shouldReconnect) await widget.onAfterSend();
    } catch (error) {
      if (mounted) setState(() => _runError = 'Reconnect failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _guidedSessionPaused = false;
          _guidedActive = false;
          _guidedStepSending = false;
          _running = false;
          _lastRunEndedAt = DateTime.now();
          _lastRunConnectionAtEnd = widget.connectionStatus.value;
        });
      }
    }
  }

  String get _guidedNextLabel {
    if (_guidedComplete || _guidedFailed) return 'Finish & reconnect';
    if (_guidedStepIndex >= _guidedSteps.length) {
      return 'Finish & reconnect';
    }
    return 'Next · ${_guidedSteps[_guidedStepIndex].label}';
  }

  Widget _guidedProgressCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeStep = _guidedStepIndex < _guidedSteps.length
        ? _guidedSteps[_guidedStepIndex]
        : null;
    final title = _guidedComplete
        ? 'Guided sequence complete'
        : _guidedFailed
        ? 'Guided sequence paused'
        : activeStep?.label ?? 'Preparing guided sequence';
    final detail =
        activeStep?.detail ??
        (_guidedComplete
            ? 'Review the response log, then finish and reconnect.'
            : 'Finish and reconnect to resume live monitoring.');
    final totalSteps = _guidedSteps.length;
    final shownStep = (_guidedStepIndex + 1).clamp(1, totalSteps);

    return Card(
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (!_guidedComplete && !_guidedFailed)
                  Text(
                    'Step $shownStep of $totalSteps',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(detail),
            if (_guidedActive && !_guidedComplete && !_guidedFailed) ...[
              const SizedBox(height: 10),
              Text(
                'Each button press sends one request. Review its response in the log before continuing.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _moveGuidedDraftStep(int from, int to) {
    if (to < 0 || to >= _guidedDraftSteps.length) return;
    setState(() {
      final draft = _guidedDraftSteps.removeAt(from);
      _guidedDraftSteps.insert(to, draft);
      _runError = null;
    });
  }

  Widget _guidedDraftRow(int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final draft = _guidedDraftSteps[index];
    final step = draft.option;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownButtonFormField<_GuidedPrepStep>(
                  key: ValueKey('guided-message-$index-${step?.label}'),
                  initialValue: step,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Message ${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    for (final option in _guidedMessageOptions)
                      DropdownMenuItem(
                        value: option,
                        child: Text(
                          identical(option, _manualUdsMessage)
                              ? option.label
                              : '${option.label} · ${_hex(option.request)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (option) => setState(() {
                    draft.option = option;
                    _runError = null;
                  }),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Move message ${index + 1} up',
                onPressed: index == 0
                    ? null
                    : () => _moveGuidedDraftStep(index, index - 1),
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
              IconButton(
                tooltip: 'Move message ${index + 1} down',
                onPressed: index == _guidedDraftSteps.length - 1
                    ? null
                    : () => _moveGuidedDraftStep(index, index + 1),
                icon: const Icon(Icons.arrow_downward_rounded),
              ),
              IconButton(
                tooltip: 'Remove message ${index + 1}',
                onPressed: _guidedDraftSteps.length <= 1
                    ? null
                    : () => setState(() {
                        _guidedDraftSteps.removeAt(index).dispose();
                        _runError = null;
                      }),
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
            ],
          ),
          if (identical(step, _manualUdsMessage)) ...[
            const SizedBox(height: 8),
            TextField(
              controller: draft.manualRequestController,
              minLines: 1,
              maxLines: 2,
              style: const TextStyle(fontFamily: 'monospace'),
              decoration: const InputDecoration(
                labelText: 'Manual UDS message (hex bytes)',
                hintText: '31 01 0F 0C 01',
                helperText:
                    'Enter one message. Spaces and commas are optional.',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _runError = null),
            ),
          ] else if (step != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _hex(step.request),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    step.detail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _guidedDraftEditor() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose guided messages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Select, reorder, add, or remove messages before starting.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < _guidedDraftSteps.length; index++)
              _guidedDraftRow(index),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() {
                  _guidedDraftSteps.add(_GuidedPrepDraft());
                  _runError = null;
                }),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _shouldStop => _stopRequested || !mounted;

  String _requestText(_PrepExchange exchange) {
    if (exchange.sensitiveRequest) return '27 12 <redacted key>';
    return exchange.request == null ? '' : _hex(exchange.request!);
  }

  void _notify(String message, {bool isError = false}) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<List<int>?> _send(
    String label,
    List<int> request, {
    bool sensitiveRequest = false,
  }) async {
    final isSecurityKey =
        request.length >= 2 && request[0] == 0x27 && request[1] == 0x12;
    final exchange = _PrepExchange(
      label: label,
      request: List<int>.of(request),
      sensitiveRequest: sensitiveRequest,
    );
    setState(() => _exchanges.add(exchange));
    _notify('Sending: $label');
    try {
      final response = await sendManualDiagnosticMessage(
        target: _dmeAddress,
        request: request,
        expectedVin: widget.vin,
      );
      if (mounted) {
        setState(() {
          exchange.response = response;
          exchange.sending = false;
        });
        final result = _status(exchange);
        _notify(
          '$label: $result',
          isError: result.startsWith('Rejected') || result == 'Transport error',
        );
      }
      return response;
    } catch (error) {
      if (mounted) {
        setState(() {
          exchange.transportError = isSecurityKey
              ? 'Transport error while sending the Security response.'
              : error.toString();
          exchange.sending = false;
        });
        _notify('$label: transport error', isError: true);
      }
      if (isSecurityKey) {
        throw Exception('Security response transport error.');
      }
      rethrow;
    }
  }

  void _addSkipped(String label) {
    setState(() {
      _exchanges.add(_PrepExchange(label: label)..skipped = true);
    });
  }

  String _status(_PrepExchange exchange) {
    if (exchange.skipped) return 'Skipped';
    if (exchange.transportError != null) return 'Transport error';
    final response = exchange.response;
    if (response == null) return exchange.sending ? 'Sending…' : 'No response';
    if (response.length >= 3 && response[0] == 0x7F) {
      if (response[2] == 0x78) return 'Pending response';
      return 'Rejected · NRC ${_hex([response[2]])}';
    }
    final request = exchange.request;
    if (request != null &&
        request.isNotEmpty &&
        response.isNotEmpty &&
        response[0] == ((request[0] + 0x40) & 0xFF)) {
      if (request.length >= 2 &&
          const {
            0x10,
            0x11,
            0x27,
            0x28,
            0x31,
            0x3E,
            0x85,
          }.contains(request[0]) &&
          (response.length < 2 || response[1] != request[1])) {
        return 'Unexpected response';
      }
      return 'Accepted';
    }
    return 'Unexpected response';
  }

  Color _statusColor(BuildContext context, _PrepExchange exchange) {
    if (exchange.skipped) return Theme.of(context).colorScheme.secondary;
    final response = exchange.response;
    if (exchange.transportError != null ||
        (response != null &&
            response.length >= 3 &&
            response[0] == 0x7F &&
            response[2] != 0x78)) {
      return Theme.of(context).colorScheme.error;
    }
    if (response != null && _status(exchange) == 'Accepted') {
      return Theme.of(context).colorScheme.primary;
    }
    if (response != null) return Theme.of(context).colorScheme.tertiary;
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  Future<void> _copyExchange(_PrepExchange exchange) async {
    final lines = [
      if (exchange.request != null) 'Request: ${_requestText(exchange)}',
      if (exchange.response != null) 'Response: ${_hex(exchange.response!)}',
      if (exchange.transportError != null)
        'Transport error: ${exchange.transportError}',
      if (exchange.skipped) 'Skipped: ${exchange.label}',
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
  }

  Map<String, Object?> _reportData() => {
    'format': 'bimmerscope-dme-prep-report-v1',
    'generatedAtUtc': DateTime.now().toUtc().toIso8601String(),
    'runStartedAtUtc': _lastRunStartedAt?.toUtc().toIso8601String(),
    'runEndedAtUtc': _lastRunEndedAt?.toUtc().toIso8601String(),
    'appEdition': ProductConfig.editionName,
    'vehicle': {'vin': widget.vin, 'engine': 'S55'},
    'ecu': {'name': 'DME', 'addressHex': '12'},
    'run': {
      'mode': _lastRunMode,
      'connectionAtStart': _lastRunConnectionAtStart,
      'connectionAtEnd': _lastRunConnectionAtEnd,
      'stoppedByUser': _stopRequested,
      'error': _runError,
      'editedSequence': _lastEditedSequence,
    },
    'exchanges': [
      for (var index = 0; index < _exchanges.length; index++)
        {
          'step': index + 1,
          'label': _exchanges[index].label,
          'requestHex':
              _exchanges[index].request == null ||
                  _exchanges[index].sensitiveRequest
              ? null
              : _hex(_exchanges[index].request!),
          'requestRedacted': _exchanges[index].sensitiveRequest,
          'responseHex': _exchanges[index].response == null
              ? null
              : _hex(_exchanges[index].response!),
          'status': _status(_exchanges[index]),
          'negativeResponseCode': _negativeResponseCode(_exchanges[index]),
          'transportError': _exchanges[index].transportError,
          'skipped': _exchanges[index].skipped,
        },
    ],
    'note':
        'Preparation prototype report. Calculated 27 12 key bytes are redacted from the request log and report. The report does not include calibration or flash data.',
  };

  String? _negativeResponseCode(_PrepExchange exchange) {
    final response = exchange.response;
    if (response == null || response.length < 3 || response[0] != 0x7F) {
      return null;
    }
    return _hex([response[2]]);
  }

  String _textReport(Map<String, Object?> data) {
    final lines = <String>[
      'BimmerScope DME preparation report',
      'Format: bimmerscope-dme-prep-report-v1',
      'Edition: ${data['appEdition']}',
      'Generated (UTC): ${data['generatedAtUtc']}',
      'Run mode: ${_lastRunMode ?? 'Unknown'}',
      'Run started (UTC): ${data['runStartedAtUtc'] ?? 'Unknown'}',
      'Run ended (UTC): ${data['runEndedAtUtc'] ?? 'In progress'}',
      'VIN: ${widget.vin}',
      'Engine / ECU: S55 DME',
      'ECU address: 12 (hex)',
      'Connection at start: ${_lastRunConnectionAtStart ?? 'Unknown'}',
      'Connection at end: ${_lastRunConnectionAtEnd ?? 'Unknown'}',
      'Stopped by user: $_stopRequested',
      if (_runError != null) 'Run error: $_runError',
      '',
    ];
    if (_lastEditedSequence != null) {
      lines.addAll(['Editable sequence as entered:', _lastEditedSequence!, '']);
    }
    lines.add('Request / response log:');
    if (_exchanges.isEmpty) lines.add('No requests recorded.');
    for (var index = 0; index < _exchanges.length; index++) {
      final exchange = _exchanges[index];
      lines.add('${index + 1}. ${exchange.label}');
      if (exchange.request != null)
        lines.add('   TX: ${_requestText(exchange)}');
      if (exchange.response != null) {
        lines.add('   RX: ${_hex(exchange.response!)}');
      }
      if (exchange.transportError != null) {
        lines.add('   Transport error: ${exchange.transportError}');
      }
      if (exchange.skipped) lines.add('   Skipped; no request was sent.');
    }
    lines.addAll([
      '',
      'Note: This report contains the VIN and raw diagnostic payloads. Calculated 27 12 key bytes are redacted. It does not contain calibration or flash data.',
    ]);
    return lines.join('\n');
  }

  Future<void> _exportReport({required bool asJson}) async {
    if (_exchanges.isEmpty || _running) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share preparation report?'),
        content: const Text(
          'The report includes the vehicle VIN and raw UDS requests and responses. Calculated 27 12 key bytes are redacted. You can review the file before choosing where to share it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;

    try {
      final documents = await getApplicationDocumentsDirectory();
      final directory = Directory(
        '${documents.path}${Platform.pathSeparator}BimmerScope${Platform.pathSeparator}prep_reports',
      );
      await directory.create(recursive: true);
      final stamp = DateTime.now()
          .toIso8601String()
          .replaceAll(RegExp(r'[-:]'), '')
          .replaceAll('.', '_');
      final extension = asJson ? 'json' : 'txt';
      final file = File(
        '${directory.path}${Platform.pathSeparator}BimmerScope_Prep_${widget.vin}_$stamp.$extension',
      );
      final data = _reportData();
      await file.writeAsString(
        asJson
            ? const JsonEncoder.withIndent('  ').convert(data)
            : _textReport(data),
      );
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              file.path,
              mimeType: asJson ? 'application/json' : 'text/plain',
            ),
          ],
          subject: 'BimmerScope DME preparation report',
          text: 'BimmerScope DME preparation report · VIN ${widget.vin}',
        ),
      );
      if (mounted) setState(() => _reportError = null);
    } catch (error) {
      if (mounted)
        setState(() => _reportError = 'Could not export report: $error');
    }
  }

  Future<void> _chooseReportFormat() async {
    final format = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Readable text report (.txt)'),
              onTap: () => Navigator.pop(context, false),
            ),
            ListTile(
              leading: const Icon(Icons.data_object_rounded),
              title: const Text('Structured report (.json)'),
              onTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
    if (format != null) await _exportReport(asJson: format);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: !_guidedSessionPaused,
      title: const Text('DME preparation prototype'),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'S55 DME · ECU 12 · VIN ${widget.vin}',
                style: Theme.of(context).textTheme.titleMedium,
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
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Runs the examined S55 preparation flow one request at a time. A positive 67 11 response is passed to SK Python using the current BTLD, and the calculated 27 12 response is sent automatically. Key bytes are redacted from the log and reports.',
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: false,
                icon: Icon(Icons.auto_awesome_rounded),
                label: Text('Guided prep'),
              ),
              ButtonSegment<bool>(
                value: true,
                icon: Icon(Icons.edit_note_rounded),
                label: Text('Editable messages'),
              ),
            ],
            selected: {_editMessages},
            onSelectionChanged: _running
                ? null
                : (selection) => setState(() {
                    _editMessages = selection.first;
                    _runError = null;
                  }),
          ),
          if (!_editMessages && !_guidedActive) ...[
            const SizedBox(height: 12),
            _guidedDraftEditor(),
          ],
          if (_editMessages) ...[
            const SizedBox(height: 12),
            const Text(
              'Edit one UDS request per line. The template mirrors the guided flow; the mode commands 00 → 03 are included as editable lines, so remove them if the ECU already reports mode 03.',
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _customSequence,
              enabled: !_running,
              minLines: 8,
              maxLines: 14,
              style: const TextStyle(fontFamily: 'monospace'),
              decoration: const InputDecoration(
                labelText: 'UDS requests (hex bytes)',
                helperText:
                    'Spaces and commas are optional; # starts a comment.',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
          if (_guidedActive) ...[
            const SizedBox(height: 12),
            _guidedProgressCard(context),
          ],
          const SizedBox(height: 12),
          if (_guidedActive)
            FilledButton.icon(
              onPressed: _guidedStepSending
                  ? null
                  : _guidedComplete || _guidedFailed
                  ? _finishGuidedPrep
                  : _advanceGuidedPrep,
              icon: Icon(
                _guidedStepSending
                    ? Icons.hourglass_top_rounded
                    : _guidedComplete || _guidedFailed
                    ? Icons.link_rounded
                    : _guidedStepIndex >= _guidedSteps.length
                    ? Icons.key_rounded
                    : Icons.arrow_forward_rounded,
              ),
              label: Text(
                _guidedStepSending
                    ? 'Waiting for DME response…'
                    : _guidedNextLabel,
              ),
            )
          else
            FilledButton.icon(
              onPressed: _editMessages ? _runCustomSequence : _runPreparation,
              icon: Icon(
                _running ? Icons.stop_rounded : Icons.play_arrow_rounded,
              ),
              label: Text(
                _running
                    ? 'Stop after current response'
                    : _editMessages
                    ? 'Send editable sequence'
                    : 'Start step-by-step prep',
              ),
            ),
          if (_guidedActive && !_guidedComplete && !_guidedFailed) ...[
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: _guidedStepSending ? null : _finishGuidedPrep,
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('Cancel steps & reconnect'),
            ),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _exchanges.isEmpty || _running
                ? null
                : _chooseReportFormat,
            icon: const Icon(Icons.ios_share_rounded),
            label: const Text('Export run report'),
          ),
          if (_runError != null) ...[
            const SizedBox(height: 12),
            SelectableText(
              _runError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (_reportError != null) ...[
            const SizedBox(height: 8),
            SelectableText(
              _reportError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (_exchanges.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Request / response log',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (var index = 0; index < _exchanges.length; index++)
              _exchangeCard(context, index, _exchanges[index]),
          ],
        ],
      ),
    ),
  );

  Widget _exchangeCard(
    BuildContext context,
    int index,
    _PrepExchange exchange,
  ) {
    final color = _statusColor(context, exchange);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${exchange.label}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  _status(exchange),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  tooltip: 'Copy request and response',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _copyExchange(exchange),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (exchange.request != null)
              _bytesLine('TX', _requestText(exchange))
            else
              const Text('No request sent for this step.'),
            if (exchange.response != null)
              _bytesLine('RX', _hex(exchange.response!)),
            if (exchange.transportError != null)
              SelectableText(
                'Transport: ${exchange.transportError}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bytesLine(String direction, String bytes) => Padding(
    padding: const EdgeInsets.only(bottom: 3),
    child: SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$direction  ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: bytes),
        ],
      ),
      style: const TextStyle(fontFamily: 'monospace', height: 1.4),
    ),
  );
}
