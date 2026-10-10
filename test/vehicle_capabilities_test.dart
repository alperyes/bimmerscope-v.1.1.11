import 'package:bmw_app/vehicle/vehicle_capabilities.dart';
import 'package:bmw_app/vehicle/vehicle_identity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const identity = VehicleIdentity(
    chassis: 'F82',
    model: 'M4',
    engine: 'S55',
    transmission: 'DCT',
    modelYear: 2014,
  );
  const vin = 'WBS3R9200E0000000';

  EcuFingerprint fingerprint({String fingerprintVin = vin}) => EcuFingerprint(
    vin: fingerprintVin,
    identity: 'MEVD17.2.G',
    boschHardware: '0261S0',
    bmwHardware: '1234567',
    softwareId: 'SW1',
    calibrationId: 'CAL1',
    bootloaderId: 'BOOT1',
    verified: true,
  );

  test(
    'grants exact-only inspection capability for matching VIN and S55 DME',
    () {
      final resolved = resolveEcuProfile(
        identity: identity,
        vehicleVin: vin,
        fingerprint: fingerprint(),
      );

      expect(resolved.confidence, ProfileConfidence.exact);
      expect(resolved.supports(VehicleCapability.calibrationRead), isTrue);
      expect(
        resolved.supports(VehicleCapability.ecuMemoryInventoryRead),
        isTrue,
      );
      expect(
        resolved.supports(VehicleCapability.offlinePackageInspection),
        isTrue,
      );
    },
  );

  test('does not grant calibration access to a cross-vehicle fingerprint', () {
    final resolved = resolveEcuProfile(
      identity: identity,
      vehicleVin: vin,
      fingerprint: fingerprint(fingerprintVin: 'WBS3R9200E0000001'),
    );

    expect(resolved.confidence, ProfileConfidence.familyMatch);
    expect(resolved.supports(VehicleCapability.calibrationRead), isFalse);
    expect(
      resolved.supports(VehicleCapability.ecuMemoryInventoryRead),
      isFalse,
    );
  });

  test('enables flap control for F30 328i but not F30 320i', () {
    final f30_328i = identifyVehicle('WBA3A53010F360747')!;
    final f30_320i = identifyVehicle('WBA3B10010F360747')!;

    expect(f30_328i.profile.supports(VehicleCapability.flapControl), isTrue);
    expect(f30_320i.profile.supports(VehicleCapability.flapControl), isFalse);
  });

  test('assigns the F22 228i its F-series N20 profile', () {
    final f22_228i = identifyVehicle('WBA1F5100E0000000')!;
    final profile = f22_228i.profile;

    expect(profile.id, 'f22-f-series-n20');
    expect(profile.chassis, 'F22');
    expect(profile.ecu?.family, EcuFamily.mevd1724);
    expect(profile.supports(VehicleCapability.diagnostics), isTrue);
    expect(profile.supports(VehicleCapability.flapControl), isFalse);
  });
}
