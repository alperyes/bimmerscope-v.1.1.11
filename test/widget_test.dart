import 'package:bmw_app/app.dart';
import 'dart:convert';
import 'package:bmw_app/dashboard/dashboard_screen.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:bmw_app/diagnostics/diagnostics_screen.dart';
import 'package:bmw_app/onboarding/connection_guide_screen.dart';
import 'package:bmw_app/product/product_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('connection chip normalizes phases and marks demo sessions', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConnectionStatusChip(
            label: 'Identifying',
            isDark: true,
            iconOnly: true,
            isDemo: true,
          ),
        ),
      ),
    );

    expect(find.text('DEMO'), findsOneWidget);
    expect(
      find.byTooltip('Demo mode. Connection status: Connecting'),
      findsOneWidget,
    );
  });

  test('connection labels use the shared semantic status tones', () {
    expect(AppPalette.connectionTone('Connected'), AppStatusTone.success);
    expect(AppPalette.connectionTone('Connecting'), AppStatusTone.active);
    expect(AppPalette.connectionTone('Reconnecting'), AppStatusTone.active);
    expect(AppPalette.connectionTone('Recovering'), AppStatusTone.warning);
    expect(AppPalette.connectionTone('Error'), AppStatusTone.danger);
    expect(AppPalette.connectionTone('Connection'), AppStatusTone.neutral);
  });

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

  testWidgets('connection guide scrolls on a compact phone viewport', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: ConnectionGuideScreen(
          isDark: true,
          firstLaunch: true,
          onDone: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip setup'), findsOneWidget);
    expect(find.text('Compatibility'), findsOneWidget);
    expect(find.text('Supported adapters'), findsOneWidget);
    expect(tester.getRect(find.text('Next')).bottom, lessThan(600));
    expect(tester.takeException(), isNull);

    final safetyCopy = find.text(
      'Set up the dashboard while parked. Mount your phone securely and never run diagnostics while moving.',
    );
    await tester.ensureVisible(safetyCopy);
    await tester.pumpAndSettle();

    expect(safetyCopy, findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip setup'), findsOneWidget);
    expect(tester.getRect(find.text('Next')).bottom, lessThan(600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the dashboard shell', (tester) async {
    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    expect(find.text('BIMMERSCOPE'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(find.text('Vehicle'), findsWidgets);
    final connectSize = tester.getSize(
      find.byKey(const Key('vehicle-connect-button')),
    );
    expect(connectSize.height, 48);
    await tester.tap(find.text('Monitor').last);
    await tester.pumpAndSettle();
    expect(find.text('Engine RPM'), findsOneWidget);
    final monitorAction = find.byKey(const Key('monitor-primary-action'));
    expect(monitorAction, findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    final startSize = tester.getSize(monitorAction);
    expect(startSize.height, connectSize.height);
    expect(startSize.width, connectSize.width);
    expect(
      tester.getRect(monitorAction).bottom,
      lessThanOrEqualTo(tester.getRect(find.byType(NavigationBar)).top),
    );

    await tester.tap(find.text('Diagnose'));
    await tester.pumpAndSettle();
    expect(monitorAction, findsNothing);
    expect(find.text('Scan'), findsOneWidget);
    final scanSize = tester.getSize(
      find.byKey(const Key('diagnostics-scan-button')),
    );
    expect(scanSize.height, connectSize.height);
    expect(scanSize.width, connectSize.width);

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();
    expect(find.text('Data Recorder'), findsOneWidget);
    expect(find.text('Auto pull'), findsOneWidget);
    expect(find.text('No saved logs yet'), findsOneWidget);

    if (ProductConfig.tuningEnabled) {
      await tester.tap(find.text('Tune').last);
      await tester.pumpAndSettle();
      final checkVehicleSize = tester.getSize(
        find.byKey(const Key('tune-check-vehicle-button')),
      );
      expect(checkVehicleSize, connectSize);

      final unlockEntry = find.byKey(const Key('tune-check-unlock-open'));
      await tester.ensureVisible(unlockEntry);
      await tester.tap(unlockEntry);
      await tester.pumpAndSettle();
      expect(find.text('Unlock status result'), findsOneWidget);
      expect(find.textContaining('informational only'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();

      final tunerRequestEntry = find.byKey(const Key('tune-request-open'));
      await tester.ensureVisible(tunerRequestEntry);
      await tester.drag(find.byType(ListView).first, const Offset(0, -220));
      await tester.pumpAndSettle();
      await tester.tap(tunerRequestEntry);
      await tester.pumpAndSettle();
      expect(find.text('Tuner Request'), findsOneWidget);
      expect(find.text('Stock file & backups'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(tunerRequestEntry, findsOneWidget);

      final flashMapButton = find.byKey(const Key('tune-flash-map-open'));
      await tester.ensureVisible(flashMapButton);
      await tester.tap(flashMapButton);
      await tester.pumpAndSettle();
      expect(
        find.text('Map flashing is not available in this version.'),
        findsOneWidget,
      );
      expect(
        find.text('No ECU programming or calibration writing is enabled.'),
        findsOneWidget,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();

      final stockButton = find.byKey(const Key('tune-flash-stock-open'));
      await tester.ensureVisible(stockButton);
      await tester.tap(stockButton);
      await tester.pumpAndSettle();
      expect(
        find.text('Stock restoration is not available in this version.'),
        findsOneWidget,
      );
    }
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

  testWidgets('diagnostics state and scan action follow the live connection', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    Widget diagnostics(String connectionLabel) => MaterialApp(
      home: Scaffold(
        drawer: const Drawer(),
        body: DiagnosticsScreen(
          isDark: true,
          onToggleTheme: () {},
          onShowGuide: () {},
          connectionLabel: connectionLabel,
          vin: '',
        ),
      ),
    );

    await tester.pumpWidget(diagnostics('Connection'));
    await tester.pumpAndSettle();
    expect(find.text('Connect vehicle'), findsWidgets);
    expect(
      find.text('Connect the ENET cable and switch the ignition on.'),
      findsNothing,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('diagnostics-scan-button')),
          )
          .onPressed,
      isNull,
    );

    await tester.pumpWidget(diagnostics('Monitoring'));
    await tester.pumpAndSettle();
    expect(find.text('Ready to scan'), findsWidgets);
    expect(
      find.text('Connect the ENET cable and switch the ignition on.'),
      findsNothing,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('diagnostics-scan-button')),
          )
          .onPressed,
      isNotNull,
    );

    await tester.pumpWidget(diagnostics('Scanning'));
    await tester.pumpAndSettle();
    expect(find.byType(PopupMenuButton<String>), findsNothing);
    expect(find.text('Live monitor pauses during scanning'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('diagnostics-scan-button')),
          )
          .onPressed,
      isNull,
    );
  });
}
