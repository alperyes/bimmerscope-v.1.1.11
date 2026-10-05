import 'dart:io';
import 'dart:convert';
import 'package:bmw_app/tuning/stock_file_store.dart';
import 'package:bmw_app/logging/data_logger.dart';
import 'package:bmw_app/logging/logging_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bmw_app/logging/log_quality.dart';

void main() {
  test('validates sanitized VIN provenance and quoted CSV fields', () async {
    final directory = await Directory.systemTemp.createTemp(
      'bimmerscope-quality-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/pull.csv');
    await file.writeAsString(
      '''# vehicle,WBS3R92M4TEST\n# vehicle_profile,F82-S55-DCT\ntimestamp,elapsed_ms,sensor_id,sensor_name,value,unit,raw_value,session_id,source\n2026-09-13T20:00:00Z,0,boost,"Boost, absolute",1.2,bar,12,s1,real\n''',
    );
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
    await file.writeAsString(
      '''# vehicle,WBS3R92M4TEST\n# vehicle_profile,F82-S55-DCT\ntimestamp,elapsed_ms,sensor_id,sensor_name,value,unit,raw_value,session_id,source\nt,0,rpm,RPM,1000,rpm,1,s1,real\nt,0,boost,Boost,1,psi,1,s1,real\nt,1000,rpm,RPM,1100,rpm,1,s1,real\nt,6000,boost,Boost,2,psi,1,s1,real\n''',
    );
    final report = await inspectLogQuality(
      file,
      vin: 'WBS3R92M4TEST',
      profileId: 'F82-S55-DCT',
    );
    expect(report.maxGapMs, 6000);
  });

  test('stock backup artifacts remain distinct and traceable', () {
    final first = stockBackupArtifactName(
      vin: 'VIN',
      sourceName: 'stock.bin',
      timestamp: 1,
      digest: 'aaa',
    );
    final second = stockBackupArtifactName(
      vin: 'VIN',
      sourceName: 'stock.bin',
      timestamp: 2,
      digest: 'bbb',
    );
    expect(first, isNot(second));
    expect(first, contains('aaa'));
    expect(second, contains('bbb'));
  });

  test('import preserves metadata and history excludes sidecars', () async {
    final directory = await Directory.systemTemp.createTemp(
      'bimmerscope-stock-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final source = File('${directory.path}/bench.bin');
    await source.writeAsBytes([0, 1, 2, 3]);
    final store = StockFileStore(directoryProvider: () async => directory);

    final first = await store.importFile(
      sourcePath: source.path,
      vin: 'BENCH',
      metadata: {
        'source': 'imported_file',
        'readStatus': 'compatibility_unverified',
      },
    );
    final second = await store.importFile(
      sourcePath: source.path,
      vin: 'BENCH',
    );
    final history = await store.loadAll('BENCH');
    final metadata =
        jsonDecode(
              await File('${first.file.path}.metadata.json').readAsString(),
            )
            as Map<String, dynamic>;

    expect(first.file.path, isNot(second.file.path));
    expect(history, hasLength(2));
    expect(metadata['source'], 'imported_file');
    expect(metadata['sha256'], sha256.convert([0, 1, 2, 3]).toString());
  });

  test('logger provenance can be tested with injected storage', () async {
    final directory = Directory(
      '${Directory.systemTemp.path}/bimmerscope_log_test',
    )..createSync();
    addTearDown(() => directory.delete(recursive: true));
    final logger = DataLogger(directoryProvider: () async => directory);
    await logger.start(
      vin: 'TESTVIN',
      sessionId: 'session_test',
      source: 'simulator',
    );
    final file = await logger.stop();
    final text = await file!.readAsString();
    expect(text, contains('# session_id,"session_test"'));
    expect(text, contains('# source,"simulator"'));
    final metadata =
        jsonDecode(await File('${file.path}.metadata.json').readAsString())
            as Map<String, dynamic>;
    expect(metadata['format'], 'bimmerscope-log-metadata-v1');
    expect(metadata['csv_file'], file.uri.pathSegments.last);
    expect(metadata['csv_sha256'], logger.lastSha256);
    expect(metadata['capture']['session_id'], 'session_test');
    expect(metadata.containsKey('markers'), isFalse);
  });

  test('renaming a log keeps its integrity sidecar paired', () async {
    final directory = await Directory.systemTemp.createTemp(
      'bimmerscope-rename-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final source = File('${directory.path}/original.csv');
    await source.writeAsString('recording');
    final digest = List.filled(64, 'a').join();
    await File(
      '${source.path}.sha256',
    ).writeAsString('$digest  original.csv\n');
    await File('${source.path}.metadata.json').writeAsString(
      jsonEncode({
        'format': 'bimmerscope-log-metadata-v1',
        'csv_file': 'original.csv',
      }),
    );
    final renamed = await DataLogger.renameSavedLog(source, '98 RON pull');
    expect(renamed.uri.pathSegments.last, '98 RON pull.csv');
    expect(await File('${renamed.path}.sha256').exists(), isTrue);
    expect(await File('${renamed.path}.metadata.json').exists(), isTrue);
    expect(await File('${source.path}.sha256').exists(), isFalse);
    expect(
      await File('${renamed.path}.sha256').readAsString(),
      contains('98 RON pull.csv'),
    );
    expect(
      jsonDecode(
        await File('${renamed.path}.metadata.json').readAsString(),
      )['csv_file'],
      '98 RON pull.csv',
    );
    await expectLater(
      DataLogger.renameSavedLog(renamed, '   '),
      throwsArgumentError,
    );
  });

  test('reports whether log metadata still matches the CSV', () async {
    final directory = await Directory.systemTemp.createTemp(
      'bimmerscope-provenance-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final csv = File('${directory.path}/pull.csv');
    await csv.writeAsString('recording');
    await File('${csv.path}.metadata.json').writeAsString(
      jsonEncode({
        'format': 'bimmerscope-log-metadata-v1',
        'csv_sha256': sha256.convert(await csv.readAsBytes()).toString(),
      }),
    );
    expect((await inspectLogProvenance(csv)).matchesCsv, isTrue);
    await csv.writeAsString('changed');
    expect((await inspectLogProvenance(csv)).matchesCsv, isFalse);
  });
}
