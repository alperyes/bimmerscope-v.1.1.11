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
    required this.onSetMode,
    required this.autoApply,
    required this.onAutoApplyChanged,
  });
  final bool isDark;
  final ValueListenable<String> connectionStatus;
  final String initialMode;
  final Future<void> Function(String mode) onSetMode;
  final bool autoApply;
  final ValueChanged<bool> onAutoApplyChanged;

  @override
  State<FlapControlScreen> createState() => _FlapControlScreenState();
}

class _FlapControlScreenState extends State<FlapControlScreen> {
  late String mode = widget.initialMode == 'open'
      ? 'open_periodic'
      : widget.initialMode;
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

  bool get _controlsEnabled => const {
    'connected',
    'monitoring',
  }.contains(widget.connectionStatus.value.trim().toLowerCase());

  @override
  Widget build(BuildContext context) {
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
                    iconOnly: true,
                  ),
                ),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final landscape = constraints.maxWidth > constraints.maxHeight;
              final controls = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _positionButton(
                    'open_legacy',
                    'Open · BimmerScope 0A FF · repeats',
                    Icons.arrow_upward_rounded,
                  ),
                  const SizedBox(height: 10),
                  _positionButton(
                    'open_periodic',
                    'Open · BimmerScope FA FF · repeats',
                    Icons.arrow_upward_rounded,
                  ),
                  const SizedBox(height: 10),
                  _positionButton(
                    'open_bm3',
                    'Open · BM3 FA FF · once',
                    Icons.arrow_upward_rounded,
                  ),
                  const SizedBox(height: 10),
                  _positionButton('auto', 'Auto', Icons.autorenew_rounded),
                  const SizedBox(height: 10),
                  _positionButton(
                    'closed',
                    'Close',
                    Icons.arrow_downward_rounded,
                  ),
                ],
              );

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      landscape ? 16 : 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Auto-apply saved setting',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      mode == 'open_bm3'
                                          ? 'One-shot mode is never auto-applied on connect'
                                          : widget.autoApply
                                          ? 'Apply ${mode.startsWith('open')
                                                ? 'Open'
                                                : mode == 'closed'
                                                ? 'Closed'
                                                : 'Auto'} when this VIN connects'
                                          : 'Saved setting is not applied on connect',
                                      style: TextStyle(
                                        color: AppPalette.secondary(
                                          widget.isDark,
                                        ),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Switch.adaptive(
                                value: widget.autoApply,
                                onChanged:
                                    _controlsEnabled && mode != 'open_bm3'
                                    ? widget.onAutoApplyChanged
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        controls,
                      ],
                    ),
                  ),
                ),
              );
            },
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
        Icon(icon, size: compact ? 24 : 30),
        SizedBox(width: compact ? 9 : 12),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 18 : 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(compact ? 72 : 84)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: compact ? 12 : 20, vertical: 16),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: selected
              ? value.startsWith('open')
                    ? AppPalette.orange
                    : value == 'closed'
                    ? AppPalette.red
                    : AppPalette.blue
              : AppPalette.separator(widget.isDark).withValues(alpha: .75),
          width: 1,
        ),
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: 'Flap position $label',
      child: selected
          ? FilledButton(
              onPressed: _controlsEnabled && !busy ? () => choose(value) : null,
              style: style.copyWith(
                backgroundColor: value.startsWith('open')
                    ? const WidgetStatePropertyAll(AppPalette.orange)
                    : value == 'closed'
                    ? const WidgetStatePropertyAll(AppPalette.red)
                    : const WidgetStatePropertyAll(AppPalette.blue),
                foregroundColor: WidgetStatePropertyAll(
                  value.startsWith('open')
                      ? const Color(0xFF211600)
                      : Colors.white,
                ),
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: _controlsEnabled && !busy ? () => choose(value) : null,
              style: style,
              child: child,
            ),
    );
  }
}
