import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class StockFileBackup {
  const StockFileBackup({required this.file, required this.vin});
  final File file;
  final String vin;

  String get fileName => file.uri.pathSegments.last;
  Future<int> get size async => file.length();
}

class StockFileStore {
  Future<StockFileBackup?> load(String vin) async {
    final files = await loadAll(vin);
    if (files.isEmpty) return null;
    return files.first;
  }

  Future<List<StockFileBackup>> loadAll(String vin) async {
    final directory = await _directory();
    final prefix = '${_safe(vin)}_';
    final files = await directory
        .list()
        .where(
          (entry) =>
              entry is File && entry.uri.pathSegments.last.startsWith(prefix),
        )
        .cast<File>()
        .toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return [for (final file in files) StockFileBackup(file: file, vin: vin)];
  }

  Future<StockFileBackup> importFile({
    required String sourcePath,
    required String vin,
  }) async {
    final source = File(sourcePath);
    final directory = await _directory();
    final name = source.uri.pathSegments.last.replaceAll(
      RegExp(r'[^A-Za-z0-9._-]'),
      '_',
    );
    final digest = sha256
        .convert(await source.readAsBytes())
        .toString()
        .substring(0, 16);
    // Keep every import as a distinct artifact. The original filename is
    // retained for human review, while the timestamp prevents a reimport
    // from replacing an earlier backup with the same name.
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final destination = File(
      '${directory.path}/${stockBackupArtifactName(vin: vin, sourceName: name, timestamp: stamp, digest: digest)}',
    );
    // Copy into a temporary sibling and rename only after the bytes are
    // complete. A process kill or storage interruption cannot leave a file
    // that looks like a valid stock artifact but contains partial data.
    final temporary = File('${destination.path}.part');
    if (await temporary.exists()) await temporary.delete();
    await source.copy(temporary.path);
    await temporary.rename(destination.path);
    return StockFileBackup(file: destination, vin: vin);
  }

  Future<StockFileBackup> saveBytes({
    required List<int> bytes,
    required String vin,
    String sourceName = 'ecu_read.bin',
    Map<String, Object?>? metadata,
  }) async {
    final directory = await _directory();
    final digest = sha256.convert(bytes).toString().substring(0, 16);
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final destination = File(
      '${directory.path}/${stockBackupArtifactName(vin: vin, sourceName: sourceName, timestamp: stamp, digest: digest)}',
    );
    final temporary = File('${destination.path}.part');
    if (await temporary.exists()) await temporary.delete();
    await temporary.writeAsBytes(bytes, flush: true);
    await temporary.rename(destination.path);
    if (metadata != null) {
      final metadataFile = File('${destination.path}.json');
      await metadataFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert({
          ...metadata,
          'artifact': destination.uri.pathSegments.last,
          'sha256': sha256.convert(bytes).toString(),
          'byteCount': bytes.length,
        }),
        flush: true,
      );
    }
    return StockFileBackup(file: destination, vin: vin);
  }

  Future<Directory> _directory() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/BimmerScope/stock_backups');
    if (!await directory.exists()) await directory.create(recursive: true);
    return directory;
  }

  String _safe(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
}

String stockBackupArtifactName({
  required String vin,
  required String sourceName,
  required int timestamp,
  required String digest,
}) {
  final safeVin = vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
  final safeName = sourceName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  return '${safeVin}_${timestamp}_${digest}_$safeName';
}
