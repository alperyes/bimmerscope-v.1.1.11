class FaultDefinition {
  const FaultDefinition({
    required this.title,
    required this.system,
    required this.explanation,
    required this.nextStep,
  });

  final String title;
  final String system;
  final String explanation;
  final String nextStep;
}

const _definitions = <String, FaultDefinition>{
  '804080': FaultDefinition(
    title: 'Ignition on: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'The vehicle recorded that the ignition remained on long enough to reduce the available starting reserve.',
    nextStep:
        'Check battery state of charge, charging voltage and recent ignition-on activity. Clear the stored fault only after the power supply has been verified.',
  ),
  '8040B9': FaultDefinition(
    title: 'Terminal 30B deactivated: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'The FEM recorded a power-management shutdown of terminal 30B because the calculated starting reserve was too low.',
    nextStep:
        'Check battery condition, battery registration, charging voltage and parasitic draw before replacing parts.',
  ),
  '8040BB': FaultDefinition(
    title: 'Terminal 30B active too long: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'Terminal 30B was recorded as active for too long or the vehicle reached its startability protection limit.',
    nextStep:
        'Check battery state of charge and power-management history, then verify that accessories or the ignition were not left on.',
  ),
  '8041B2': FaultDefinition(
    title: 'Lights active: startability limit reached',
    system: 'Lighting / FEM',
    explanation:
        'The vehicle recorded a startability-limit event while the lights were active during stationary operation.',
    nextStep:
        'Check battery state of charge and charging voltage, and confirm that the lights were not left on while the vehicle was stationary.',
  ),
  '138104': FaultDefinition(
    title: 'Exhaust flap actuator: open circuit',
    system: 'Exhaust system',
    explanation:
        'The DME detected an interrupted electrical connection while commanding the exhaust flap actuator.',
    nextStep:
        'Inspect the actuator connector, wiring and flap mechanism, then follow the BMW test plan before replacing parts.',
  ),
};

FaultDefinition? faultDefinition(String code) =>
    _definitions[code.trim().toUpperCase()];
