import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';

import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class TunerPackageStore {
  TunerPackageStore({Future<Directory> Function()? documentsProvider})
    : _documentsProvider = documentsProvider;

  final Future<Directory> Function()? _documentsProvider;
  List<File> lastAttachments = [];
  Future<File> create({
    required String vin,
    required String vehicleLabel,
    required String profileId,
    required String productId,
    required String productLabel,
    required List<String> capabilities,
    required String? stockFileName,
    String? stockFilePath,
    required List<String> logFiles,
    required String modifications,
    required Map<String, dynamic> compatibility,
    required List<Map<String, dynamic>> logQuality,
    String fuel = '',
    String hardware = '',
    double? mileageKm,
  }) async {
    final documents =
        await (_documentsProvider?.call() ??
            getApplicationDocumentsDirectory());
    final directory = Directory('${documents.path}/BimmerScope/tuner_packages');
    if (!await directory.exists()) await directory.create(recursive: true);
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final safeVin = vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final file = File(
      '${directory.path}/BimmerScope_TunerPackage_${safeVin}_$stamp.json',
    );
    final packageName = file.uri.pathSegments.last.replaceFirst(
      RegExp(r'\.json$'),
      '',
    );
    final packageDir = Directory('${directory.path}/$packageName');
    await packageDir.create(recursive: true);
    lastAttachments = [];
    final stockSource = stockFilePath == null ? null : File(stockFilePath);
    final stockEntry = await _copyAttachment(
      stockSource,
      packageDir,
      'stock_backup',
    );
    final logEntries = <Map<String, dynamic>>[];
    for (final path in logFiles) {
      final source = File(path);
      final entry = await _copyAttachment(source, packageDir, 'logs');
      if (entry != null) {
        entry['sidecars'] = await _copyLogSidecars(source, entry, packageDir);
        logEntries.add(entry);
      }
    }
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'format': 'bimmerscope-tuner-package-v3',
        'created_at': DateTime.now().toIso8601String(),
        'vehicle': {
          'vin': vin,
          'label': vehicleLabel,
          'profile_id': profileId,
          if (mileageKm != null) 'mileage_km': mileageKm,
        },
        'product': {'id': productId, 'label': productLabel},
        'capabilities': capabilities,
        'compatibility': compatibility,
        'log_quality': logQuality,
        'modifications': modifications,
        'request_details': {
          'fuel': fuel,
          'hardware': hardware,
          'modifications': modifications,
        },
        'stock_backup': stockEntry ?? {'present': false},
        'data_logs': logEntries,
        'attachments_directory': packageName,
      }),
    );
    return file;
  }

  Future<Map<String, dynamic>?> _copyAttachment(
    File? source,
    Directory root,
    String subdir,
  ) async {
    if (source == null) return null;
    if (!await source.exists()) {
      throw FileSystemException('Selected attachment is missing', source.path);
    }
    final targetDir = Directory('${root.path}/$subdir')
      ..createSync(recursive: true);
    final originalName = source.uri.pathSegments.last;
    var target = File('${targetDir.path}/$originalName');
    var suffix = 2;
    while (await target.exists()) {
      target = File('${targetDir.path}/${suffix++}_$originalName');
    }
    final temporary = File('${target.path}.part');
    if (await temporary.exists()) await temporary.delete();
    await source.copy(temporary.path);
    await temporary.rename(target.path);
    final digest = sha256.convert(await target.readAsBytes()).toString();
    lastAttachments.add(target);
    final relativePath = '$subdir/${target.uri.pathSegments.last}';
    return {
      'file_name': source.uri.pathSegments.last,
      'path': relativePath,
      'sha256': digest,
      'size': await target.length(),
      'present': true,
    };
  }

  Future<List<Map<String, dynamic>>> _copyLogSidecars(
    File source,
    Map<String, dynamic> logEntry,
    Directory packageDir,
  ) async {
    final sidecars = <Map<String, dynamic>>[];
    final packagedPath = logEntry['path'] as String;
    for (final suffix in const ['.sha256', '.metadata.json']) {
      final sidecar = File('${source.path}$suffix');
      if (!await sidecar.exists()) continue;
      final target = File(
        '${packageDir.path}${Platform.pathSeparator}$packagedPath$suffix',
      );
      final temporary = File('${target.path}.part');
      if (await temporary.exists()) await temporary.delete();
      await sidecar.copy(temporary.path);
      await temporary.rename(target.path);
      final bytes = await target.readAsBytes();
      lastAttachments.add(target);
      sidecars.add({
        'path': '$packagedPath$suffix',
        'sha256': sha256.convert(bytes).toString(),
        'size': bytes.length,
        'present': true,
      });
    }
    return sidecars;
  }

  /// Reopens a generated package and verifies every declared attachment. This
  Future<File> createArchive(File manifestFile) async {
    final validation = await validate(manifestFile);
    if (!validation.valid) throw StateError(validation.errors.join(' '));
    final manifestBytes = await manifestFile.readAsBytes();
    final manifest =
        jsonDecode(utf8.decode(manifestBytes)) as Map<String, dynamic>;
    final name = manifestFile.uri.pathSegments.last;
    final folder = name.replaceFirst(RegExp(r'\.json$'), '');
    final archive = Archive()
      ..addFile(ArchiveFile(name, manifestBytes.length, manifestBytes));
    final entries = _declaredAttachments(manifest);
    for (final entry in entries) {
      final relative = entry['path'] as String;
      final bytes = await File(
        '${manifestFile.parent.path}/$folder/$relative',
      ).readAsBytes();
      if (bytes.length != entry['size'] ||
          sha256.convert(bytes).toString() != entry['sha256']) {
        throw StateError('Attachment changed during export: $relative');
      }
      archive.addFile(ArchiveFile('$folder/$relative', bytes.length, bytes));
    }
    final target = File('${manifestFile.parent.path}/$folder.zip');
    await target.writeAsBytes(ZipEncoder().encode(archive), flush: true);
    return target;
  }

  /// Reopens a generated package and verifies every declared attachment. This
  /// is a read-only integrity check used before sharing with a tuner.
  Future<TunerPackageValidation> validate(File manifestFile) async {
    final errors = <String>[];
    Map<String, dynamic>? manifest;
    try {
      final decoded = jsonDecode(await manifestFile.readAsString());
      if (decoded is Map<String, dynamic>) manifest = decoded;
    } catch (error) {
      errors.add('Manifest could not be read: $error');
    }
    if (manifest == null) {
      return const TunerPackageValidation(
        valid: false,
        errors: ['Invalid package manifest'],
      );
    }
    if (!const {
      'bimmerscope-tuner-package-v2',
      'bimmerscope-tuner-package-v3',
    }.contains(manifest['format'])) {
      errors.add('Unsupported package format');
    }
    final packageDir = Directory(
      '${manifestFile.parent.path}${Platform.pathSeparator}${manifestFile.uri.pathSegments.last.replaceFirst(RegExp(r'\.json$'), '')}',
    );
    final attachments = _declaredAttachments(manifest);
    for (final entry in attachments) {
      final relative = entry['path'] as String?;
      final expected = entry['sha256'] as String?;
      final expectedSize = entry['size'] as num?;
      if (relative == null || expected == null || relative.contains('..')) {
        errors.add('Attachment entry is incomplete');
        continue;
      }
      final file = File('${packageDir.path}${Platform.pathSeparator}$relative');
      final rootPath = packageDir.absolute.path.toLowerCase();
      final targetPath = file.absolute.path.toLowerCase();
      if (!targetPath.startsWith('$rootPath${Platform.pathSeparator}')) {
        errors.add('Attachment path escapes package: $relative');
        continue;
      }
      if (!await file.exists()) {
        errors.add('Missing attachment: $relative');
        continue;
      }
      if (expectedSize == null || await file.length() != expectedSize.toInt()) {
        errors.add('Size mismatch: $relative');
        continue;
      }
      final actual = sha256.convert(await file.readAsBytes()).toString();
      if (actual != expected) errors.add('Hash mismatch: $relative');
    }
    return TunerPackageValidation(valid: errors.isEmpty, errors: errors);
  }

  List<Map<String, dynamic>> _declaredAttachments(
    Map<String, dynamic> manifest,
  ) {
    final attachments = <Map<String, dynamic>>[];
    final stock = manifest['stock_backup'];
    if (stock is Map && stock['present'] == true) {
      attachments.add(Map<String, dynamic>.from(stock));
    }
    final logs = manifest['data_logs'];
    if (logs is List) {
      for (final entry in logs.whereType<Map>()) {
        final log = Map<String, dynamic>.from(entry);
        attachments.add(log);
        final sidecars = log['sidecars'];
        if (sidecars is List) {
          attachments.addAll(
            sidecars.whereType<Map>().map(Map<String, dynamic>.from),
          );
        }
      }
    }
    return attachments;
  }
}

class TunerPackageValidation {
  const TunerPackageValidation({required this.valid, required this.errors});
  final bool valid;
  final List<String> errors;
}
