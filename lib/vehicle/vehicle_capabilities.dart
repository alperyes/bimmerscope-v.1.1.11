import 'vehicle_identity.dart';

enum VehicleCapability {
  diagnostics,
  liveData,
  dataLogging,
  flapControl,
  calibrationRead,
  calibrationWrite,
  ecuIdentification,
  ecuDtcRead,
  ecuFreezeFrameRead,
  ecuSoftwareMetadataRead,
  ecuMemoryInventoryRead,
  ecuBackupEligible,
  offlinePackageInspection,
}

enum EcuFamily { mevd1724, mevd1726, mevd172g, edc17, md1, mg1, unknown }

enum ProfileConfidence { unknown, vehicleOnly, familyMatch, exact }

class EcuIdentity {
  const EcuIdentity({
    required this.name,
    required this.family,
    this.boschHardware,
    this.bmwHardware,
    this.softwareId,
    this.calibrationId,
    this.bootloaderId,
    this.associatedVin,
  });

  final String name;
  final EcuFamily family;
  final String? boschHardware;
  final String? bmwHardware;
  final String? softwareId;
  final String? calibrationId;
  final String? bootloaderId;
  final String? associatedVin;
}

class EcuFingerprint {
  const EcuFingerprint({
    required this.vin,
    required this.identity,
    this.boschHardware,
    this.bmwHardware,
    this.softwareId,
    this.calibrationId,
    this.bootloaderId,
    this.verified = false,
  });

  final String vin;
  final String identity;
  final String? boschHardware;
  final String? bmwHardware;
  final String? softwareId;
  final String? calibrationId;
  final String? bootloaderId;
  final bool verified;

  bool get complete =>
      vin.isNotEmpty &&
      identity.isNotEmpty &&
      boschHardware?.isNotEmpty == true &&
      bmwHardware?.isNotEmpty == true &&
      softwareId?.isNotEmpty == true &&
      calibrationId?.isNotEmpty == true &&
      bootloaderId?.isNotEmpty == true &&
      verified;
}

class ResolvedEcuProfile {
  const ResolvedEcuProfile({
    required this.vehicle,
    required this.fingerprint,
    required this.capabilities,
    required this.confidence,
  });

  final VehicleProfile vehicle;
  final EcuFingerprint fingerprint;
  final Set<VehicleCapability> capabilities;
  final ProfileConfidence confidence;

  bool supports(VehicleCapability capability) =>
      capabilities.contains(capability);
}

class VehicleProfile {
  const VehicleProfile({
    required this.id,
    required this.label,
    required this.chassis,
    required this.engines,
    required this.capabilities,
    required this.ecu,
    required this.confidence,
  });

  final String id;
  final String label;
  final String chassis;
  final List<String> engines;
  final Set<VehicleCapability> capabilities;
  final EcuIdentity? ecu;
  final ProfileConfidence confidence;

  bool supports(VehicleCapability capability) =>
      capabilities.contains(capability);
}

const _readOnly = {
  VehicleCapability.diagnostics,
  VehicleCapability.liveData,
  VehicleCapability.dataLogging,
  VehicleCapability.ecuIdentification,
  VehicleCapability.ecuDtcRead,
  VehicleCapability.ecuFreezeFrameRead,
  VehicleCapability.ecuSoftwareMetadataRead,
};

const _f82S55Capabilities = {
  ..._readOnly,
  VehicleCapability.flapControl,
  VehicleCapability.calibrationRead,
};

const _readOnlyCalibrationReview = {
  ..._readOnly,
  VehicleCapability.calibrationRead,
};

