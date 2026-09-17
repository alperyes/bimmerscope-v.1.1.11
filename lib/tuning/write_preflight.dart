import '../vehicle/vehicle_capabilities.dart';

/// Exact comparison of recorded identifiers; family names alone are not enough.
bool matchingWriteFingerprint(EcuFingerprint a, EcuFingerprint b) =>
    a.complete &&
    b.complete &&
    a.vin.trim().toUpperCase() == b.vin.trim().toUpperCase() &&
    a.identity == b.identity &&
    a.boschHardware == b.boschHardware &&
    a.bmwHardware == b.bmwHardware &&
    a.softwareId == b.softwareId &&
    a.calibrationId == b.calibrationId &&
    a.bootloaderId == b.bootloaderId;

/// Evidence required before a programming backend may be called.
///
/// This is deliberately separate from [VehicleCapability.calibrationWrite].
/// A profile can describe a future capability while a particular session still
/// lacks the evidence needed to use it.
class WritePreflight {
  const WritePreflight({
    required this.profile,
    required this.sessionVin,
    required this.ecuFingerprint,
    required this.transport,
    required this.externalPowerStable,
    required this.ignitionReady,
    required this.immutableBackupHash,
    required this.packageSignatureVerified,
    required this.recoveryProcedureVerified,
    required this.backendValidated,
  });

  final ResolvedEcuProfile? profile;
  final String sessionVin;
  final EcuFingerprint? ecuFingerprint;
  final String? transport;
  final bool externalPowerStable;
  final bool ignitionReady;
  final String? immutableBackupHash;
  final bool packageSignatureVerified;
  final bool recoveryProcedureVerified;
  final bool backendValidated;

  List<String> get blockingReasons {
    final reasons = <String>[];
    final resolved = profile;
    if (resolved == null) reasons.add('No active ECU profile');
    if (resolved != null &&
        !resolved.supports(VehicleCapability.calibrationWrite)) {
      reasons.add('Calibration writing is not supported for this profile');
    }
    final fingerprint = ecuFingerprint;
    if (resolved != null &&
        (resolved.confidence != ProfileConfidence.exact ||
            fingerprint == null ||
            !matchingWriteFingerprint(resolved.fingerprint, fingerprint))) {
      reasons.add('Exact profile fingerprint must match the session evidence');
    }
    if (fingerprint == null || !fingerprint.complete) {
      reasons.add('Complete verified ECU fingerprint is required');
    }
    if (sessionVin.trim().isEmpty ||
        fingerprint == null ||
        sessionVin.trim().toUpperCase() !=
            fingerprint.vin.trim().toUpperCase()) {
      reasons.add('Session VIN must match the ECU fingerprint');
    }
    if (transport != 'wired_enet') {
      reasons.add('A validated wired ENET transport is required');
    }
    if (!externalPowerStable) reasons.add('Stable external power is required');
    if (!ignitionReady) reasons.add('Ignition and vehicle state are not ready');
    if (immutableBackupHash == null || immutableBackupHash!.isEmpty) {
      reasons.add('An immutable verified backup is required');
    }
    if (!packageSignatureVerified) {
      reasons.add('A verified package signature is required');
    }
    if (!recoveryProcedureVerified) {
      reasons.add('Bench recovery evidence is required');
    }
    if (!backendValidated) {
      reasons.add('No validated programming backend is available');
    }
    return List.unmodifiable(reasons);
  }

  bool get allowed => blockingReasons.isEmpty;
}
