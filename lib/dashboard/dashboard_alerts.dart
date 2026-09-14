import 'package:bmw_app/src/rust/api/vehicle.dart';

class DashboardGaugeAlert {
  const DashboardGaugeAlert({
    required this.sensor,
    required this.value,
    required this.danger,
  });

  final SensorDefinition sensor;
  final double value;
  final bool danger;
}

List<DashboardGaugeAlert> activeDashboardGaugeAlerts({
  required Iterable<String> visibleSensorIds,
  required Map<String, SensorDefinition> sensorsById,
  required Map<String, double> values,
}) {
  final alerts = <DashboardGaugeAlert>[];
  for (final id in visibleSensorIds) {
    final sensor = sensorsById[id];
    final value = values[id];
    if (sensor == null || value == null || !value.isFinite) continue;
    if (sensor.warning == 0 && sensor.danger == 0) continue;
    final dangerLow = sensor.danger < sensor.warning;
    final isDanger = dangerLow
        ? value <= sensor.danger
        : value >= sensor.danger;
    final isWarning = dangerLow
        ? value <= sensor.warning
        : value >= sensor.warning;
    if (isWarning) {
      alerts.add(
        DashboardGaugeAlert(sensor: sensor, value: value, danger: isDanger),
      );
    }
  }
  alerts.sort((a, b) {
    if (a.danger != b.danger) return a.danger ? -1 : 1;
    return a.sensor.label.compareTo(b.sensor.label);
  });
  return alerts;
}