const vehicleProfiles = <VehicleProfile>[
  VehicleProfile(
    id: 'f82-s55',
    label: 'F82 M4 · S55',
    chassis: 'F82',
    engines: ['S55'],
    capabilities: _f82S55Capabilities,
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.mevd172g),
    confidence: ProfileConfidence.familyMatch,
  ),
  VehicleProfile(
    id: 'f-series-n55',
    label: 'F-series · N55',
    chassis: 'F-series',
    engines: ['N55'],
    capabilities: {..._readOnly, VehicleCapability.calibrationRead},
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.mevd1726),
    confidence: ProfileConfidence.familyMatch,
  ),
  VehicleProfile(
    id: 'f-series-n13',
    label: 'F-series · N13',
    chassis: 'F-series',
    engines: ['N13'],
    capabilities: _readOnlyCalibrationReview,
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.mevd1724),
    confidence: ProfileConfidence.familyMatch,
  ),
  VehicleProfile(
    id: 'f-series-n20',
    label: 'F-series · N20',
    chassis: 'F-series',
    engines: ['N20'],
    capabilities: _readOnlyCalibrationReview,
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.mevd1724),
    confidence: ProfileConfidence.familyMatch,
  ),
  VehicleProfile(
    id: 'g-series-b48',
    label: 'G-series · B48',
    chassis: 'G-series',
    engines: ['B48'],
    capabilities: _readOnlyCalibrationReview,
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.mg1),
    confidence: ProfileConfidence.familyMatch,
  ),
  VehicleProfile(
    id: 'g-series-b58',
    label: 'G-series · B58',
    chassis: 'G-series',
    engines: ['B58'],
    capabilities: _readOnlyCalibrationReview,
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.mg1),
    confidence: ProfileConfidence.familyMatch,
  ),
  VehicleProfile(
    id: 'g-series-s58',
    label: 'G-series · S58',
    chassis: 'G-series',
    engines: ['S58'],
    capabilities: _readOnlyCalibrationReview,
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.md1),
    confidence: ProfileConfidence.familyMatch,
  ),
];

extension VehicleIdentityCapabilities on VehicleIdentity {
  VehicleProfile get profile => profileFor(this);
}

ResolvedEcuProfile resolveEcuProfile({
  required VehicleIdentity identity,
  required String vehicleVin,
  required EcuFingerprint fingerprint,
}) {
  final vehicle = profileFor(identity);
  final familyMatches =
      vehicle.ecu != null &&
      _identityMatchesFamily(fingerprint.identity, vehicle.ecu!.family);
  final vinMatches =
      _normalizeVin(vehicleVin).isNotEmpty &&
      _normalizeVin(fingerprint.vin) == _normalizeVin(vehicleVin);
  final exact = familyMatches && vinMatches && fingerprint.complete;
  final capabilities = <VehicleCapability>{...vehicle.capabilities};
  if (!exact) {
    // A family match alone is useful for read-only diagnostics, but a stale
    // or cross-vehicle ECU fingerprint must not grant calibration access.
    capabilities.remove(VehicleCapability.calibrationRead);
  }
  if (exact) {
    capabilities.addAll({
      VehicleCapability.ecuMemoryInventoryRead,
      VehicleCapability.offlinePackageInspection,
    });
  }
  return ResolvedEcuProfile(
    vehicle: vehicle,
    fingerprint: fingerprint,
    capabilities: capabilities,
    confidence: exact
        ? ProfileConfidence.exact
        : familyMatches
        ? ProfileConfidence.familyMatch
        : ProfileConfidence.unknown,
  );
}

String _normalizeVin(String value) =>
    value.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

bool _identityMatchesFamily(String ecuIdentity, EcuFamily family) {
  final normalized = ecuIdentity.toUpperCase().replaceAll(
    RegExp(r'[^A-Z0-9]'),
    '',
  );
  return switch (family) {
    EcuFamily.mevd1724 => normalized.contains('MEVD1724'),
    EcuFamily.mevd1726 => normalized.contains('MEVD1726'),
    EcuFamily.mevd172g => normalized.contains('MEVD172G'),
    EcuFamily.edc17 => normalized.contains('EDC17'),
    EcuFamily.md1 => normalized.contains('MD1'),
    EcuFamily.mg1 => normalized.contains('MG1'),
    EcuFamily.unknown => false,
  };
}

VehicleProfile profileFor(VehicleIdentity identity) {
  for (final profile in vehicleProfiles) {
    if (profile.chassis == identity.chassis &&
        (profile.engines.isEmpty ||
            profile.engines.contains(identity.engine))) {
      return profile;
    }
  }
  return const VehicleProfile(
    id: 'unsupported-f-series',
    label: 'Unsupported F-series profile',
    chassis: 'F-series',
    engines: [],
    capabilities: _readOnly,
    ecu: null,
    confidence: ProfileConfidence.unknown,
  );
}
