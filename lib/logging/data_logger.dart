import 'dart:async';
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
    final now = DateTime.now();
    sink.writeln(
      '${now.toIso8601String()},${now.difference(started).inMilliseconds},'
      '${csv(sensor.id)},${csv(sensor.label)},${event.value},'
      '${csv(sensor.unit)},${event.rawValue},${csv(_sessionId)},${csv(_source)}',
    );
    sampleCount++;
  }

  /// Adds a human-readable event marker without changing the numeric CSV
  /// schema. Comment rows remain valid CSV and are ignored by chart parsing,
  /// while support tools can use the timestamp and elapsed position.
  bool addMarker([String label = 'Manual marker']) {
    final sink = _sink;
    final started = _startedAt;
    if (sink == null || started == null) return false;
    final now = DateTime.now();
    final clean = label.trim().isEmpty ? 'Manual marker' : label.trim();
    sink.writeln(
      '# marker,${now.toIso8601String()},${now.difference(started).inMilliseconds},${csv(clean)}',
    );
    return true;
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
