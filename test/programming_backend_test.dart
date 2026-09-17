import 'package:bmw_app/tuning/calibration_write_service.dart';
import 'package:bmw_app/tuning/programming_backend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const request = CalibrationWriteRequest(
    vin: 'WBS00000000000000',
    ecuFingerprint: 'SIMULATED',
    packageHash: 'package',
    backupHash: 'backup',
  );

  test('simulated backend journals the complete staged transaction', () async {
    final entries = <CalibrationWriteJournalEntry>[];
    await SimulatedProgrammingBackend().execute(request, entries.add);

    expect(entries.map((entry) => entry.stage), [
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
    ]);
    expect(
      entries.every((entry) => entry.message.contains('no ECU access')),
      isTrue,
    );
  });

  test('simulated backend records a failure at the requested stage', () async {
    final entries = <CalibrationWriteJournalEntry>[];
    await SimulatedProgrammingBackend(
      failAt: CalibrationWriteStage.transfer,
    ).execute(request, entries.add);

    expect(entries.last.stage, CalibrationWriteStage.failed);
    expect(entries.last.message, contains('transfer'));
    expect(
      entries.where((entry) => entry.stage == CalibrationWriteStage.verify),
      isEmpty,
    );
  });
}
