import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class TunerPackageStore {
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
  }) async {
    final documents = await getApplicationDocumentsDirectory();
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
      final entry = await _copyAttachment(File(path), packageDir, 'logs');
      if (entry != null) logEntries.add(entry);
    }
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'format': 'bimmerscope-tuner-package-v2',
        'created_at': DateTime.now().toIso8601String(),
        'vehicle': {'vin': vin, 'label': vehicleLabel, 'profile_id': profileId},
        'product': {'id': productId, 'label': productLabel},
        'capabilities': capabilities,
        'compatibility': compatibility,
        'log_quality': logQuality,
        'modifications': modifications,
        'stock_backup': stockEntry ?? {'present': false},
        'data_logs': logEntries,
        'attachments_directory': 'attachments',
      }),
    );
    return file;
  }

  Future<Map<String, dynamic>?> _copyAttachment(
    File? source,
    Directory root,
    String subdir,
  ) async {
    if (source == null || !await source.exists()) return null;
    final targetDir = Directory('${root.path}/$subdir')
      ..createSync(recursive: true);
    final target = File('${targetDir.path}/${source.uri.pathSegments.last}');
    final temporary = File('${target.path}.part');
    if (await temporary.exists()) await temporary.delete();
    await source.copy(temporary.path);
    await temporary.rename(target.path);
    final digest = sha256.convert(await target.readAsBytes()).toString();
    lastAttachments.add(target);
    final relativePath = '$subdir/${source.uri.pathSegments.last}';
    return {
      'file_name': source.uri.pathSegments.last,
      'path': relativePath,
      'sha256': digest,
      'size': await target.length(),
      'present': true,
    };
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
    if (manifest['format'] != 'bimmerscope-tuner-package-v2') {
      errors.add('Unsupported package format');
    }
    final packageDir = Directory(
      '${manifestFile.parent.path}${Platform.pathSeparator}${manifestFile.uri.pathSegments.last.replaceFirst(RegExp(r'\.json$'), '')}',
    );
    final attachments = <Map<String, dynamic>>[];
    final stock = manifest['stock_backup'];
    if (stock is Map && stock['present'] == true) {
      attachments.add(Map<String, dynamic>.from(stock));
    }
    final logs = manifest['data_logs'];
    if (logs is List) {
      for (final entry in logs.whereType<Map>()) {
        attachments.add(Map<String, dynamic>.from(entry));
      }
    }
    for (final entry in attachments) {
      final relative = entry['path'] as String?;
      final expected = entry['sha256'] as String?;
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
      final actual = sha256.convert(await file.readAsBytes()).toString();
      if (actual != expected) errors.add('Hash mismatch: $relative');
    }
    return TunerPackageValidation(valid: errors.isEmpty, errors: errors);
  }
}

class TunerPackageValidation {
  const TunerPackageValidation({required this.valid, required this.errors});
  final bool valid;
  final List<String> errors;
}
