import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:bmw_app/tuning/file_write_journal.dart';
import 'package:bmw_app/tuning/write_preflight.dart';
import 'package:bmw_app/tuning/calibration_write_service.dart';
import 'package:bmw_app/vehicle/vehicle_capabilities.dart';
import 'package:bmw_app/vehicle/vehicle_identity.dart';

class _CompletionBackend implements CalibrationWriteBackend {
  _CompletionBackend(this.ending);
  final String ending;

  @override
  Future<void> execute(
    CalibrationWriteRequest request,
    void Function(CalibrationWriteJournalEntry) record,
  ) async {
    void emit(CalibrationWriteStage stage) => record(
      CalibrationWriteJournalEntry(
        stage: stage,
        message: stage.name,
        at: DateTime.now().toUtc(),
      ),
    );
    for (final stage in [
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
    ]) {
      emit(stage);
    }
    if (ending == 'throw') throw StateError('failure after completion');
    if (ending == 'failure') emit(CalibrationWriteStage.failed);
    if (ending == 'extra') emit(CalibrationWriteStage.transfer);
  }
}

class _FailingJournal implements CalibrationWriteJournal {
  @override
  void append(CalibrationWriteJournalEntry entry) {
    if (entry.stage != CalibrationWriteStage.preflight) {
      throw StateError('Disk unavailable');
    }
  }
}

class _SwallowingBackend implements CalibrationWriteBackend {
  @override
  Future<void> execute(
    CalibrationWriteRequest request,
    void Function(CalibrationWriteJournalEntry) record,
  ) async {
    try {
      await _CompletionBackend('success').execute(request, record);
    } catch (_) {}
  }
}

class _IncompleteBackend implements CalibrationWriteBackend {
  @override
  Future<void> execute(
    CalibrationWriteRequest request,
    void Function(CalibrationWriteJournalEntry entry) record,
  ) async {
    record(
      CalibrationWriteJournalEntry(
        stage: CalibrationWriteStage.backup,
        message: 'backup',
        at: DateTime.now().toUtc(),
      ),
    );
  }
}

class _OutOfOrderBackend implements CalibrationWriteBackend {
  @override
  Future<void> execute(
    CalibrationWriteRequest request,
    void Function(CalibrationWriteJournalEntry entry) record,
  ) async {
    record(
      CalibrationWriteJournalEntry(
        stage: CalibrationWriteStage.complete,
        message: 'not verified',
        at: DateTime.now().toUtc(),
      ),
    );
  }
}

