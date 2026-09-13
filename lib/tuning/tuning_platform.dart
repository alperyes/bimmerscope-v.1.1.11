import 'package:bmw_app/vehicle/vehicle_capabilities.dart';

enum TuningTrackStatus { active, readOnly, planned }

/// Engine-family scope for the tuning workbench. A track can be visible in
/// the product UI without being allowed to create a vehicle package; package
/// creation remains an explicit, profile-gated capability.
class TuningEngineTrack {
  const TuningEngineTrack({
    required this.engine,
    required this.label,
    required this.ecuFamily,
    required this.status,
    required this.productLabel,
    required this.detail,
  });

  final String engine;
  final String label;
  final EcuFamily ecuFamily;
  final TuningTrackStatus status;
  final String productLabel;
  final String detail;

  bool get packagePreparationEnabled => status == TuningTrackStatus.active;

  String get statusLabel => switch (status) {
    TuningTrackStatus.active => 'Active track',
    TuningTrackStatus.readOnly => 'Read-only groundwork',
    TuningTrackStatus.planned => 'Planned',
  };
}

const tuningEngineTracks = <TuningEngineTrack>[
  TuningEngineTrack(
    engine: 'N13',
    label: 'N13',
    ecuFamily: EcuFamily.mevd1724,
    status: TuningTrackStatus.readOnly,
    productLabel: 'N13 remap',
    detail: 'Identity, diagnostics, and compatibility capture first.',
  ),
  TuningEngineTrack(
    engine: 'N20',
    label: 'N20',
    ecuFamily: EcuFamily.mevd1724,
    status: TuningTrackStatus.readOnly,
    productLabel: 'N20 remap',
    detail: 'Identity, diagnostics, and compatibility capture first.',
  ),
  TuningEngineTrack(
    engine: 'N55',
    label: 'N55',
    ecuFamily: EcuFamily.mevd1726,
    status: TuningTrackStatus.readOnly,
    productLabel: 'N55 remap',
    detail: 'Profile expansion is waiting for validated ECU evidence.',
  ),
  TuningEngineTrack(
    engine: 'S55',
    label: 'S55',
    ecuFamily: EcuFamily.mevd172g,
    status: TuningTrackStatus.active,
    productLabel: 'S55 remap',
    detail: 'Competition and CS package preparation for the confirmed F82 DCT.',
  ),
  TuningEngineTrack(
    engine: 'B48',
    label: 'B48',
    ecuFamily: EcuFamily.mg1,
    status: TuningTrackStatus.readOnly,
    productLabel: 'B48 remap',
    detail: 'Identity and software-family collection is scaffolded.',
  ),
  TuningEngineTrack(
    engine: 'B58',
    label: 'B58',
    ecuFamily: EcuFamily.mg1,
    status: TuningTrackStatus.readOnly,
    productLabel: 'B58 remap',
    detail: 'Identity and software-family collection is scaffolded.',
  ),
  TuningEngineTrack(
    engine: 'S58',
    label: 'S58',
    ecuFamily: EcuFamily.md1,
    status: TuningTrackStatus.readOnly,
    productLabel: 'S58 remap',
    detail: 'Identity and software-family collection is scaffolded.',
  ),
];

TuningEngineTrack? tuningTrackForEngine(String? engine) {
  if (engine == null) return null;
  for (final track in tuningEngineTracks) {
    if (track.engine == engine.toUpperCase()) return track;
  }
  return null;
}
