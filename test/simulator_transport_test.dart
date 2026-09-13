import 'package:bmw_app/vehicle/simulator_transport.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts supported simulator DME states', () {
    expect(parseSimulatorDmeUnlockStatus('unknown'), 'unknown');
    expect(parseSimulatorDmeUnlockStatus('Unlocked'), 'unlocked');
    expect(parseSimulatorDmeUnlockStatus('locked'), 'locked');
    expect(parseSimulatorDmeUnlockStatus('bench_unlock_required'), 'bench_unlock_required');
  });

  test('rejects malformed simulator DME states', () {
    expect(parseSimulatorDmeUnlockStatus('guess'), isNull);
    expect(parseSimulatorDmeUnlockStatus(null), isNull);
  });
}
