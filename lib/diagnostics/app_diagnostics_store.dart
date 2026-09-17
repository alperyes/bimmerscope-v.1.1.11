import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppDiagnosticsLevel { normal, detailed, trace }

extension AppDiagnosticsLevelLabel on AppDiagnosticsLevel {
  String get title => switch (this) {
    AppDiagnosticsLevel.normal => 'Normal',
    AppDiagnosticsLevel.detailed => 'Detailed',
    AppDiagnosticsLevel.trace => 'Trace',
  };

  String get description => switch (this) {
    AppDiagnosticsLevel.normal => 'Connection events and faults only.',
    AppDiagnosticsLevel.detailed =>
      'Adds timing, retries, gaps, and responses.',
    AppDiagnosticsLevel.trace =>
      'Keeps high-volume sensor and transport detail.',
  };
}

/// Persistent, append-only app session diagnostics.
///
/// JSONL keeps writes small and recoverable if Android kills the process while
/// a vehicle is connected. Each line is a timestamped record; the first line
/// identifies the session and the final line is marked `session_end`.
class AppDiagnosticsStore {
  static const _levelKey = 'bimmerscope.diagnostics.level';
  static const _folderName = 'bimmerscope_diagnostics';
  static const _filePrefix = 'BimmerScope_Session_';

  Future<Directory> _directory() async {
    final root = await getApplicationDocumentsDirectory();
    final directory = Directory(
      '${root.path}${Platform.pathSeparator}$_folderName',
    );
    if (!await directory.exists()) await directory.create(recursive: true);
    return directory;
  }

  Future<Directory> directory() => _directory();

  Future<AppDiagnosticsLevel> level() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(_levelKey);
    return AppDiagnosticsLevel.values.firstWhere(
      (item) => item.name == value,
      orElse: () => AppDiagnosticsLevel.normal,
    );
  }

  Future<void> setLevel(AppDiagnosticsLevel value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_levelKey, value.name);
  }

  Future<File> start({
    required String sessionId,
    required String source,
    required DateTime startedAt,
  }) async {
    final directory = await _directory();
    final safeId = sessionId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final file = File(
      '${directory.path}${Platform.pathSeparator}$_filePrefix$safeId.jsonl',
    );
    await file.writeAsString(
      '${jsonEncode({'type': 'session_start', 'sessionId': sessionId, 'source': source, 'timestamp': startedAt.toIso8601String()})}\n',
      mode: FileMode.write,
    );
    return file;
  }

  Future<void> append(File file, Map<String, Object?> record) async {
    await file.writeAsString('${jsonEncode(record)}\n', mode: FileMode.append);
  }

  Future<List<File>> list() async {
    final directory = await _directory();
    await pruneOldFiles(directory);
    final files = directory
        .listSync()
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.jsonl') ||
              file.path.contains('BimmerScope_App_Diagnostics_') ||
              file.path.contains('BimmerScope_App_Session_') ||
              file.path.contains('BimmerScope_Raw_HSFZ_'),
        )
        .toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files;
  }

  Future<void> pruneOldFiles(Directory directory, {int? days}) async {
    var retention = days;
    if (retention == null) {
      try {
        retention =
            (await SharedPreferences.getInstance()).getInt(
              'bimmerscope.log_retention_days',
            ) ??
            30;
      } catch (_) {
        retention = 30;
      }
    }
    if (retention <= 0) return;
    final cutoff = DateTime.now().subtract(Duration(days: retention));
    await for (final entry in directory.list()) {
      if (entry is! File) continue;
      if (!entry.path.endsWith('.jsonl') &&
          !entry.path.contains('BimmerScope_App_Diagnostics_') &&
          !entry.path.contains('BimmerScope_App_Session_') &&
          !entry.path.contains('BimmerScope_Raw_HSFZ_')) {
        continue;
      }
      try {
        if ((await entry.lastModified()).isBefore(cutoff)) await entry.delete();
      } catch (_) {}
    }
  }

  Future<void> delete(File file) => file.exists().then((exists) async {
    if (exists) await file.delete();
  });

  Future<void> deleteAll() async {
    for (final file in await list()) {
      await delete(file);
    }
  }
}
