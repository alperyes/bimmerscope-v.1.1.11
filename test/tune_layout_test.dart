import 'package:bmw_app/app.dart';
import 'package:bmw_app/product/product_config.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tune primary actions fit a phone viewport', (tester) async {
    if (!ProductConfig.tuningEnabled) return;
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const BmwEnetApp(previewMode: true));
    await tester.pumpAndSettle();

    final checkVehicle = find.byKey(const Key('tune-check-vehicle-button'));
    final hero = find.byKey(const Key('tune-hero-card'));
    final readDme2 = find.byKey(const Key('tune-read-dme-2'));
    final status = find.byKey(const Key('tune-dme-status-strip'));
    final identity = find.byKey(const Key('tune-dme-identity-open'));
    final tunerRequest = find.byKey(const Key('tune-request-open'));
    final navigation = find.byType(NavigationBar);
    expect(checkVehicle, findsOneWidget);
    expect(hero, findsOneWidget);
    expect(tester.getSize(hero).height, appTopActionCardHeight);
    expect(tester.getRect(hero).left, 16);
    expect(find.byKey(const Key('tune-read-dme')), findsNothing);
    expect(readDme2, findsOneWidget);
    expect(status, findsOneWidget);
    expect(identity, findsOneWidget);
    expect(tunerRequest, findsOneWidget);
    expect(
      tester.getRect(readDme2).top,
      greaterThan(tester.getRect(checkVehicle).bottom),
    );
    expect(
      tester.getRect(status).top,
      greaterThan(tester.getRect(readDme2).bottom),
    );
    expect(
      tester.getRect(tunerRequest).bottom,
      lessThanOrEqualTo(tester.getRect(navigation).top),
    );
    expect(tester.takeException(), isNull);
  });
}
