import 'package:bmw_app/diagnostics/fault_definitions.dart';
import 'package:bmw_app/diagnostics/generated_dme_fault_definitions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('complete S55 and N20 reference catalogs are present', () {
    expect(s55DmeFaultDefinitions.length, 1093);
    expect(n20DmeFaultDefinitions.length, 1268);
    expect(
      {...s55DmeFaultDefinitions.keys, ...n20DmeFaultDefinitions.keys}.length,
      1582,
    );
  });

  test('generated DME definitions stay scoped to their engine and ECU', () {
    final n20 = faultDefinition(
      '102301',
      engine: 'N20',
      ecu: 'DME (engine control unit)',
    );
    expect(n20?.title, contains('Air mass meter'));
    expect(n20?.explanation, contains('N20 DME'));
    expect(faultDefinition('102301', engine: 'S55', ecu: 'DME'), isNull);
    expect(
      faultDefinition('102301', engine: 'N20', ecu: 'FEM body module'),
      isNull,
    );
  });

  test('different S55 and N20 meanings remain distinct', () {
    final s55 = faultDefinition('1C4121', engine: 'S55', ecu: 'DME');
    final n20 = faultDefinition('1C4121', engine: 'N20', ecu: 'DME');
    expect(s55?.title, contains('not received'));
    expect(n20?.title, contains('inconsistent signal'));
  });

  test('DME coding faults include diagnostic context', () {
    final definition = faultDefinition('021208');
    expect(definition?.title, 'DME coding data missing');
    expect(definition?.explanation, contains('coding data is absent'));
  });

  test('CD9A04 identifies the missing DSC braking-torque message', () {
    final definition = faultDefinition('cd9a04');
    expect(definition, isNotNull);
    expect(definition!.title, contains('braking-torque message missing'));
    expect(definition.explanation, contains('DME/DDE'));
    expect(definition.explanation, contains('DSC'));
  });

  test('CD0487 identifies a FlexRay synchronisation failure', () {
    final definition = faultDefinition('cd0487');
    expect(definition, isNotNull);
    expect(definition!.title, contains('FlexRay synchronisation'));
    expect(definition.system, contains('ZGM'));
  });

  test('80409B identifies the KL15N2 driver circuit fault', () {
    final definition = faultDefinition('80409B');
    expect(definition, isNotNull);
    expect(definition!.title, contains('Terminal 15N2'));
    expect(definition.explanation, contains('short to battery positive'));
    expect(definition.system, contains('FEM'));
  });

  test('80409A identifies the KL15N1 driver circuit fault', () {
    final definition = faultDefinition('80409A');
    expect(definition, isNotNull);
    expect(definition!.title, contains('Terminal 15N1'));
    expect(definition.explanation, contains('short to battery positive'));
    expect(definition.system, contains('FEM'));
  });

  test('101410 identifies low voltage during throttle adaptation', () {
    final definition = faultDefinition('101410');
    expect(definition, isNotNull);
    expect(definition!.title, contains('battery voltage too low'));
    expect(definition.system, contains('DME'));
  });

  test('101401 identifies unmet throttle adaptation conditions', () {
    final definition = faultDefinition('101401');
    expect(definition, isNotNull);
    expect(definition!.title, contains('Throttle valve adaptation'));
    expect(definition.system, contains('DME'));
  });

  test('1C3110 resolves to the oil pressure/temperature circuit fault', () {
    final definition = faultDefinition(' 1c3110 ');
    expect(definition, isNotNull);
    expect(definition!.title, contains('oil pressure/temperature sensor'));
    expect(definition.system, contains('DME'));
  });

  test('804107 resolves to the front interior aerial open circuit', () {
    final definition = faultDefinition('804107');
    expect(definition, isNotNull);
    expect(definition!.title, contains('Front interior aerial'));
    expect(definition.system, contains('FEM'));
  });

  test('D91681 resolves to a missing voltage network message', () {
    final definition = faultDefinition('d91681');
    expect(definition, isNotNull);
    expect(definition!.title, contains('voltage message missing'));
    expect(definition.explanation, contains('DME/DDE'));
    expect(
      definition.explanation,
      contains('not by itself proof of low voltage'),
    );
  });

  test('D917F9 resolves to missing drivetrain data from DME', () {
    final definition = faultDefinition('D917F9');
    expect(definition, isNotNull);
    expect(definition!.title, contains('Drivetrain data 2'));
    expect(definition.explanation, contains('0x3F9'));
    expect(definition.explanation, contains('DME/DDE'));
  });

  test('D91FF9 uses its own drivetrain message identifier', () {
    final definition = faultDefinition('d91ff9');
    expect(definition, isNotNull);
    expect(definition!.title, contains('ID 230.0.2'));
    expect(definition.explanation, contains('D917F9'));
  });
}
