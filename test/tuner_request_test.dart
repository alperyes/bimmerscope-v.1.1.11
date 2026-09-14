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
      fuel: '98 RON',
      hardware: 'Stock turbos · intake',
    );

    final restored = TunerRequest.fromJson(original.toJson());
    expect(restored.id, original.id);
    expect(restored.vin, original.vin);
    expect(restored.status, original.status);
    expect(restored.logFiles, original.logFiles);
    expect(restored.fuel, original.fuel);
    expect(restored.hardware, original.hardware);
    expect(restored.timeline, hasLength(1));
    expect(restored.timeline.single.action, 'Request created');
  });

  test('records a clear local sent transition', () {
    final request = TunerRequest(
      id: 'request_2',
      vin: 'VIN',
      vehicleLabel: 'BMW F82 M4',
      modifications: '',
      stockFileName: null,
      logFiles: const [],
      status: TunerRequestStatus.readyToSend,
      createdAt: DateTime.utc(2026, 9, 1),
    );
    final sent = request.markSent(at: DateTime.utc(2026, 9, 2));
    expect(sent.status, TunerRequestStatus.sent);
    expect(sent.revision, 2);
    expect(sent.timeline.map((event) => event.action), [
      'Request created',
      'Marked as sent',
    ]);
    expect(sent.timeline.last.detail, contains('delivery is not confirmed'));
  });

  test('defaults incomplete requests to a safe draft', () {
    final restored = TunerRequest.fromJson(const {'vin': 'VIN'});
    expect(restored.vin, 'VIN');
    expect(restored.status, TunerRequestStatus.draft);
    expect(restored.modifications, isEmpty);
    expect(restored.fuel, isEmpty);
    expect(restored.hardware, isEmpty);
  });
}
