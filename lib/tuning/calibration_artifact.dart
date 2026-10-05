import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Read-only inspection for provider-supplied JSON manifests. Raw binaries are
/// deliberately identified but never decoded, patched, or installed here.
class CalibrationArtifactInspection {
  const CalibrationArtifactInspection({
    required this.fileName,
    required this.sha256,
    required this.size,
    required this.kind,
    required this.provider,
    required this.revision,
    required this.declaredCompatibility,
    required this.signatureStatus,
    required this.notes,
    this.filenameVin,
    this.filenameEcuId,
    this.binaryMarker,
  });

  final String fileName;
  final String sha256;
  final int size;
  final String kind;
  final String? provider;
  final String? revision;
  final Map<String, dynamic>? declaredCompatibility;
  final String signatureStatus;
  final List<String> notes;

  /// Filename claims are unverified and are never treated as ECU evidence.
  final String? filenameVin;
  final String? filenameEcuId;
  final String? binaryMarker;

  Map<String, dynamic> toJson() => {
    'file_name': fileName,
    'sha256': sha256,
    'size': size,
    'kind': kind,
    'provider': provider,
    'revision': revision,
    'declared_compatibility': declaredCompatibility,
    'signature_status': signatureStatus,
    'notes': notes,
    'filename_vin': filenameVin,
    'filename_ecu_id': filenameEcuId,
    'binary_marker': binaryMarker,
  };
}

Future<CalibrationArtifactInspection> inspectCalibrationArtifact(
  File file,
) async {
  final bytes = await file.readAsBytes();
  final digest = sha256.convert(bytes).toString();
  final fileName = file.uri.pathSegments.last;
  Map<String, dynamic>? manifest;
  try {
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is Map<String, dynamic> &&
        decoded['format'] == 'bimmerscope-calibration-manifest-v1') {
      manifest = decoded;
    }
  } catch (_) {}
  if (manifest == null) {
    final nameMatch = RegExp(
      r'([A-HJ-NPR-Z0-9]{17})_([0-9A-F]{14})',
      caseSensitive: false,
    ).firstMatch(fileName);
    final marker = _binaryMarker(bytes);
    return CalibrationArtifactInspection(
      fileName: fileName,
      sha256: digest,
      size: bytes.length,
      kind: 'opaque_artifact',
      provider: null,
      revision: null,
      declaredCompatibility: null,
      signatureStatus: 'not_verifiable',
      filenameVin: nameMatch?.group(1)?.toUpperCase(),
      filenameEcuId: nameMatch?.group(2)?.toUpperCase(),
      binaryMarker: marker,
      notes: const [
        'Filename identifiers and binary markers do not verify ECU compatibility.',
      ],
    );
  }
  return CalibrationArtifactInspection(
    fileName: fileName,
    sha256: digest,
    size: bytes.length,
    kind: 'provider_manifest',
    provider: manifest['provider'] as String?,
    revision: manifest['revision'] as String?,
    declaredCompatibility: manifest['compatibility'] as Map<String, dynamic>?,
    signatureStatus: 'declared_but_not_verified',
    notes: const [
      'Manifest signatures require an approved provider public key before they can be trusted.',
    ],
  );
}

String? _binaryMarker(List<int> bytes) {
  // A narrow, passive inspection of the file header. Do not interpret map
  // addresses or claim a format from arbitrary printable data elsewhere.
  final prefix = latin1.decode(bytes.take(256).toList());
  return RegExp(r'MEVD17[._0-9A-Za-z]{1,20}').firstMatch(prefix)?.group(0);
}
