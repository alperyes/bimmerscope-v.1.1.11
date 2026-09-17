class LogHealthFinding {
  const LogHealthFinding({required this.channel, required this.message, required this.severity});
  final String channel;
  final String message;
  final LogFindingSeverity severity;
}

enum LogFindingSeverity { info, caution, warning }

/// Lightweight, intentionally conservative checks for replayed logs.
/// Thresholds are not vehicle-specific and must never be presented as a tune.
List<LogHealthFinding> analyzeLog(Map<String, List<double>> channels) {
  final findings = <LogHealthFinding>[];
  for (final entry in channels.entries) {
    final name = entry.key.toLowerCase();
    final values = entry.value.where((value) => value.isFinite).toList();
    if (values.isEmpty) continue;
    final maximum = values.reduce((a, b) => a > b ? a : b);
    final minimum = values.reduce((a, b) => a < b ? a : b);
    if (name.contains('coolant') && maximum > 115) {
      findings.add(LogHealthFinding(channel: entry.key, message: 'Coolant temperature reached ${maximum.toStringAsFixed(1)}°C.', severity: LogFindingSeverity.warning));
    } else if (name.contains('oil') && maximum > 130) {
      findings.add(LogHealthFinding(channel: entry.key, message: 'Oil temperature reached ${maximum.toStringAsFixed(1)}°C.', severity: LogFindingSeverity.caution));
    } else if (name.contains('lambda') && (minimum < 0.75 || maximum > 1.25)) {
      findings.add(LogHealthFinding(channel: entry.key, message: 'Lambda moved outside the conservative review range.', severity: LogFindingSeverity.caution));
    } else if (name.contains('boost') || name.contains('charge pressure')) {
      final psi = name.contains('psi');
      final threshold = psi ? 30.0 : 3.5;
      if (maximum <= threshold) continue;
      findings.add(LogHealthFinding(channel: entry.key, message: 'Boost channel reached an unusually high value; verify units and sensor definition.', severity: LogFindingSeverity.info));
    }
  }
  return findings;
}
