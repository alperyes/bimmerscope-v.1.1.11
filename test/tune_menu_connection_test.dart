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
