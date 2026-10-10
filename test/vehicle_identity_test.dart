import 'package:bmw_app/vehicle/vehicle_identity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('identifies the WBS3R92 F82 M4 profile locally', () {
    final identity = identifyVehicle('WBS3R9200E0000000');

    expect(identity?.chassis, 'F82');
    expect(identity?.model, 'M4');
    expect(identity?.engine, 'S55');
    expect(identity?.transmission, 'DCT');
    expect(identity?.modelYear, 2014);
    expect(identity?.displayLabel, 'BMW F82 M4 · 2014');
  });

  test('does not claim an unsupported identity from an unknown VIN', () {
    final identity = identifyVehicle('WBA000000F0000000');

    expect(identity, isNull);
  });

  test('decodes F30 N20 328i and 320i variants from the VIN type key', () {
    final flapVehicle = identifyVehicle('WBA3A53010F360747');
    final noFlapVehicle = identifyVehicle('WBA3B10010F360747');

    expect(flapVehicle?.chassis, 'F30');
    expect(flapVehicle?.model, '328i');
    expect(flapVehicle?.engine, 'N20');
    expect(noFlapVehicle?.chassis, 'F30');
    expect(noFlapVehicle?.model, '320i');
    expect(noFlapVehicle?.engine, 'N20');
  });

  test('decodes F22 228i N20 and N26 type keys from the F-series registry', () {
    final n20 = identifyVehicle('WBA1F5100E0000000');
    final n26 = identifyVehicle('WBA1F9300E0000000');

    expect(n20?.chassis, 'F22');
    expect(n20?.model, '228i');
    expect(n20?.engine, 'N20');
    expect(n20?.typeKey, '1F51');
    expect(n26?.chassis, 'F22');
    expect(n26?.model, '228i');
    expect(n26?.engine, 'N26');
    expect(n26?.typeKey, '1F93');
  });

  test('does not infer a vehicle from an unknown type key', () {
    expect(identifyVehicle('WBA8B5100E0000000'), isNull);
  });
}
