import 'package:bmw_app/logging/logging_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('auto pull card separates settings from its switch', (
    tester,
  ) async {
    var enabled = false;
    var toggleCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => LoggingScreen(
            isDark: true,
            onToggleTheme: () {},
            onShowGuide: () {},
            connectionLabel: 'Monitoring',
            isRecording: false,
            sampleCount: 0,
            elapsed: Duration.zero,
            canRecord: true,
            isConnected: true,
            onToggleRecording: () async {},
            autoLogEnabled: enabled,
            autoLogThreshold: 70,
            autoLogReleaseDelaySeconds: 3,
            onAutoLogChanged: (value) async {
              toggleCalls++;
              setState(() => enabled = value);
              return true;
            },
            onAutoLogThresholdChanged: (_) async {},
            onAutoLogReleaseDelayChanged: (_) async {},
            previewMode: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final card = find.byKey(const Key('logs-auto-pull-settings'));
    final toggle = find.byKey(const Key('logs-auto-pull-toggle'));
    expect(card, findsOneWidget);
    expect(toggle, findsOneWidget);
    expect(find.text('Off · starts at 70% throttle'), findsOneWidget);

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(toggleCalls, 1);
    expect(enabled, isTrue);
    expect(find.text('On · starts at 70% throttle'), findsOneWidget);

    await tester.tap(find.text('Auto pull'));
    await tester.pumpAndSettle();
    expect(find.text('Automatic pull logging'), findsWidgets);
  });

  testWidgets('auto pull card fits a narrow phone', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: LoggingScreen(
          isDark: true,
          onToggleTheme: () {},
          onShowGuide: () {},
          connectionLabel: 'Disconnected',
          isRecording: false,
          sampleCount: 0,
          elapsed: Duration.zero,
          canRecord: false,
          isConnected: false,
          onToggleRecording: () async {},
          autoLogEnabled: false,
          autoLogThreshold: 70,
          autoLogReleaseDelaySeconds: 3,
          onAutoLogChanged: (_) async => true,
          onAutoLogThresholdChanged: (_) async {},
          onAutoLogReleaseDelayChanged: (_) async {},
          previewMode: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('logs-auto-pull-settings')), findsOneWidget);
    expect(
      tester
          .widget<Switch>(find.byKey(const Key('logs-auto-pull-toggle')))
          .onChanged,
      isNull,
    );
    expect(find.text('Start live monitoring first'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saved auto pull preference is paused without monitoring', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoggingScreen(
          isDark: true,
          onToggleTheme: () {},
          onShowGuide: () {},
          connectionLabel: 'Connected',
          isRecording: false,
          sampleCount: 0,
          elapsed: Duration.zero,
          canRecord: false,
          isConnected: true,
          onToggleRecording: () async {},
          autoLogEnabled: true,
          autoLogThreshold: 70,
          autoLogReleaseDelaySeconds: 3,
          onAutoLogChanged: (_) async => true,
          onAutoLogThresholdChanged: (_) async {},
          onAutoLogReleaseDelayChanged: (_) async {},
          previewMode: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final toggle = tester.widget<Switch>(
      find.byKey(const Key('logs-auto-pull-toggle')),
    );
    expect(toggle.value, isTrue);
    expect(toggle.onChanged, isNull);
    expect(find.text('Paused · start live monitoring first'), findsOneWidget);
  });
}
