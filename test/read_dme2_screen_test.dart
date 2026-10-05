import 'dart:io';

import 'package:bmw_app/tuning/read_dme2_screen.dart';
import 'package:bmw_app/tuning/stock_file_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Read DME 2 shows saved BIN and refreshes after a read', (
    tester,
  ) async {
    final directory = await tester.runAsync(
      () => Directory.systemTemp.createTemp('read_dme2_test_'),
    );
    if (directory == null) throw StateError('Could not create test directory');
    addTearDown(() => directory.delete(recursive: true));
    final store = StockFileStore(directoryProvider: () async => directory);
    const vin = 'WBA3A52010F360747';
    late StockFileBackup sample;
    await tester.runAsync(() async {
      sample = await store.saveBytes(
        bytes: [1, 2, 3],
        vin: vin,
        sourceName: 'n20_bench_memory_probe_sample.bin',
        metadata: {'source': 'live_enet'},
      );
      await store.saveBytes(
        bytes: [9],
        vin: vin,
        sourceName: 'unrelated_import.bin',
      );
    });
    var readCalls = 0;

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReadDme2Screen(
            vin: vin,
            isN20Reference: true,
            canRead: () => true,
            onRead: () async {
              readCalls++;
              await store.saveBytes(
                bytes: [4, 5, 6, 7],
                vin: vin,
                sourceName: 'n20_bench_80180000_7fc00.bin',
              );
            },
            onCancel: () {},
            store: store,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();

    expect(
      find.textContaining('n20_bench_memory_probe_sample.bin'),
      findsOneWidget,
    );
    expect(find.text('Share BIN'), findsOneWidget);
    expect(find.textContaining('unrelated_import.bin'), findsNothing);
    expect(find.textContaining('3 bytes'), findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('read-dme-2-start')));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
    expect(readCalls, 1);
    expect(find.text('Share BIN'), findsNWidgets(2));
    expect(find.textContaining('n20_bench_80180000_7fc00.bin'), findsOneWidget);
    expect(find.textContaining(RegExp(r'^4 bytes ·')), findsOneWidget);

    await tester.tap(find.text('Delete').first);
    await tester.pumpAndSettle();
    expect(find.text('Delete saved BIN?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Cancel'),
      ),
    );
    await tester.pumpAndSettle();
    expect(await tester.runAsync(sample.file.exists), isTrue);
    expect(find.text('Share BIN'), findsNWidgets(2));
    expect(find.textContaining('unrelated_import.bin'), findsNothing);
  });

  test('deleting a managed BIN removes its metadata but keeps other files', () async {
    final directory = await Directory.systemTemp.createTemp('read_dme2_delete_');
    addTearDown(() => directory.delete(recursive: true));
    final store = StockFileStore(directoryProvider: () async => directory);
    const vin = 'WBA3A52010F360747';
    final backup = await store.saveBytes(
      bytes: [1, 2, 3],
      vin: vin,
      sourceName: 'n20_bench_80180000_7fc00.bin',
      metadata: {'source': 'live_enet'},
    );
    final other = await store.saveBytes(
      bytes: [4],
      vin: vin,
      sourceName: 'unrelated_import.bin',
    );

    await store.deleteBackup(file: backup.file, vin: vin);

    expect(await backup.file.exists(), isFalse);
    expect(await File('${backup.file.path}.json').exists(), isFalse);
    expect(await other.file.exists(), isTrue);
  });
}
