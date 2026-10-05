import 'package:bmw_app/app.dart';
import 'package:bmw_app/product/product_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Tune menu actions are disabled without a connection', (
    tester,
  ) async {
    if (!ProductConfig.tuningEnabled) return;
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tune').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tune-read-dme')), findsNothing);
    final readDme2 = find.byKey(const Key('tune-read-dme-2'));
    expect(readDme2, findsOneWidget);
    expect(tester.widget<OutlinedButton>(readDme2).onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('tune-read-dme-2')));
    await tester.pumpAndSettle();
    expect(find.text('Saved reads'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('read-dme-2-start')))
          .onPressed,
      isNull,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    final dmeStatus = find.byKey(const Key('tune-dme-status-strip'));
    expect(dmeStatus, findsOneWidget);
    expect(
      find.descendant(of: dmeStatus, matching: find.text('DME software')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dmeStatus, matching: find.text('Unlock status')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dmeStatus, matching: find.text('Unverified')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dmeStatus, matching: find.text('Stock backup')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dmeStatus, matching: find.text('None')),
      findsOneWidget,
    );

    for (final key in [
      'tune-dme-identity-open',
      'tune-check-unlock-open',
      'tune-flash-map-open',
      'tune-flash-stock-open',
      'tune-request-open',
    ]) {
      final action = find.byKey(Key(key));
      expect(action, findsOneWidget);
      expect(tester.widget<InkWell>(action).onTap, isNull);
    }
  });
}
