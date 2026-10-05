import 'dart:convert';
import 'dart:io';

import 'package:bmw_app/tuning/calibration_artifact.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps an opaque calibration artifact read-only', () async {
    final directory = await Directory.systemTemp.createTemp(
      'bimmerscope_artifact_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}${Platform.pathSeparator}unknown.bin');
    await file.writeAsBytes([0, 1, 2, 3]);

    final inspection = await inspectCalibrationArtifact(file);

    expect(inspection.kind, 'opaque_artifact');
    expect(inspection.signatureStatus, 'not_verifiable');
    expect(inspection.declaredCompatibility, isNull);
  });

  test('identifies but does not trust a declared provider manifest', () async {
    final directory = await Directory.systemTemp.createTemp(
      'bimmerscope_artifact_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File(
      '${directory.path}${Platform.pathSeparator}manifest.json',
    );
    await file.writeAsString(
      jsonEncode({
        'format': 'bimmerscope-calibration-manifest-v1',
        'provider': 'Example Tuning',
        'revision': 'r2',
        'compatibility': {'vehicle': 'F82', 'engine': 'S55'},
      }),
    );

    final inspection = await inspectCalibrationArtifact(file);

    expect(inspection.kind, 'provider_manifest');
    expect(inspection.provider, 'Example Tuning');
    expect(inspection.revision, 'r2');
    expect(inspection.signatureStatus, 'declared_but_not_verified');
    expect(inspection.declaredCompatibility, {
      'vehicle': 'F82',
      'engine': 'S55',
    });
  });

  test('inspects bench BIN hints without claiming compatibility', () async {
    final directory = await Directory.systemTemp.createTemp('bimmerscope-bin-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(
      '${directory.path}${Platform.pathSeparator}WBA3A52010F360747_00001C9F1D9601.bin',
    );
    await file.writeAsBytes([
      ...List<int>.filled(26, 0),
      ...ascii.encode('MEVD1729__'),
      ...List<int>.filled(64, 0),
    ]);

    final inspection = await inspectCalibrationArtifact(file);

    expect(inspection.filenameVin, 'WBA3A52010F360747');
    expect(inspection.filenameEcuId, '00001C9F1D9601');
    expect(inspection.binaryMarker, 'MEVD1729__');
    expect(inspection.kind, 'opaque_artifact');
    expect(inspection.signatureStatus, 'not_verifiable');
  });
}
