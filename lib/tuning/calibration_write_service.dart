import 'write_preflight.dart';
import '../vehicle/vehicle_capabilities.dart';

enum CalibrationWriteStage {
  preflight,
  backup,
  identify,
  compatibility,
  programmingPreconditions,
  prepareSession,
  authenticate,
  quiesceNetwork,
  erase,
  requestDownload,
  transfer,
  transferExit,
  verify,
  reset,
  restoreNetwork,
  complete,
  failed,
}

class CalibrationWriteRequest {
  const CalibrationWriteRequest({
    required this.vin,
    required this.ecuFingerprint,
    required this.packageHash,
    required this.backupHash,
    this.expectedFingerprint,
  });

  final String vin;
  final String ecuFingerprint;
  final String packageHash;
  final String backupHash;
  final EcuFingerprint? expectedFingerprint;
}

class CalibrationWriteJournalEntry {
  const CalibrationWriteJournalEntry({
    required this.stage,
    required this.message,
    required this.at,
  });

  final CalibrationWriteStage stage;
  final String message;
  final DateTime at;
}

abstract interface class CalibrationWriteBackend {
  Future<void> execute(
    CalibrationWriteRequest request,
    void Function(CalibrationWriteJournalEntry entry) record,
  );
}

/// Implementations must persist an entry before returning. Storage errors must
/// propagate; the service must never report success when its journal failed.
abstract interface class CalibrationWriteJournal {
  void append(CalibrationWriteJournalEntry entry);
}

/// Safety boundary for all future programming backends.
class CalibrationWriteService {
  const CalibrationWriteService(this.backend);

  final CalibrationWriteBackend? backend;

  Future<List<CalibrationWriteJournalEntry>> write({
    required WritePreflight preflight,
    required CalibrationWriteRequest request,
    CalibrationWriteJournal? journal,
  }) async {
    final entries = <CalibrationWriteJournalEntry>[];
    Object? journalFailure;
    void append(CalibrationWriteJournalEntry entry) {
      if (journalFailure != null) {
        throw StateError('Operation journal unavailable');
      }
      try {
        journal?.append(entry);
      } catch (error) {
        journalFailure = error;
        rethrow;
      }
      entries.add(entry);
    }

    void record(CalibrationWriteStage stage, String message) {
      append(
        CalibrationWriteJournalEntry(
          stage: stage,
          message: message,
          at: DateTime.now().toUtc(),
        ),
      );
    }

    record(CalibrationWriteStage.preflight, 'Preflight started');
    if (!preflight.allowed) {
      record(
        CalibrationWriteStage.failed,
        'Write blocked: ${preflight.blockingReasons.join('; ')}',
      );
      return List.unmodifiable(entries);
    }
    final fingerprint = preflight.ecuFingerprint;
    if (request.vin.trim().toUpperCase() !=
            preflight.sessionVin.trim().toUpperCase() ||
        fingerprint == null ||
        request.expectedFingerprint == null ||
        !matchingWriteFingerprint(request.expectedFingerprint!, fingerprint) ||
        request.ecuFingerprint != fingerprint.identity ||
        request.backupHash != preflight.immutableBackupHash ||
        request.packageHash.trim().isEmpty) {
      record(
        CalibrationWriteStage.failed,
        'Write blocked: request evidence does not match preflight',
      );
      return List.unmodifiable(entries);
    }
    final writer = backend;
    if (writer == null) {
      record(
        CalibrationWriteStage.failed,
        'Write blocked: no validated programming backend is installed',
      );
      return List.unmodifiable(entries);
    }
    const expectedStages = <CalibrationWriteStage>[
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
    var nextStage = 0;
    var terminal = false;
    var returned = false;
    CalibrationWriteJournalEntry? pendingCompletion;
    void recordBackend(CalibrationWriteJournalEntry entry) {
      if (returned || terminal) return;
      if (entry.stage == CalibrationWriteStage.failed) {
        terminal = true;
        append(entry);
        return;
      }
      if (nextStage >= expectedStages.length ||
          entry.stage != expectedStages[nextStage]) {
        terminal = true;
        record(
          CalibrationWriteStage.failed,
          'Programming backend reported an invalid stage sequence',
        );
        return;
      }
      if (entry.stage == CalibrationWriteStage.complete) {
        pendingCompletion = entry;
      } else {
        append(entry);
      }
      nextStage += 1;
    }

    try {
      await writer.execute(request, recordBackend);
    } catch (_) {
      if (journalFailure != null) rethrow;
      if (!terminal) {
        terminal = true;
        record(
          CalibrationWriteStage.failed,
          'Programming backend failed unexpectedly',
        );
      }
    }
    returned = true;
    if (journalFailure != null) {
      throw StateError('Operation journal unavailable');
    }
    if (!terminal && pendingCompletion != null) {
      append(pendingCompletion!);
    } else if (!terminal) {
      record(
        CalibrationWriteStage.failed,
        'Programming backend ended before verification completed',
      );
    }
    return List.unmodifiable(entries);
  }
}
