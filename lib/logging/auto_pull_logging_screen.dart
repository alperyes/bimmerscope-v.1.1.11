import 'package:flutter/material.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/connection_status_chip.dart';

class AutoPullLoggingScreen extends StatefulWidget {
  const AutoPullLoggingScreen({
    super.key,
    required this.isDark,
    required this.connectionLabel,
    required this.isConnected,
    required this.canConfigure,
    required this.enabled,
    required this.threshold,
    required this.releaseDelaySeconds,
    required this.onEnabledChanged,
    required this.onThresholdChanged,
    required this.onReleaseDelayChanged,
  });

  final bool isDark;
  final String connectionLabel;
  final bool isConnected;
  final bool canConfigure;
  final bool enabled;
  final double threshold;
  final int releaseDelaySeconds;
  final Future<bool> Function(bool enabled) onEnabledChanged;
  final Future<void> Function(double threshold) onThresholdChanged;
  final Future<void> Function(int seconds) onReleaseDelayChanged;

  @override
  State<AutoPullLoggingScreen> createState() => _AutoPullLoggingScreenState();
}

class _AutoPullLoggingScreenState extends State<AutoPullLoggingScreen> {
  late bool enabled = widget.enabled;
  late double threshold = widget.threshold;
  late int releaseDelaySeconds = widget.releaseDelaySeconds;

  Future<void> setEnabled(bool value) async {
    final applied = await widget.onEnabledChanged(value);
    if (mounted && applied) setState(() => enabled = value);
  }

  void setThreshold(double value) {
    setState(() => threshold = value);
  }

  void setReleaseDelay(double value) {
    final seconds = value.round();
    setState(() => releaseDelaySeconds = seconds);
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.canConfigure
        ? 'Starts and stops a log using the throttle settings below.'
        : widget.isConnected
        ? 'Start live monitoring to enable automatic logging.'
        : 'Connect and start live monitoring to enable automatic logging.';
    return Scaffold(
      backgroundColor: AppPalette.background(widget.isDark),
      appBar: AppBar(
        title: const Text('Automatic pull logging'),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: ConnectionStatusChip(
                label: widget.connectionLabel,
                isDark: widget.isDark,
                iconOnly: true,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.surface(widget.isDark),
              borderRadius: BorderRadius.circular(appCardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Automatic pull logging',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(detail),
                  value: enabled,
                  onChanged: widget.canConfigure ? setEnabled : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Start at ${threshold.round()}% throttle',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Slider(
                  value: threshold,
                  min: 30,
                  max: 95,
                  divisions: 13,
                  label: '${threshold.round()}%',
                  onChanged: setThreshold,
                  onChangeEnd: widget.onThresholdChanged,
                ),
                const SizedBox(height: 12),
                Text(
                  'Stop ${releaseDelaySeconds}s after throttle release',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Slider(
                  value: releaseDelaySeconds.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '${releaseDelaySeconds}s',
                  onChanged: setReleaseDelay,
                  onChangeEnd: (value) =>
                      widget.onReleaseDelayChanged(value.round()),
                ),
                Text(
                  'Release means throttle falls below ${(threshold * .5).round()}%. Settings can be changed before connecting.',
                  style: TextStyle(
                    color: AppPalette.secondary(widget.isDark),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.blue.withValues(
                alpha: widget.isDark ? .12 : .07,
              ),
              borderRadius: BorderRadius.circular(appCardRadius),
            ),
            child: const Text(
              'Automatic logging requires a live vehicle connection and live monitoring. Logs are saved with the same data and session details as a manual recording.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
