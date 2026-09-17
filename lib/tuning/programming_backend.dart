import 'calibration_write_service.dart';

/// Describes a programming implementation without implying that it is safe
/// or validated for any particular ECU. A future S55 adapter must provide
/// evidence for every field before it can be enabled in production.
class ProgrammingBackendDescriptor {
  const ProgrammingBackendDescriptor({
    required this.id,
    required this.displayName,
    required this.ecuFamily,
    required this.transport,
    required this.validatedSoftwareIds,
    required this.benchOnly,
    required this.validated,
  });

  final String id;
  final String displayName;
  final String ecuFamily;
  final String transport;
  final Set<String> validatedSoftwareIds;
  final bool benchOnly;
  final bool validated;
}

/// A deterministic backend for developing the transaction pipeline.
///
/// This intentionally simulates stages only. It does not accept raw ECU
/// frames, derive security keys, modify files, or connect to a vehicle.
class SimulatedProgrammingBackend implements CalibrationWriteBackend {
  SimulatedProgrammingBackend({
    this.failAt,
    this.descriptor = const ProgrammingBackendDescriptor(
      id: 'simulated-programming-backend',
      displayName: 'BimmerScope simulated backend',
      ecuFamily: 'test-fixture',
      transport: 'simulator',
      validatedSoftwareIds: <String>{'SIMULATED'},
      benchOnly: true,
      validated: false,
    ),
  });

  final CalibrationWriteStage? failAt;
  final ProgrammingBackendDescriptor descriptor;

  @override
  Future<void> execute(
    CalibrationWriteRequest request,
    void Function(CalibrationWriteJournalEntry entry) record,
  ) async {
    final stages = <CalibrationWriteStage>[
      CalibrationWriteStage.backup,
      CalibrationWriteStage.identify,
      CalibrationWriteStage.compatibility,
      CalibrationWriteStage.programmingPreconditions,
      CalibrationWriteStage.prepareSession,
      CalibrationWriteStage.authenticate,
      CalibrationWriteStage.quiesceNetwork,
      CalibrationWriteStage.erase,
      CalibrationWriteStage.requestDownload,
      CalibrationWriteStage.transfer,
      CalibrationWriteStage.transferExit,
      CalibrationWriteStage.verify,
      CalibrationWriteStage.reset,
      CalibrationWriteStage.restoreNetwork,
      CalibrationWriteStage.complete,
    ];
    for (final stage in stages) {
      if (stage == failAt) {
        record(
          CalibrationWriteJournalEntry(
            stage: CalibrationWriteStage.failed,
            message: 'Simulation stopped at ${stage.name}',
            at: DateTime.now().toUtc(),
          ),
        );
        return;
      }
      record(
        CalibrationWriteJournalEntry(
          stage: stage,
          message: 'Simulation: ${stage.name} (no ECU access)',
          at: DateTime.now().toUtc(),
        ),
      );
    }
  }
}
