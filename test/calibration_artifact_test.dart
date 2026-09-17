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
}
