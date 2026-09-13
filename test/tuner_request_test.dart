import 'package:bmw_app/tuning/tuner_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('round-trips a tuner request through JSON', () {
    final original = TunerRequest(
      id: 'request_1',
      vin: 'DEMOF82S55MOBILE',
      vehicleLabel: 'BMW F82 M4 · 2015',
      modifications: 'Catless downpipes',
      stockFileName: 'stock.bin',
      logFiles: const ['pull.csv'],
      status: TunerRequestStatus.readyToSend,
      createdAt: DateTime.utc(2026, 9, 5),
    );

    final restored = TunerRequest.fromJson(original.toJson());
    expect(restored.id, original.id);
    expect(restored.vin, original.vin);
    expect(restored.status, original.status);
    expect(restored.logFiles, original.logFiles);
  });

  test('defaults incomplete requests to a safe draft', () {
    final restored = TunerRequest.fromJson(const {'vin': 'VIN'});
    expect(restored.vin, 'VIN');
    expect(restored.status, TunerRequestStatus.draft);
    expect(restored.modifications, isEmpty);
  });
}
