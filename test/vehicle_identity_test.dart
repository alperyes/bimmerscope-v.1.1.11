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
}
