import 'dart:io';
import 'package:bmw_app/tuning/stock_file_store.dart';
import 'package:bmw_app/logging/data_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

}
