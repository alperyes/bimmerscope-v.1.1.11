import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLogger {
  DataLogger({Future<Directory> Function()? directoryProvider})
    : _directoryProvider = directoryProvider;

  final Future<Directory> Function()? _directoryProvider;
  IOSink? _sink;
  File? _file;
  DateTime? _startedAt;
  Timer? _flushTimer;
  String _sessionId = '';
  String _source = '';
  String _vin = '';
  String? _vehicleProfile;
  String? _ecuIdentity;
  String? _ecuSoftware;
  String? _ecuCalibration;
  final _channels = <String, Map<String, Object?>>{};
  int sampleCount = 0;
  String? lastSha256;

  bool get isRecording => _sink != null;
  DateTime? get startedAt => _startedAt;
  String? get activePath => _file?.path;

  Future<void> start({
    required String vin,
    required String sessionId,
    required String source,
    String? vehicleProfile,
    String? ecuIdentity,
    String? ecuSoftware,
    String? ecuCalibration,
  }) async {
    if (isRecording) return;
    final directory = await (_directoryProvider?.call() ?? logsDirectory());
    await pruneOldLogs(directory: directory);
    final now = DateTime.now();
    final stamp = now
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final safeVin = vin == 'Not identified'
        ? 'unknown-vehicle'
        : vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    _file = File('${directory.path}/BimmerScope_${safeVin}_$stamp.csv');
    _sink = _file!.openWrite();
    _startedAt = now;
    _sessionId = sessionId;
    _source = source;
    _vin = vin;
    _vehicleProfile = vehicleProfile;
    _ecuIdentity = ecuIdentity;
    _ecuSoftware = ecuSoftware;
    _ecuCalibration = ecuCalibration;
    _channels.clear();
    sampleCount = 0;
    lastSha256 = null;
    _sink!
      ..writeln('# BimmerScope live-data log')
      ..writeln('# vehicle,$safeVin')
      ..writeln('# session_id,${csv(sessionId)}')
      ..writeln('# source,${csv(source)}')
      ..writeln('# vehicle_profile,${csv(_metadataValue(vehicleProfile))}')
      ..writeln('# ecu_identity,${csv(_metadataValue(ecuIdentity))}')
      ..writeln('# ecu_software,${csv(_metadataValue(ecuSoftware))}')
      ..writeln('# ecu_calibration,${csv(_metadataValue(ecuCalibration))}')
      ..writeln('# started_at,${now.toIso8601String()}')
      ..writeln(
        'timestamp,elapsed_ms,sensor_id,sensor_name,value,unit,raw_value,session_id,source',
      );
    _flushTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final sink = _sink;
      if (sink != null) unawaited(sink.flush());
    });
  }

  void record(VehicleEvent event, SensorDefinition sensor) {
    final sink = _sink;
    final started = _startedAt;
    if (sink == null || started == null || event.kind != 'sensor') return;
    if (!event.value.isFinite) return;
    _channels.putIfAbsent(
      sensor.id,
      () => {
        'id': sensor.id,
        'label': sensor.label,
        'unit': sensor.unit,
        'minimum': sensor.minimum,
        'maximum': sensor.maximum,
        'scale': sensor.scale,
        'offset': sensor.offset,
      },
    );
    final now = DateTime.now();
    sink.writeln(
      '${now.toIso8601String()},${now.difference(started).inMilliseconds},'
      '${csv(sensor.id)},${csv(sensor.label)},${event.value},'
      '${csv(sensor.unit)},${event.rawValue},${csv(_sessionId)},${csv(_source)}',
    );
    sampleCount++;
  }

  Future<File?> stop() async {
    final sink = _sink;
    final file = _file;
    if (sink == null) return file;
    _flushTimer?.cancel();
    _flushTimer = null;
    _sink = null;
    sink.writeln('# ended_at,${DateTime.now().toIso8601String()}');
    sink.writeln('# samples,$sampleCount');
    await sink.flush();
    await sink.close();
    try {
      lastSha256 = sha256.convert(await file!.readAsBytes()).toString();
      await File(
        '${file.path}.sha256',
      ).writeAsString('$lastSha256  ${file.uri.pathSegments.last}\n');
      await _writeMetadataSidecar(file, endedAt: DateTime.now());
    } catch (_) {
      lastSha256 = null;
    }
    _startedAt = null;
    return file;
  }

  Future<void> flush() async {
    final sink = _sink;
    if (sink != null) await sink.flush();
  }

  Future<void> dispose() async => stop();

  Future<void> _writeMetadataSidecar(
    File file, {
    required DateTime endedAt,
  }) async {
    final metadata = File('${file.path}.metadata.json');
    final temporary = File('${metadata.path}.part');
    if (await temporary.exists()) await temporary.delete();
    final content = <String, Object?>{
      'format': 'bimmerscope-log-metadata-v1',
      'csv_file': file.uri.pathSegments.last,
      'csv_sha256': lastSha256,
      'capture': {
        'vin': _vin,
        'session_id': _sessionId,
        'source': _source,
        'vehicle_profile': _vehicleProfile,
        'ecu_identity': _ecuIdentity,
        'ecu_software': _ecuSoftware,
        'ecu_calibration': _ecuCalibration,
        'started_at': _startedAt?.toIso8601String(),
        'ended_at': endedAt.toIso8601String(),
        'sample_count': sampleCount,
      },
      'channels': _channels.values.toList(),
    };
    await temporary.writeAsString(
      const JsonEncoder.withIndent('  ').convert(content),
      flush: true,
    );
    if (await metadata.exists()) await metadata.delete();
    await temporary.rename(metadata.path);
  }

  static Future<Directory> logsDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/BimmerScope/logs');
    if (!await directory.exists()) await directory.create(recursive: true);
    return directory;
  }

  static Future<List<File>> savedLogs() async {
    final directory = await logsDirectory();
    final files = await directory
        .list()
        .where((entry) => entry is File && entry.path.endsWith('.csv'))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files;
  }

  /// Renames a saved CSV and all of its integrity/provenance sidecars.
  /// The log's embedded session metadata is intentionally unchanged.
  static Future<File> renameSavedLog(File source, String requestedName) async {
    if (!await source.exists()) {
      throw FileSystemException('Log file is missing', source.path);
    }
    var name = requestedName.trim();
    if (name.toLowerCase().endsWith('.csv')) {
      name = name.substring(0, name.length - 4);
    }
    name = name.replaceAll(RegExp(r'[^A-Za-z0-9 _.-]'), '_').trim();
    if (name.isEmpty) {
      throw ArgumentError.value(
        requestedName,
        'requestedName',
        'Enter a valid log name.',
      );
    }
    if (name.length > 80) name = name.substring(0, 80);
    final target = File(
      '${source.parent.path}${Platform.pathSeparator}$name.csv',
    );
    if (target.path == source.path) return source;
    if (await target.exists()) {
      throw FileSystemException(
        'A log with that name already exists',
        target.path,
      );
    }
    final sidecar = File('${source.path}.sha256');
    final targetSidecar = File('${target.path}.sha256');
    final metadata = File('${source.path}.metadata.json');
    final targetMetadata = File('${target.path}.metadata.json');
    if (await targetSidecar.exists()) {
      throw FileSystemException(
        'A log integrity file with that name already exists',
        targetSidecar.path,
      );
    }
    if (await targetMetadata.exists()) {
      throw FileSystemException(
        'A log metadata file with that name already exists',
        targetMetadata.path,
      );
    }
    final renamed = await source.rename(target.path);
    try {
      if (await sidecar.exists()) {
        await sidecar.rename(targetSidecar.path);
        final sidecarText = await targetSidecar.readAsString();
        final digest = sidecarText.trim().split(RegExp(r'\s+')).first;
        if (RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(digest)) {
          await targetSidecar.writeAsString(
            '$digest  ${target.uri.pathSegments.last}\n',
            flush: true,
          );
        }
      }
      if (await metadata.exists()) {
        await metadata.rename(targetMetadata.path);
        final decoded = jsonDecode(await targetMetadata.readAsString());
        if (decoded is Map<String, dynamic>) {
          decoded['csv_file'] = target.uri.pathSegments.last;
          await targetMetadata.writeAsString(
            const JsonEncoder.withIndent('  ').convert(decoded),
            flush: true,
          );
        }
      }
      return renamed;
    } catch (_) {
      // Do not leave a renamed CSV without its matching sidecar when a move
      // fails (for example, because storage changed mid-operation).
      if (await renamed.exists() && !await source.exists()) {
        await renamed.rename(source.path);
      }
      if (await targetSidecar.exists() && !await sidecar.exists()) {
        await targetSidecar.rename(sidecar.path);
      }
      if (await targetMetadata.exists() && !await metadata.exists()) {
        await targetMetadata.rename(metadata.path);
      }
      rethrow;
    }
  }

  /// Keeps long drives from filling the device. A value of zero means
  /// unlimited retention. The setting is deliberately local and never
  /// affects an already-exported or shared file.
  static Future<void> pruneOldLogs({Directory? directory, int? days}) async {
    final target = directory ?? await logsDirectory();
    var configured = days;
    if (configured == null) {
      try {
        configured =
            (await SharedPreferences.getInstance()).getInt(
              'bimmerscope.log_retention_days',
            ) ??
            30;
      } catch (_) {
        // Pure Dart logger tests and early startup may not have a Flutter
        // binding yet; use the safe default in that case.
        configured = 30;
      }
    }
    if (configured <= 0 || !await target.exists()) return;
    final cutoff = DateTime.now().subtract(Duration(days: configured));
    await for (final entry in target.list()) {
      if (entry is! File || !entry.path.endsWith('.csv')) continue;
      try {
        if ((await entry.lastModified()).isBefore(cutoff)) {
          await entry.delete();
          final sidecar = File('${entry.path}.sha256');
          if (await sidecar.exists()) await sidecar.delete();
          final metadata = File('${entry.path}.metadata.json');
          if (await metadata.exists()) await metadata.delete();
        }
      } catch (_) {
        // A locked or partially written log is kept for the next cleanup.
      }
    }
  }

  static String csv(String value) =>
      '"${value.replaceAll('"', '""').replaceAll('\n', ' ')}"';

  /// CSV headers remain parseable when an identity read is unavailable. Empty
  /// values deliberately mean "not observed" rather than a guessed fallback.
  static String _metadataValue(String? value) => value?.trim() ?? '';
}
