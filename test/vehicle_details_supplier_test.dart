import 'package:bmw_app/dashboard/dashboard_screen.dart';
import 'package:bmw_app/vehicle/dme_identifier_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats the captured seven-byte component record', () {
    expect(
      formatDmeComponentId('00001CA1029110000'),
      '00001CA1-029.110.000',
    );
    expect(formatDmeComponentId('Not read'), 'Not read');
  });

  testWidgets('vehicle details shows supplier identity in dotted notation', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VehicleDetailsScreen(
          isDark: true,
          vin: 'Not identified',
          gatewayIp: null,
          gatewayPort: 6801,
          identity: null,
          mileageKm: null,
          engineEcuDetected: true,
          engineEcuIdentity: '0F1810',
          engineSupplierCalibration: '00001CA1029110000',
        ),
      ),
    );

    final detailsList = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    ).first;
    await tester.scrollUntilVisible(
      find.text('Supplier software'),
      300,
      scrollable: detailsList,
    );
    expect(find.text('Supplier software'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('00001CA1-029.110.000'),
      200,
      scrollable: detailsList,
    );
    expect(find.text('00001CA1-029.110.000'), findsOneWidget);
  });
}
