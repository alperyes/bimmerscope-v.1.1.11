import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/connection_status_chip.dart';

class FlapControlScreen extends StatefulWidget {
  const FlapControlScreen({
    super.key,
    required this.isDark,
    required this.connectionStatus,
    this.initialMode = 'auto',
    required this.onRunTest,
    required this.onSetMode,
    required this.autoApply,
    required this.onAutoApplyChanged,
  });
  final bool isDark;
  final ValueListenable<String> connectionStatus;
  final String initialMode;
  final Future<void> Function() onRunTest;
  final Future<void> Function(String mode) onSetMode;
  final bool autoApply;
  final ValueChanged<bool> onAutoApplyChanged;

  @override
  State<FlapControlScreen> createState() => _FlapControlScreenState();
}

class _FlapControlScreenState extends State<FlapControlScreen> {
  late String mode = widget.initialMode;
  bool busy = false;

  Future<void> choose(String value) async {
    if (busy || !_controlsEnabled) return;
    setState(() {
      busy = true;
    });
    var completed = false;
    try {
      await widget.onSetMode(value);
      completed = true;
    } finally {
      if (mounted) {
        setState(() {
          busy = false;
          if (completed) {
            mode = value;
          }
        });
      }
    }
  }

  Future<void> runTest() async {
    if (busy || !_controlsEnabled) return;
    setState(() => busy = true);
    try {
      await widget.onRunTest();
    } finally {
      if (mounted) {
        setState(() {
          busy = false;
        });
      }
    }
  }

  bool get _controlsEnabled => const {
    'connected',
    'monitoring',
  }.contains(widget.connectionStatus.value.trim().toLowerCase());

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final controls = landscape
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _positionButton(
                  'open',
                  'Open',
                  Icons.arrow_upward_rounded,
                  compact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _positionButton(
                  'auto',
                  'Auto',
                  Icons.autorenew_rounded,
                  compact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _positionButton(
                  'closed',
                  'Close',
                  Icons.arrow_downward_rounded,
                  compact: true,
                ),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _positionButton('open', 'Open', Icons.arrow_upward_rounded),
              const SizedBox(height: 10),
              _positionButton('auto', 'Auto', Icons.autorenew_rounded),
              const SizedBox(height: 10),
              _positionButton('closed', 'Close', Icons.arrow_downward_rounded),
            ],
          );

    return AnimatedBuilder(
      animation: widget.connectionStatus,
      builder: (context, _) {
        final connectionLabel = widget.connectionStatus.value;
        return Scaffold(
          backgroundColor: AppPalette.background(widget.isDark),
          appBar: AppBar(
            title: const Text('Exhaust flap'),
            backgroundColor: Colors.transparent,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Center(
                  child: ConnectionStatusChip(
                    label: connectionLabel,
                    isDark: widget.isDark,
                    compact: true,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, landscape ? 16 : 24),
            child: Column(
              children: [
                Expanded(child: Center(child: controls)),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Auto-apply saved setting'),
                  subtitle: Text(
                    widget.autoApply
                        ? 'Apply ${mode == 'open'
                              ? 'Open'
                              : mode == 'closed'
                              ? 'Closed'
                              : 'Auto'} when this VIN connects'
                        : 'Ask before changing the flap on connect',
                  ),
                  value: widget.autoApply,
                  onChanged: _controlsEnabled
                      ? widget.onAutoApplyChanged
                      : null,
                ),
                SizedBox(
                  height: landscape ? 46 : 52,
                  child: FilledButton.icon(
                    onPressed: busy || !_controlsEnabled ? null : runTest,
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.sync_rounded, size: 20),
                    label: const Text(
                      'Run cyclic service test',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _positionButton(
    String value,
    String label,
    IconData icon, {
    bool compact = false,
  }) {
    final selected = mode == value;
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
      ],
    );
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(compact ? 104 : 148)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
    return selected
        ? FilledButton(
            onPressed: _controlsEnabled && !busy ? () => choose(value) : null,
            style: style.copyWith(
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
            ),
            child: child,
          )
        : OutlinedButton(
            onPressed: _controlsEnabled && !busy ? () => choose(value) : null,
            style: style,
            child: child,
          );
  }
}
