import 'package:bmw_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('vehicle actions sit beneath artwork and respect availability', (
    tester,
  ) async {
    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.pumpAndSettle();

    final artwork = find.byKey(const Key('vehicle-artwork'));
    final details = find.byKey(const Key('vehicle-details-action'));
    final flap = find.byKey(const Key('vehicle-flap-action'));
    expect(artwork, findsOneWidget);
    expect(details, findsOneWidget);
    expect(flap, findsOneWidget);
    expect(
      tester.getRect(details).top,
      greaterThan(tester.getRect(artwork).bottom),
    );
    expect(tester.getRect(details).top, tester.getRect(flap).top);
    expect(tester.widget<InkWell>(details).onTap, isNull);
    expect(tester.widget<InkWell>(flap).onTap, isNull);
  });

  testWidgets('vehicle actions stack on a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.pumpAndSettle();

    final details = find.byKey(const Key('vehicle-details-action'));
    final flap = find.byKey(const Key('vehicle-flap-action'));
    expect(
      tester.getRect(flap).top,
      greaterThan(tester.getRect(details).bottom),
    );
    expect(tester.takeException(), isNull);
  });
}
