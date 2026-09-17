import 'dart:convert';
import 'dart:io';

import 'calibration_write_service.dart';

/// Local development journal. Flushes every record before acknowledging it.
/// Each operation owns a newly created directory; existing records are never
/// reopened for writing. This is diagnostic evidence, not ECU recovery logic.
class FileWriteJournal implements CalibrationWriteJournal {
  FileWriteJournal._(this.file, this._handle);

  final File file;
  final RandomAccessFile _handle;
  int _sequence = 0;
  bool _closed = false;

  static FileWriteJournal create({
    required Directory root,
    required CalibrationWriteRequest request,
    required String backendId,
    required bool simulated,
  }) {
    root.createSync(recursive: true);
    final directory = root.createTempSync('operation-');
    final file = File(
      '${directory.path}${Platform.pathSeparator}journal.jsonl',
    );
    final handle = file.openSync(mode: FileMode.write);
    final journal = FileWriteJournal._(file, handle);
    try {
      journal._write({
        'schema': 'bimmerscope-operation-v1',
        'type': 'operation',
        'backend_id': backendId,
        'simulated': simulated,
        'vin': request.vin,
        'ecu_fingerprint': request.ecuFingerprint,
        'expected_fingerprint': request.expectedFingerprint == null
            ? null
            : {
                'vin': request.expectedFingerprint!.vin,
                'identity': request.expectedFingerprint!.identity,
                'bosch_hardware': request.expectedFingerprint!.boschHardware,
                'bmw_hardware': request.expectedFingerprint!.bmwHardware,
                'software_id': request.expectedFingerprint!.softwareId,
                'calibration_id': request.expectedFingerprint!.calibrationId,
                'bootloader_id': request.expectedFingerprint!.bootloaderId,
              },
        'package_hash': request.packageHash,
        'backup_hash': request.backupHash,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {
      journal.close();
      rethrow;
    }
    return journal;
  }

  void _write(Map<String, Object?> record) {
    if (_closed) throw StateError('Journal is closed');
    _handle.writeStringSync('${jsonEncode(record)}\n');
    _handle.flushSync();
  }

  @override
  void append(CalibrationWriteJournalEntry entry) {
    _write({
      'type': 'stage',
      'sequence': _sequence,
      'stage': entry.stage.name,
      'message': entry.message,
      'at': entry.at.toUtc().toIso8601String(),
    });
    _sequence++;
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _handle.closeSync();
    }
  }
}

enum RecordedOperationStatus { complete, failed, interrupted, corrupt }

/// Reads conservatively: a truncated or malformed record makes the outcome
/// uncertain, even if an earlier record said complete. Never resumes a write.
RecordedOperationStatus inspectWriteJournal(File file) {
  try {
    final text = file.readAsStringSync();
    if (!text.endsWith('\n')) return RecordedOperationStatus.corrupt;
    final lines = text.substring(0, text.length - 1).split('\n');
    final header = jsonDecode(lines.first) as Map<String, dynamic>;
    if (header['schema'] != 'bimmerscope-operation-v1' ||
        header['type'] != 'operation') {
      return RecordedOperationStatus.corrupt;
    }
    const order = [
      'preflight',
      'backup',
      'identify',
      'compatibility',
      'programmingPreconditions',
      'prepareSession',
      'authenticate',
      'quiesceNetwork',
      'erase',
      'requestDownload',
      'transfer',
      'transferExit',
      'verify',
      'reset',
      'restoreNetwork',
      'complete',
    ];
    var next = 0;
    var status = RecordedOperationStatus.interrupted;
    for (final line in lines.skip(1)) {
      if (status != RecordedOperationStatus.interrupted) {
        return RecordedOperationStatus.corrupt;
      }
      final record = jsonDecode(line) as Map<String, dynamic>;
      if (record['type'] != 'stage' ||
          record['sequence'] != next ||
          record['message'] is! String ||
          DateTime.tryParse(record['at'] as String) == null) {
        return RecordedOperationStatus.corrupt;
      }
      if (record['stage'] == 'failed') {
        status = RecordedOperationStatus.failed;
      } else if (next >= order.length || record['stage'] != order[next]) {
        return RecordedOperationStatus.corrupt;
      } else if (record['stage'] == 'complete') {
        status = RecordedOperationStatus.complete;
      }
      next++;
    }
    return status;
  } catch (_) {
    return RecordedOperationStatus.corrupt;
  }
}
