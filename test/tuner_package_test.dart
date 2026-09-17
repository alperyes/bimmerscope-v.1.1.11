import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:bmw_app/tuning/tuner_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'preserves colliding log filenames and rejects missing selections',
    () async {
      final root = await Directory.systemTemp.createTemp('package-test-');
      addTearDown(() => root.delete(recursive: true));
      final first = File('${root.path}/one/log.csv');
      final second = File('${root.path}/two/log.csv');
      await first.parent.create();
      await second.parent.create();
      await first.writeAsString('first recording');
      await second.writeAsString('second recording');
      await File('${first.path}.sha256').writeAsString('integrity sidecar');
      await File('${first.path}.metadata.json').writeAsString(
        jsonEncode({
          'format': 'bimmerscope-log-metadata-v1',
          'csv_sha256': sha256.convert(await first.readAsBytes()).toString(),
        }),
      );
      final store = TunerPackageStore(documentsProvider: () async => root);
      Future<File> create(List<String> logs) => store.create(
        vin: 'test',
        vehicleLabel: 'test',
        profileId: 'test',
        productId: 'test',
        productLabel: 'test',
        capabilities: [],
        stockFileName: null,
        logFiles: logs,
        modifications: '',
        compatibility: {},
        logQuality: [],
        fuel: '98 RON',
        hardware: 'Stock turbos',
        mileageKm: 84231,
      );
      final manifest = await create([first.path, second.path]);
      expect((await store.validate(manifest)).valid, isTrue);
      final data = jsonDecode(await manifest.readAsString());
      expect(data['format'], 'bimmerscope-tuner-package-v3');
      expect(data['vehicle']['mileage_km'], 84231);
      expect(data['request_details'], {
        'fuel': '98 RON',
        'hardware': 'Stock turbos',
        'modifications': '',
      });
      expect(data['data_logs'][0]['path'], isNot(data['data_logs'][1]['path']));
      expect(data['data_logs'][0]['sidecars'], hasLength(2));
      expect(await store.lastAttachments[0].readAsString(), 'first recording');
      final zip = await store.createArchive(manifest);
      final decoded = ZipDecoder().decodeBytes(await zip.readAsBytes());
      expect(decoded.files.length, 5);
      final packagedManifest = jsonDecode(
        utf8.decode(decoded.files.first.content),
      );
      final folder = packagedManifest['attachments_directory'];
      for (final entry in packagedManifest['data_logs']) {
        final archived = decoded.files.singleWhere(
          (f) => f.name == '$folder/${entry['path']}',
        );
        expect(archived.content.length, entry['size']);
        expect(sha256.convert(archived.content).toString(), entry['sha256']);
        for (final sidecar in entry['sidecars']) {
          final archivedSidecar = decoded.files.singleWhere(
            (file) => file.name == '$folder/${sidecar['path']}',
          );
          expect(archivedSidecar.content.length, sidecar['size']);
          expect(
            sha256.convert(archivedSidecar.content).toString(),
            sidecar['sha256'],
          );
        }
      }
      // Reopen with a new store: export must not rely on lastAttachments state.
      final reopened = TunerPackageStore(documentsProvider: () async => root);
      expect(await (await reopened.createArchive(manifest)).exists(), isTrue);
      final attachment = store.lastAttachments.first;
      final originalBytes = await attachment.readAsBytes();
      final altered = List<int>.from(originalBytes);
      altered[0] ^= 1;
      await attachment.writeAsBytes(altered);
      expect(
        (await reopened.validate(manifest)).errors,
        contains(startsWith('Hash mismatch:')),
      );
      await expectLater(reopened.createArchive(manifest), throwsStateError);
      await attachment.writeAsBytes(originalBytes.take(2).toList());
      expect(
        (await reopened.validate(manifest)).errors,
        contains(startsWith('Size mismatch:')),
      );
      await attachment.delete();
      expect(
        (await reopened.validate(manifest)).errors,
        contains(startsWith('Missing attachment:')),
      );
      await expectLater(reopened.createArchive(manifest), throwsStateError);
      await expectLater(
        create(['${root.path}/missing.csv']),
        throwsA(isA<FileSystemException>()),
      );
    },
  );

  test(
    'rejects a bundled metadata sidecar that does not match its CSV',
    () async {
      final root = await Directory.systemTemp.createTemp('package-metadata-');
      addTearDown(() => root.delete(recursive: true));
      final log = File('${root.path}/pull.csv');
      await log.writeAsString('recording');
      await File('${log.path}.metadata.json').writeAsString(
        jsonEncode({
          'format': 'bimmerscope-log-metadata-v1',
          'csv_sha256': List.filled(64, '0').join(),
        }),
      );
      final store = TunerPackageStore(documentsProvider: () async => root);
      final manifest = await store.create(
        vin: 'test',
        vehicleLabel: 'test',
        profileId: 'test',
        productId: 'test',
        productLabel: 'test',
        capabilities: const [],
        stockFileName: null,
        logFiles: [log.path],
        modifications: '',
        compatibility: const {},
        logQuality: const [],
      );

      expect(
        (await store.validate(manifest)).errors,
        contains('Log metadata does not match CSV: logs/pull.csv'),
      );
    },
  );
}
