import 'dart:convert';
import 'dart:io';
import 'package:bmw_app/tuning/tuner_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('preserves colliding log filenames and rejects missing selections', () async {
    final root = await Directory.systemTemp.createTemp('package-test-');
    addTearDown(() => root.delete(recursive: true));
    final first = File('${root.path}/one/log.csv');
    final second = File('${root.path}/two/log.csv');
    await first.parent.create();
    await second.parent.create();
    await first.writeAsString('first recording');
    await second.writeAsString('second recording');
    final store = TunerPackageStore(documentsProvider: () async => root);
    Future<File> create(List<String> logs) => store.create(
      vin: 'test', vehicleLabel: 'test', profileId: 'test',
      productId: 'test', productLabel: 'test', capabilities: [],
      stockFileName: null, logFiles: logs, modifications: '',
      compatibility: {}, logQuality: [],
    );
    final manifest = await create([first.path, second.path]);
    expect((await store.validate(manifest)).valid, isTrue);
    final data = jsonDecode(await manifest.readAsString());
    expect(data['data_logs'][0]['path'], isNot(data['data_logs'][1]['path']));
    expect(await store.lastAttachments[0].readAsString(), 'first recording');
    expect(await store.lastAttachments[1].readAsString(), 'second recording');
    await expectLater(create(['${root.path}/missing.csv']), throwsA(isA<FileSystemException>()));
  });
}
