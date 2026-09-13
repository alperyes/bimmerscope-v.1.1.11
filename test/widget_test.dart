import 'package:bmw_app/app.dart';
import 'dart:convert';
import 'package:bmw_app/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('restores saved layout styles and migrates channel presets', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'bimmerscope.dashboard_presets_v1': jsonEncode({
        'Track': {
          'visibleSensorIds': ['engine_rpm', 'missing_sensor', 'engine_rpm'],
          'gaugeWidths': {'engine_rpm': 250},
          'gaugeHeights': {'engine_rpm': 210},
          'dialSensorIds': ['engine_rpm'],
          'valueColorIds': ['engine_rpm'],
        },
        'Legacy': ['engine_rpm'],
      }),
    });
    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.pumpAndSettle();
    final dynamic dashboard = tester.state(find.byType(DashboardScreen));
    dashboard.applyCustomDashboardPreset('Track');
    await tester.pump();
    expect(dashboard.visibleSensorIds, ['engine_rpm']);
    expect(dashboard.gaugeWidths['engine_rpm'], 250);
    expect(dashboard.gaugeHeights['engine_rpm'], 210);
    expect(dashboard.dialSensorIds, contains('engine_rpm'));
    expect(dashboard.valueColorIds, contains('engine_rpm'));
    dashboard.applyCustomDashboardPreset('Legacy');
    await tester.pump();
    expect(dashboard.visibleSensorIds, ['engine_rpm']);
    expect(dashboard.gaugeWidths, isEmpty);
    expect(dashboard.gaugeHeights, isEmpty);
    expect(dashboard.dialSensorIds, isEmpty);
    expect(dashboard.valueColorIds, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('restores only known favorite gauges', (tester) async {
    SharedPreferences.setMockInitialValues({
      'bimmerscope.dashboard_favorite_sensors_v1': [
        'engine_rpm',
        'missing_sensor',
      ],
    });
    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.pumpAndSettle();
    final dynamic dashboard = tester.state(find.byType(DashboardScreen));
    expect(dashboard.favoriteSensorIds, {'engine_rpm'});
    await tester.pumpWidget(const SizedBox.shrink());
    SharedPreferences.setMockInitialValues({});
  });

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
    expect(find.text('Automatic pull logging'), findsOneWidget);
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