void main() {
  test(
    'same family with different software is rejected before backend call',
    () async {
      final backend = _CountingBackend();
      final entries = await CalibrationWriteService(backend).write(
        preflight: _allowedPreflight(),
        request: const CalibrationWriteRequest(
          vin: 'WBS00000000000000',
          ecuFingerprint: 'MEVD17.2.G',
          packageHash: 'package',
          backupHash: 'backup',
          expectedFingerprint: EcuFingerprint(
            vin: 'WBS00000000000000',
            identity: 'MEVD17.2.G',
            boschHardware: '0261S00000',
            bmwHardware: '1234567',
            softwareId: 'DIFFERENT',
            calibrationId: 'SIMULATED',
            bootloaderId: 'SIMULATED',
            verified: true,
          ),
        ),
      );
      expect(backend.calls, 0);
      expect(entries.last.stage, CalibrationWriteStage.failed);
    },
  );
  test('operation journal survives closing and detects a torn tail', () async {
    final root = Directory.systemTemp.createTempSync('write-journal-test-');
    addTearDown(() => root.deleteSync(recursive: true));
    final journal = FileWriteJournal.create(
      root: root,
      request: _request,
      backendId: 'test',
      simulated: true,
    );
    try {
      expect(
        inspectWriteJournal(journal.file),
        RecordedOperationStatus.interrupted,
      );
      await CalibrationWriteService(_CompletionBackend('success')).write(
        preflight: _allowedPreflight(),
        request: _request,
        journal: journal,
      );
    } finally {
      journal.close();
    }
    expect(inspectWriteJournal(journal.file), RecordedOperationStatus.complete);
    journal.file.writeAsStringSync('{', mode: FileMode.append, flush: true);
    expect(inspectWriteJournal(journal.file), RecordedOperationStatus.corrupt);
  });

  test('every unfinished stage is recovered as interrupted', () {
    final root = Directory.systemTemp.createTempSync(
      'write-interruption-test-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final journal = FileWriteJournal.create(
      root: root,
      request: _request,
      backendId: 'test',
      simulated: true,
    );
    try {
      for (final stage in [
        CalibrationWriteStage.preflight,
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
      ]) {
        journal.append(
          CalibrationWriteJournalEntry(
            stage: stage,
            message: stage.name,
            at: DateTime.now().toUtc(),
          ),
        );
        expect(
          inspectWriteJournal(journal.file),
          RecordedOperationStatus.interrupted,
        );
      }
    } finally {
      journal.close();
    }
    expect(
      inspectWriteJournal(journal.file),
      RecordedOperationStatus.interrupted,
    );
    final other = FileWriteJournal.create(
      root: root,
      request: _request,
      backendId: 'test',
      simulated: true,
    );
    other.close();
    expect(other.file.path, isNot(journal.file.path));
  });

  test(
    'journal failure prevents reporting completion even if swallowed',
    () async {
      await expectLater(
        CalibrationWriteService(_SwallowingBackend()).write(
          preflight: _allowedPreflight(),
          request: _request,
          journal: _FailingJournal(),
        ),
        throwsStateError,
      );
    },
  );
  for (final ending in ['success', 'throw', 'failure', 'extra']) {
    test('completion is provisional until backend returns: $ending', () async {
      final entries = await CalibrationWriteService(
        _CompletionBackend(ending),
      ).write(preflight: _allowedPreflight(), request: _request);
      expect(
        entries.last.stage,
        ending == 'success'
            ? CalibrationWriteStage.complete
            : CalibrationWriteStage.failed,
      );
      expect(
        entries.where((e) => e.stage == CalibrationWriteStage.complete).length,
        ending == 'success' ? 1 : 0,
      );
    });
  }
  test('write preflight blocks an unvalidated S55 session', () {
    final identity = const VehicleIdentity(
      chassis: 'F82',
      model: 'M4',
      engine: 'S55',
      transmission: 'DCT',
      modelYear: 2014,
    );
    final profile = resolveEcuProfile(
      identity: identity,
      vehicleVin: 'WBS00000000000000',
      fingerprint: const EcuFingerprint(
        vin: 'WBS00000000000000',
        identity: 'MEVD17.2.G',
      ),
    );
    final preflight = WritePreflight(
      profile: profile,
      sessionVin: 'WBS00000000000000',
      ecuFingerprint: profile.fingerprint,
      transport: 'wired_enet',
      externalPowerStable: true,
      ignitionReady: true,
      immutableBackupHash: 'abc',
      packageSignatureVerified: true,
      recoveryProcedureVerified: true,
      backendValidated: true,
    );

    expect(preflight.allowed, isFalse);
    expect(
      preflight.blockingReasons,
      contains('Calibration writing is not supported for this profile'),
    );
  });

  test(
    'write service journals a blocked request without calling transport',
    () async {
      final entries = await const CalibrationWriteService(null).write(
        preflight: const WritePreflight(
          profile: null,
          sessionVin: '',
          ecuFingerprint: null,
          transport: null,
          externalPowerStable: false,
          ignitionReady: false,
          immutableBackupHash: null,
          packageSignatureVerified: false,
          recoveryProcedureVerified: false,
          backendValidated: false,
        ),
        request: const CalibrationWriteRequest(
          vin: 'WBS00000000000000',
          ecuFingerprint: 'MEVD17.2.G',
          packageHash: 'package',
          backupHash: 'backup',
        ),
      );

      expect(entries.last.stage, CalibrationWriteStage.failed);
      expect(entries.last.message, contains('Write blocked'));
    },
  );

  test('write service rejects an incomplete backend transaction', () async {
    final entries = await CalibrationWriteService(
      _IncompleteBackend(),
    ).write(preflight: _allowedPreflight(), request: _request);

    expect(entries.last.stage, CalibrationWriteStage.failed);
    expect(entries.last.message, contains('before verification'));
  });

  test('write service rejects an out-of-order backend transaction', () async {
    final entries = await CalibrationWriteService(
      _OutOfOrderBackend(),
    ).write(preflight: _allowedPreflight(), request: _request);

    expect(entries.last.stage, CalibrationWriteStage.failed);
    expect(entries.last.message, contains('invalid stage sequence'));
  });
}

class _CountingBackend implements CalibrationWriteBackend {
  int calls = 0;
  @override
  Future<void> execute(
    CalibrationWriteRequest request,
    void Function(CalibrationWriteJournalEntry) record,
  ) async {
    calls++;
  }
}

const _request = CalibrationWriteRequest(
  vin: 'WBS00000000000000',
  ecuFingerprint: 'MEVD17.2.G',
  packageHash: 'package',
  backupHash: 'backup',
  expectedFingerprint: EcuFingerprint(
    vin: 'WBS00000000000000',
    identity: 'MEVD17.2.G',
    boschHardware: '0261S00000',
    bmwHardware: '1234567',
    softwareId: 'SIMULATED',
    calibrationId: 'SIMULATED',
    bootloaderId: 'SIMULATED',
    verified: true,
  ),
);

WritePreflight _allowedPreflight() {
  const fingerprint = EcuFingerprint(
    vin: 'WBS00000000000000',
    identity: 'MEVD17.2.G',
    boschHardware: '0261S00000',
    bmwHardware: '1234567',
    softwareId: 'SIMULATED',
    calibrationId: 'SIMULATED',
    bootloaderId: 'SIMULATED',
    verified: true,
  );
  const vehicle = VehicleProfile(
    id: 'test-write-profile',
    label: 'Test write profile',
    chassis: 'F82',
    engines: ['S55'],
    capabilities: {VehicleCapability.calibrationWrite},
    ecu: EcuIdentity(name: 'DME', family: EcuFamily.mevd172g),
    confidence: ProfileConfidence.exact,
  );
  return const WritePreflight(
    profile: ResolvedEcuProfile(
      vehicle: vehicle,
      fingerprint: fingerprint,
      capabilities: {VehicleCapability.calibrationWrite},
      confidence: ProfileConfidence.exact,
    ),
    sessionVin: 'WBS00000000000000',
    ecuFingerprint: fingerprint,
    transport: 'wired_enet',
    externalPowerStable: true,
    ignitionReady: true,
    immutableBackupHash: 'backup',
    packageSignatureVerified: true,
    recoveryProcedureVerified: true,
    backendValidated: true,
  );
}
