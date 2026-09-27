import 'dart:io';

import 'package:bmw_app/diagnostics/app_diagnostics_screen.dart';
import 'package:bmw_app/diagnostics/app_diagnostics_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _ArchiveStore extends AppDiagnosticsStore {
  _ArchiveStore(this.archive);

  final File archive;

  @override
  Future<List<File>> list() async => [archive];

  @override
  Future<AppDiagnosticsLevel> level() async => AppDiagnosticsLevel.normal;
}

void main() {
  testWidgets('renders an archived session without a Material assertion', (
    tester,
  ) async {
    final archive = File('BimmerScope_Session_test.jsonl');

    await tester.pumpWidget(
      MaterialApp(
        home: AppDiagnosticsScreen(isDark: true, store: _ArchiveStore(archive)),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('1 matching file'), findsOneWidget);
    expect(find.text('Reading session…'), findsOneWidget);
  });
}
