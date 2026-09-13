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
    return CalibrationArtifactInspection(
      fileName: fileName,
      sha256: digest,
      size: bytes.length,
      kind: 'opaque_artifact',
      provider: null,
      revision: null,
      declaredCompatibility: null,
      signatureStatus: 'not_verifiable',
      notes: const [
        'Raw calibration artifacts are retained for professional review only.',
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
