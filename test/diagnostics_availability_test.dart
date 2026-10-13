import 'package:bmw_app/diagnostics/diagnostics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('manual message opens for a connected vehicle', (tester) async {
    SharedPreferences.setMockInitialValues({});
    Future<void> noop() async {}
    Widget screen({required bool simulator}) => MaterialApp(
      home: Scaffold(
        body: DiagnosticsScreen(
          isDark: true,
          onToggleTheme: () {},
          onShowGuide: () {},
          connectionLabel: 'Connected',
          vin: 'WBA3A52010F360747',
          simulatorMode: simulator,
          onBeforeVehicleScan: noop,
          onAfterVehicleScan: noop,
        ),
      ),
    );

    await tester.pumpWidget(screen(simulator: true));
    await tester.pumpAndSettle();
    final button = find.byKey(const Key('diagnostics-manual-message-button'));
    expect(tester.widget<OutlinedButton>(button).onPressed, isNull);

    await tester.pumpWidget(screen(simulator: false));
    await tester.pumpAndSettle();
    expect(tester.widget<OutlinedButton>(button).onPressed, isNotNull);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('UDS request (hex bytes)'), findsOneWidget);
    expect(find.text('Send message'), findsOneWidget);
  });

  testWidgets('diagnostics status follows scan availability', (tester) async {
    SharedPreferences.setMockInitialValues({});

    Widget screen(String connectionLabel) => MaterialApp(
      home: Scaffold(
        body: DiagnosticsScreen(
          isDark: true,
          onToggleTheme: () {},
          onShowGuide: () {},
          connectionLabel: connectionLabel,
          vin: '',
        ),
      ),
    );

    await tester.pumpWidget(screen('Disconnected'));
    await tester.pumpAndSettle();
    final status = find.byKey(const Key('diagnostics-availability-state'));
    final scan = find.byKey(const Key('diagnostics-scan-button'));
    expect(
      find.descendant(of: status, matching: find.text('Not connected')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: status,
        matching: find.byIcon(Icons.link_off_rounded),
      ),
      findsOneWidget,
    );
    expect(tester.widget<FilledButton>(scan).onPressed, isNull);

    await tester.pumpWidget(screen('Monitoring'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: status, matching: find.text('Ready to scan')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: status,
        matching: find.byIcon(Icons.manage_search_rounded),
      ),
      findsOneWidget,
    );
    expect(tester.widget<FilledButton>(scan).onPressed, isNotNull);
  });

  testWidgets('DME reset requires confirmation and brackets the request', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final operations = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DiagnosticsScreen(
            isDark: true,
            onToggleTheme: () {},
            onShowGuide: () {},
            connectionLabel: 'Connected',
            vin: 'WBA3A52010F360747',
            onBeforeVehicleScan: () async => operations.add('pause'),
            onAfterVehicleScan: () async => operations.add('resume'),
            onResetDme: (vin) async => operations.add('reset:$vin'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final resetButton = find.byKey(const Key('diagnostics-reset-dme-button'));
    expect(tester.widget<OutlinedButton>(resetButton).onPressed, isNotNull);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    expect(find.textContaining('Turn the engine off'), findsOneWidget);
    expect(operations, isEmpty);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(operations, isEmpty);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset DME'));
    await tester.pumpAndSettle();
    expect(operations, ['pause', 'reset:WBA3A52010F360747', 'resume']);
    expect(find.text('DME has been successfully reset.'), findsOneWidget);
  });
}
