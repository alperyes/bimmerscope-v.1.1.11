import 'package:bmw_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows connection guide on first launch', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BmwEnetApp());
    await tester.pumpAndSettle();
    expect(find.text('BIMMERSCOPE'), findsOneWidget);
    expect(find.text('BMW F-series (2012–2019)'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('renders the dashboard shell', (tester) async {
    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    expect(find.text('BIMMERSCOPE'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(find.text('Vehicle'), findsWidgets);
    await tester.tap(find.text('Monitor').last);
    await tester.pumpAndSettle();
    expect(find.text('Engine RPM'), findsOneWidget);

    await tester.tap(find.text('Diagnostics'));
    await tester.pumpAndSettle();
    expect(find.text('Scan'), findsOneWidget);

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();
    expect(find.text('Data recorder'), findsOneWidget);
    expect(find.text('No saved logs yet'), findsOneWidget);
  });

  testWidgets('keeps monitor usable on a narrow layout', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.tap(find.text('Monitor').last);
    await tester.pumpAndSettle();

    expect(find.text('Engine RPM'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
