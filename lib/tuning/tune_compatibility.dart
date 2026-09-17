import 'package:bmw_app/tuning/tune_product.dart';
import 'package:bmw_app/vehicle/vehicle_identity.dart';

/// Immutable evidence collected from a live, read-only DME identity session.
class TuneDmeEvidence {
  const TuneDmeEvidence({
    required this.connected,
    required this.detected,
    required this.identity,
    this.hardware,
    required this.software,
    required this.bootloader,
    required this.calibration,
    this.codingId,
    this.svk,
    this.serialNumber,
    this.sessionId,
    this.source,
    this.capturedAt,
  });

  final bool connected;
  final bool detected;
  final String? identity;
  final String? hardware;
  final String? software;
  final String? bootloader;
  final String? calibration;
  final String? codingId;
  final String? svk;
  final String? serialNumber;
  final String? sessionId;
  final String? source;
  final DateTime? capturedAt;

  /// The core identifiers that the S55 ISTA definition exposes for every
  /// supported software level. Physical hardware and supplier fields are
  /// useful corroboration, but are legitimately absent on some DME levels.
  bool get complete => [
    identity,
    software,
    bootloader,
    calibration,
  ].every((value) => value?.trim().isNotEmpty == true);

  bool get hasPhysicalHardware => hardware?.trim().isNotEmpty == true;

  Map<String, String?> toJson() => {
    'identity': identity,
    'hardware': hardware,
    'software': software,
    'bootloader': bootloader,
    'calibration': calibration,
    'coding_id': codingId,
    'svk': svk,
    'serial_number': serialNumber,
    'session_id': sessionId,
    'source': source,
    'captured_at': capturedAt?.toIso8601String(),
  };
}

enum TuneCompatibilityState { rejected, evidenceRequired, reviewReady }

class TuneCompatibilityReport {
  const TuneCompatibilityReport({
    required this.state,
    required this.reasons,
    required this.evidence,
    required this.vehicle,
    required this.product,
  });

  final TuneCompatibilityState state;
  final List<String> reasons;
  final TuneDmeEvidence evidence;
  final VehicleIdentity? vehicle;
  final TuneProduct product;

  bool get readyForProfessionalReview =>
      state == TuneCompatibilityState.reviewReady;

  /// Programming is intentionally not a capability of this prototype.
  bool get installableInBimmerScope => false;

  String get label => switch (state) {
    TuneCompatibilityState.rejected => 'Not compatible',
    TuneCompatibilityState.evidenceRequired => 'Evidence required',
    TuneCompatibilityState.reviewReady => 'Ready for professional review',
  };

  Map<String, dynamic> toJson() => {
    'state': state.name,
    'label': label,
    'reasons': reasons,
    'installable_in_bimmerscope': false,
    'vehicle': vehicle == null
        ? null
        : {
            'chassis': vehicle!.chassis,
            'engine': vehicle!.engine,
            'transmission': vehicle!.transmission,
          },
    'dme_evidence': evidence.toJson(),
  };
}

TuneCompatibilityReport assessTuneCompatibility({
  required VehicleIdentity? vehicle,
  required TuneProduct product,
  required TuneDmeEvidence evidence,
}) {
  final reasons = <String>[];
  if (!evidence.connected) {
    reasons.add('A live vehicle connection is required.');
  }
  if (vehicle == null) {
    reasons.add('The VIN does not resolve to a supported vehicle profile.');
  }
  if (vehicle != null && !product.matchesVehicle(vehicle)) {
    reasons.add('This product is limited to F82 S55 DCT fitment.');
  }
  if (!evidence.detected) {
    reasons.add('The engine DME was not identified on this session.');
  }
  if (evidence.identity?.toUpperCase().contains('MEVD17.2.G') != true) {
    reasons.add('The confirmed S55 MEVD17.2.G DME identity is required.');
  }
  if (!evidence.complete) {
    reasons.add(
      'DME identity, software, boot/startup, and calibration evidence is incomplete.',
    );
  }
  final rejected = vehicle != null && !product.matchesVehicle(vehicle);
  return TuneCompatibilityReport(
    state: rejected
        ? TuneCompatibilityState.rejected
        : reasons.isEmpty
        ? TuneCompatibilityState.reviewReady
        : TuneCompatibilityState.evidenceRequired,
    reasons: reasons.isEmpty
        ? const [
            'Exact DME evidence captured. A calibration provider must still approve a signed package.',
          ]
        : reasons,
    evidence: evidence,
    vehicle: vehicle,
    product: product,
  );
}
