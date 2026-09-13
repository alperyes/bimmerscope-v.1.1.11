import 'dart:io';
import 'package:bmw_app/tuning/stock_file_store.dart';
import 'package:bmw_app/logging/data_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bmw_app/logging/log_quality.dart';

void main() {
  test('validates sanitized VIN provenance and quoted CSV fields', () async {
    final directory = await Directory.systemTemp.createTemp('bimmerscope-quality-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/pull.csv');
    await file.writeAsString('''# vehicle,WBS3R92M4TEST\n# vehicle_profile,F82-S55-DCT\ntimestamp,elapsed_ms,sensor_id,sensor_name,value,unit,raw_value,session_id,source\n2026-09-13T20:00:00Z,0,boost,"Boost, absolute",1.2,bar,12,s1,real\n''');
    final report = await inspectLogQuality(
      file,
      vin: 'WBS3R92M4TEST',
      profileId: 'F82-S55-DCT',
    );
    expect(report.provenanceMatches, isTrue);
  });

  test('measures telemetry gaps independently for each channel', () async {
    final directory = await Directory.systemTemp.createTemp('bimmerscope-gap-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/interleaved.csv');
    await file.writeAsString('''# vehicle,WBS3R92M4TEST\n# vehicle_profile,F82-S55-DCT\ntimestamp,elapsed_ms,sensor_id,sensor_name,value,unit,raw_value,session_id,source\nt,0,rpm,RPM,1000,rpm,1,s1,real\nt,0,boost,Boost,1,psi,1,s1,real\nt,1000,rpm,RPM,1100,rpm,1,s1,real\nt,6000,boost,Boost,2,psi,1,s1,real\n''');
    final report = await inspectLogQuality(
      file,
      vin: 'WBS3R92M4TEST',
      profileId: 'F82-S55-DCT',
    );
    expect(report.maxGapMs, 6000);
  });

  test('stock backup artifacts remain distinct and traceable', () {
    final first = stockBackupArtifactName(vin: 'VIN', sourceName: 'stock.bin', timestamp: 1, digest: 'aaa');
    final second = stockBackupArtifactName(vin: 'VIN', sourceName: 'stock.bin', timestamp: 2, digest: 'bbb');
    expect(first, isNot(second));
    expect(first, contains('aaa'));
    expect(second, contains('bbb'));
  });

  test('logger provenance can be tested with injected storage', () async {
    final directory = Directory('${Directory.systemTemp.path}/bimmerscope_log_test')..createSync();
    addTearDown(() => directory.delete(recursive: true));
    final logger = DataLogger(directoryProvider: () async => directory);
    await logger.start(vin: 'TESTVIN', sessionId: 'session_test', source: 'simulator');
    final file = await logger.stop();
    final text = await file!.readAsString();
    expect(text, contains('# session_id,"session_test"'));
    expect(text, contains('# source,"simulator"'));
  });

  test('renaming a log keeps its integrity sidecar paired', () async {
    final directory = await Directory.systemTemp.createTemp('bimmerscope-rename-');
    addTearDown(() => directory.delete(recursive: true));
    final source = File('${directory.path}/original.csv');
    await source.writeAsString('recording');
    final digest = List.filled(64, 'a').join();
    await File('${source.path}.sha256').writeAsString('$digest  original.csv\n');
    final renamed = await DataLogger.renameSavedLog(source, '98 RON pull');
    expect(renamed.uri.pathSegments.last, '98 RON pull.csv');
    expect(await File('${renamed.path}.sha256').exists(), isTrue);
    expect(await File('${source.path}.sha256').exists(), isFalse);
    expect(
      await File('${renamed.path}.sha256').readAsString(),
      contains('98 RON pull.csv'),
    );
    await expectLater(
      DataLogger.renameSavedLog(renamed, '   '),
      throwsArgumentError,
    );
  });

}
