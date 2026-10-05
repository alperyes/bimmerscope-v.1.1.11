import 'package:bmw_app/diagnostics/fault_definitions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
    expect(definition.nextStep, contains('battery voltage'));
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
    expect(definition.nextStep, contains('voltage during adaptation'));
  });

  test('101401 identifies unmet throttle adaptation conditions', () {
    final definition = faultDefinition('101401');
    expect(definition, isNotNull);
    expect(definition!.title, contains('Throttle valve adaptation'));
    expect(definition.system, contains('DME'));
    expect(definition.nextStep, contains('battery voltage'));
  });

  test('1C3110 resolves to the oil pressure/temperature circuit fault', () {
    final definition = faultDefinition(' 1c3110 ');
    expect(definition, isNotNull);
    expect(definition!.title, contains('oil pressure/temperature sensor'));
    expect(definition.system, contains('DME'));
    expect(definition.nextStep, contains('actual oil pressure'));
  });

  test('804107 resolves to the front interior aerial open circuit', () {
    final definition = faultDefinition('804107');
    expect(definition, isNotNull);
    expect(definition!.title, contains('Front interior aerial'));
    expect(definition.system, contains('FEM'));
    expect(definition.nextStep, contains('connector and wiring'));
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
