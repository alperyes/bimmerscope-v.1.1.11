import 'package:flutter/material.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/connection_status_chip.dart';

class AutoPullLoggingScreen extends StatelessWidget {
  const AutoPullLoggingScreen({
    super.key,
    required this.isDark,
    required this.connectionLabel,
    required this.isConnected,
    required this.canConfigure,
    required this.enabled,
    required this.threshold,
    required this.onEnabledChanged,
    required this.onThresholdChanged,
  });

  final bool isDark;
  final String connectionLabel;
  final bool isConnected;
  final bool canConfigure;
  final bool enabled;
  final double threshold;
  final Future<void> Function(bool enabled) onEnabledChanged;
  final Future<void> Function(double threshold) onThresholdChanged;

  @override
  Widget build(BuildContext context) {
    final detail = canConfigure
        ? 'Starts a log when throttle reaches the selected level and stops shortly after you release.'
        : isConnected
        ? 'Start live monitoring to configure and use automatic pull logging.'
        : 'Connect and start live monitoring to configure and use automatic pull logging.';
    return Scaffold(
      backgroundColor: AppPalette.background(isDark),
      appBar: AppBar(
        title: const Text('Automatic pull logging'),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: ConnectionStatusChip(
                label: connectionLabel,
                isDark: isDark,
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
              color: AppPalette.surface(isDark),
              borderRadius: BorderRadius.circular(appCardRadius),
              border: Border.all(
                color: AppPalette.separator(isDark).withValues(alpha: .45),
              ),
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
                  onChanged: canConfigure ? onEnabledChanged : null,
                ),
                if (enabled) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Start threshold: ${threshold.round()}% throttle',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Slider(
                    value: threshold,
                    min: 30,
                    max: 95,
                    divisions: 13,
                    label: '${threshold.round()}%',
                    onChanged: canConfigure ? onThresholdChanged : null,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.blue.withValues(alpha: isDark ? .12 : .07),
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
