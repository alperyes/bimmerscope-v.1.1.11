import 'package:bmw_app/app.dart';
import 'package:bmw_app/product/product_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sidebar omits destinations kept in bottom navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();

    final drawer = find.byType(Drawer);
    final navigation = find.byType(NavigationBar);
    expect(drawer, findsOneWidget);
    expect(navigation, findsOneWidget);
    for (final destination in [
      'Vehicle',
      'Monitor',
      'Diagnose',
      'Logs',
      if (ProductConfig.tuningEnabled) 'Tune',
    ]) {
      expect(
        find.descendant(of: drawer, matching: find.text(destination)),
        findsNothing,
      );
      expect(
        find.descendant(of: navigation, matching: find.text(destination)),
        findsOneWidget,
      );
    }
    expect(
      find.descendant(of: drawer, matching: find.text('Try demo')),
      findsOneWidget,
    );
  });
}
