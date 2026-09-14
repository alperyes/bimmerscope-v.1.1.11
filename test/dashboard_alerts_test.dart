import 'package:bmw_app/dashboard/dashboard_alerts.dart';
import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  SensorDefinition sensor({
    required String id,
    required double warning,
    required double danger,
  }) => SensorDefinition(
    id: id,
    label: id,
    did: 1,
    ecu: 1,
    size: 2,
    unit: 'u',
    minimum: 0,
    maximum: 100,
    warning: warning,
    danger: danger,
    decimals: 1,
    scale: 1,
    offset: 0,
  );

  test('prioritizes danger and supports high-side thresholds', () {
    final warning = sensor(id: 'warning', warning: 50, danger: 80);
    final danger = sensor(id: 'danger', warning: 50, danger: 80);
    final alerts = activeDashboardGaugeAlerts(
      visibleSensorIds: ['warning', 'danger'],
      sensorsById: {'warning': warning, 'danger': danger},
      values: {'warning': 55, 'danger': 85},
    );
    expect(alerts.map((alert) => alert.sensor.id), ['danger', 'warning']);
    expect(alerts.first.danger, isTrue);
  });

  test('supports low-side thresholds and ignores unset limits', () {
    final pressure = sensor(id: 'pressure', warning: 30, danger: 20);
    final unset = sensor(id: 'unset', warning: 0, danger: 0);
    final alerts = activeDashboardGaugeAlerts(
      visibleSensorIds: ['pressure', 'unset'],
      sensorsById: {'pressure': pressure, 'unset': unset},
      values: {'pressure': 18, 'unset': 50},
    );
    expect(alerts, hasLength(1));
    expect(alerts.single.sensor.id, 'pressure');
    expect(alerts.single.danger, isTrue);
  });
}
