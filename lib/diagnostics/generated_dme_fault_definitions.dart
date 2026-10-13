// Generated from the S55/N20 DME B1V reference workbook and original N20 B1V.
// These are conservative app summaries, not BMW test-plan interpretations.
// Regenerate with tool/generate_dme_fault_catalog.py; hand-written entries win.
import 'fault_definitions.dart';

const s55DmeFaultDefinitions = <String, FaultDefinition>{
  '021200': FaultDefinition(
    title: 'DME report: energy-saving mode active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: energy-saving mode active. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '021208': FaultDefinition(
    title: 'DME, coding — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: not received. The code alone does not establish which part caused it.',
  ),
  '021209': FaultDefinition(
    title: 'DME, coding — spelling error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: spelling error. The code alone does not establish which part caused it.',
  ),
  '02120A': FaultDefinition(
    title: 'DME, coding — Signature verification incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: signature verification incorrect. The code alone does not establish which part caused it.',
  ),
  '02120B': FaultDefinition(
    title: 'DME, coding — VIN wrong',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: vin wrong. The code alone does not establish which part caused it.',
  ),
  '02120C': FaultDefinition(
    title: 'DME, coding — data inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: data inconsistent. The code alone does not establish which part caused it.',
  ),
  '02FF12': FaultDefinition(
    title: 'Error memory entry — only for testing',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving error memory entry: only for testing. The code alone does not establish which part caused it.',
  ),
  '100001': FaultDefinition(
    title: 'Throttle valve, function — clamps for a short time',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, function: clamps for a short time. The code alone does not establish which part caused it.',
  ),
  '100101': FaultDefinition(
    title: 'Throttle valve, function — clamps permanently',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, function: clamps permanently. The code alone does not establish which part caused it.',
  ),
  '100201': FaultDefinition(
    title: 'Throttle valve, function — difficult to move, too slow',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, function: difficult to move, too slow. The code alone does not establish which part caused it.',
  ),
  '100A04': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 1 and 2 — double error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, throttle valve potentiometer 1 and 2: double error. The code alone does not establish which part caused it.',
  ),
  '101001': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 1, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, throttle valve potentiometer 1, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '101002': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 1, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, throttle valve potentiometer 1, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '101201': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 2, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, throttle valve potentiometer 2, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '101202': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 2, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, throttle valve potentiometer 2, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '101401': FaultDefinition(
    title: 'Throttle valve, adaptation — boundary conditions not met',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, adaptation: boundary conditions not met. The code alone does not establish which part caused it.',
  ),
  '101402': FaultDefinition(
    title: 'Throttle valve, adaptation — emergency air position not adapted',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, adaptation: emergency air position not adapted. The code alone does not establish which part caused it.',
  ),
  '101408': FaultDefinition(
    title:
        'Throttle valve, adaptation — first adaptation, lower stop not learned',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, adaptation: first adaptation, lower stop not learned. The code alone does not establish which part caused it.',
  ),
  '101410': FaultDefinition(
    title:
        'Throttle valve, adaptation — boundary conditions not met, battery voltage below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, adaptation: boundary conditions not met, battery voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '101C08': FaultDefinition(
    title:
        'Throttle valve, throttle valve potentiometer, plausibility — synchronous error between potentiometer 1 and 2',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, throttle valve potentiometer, plausibility: synchronous error between potentiometer 1 and 2. The code alone does not establish which part caused it.',
  ),
  '101F01': FaultDefinition(
    title:
        'Throttle flap angle - absolute pressure intake pipe, comparison — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle flap angle - absolute pressure intake pipe, comparison: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '101F02': FaultDefinition(
    title:
        'Throttle flap angle - absolute pressure intake pipe, comparison — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle flap angle - absolute pressure intake pipe, comparison: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '102001': FaultDefinition(
    title: 'Air mass, plausibility — air mass above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass, plausibility: air mass above expected range. The code alone does not establish which part caused it.',
  ),
  '102002': FaultDefinition(
    title: 'Air mass, plausibility — air mass below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass, plausibility: air mass below expected range. The code alone does not establish which part caused it.',
  ),
  '102901': FaultDefinition(
    title: 'Air mass 2, plausibility — air mass above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass 2, plausibility: air mass above expected range. The code alone does not establish which part caused it.',
  ),
  '102902': FaultDefinition(
    title: 'Air mass 2, plausibility — air mass below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass 2, plausibility: air mass below expected range. The code alone does not establish which part caused it.',
  ),
  '102A01': FaultDefinition(
    title: 'Air mass meter, signal — electrical fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter, signal: electrical fault. The code alone does not establish which part caused it.',
  ),
  '102A11': FaultDefinition(
    title: 'Air mass meter 2, signal — electrical error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter 2, signal: electrical error. The code alone does not establish which part caused it.',
  ),
  '102A22': FaultDefinition(
    title: 'Air mass meter, working range — air mass above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter, working range: air mass above expected range. The code alone does not establish which part caused it.',
  ),
  '102A32': FaultDefinition(
    title: 'Air mass meter, working range — air mass below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter, working range: air mass below expected range. The code alone does not establish which part caused it.',
  ),
  '102A42': FaultDefinition(
    title: 'Air mass meter, working range — period too long',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter, working range: period too long. The code alone does not establish which part caused it.',
  ),
  '102A43': FaultDefinition(
    title: 'Air mass meter 2, working range — signal period above range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter 2, working range: signal period above range. The code alone does not establish which part caused it.',
  ),
  '102A52': FaultDefinition(
    title: 'Air mass meter, working range — period below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter, working range: period below expected range. The code alone does not establish which part caused it.',
  ),
  '102A53': FaultDefinition(
    title:
        'Air mass meter 2, working range — period duration below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter 2, working range: period duration below expected range. The code alone does not establish which part caused it.',
  ),
  '102E10': FaultDefinition(
    title: 'DME — internal error [air mass meter: open circuit standby switch]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [air mass meter: open circuit standby switch]. The code alone does not establish which part caused it.',
  ),
  '102E11': FaultDefinition(
    title: 'Air mass meter — electrical fault or air mass inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving air mass meter: electrical fault or air mass inconsistent. The code alone does not establish which part caused it.',
  ),
  '103001': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 1, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 1, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '103002': FaultDefinition(
    title: 'Gas pedal module, pedal transducer 1, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 1, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '103004': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 1, working range — voltage above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 1, working range: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '103008': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 1, working range — voltage below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 1, working range: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '103101': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 2, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 2, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '103102': FaultDefinition(
    title: 'Gas pedal module, pedal transducer 2, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 2, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '103104': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 2, working range — voltage above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 2, working range: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '103108': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 2, working range — voltage below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer 2, working range: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '103308': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer, plausibility — synchronous error between pedal transducer 1 and pedal transducer 2',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer, plausibility: synchronous error between pedal transducer 1 and pedal transducer 2. The code alone does not establish which part caused it.',
  ),
  '10351C': FaultDefinition(
    title: 'Gas pedal module, pedal transducer — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gas pedal module, pedal transducer: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '104301': FaultDefinition(
    title:
        'Absolute pressure sensor, intake pipe, plausibility, follow-up — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving absolute pressure sensor, intake pipe, plausibility, follow-up: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '104302': FaultDefinition(
    title:
        'Absolute pressure sensor, intake pipe, plausibility, follow-up — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving absolute pressure sensor, intake pipe, plausibility, follow-up: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '104401': FaultDefinition(
    title:
        'Absolute pressure sensor, intake pipe, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving absolute pressure sensor, intake pipe, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '104402': FaultDefinition(
    title:
        'Absolute pressure sensor, intake manifold, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving absolute pressure sensor, intake manifold, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '104B01': FaultDefinition(
    title:
        'Absolute pressure sensor, intake manifold — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving absolute pressure sensor, intake manifold: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '105001': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor: short to battery positive]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor: short to battery positive]. The code alone does not establish which part caused it.',
  ),
  '105002': FaultDefinition(
    title: 'DME — internal error [Ambient pressure sensor: short to ground]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor: short to ground]. The code alone does not establish which part caused it.',
  ),
  '105201': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure above expected range in lag]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure above expected range in lag]. The code alone does not establish which part caused it.',
  ),
  '105202': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure below expected range in lag]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure below expected range in lag]. The code alone does not establish which part caused it.',
  ),
  '105A30': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor: multiple related faults]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor: multiple related faults]. The code alone does not establish which part caused it.',
  ),
  '105A40': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, working range: pressure above expected range]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor, working range: pressure above expected range]. The code alone does not establish which part caused it.',
  ),
  '105A41': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, working range: pressure below expected range]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor, working range: pressure below expected range]. The code alone does not establish which part caused it.',
  ),
  '105A42': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure inconsistent]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure inconsistent]. The code alone does not establish which part caused it.',
  ),
  '105A43': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure inconsistent]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure inconsistent]. The code alone does not establish which part caused it.',
  ),
  '107801': FaultDefinition(
    title: 'Tuning protection — air mass above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tuning protection: air mass above expected range. The code alone does not establish which part caused it.',
  ),
  '107A50': FaultDefinition(
    title: 'Throttle valve — emergency running active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve: emergency running active. The code alone does not establish which part caused it.',
  ),
  '107A70': FaultDefinition(
    title: 'Throttle valve, control — short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, control: short circuit. The code alone does not establish which part caused it.',
  ),
  '107A71': FaultDefinition(
    title:
        'Throttle valve, control — overtemperature or current above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, control: overtemperature or current above expected range. The code alone does not establish which part caused it.',
  ),
  '107A72': FaultDefinition(
    title:
        'DME, internal error, control throttle valve — internal communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, control throttle valve: internal communication error. The code alone does not establish which part caused it.',
  ),
  '107A73': FaultDefinition(
    title: 'throttle valve, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '107A80': FaultDefinition(
    title:
        'Throttle, closing spring test — break-off test, spring does not close',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle, closing spring test: break-off test, spring does not close. The code alone does not establish which part caused it.',
  ),
  '107A81': FaultDefinition(
    title: 'Throttle, closing spring test — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle, closing spring test: operation fault. The code alone does not establish which part caused it.',
  ),
  '107A90': FaultDefinition(
    title:
        'Throttle, opening spring test — break-off test, spring does not open',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle, opening spring test: break-off test, spring does not open. The code alone does not establish which part caused it.',
  ),
  '107A91': FaultDefinition(
    title: 'Throttle, opening spring test — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle, opening spring test: operation fault. The code alone does not establish which part caused it.',
  ),
  '107AE0': FaultDefinition(
    title: 'Throttle valve, adaptation — relearning, lower stop not learned',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving throttle valve, adaptation: relearning, lower stop not learned. The code alone does not establish which part caused it.',
  ),
  '108920': FaultDefinition(
    title: 'Charge air temperature sensor — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '108922': FaultDefinition(
    title: 'Charge air temperature sensor 2 — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor 2: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '108930': FaultDefinition(
    title: 'Charge air temperature sensor — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '108A01': FaultDefinition(
    title:
        'Charge air temperature sensor, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '108A02': FaultDefinition(
    title: 'Charge air temperature sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '108A10': FaultDefinition(
    title: 'Charge air temperature sensor, voltage change — too fast',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor, voltage change: too fast. The code alone does not establish which part caused it.',
  ),
  '108B02': FaultDefinition(
    title: 'Charge air temperature sensor 2, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor 2, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '108C01': FaultDefinition(
    title:
        'Charge air temperature, plausibility — temperature above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature, plausibility: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '108C08': FaultDefinition(
    title: 'Charge air temperature, signal — fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '108F01': FaultDefinition(
    title:
        'Intake air system — suspected leakage between turbocharger and intake valves',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intake air system: suspected leakage between turbocharger and intake valves. The code alone does not establish which part caused it.',
  ),
  '109001': FaultDefinition(
    title: 'Coolant temperature sensor, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coolant temperature sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '109002': FaultDefinition(
    title: 'Coolant temperature sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coolant temperature sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '109308': FaultDefinition(
    title: 'Coolant temperature sensor, signal change — too fast',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coolant temperature sensor, signal change: too fast. The code alone does not establish which part caused it.',
  ),
  '10AA20': FaultDefinition(
    title:
        'Coolant temperature sensor, plausibility, cold start — temperature above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coolant temperature sensor, plausibility, cold start: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '10AA21': FaultDefinition(
    title:
        'Coolant temperature sensor, plausibility, cold start — temperature below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coolant temperature sensor, plausibility, cold start: temperature below expected range. The code alone does not establish which part caused it.',
  ),
  '10AA30': FaultDefinition(
    title: 'Coolant temperature sensor — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coolant temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '10AA40': FaultDefinition(
    title: 'FlexRay, message (coolant temperature sensor) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (coolant temperature sensor): not received. The code alone does not establish which part caused it.',
  ),
  '10AA52': FaultDefinition(
    title: 'Coolant temperature sensor, signal — fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coolant temperature sensor, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '10B101': FaultDefinition(
    title: 'External temperature sensor — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving external temperature sensor: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '10B102': FaultDefinition(
    title: 'External temperature sensor — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving external temperature sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '10B104': FaultDefinition(
    title: 'External temperature sensor, signal — CAN message faulty',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving external temperature sensor, signal: can message faulty. The code alone does not establish which part caused it.',
  ),
  '10BA30': FaultDefinition(
    title:
        'External temperature sensor, collection error — electrical and plausibility',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving external temperature sensor, collection error: electrical and plausibility. The code alone does not establish which part caused it.',
  ),
  '10BA40': FaultDefinition(
    title:
        'Outdoor temperature sensor, plausibility — outdoor temperature greater than model temperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving outdoor temperature sensor, plausibility: outdoor temperature greater than model temperature. The code alone does not establish which part caused it.',
  ),
  '10BA41': FaultDefinition(
    title:
        'Exterior temperature sensor, plausibility — exterior temperature less than model temperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exterior temperature sensor, plausibility: exterior temperature less than model temperature. The code alone does not establish which part caused it.',
  ),
  '10BA4B': FaultDefinition(
    title:
        'Charge air temperature sensor, plausibility, cold start — temperature below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor, plausibility, cold start: temperature below expected range. The code alone does not establish which part caused it.',
  ),
  '10BA51': FaultDefinition(
    title:
        'Charge air temperature sensor, cold start — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor, cold start: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '10BA52': FaultDefinition(
    title: 'Charge air temperature sensor — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '10C004': FaultDefinition(
    title:
        'Charge air temperature sensor, plausibility, cold start — temperature above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor, plausibility, cold start: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '10C111': FaultDefinition(
    title:
        'Charge air temperature sensor 2, plausibility, cold start — temperature below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air temperature sensor 2, plausibility, cold start: temperature below expected range. The code alone does not establish which part caused it.',
  ),
  '110001': FaultDefinition(
    title:
        'Cylinder injection shutdown — Cat guard due to pressure below expected range in the fuel system',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cylinder injection shutdown: cat guard due to pressure below expected range in the fuel system. The code alone does not establish which part caused it.',
  ),
  '110103': FaultDefinition(
    title: 'Injector cylinder 1, control — high voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 1, control: high voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110105': FaultDefinition(
    title: 'Injector cylinder 1, control — low-voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 1, control: low-voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110203': FaultDefinition(
    title: 'Injector cylinder 2, control — high voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 2, control: high voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110205': FaultDefinition(
    title: 'Injector cylinder 2, control — low-voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 2, control: low-voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110303': FaultDefinition(
    title: 'Injector cylinder 3, control — high voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 3, control: high voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110305': FaultDefinition(
    title: 'Injector cylinder 3, control — low voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 3, control: low voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110403': FaultDefinition(
    title: 'Injector cylinder 4, control — high voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 4, control: high voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110405': FaultDefinition(
    title: 'Injector cylinder 4, control — low-voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 4, control: low-voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110503': FaultDefinition(
    title: 'Injector cylinder 5, control — high voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 5, control: high voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110505': FaultDefinition(
    title: 'Injector cylinder 5, control — low-voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 5, control: low-voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110603': FaultDefinition(
    title: 'Injector cylinder 6, control — high voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 6, control: high voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '110605': FaultDefinition(
    title: 'Injector cylinder 6, control — low-voltage side, short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 6, control: low-voltage side, short circuit. The code alone does not establish which part caused it.',
  ),
  '112101': FaultDefinition(
    title: 'Injector cylinder 1, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 1, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112104': FaultDefinition(
    title:
        'Injector cylinder 1, control — short circuit high-voltage side to low-voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 1, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112201': FaultDefinition(
    title: 'Injector cylinder 2, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112204': FaultDefinition(
    title:
        'Injector cylinder 2, control — short circuit high-voltage side to low-voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 2, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112301': FaultDefinition(
    title: 'Injector cylinder 3, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 3, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112304': FaultDefinition(
    title:
        'Injector cylinder 3, control — short circuit high-voltage side to low-voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 3, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112401': FaultDefinition(
    title: 'Injector cylinder 4, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 4, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112404': FaultDefinition(
    title:
        'Injector cylinder 4, control — short circuit high-voltage side to low-voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 4, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112501': FaultDefinition(
    title: 'Injector cylinder 5, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 5, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112504': FaultDefinition(
    title:
        'Injector cylinder 5, control — short circuit high-voltage side to low-voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 5, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112601': FaultDefinition(
    title: 'Injector cylinder 6, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 6, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112604': FaultDefinition(
    title:
        'Injector cylinder 6, control — short circuit high-voltage side to low-voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving injector cylinder 6, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '113025': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage injection — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, supply voltage injection: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '113026': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage injection — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, supply voltage injection: short to ground. The code alone does not establish which part caused it.',
  ),
  '113027': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage injection — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, supply voltage injection: open circuit. The code alone does not establish which part caused it.',
  ),
  '114102': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 1 — mixture too rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 1: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114202': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 2 — mixture too rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 2: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114302': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 3 — mixture too rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 3: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114402': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 4 — mixture too rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 4: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114502': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 5 — mixture too rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 5: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114602': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 6 — mixture too rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 6: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '117120': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1 — adaptation value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 1: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117121': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 1 — regulator value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 1: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117123': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1, basic adaptation — transient control failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 1, basic adaptation: transient control failed. The code alone does not establish which part caused it.',
  ),
  '117124': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 1, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 1, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117125': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 1, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest-quantity adaptation, injector cylinder 1, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117126': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1, signal detection, basic adaptation — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 1, signal detection, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117127': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1, signal detection — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 1, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117128': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 1, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 1, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117220': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3 — adaptation value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 3: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117221': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3 — controller value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 3: controller value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117223': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3, basic adaptation — transient response of the controller failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 3, basic adaptation: transient response of the controller failed. The code alone does not establish which part caused it.',
  ),
  '117224': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 3, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 3, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117225': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 3, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest-quantity adaptation, injector cylinder 3, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117226': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3, signal recognition, basic adaptation — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 3, signal recognition, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117227': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3, signal detection — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 3, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117228': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 3, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 3, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117320': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4 — adaptation value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 4: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117321': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 4 — regulator value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 4: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117323': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4, basic adaptation — transient response of the regulator failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 4, basic adaptation: transient response of the regulator failed. The code alone does not establish which part caused it.',
  ),
  '117324': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 4, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 4, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117325': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 4, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest-quantity adaptation, injector cylinder 4, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117326': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4, signal detection, basic adaptation — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 4, signal detection, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117327': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4, signal detection — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 4, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117328': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 4, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 4, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117420': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2 — adaptation value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 2: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117421': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2 — regulator value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 2: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117423': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2, basic adaptation — transient response of the regulator failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 2, basic adaptation: transient response of the regulator failed. The code alone does not establish which part caused it.',
  ),
  '117424': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 2, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 2, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117425': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 2, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest-quantity adaptation, injector cylinder 2, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117426': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2, signal recognition, basic adaptation — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 2, signal recognition, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117427': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2, signal detection — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 2, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117428': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 2, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 2, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117520': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 5 — adaptation value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 5: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117521': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 5 — regulator value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 5: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117523': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 5, basic adaptation — transient response of the controller failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 5, basic adaptation: transient response of the controller failed. The code alone does not establish which part caused it.',
  ),
  '117524': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 5, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 5, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117525': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 5, basic adaptation, plausibility — opening delay time inconsistent with respect to the value learned last',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest-quantity adaptation, injector cylinder 5, basic adaptation, plausibility: opening delay time inconsistent with respect to the value learned last. The code alone does not establish which part caused it.',
  ),
  '117526': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 5, signal recognition, basic adaptation — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 5, signal recognition, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117527': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 5, signal detection — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 5, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117528': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 5, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 5, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117620': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 6 — adaptation value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 6: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117621': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 6 — regulator value outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 6: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117623': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 6, basic adaptation — transient response of the regulator failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 6, basic adaptation: transient response of the regulator failed. The code alone does not establish which part caused it.',
  ),
  '117624': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 6, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 6, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117625': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 6, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest-quantity adaptation, injector cylinder 6, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117626': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 6, signal detection, basic adaptation — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 6, signal detection, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117627': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 6, signal detection — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving small-quantity adaptation, injector cylinder 6, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117628': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 6, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving smallest quantity adaptation, injector cylinder 6, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '118001': FaultDefinition(
    title: 'Mixture regulation — mixture to lean',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture regulation: mixture to lean. The code alone does not establish which part caused it.',
  ),
  '118002': FaultDefinition(
    title: 'Mixture regulation — mixture to rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture regulation: mixture to rich. The code alone does not establish which part caused it.',
  ),
  '118101': FaultDefinition(
    title: 'Mixture regulation 2 — Mixture to lean',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture regulation 2: mixture to lean. The code alone does not establish which part caused it.',
  ),
  '118102': FaultDefinition(
    title: 'Mixture regulation 2 — Mixture to rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture regulation 2: mixture to rich. The code alone does not establish which part caused it.',
  ),
  '118401': FaultDefinition(
    title: 'Mixture regulation — mixture to lean, large deviation',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture regulation: mixture to lean, large deviation. The code alone does not establish which part caused it.',
  ),
  '118402': FaultDefinition(
    title: 'Mixture control — mixture too rich, large deviation',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture control: mixture too rich, large deviation. The code alone does not establish which part caused it.',
  ),
  '118501': FaultDefinition(
    title: 'Mixture regulation 2 — mixture to lean, large deviation',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture regulation 2: mixture to lean, large deviation. The code alone does not establish which part caused it.',
  ),
  '118502': FaultDefinition(
    title: 'Mixture regulation 2 — Mixture too rich, large deviation',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture regulation 2: mixture too rich, large deviation. The code alone does not establish which part caused it.',
  ),
  '118601': FaultDefinition(
    title:
        'Lambda sensor before catalytic converter, fine mixture control — exhaust gas by catalytic converter too rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor before catalytic converter, fine mixture control: exhaust gas by catalytic converter too rich. The code alone does not establish which part caused it.',
  ),
  '118602': FaultDefinition(
    title:
        'Lambda probe before catalytic converter, fine mixture control — exhaust gas lean by catalytic converter',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalytic converter, fine mixture control: exhaust gas lean by catalytic converter. The code alone does not establish which part caused it.',
  ),
  '118701': FaultDefinition(
    title:
        'Lambda probe before catalytic converter 2, fine mixture control — exhaust gas too rich after catalytic converter',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalytic converter 2, fine mixture control: exhaust gas too rich after catalytic converter. The code alone does not establish which part caused it.',
  ),
  '118702': FaultDefinition(
    title:
        'Lambda sensor upstream of catalytic converter 2, fine mixture control — exhaust gas lean by catalytic converter',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor upstream of catalytic converter 2, fine mixture control: exhaust gas lean by catalytic converter. The code alone does not establish which part caused it.',
  ),
  '119001': FaultDefinition(
    title: 'Rail pressure sensor, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving rail pressure sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '119002': FaultDefinition(
    title: 'Rail pressure sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving rail pressure sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '119201': FaultDefinition(
    title: 'Low-pressure fuel sensor — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low-pressure fuel sensor: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '119202': FaultDefinition(
    title: 'Low pressure fuel sensor — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low pressure fuel sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '119208': FaultDefinition(
    title: 'Low pressure fuel sensor, signal — fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low pressure fuel sensor, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '119304': FaultDefinition(
    title:
        'Rail pressure sensor, plausibility — pressure above expected range before engine start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving rail pressure sensor, plausibility: pressure above expected range before engine start. The code alone does not establish which part caused it.',
  ),
  '119308': FaultDefinition(
    title:
        'Rail pressure sensor, plausibility — pressure below expected range before engine start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving rail pressure sensor, plausibility: pressure below expected range before engine start. The code alone does not establish which part caused it.',
  ),
  '119404': FaultDefinition(
    title: 'Rail pressure sensor, signal — fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving rail pressure sensor, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '11A001': FaultDefinition(
    title: 'High fuel pressure, plausibility — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high fuel pressure, plausibility: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '11A002': FaultDefinition(
    title: 'High fuel pressure, plausibility — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high fuel pressure, plausibility: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11A201': FaultDefinition(
    title: 'Low fuel pressure, working range — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low fuel pressure, working range: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '11A204': FaultDefinition(
    title: 'Low fuel pressure, working range — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low fuel pressure, working range: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11A210': FaultDefinition(
    title:
        'Low pressure fuel system, plausibility — power electrical fuel pump for actual pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low pressure fuel system, plausibility: power electrical fuel pump for actual pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '11A401': FaultDefinition(
    title:
        'High fuel pressure at injection release — Pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high fuel pressure at injection release: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11AA03': FaultDefinition(
    title:
        'High pressure fuel system — high pressure pump, pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high pressure fuel system: high pressure pump, pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11AA05': FaultDefinition(
    title:
        'High pressure fuel system — high pressure pump 2, pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high pressure fuel system: high pressure pump 2, pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11AC01': FaultDefinition(
    title:
        'High fuel pressure, plausibility, cold start — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high fuel pressure, plausibility, cold start: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '11AC02': FaultDefinition(
    title:
        'High fuel pressure, plausibility, cold start — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high fuel pressure, plausibility, cold start: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11B209': FaultDefinition(
    title:
        'Low pressure fuel system, plausibility — flow rate below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low pressure fuel system, plausibility: flow rate below expected range. The code alone does not establish which part caused it.',
  ),
  '11B210': FaultDefinition(
    title:
        'Low pressure fuel system, plausibility — voltage electrical fuel pump inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving low pressure fuel system, plausibility: voltage electrical fuel pump inconsistent. The code alone does not establish which part caused it.',
  ),
  '11B401': FaultDefinition(
    title:
        'High fuel pressure at or after release of injection (2nd environmental condition set after time delay) — Pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high fuel pressure at or after release of injection (2nd environmental condition set after time delay): pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11B501': FaultDefinition(
    title:
        'High fuel pressure after release of injection — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving high fuel pressure after release of injection: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11C004': FaultDefinition(
    title: 'Quantity control valve, triggering — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve, triggering: open circuit. The code alone does not establish which part caused it.',
  ),
  '11C301': FaultDefinition(
    title: 'Quantity control valve 2, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve 2, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '11C302': FaultDefinition(
    title: 'Quantity control valve 2, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve 2, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '11C303': FaultDefinition(
    title: 'Quantity control valve 2, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '11C304': FaultDefinition(
    title: 'Quantity control valve 2, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '11C401': FaultDefinition(
    title: 'Quantity control valve, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '11C402': FaultDefinition(
    title: 'Quantity control valve, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '11C404': FaultDefinition(
    title: 'Quantity control valve, triggering — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve, triggering: open circuit. The code alone does not establish which part caused it.',
  ),
  '11C405': FaultDefinition(
    title: 'Quantity control valve, control, high voltage side — short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve, control, high voltage side: short circuit. The code alone does not establish which part caused it.',
  ),
  '11C406': FaultDefinition(
    title:
        'Quantity control valve, control — short circuit high voltage side to low voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve, control: short circuit high voltage side to low voltage side. The code alone does not establish which part caused it.',
  ),
  '11C407': FaultDefinition(
    title: 'Quantity control valve, control, low-voltage side — short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve, control, low-voltage side: short circuit. The code alone does not establish which part caused it.',
  ),
  '11C408': FaultDefinition(
    title:
        'Quantity control valve 2, control, high-voltage side — short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve 2, control, high-voltage side: short circuit. The code alone does not establish which part caused it.',
  ),
  '11C409': FaultDefinition(
    title:
        'Quantity control valve 2, control — short circuit high-voltage side to low-voltage side',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve 2, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '11C40A': FaultDefinition(
    title:
        'Quantity control valve 2, control, low-voltage side — short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving quantity control valve 2, control, low-voltage side: short circuit. The code alone does not establish which part caused it.',
  ),
  '11CF30': FaultDefinition(
    title: 'Mixture control — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture control: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '11CF31': FaultDefinition(
    title: 'Mixture control 2 — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving mixture control 2: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '120208': FaultDefinition(
    title:
        'Charge pressure control, plausibility — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure control, plausibility: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '120308': FaultDefinition(
    title:
        'Charge pressure control, plausibility — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure control, plausibility: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '120408': FaultDefinition(
    title: 'Charge pressure control — shutdown as a follow-up reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure control: shutdown as a follow-up reaction. The code alone does not establish which part caused it.',
  ),
  '121001': FaultDefinition(
    title: 'Charge pressure sensor, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '121002': FaultDefinition(
    title: 'Charge pressure sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '121201': FaultDefinition(
    title:
        'Charge pressure sensor, plausibility, follow-up — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure sensor, plausibility, follow-up: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '121202': FaultDefinition(
    title:
        'Charge pressure sensor, plausibility, follow-up — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure sensor, plausibility, follow-up: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '121521': FaultDefinition(
    title: 'Charge pressure sensor — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '121530': FaultDefinition(
    title: 'Charge pressure, plausibility — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure, plausibility: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '121531': FaultDefinition(
    title: 'Charge pressure, working range — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure, working range: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '121532': FaultDefinition(
    title:
        'Charge pressure - ambient pressure, comparison — charge pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure - ambient pressure, comparison: charge pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '121533': FaultDefinition(
    title:
        'Charge pressure - ambient pressure, comparison — charge pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge pressure - ambient pressure, comparison: charge pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '122001': FaultDefinition(
    title:
        'Thrust air recirculation valve, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving thrust air recirculation valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '122002': FaultDefinition(
    title: 'Thrust air recirculation valve, triggering — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving thrust air recirculation valve, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '122004': FaultDefinition(
    title: 'Thrust circulating air valve, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving thrust circulating air valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '122101': FaultDefinition(
    title:
        'Thrust circulating air valve 2, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving thrust circulating air valve 2, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '122102': FaultDefinition(
    title: 'Thrust circulating air valve 2, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving thrust circulating air valve 2, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '122104': FaultDefinition(
    title: 'Thrust circulating air valve 2, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving thrust circulating air valve 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '122201': FaultDefinition(
    title:
        'Thrust air recirculation valve, mechanics — suspected of open-clamping thrust air recirculation valve',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving thrust air recirculation valve, mechanics: suspected of open-clamping thrust air recirculation valve. The code alone does not establish which part caused it.',
  ),
  '123201': FaultDefinition(
    title: 'Wastegate, control — Suspicion of errors in the wastegate control',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wastegate, control: suspicion of errors in the wastegate control. The code alone does not establish which part caused it.',
  ),
  '123401': FaultDefinition(
    title: 'Electrical wastegate, stop learning, cold start — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate, stop learning, cold start: operation fault. The code alone does not establish which part caused it.',
  ),
  '123402': FaultDefinition(
    title:
        'Electrical wastegate 2, stop learning, cold start — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, stop learning, cold start: operation fault. The code alone does not establish which part caused it.',
  ),
  '123411': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate open) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate open) not found. The code alone does not establish which part caused it.',
  ),
  '123412': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate closed) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate closed) not found. The code alone does not establish which part caused it.',
  ),
  '123413': FaultDefinition(
    title:
        'Electric wastegate 2, stop learning — stop position (wastegate open) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate 2, stop learning: stop position (wastegate open) not found. The code alone does not establish which part caused it.',
  ),
  '123414': FaultDefinition(
    title:
        'Electric wastegate 2, stop learning — stop position (wastegate closed) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate 2, stop learning: stop position (wastegate closed) not found. The code alone does not establish which part caused it.',
  ),
  '123421': FaultDefinition(
    title:
        'Electric wastegate, stop learning — starting position (wastegate open) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, stop learning: starting position (wastegate open) not found. The code alone does not establish which part caused it.',
  ),
  '123422': FaultDefinition(
    title:
        'Electric wastegate, stop learning — starting position (wastegate closed) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, stop learning: starting position (wastegate closed) not found. The code alone does not establish which part caused it.',
  ),
  '123423': FaultDefinition(
    title:
        'Electric wastegate 2, stop learning — starting position (wastegate open) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate 2, stop learning: starting position (wastegate open) not found. The code alone does not establish which part caused it.',
  ),
  '123424': FaultDefinition(
    title:
        'Electric wastegate 2, stop learning — starting position (wastegate closed) not found',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate 2, stop learning: starting position (wastegate closed) not found. The code alone does not establish which part caused it.',
  ),
  '123425': FaultDefinition(
    title:
        'Electrical wastegate 2, position sensor, supply voltage, plausibility — voltage below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, position sensor, supply voltage, plausibility: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '123426': FaultDefinition(
    title: 'Electrical wastegate 2, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '123427': FaultDefinition(
    title:
        'Electrical wastegate 2, wastegate flap, cold start — difficult to move',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, wastegate flap, cold start: difficult to move. The code alone does not establish which part caused it.',
  ),
  '123431': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate open) outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate open) outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123432': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate closed) outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate closed) outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123433': FaultDefinition(
    title:
        'Electric wastegate, stop learning — adjustment range outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, stop learning: adjustment range outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123434': FaultDefinition(
    title:
        'Electrical wastegate 2, stop learning — stop position (wastegate open) outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, stop learning: stop position (wastegate open) outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123435': FaultDefinition(
    title:
        'Electrical wastegate 2, stop learning — adjustment range outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, stop learning: adjustment range outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123436': FaultDefinition(
    title:
        'Electrical wastegate 2, stop learning — stop position (wastegate closed) outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, stop learning: stop position (wastegate closed) outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123511': FaultDefinition(
    title: 'Electrical wastegate, wastegate flap — difficult to move',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate, wastegate flap: difficult to move. The code alone does not establish which part caused it.',
  ),
  '123512': FaultDefinition(
    title:
        'Electrical wastegate, wastegate flap, cold start — difficult to move',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate, wastegate flap, cold start: difficult to move. The code alone does not establish which part caused it.',
  ),
  '123513': FaultDefinition(
    title:
        'Electrical wastegate, position sensor, supply voltage, plausibility — voltage inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate, position sensor, supply voltage, plausibility: voltage inconsistent. The code alone does not establish which part caused it.',
  ),
  '123516': FaultDefinition(
    title: 'Electrical wastegate, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '123518': FaultDefinition(
    title: 'Electrical wastegate 2, wastegate flap — difficult to move',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, wastegate flap: difficult to move. The code alone does not establish which part caused it.',
  ),
  '123601': FaultDefinition(
    title: 'Electric wastegate, control — short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, control: short circuit. The code alone does not establish which part caused it.',
  ),
  '123602': FaultDefinition(
    title:
        'Electric wastegate, output stage — temperature above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, output stage: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '123603': FaultDefinition(
    title: 'Electrical wastegate 2, control — short circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, control: short circuit. The code alone does not establish which part caused it.',
  ),
  '123605': FaultDefinition(
    title:
        'Electrical wastegate 2, output stage — temperature above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, output stage: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '123606': FaultDefinition(
    title:
        'DME, internal error, electrical wastegate 2 — SPI communication faulty',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, electrical wastegate 2: spi communication faulty. The code alone does not establish which part caused it.',
  ),
  '123608': FaultDefinition(
    title:
        'DME, internal error, electrical wastegate — SPI communication faulty',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, electrical wastegate: spi communication faulty. The code alone does not establish which part caused it.',
  ),
  '123609': FaultDefinition(
    title:
        'Electrical wastegate, thermal overload protection — warning threshold exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate, thermal overload protection: warning threshold exceeded. The code alone does not establish which part caused it.',
  ),
  '12360B': FaultDefinition(
    title:
        'Electric wastegate, thermal overload protection — emergency running active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, thermal overload protection: emergency running active. The code alone does not establish which part caused it.',
  ),
  '123701': FaultDefinition(
    title:
        'Electric wastegate, position sensor, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate, position sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '123702': FaultDefinition(
    title:
        'Electrical wastegate, position sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate, position sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '123703': FaultDefinition(
    title:
        'Electric Wastegate 2, position sensor, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric wastegate 2, position sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '123704': FaultDefinition(
    title:
        'Electrical wastegate 2, position sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electrical wastegate 2, position sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '124004': FaultDefinition(
    title:
        'Water injection system, water pump, relay, control line — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water pump, relay, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '124005': FaultDefinition(
    title:
        'Water injection system, water pump, relay, control line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water pump, relay, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '124006': FaultDefinition(
    title:
        'Water injection system, water pump, relay, control line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water pump, relay, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '124007': FaultDefinition(
    title:
        'Water injection system, backflush valve, relay, control line — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, backflush valve, relay, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '124008': FaultDefinition(
    title:
        'Water injection system, backflush valve, relay, control line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, backflush valve, relay, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '124009': FaultDefinition(
    title:
        'Water injection system, backflow valve, relay, control line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, backflow valve, relay, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '12400A': FaultDefinition(
    title:
        'Water injection system, water injection valve 1, control line — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 1, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '12400B': FaultDefinition(
    title:
        'Water injection system, water injection valve 1, control line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 1, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12400C': FaultDefinition(
    title:
        'Water injection system, water injection valve 1, control line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 1, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '12400D': FaultDefinition(
    title:
        'Water injection system, water injection valve 2, control line — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 2, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '12400E': FaultDefinition(
    title:
        'Water injection system, water injection valve 2 control line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 2 control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12400F': FaultDefinition(
    title:
        'Water injection system, water injection valve 2, control line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 2, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '124010': FaultDefinition(
    title:
        'Water injection system, water injection valve 3, control line — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 3, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '124011': FaultDefinition(
    title:
        'Water injection system, water injection valve 3, control line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 3, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '124012': FaultDefinition(
    title:
        'Water injection system, water injection valve 3, control line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water injection valve 3, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '124013': FaultDefinition(
    title:
        'Water injection system, back-flush valve, plausibility — no pressure reduction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, back-flush valve, plausibility: no pressure reduction. The code alone does not establish which part caused it.',
  ),
  '124014': FaultDefinition(
    title:
        'Check control message (ID 969) — water injection. Water tank reserve',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 969): water injection. water tank reserve. The code alone does not establish which part caused it.',
  ),
  '124015': FaultDefinition(
    title:
        'Water injection system, working area — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, working area: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '124016': FaultDefinition(
    title:
        'Water injection system, working area — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, working area: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '124017': FaultDefinition(
    title:
        'Water injection system, pressure sensor, plausibility — pressure inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, pressure sensor, plausibility: pressure inconsistent. The code alone does not establish which part caused it.',
  ),
  '124018': FaultDefinition(
    title: 'Water injection system, water line — flow disturbed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, water line: flow disturbed. The code alone does not establish which part caused it.',
  ),
  '124019': FaultDefinition(
    title: 'Water injection system — wrong medium detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system: wrong medium detected. The code alone does not establish which part caused it.',
  ),
  '12401A': FaultDefinition(
    title:
        'Water injection system, pressure maintenance test — pressure drop above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, pressure maintenance test: pressure drop above expected range. The code alone does not establish which part caused it.',
  ),
  '12401B': FaultDefinition(
    title: 'Water injection system, injector 1 — no flow',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, injector 1: no flow. The code alone does not establish which part caused it.',
  ),
  '12401C': FaultDefinition(
    title: 'Water injection system, injector 2 — no flow',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, injector 2: no flow. The code alone does not establish which part caused it.',
  ),
  '12401D': FaultDefinition(
    title: 'Water injection system, injector 3 — no flow',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, injector 3: no flow. The code alone does not establish which part caused it.',
  ),
  '12401E': FaultDefinition(
    title: 'Water injection system — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '12401F': FaultDefinition(
    title:
        'Water injection system, pressure sensor — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, pressure sensor: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '124020': FaultDefinition(
    title: 'Water injection system, pressure sensor — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, pressure sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '124021': FaultDefinition(
    title:
        'Water injection system, temperature sensor — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, temperature sensor: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '124022': FaultDefinition(
    title: 'Water injection system, temperature sensor — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving water injection system, temperature sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '128101': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter, system test — signal fixed on lean',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor in front of catalytic converter, system test: signal fixed on lean. The code alone does not establish which part caused it.',
  ),
  '128201': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter 2, system test — signal fixed on lean',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor in front of catalytic converter 2, system test: signal fixed on lean. The code alone does not establish which part caused it.',
  ),
  '128301': FaultDefinition(
    title:
        'Lambda probe before catalytic converter, system test — oxygen signal fixed rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalytic converter, system test: oxygen signal fixed rich. The code alone does not establish which part caused it.',
  ),
  '128401': FaultDefinition(
    title:
        'Lambda probe before catalytic converter 2, system test — oxygen signal fixed rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalytic converter 2, system test: oxygen signal fixed rich. The code alone does not establish which part caused it.',
  ),
  '128901': FaultDefinition(
    title: 'Lambda probe before catalyst, dynamics — slow reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalyst, dynamics: slow reaction. The code alone does not establish which part caused it.',
  ),
  '128B01': FaultDefinition(
    title: 'Lambda probe in front of catalyst — false air detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe in front of catalyst: false air detected. The code alone does not establish which part caused it.',
  ),
  '128C01': FaultDefinition(
    title: 'Lambda sensor in front of catalyst 2 — false air detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor in front of catalyst 2: false air detected. The code alone does not establish which part caused it.',
  ),
  '128E01': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter, electrical — interruption Nernstleitung',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe in front of catalytic converter, electrical: interruption nernstleitung. The code alone does not establish which part caused it.',
  ),
  '128E03': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter, electrical — interruption of balancing resistance line',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor in front of catalytic converter, electrical: interruption of balancing resistance line. The code alone does not establish which part caused it.',
  ),
  '128E05': FaultDefinition(
    title:
        'Lambda sensor upstream of catalytic converter 2, electrical — interruption of balancing resistance line',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor upstream of catalytic converter 2, electrical: interruption of balancing resistance line. The code alone does not establish which part caused it.',
  ),
  '128F01': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter 2, electrical — interruption Nernstleitung',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe in front of catalytic converter 2, electrical: interruption nernstleitung. The code alone does not establish which part caused it.',
  ),
  '129001': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter, signal lines — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe in front of catalytic converter, signal lines: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '129002': FaultDefinition(
    title:
        'Lambda probe before catalytic converter, signal lines — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalytic converter, signal lines: short to ground. The code alone does not establish which part caused it.',
  ),
  '129101': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter 2, signal lines — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe in front of catalytic converter 2, signal lines: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '129102': FaultDefinition(
    title:
        'Lambda probe before catalytic converter 2, signal lines — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalytic converter 2, signal lines: short to ground. The code alone does not establish which part caused it.',
  ),
  '129201': FaultDefinition(
    title:
        'DME, internal error, lambda probe before catalyst — initialization error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, lambda probe before catalyst: initialization error. The code alone does not establish which part caused it.',
  ),
  '129202': FaultDefinition(
    title:
        'DME, internal error, lambda probe before catalyst — communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, lambda probe before catalyst: communication error. The code alone does not establish which part caused it.',
  ),
  '129301': FaultDefinition(
    title:
        'DME, internal error, lambda probe before catalyst 2 — initialization error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, lambda probe before catalyst 2: initialization error. The code alone does not establish which part caused it.',
  ),
  '129302': FaultDefinition(
    title:
        'DME, internal error, lambda probe before catalyst 2 — communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, lambda probe before catalyst 2: communication error. The code alone does not establish which part caused it.',
  ),
  '129A20': FaultDefinition(
    title:
        'DME, internal fault, lambda probe before catalytic converter — lambda probe component, signal circuit adaptation values above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, lambda probe before catalytic converter: lambda probe component, signal circuit adaptation values above expected range. The code alone does not establish which part caused it.',
  ),
  '129A21': FaultDefinition(
    title:
        'DME, internal fault, lambda sensor before catalytic converter — lambda sensor module, low voltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, lambda sensor before catalytic converter: lambda sensor module, low voltage. The code alone does not establish which part caused it.',
  ),
  '129A30': FaultDefinition(
    title:
        'DME, internal error, lambda probe before catalytic converter 2 — lambda probe component, signal circuit adaptation values above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, lambda probe before catalytic converter 2: lambda probe component, signal circuit adaptation values above expected range. The code alone does not establish which part caused it.',
  ),
  '129A31': FaultDefinition(
    title:
        'DME, internal fault, lambda sensor upstream of catalytic converter 2 — lambda sensor module, low voltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, lambda sensor upstream of catalytic converter 2: lambda sensor module, low voltage. The code alone does not establish which part caused it.',
  ),
  '12A001': FaultDefinition(
    title: 'Lambda probe before catalyst 2, dynamics — slow reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalyst 2, dynamics: slow reaction. The code alone does not establish which part caused it.',
  ),
  '12A008': FaultDefinition(
    title: 'Lambda probes by catalyst, assembly — reversed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probes by catalyst, assembly: reversed. The code alone does not establish which part caused it.',
  ),
  '12A308': FaultDefinition(
    title:
        'Lambda probe by catalyst, dynamics, from fat to lean — slow reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe by catalyst, dynamics, from fat to lean: slow reaction. The code alone does not establish which part caused it.',
  ),
  '12A408': FaultDefinition(
    title:
        'Lambda probe after catalyst 2, dynamics, from fat to lean — slow reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst 2, dynamics, from fat to lean: slow reaction. The code alone does not establish which part caused it.',
  ),
  '12A701': FaultDefinition(
    title:
        'Lambda probe after catalytic converter, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalytic converter, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12A801': FaultDefinition(
    title:
        'Lambda probe after catalytic converter 2, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalytic converter 2, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12A902': FaultDefinition(
    title: 'Lambda probe by catalytic converter, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe by catalytic converter, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '12AA02': FaultDefinition(
    title:
        'Lambda probe after catalytic converter 2, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalytic converter 2, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '12AB04': FaultDefinition(
    title: 'Lambda sensor by catalytic converter, electrical — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor by catalytic converter, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '12AC04': FaultDefinition(
    title: 'Lambda sensor after catalyst 2, electrical — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor after catalyst 2, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '12AD01': FaultDefinition(
    title: 'Lambda probe after catalyst — signal fixed on lean',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst: signal fixed on lean. The code alone does not establish which part caused it.',
  ),
  '12AE01': FaultDefinition(
    title: 'Lambda probe after catalyst — oxygen signal fixed rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst: oxygen signal fixed rich. The code alone does not establish which part caused it.',
  ),
  '12AF20': FaultDefinition(
    title: 'Lambda probe after catalyst — oxygen signal fixed rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst: oxygen signal fixed rich. The code alone does not establish which part caused it.',
  ),
  '12B001': FaultDefinition(
    title: 'Lambda probe by catalyst, from fat to lean — delayed reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe by catalyst, from fat to lean: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '12B008': FaultDefinition(
    title: 'Lambda probe after catalyst 2, from fat to lean — delayed reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst 2, from fat to lean: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '12B010': FaultDefinition(
    title: 'Lambda probe after catalyst 2, lean to fat — delayed reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst 2, lean to fat: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '12B020': FaultDefinition(
    title: 'Lambda probe after catalyst 2 — signal fixed on rich',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst 2: signal fixed on rich. The code alone does not establish which part caused it.',
  ),
  '12B021': FaultDefinition(
    title: 'Lambda probe after catalyst 2 — signal fixed on lean',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst 2: signal fixed on lean. The code alone does not establish which part caused it.',
  ),
  '12B101': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating before catalytic converter, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12B102': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, driving — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating before catalytic converter, driving: short to ground. The code alone does not establish which part caused it.',
  ),
  '12B104': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating before catalytic converter, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '12B201': FaultDefinition(
    title:
        'Lambda probe heating upstream of catalytic converter 2, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating upstream of catalytic converter 2, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12B202': FaultDefinition(
    title:
        'Lambda probe heating upstream of catalytic converter 2, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating upstream of catalytic converter 2, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '12B204': FaultDefinition(
    title:
        'Lambda probe heating upstream of catalytic converter 2, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating upstream of catalytic converter 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '12B301': FaultDefinition(
    title:
        'Lambda probe heating after catalytic converter, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating after catalytic converter, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12B302': FaultDefinition(
    title:
        'Lambda probe heating by catalytic converter, driving — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating by catalytic converter, driving: short to ground. The code alone does not establish which part caused it.',
  ),
  '12B304': FaultDefinition(
    title:
        'Lambda probe heating by catalytic converter, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating by catalytic converter, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '12B401': FaultDefinition(
    title:
        'Lambda probe heating after catalytic converter 2, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating after catalytic converter 2, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12B402': FaultDefinition(
    title:
        'Lambda probe heating after catalytic converter 2, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating after catalytic converter 2, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '12B404': FaultDefinition(
    title: 'Lambda probe heating after catalyst 2, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating after catalyst 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '12B505': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, function — heater fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating before catalytic converter, function: heater fault. The code alone does not establish which part caused it.',
  ),
  '12B506': FaultDefinition(
    title:
        'Lambda probe heating upstream of catalytic converter 2, function — heater fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating upstream of catalytic converter 2, function: heater fault. The code alone does not establish which part caused it.',
  ),
  '12B701': FaultDefinition(
    title:
        'Lambda probe heating by catalyst, function — internal resistance above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating by catalyst, function: internal resistance above expected range. The code alone does not establish which part caused it.',
  ),
  '12B801': FaultDefinition(
    title:
        'Lambda probe heating according to catalytic converter 2, function — internal resistance above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe heating according to catalytic converter 2, function: internal resistance above expected range. The code alone does not establish which part caused it.',
  ),
  '12BB01': FaultDefinition(
    title: 'Lambda probe by catalyst, lean to fat — delayed reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe by catalyst, lean to fat: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '12BC01': FaultDefinition(
    title: 'Lambda probe after catalyst 2, lean to fat — delayed reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst 2, lean to fat: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '12BD52': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter, electrical — interruption of pump current line',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor in front of catalytic converter, electrical: interruption of pump current line. The code alone does not establish which part caused it.',
  ),
  '12BD54': FaultDefinition(
    title:
        'Lambda probe upstream of catalytic converter 2, electrical — interruption pump current line',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe upstream of catalytic converter 2, electrical: interruption pump current line. The code alone does not establish which part caused it.',
  ),
  '12BD60': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter, electrical — interrupt virtual mass',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe in front of catalytic converter, electrical: interrupt virtual mass. The code alone does not establish which part caused it.',
  ),
  '12BD61': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter 2, electrical — interruption virtual mass',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe in front of catalytic converter 2, electrical: interruption virtual mass. The code alone does not establish which part caused it.',
  ),
  '12BD80': FaultDefinition(
    title: 'Lambda probe before catalyst — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe before catalyst: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '12BD81': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter 2 — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda sensor in front of catalytic converter 2: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '12BE08': FaultDefinition(
    title: 'Lambda probe by catalyst, dynamics, lean to fat — slow reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe by catalyst, dynamics, lean to fat: slow reaction. The code alone does not establish which part caused it.',
  ),
  '12BF08': FaultDefinition(
    title:
        'Lambda probe after catalyst 2, dynamics, lean to fat — slow reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe after catalyst 2, dynamics, lean to fat: slow reaction. The code alone does not establish which part caused it.',
  ),
  '130001': FaultDefinition(
    title: 'VANOS solenoid valve inlet, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos solenoid valve inlet, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '130002': FaultDefinition(
    title: 'VANOS solenoid valve inlet, triggering — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos solenoid valve inlet, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '130004': FaultDefinition(
    title: 'VANOS solenoid valve inlet, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos solenoid valve inlet, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '130104': FaultDefinition(
    title: 'VANOS, inlet — control error, camshaft jammed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, inlet: control error, camshaft jammed. The code alone does not establish which part caused it.',
  ),
  '130108': FaultDefinition(
    title: 'VANOS, inlet — control error, position target not reached',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, inlet: control error, position target not reached. The code alone does not establish which part caused it.',
  ),
  '130201': FaultDefinition(
    title: 'VANOS solenoid valve outlet, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos solenoid valve outlet, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '130202': FaultDefinition(
    title: 'VANOS solenoid valve outlet, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos solenoid valve outlet, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '130204': FaultDefinition(
    title: 'VANOS solenoid valve outlet, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos solenoid valve outlet, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '130304': FaultDefinition(
    title: 'VANOS, outlet — control error, camshaft jammed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, outlet: control error, camshaft jammed. The code alone does not establish which part caused it.',
  ),
  '130308': FaultDefinition(
    title: 'VANOS, outlet — control error, position target not reached',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, outlet: control error, position target not reached. The code alone does not establish which part caused it.',
  ),
  '130E11': FaultDefinition(
    title: 'Inlet camshaft sensor, plausibility — pattern invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving inlet camshaft sensor, plausibility: pattern invalid. The code alone does not establish which part caused it.',
  ),
  '130E20': FaultDefinition(
    title:
        'Inlet camshaft — angular offset to the crankshaft outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving inlet camshaft: angular offset to the crankshaft outside tolerance. The code alone does not establish which part caused it.',
  ),
  '130F11': FaultDefinition(
    title: 'Exhaust camshaft sensor, plausibility — pattern invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust camshaft sensor, plausibility: pattern invalid. The code alone does not establish which part caused it.',
  ),
  '130F20': FaultDefinition(
    title:
        'Exhaust camshaft — angular offset to the crankshaft outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust camshaft: angular offset to the crankshaft outside tolerance. The code alone does not establish which part caused it.',
  ),
  '131401': FaultDefinition(
    title: 'VANOS, outlet, cold start — not controllable',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, outlet, cold start: not controllable. The code alone does not establish which part caused it.',
  ),
  '131501': FaultDefinition(
    title: 'VANOS, inlet, cold start — not controllable',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, inlet, cold start: not controllable. The code alone does not establish which part caused it.',
  ),
  '131808': FaultDefinition(
    title: 'VANOS, outlet, cold start — position target not reached',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, outlet, cold start: position target not reached. The code alone does not establish which part caused it.',
  ),
  '131908': FaultDefinition(
    title: 'VANOS, inlet, cold start — position target not reached',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, inlet, cold start: position target not reached. The code alone does not establish which part caused it.',
  ),
  '132101': FaultDefinition(
    title: 'VANOS, outlet — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, outlet: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '132201': FaultDefinition(
    title: 'VANOS, inlet — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos, inlet: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '132301': FaultDefinition(
    title: 'VANOS — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vanos: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '133010': FaultDefinition(
    title: 'Valvetronic actuator, control — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic actuator, control: operation fault. The code alone does not establish which part caused it.',
  ),
  '133011': FaultDefinition(
    title: 'Valvetronic, supply voltage — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, supply voltage: operation fault. The code alone does not establish which part caused it.',
  ),
  '133101': FaultDefinition(
    title: 'Valvetronic relay, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic relay, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '133102': FaultDefinition(
    title: 'Valvetronic relay, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic relay, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '133104': FaultDefinition(
    title: 'Valvetronic relay, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic relay, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '133201': FaultDefinition(
    title: 'Valvetronic servomotor, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '133202': FaultDefinition(
    title: 'Valvetronic servomotor, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '133206': FaultDefinition(
    title: 'Valvetronic servomotor, control — shutdown in driving mode',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, control: shutdown in driving mode. The code alone does not establish which part caused it.',
  ),
  '133304': FaultDefinition(
    title: 'Valvetronic — component protection, shutdown system',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic: component protection, shutdown system. The code alone does not establish which part caused it.',
  ),
  '133710': FaultDefinition(
    title: 'Valvetronic, eccentric shaft adaptation — lower stop reached',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, eccentric shaft adaptation: lower stop reached. The code alone does not establish which part caused it.',
  ),
  '133B04': FaultDefinition(
    title: 'Valvetronic system — no adjustment possible',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic system: no adjustment possible. The code alone does not establish which part caused it.',
  ),
  '133E10': FaultDefinition(
    title: 'Valvetronic system — deactivated, too frequent adjustment errors',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic system: deactivated, too frequent adjustment errors. The code alone does not establish which part caused it.',
  ),
  '134A02': FaultDefinition(
    title: 'Valvetronic actuator — overload',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic actuator: overload. The code alone does not establish which part caused it.',
  ),
  '134F01': FaultDefinition(
    title: 'Valvetronic, adjustment range — learning outside tolerances',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, adjustment range: learning outside tolerances. The code alone does not establish which part caused it.',
  ),
  '134F02': FaultDefinition(
    title: 'Valvetronic, adjustment range — stop not learned',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, adjustment range: stop not learned. The code alone does not establish which part caused it.',
  ),
  '134F04': FaultDefinition(
    title: 'Valvetronic, Adjustment Range — Error Range Checking',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, adjustment range: error range checking. The code alone does not establish which part caused it.',
  ),
  '134F08': FaultDefinition(
    title:
        'Valvetronic, Adjustment Range — Range Check Deviation to UrLearning',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, adjustment range: range check deviation to urlearning. The code alone does not establish which part caused it.',
  ),
  '134F10': FaultDefinition(
    title:
        'Valvetronic, range of adjustment — stop not learned due to environmental conditions',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, range of adjustment: stop not learned due to environmental conditions. The code alone does not establish which part caused it.',
  ),
  '135302': FaultDefinition(
    title: 'Valvetronic actuator — component protection, shutdown system',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic actuator: component protection, shutdown system. The code alone does not establish which part caused it.',
  ),
  '135401': FaultDefinition(
    title: 'Valvetronic — power stage overloaded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic: power stage overloaded. The code alone does not establish which part caused it.',
  ),
  '135501': FaultDefinition(
    title: 'Valvetronic — Warning threshold overload protection exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic: warning threshold overload protection exceeded. The code alone does not establish which part caused it.',
  ),
  '135502': FaultDefinition(
    title:
        'Valvetronic actuator — warning threshold overload protection exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic actuator: warning threshold overload protection exceeded. The code alone does not establish which part caused it.',
  ),
  '135608': FaultDefinition(
    title: 'Valvetronic system — no movement detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic system: no movement detected. The code alone does not establish which part caused it.',
  ),
  '135704': FaultDefinition(
    title: 'Valvetronic system — warning threshold control deviation exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic system: warning threshold control deviation exceeded. The code alone does not establish which part caused it.',
  ),
  '135705': FaultDefinition(
    title:
        'Valvetronic system — deactivated, warning threshold control deviation too often exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic system: deactivated, warning threshold control deviation too often exceeded. The code alone does not establish which part caused it.',
  ),
  '135706': FaultDefinition(
    title: 'Valvetronic System — lower stop learned',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic system: lower stop learned. The code alone does not establish which part caused it.',
  ),
  '135808': FaultDefinition(
    title:
        'Valvetronic actuators, position sensors, electrical — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic actuators, position sensors, electrical: operation fault. The code alone does not establish which part caused it.',
  ),
  '135908': FaultDefinition(
    title:
        'Valvetronic servomotor, position sensors — supply voltage not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, position sensors: supply voltage not received. The code alone does not establish which part caused it.',
  ),
  '135A08': FaultDefinition(
    title:
        'Valvetronic servomotor, position sensors, plausibility — signals inconsistent to each other',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, position sensors, plausibility: signals inconsistent to each other. The code alone does not establish which part caused it.',
  ),
  '135A10': FaultDefinition(
    title:
        'Valvetronic servomotor, position sensors — absolute value eccentric angle wrong',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, position sensors: absolute value eccentric angle wrong. The code alone does not establish which part caused it.',
  ),
  '135B10': FaultDefinition(
    title: 'Valvetronic servomotor, control phase U — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, control phase u: open circuit. The code alone does not establish which part caused it.',
  ),
  '135B11': FaultDefinition(
    title: 'Valvetronic actuator, control phase V — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic actuator, control phase v: open circuit. The code alone does not establish which part caused it.',
  ),
  '135B12': FaultDefinition(
    title: 'Valvetronic servomotor, control phase W — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, control phase w: open circuit. The code alone does not establish which part caused it.',
  ),
  '135C10': FaultDefinition(
    title: 'Valvetronic servomotor, position sensors — error detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic servomotor, position sensors: error detected. The code alone does not establish which part caused it.',
  ),
  '135C11': FaultDefinition(
    title: 'Valvetronic actuator, position sensors — signals inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic actuator, position sensors: signals inconsistent. The code alone does not establish which part caused it.',
  ),
  '138101': FaultDefinition(
    title: 'Exhaust flap actuator, signal line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust flap actuator, signal line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '138102': FaultDefinition(
    title: 'Exhaust valve actuator, signal line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust valve actuator, signal line: short to ground. The code alone does not establish which part caused it.',
  ),
  '138104': FaultDefinition(
    title: 'Exhaust flap actuator, signal line — open',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust flap actuator, signal line: open. The code alone does not establish which part caused it.',
  ),
  '138A01': FaultDefinition(
    title: 'Exhaust valve actuator 2, signal line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust valve actuator 2, signal line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '138A02': FaultDefinition(
    title: 'Exhaust valve actuator 2, signal line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust valve actuator 2, signal line: short to ground. The code alone does not establish which part caused it.',
  ),
  '138A04': FaultDefinition(
    title: 'Exhaust flap actuator 2, signal line — open',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust flap actuator 2, signal line: open. The code alone does not establish which part caused it.',
  ),
  '138A11': FaultDefinition(
    title: 'Exhaust flap, plausibility — adjustment time inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust flap, plausibility: adjustment time inconsistent. The code alone does not establish which part caused it.',
  ),
  '138A12': FaultDefinition(
    title: 'Exhaust flap — no feedback',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust flap: no feedback. The code alone does not establish which part caused it.',
  ),
  '138A13': FaultDefinition(
    title: 'Exhaust flap 2, plausibility — adjustment time inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust flap 2, plausibility: adjustment time inconsistent. The code alone does not establish which part caused it.',
  ),
  '138A14': FaultDefinition(
    title: 'Exhaust flap 2 — no feedback',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust flap 2: no feedback. The code alone does not establish which part caused it.',
  ),
  '139001': FaultDefinition(
    title: 'Lambda probe by catalyst, from fat to lean — delayed reaction',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lambda probe by catalyst, from fat to lean: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '140001': FaultDefinition(
    title:
        'Combustion misfires, multiple cylinders — injection is switched off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfires, multiple cylinders: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140002': FaultDefinition(
    title:
        'Combustion misfires, multiple cylinders — detrimental to exhaust after starting',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfires, multiple cylinders: detrimental to exhaust after starting. The code alone does not establish which part caused it.',
  ),
  '140004': FaultDefinition(
    title: 'Combustion misfires, multiple cylinders — harmful to exhaust gas',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfires, multiple cylinders: harmful to exhaust gas. The code alone does not establish which part caused it.',
  ),
  '140010': FaultDefinition(
    title: 'Misfires, multiple cylinders — detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving misfires, multiple cylinders: detected. The code alone does not establish which part caused it.',
  ),
  '140011': FaultDefinition(
    title: 'Misfires — injection cut-off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving misfires: injection cut-off. The code alone does not establish which part caused it.',
  ),
  '140101': FaultDefinition(
    title: 'Combustion misfire, cylinder 1 — injection is switched off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 1: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140102': FaultDefinition(
    title:
        'Combustion misfire, cylinder 1 — exhaust gas damaging after starting process',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 1: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140104': FaultDefinition(
    title: 'Combustion misfire, cylinder 1 — exhaust gas damaging',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 1: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140110': FaultDefinition(
    title: 'Combustion misfire, cylinder 1 — detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 1: detected. The code alone does not establish which part caused it.',
  ),
  '140201': FaultDefinition(
    title: 'Combustion misfire, cylinder 2 — injection is switched off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 2: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140202': FaultDefinition(
    title:
        'Combustion misfire, cylinder 2 — exhaust gas damaging after starting process',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 2: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140204': FaultDefinition(
    title: 'Combustion misfire, cylinder 2 — exhaust gas damaging',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 2: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140210': FaultDefinition(
    title: 'Combustion misfire, cylinder 2 — detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 2: detected. The code alone does not establish which part caused it.',
  ),
  '140301': FaultDefinition(
    title: 'Combustion misfire, cylinder 3 — injection is switched off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 3: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140302': FaultDefinition(
    title:
        'Combustion misfire, cylinder 3 — exhaust gas damaging after starting process',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 3: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140304': FaultDefinition(
    title: 'Combustion misfire, cylinder 3 — exhaust gas damaging',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 3: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140310': FaultDefinition(
    title: 'Combustion misfire, cylinder 3 — detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 3: detected. The code alone does not establish which part caused it.',
  ),
  '140401': FaultDefinition(
    title: 'Combustion misfire, cylinder 4 — injection is switched off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 4: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140402': FaultDefinition(
    title:
        'Combustion misfire, cylinder 4 — exhaust gas damaging after starting process',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 4: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140404': FaultDefinition(
    title: 'Combustion misfire, cylinder 4 — exhaust gas damaging',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 4: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140410': FaultDefinition(
    title: 'Combustion misfire, cylinder 4 — detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 4: detected. The code alone does not establish which part caused it.',
  ),
  '140501': FaultDefinition(
    title: 'Combustion misfire, cylinder 5 — injection is switched off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 5: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140502': FaultDefinition(
    title:
        'Combustion misfire, cylinder 5 — exhaust gas damaging after starting process',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 5: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140504': FaultDefinition(
    title: 'Combustion misfire, cylinder 5 — exhaust gas damaging',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 5: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140510': FaultDefinition(
    title: 'Combustion misfire, cylinder 5 — detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 5: detected. The code alone does not establish which part caused it.',
  ),
  '140601': FaultDefinition(
    title: 'Combustion misfire, cylinder 6 — injection is switched off',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 6: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140602': FaultDefinition(
    title:
        'Combustion misfire, cylinder 6 — exhaust gas damaging after starting process',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 6: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140604': FaultDefinition(
    title: 'Combustion misfire, cylinder 6 — exhaust gas damaging',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 6: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140610': FaultDefinition(
    title: 'Combustion misfire, cylinder 6 — detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving combustion misfire, cylinder 6: detected. The code alone does not establish which part caused it.',
  ),
  '150102': FaultDefinition(
    title: 'Ignition, cylinder 1 — Burning time too short',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 1: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150202': FaultDefinition(
    title: 'Ignition, cylinder 2 — Burning time too short',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 2: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150302': FaultDefinition(
    title: 'Ignition, cylinder 3 — Burning time too short',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 3: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150402': FaultDefinition(
    title: 'Ignition, cylinder 4 — Burning time too short',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 4: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150502': FaultDefinition(
    title: 'Ignition, cylinder 5 — Burning time too short',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 5: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150602': FaultDefinition(
    title: 'Ignition, cylinder 6 — Burning time too short',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 6: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150C11': FaultDefinition(
    title: 'Ignition, cylinder 1 — Burning time outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 1: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C12': FaultDefinition(
    title: 'Ignition, cylinder 2 — Burning time outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 2: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C13': FaultDefinition(
    title: 'Ignition, cylinder 3 — Burning time outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 3: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C14': FaultDefinition(
    title: 'Ignition, cylinder 4 — Burning time outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 4: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C15': FaultDefinition(
    title: 'Ignition, cylinder 5 — Burning time outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 5: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C16': FaultDefinition(
    title: 'Ignition, cylinder 6 — Burning time outside tolerance',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition, cylinder 6: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '151001': FaultDefinition(
    title:
        'Ignition angle adjustment in idle, cold start — Ignition angle too early',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition angle adjustment in idle, cold start: ignition angle too early. The code alone does not establish which part caused it.',
  ),
  '151101': FaultDefinition(
    title:
        'Ignition angle adjustment in part load, cold start — Ignition angle too early',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition angle adjustment in part load, cold start: ignition angle too early. The code alone does not establish which part caused it.',
  ),
  '152001': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage ignition — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, supply voltage ignition: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '152007': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage ignition — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, supply voltage ignition: short to ground. The code alone does not establish which part caused it.',
  ),
  '152008': FaultDefinition(
    title: 'Ignition circuit, supply voltage — bank failure or engine failure',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ignition circuit, supply voltage: bank failure or engine failure. The code alone does not establish which part caused it.',
  ),
  '152108': FaultDefinition(
    title: 'Super-knock cylinder 1 — injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super-knock cylinder 1: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152118': FaultDefinition(
    title: 'Super knock cylinder 1 — permanent injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knock cylinder 1: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152208': FaultDefinition(
    title: 'Super knock cylinder 2 — injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knock cylinder 2: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152218': FaultDefinition(
    title: 'Super knock cylinder 2 — permanent injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knock cylinder 2: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152308': FaultDefinition(
    title: 'Super knock cylinder 3 — injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knock cylinder 3: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152318': FaultDefinition(
    title: 'Super-knock cylinder 3 — permanent injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super-knock cylinder 3: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152408': FaultDefinition(
    title: 'Super knock cylinder 4 — injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knock cylinder 4: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152418': FaultDefinition(
    title: 'Super-knock cylinder 4 — permanent injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super-knock cylinder 4: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152508': FaultDefinition(
    title: 'Super knock cylinder 5 — injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knock cylinder 5: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152518': FaultDefinition(
    title: 'Super-knock cylinder 5 — permanent injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super-knock cylinder 5: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152608': FaultDefinition(
    title: 'Super knock cylinder 6 — injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knock cylinder 6: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152618': FaultDefinition(
    title: 'Super-knock cylinder 6 — permanent injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super-knock cylinder 6: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152D08': FaultDefinition(
    title: 'Super knocking — injection shutdown',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving super knocking: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '160001': FaultDefinition(
    title: 'Crankshaft sensor, signal — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving crankshaft sensor, signal: not received. The code alone does not establish which part caused it.',
  ),
  '160020': FaultDefinition(
    title: 'Crankshaft sensor, signal — inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving crankshaft sensor, signal: inconsistent. The code alone does not establish which part caused it.',
  ),
  '160021': FaultDefinition(
    title: 'Crankshaft sensor — general synchronization loss',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving crankshaft sensor: general synchronization loss. The code alone does not establish which part caused it.',
  ),
  '160501': FaultDefinition(
    title: 'Crankcase ventilation heater, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving crankcase ventilation heater, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '160502': FaultDefinition(
    title: 'Crankcase ventilation heater, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving crankcase ventilation heater, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '160504': FaultDefinition(
    title: 'Crankcase ventilation heater, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving crankcase ventilation heater, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '160510': FaultDefinition(
    title: 'Crankshaft sensor [plausibility] — pulse width inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving crankshaft sensor [plausibility]: pulse width inconsistent. The code alone does not establish which part caused it.',
  ),
  '164020': FaultDefinition(
    title: 'Inlet camshaft sensor, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving inlet camshaft sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '164021': FaultDefinition(
    title: 'Inlet camshaft sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving inlet camshaft sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '164030': FaultDefinition(
    title: 'Exhaust camshaft sensor, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust camshaft sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '164031': FaultDefinition(
    title: 'Electric exhaust camshaft sensor — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric exhaust camshaft sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '164040': FaultDefinition(
    title: 'Inlet camshaft — assembly faulty',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving inlet camshaft: assembly faulty. The code alone does not establish which part caused it.',
  ),
  '164041': FaultDefinition(
    title: 'Output camshaft — assembly incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving output camshaft: assembly incorrect. The code alone does not establish which part caused it.',
  ),
  '165011': FaultDefinition(
    title:
        'Intermediate wave sensor (high pressure pump), signal — not received, substitute value active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intermediate wave sensor (high pressure pump), signal: not received, substitute value active. The code alone does not establish which part caused it.',
  ),
  '165012': FaultDefinition(
    title:
        'Intermediate wave sensor (high pressure pump), plausibility, signal edges — number inconsistent, substitute value active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intermediate wave sensor (high pressure pump), plausibility, signal edges: number inconsistent, substitute value active. The code alone does not establish which part caused it.',
  ),
  '165013': FaultDefinition(
    title:
        'Intermediate wave sensor (high pressure pump), plausibility — signals inconsistent, substitute value not active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intermediate wave sensor (high pressure pump), plausibility: signals inconsistent, substitute value not active. The code alone does not establish which part caused it.',
  ),
  '165014': FaultDefinition(
    title:
        'Intermediate wave sensor (high pressure pump), plausibility, signal edges — position inconsistent, substitute value active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intermediate wave sensor (high pressure pump), plausibility, signal edges: position inconsistent, substitute value active. The code alone does not establish which part caused it.',
  ),
  '165015': FaultDefinition(
    title:
        'Intermediate shaft (high-pressure pump) - crankshaft, synchronization — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intermediate shaft (high-pressure pump) - crankshaft, synchronization: operation fault. The code alone does not establish which part caused it.',
  ),
  '168001': FaultDefinition(
    title: 'Knock sensor 1, signal — motor noise above limit value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 1, signal: motor noise above limit value. The code alone does not establish which part caused it.',
  ),
  '168002': FaultDefinition(
    title: 'Knock sensor 1, signal — engine noise below limit or open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 1, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '168101': FaultDefinition(
    title: 'Knock sensor 2, signal — motor noise over limit value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 2, signal: motor noise over limit value. The code alone does not establish which part caused it.',
  ),
  '168102': FaultDefinition(
    title: 'Knock sensor 2, signal — engine noise below limit or open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 2, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '168A20': FaultDefinition(
    title: 'Knock control — system error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock control: system error. The code alone does not establish which part caused it.',
  ),
  '168A30': FaultDefinition(
    title:
        'Knock sensor 1, electrical — signal input A, short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 1, electrical: signal input a, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A31': FaultDefinition(
    title: 'Knock sensor 1, electrical — signal input A, short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 1, electrical: signal input a, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A40': FaultDefinition(
    title:
        'Knock sensor 1, electrical — signal input B, short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 1, electrical: signal input b, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A41': FaultDefinition(
    title: 'Knock sensor 1, electrical — signal input B, short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 1, electrical: signal input b, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A50': FaultDefinition(
    title:
        'Knock sensor 2, electrical — signal input A, short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 2, electrical: signal input a, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A51': FaultDefinition(
    title: 'Knock sensor 2, electrical — signal input A, short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 2, electrical: signal input a, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A60': FaultDefinition(
    title:
        'Knock sensor 2, electrical — signal input B, short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 2, electrical: signal input b, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A61': FaultDefinition(
    title: 'Knock sensor 2, electrical — signal input B, short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 2, electrical: signal input b, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A71': FaultDefinition(
    title: 'Knock sensor 1, signal — engine noise below limit or open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 1, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '168A81': FaultDefinition(
    title: 'Knock sensor 2, signal — engine noise below limit or open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving knock sensor 2, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '180001': FaultDefinition(
    title: 'Catalyst — efficiency below limit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving catalyst: efficiency below limit. The code alone does not establish which part caused it.',
  ),
  '180101': FaultDefinition(
    title: 'Catalyst 2 — efficiency below limit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving catalyst 2: efficiency below limit. The code alone does not establish which part caused it.',
  ),
  '190302': FaultDefinition(
    title:
        'Tank ventilation and purge air system, fine-sleck — leakage exceeding 0,5 mm',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank ventilation and purge air system, fine-sleck: leakage exceeding 0,5 mm. The code alone does not establish which part caused it.',
  ),
  '190F03': FaultDefinition(
    title: 'Tank ventilation system — closed after reprogramming',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank ventilation system: closed after reprogramming. The code alone does not establish which part caused it.',
  ),
  '190F08': FaultDefinition(
    title: 'Tank ventilation system — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank ventilation system: operation fault. The code alone does not establish which part caused it.',
  ),
  '191001': FaultDefinition(
    title: 'Tank ventilation valve, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank ventilation valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '191002': FaultDefinition(
    title: 'Tank ventilation valve, triggering — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank ventilation valve, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '191004': FaultDefinition(
    title: 'Tank ventilation valve, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank ventilation valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '191C02': FaultDefinition(
    title: 'Tank ventilation system, 2nd discharge point — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank ventilation system, 2nd discharge point: operation fault. The code alone does not establish which part caused it.',
  ),
  '193001': FaultDefinition(
    title: 'Fuel level sensor, left, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fuel level sensor, left, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '193002': FaultDefinition(
    title: 'Fuel level sensor, left, electric — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fuel level sensor, left, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '193008': FaultDefinition(
    title: 'Fuel level sensor, left, plausibility — CAN value inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fuel level sensor, left, plausibility: can value inconsistent. The code alone does not establish which part caused it.',
  ),
  '193101': FaultDefinition(
    title: 'Fuel level sensor, right, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fuel level sensor, right, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '193102': FaultDefinition(
    title: 'Fuel level sensors, right, electric — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fuel level sensors, right, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '193108': FaultDefinition(
    title: 'Fuel level sensor, right, plausibility — CAN value inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fuel level sensor, right, plausibility: can value inconsistent. The code alone does not establish which part caused it.',
  ),
  '193208': FaultDefinition(
    title:
        'Tank level, plausibility — deviation between consumption and change in level',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank level, plausibility: deviation between consumption and change in level. The code alone does not establish which part caused it.',
  ),
  '193218': FaultDefinition(
    title:
        'Tank level sensor — signal inconsistent due to hanging tank level sensor',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank level sensor: signal inconsistent due to hanging tank level sensor. The code alone does not establish which part caused it.',
  ),
  '193A20': FaultDefinition(
    title: 'Tank level, collection error — signal and electrical',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank level, collection error: signal and electrical. The code alone does not establish which part caused it.',
  ),
  '194001': FaultDefinition(
    title:
        'Tank leakage module, temperature sensor, electrical — voltage below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, temperature sensor, electrical: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '194002': FaultDefinition(
    title:
        'Tank leakage module, temperature sensor, electrical — voltage above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, temperature sensor, electrical: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '194004': FaultDefinition(
    title:
        'Tank leakage module, temperature, plausibility, cold start — temperature inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, temperature, plausibility, cold start: temperature inconsistent. The code alone does not establish which part caused it.',
  ),
  '194101': FaultDefinition(
    title: 'Tank leakage module, temperature sensor, signal change — too fast',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, temperature sensor, signal change: too fast. The code alone does not establish which part caused it.',
  ),
  '194201': FaultDefinition(
    title: 'Tank leakage module, timer — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, timer: operation fault. The code alone does not establish which part caused it.',
  ),
  '194401': FaultDefinition(
    title: 'Tank leakage module, communication — disturbed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, communication: disturbed. The code alone does not establish which part caused it.',
  ),
  '194501': FaultDefinition(
    title: 'Tank leakage module, communication — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, communication: operation fault. The code alone does not establish which part caused it.',
  ),
  '194601': FaultDefinition(
    title: 'Tank leakage module, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '194602': FaultDefinition(
    title: 'Tank leakage module, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '194604': FaultDefinition(
    title: 'Tank leakage module, electrical — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '194701': FaultDefinition(
    title: 'Tank leakage module, pressure switch — clamped',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, pressure switch: clamped. The code alone does not establish which part caused it.',
  ),
  '194801': FaultDefinition(
    title:
        'Tank leakage module, pressure switch, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, pressure switch, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '194802': FaultDefinition(
    title: 'Tank leakage module, pressure switch, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, pressure switch, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '194804': FaultDefinition(
    title: 'Tank leakage module, pressure switch, electrical — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving tank leakage module, pressure switch, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '195001': FaultDefinition(
    title:
        'Differential pressure sensor, tank ventilation valve, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving differential pressure sensor, tank ventilation valve, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '195002': FaultDefinition(
    title:
        'Differential pressure sensor, tank ventilation valve, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving differential pressure sensor, tank ventilation valve, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '195013': FaultDefinition(
    title:
        'Differential pressure sensor, tank ventilation valve, working range — absolute pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving differential pressure sensor, tank ventilation valve, working range: absolute pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '1A2001': FaultDefinition(
    title: 'Electric fan, control line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1A2002': FaultDefinition(
    title: 'Electric fan, control line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '1A2004': FaultDefinition(
    title: 'Electric fan, control line — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '1A2108': FaultDefinition(
    title: 'Electric fan, self-diagnosis stage 1 — slight fan error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, self-diagnosis stage 1: slight fan error. The code alone does not establish which part caused it.',
  ),
  '1A2308': FaultDefinition(
    title:
        'Electric fan, self-diagnosis Stage 2 — fan failures with potential risk to the fan',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, self-diagnosis stage 2: fan failures with potential risk to the fan. The code alone does not establish which part caused it.',
  ),
  '1A2408': FaultDefinition(
    title:
        'Electric fan, self-diagnosis Stage 3 — Fan failure with engine function impairment',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, self-diagnosis stage 3: fan failure with engine function impairment. The code alone does not establish which part caused it.',
  ),
  '1A2508': FaultDefinition(
    title: 'Electric fan, self-diagnosis stage 4 — severe fan error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, self-diagnosis stage 4: severe fan error. The code alone does not establish which part caused it.',
  ),
  '1A2601': FaultDefinition(
    title:
        'Safety relay electric fan, control line — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving safety relay electric fan, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1A2602': FaultDefinition(
    title: 'Safety relay electric fan, control line — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving safety relay electric fan, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '1A2604': FaultDefinition(
    title: 'Safety relay electric fan, control line — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving safety relay electric fan, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '1A2801': FaultDefinition(
    title:
        'Otto particulate filter pressure sensor, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter pressure sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1A2802': FaultDefinition(
    title:
        'Otto particulate filter pressure sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter pressure sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1A2803': FaultDefinition(
    title:
        'Otto particulate filter pressure sensor, plausibility — pressure inconsistent in lag',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter pressure sensor, plausibility: pressure inconsistent in lag. The code alone does not establish which part caused it.',
  ),
  '1A2804': FaultDefinition(
    title: 'Electric fans, operational readiness — restricted',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fans, operational readiness: restricted. The code alone does not establish which part caused it.',
  ),
  '1A2807': FaultDefinition(
    title:
        'Otto particulate filter pressure sensor 2, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter pressure sensor 2, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1A2808': FaultDefinition(
    title:
        'Otto particulate filter pressure sensor 2, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter pressure sensor 2, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1A2809': FaultDefinition(
    title:
        'Otto particulate filter pressure sensor 2, plausibility — pressure inconsistent in lag',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter pressure sensor 2, plausibility: pressure inconsistent in lag. The code alone does not establish which part caused it.',
  ),
  '1A280A': FaultDefinition(
    title: 'Otto particulate filter, pressure sensor, hose line — leak',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter, pressure sensor, hose line: leak. The code alone does not establish which part caused it.',
  ),
  '1A280C': FaultDefinition(
    title:
        'Otto particulate filter, pressure sensor, power limitation — exhaust backpressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter, pressure sensor, power limitation: exhaust backpressure above expected range. The code alone does not establish which part caused it.',
  ),
  '1A280E': FaultDefinition(
    title:
        'Otto particulate filter, pressure sensor — exhaust back pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter, pressure sensor: exhaust back pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '1A2810': FaultDefinition(
    title: 'Otto particulate filter — total failure',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter: total failure. The code alone does not establish which part caused it.',
  ),
  '1A2811': FaultDefinition(
    title: 'Otto particulate filter — ash value larger threshold',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter: ash value larger threshold. The code alone does not establish which part caused it.',
  ),
  '1A2812': FaultDefinition(
    title:
        'Otto particulate filter, pressure sensor, short-term power limitation — exhaust backpressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter, pressure sensor, short-term power limitation: exhaust backpressure above expected range. The code alone does not establish which part caused it.',
  ),
  '1A2814': FaultDefinition(
    title: 'Otto particulate filter, pressure sensor 2, hose line — leak',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter, pressure sensor 2, hose line: leak. The code alone does not establish which part caused it.',
  ),
  '1A2817': FaultDefinition(
    title: 'Otto particulate filter, bank 2 — total failure',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter, bank 2: total failure. The code alone does not establish which part caused it.',
  ),
  '1A2818': FaultDefinition(
    title: 'Otto particulate filter — regeneration continuously interrupted',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter: regeneration continuously interrupted. The code alone does not establish which part caused it.',
  ),
  '1A2829': FaultDefinition(
    title:
        'Exhaust gas temperature sensor in front of Otto particulate filter, plausibility — signal fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor in front of otto particulate filter, plausibility: signal fixed. The code alone does not establish which part caused it.',
  ),
  '1A2830': FaultDefinition(
    title:
        'Exhaust gas temperature sensor in front of Otto particulate filter, plausibility — value above expected range in cold start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor in front of otto particulate filter, plausibility: value above expected range in cold start. The code alone does not establish which part caused it.',
  ),
  '1A2831': FaultDefinition(
    title:
        'Exhaust gas temperature sensor in front of Otto particulate filter, plausibility — Cold start value below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor in front of otto particulate filter, plausibility: cold start value below expected range. The code alone does not establish which part caused it.',
  ),
  '1A2832': FaultDefinition(
    title:
        'Exhaust gas temperature sensor in front of Otto particulate filter 2, plausibility — signal fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor in front of otto particulate filter 2, plausibility: signal fixed. The code alone does not establish which part caused it.',
  ),
  '1A2833': FaultDefinition(
    title:
        'Exhaust gas temperature sensor in front of Otto particulate filter 2, plausibility — value above expected range in cold start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor in front of otto particulate filter 2, plausibility: value above expected range in cold start. The code alone does not establish which part caused it.',
  ),
  '1A2834': FaultDefinition(
    title:
        'Exhaust gas temperature sensor in front of Otto particulate filter 2, plausibility — value below expected range in cold start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor in front of otto particulate filter 2, plausibility: value below expected range in cold start. The code alone does not establish which part caused it.',
  ),
  '1A2835': FaultDefinition(
    title:
        'Exhaust gas temperature sensor according to Otto particulate filter, plausibility — signal fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor according to otto particulate filter, plausibility: signal fixed. The code alone does not establish which part caused it.',
  ),
  '1A2836': FaultDefinition(
    title:
        'Exhaust gas temperature sensor according to Otto particulate filter, plausibility — value above expected range in cold start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor according to otto particulate filter, plausibility: value above expected range in cold start. The code alone does not establish which part caused it.',
  ),
  '1A2837': FaultDefinition(
    title:
        'Exhaust gas temperature sensor according to Otto particulate filter, plausibility — value in cold start below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor according to otto particulate filter, plausibility: value in cold start below expected range. The code alone does not establish which part caused it.',
  ),
  '1A2838': FaultDefinition(
    title:
        'Exhaust gas temperature sensor according to Otto particulate filter 2, plausibility — signal fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor according to otto particulate filter 2, plausibility: signal fixed. The code alone does not establish which part caused it.',
  ),
  '1A2839': FaultDefinition(
    title:
        'Exhaust gas temperature sensor according to Otto particulate filter 2, plausibility — value above expected range in cold start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor according to otto particulate filter 2, plausibility: value above expected range in cold start. The code alone does not establish which part caused it.',
  ),
  '1A2840': FaultDefinition(
    title:
        'Exhaust gas temperature sensor according to Otto particulate filter 2, plausibility — value in cold start below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving exhaust gas temperature sensor according to otto particulate filter 2, plausibility: value in cold start below expected range. The code alone does not establish which part caused it.',
  ),
  '1A2841': FaultDefinition(
    title:
        'Otto particulate filter — total failure detected by means of temperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particulate filter: total failure detected by means of temperature. The code alone does not establish which part caused it.',
  ),
  '1A2842': FaultDefinition(
    title: 'Otto Particle Filter 2 — Total failure detected by temperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving otto particle filter 2: total failure detected by temperature. The code alone does not establish which part caused it.',
  ),
  '1A2843': FaultDefinition(
    title:
        'DME report: exhaust back pressure not plausible. Indication of damage or blockage exhaust system',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: exhaust back pressure not plausible. indication of damage or blockage exhaust system. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '1A2844': FaultDefinition(
    title:
        'DME report: exhaust back pressure not plausible. Indication of damage or blockage exhaust system',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: exhaust back pressure not plausible. indication of damage or blockage exhaust system. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '1A2904': FaultDefinition(
    title: 'Electric fans, ready for use — not available',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fans, ready for use: not available. The code alone does not establish which part caused it.',
  ),
  '1B0808': FaultDefinition(
    title: 'Vehicle speed, plausibility — speed signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, plausibility: speed signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A20': FaultDefinition(
    title: 'Bad track detection — wheel speed above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving bad track detection: wheel speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1B0A21': FaultDefinition(
    title: 'Bad track detection — No wheel speed signal received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving bad track detection: no wheel speed signal received. The code alone does not establish which part caused it.',
  ),
  '1B0A40': FaultDefinition(
    title: 'Vehicle speed, plausibility — speed above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, plausibility: speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1B0A60': FaultDefinition(
    title:
        'Vehicle speed, plausibility — minimum speed under load inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, plausibility: minimum speed under load inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A61': FaultDefinition(
    title: 'Vehicle speed, plausibility — minimum thrust speed inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, plausibility: minimum thrust speed inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A62': FaultDefinition(
    title: 'Vehicle speed, plausibility — speed signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, plausibility: speed signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A64': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/left, signal change — inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, wheel speed sensor rear/left, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A65': FaultDefinition(
    title:
        'Vehicle speed, front/left wheel speed sensor, signal change — inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, front/left wheel speed sensor, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A66': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/right, signal change — inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, wheel speed sensor rear/right, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A67': FaultDefinition(
    title:
        'Vehicle speed, front/right wheel speed sensor, signal change — inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, front/right wheel speed sensor, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B2001': FaultDefinition(
    title: 'EWS manipulation protection — engine running blocked by EWS',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ews manipulation protection: engine running blocked by ews. The code alone does not establish which part caused it.',
  ),
  '1B2002': FaultDefinition(
    title: 'EWS Manipulation Protection — no starting value programmed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ews manipulation protection: no starting value programmed. The code alone does not establish which part caused it.',
  ),
  '1B2008': FaultDefinition(
    title: 'EWS Manipulation Protection — Answer inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ews manipulation protection: answer inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B2101': FaultDefinition(
    title: 'Interface EWS-DME — Hardware error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving interface ews-dme: hardware error. The code alone does not establish which part caused it.',
  ),
  '1B2102': FaultDefinition(
    title: 'Interface EWS-DME — frame error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving interface ews-dme: frame error. The code alone does not establish which part caused it.',
  ),
  '1B2104': FaultDefinition(
    title: 'EWS-DME interface — time-out',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ews-dme interface: time-out. The code alone does not establish which part caused it.',
  ),
  '1B2109': FaultDefinition(
    title: 'Interface EWS-DME — reception error CAS interface',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving interface ews-dme: reception error cas interface. The code alone does not establish which part caused it.',
  ),
  '1B2201': FaultDefinition(
    title: 'DME, internal error, EWS data — no available storage option',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, ews data: no available storage option. The code alone does not establish which part caused it.',
  ),
  '1B2202': FaultDefinition(
    title: 'DME, internal error, EWS data — error release code storage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, ews data: error release code storage. The code alone does not establish which part caused it.',
  ),
  '1B2208': FaultDefinition(
    title: 'DME, internal error, EWS data — checksum error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, ews data: checksum error. The code alone does not establish which part caused it.',
  ),
  '1B2209': FaultDefinition(
    title: 'DME, internal error, EWS data — spelling error Secret Key',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, ews data: spelling error secret key. The code alone does not establish which part caused it.',
  ),
  '1B2301': FaultDefinition(
    title: 'FlexRay, Message (EWS Information FEM, 103.1.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (ews information fem, 103.1.4): not received. The code alone does not establish which part caused it.',
  ),
  '1B2302': FaultDefinition(
    title: 'FA-CAN, message (EWS service DME1/DDE1, 0x5C0) — frame error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (ews service dme1/dde1, 0x5c0): frame error. The code alone does not establish which part caused it.',
  ),
  '1B2304': FaultDefinition(
    title: 'FA-CAN, message (EWS service DME1/DDE1, 0x5C0) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (ews service dme1/dde1, 0x5c0): not received. The code alone does not establish which part caused it.',
  ),
  '1B2305': FaultDefinition(
    title:
        'FlexRay, message (stabilization status DSC 2, 47.1.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (stabilization status dsc 2, 47.1.2): not received. The code alone does not establish which part caused it.',
  ),
  '1B2904': FaultDefinition(
    title: 'Functional release, speed limitation — Code invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving functional release, speed limitation: code invalid. The code alone does not establish which part caused it.',
  ),
  '1B5101': FaultDefinition(
    title:
        'Terminal 15 3, line from CAS, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving terminal 15 3, line from cas, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1B5102': FaultDefinition(
    title: 'Terminal 15 3, line from CAS, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving terminal 15 3, line from cas, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1B5202': FaultDefinition(
    title: 'Terminal 15N 1 — no voltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving terminal 15n 1: no voltage. The code alone does not establish which part caused it.',
  ),
  '1B5302': FaultDefinition(
    title: 'Terminal 15N 2 — no voltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving terminal 15n 2: no voltage. The code alone does not establish which part caused it.',
  ),
  '1B5402': FaultDefinition(
    title: 'Terminal 15N 3 — no voltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving terminal 15n 3: no voltage. The code alone does not establish which part caused it.',
  ),
  '1B6008': FaultDefinition(
    title: 'Brake light switch, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving brake light switch, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B9508': FaultDefinition(
    title:
        'Engine shutdown time, plausibility — time too short in correlation to engine coolant cooling',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine shutdown time, plausibility: time too short in correlation to engine coolant cooling. The code alone does not establish which part caused it.',
  ),
  '1B9608': FaultDefinition(
    title:
        'Engine shutdown time, plausibility — time too long in correlation with engine coolant cooling',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine shutdown time, plausibility: time too long in correlation with engine coolant cooling. The code alone does not establish which part caused it.',
  ),
  '1B9701': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combi - time counter DME, comparison — value time counter Combi above expected range in engine running',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving motor shutdown time, time counter combi - time counter dme, comparison: value time counter combi above expected range in engine running. The code alone does not establish which part caused it.',
  ),
  '1B9702': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combine - time counter DME, comparison — value time counter Combine below expected range in engine running',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving motor shutdown time, time counter combine - time counter dme, comparison: value time counter combine below expected range in engine running. The code alone does not establish which part caused it.',
  ),
  '1B9804': FaultDefinition(
    title: 'Engine shut-off time, signal — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine shut-off time, signal: not received. The code alone does not establish which part caused it.',
  ),
  '1B9A01': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combi - time counter DME, comparison — value time counter Combi above expected range in lag',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving motor shutdown time, time counter combi - time counter dme, comparison: value time counter combi above expected range in lag. The code alone does not establish which part caused it.',
  ),
  '1B9A02': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combi - time counter DME, comparison — value time counter Combi below expected range in lag',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving motor shutdown time, time counter combi - time counter dme, comparison: value time counter combi below expected range in lag. The code alone does not establish which part caused it.',
  ),
  '1B9B01': FaultDefinition(
    title: 'Engine shut-off time — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine shut-off time: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '1BC004': FaultDefinition(
    title: 'Zero-speed sensor, adaptation — not learned (MSA deactivated)',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving zero-speed sensor, adaptation: not learned (msa deactivated). The code alone does not establish which part caused it.',
  ),
  '1BC101': FaultDefinition(
    title: 'Zero-speed sensor, plausibility — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving zero-speed sensor, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1BC110': FaultDefinition(
    title: 'Zero gear sensor, signal — pulse duty factor above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving zero gear sensor, signal: pulse duty factor above expected range. The code alone does not establish which part caused it.',
  ),
  '1BC111': FaultDefinition(
    title: 'Zero gear sensor, signal — pulse duty factor below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving zero gear sensor, signal: pulse duty factor below expected range. The code alone does not establish which part caused it.',
  ),
  '1BC112': FaultDefinition(
    title: 'Zero-speed sensor, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving zero-speed sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BC113': FaultDefinition(
    title: 'Electric zero speed sensor — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric zero speed sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BC114': FaultDefinition(
    title:
        'Zero gear sensor, plausibility — period duration outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving zero gear sensor, plausibility: period duration outside valid range. The code alone does not establish which part caused it.',
  ),
  '1BC118': FaultDefinition(
    title: 'gait sensor, learning values — inconsistent or memory failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gait sensor, learning values: inconsistent or memory failed. The code alone does not establish which part caused it.',
  ),
  '1BC119': FaultDefinition(
    title: 'Gear sensor — shift lever position invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gear sensor: shift lever position invalid. The code alone does not establish which part caused it.',
  ),
  '1BC120': FaultDefinition(
    title: 'Gear sensor, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gear sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BC121': FaultDefinition(
    title: 'Gear sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gear sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BC122': FaultDefinition(
    title: 'Gear sensor, signal — invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gear sensor, signal: invalid. The code alone does not establish which part caused it.',
  ),
  '1BC123': FaultDefinition(
    title: 'Gear sensor, signal — outside synchronization',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gear sensor, signal: outside synchronization. The code alone does not establish which part caused it.',
  ),
  '1BC124': FaultDefinition(
    title: 'Gear sensor, signal — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gear sensor, signal: not received. The code alone does not establish which part caused it.',
  ),
  '1BD401': FaultDefinition(
    title: 'Wheel speed sensor rear/left, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wheel speed sensor rear/left, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BD402': FaultDefinition(
    title: 'Rear/left wheel speed sensor, electric — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving rear/left wheel speed sensor, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD408': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/left, electric — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, wheel speed sensor rear/left, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1BD501': FaultDefinition(
    title:
        'Wheel speed sensor front/left, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wheel speed sensor front/left, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BD502': FaultDefinition(
    title: 'Wheel speed sensor front/left, electric — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wheel speed sensor front/left, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD508': FaultDefinition(
    title:
        'Vehicle speed, front/left wheel speed sensor, electric — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, front/left wheel speed sensor, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1BD601': FaultDefinition(
    title: 'Wheel speed sensor rear/right, electric — short to plus',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wheel speed sensor rear/right, electric: short to plus. The code alone does not establish which part caused it.',
  ),
  '1BD602': FaultDefinition(
    title: 'Wheel speed sensor rear/right, electric — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wheel speed sensor rear/right, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD608': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/right, electric — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, wheel speed sensor rear/right, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1BD701': FaultDefinition(
    title:
        'Wheel speed sensor front/right, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wheel speed sensor front/right, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BD702': FaultDefinition(
    title: 'Wheel speed sensor front/right, electric — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving wheel speed sensor front/right, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD708': FaultDefinition(
    title:
        'Vehicle speed, front/right wheel speed sensor, electric — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle speed, front/right wheel speed sensor, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1C0001': FaultDefinition(
    title: 'Engine oil pressure control, plausibility — pressure variations',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control, plausibility: pressure variations. The code alone does not establish which part caused it.',
  ),
  '1C0101': FaultDefinition(
    title:
        'Engine oil pressure control, plausibility, static — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control, plausibility, static: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '1C0102': FaultDefinition(
    title:
        'Engine oil pressure control, plausibility, static — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control, plausibility, static: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '1C0201': FaultDefinition(
    title:
        'Engine oil pressure control valve, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1C0202': FaultDefinition(
    title: 'Engine oil pressure control valve, triggering — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control valve, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '1C0204': FaultDefinition(
    title: 'Engine oil pressure control valve, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1C0301': FaultDefinition(
    title:
        'Engine oil pressure control valve — clamped in fully energized position (minimum oil pressure)',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control valve: clamped in fully energized position (minimum oil pressure). The code alone does not establish which part caused it.',
  ),
  '1C0302': FaultDefinition(
    title:
        'Engine oil pressure control valve — clamped in deenergized position (maximum oil pressure)',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control valve: clamped in deenergized position (maximum oil pressure). The code alone does not establish which part caused it.',
  ),
  '1C0401': FaultDefinition(
    title: 'Engine oil pressure control — unstable',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure control: unstable. The code alone does not establish which part caused it.',
  ),
  '1C2001': FaultDefinition(
    title: 'Engine oil pump — pressure above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pump: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '1C2002': FaultDefinition(
    title: 'Engine oil pump — pressure below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pump: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '1C3001': FaultDefinition(
    title: 'Engine oil pressure sensor, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1C3002': FaultDefinition(
    title: 'Engine oil pressure sensor, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1C3101': FaultDefinition(
    title:
        'Engine oil pressure sensor, plausibility — pressure above expected range before engine start',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure sensor, plausibility: pressure above expected range before engine start. The code alone does not establish which part caused it.',
  ),
  '1C3102': FaultDefinition(
    title:
        'Engine oil pressure sensor, plausibility — pressure before engine start below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure sensor, plausibility: pressure before engine start below expected range. The code alone does not establish which part caused it.',
  ),
  '1C3108': FaultDefinition(
    title: 'Engine oil pressure sensor, signal — fixed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil pressure sensor, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '1C4002': FaultDefinition(
    title: 'Engine oil level — below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil level: below expected range. The code alone does not establish which part caused it.',
  ),
  '1C4110': FaultDefinition(
    title: 'Oil state sensor — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving oil state sensor: operation fault. The code alone does not establish which part caused it.',
  ),
  '1C4116': FaultDefinition(
    title: 'Oil state sensor, electrical — level operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving oil state sensor, electrical: level operation fault. The code alone does not establish which part caused it.',
  ),
  '1C4118': FaultDefinition(
    title: 'Oil state sensor, electrical — temperature operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving oil state sensor, electrical: temperature operation fault. The code alone does not establish which part caused it.',
  ),
  '1C4119': FaultDefinition(
    title: 'Engine oil temperature sensor, electrical — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine oil temperature sensor, electrical: operation fault. The code alone does not establish which part caused it.',
  ),
  '1C4121': FaultDefinition(
    title: 'Oil state sensor — signal not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving oil state sensor: signal not received. The code alone does not establish which part caused it.',
  ),
  '1C4122': FaultDefinition(
    title: 'Oil state sensor — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving oil state sensor: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1C5A20': FaultDefinition(
    title: 'BSD, communication (oil state sensor) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving bsd, communication (oil state sensor): not received. The code alone does not establish which part caused it.',
  ),
  '1D2008': FaultDefinition(
    title: 'Characteristic thermostat — clamps open',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving characteristic thermostat: clamps open. The code alone does not establish which part caused it.',
  ),
  '1D2102': FaultDefinition(
    title: 'Characteristic field thermostat, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving characteristic field thermostat, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '1D2401': FaultDefinition(
    title:
        'Characteristic field thermostat, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving characteristic field thermostat, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1D2402': FaultDefinition(
    title: 'Characteristic field thermostat, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving characteristic field thermostat, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '1D2404': FaultDefinition(
    title: 'Characteristic field thermostat, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving characteristic field thermostat, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1D3001': FaultDefinition(
    title:
        'Coupling, plausibility — transferable torque below expected range, coupling slightly damaged',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coupling, plausibility: transferable torque below expected range, coupling slightly damaged. The code alone does not establish which part caused it.',
  ),
  '1D3101': FaultDefinition(
    title:
        'Coupling, plausibility — transferable torque below expected range, clutch damaged',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coupling, plausibility: transferable torque below expected range, clutch damaged. The code alone does not establish which part caused it.',
  ),
  '1D3201': FaultDefinition(
    title:
        'Coupling, plausibility — transferable torque below expected range, clutch severely damaged',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coupling, plausibility: transferable torque below expected range, clutch severely damaged. The code alone does not establish which part caused it.',
  ),
  '1D3211': FaultDefinition(
    title:
        'Coupling temperature — warning threshold value 1 is exceeded without damage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coupling temperature: warning threshold value 1 is exceeded without damage. The code alone does not establish which part caused it.',
  ),
  '1D3212': FaultDefinition(
    title:
        'Coupling temperature — warning threshold value 2 is exceeded without damage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving coupling temperature: warning threshold value 2 is exceeded without damage. The code alone does not establish which part caused it.',
  ),
  '1D3650': FaultDefinition(
    title: 'Rear axle transmission, plausibility — translation inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving rear axle transmission, plausibility: translation inconsistent. The code alone does not establish which part caused it.',
  ),
  '1D3701': FaultDefinition(
    title: 'Power management, battery — speed increase due to low charge level',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management, battery: speed increase due to low charge level. The code alone does not establish which part caused it.',
  ),
  '1D3810': FaultDefinition(
    title: 'Clutch switch — positions inconsistent relative to each other',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving clutch switch: positions inconsistent relative to each other. The code alone does not establish which part caused it.',
  ),
  '1D3A01': FaultDefinition(
    title:
        'Communication — signal (speed transmission train output) in A-CAN, message (transmission train data, 0x1AF): invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving communication: signal (speed transmission train output) in a-can, message (transmission train data, 0x1af): invalid. The code alone does not establish which part caused it.',
  ),
  '1D3C01': FaultDefinition(
    title:
        'Communication — signal (status shift active transmission) in A- / FA-CAN, message (status transmission control, 0x39A): invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving communication: signal (status shift active transmission) in a- / fa-can, message (status transmission control, 0x39a): invalid. The code alone does not establish which part caused it.',
  ),
  '1E0001': FaultDefinition(
    title: 'Idle control — speed above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving idle control: speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1E0002': FaultDefinition(
    title: 'Idle control — speed below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving idle control: speed below expected range. The code alone does not establish which part caused it.',
  ),
  '1E0101': FaultDefinition(
    title: 'Idle control, cold start — speed above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving idle control, cold start: speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1E0102': FaultDefinition(
    title: 'Idle control, cold start — speed below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving idle control, cold start: speed below expected range. The code alone does not establish which part caused it.',
  ),
  '1E0308': FaultDefinition(
    title: 'Idle control, plausibility, cold start — speed inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving idle control, plausibility, cold start: speed inconsistent. The code alone does not establish which part caused it.',
  ),
  '1E4001': FaultDefinition(
    title: 'Sport button, electric — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving sport button, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1E4002': FaultDefinition(
    title: 'Sport button, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving sport button, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1E5001': FaultDefinition(
    title:
        'Customer display — Full drive power soon available has been activated',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving customer display: full drive power soon available has been activated. The code alone does not establish which part caused it.',
  ),
  '1E5201': FaultDefinition(
    title:
        'Speed limitation with vehicle stationary — idle speed too long above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving speed limitation with vehicle stationary: idle speed too long above expected range. The code alone does not establish which part caused it.',
  ),
  '1E5301': FaultDefinition(
    title: 'Manipulation protection — engine power above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving manipulation protection: engine power above expected range. The code alone does not establish which part caused it.',
  ),
  '1E5A20': FaultDefinition(
    title: 'Drive, safety function — power reduction through safety concept',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: power reduction through safety concept. The code alone does not establish which part caused it.',
  ),
  '1F0514': FaultDefinition(
    title: 'Valvetronic, supply voltage — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, supply voltage: short to ground. The code alone does not establish which part caused it.',
  ),
  '1F0515': FaultDefinition(
    title: 'Valvetronic, supply voltage — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving valvetronic, supply voltage: open circuit. The code alone does not establish which part caused it.',
  ),
  '1F0516': FaultDefinition(
    title: 'Drive, safety function — AD converter idle test pulse test',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: ad converter idle test pulse test. The code alone does not establish which part caused it.',
  ),
  '1F0517': FaultDefinition(
    title: 'Drive, safety function — AD converter test voltage test',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: ad converter test voltage test. The code alone does not establish which part caused it.',
  ),
  '1F0518': FaultDefinition(
    title: 'DME, internal error, safety function — air volume adjustment',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, safety function: air volume adjustment. The code alone does not establish which part caused it.',
  ),
  '1F0519': FaultDefinition(
    title:
        'Drive, safety function — accelerator pedal module or pedal transducer inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: accelerator pedal module or pedal transducer inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0520': FaultDefinition(
    title: 'Drive, safety function — speed sensor inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: speed sensor inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0521': FaultDefinition(
    title:
        'DME, internal error, safety function — plausibility check of the mixture correction factors',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, safety function: plausibility check of the mixture correction factors. The code alone does not establish which part caused it.',
  ),
  '1F0522': FaultDefinition(
    title:
        'DME, internal fault, safety function — injection limitation level 1',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, safety function: injection limitation level 1. The code alone does not establish which part caused it.',
  ),
  '1F0523': FaultDefinition(
    title: 'Drive, safety function — safety shutdown injection',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: safety shutdown injection. The code alone does not establish which part caused it.',
  ),
  '1F0524': FaultDefinition(
    title: 'DME, internal error, safety function — Lambda setpoint',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, safety function: lambda setpoint. The code alone does not establish which part caused it.',
  ),
  '1F0525': FaultDefinition(
    title:
        'DME, internal fault, safety function — plausibility check relative fuel mass',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, safety function: plausibility check relative fuel mass. The code alone does not establish which part caused it.',
  ),
  '1F0526': FaultDefinition(
    title: 'DME, internal error, safety function — moment comparison',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, safety function: moment comparison. The code alone does not establish which part caused it.',
  ),
  '1F0527': FaultDefinition(
    title:
        'DME, internal error, safety function — drive train transmission ratio inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, safety function: drive train transmission ratio inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0528': FaultDefinition(
    title: 'Drive, safety function — transmission variant inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: transmission variant inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0529': FaultDefinition(
    title: 'DME, internal fault, safety function — ignition angle monitoring',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, safety function: ignition angle monitoring. The code alone does not establish which part caused it.',
  ),
  '1F0530': FaultDefinition(
    title: 'Drive, safety function — switch-off path test negative',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving drive, safety function: switch-off path test negative. The code alone does not establish which part caused it.',
  ),
  '1F0531': FaultDefinition(
    title:
        'DME, internal fault, safety function — plausibility check fuel mass',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, safety function: plausibility check fuel mass. The code alone does not establish which part caused it.',
  ),
  '1F053B': FaultDefinition(
    title:
        'DME, internal error, safety function — torque requirement inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, safety function: torque requirement inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0904': FaultDefinition(
    title: 'DME, internal error, Valvetronic control — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, valvetronic control: operation fault. The code alone does not establish which part caused it.',
  ),
  '1F0905': FaultDefinition(
    title: 'DME, internal error, Valvetronic — power inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, valvetronic: power inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0906': FaultDefinition(
    title: 'DME, internal fault, Valvetronic — voltage outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, valvetronic: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1401': FaultDefinition(
    title: 'DME, internal error, MSA monitoring — incorrect calculation',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, msa monitoring: incorrect calculation. The code alone does not establish which part caused it.',
  ),
  '1F1A40': FaultDefinition(
    title: 'DME, internal error — SPI communication monitoring',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: spi communication monitoring. The code alone does not establish which part caused it.',
  ),
  '1F1A50': FaultDefinition(
    title: 'DME, internal error — erasing EEPROM incorrectly',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: erasing eeprom incorrectly. The code alone does not establish which part caused it.',
  ),
  '1F1A51': FaultDefinition(
    title: 'DME, internal error — reading EEPROM incorrectly',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: reading eeprom incorrectly. The code alone does not establish which part caused it.',
  ),
  '1F1A52': FaultDefinition(
    title: 'DME, internal error — Write EEPROM incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: write eeprom incorrect. The code alone does not establish which part caused it.',
  ),
  '1F1A60': FaultDefinition(
    title: 'DME, internal error — monitoring module error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: monitoring module error. The code alone does not establish which part caused it.',
  ),
  '1F1A70': FaultDefinition(
    title: 'DME, internal failure, monitoring 5V supply — overvoltage detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal failure, monitoring 5v supply: overvoltage detected. The code alone does not establish which part caused it.',
  ),
  '1F1A71': FaultDefinition(
    title: 'DME, internal fault, monitoring 5V supply — undervoltage detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, monitoring 5v supply: undervoltage detected. The code alone does not establish which part caused it.',
  ),
  '1F1A80': FaultDefinition(
    title: 'DME, internal error, watchdog output — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, watchdog output: operation fault. The code alone does not establish which part caused it.',
  ),
  '1F1A81': FaultDefinition(
    title:
        'DME, internal error, watchdog output — incorrect question/answer communication',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, watchdog output: incorrect question/answer communication. The code alone does not establish which part caused it.',
  ),
  '1F1A82': FaultDefinition(
    title: 'DME, internal error, watchdog output — surge detection',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, watchdog output: surge detection. The code alone does not establish which part caused it.',
  ),
  '1F1A90': FaultDefinition(
    title: 'Monitoring 5V sensor supply — voltage outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving monitoring 5v sensor supply: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1A91': FaultDefinition(
    title: 'Monitoring 5V sensor supply 2 — voltage outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving monitoring 5v sensor supply 2: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1A92': FaultDefinition(
    title: 'Monitoring 5V sensor supply 3 — voltage outside valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving monitoring 5v sensor supply 3: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1AA0': FaultDefinition(
    title: 'DME, internal error — software reset',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: software reset. The code alone does not establish which part caused it.',
  ),
  '1F1AA1': FaultDefinition(
    title: 'DME, internal error — software reset',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: software reset. The code alone does not establish which part caused it.',
  ),
  '1F1AA2': FaultDefinition(
    title: 'DME, internal error — software reset',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error: software reset. The code alone does not establish which part caused it.',
  ),
  '1F1B40': FaultDefinition(
    title: 'Starting unit pinion starter, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving starting unit pinion starter, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1F1B41': FaultDefinition(
    title: 'Starting unit pinion starter, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving starting unit pinion starter, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '1F1B42': FaultDefinition(
    title: 'Starting unit pinion starter, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving starting unit pinion starter, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1F2102': FaultDefinition(
    title: 'Function release, power increase — not performed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving function release, power increase: not performed. The code alone does not establish which part caused it.',
  ),
  '1F2104': FaultDefinition(
    title:
        'DME, incorrect data set — FA-CAN, message (vehicle type, 0x388): not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, incorrect data set: fa-can, message (vehicle type, 0x388): not received. The code alone does not establish which part caused it.',
  ),
  '1F2108': FaultDefinition(
    title: 'DME, wrong data set — variant monitoring',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, wrong data set: variant monitoring. The code alone does not establish which part caused it.',
  ),
  '1F2601': FaultDefinition(
    title: 'DME, coding — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: not received. The code alone does not establish which part caused it.',
  ),
  '1F2604': FaultDefinition(
    title: 'DME, coding — VIN wrong',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: vin wrong. The code alone does not establish which part caused it.',
  ),
  '1F2701': FaultDefinition(
    title: 'DME, coding — spelling error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: spelling error. The code alone does not establish which part caused it.',
  ),
  '1F2702': FaultDefinition(
    title: 'DME, coding — Signature verification incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: signature verification incorrect. The code alone does not establish which part caused it.',
  ),
  '1F2704': FaultDefinition(
    title: 'DME, coding — data inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, coding: data inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F4A01': FaultDefinition(
    title: 'Relay ignition and injectors, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1F4A02': FaultDefinition(
    title: 'Relay ignition and injectors, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '1F4A10': FaultDefinition(
    title: 'Relay ignition and injectors, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving relay ignition and injectors, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1F5020': FaultDefinition(
    title:
        'DME, internal error, internal temperature sensor — value above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, internal temperature sensor: value above expected range. The code alone does not establish which part caused it.',
  ),
  '1F5021': FaultDefinition(
    title:
        'DME, internal error, internal temperature sensor — value below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal error, internal temperature sensor: value below expected range. The code alone does not establish which part caused it.',
  ),
  '1F5101': FaultDefinition(
    title: 'DME Temperature — Overtemperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme temperature: overtemperature. The code alone does not establish which part caused it.',
  ),
  '1FB001': FaultDefinition(
    title: 'Power Management — Transport monitoring battery charge status OK',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: transport monitoring battery charge status ok. The code alone does not establish which part caused it.',
  ),
  '1FB101': FaultDefinition(
    title:
        'Power Management — Battery below the upper start-up capability limit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: battery below the upper start-up capability limit. The code alone does not establish which part caused it.',
  ),
  '1FB201': FaultDefinition(
    title: 'Check-Control message (ID 257) — Engine too hot! Moderate driving',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check-control message (id 257): engine too hot! moderate driving. The code alone does not establish which part caused it.',
  ),
  '1FB301': FaultDefinition(
    title: 'Check control message (ID 39) — Engine overheated. Be careful',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 39): engine overheated. be careful. The code alone does not establish which part caused it.',
  ),
  '1FB401': FaultDefinition(
    title: 'Check control message (ID 367) — Drive moderately',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 367): drive moderately. The code alone does not establish which part caused it.',
  ),
  '1FB402': FaultDefinition(
    title: 'Check-Control message (ID 257) — Engine too hot. Moderate driving',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check-control message (id 257): engine too hot. moderate driving. The code alone does not establish which part caused it.',
  ),
  '1FB501': FaultDefinition(
    title: 'Check-Control Message (ID 27) — Refill engine oil',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check-control message (id 27): refill engine oil. The code alone does not establish which part caused it.',
  ),
  '1FB601': FaultDefinition(
    title:
        'Check control message (ID 450) — Auto Start Stop function deactivated',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 450): auto start stop function deactivated. The code alone does not establish which part caused it.',
  ),
  '1FB701': FaultDefinition(
    title: 'Check control message (ID 397) — Auto Start Stop function failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 397): auto start stop function failed. The code alone does not establish which part caused it.',
  ),
  '1FB801': FaultDefinition(
    title:
        'Check control message (ID 212) — engine oil pressure. Persistent cautiously',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 212): engine oil pressure. persistent cautiously. The code alone does not establish which part caused it.',
  ),
  '1FB901': FaultDefinition(
    title: 'Check control message (ID 278) — Select low gear',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 278): select low gear. The code alone does not establish which part caused it.',
  ),
  '1FBB01': FaultDefinition(
    title: 'Check-control message (ID 567) — Engine fan. Moderate driving',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check-control message (id 567): engine fan. moderate driving. The code alone does not establish which part caused it.',
  ),
  '1FBC01': FaultDefinition(
    title: 'Check control message (ID 584) — Transport mode',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving check control message (id 584): transport mode. The code alone does not establish which part caused it.',
  ),
  '201004': FaultDefinition(
    title: 'CBS client — output of replacement value',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cbs client: output of replacement value. The code alone does not establish which part caused it.',
  ),
  '201010': FaultDefinition(
    title: 'A- / FA-CAN Hardware — defective',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a- / fa-can hardware: defective. The code alone does not establish which part caused it.',
  ),
  '201020': FaultDefinition(
    title: 'FlexRay hardware — defective',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray hardware: defective. The code alone does not establish which part caused it.',
  ),
  '201101': FaultDefinition(
    title:
        'DME, manipulation protection — program or data manipulation detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, manipulation protection: program or data manipulation detected. The code alone does not establish which part caused it.',
  ),
  '20A012': FaultDefinition(
    title: 'Charge air cooling pump, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling pump, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '20A013': FaultDefinition(
    title: 'Charge air cooling pump, triggering — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling pump, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '20A014': FaultDefinition(
    title: 'Charge air cooling pump, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling pump, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '20A015': FaultDefinition(
    title:
        'DME, internal fault, charge air cooling pump — overtemperature detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, charge air cooling pump: overtemperature detected. The code alone does not establish which part caused it.',
  ),
  '20A016': FaultDefinition(
    title: 'Charge air coolant pump, mass sampling — dry run',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air coolant pump, mass sampling: dry run. The code alone does not establish which part caused it.',
  ),
  '20A017': FaultDefinition(
    title: 'Charge air cooling pump, mass sampling — pump blocked',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling pump, mass sampling: pump blocked. The code alone does not establish which part caused it.',
  ),
  '20A018': FaultDefinition(
    title: 'Charge air coolant pump, mass sampling — pump superheated',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air coolant pump, mass sampling: pump superheated. The code alone does not establish which part caused it.',
  ),
  '20A019': FaultDefinition(
    title: 'Charge air cooling pump, mass sampling — pump below minimum speed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling pump, mass sampling: pump below minimum speed. The code alone does not establish which part caused it.',
  ),
  '20A01A': FaultDefinition(
    title: 'Charge air cooling pump — mass sampling inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling pump: mass sampling inconsistent. The code alone does not establish which part caused it.',
  ),
  '20A01B': FaultDefinition(
    title: 'Additional coolant pump, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving additional coolant pump, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '20A01C': FaultDefinition(
    title: 'Additional coolant pump, triggering — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving additional coolant pump, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '20A01D': FaultDefinition(
    title: 'Additional coolant pump, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving additional coolant pump, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '20A01E': FaultDefinition(
    title:
        'DME, internal fault, auxiliary coolant pump — overtemperature detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme, internal fault, auxiliary coolant pump: overtemperature detected. The code alone does not establish which part caused it.',
  ),
  '20A01F': FaultDefinition(
    title: 'Supplementary coolant pump, mass sampling — dry running',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving supplementary coolant pump, mass sampling: dry running. The code alone does not establish which part caused it.',
  ),
  '20A020': FaultDefinition(
    title: 'Additional coolant pump, mass sampling — pump blocked',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving additional coolant pump, mass sampling: pump blocked. The code alone does not establish which part caused it.',
  ),
  '20A021': FaultDefinition(
    title: 'Supplementary coolant pump, mass sampling — pump superheated',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving supplementary coolant pump, mass sampling: pump superheated. The code alone does not establish which part caused it.',
  ),
  '20A022': FaultDefinition(
    title: 'Additional coolant pump, mass sampling — pump below minimum speed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving additional coolant pump, mass sampling: pump below minimum speed. The code alone does not establish which part caused it.',
  ),
  '20A023': FaultDefinition(
    title: 'Supplementary coolant pump — mass sampling inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving supplementary coolant pump: mass sampling inconsistent. The code alone does not establish which part caused it.',
  ),
  '20A101': FaultDefinition(
    title:
        'Charge air cooling system — coolant pump switched off due to excess temperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling system: coolant pump switched off due to excess temperature. The code alone does not establish which part caused it.',
  ),
  '20A104': FaultDefinition(
    title:
        'Charge air cooling system — shutdown of coolant pump due to blockage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling system: shutdown of coolant pump due to blockage. The code alone does not establish which part caused it.',
  ),
  '20A105': FaultDefinition(
    title: 'Charge air coolant pump, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air coolant pump, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '20A106': FaultDefinition(
    title:
        'DME — internal error [output stage, charge air coolant pump: temperature above expected range]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [output stage, charge air coolant pump: temperature above expected range]. The code alone does not establish which part caused it.',
  ),
  '20A107': FaultDefinition(
    title: 'Charge air coolant pump, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air coolant pump, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '20A109': FaultDefinition(
    title: 'Charge air coolant pump, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air coolant pump, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '20A10B': FaultDefinition(
    title:
        'Charge air cooling system — speed coolant pump below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling system: speed coolant pump below expected range. The code alone does not establish which part caused it.',
  ),
  '20A201': FaultDefinition(
    title:
        'Charge air cooling system — coolant pump protective function active due to dry running',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling system: coolant pump protective function active due to dry running. The code alone does not establish which part caused it.',
  ),
  '20A203': FaultDefinition(
    title: 'Charge air cooling system — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving charge air cooling system: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '20A501': FaultDefinition(
    title: 'Turbocharger coolant pump, control — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving turbocharger coolant pump, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '20A502': FaultDefinition(
    title: 'Turbocharger coolant pump, control — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving turbocharger coolant pump, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '20A503': FaultDefinition(
    title: 'Turbocharger coolant pump — signal inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving turbocharger coolant pump: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '20A504': FaultDefinition(
    title: 'Turbocharger coolant pump, control — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving turbocharger coolant pump, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '20A506': FaultDefinition(
    title:
        'DME — internal error, output stage [turbocharger coolant pump: temperature above expected range]',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error, output stage [turbocharger coolant pump: temperature above expected range]. The code alone does not establish which part caused it.',
  ),
  '20A507': FaultDefinition(
    title:
        'Engine cooling system — shutdown of turbocharger coolant pump due to overtemperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine cooling system: shutdown of turbocharger coolant pump due to overtemperature. The code alone does not establish which part caused it.',
  ),
  '20A508': FaultDefinition(
    title:
        'Engine cooling system — shutdown of turbocharger coolant pump due to blockage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine cooling system: shutdown of turbocharger coolant pump due to blockage. The code alone does not establish which part caused it.',
  ),
  '20A509': FaultDefinition(
    title:
        'Engine cooling system — speed of turbocharger cooler title pump below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine cooling system: speed of turbocharger cooler title pump below expected range. The code alone does not establish which part caused it.',
  ),
  '20A50A': FaultDefinition(
    title:
        'Engine cooling system — turbocharger coolant pump protective function active due to dry running',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving engine cooling system: turbocharger coolant pump protective function active due to dry running. The code alone does not establish which part caused it.',
  ),
  '20BA20': FaultDefinition(
    title: 'Clutch switch, signal — inconsistent gear change detected',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving clutch switch, signal: inconsistent gear change detected. The code alone does not establish which part caused it.',
  ),
  '210201': FaultDefinition(
    title: 'Generator, electrical — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator, electrical: operation fault. The code alone does not establish which part caused it.',
  ),
  '210301': FaultDefinition(
    title: 'Generator, plausibility, electrical — calculated',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator, plausibility, electrical: calculated. The code alone does not establish which part caused it.',
  ),
  '210401': FaultDefinition(
    title: 'Generator, temperature — overtemperature',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator, temperature: overtemperature. The code alone does not establish which part caused it.',
  ),
  '210601': FaultDefinition(
    title: 'Generator, mechanical — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator, mechanical: operation fault. The code alone does not establish which part caused it.',
  ),
  '210801': FaultDefinition(
    title: 'Generator — Type Wrong',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator: type wrong. The code alone does not establish which part caused it.',
  ),
  '210C01': FaultDefinition(
    title: 'Generator, communication — bus error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator, communication: bus error. The code alone does not establish which part caused it.',
  ),
  '211A21': FaultDefinition(
    title: 'BSD bus — communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving bsd bus: communication error. The code alone does not establish which part caused it.',
  ),
  '211F01': FaultDefinition(
    title: 'Generator/Starter Generator — Coding not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator/starter generator: coding not received. The code alone does not establish which part caused it.',
  ),
  '211F03': FaultDefinition(
    title: 'Generator/Starter Generator — Coding or program status incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving generator/starter generator: coding or program status incorrect. The code alone does not establish which part caused it.',
  ),
  '213301': FaultDefinition(
    title: 'Power management — central overvoltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: central overvoltage. The code alone does not establish which part caused it.',
  ),
  '213401': FaultDefinition(
    title: 'Power management — central undervoltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: central undervoltage. The code alone does not establish which part caused it.',
  ),
  '213501': FaultDefinition(
    title: 'Power Management — Battery Deep Discharge',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: battery deep discharge. The code alone does not establish which part caused it.',
  ),
  '213601': FaultDefinition(
    title: 'Power management — quiescent current breach',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: quiescent current breach. The code alone does not establish which part caused it.',
  ),
  '213701': FaultDefinition(
    title: 'Power Management — batteryless operation',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: batteryless operation. The code alone does not establish which part caused it.',
  ),
  '213801': FaultDefinition(
    title:
        'Power Management — Transport monitoring battery state deep discharge',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: transport monitoring battery state deep discharge. The code alone does not establish which part caused it.',
  ),
  '213901': FaultDefinition(
    title: 'Power Management — Consumer Reduction Active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving power management: consumer reduction active. The code alone does not establish which part caused it.',
  ),
  '213A01': FaultDefinition(
    title: 'Powermanagement — transport monitoring battery state discharge',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving powermanagement: transport monitoring battery state discharge. The code alone does not establish which part caused it.',
  ),
  '213A20': FaultDefinition(
    title:
        'Vehicle electrical system voltage, working range — voltage above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle electrical system voltage, working range: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '213A21': FaultDefinition(
    title:
        'Vehicle electrical system voltage, working range — voltage below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving vehicle electrical system voltage, working range: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '213B01': FaultDefinition(
    title: 'Battery status detection — defective battery',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery status detection: defective battery. The code alone does not establish which part caused it.',
  ),
  '213C01': FaultDefinition(
    title: 'Battery state detection — battery deep discharge',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery state detection: battery deep discharge. The code alone does not establish which part caused it.',
  ),
  '215001': FaultDefinition(
    title:
        'Advanced communication, intelligent battery sensor — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving advanced communication, intelligent battery sensor: operation fault. The code alone does not establish which part caused it.',
  ),
  '215101': FaultDefinition(
    title:
        'Intelligent battery sensor, plausibility — temperature inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intelligent battery sensor, plausibility: temperature inconsistent. The code alone does not establish which part caused it.',
  ),
  '215104': FaultDefinition(
    title: 'Intelligent battery sensor, plausibility — voltage inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intelligent battery sensor, plausibility: voltage inconsistent. The code alone does not establish which part caused it.',
  ),
  '215108': FaultDefinition(
    title:
        'Intelligent battery sensor, plausibility — electricity inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intelligent battery sensor, plausibility: electricity inconsistent. The code alone does not establish which part caused it.',
  ),
  '215109': FaultDefinition(
    title: 'Battery, battery electronics — defect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery electronics: defect. The code alone does not establish which part caused it.',
  ),
  '21510A': FaultDefinition(
    title:
        'Battery, battery sensor, working area — discharge current above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor, working area: discharge current above expected range. The code alone does not establish which part caused it.',
  ),
  '21510B': FaultDefinition(
    title:
        'Battery, battery sensor, working range — charging current above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor, working range: charging current above expected range. The code alone does not establish which part caused it.',
  ),
  '21510C': FaultDefinition(
    title: 'Battery, battery sensor — isolating switch open',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor: isolating switch open. The code alone does not establish which part caused it.',
  ),
  '21510D': FaultDefinition(
    title:
        'Battery, battery sensor, working area — voltage above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor, working area: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '21510E': FaultDefinition(
    title:
        'Battery, battery sensor, working area — temperature above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor, working area: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '21510F': FaultDefinition(
    title:
        'Battery, battery sensor, working range — voltage below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor, working range: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '215110': FaultDefinition(
    title:
        'Battery, battery sensor, plausibility — temperature or cell voltage above expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor, plausibility: temperature or cell voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '215203': FaultDefinition(
    title:
        'Battery, battery sensor, working area — temperature below expected range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery, battery sensor, working area: temperature below expected range. The code alone does not establish which part caused it.',
  ),
  '215701': FaultDefinition(
    title: 'Intelligent battery sensor, self-diagnosis — system error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intelligent battery sensor, self-diagnosis: system error. The code alone does not establish which part caused it.',
  ),
  '215801': FaultDefinition(
    title:
        'Intelligent battery sensor, wake-up line, electrical — short to battery positive or ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intelligent battery sensor, wake-up line, electrical: short to battery positive or ground. The code alone does not establish which part caused it.',
  ),
  '215901': FaultDefinition(
    title: 'Intelligent battery sensor, compatibility — version not plausible',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intelligent battery sensor, compatibility: version not plausible. The code alone does not establish which part caused it.',
  ),
  '215A01': FaultDefinition(
    title:
        'Intelligent battery sensor, wake-up line, electrical — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving intelligent battery sensor, wake-up line, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '216002': FaultDefinition(
    title: 'MSA, monitoring — time-out',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving msa, monitoring: time-out. The code alone does not establish which part caused it.',
  ),
  '216104': FaultDefinition(
    title: 'MSA, Monitoring — Start Delay',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving msa, monitoring: start delay. The code alone does not establish which part caused it.',
  ),
  '216110': FaultDefinition(
    title: 'Gear starter — number of MSA reflex starts exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving gear starter: number of msa reflex starts exceeded. The code alone does not establish which part caused it.',
  ),
  '216111': FaultDefinition(
    title: 'Starter unit pinion starter — number of engine starts exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving starter unit pinion starter: number of engine starts exceeded. The code alone does not establish which part caused it.',
  ),
  '216112': FaultDefinition(
    title:
        'Pinion starter, component protection function — Critical threshold reached',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter, component protection function: critical threshold reached. The code alone does not establish which part caused it.',
  ),
  '216113': FaultDefinition(
    title:
        'Pinion starter, component protection function — warning threshold reached',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter, component protection function: warning threshold reached. The code alone does not establish which part caused it.',
  ),
  '216114': FaultDefinition(
    title:
        'Pinion starter — starting capability endangered, limit value on-board electrical system voltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: starting capability endangered, limit value on-board electrical system voltage. The code alone does not establish which part caused it.',
  ),
  '216115': FaultDefinition(
    title: 'Pinion starter — Start attempt detected with blocked starter',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: start attempt detected with blocked starter. The code alone does not establish which part caused it.',
  ),
  '216116': FaultDefinition(
    title:
        'Pinion starter — start attempt detected in the event of a fault in the combustion system',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: start attempt detected in the event of a fault in the combustion system. The code alone does not establish which part caused it.',
  ),
  '216117': FaultDefinition(
    title:
        'Pinion starter — start attempt detected in the event of a fault in the fuel system',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: start attempt detected in the event of a fault in the fuel system. The code alone does not establish which part caused it.',
  ),
  '216118': FaultDefinition(
    title:
        'RitzelStarter — Start attempt at property protection detected EWS release during start attempt incorrect or delayed or delayed. Not available',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving ritzelstarter: start attempt at property protection detected ews release during start attempt incorrect or delayed or delayed. not available. The code alone does not establish which part caused it.',
  ),
  '216119': FaultDefinition(
    title: 'Pinion starter — open circuit Starter control (KL50 / KL30)',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: open circuit starter control (kl50 / kl30). The code alone does not establish which part caused it.',
  ),
  '21611A': FaultDefinition(
    title:
        'Pinion starter — starting capability limit VM target not reached, starting torque could not be set up. High countertorque and/or undervoltage',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: starting capability limit vm target not reached, starting torque could not be set up. high countertorque and/or undervoltage. The code alone does not establish which part caused it.',
  ),
  '21611B': FaultDefinition(
    title:
        'Pinion starter — Start attempt detected in case of overvoltage. Prerequisite: A jump-start with a truck',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: start attempt detected in case of overvoltage. prerequisite: a jump-start with a truck. The code alone does not establish which part caused it.',
  ),
  '21611C': FaultDefinition(
    title:
        'Pinion starter — on-board electrical system tension not sufficient during start attempt',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving pinion starter: on-board electrical system tension not sufficient during start attempt. The code alone does not establish which part caused it.',
  ),
  '218001': FaultDefinition(
    title: 'Battery Charger — Internal Error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery charger: internal error. The code alone does not establish which part caused it.',
  ),
  '218101': FaultDefinition(
    title: 'Battery charging unit, line monitoring — operation fault',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery charging unit, line monitoring: operation fault. The code alone does not establish which part caused it.',
  ),
  '218201': FaultDefinition(
    title: 'Battery charging unit, secondary battery — defective',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery charging unit, secondary battery: defective. The code alone does not establish which part caused it.',
  ),
  '218301': FaultDefinition(
    title:
        'Battery charging unit — failure in the separating element/cable tree',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving battery charging unit: failure in the separating element/cable tree. The code alone does not establish which part caused it.',
  ),
  '218401': FaultDefinition(
    title:
        'Starting voltage converter/starter generator, drive — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving starting voltage converter/starter generator, drive: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '218402': FaultDefinition(
    title:
        'Starting voltage converter/starter generator, drive — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving starting voltage converter/starter generator, drive: short to ground. The code alone does not establish which part caused it.',
  ),
  '218404': FaultDefinition(
    title: 'Start voltage converter/starter generator, drive — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving start voltage converter/starter generator, drive: open circuit. The code alone does not establish which part caused it.',
  ),
  '219001': FaultDefinition(
    title: 'Active engine mount, electrical — short to battery positive',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving active engine mount, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '219002': FaultDefinition(
    title: 'Active engine mount, electrical — short to ground',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving active engine mount, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '219004': FaultDefinition(
    title: 'Active engine mount, electrical — open circuit',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving active engine mount, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '21A001': FaultDefinition(
    title: 'Assembly mode — active',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving assembly mode: active. The code alone does not establish which part caused it.',
  ),
  '21A023': FaultDefinition(
    title:
        'Internal combustion engine — false start or engine started without driver influence',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving internal combustion engine: false start or engine started without driver influence. The code alone does not establish which part caused it.',
  ),
  '21A210': FaultDefinition(
    title:
        'Communication — signal (status wavelength FSSP) in FA-CAN, message (services 0x5E0, electrical request consumer ID2: 68): invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving communication: signal (status wavelength fssp) in fa-can, message (services 0x5e0, electrical request consumer id2: 68): invalid. The code alone does not establish which part caused it.',
  ),
  '21A310': FaultDefinition(
    title: 'Emergency operation 1 — multiple related faults for DME coupling',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving emergency operation 1: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A330': FaultDefinition(
    title: 'Emergency operation 2 — multiple related faults for DME coupling',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving emergency operation 2: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A350': FaultDefinition(
    title: 'Emergency operation 3 — multiple related faults for DME coupling',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving emergency operation 3: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A370': FaultDefinition(
    title: 'Emergency operation 4 — multiple related faults for DME coupling',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving emergency operation 4: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A372': FaultDefinition(
    title: 'Emergency running 5 — multiple related faults for DME coupling',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving emergency running 5: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A411': FaultDefinition(
    title:
        'Breakdown data memory, measured value — Address measuring channel invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory, measured value: address measuring channel invalid. The code alone does not establish which part caused it.',
  ),
  '21A412': FaultDefinition(
    title:
        'Breakdown data memory — Configured memory requirement exceeds valid range',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory: configured memory requirement exceeds valid range. The code alone does not establish which part caused it.',
  ),
  '21A413': FaultDefinition(
    title:
        'Breakdown data memory — Application modified at runtime or CRC collision with footer possible',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory: application modified at runtime or crc collision with footer possible. The code alone does not establish which part caused it.',
  ),
  '21A414': FaultDefinition(
    title: 'Breakdown data memory, measured value — memory area invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory, measured value: memory area invalid. The code alone does not establish which part caused it.',
  ),
  '21A415': FaultDefinition(
    title: 'Breakdown data memory, measured value — memory area exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory, measured value: memory area exceeded. The code alone does not establish which part caused it.',
  ),
  '21A416': FaultDefinition(
    title: 'Breakdown memory — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown memory: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '21A417': FaultDefinition(
    title: 'Breakdown data memory — maximum sector change achieved',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory: maximum sector change achieved. The code alone does not establish which part caused it.',
  ),
  '21A418': FaultDefinition(
    title: 'Breakdown data memory, header — address measuring channel invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory, header: address measuring channel invalid. The code alone does not establish which part caused it.',
  ),
  '21A419': FaultDefinition(
    title: 'Breakdown data memory, header — memory area invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory, header: memory area invalid. The code alone does not establish which part caused it.',
  ),
  '21A41A': FaultDefinition(
    title: 'Breakdown data memory, header — memory area exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving breakdown data memory, header: memory area exceeded. The code alone does not establish which part caused it.',
  ),
  '21A430': FaultDefinition(
    title: 'Long-term quality memory — multiple related faults',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving long-term quality memory: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '21A431': FaultDefinition(
    title: 'Long-term quality memory — maximum sector change achieved',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving long-term quality memory: maximum sector change achieved. The code alone does not establish which part caused it.',
  ),
  '21A432': FaultDefinition(
    title: 'Long-term quality memory, measured value — address invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving long-term quality memory, measured value: address invalid. The code alone does not establish which part caused it.',
  ),
  '21A433': FaultDefinition(
    title:
        'Long-term quality memory — Application modified at runtime or CRC collision with footer possible',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving long-term quality memory: application modified at runtime or crc collision with footer possible. The code alone does not establish which part caused it.',
  ),
  '21A434': FaultDefinition(
    title: 'Long-term quality memory, measured value — memory area exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving long-term quality memory, measured value: memory area exceeded. The code alone does not establish which part caused it.',
  ),
  '21A435': FaultDefinition(
    title:
        'DME — internal error [software, TripRec - Gen.] Trigger, measured value: address measuring channel invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [software, triprec - gen.] trigger, measured value: address measuring channel invalid. The code alone does not establish which part caused it.',
  ),
  '21A436': FaultDefinition(
    title:
        'DME — internal error [software, TripRec - Gen.] Trigger: parameter change at runtime',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving dme: internal error [software, triprec - gen.] trigger: parameter change at runtime. The code alone does not establish which part caused it.',
  ),
  '21B210': FaultDefinition(
    title:
        'Functional unlocking, M-Drive Professional — unlocking code invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving functional unlocking, m-drive professional: unlocking code invalid. The code alone does not establish which part caused it.',
  ),
  '21B212': FaultDefinition(
    title:
        'DME report: water injection, knocking combustion during water injection cylinder 1',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: water injection, knocking combustion during water injection cylinder 1. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '21B213': FaultDefinition(
    title:
        'DME report: water injection, knocking combustion during water injection cylinder 2',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: water injection, knocking combustion during water injection cylinder 2. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '21B214': FaultDefinition(
    title:
        'DME report: water injection, knocking combustion during water injection cylinder 3',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: water injection, knocking combustion during water injection cylinder 3. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '21B215': FaultDefinition(
    title:
        'DME report: water injection, knocking combustion during water injection cylinder 4',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: water injection, knocking combustion during water injection cylinder 4. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '21B216': FaultDefinition(
    title:
        'DME report: water injection, knocking combustion during water injection cylinder 5',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: water injection, knocking combustion during water injection cylinder 5. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '21B217': FaultDefinition(
    title:
        'DME report: water injection, knocking combustion during water injection cylinder 6',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: water injection, knocking combustion during water injection cylinder 6. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '21B218': FaultDefinition(
    title:
        'DME report: water injection, knocking combustion of all cylinders during water injection',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: water injection, knocking combustion of all cylinders during water injection. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '21B21E': FaultDefinition(
    title: 'CBS client — reduction of service interval due to oil level',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving cbs client: reduction of service interval due to oil level. The code alone does not establish which part caused it.',
  ),
  '21B235': FaultDefinition(
    title:
        'Oil pressure plausibility checking, plausibility checking oil pressure signal — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving oil pressure plausibility checking, plausibility checking oil pressure signal: signal error. The code alone does not establish which part caused it.',
  ),
  '230008': FaultDefinition(
    title: 'Communication sleep coordinator — message inconsistent',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving communication sleep coordinator: message inconsistent. The code alone does not establish which part caused it.',
  ),
  '231501': FaultDefinition(
    title: 'Error memory entry — transmit buffer full',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving error memory entry: transmit buffer full. The code alone does not establish which part caused it.',
  ),
  '231502': FaultDefinition(
    title: 'Error memory entry — Send failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving error memory entry: send failed. The code alone does not establish which part caused it.',
  ),
  '231F04': FaultDefinition(
    title: 'A- / FA-CAN, messages (transmission) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a- / fa-can, messages (transmission): not received. The code alone does not establish which part caused it.',
  ),
  '233004': FaultDefinition(
    title:
        'FA-CAN, message (OBD sensor diagnostic status, 0x5E0) — not received, transmitter combination',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (obd sensor diagnostic status, 0x5e0): not received, transmitter combination. The code alone does not establish which part caused it.',
  ),
  '240001': FaultDefinition(
    title: 'Radar sensor — sensor defective',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving radar sensor: sensor defective. The code alone does not establish which part caused it.',
  ),
  '240002': FaultDefinition(
    title: 'Camera — dirty or lighting conditions inappropriate',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving camera: dirty or lighting conditions inappropriate. The code alone does not establish which part caused it.',
  ),
  '240003': FaultDefinition(
    title: 'Radar sensor — sensor dirty or hidden',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving radar sensor: sensor dirty or hidden. The code alone does not establish which part caused it.',
  ),
  '240004': FaultDefinition(
    title: 'DME report: valve stroke correction not successful',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: valve stroke correction not successful. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '240005': FaultDefinition(
    title: 'eSUV — open or closed clamping eSUV (master) bank1',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving esuv: open or closed clamping esuv (master) bank1. The code alone does not establish which part caused it.',
  ),
  '240006': FaultDefinition(
    title: 'eSUV — open or closed clamping eSUV (slave) bank1',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving esuv: open or closed clamping esuv (slave) bank1. The code alone does not establish which part caused it.',
  ),
  '240007': FaultDefinition(
    title: 'eSUV — open or closed clamping eSUV (master) bank2',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving esuv: open or closed clamping esuv (master) bank2. The code alone does not establish which part caused it.',
  ),
  '240008': FaultDefinition(
    title: 'eSUV — open or closed clamping eSUV (slave) bank2',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving esuv: open or closed clamping esuv (slave) bank2. The code alone does not establish which part caused it.',
  ),
  '240009': FaultDefinition(
    title: 'Electric fan, self-diagnosis stage 1 — slight fan error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving electric fan, self-diagnosis stage 1: slight fan error. The code alone does not establish which part caused it.',
  ),
  '24000A': FaultDefinition(
    title: 'DME report: electrical fans, communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: electrical fans, communication error. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '32B400': FaultDefinition(
    title:
        'Message (ST AKKS 2 LIN, 0x2C, LIN), Timeout — Message (Status AKKS 2 LIN) of AKKS 2 failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving message (st akks 2 lin, 0x2c, lin), timeout: message (status akks 2 lin) of akks 2 failed. The code alone does not establish which part caused it.',
  ),
  '32B700': FaultDefinition(
    title:
        'Message (ST DIAG OBD 20 PT LIN AKKS 2, 0x2B, LIN), Alivecounter — Message (Status Diagnosis OBD 20 Powertrain LIN AKKS 2) of AKKS 2 not current',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving message (st diag obd 20 pt lin akks 2, 0x2b, lin), alivecounter: message (status diagnosis obd 20 powertrain lin akks 2) of akks 2 not current. The code alone does not establish which part caused it.',
  ),
  '32B800': FaultDefinition(
    title:
        'Message (ST DIAG OBD 20 PT LIN AKKS 2, 0x2B, LIN), Timeout — Message (Status Diagnosis OBD 20 Powertrain LIN AKKS 2) of AKKS 2 failed',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving message (st diag obd 20 pt lin akks 2, 0x2b, lin), timeout: message (status diagnosis obd 20 powertrain lin akks 2) of akks 2 failed. The code alone does not establish which part caused it.',
  ),
  'CD840A': FaultDefinition(
    title: 'DME report: fA-CAN Control Module Bus OFF',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: fa-can control module bus off. Review the operating context and related faults before drawing a diagnosis.',
  ),
  'CD841F': FaultDefinition(
    title: 'FlexRay Bus — Line error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray bus: line error. The code alone does not establish which part caused it.',
  ),
  'CD8420': FaultDefinition(
    title: 'FlexRay Bus — communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray bus: communication error. The code alone does not establish which part caused it.',
  ),
  'CD8486': FaultDefinition(
    title: 'DME report: a-CAN Control Module Bus OFF',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged this condition: a-can control module bus off. Review the operating context and related faults before drawing a diagnosis.',
  ),
  'CD8801': FaultDefinition(
    title: 'FlexRay Controller, Startup — maximum startup time exceeded',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray controller, startup: maximum startup time exceeded. The code alone does not establish which part caused it.',
  ),
  'CD8B02': FaultDefinition(
    title:
        'FlexRay, message (diagnosis OBD 1, 263.3.4) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (diagnosis obd 1, 263.3.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CD8B04': FaultDefinition(
    title: 'FlexRay, message (diagnosis OBD 1, 263.3.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (diagnosis obd 1, 263.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD8BFF': FaultDefinition(
    title: 'Network error — only for testing',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving network error: only for testing. The code alone does not establish which part caused it.',
  ),
  'CD8E10': FaultDefinition(
    title: 'LIN Bus — communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lin bus: communication error. The code alone does not establish which part caused it.',
  ),
  'CD8E11': FaultDefinition(
    title:
        'LIN, communication (charge unit for auxiliary battery) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lin, communication (charge unit for auxiliary battery): not received. The code alone does not establish which part caused it.',
  ),
  'CD8E12': FaultDefinition(
    title: 'LIN, communication (generator) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lin, communication (generator): not received. The code alone does not establish which part caused it.',
  ),
  'CD8F01': FaultDefinition(
    title: 'LIN, communication (intelligent battery sensor) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving lin, communication (intelligent battery sensor): not received. The code alone does not establish which part caused it.',
  ),
  'CD9432': FaultDefinition(
    title:
        'A-CAN, message (status transmission control unit, 0x39A) at low voltage — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (status transmission control unit, 0x39a) at low voltage: not received. The code alone does not establish which part caused it.',
  ),
  'CD9435': FaultDefinition(
    title:
        'A-CAN, message (transmission train data, 0x1AF) at low voltage — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (transmission train data, 0x1af) at low voltage: not received. The code alone does not establish which part caused it.',
  ),
  'CD9437': FaultDefinition(
    title:
        'FlexRay, Message (request wheel torque drivetrain sum stabilization / nominal distribution longitudinal torque front axle rear axle, 43.1.4) under voltage — communication error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / nominal distribution longitudinal torque front axle rear axle, 43.1.4) under voltage: communication error. The code alone does not establish which part caused it.',
  ),
  'CD944D': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.0.1) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is speed wheel, 46.0.1): signal error. The code alone does not establish which part caused it.',
  ),
  'CD9502': FaultDefinition(
    title:
        'FlexRay, Message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9504': FaultDefinition(
    title:
        'FlexRay, Message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD9508': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9602': FaultDefinition(
    title:
        'FlexRay, message (request wheel torque powertrain sum recuperation, 47.0.2) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque powertrain sum recuperation, 47.0.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9604': FaultDefinition(
    title:
        'FlexRay, message (request wheel torque drivetrain sum recuperation, 47.0.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum recuperation, 47.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9608': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque powertrain sum recuperation, 47.0.2) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque powertrain sum recuperation, 47.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9702': FaultDefinition(
    title:
        'FlexRay, message (configuration switch driving dynamics, 272.4.8) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (configuration switch driving dynamics, 272.4.8): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9704': FaultDefinition(
    title:
        'FlexRay, message (configuration switch driving dynamics, 272.4.8) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (configuration switch driving dynamics, 272.4.8): not received. The code alone does not establish which part caused it.',
  ),
  'CD9708': FaultDefinition(
    title:
        'FlexRay, Message (Drive Dynamics Switch configuration, 272.4.8) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (drive dynamics switch configuration, 272.4.8): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9710': FaultDefinition(
    title:
        'FlexRay, message (configuration switch driving dynamics 2, 272.4.8) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (configuration switch driving dynamics 2, 272.4.8): not received. The code alone does not establish which part caused it.',
  ),
  'CD9902': FaultDefinition(
    title: 'FlexRay, message (vehicle speed, 55.3.4) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CD9904': FaultDefinition(
    title: 'FlexRay, message (vehicle speed, 55.3.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD9908': FaultDefinition(
    title: 'FlexRay, Message (vehicle speed, 55.3.4) — checksum mismatch',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CD9932': FaultDefinition(
    title:
        'FlexRay, message (yaw velocity vehicle, 56.0.2) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (yaw velocity vehicle, 56.0.2): message counter error. The code alone does not establish which part caused it.',
  ),
  'CD9933': FaultDefinition(
    title: 'FlexRay, message (yaw velocity vehicle, 56.0.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (yaw velocity vehicle, 56.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9934': FaultDefinition(
    title:
        'FlexRay, message (yaw velocity vehicle, 56.0.2) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (yaw velocity vehicle, 56.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9A02': FaultDefinition(
    title: 'FlexRay, Message (Is braking torque sum, 43.3.4) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is braking torque sum, 43.3.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9A04': FaultDefinition(
    title:
        'FlexRay, message (actual braking torque sum, 43.3.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (actual braking torque sum, 43.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD9A08': FaultDefinition(
    title:
        'FlexRay, Message (is braking torque sum, 43.3.4) — checksum mismatch',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is braking torque sum, 43.3.4): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CD9A10': FaultDefinition(
    title:
        'FlexRay, message (status contact hand brake, 243.1.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (status contact hand brake, 243.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9B02': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.1.2) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is speed wheel, 46.1.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9B04': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.1.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is speed wheel, 46.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9B08': FaultDefinition(
    title: 'FlexRay, Message (is speed wheel, 46.1.2) — checksum mismatch',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is speed wheel, 46.1.2): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CD9D02': FaultDefinition(
    title:
        'FlexRay, message (longitudinal acceleration center of gravity, 55.0.2) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (longitudinal acceleration center of gravity, 55.0.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9D04': FaultDefinition(
    title:
        'FlexRay, message (longitudinal acceleration center of gravity, 55.0.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (longitudinal acceleration center of gravity, 55.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9D08': FaultDefinition(
    title:
        'FlexRay, message (longitudinal acceleration center of gravity, 55.0.2) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (longitudinal acceleration center of gravity, 55.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9E02': FaultDefinition(
    title:
        'FlexRay, message (center of gravity transverse acceleration, 55.0.2) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (center of gravity transverse acceleration, 55.0.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9E04': FaultDefinition(
    title:
        'FlexRay, message (center of gravity transverse acceleration, 55.0.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (center of gravity transverse acceleration, 55.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9E08': FaultDefinition(
    title:
        'FlexRay, message (center of gravity transverse acceleration, 55.0.2) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (center of gravity transverse acceleration, 55.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9F02': FaultDefinition(
    title: 'FlexRay, message (stabilization status DSC, 47.1.2) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9F04': FaultDefinition(
    title: 'FlexRay, message (stabilization status DSC, 47.1.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9F08': FaultDefinition(
    title:
        'FlexRay, message (stabilization status DSC, 47.1.2) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9F11': FaultDefinition(
    title: 'FlexRay, message (stabilization status DSC, 47.1.2) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): signal error. The code alone does not establish which part caused it.',
  ),
  'CD9F12': FaultDefinition(
    title:
        'FlexRay, message (configuration of the vehicle dynamics switch, 272.4.8) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (configuration of the vehicle dynamics switch, 272.4.8): signal error. The code alone does not establish which part caused it.',
  ),
  'CD9F13': FaultDefinition(
    title: 'FlexRay, message (vehicle speed, 55.3.4) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): signal error. The code alone does not establish which part caused it.',
  ),
  'CDA002': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque drivetrain sum FAS, 33.1.4) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum fas, 33.1.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA004': FaultDefinition(
    title:
        'FlexRay, message (request wheel torque drivetrain sum FAS, 33.1.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum fas, 33.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA008': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque drivetrain sum FAS, 33.1.4) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request wheel torque drivetrain sum fas, 33.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA038': FaultDefinition(
    title:
        'FlexRay, message (information data target object speed control, 71.7.32) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (information data target object speed control, 71.7.32): not received. The code alone does not establish which part caused it.',
  ),
  'CDA102': FaultDefinition(
    title: 'FlexRay, Message (inclination roadway, 56.1.2) — Alivetest',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (inclination roadway, 56.1.2): alivetest. The code alone does not establish which part caused it.',
  ),
  'CDA104': FaultDefinition(
    title: 'FlexRay, message (inclination roadway, 56.1.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (inclination roadway, 56.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA108': FaultDefinition(
    title: 'FlexRay, Message (inclination roadway, 56.1.2) — checksum mismatch',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (inclination roadway, 56.1.2): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CDA204': FaultDefinition(
    title:
        'FlexRay, Message (Request Power Electric EPS, 234.0.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (request power electric eps, 234.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA302': FaultDefinition(
    title:
        'FlexRay, message (status vehicle standstill, 263.1.4) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (status vehicle standstill, 263.1.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDA304': FaultDefinition(
    title:
        'FlexRay, message (status vehicle standstill, 263.1.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (status vehicle standstill, 263.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA308': FaultDefinition(
    title:
        'FlexRay, message (status vehicle standstill, 263.1.4) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (status vehicle standstill, 263.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA321': FaultDefinition(
    title: 'FlexRay, Message (units BN2020, 252.0.4 ) — Signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (units bn2020, 252.0.4 ): signal error. The code alone does not establish which part caused it.',
  ),
  'CDA322': FaultDefinition(
    title: 'FlexRay, message (units BN2020, 252.0.4 ) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (units bn2020, 252.0.4 ): not received. The code alone does not establish which part caused it.',
  ),
  'CDA402': FaultDefinition(
    title:
        'FlexRay, Message (actual steering angle front axle, 57.1.2) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (actual steering angle front axle, 57.1.2): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDA404': FaultDefinition(
    title:
        'FlexRay, message (actual steering angle front axle, 57.1.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (actual steering angle front axle, 57.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA408': FaultDefinition(
    title:
        'FlexRay, Message (actual steering angle front axle, 57.1.2) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (actual steering angle front axle, 57.1.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA421': FaultDefinition(
    title:
        'FlexRay, message (Secured door sensor status, 256.3.4) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (secured door sensor status, 256.3.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA422': FaultDefinition(
    title:
        'FlexRay, message (Secured door sensor status, 256.3.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (secured door sensor status, 256.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA423': FaultDefinition(
    title:
        'FlexRay, Message (Secured door sensor status, 256.3.4) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (secured door sensor status, 256.3.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA426': FaultDefinition(
    title:
        'FlexRay, message (status distribution longitudinal torque front axle rear axle, 19.3.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (status distribution longitudinal torque front axle rear axle, 19.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA428': FaultDefinition(
    title:
        'FlexRay, message (status distribution longitudinal torque front axle rear axle, 19.3.4) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (status distribution longitudinal torque front axle rear axle, 19.3.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA429': FaultDefinition(
    title:
        'FlexRay, message (status distribution longitudinal torque front axle rear axle, 19.3.4) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (status distribution longitudinal torque front axle rear axle, 19.3.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA435': FaultDefinition(
    title: 'FlexRay, Message (mass/weight vehicle, 108.1.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (mass/weight vehicle, 108.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA451': FaultDefinition(
    title:
        'FlexRay, message (actual steering torque driver actuator, 49.0.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (actual steering torque driver actuator, 49.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA452': FaultDefinition(
    title: 'FlexRay, Message (Is power rack, 49.0.2) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is power rack, 49.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA491': FaultDefinition(
    title:
        'FlexRay, Message (target distribution longitudinal torque front axle rear axle, 43.1.4) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (target distribution longitudinal torque front axle rear axle, 43.1.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDA492': FaultDefinition(
    title:
        'FlexRay, Message (target distribution longitudinal torque front axle rear axle, 43.1.4) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (target distribution longitudinal torque front axle rear axle, 43.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA493': FaultDefinition(
    title:
        'FlexRay, message (target distribution longitudinal torque front axle rear axle, 43.1.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (target distribution longitudinal torque front axle rear axle, 43.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA494': FaultDefinition(
    title:
        'FlexRay, message (target braking torque sum coordinated, 63.1.4) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (target braking torque sum coordinated, 63.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA512': FaultDefinition(
    title:
        'FA-CAN, message (status belt contact seat occupancy, 0x297) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (status belt contact seat occupancy, 0x297): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA514': FaultDefinition(
    title:
        'FA-CAN, message (status belt contact seat occupancy, 0x297) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (status belt contact seat occupancy, 0x297): not received. The code alone does not establish which part caused it.',
  ),
  'CDA518': FaultDefinition(
    title:
        'FA-CAN, message (status belt contact seat occupancy, 0x297) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (status belt contact seat occupancy, 0x297): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA519': FaultDefinition(
    title:
        'FA-CAN, message (status energy voltage current, 0x399) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (status energy voltage current, 0x399): not received. The code alone does not establish which part caused it.',
  ),
  'CDA524': FaultDefinition(
    title: 'FA-CAN, message (Electric fuel pump status, 0x335) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (electric fuel pump status, 0x335): not received. The code alone does not establish which part caused it.',
  ),
  'CDA525': FaultDefinition(
    title: 'FA-CAN, message (status Electric fuel pump, 0x335) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (status electric fuel pump, 0x335): signal error. The code alone does not establish which part caused it.',
  ),
  'CDA67F': FaultDefinition(
    title:
        'Communication — signal (status wavelength FSSP) in FA-CAN, message (services 0x5E0, electrical request consumer ID2: 68): invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving communication: signal (status wavelength fssp) in fa-can, message (services 0x5e0, electrical request consumer id2: 68): invalid. The code alone does not establish which part caused it.',
  ),
  'CDA804': FaultDefinition(
    title: 'FA-CAN, message (relative time, 0x328) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (relative time, 0x328): not received. The code alone does not establish which part caused it.',
  ),
  'CDAB04': FaultDefinition(
    title: 'FA-CAN, message (Reverse status, 0x3B0) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (reverse status, 0x3b0): not received. The code alone does not establish which part caused it.',
  ),
  'CDAC04': FaultDefinition(
    title:
        'FA-CAN, message (status transmission control unit, 0x39A) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (status transmission control unit, 0x39a): not received. The code alone does not establish which part caused it.',
  ),
  'CDAD04': FaultDefinition(
    title:
        'FA-CAN, Message (control of crash shutdown electric fuel pump, 0x135) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (control of crash shutdown electric fuel pump, 0x135): not received. The code alone does not establish which part caused it.',
  ),
  'CDAE04': FaultDefinition(
    title: 'FA-CAN, message (time/date, 0x2F8) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (time/date, 0x2f8): not received. The code alone does not establish which part caused it.',
  ),
  'CDAF04': FaultDefinition(
    title: 'FA-CAN, message (ZV and flap state, 0x2FC) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (zv and flap state, 0x2fc): not received. The code alone does not establish which part caused it.',
  ),
  'CDB204': FaultDefinition(
    title: 'FA-CAN, message (external temperature, 0x2CA) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (external temperature, 0x2ca): not received. The code alone does not establish which part caused it.',
  ),
  'CDB302': FaultDefinition(
    title: 'FA-CAN, message (data display gear train, 0x3FD) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): alive check. The code alone does not establish which part caused it.',
  ),
  'CDB304': FaultDefinition(
    title: 'FA-CAN, message (data display gear train, 0x3FD) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): not received. The code alone does not establish which part caused it.',
  ),
  'CDB308': FaultDefinition(
    title:
        'FA-CAN, Message (data display gear train, 0x3FD) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDB404': FaultDefinition(
    title: 'FA-CAN, message (vehicle condition, 0x3A0) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (vehicle condition, 0x3a0): not received. The code alone does not establish which part caused it.',
  ),
  'CDB504': FaultDefinition(
    title: 'FA-CAN, message (km/range, 0x330) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (km/range, 0x330): not received. The code alone does not establish which part caused it.',
  ),
  'CDB602': FaultDefinition(
    title: 'FA-CAN, Message (terminal, 0x12F) — Alivecheck',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (terminal, 0x12f): alivecheck. The code alone does not establish which part caused it.',
  ),
  'CDB604': FaultDefinition(
    title: 'FA-CAN, message (terminal, 0x12F) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (terminal, 0x12f): not received. The code alone does not establish which part caused it.',
  ),
  'CDB608': FaultDefinition(
    title: 'FA-CAN, Message (terminal, 0x12F) — Checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (terminal, 0x12f): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDB804': FaultDefinition(
    title:
        'FA-CAN, embassy (conditioning system request, 0x2F9) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, embassy (conditioning system request, 0x2f9): not received. The code alone does not establish which part caused it.',
  ),
  'CDB904': FaultDefinition(
    title: 'FA-CAN, message (diagnosis OBD transmission, 0x396) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (diagnosis obd transmission, 0x396): not received. The code alone does not establish which part caused it.',
  ),
  'CDBA04': FaultDefinition(
    title: 'FA-CAN, Embassy (Global FZM, 0x3A5) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, embassy (global fzm, 0x3a5): not received. The code alone does not establish which part caused it.',
  ),
  'CDBB02': FaultDefinition(
    title:
        'A-CAN, Message (Request torque crankshaft gearbox 2, 0xA0) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDBB04': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox 2, 0xA0) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): not received. The code alone does not establish which part caused it.',
  ),
  'CDBB08': FaultDefinition(
    title:
        'A-CAN, Message (request torque crankshaft gearbox 2, 0xA0) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDBB09': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox 2, 0xA0) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): signal error. The code alone does not establish which part caused it.',
  ),
  'CDBB24': FaultDefinition(
    title:
        'Communication — signal (speed transmission train output) in A-CAN, message (transmission train data, 0x1AF): invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving communication: signal (speed transmission train output) in a-can, message (transmission train data, 0x1af): invalid. The code alone does not establish which part caused it.',
  ),
  'CDBB26': FaultDefinition(
    title:
        'Communication — signal (status shift active transmission) in A- / FA-CAN, message (status transmission control, 0x39A): invalid',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving communication: signal (status shift active transmission) in a- / fa-can, message (status transmission control, 0x39a): invalid. The code alone does not establish which part caused it.',
  ),
  'CDBE02': FaultDefinition(
    title:
        'A-CAN, message (indicating speed motor dynamics, 0xF8) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (indicating speed motor dynamics, 0xf8): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDBE04': FaultDefinition(
    title:
        'A-CAN, message (indication speed motor dynamics, 0xF8) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (indication speed motor dynamics, 0xf8): not received. The code alone does not establish which part caused it.',
  ),
  'CDBF04': FaultDefinition(
    title:
        'A-CAN, message (status transmission control unit, 0x39A) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (status transmission control unit, 0x39a): not received. The code alone does not establish which part caused it.',
  ),
  'CDC004': FaultDefinition(
    title: 'A-CAN, message (diagnosis OBD transmission, 0x396) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (diagnosis obd transmission, 0x396): not received. The code alone does not establish which part caused it.',
  ),
  'CDC102': FaultDefinition(
    title: 'A-CAN, message (transmission train data, 0x1AF) — Alive check',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (transmission train data, 0x1af): alive check. The code alone does not establish which part caused it.',
  ),
  'CDC104': FaultDefinition(
    title: 'A-CAN, message (transmission train data, 0x1AF) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (transmission train data, 0x1af): not received. The code alone does not establish which part caused it.',
  ),
  'CDC108': FaultDefinition(
    title:
        'A-CAN, message (transmission train data, 0x1AF) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (transmission train data, 0x1af): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDC109': FaultDefinition(
    title: 'A-CAN, message (transmission train data, 0x1AF) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (transmission train data, 0x1af): signal error. The code alone does not establish which part caused it.',
  ),
  'CDC202': FaultDefinition(
    title:
        'A-CAN, Message (crankshaft torque request, 0xB0) — message counter error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (crankshaft torque request, 0xb0): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDC204': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox, 0xB0) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (request torque crankshaft gearbox, 0xb0): not received. The code alone does not establish which part caused it.',
  ),
  'CDC208': FaultDefinition(
    title:
        'A-CAN, Message (request torque crankshaft transmission, 0xB0) — checksum incorrect',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (request torque crankshaft transmission, 0xb0): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDC209': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox, 0xB0) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (request torque crankshaft gearbox, 0xb0): signal error. The code alone does not establish which part caused it.',
  ),
  'CDC304': FaultDefinition(
    title: 'A-CAN, message (Electric fuel pump status, 0x335) — not received',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (electric fuel pump status, 0x335): not received. The code alone does not establish which part caused it.',
  ),
  'CDC310': FaultDefinition(
    title: 'A-CAN, message (Electric fuel pump status, 0x335) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving a-can, message (electric fuel pump status, 0x335): signal error. The code alone does not establish which part caused it.',
  ),
  'CDDB09': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.0.1) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving flexray, message (is speed wheel, 46.0.1): signal error. The code alone does not establish which part caused it.',
  ),
  'CDF209': FaultDefinition(
    title: 'FA-CAN, Message (data display gear train, 0x3FD) — signal error',
    system: 'S55 DME reference',
    explanation:
        'The S55 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): signal error. The code alone does not establish which part caused it.',
  ),
};

const n20DmeFaultDefinitions = <String, FaultDefinition>{
  '021200': FaultDefinition(
    title: 'DME report: energy-saving mode active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged this condition: energy-saving mode active. Review the operating context and related faults before drawing a diagnosis.',
  ),
  '021208': FaultDefinition(
    title: 'DME, coding — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: not received. The code alone does not establish which part caused it.',
  ),
  '021209': FaultDefinition(
    title: 'DME, coding — spelling error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: spelling error. The code alone does not establish which part caused it.',
  ),
  '02120A': FaultDefinition(
    title: 'DME, coding — Signature verification incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: signature verification incorrect. The code alone does not establish which part caused it.',
  ),
  '02120B': FaultDefinition(
    title: 'DME, coding — VIN wrong',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: vin wrong. The code alone does not establish which part caused it.',
  ),
  '02120C': FaultDefinition(
    title: 'DME, coding — data inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: data inconsistent. The code alone does not establish which part caused it.',
  ),
  '02FF12': FaultDefinition(
    title: 'Error memory entry — only for testing',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving error memory entry: only for testing. The code alone does not establish which part caused it.',
  ),
  '100001': FaultDefinition(
    title: 'Throttle valve, function — clamps for a short time',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, function: clamps for a short time. The code alone does not establish which part caused it.',
  ),
  '100101': FaultDefinition(
    title: 'Throttle valve, function — clamps permanently',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, function: clamps permanently. The code alone does not establish which part caused it.',
  ),
  '100201': FaultDefinition(
    title: 'Throttle valve, function — difficult to move, too slow',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, function: difficult to move, too slow. The code alone does not establish which part caused it.',
  ),
  '100A04': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 1 and 2 — double error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, throttle valve potentiometer 1 and 2: double error. The code alone does not establish which part caused it.',
  ),
  '101001': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 1, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, throttle valve potentiometer 1, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '101002': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 1, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, throttle valve potentiometer 1, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '101201': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 2, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, throttle valve potentiometer 2, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '101202': FaultDefinition(
    title:
        'throttle valve, throttle valve potentiometer 2, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, throttle valve potentiometer 2, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '101401': FaultDefinition(
    title: 'Throttle valve, adaptation — boundary conditions not met',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, adaptation: boundary conditions not met. The code alone does not establish which part caused it.',
  ),
  '101402': FaultDefinition(
    title: 'Throttle valve, adaptation — emergency air position not adapted',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, adaptation: emergency air position not adapted. The code alone does not establish which part caused it.',
  ),
  '101408': FaultDefinition(
    title:
        'Throttle valve, adaptation — first adaptation, lower stop not learned',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, adaptation: first adaptation, lower stop not learned. The code alone does not establish which part caused it.',
  ),
  '101410': FaultDefinition(
    title:
        'Throttle valve, adaptation — boundary conditions not met, battery voltage below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, adaptation: boundary conditions not met, battery voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '101C08': FaultDefinition(
    title:
        'Throttle valve, throttle valve potentiometer, plausibility — synchronous error between potentiometer 1 and 2',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, throttle valve potentiometer, plausibility: synchronous error between potentiometer 1 and 2. The code alone does not establish which part caused it.',
  ),
  '101F01': FaultDefinition(
    title:
        'Throttle flap angle - absolute pressure intake pipe, comparison — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle flap angle - absolute pressure intake pipe, comparison: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '101F02': FaultDefinition(
    title:
        'Throttle flap angle - absolute pressure intake pipe, comparison — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle flap angle - absolute pressure intake pipe, comparison: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '102001': FaultDefinition(
    title: 'Air mass, plausibility — air mass above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving air mass, plausibility: air mass above expected range. The code alone does not establish which part caused it.',
  ),
  '102002': FaultDefinition(
    title: 'Air mass, plausibility — air mass below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving air mass, plausibility: air mass below expected range. The code alone does not establish which part caused it.',
  ),
  '102301': FaultDefinition(
    title: 'Air mass meter — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in air mass meter. The code alone does not identify a failed component.',
  ),
  '102302': FaultDefinition(
    title: 'Air mass meter — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in air mass meter. The code alone does not identify a failed component.',
  ),
  '102A01': FaultDefinition(
    title: 'Air mass meter, signal — electrical fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving air mass meter, signal: electrical fault. The code alone does not establish which part caused it.',
  ),
  '102A22': FaultDefinition(
    title: 'Air mass meter, working range — air mass above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving air mass meter, working range: air mass above expected range. The code alone does not establish which part caused it.',
  ),
  '102A32': FaultDefinition(
    title: 'Air mass meter, working range — air mass below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving air mass meter, working range: air mass below expected range. The code alone does not establish which part caused it.',
  ),
  '102A42': FaultDefinition(
    title: 'Air mass meter, working range — period too long',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving air mass meter, working range: period too long. The code alone does not establish which part caused it.',
  ),
  '102A52': FaultDefinition(
    title: 'Air mass meter, working range — period below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving air mass meter, working range: period below expected range. The code alone does not establish which part caused it.',
  ),
  '102E10': FaultDefinition(
    title: 'DME — internal error [air mass meter: open circuit standby switch]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [air mass meter: open circuit standby switch]. The code alone does not establish which part caused it.',
  ),
  '103001': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 1, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 1, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '103002': FaultDefinition(
    title: 'Gas pedal module, pedal transducer 1, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 1, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '103004': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 1, working range — voltage above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 1, working range: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '103008': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 1, working range — voltage below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 1, working range: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '103010': FaultDefinition(
    title: 'Accelerator pedal module — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in accelerator pedal module. The code alone does not identify a failed component.',
  ),
  '103011': FaultDefinition(
    title: 'Accelerator pedal module — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in accelerator pedal module. The code alone does not identify a failed component.',
  ),
  '103012': FaultDefinition(
    title: 'Accelerator pedal module — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in accelerator pedal module. The code alone does not identify a failed component.',
  ),
  '103013': FaultDefinition(
    title: 'Accelerator pedal module — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in accelerator pedal module. The code alone does not identify a failed component.',
  ),
  '103101': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 2, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 2, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '103102': FaultDefinition(
    title: 'Gas pedal module, pedal transducer 2, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 2, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '103104': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 2, working range — voltage above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 2, working range: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '103108': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer 2, working range — voltage below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer 2, working range: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '103308': FaultDefinition(
    title:
        'Gas pedal module, pedal transducer, plausibility — synchronous error between pedal transducer 1 and pedal transducer 2',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer, plausibility: synchronous error between pedal transducer 1 and pedal transducer 2. The code alone does not establish which part caused it.',
  ),
  '10351C': FaultDefinition(
    title: 'Gas pedal module, pedal transducer — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gas pedal module, pedal transducer: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '104301': FaultDefinition(
    title:
        'Absolute pressure sensor, intake pipe, plausibility, follow-up — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving absolute pressure sensor, intake pipe, plausibility, follow-up: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '104302': FaultDefinition(
    title:
        'Absolute pressure sensor, intake pipe, plausibility, follow-up — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving absolute pressure sensor, intake pipe, plausibility, follow-up: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '104401': FaultDefinition(
    title:
        'Absolute pressure sensor, intake pipe, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving absolute pressure sensor, intake pipe, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '104402': FaultDefinition(
    title:
        'Absolute pressure sensor, intake manifold, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving absolute pressure sensor, intake manifold, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '104B01': FaultDefinition(
    title:
        'Absolute pressure sensor, intake manifold — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving absolute pressure sensor, intake manifold: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '105001': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor: short to battery positive]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor: short to battery positive]. The code alone does not establish which part caused it.',
  ),
  '105002': FaultDefinition(
    title: 'DME — internal error [Ambient pressure sensor: short to ground]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor: short to ground]. The code alone does not establish which part caused it.',
  ),
  '105101': FaultDefinition(
    title: 'Ambient pressure — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in ambient pressure. The code alone does not identify a failed component.',
  ),
  '105102': FaultDefinition(
    title: 'Ambient pressure — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in ambient pressure. The code alone does not identify a failed component.',
  ),
  '105201': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure above expected range in lag]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure above expected range in lag]. The code alone does not establish which part caused it.',
  ),
  '105202': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure below expected range in lag]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure below expected range in lag]. The code alone does not establish which part caused it.',
  ),
  '105A30': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor: multiple related faults]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor: multiple related faults]. The code alone does not establish which part caused it.',
  ),
  '105A40': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, working range: pressure above expected range]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor, working range: pressure above expected range]. The code alone does not establish which part caused it.',
  ),
  '105A41': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, working range: pressure below expected range]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor, working range: pressure below expected range]. The code alone does not establish which part caused it.',
  ),
  '105A42': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure inconsistent]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure inconsistent]. The code alone does not establish which part caused it.',
  ),
  '105A43': FaultDefinition(
    title:
        'DME — internal error [Ambient pressure sensor, plausibility: pressure inconsistent]',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [ambient pressure sensor, plausibility: pressure inconsistent]. The code alone does not establish which part caused it.',
  ),
  '107801': FaultDefinition(
    title: 'Tuning protection — air mass above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tuning protection: air mass above expected range. The code alone does not establish which part caused it.',
  ),
  '107A50': FaultDefinition(
    title: 'Throttle valve — emergency running active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve: emergency running active. The code alone does not establish which part caused it.',
  ),
  '107A70': FaultDefinition(
    title: 'Throttle valve, control — short circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, control: short circuit. The code alone does not establish which part caused it.',
  ),
  '107A71': FaultDefinition(
    title:
        'Throttle valve, control — overtemperature or current above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, control: overtemperature or current above expected range. The code alone does not establish which part caused it.',
  ),
  '107A72': FaultDefinition(
    title:
        'DME, internal error, control throttle valve — internal communication error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, control throttle valve: internal communication error. The code alone does not establish which part caused it.',
  ),
  '107A73': FaultDefinition(
    title: 'throttle valve, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '107A80': FaultDefinition(
    title:
        'Throttle, closing spring test — break-off test, spring does not close',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle, closing spring test: break-off test, spring does not close. The code alone does not establish which part caused it.',
  ),
  '107A81': FaultDefinition(
    title: 'Throttle, closing spring test — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle, closing spring test: operation fault. The code alone does not establish which part caused it.',
  ),
  '107A90': FaultDefinition(
    title:
        'Throttle, opening spring test — break-off test, spring does not open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle, opening spring test: break-off test, spring does not open. The code alone does not establish which part caused it.',
  ),
  '107A91': FaultDefinition(
    title: 'Throttle, opening spring test — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle, opening spring test: operation fault. The code alone does not establish which part caused it.',
  ),
  '107AE0': FaultDefinition(
    title: 'Throttle valve, adaptation — relearning, lower stop not learned',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving throttle valve, adaptation: relearning, lower stop not learned. The code alone does not establish which part caused it.',
  ),
  '108920': FaultDefinition(
    title: 'Charge air temperature sensor — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '108930': FaultDefinition(
    title: 'Charge air temperature sensor — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '108A01': FaultDefinition(
    title:
        'Charge air temperature sensor, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '108A02': FaultDefinition(
    title: 'Charge air temperature sensor, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '108A10': FaultDefinition(
    title: 'Charge air temperature sensor, voltage change — too fast',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor, voltage change: too fast. The code alone does not establish which part caused it.',
  ),
  '108C01': FaultDefinition(
    title:
        'Charge air temperature, plausibility — temperature above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature, plausibility: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '108C08': FaultDefinition(
    title: 'Charge air temperature, signal — fixed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '108F01': FaultDefinition(
    title:
        'Intake air system — suspected leakage between turbocharger and intake valves',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intake air system: suspected leakage between turbocharger and intake valves. The code alone does not establish which part caused it.',
  ),
  '109001': FaultDefinition(
    title: 'Coolant temperature sensor, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coolant temperature sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '109002': FaultDefinition(
    title: 'Coolant temperature sensor, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coolant temperature sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '109208': FaultDefinition(
    title: 'Coolant temperature — signal stuck at one value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal stuck at one value in coolant temperature. The code alone does not identify a failed component.',
  ),
  '109308': FaultDefinition(
    title: 'Coolant temperature sensor, signal change — too fast',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coolant temperature sensor, signal change: too fast. The code alone does not establish which part caused it.',
  ),
  '10A001': FaultDefinition(
    title:
        'Radiator outlet temperature sensor — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in radiator outlet temperature sensor. The code alone does not identify a failed component.',
  ),
  '10A002': FaultDefinition(
    title: 'Radiator outlet temperature sensor — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in radiator outlet temperature sensor. The code alone does not identify a failed component.',
  ),
  '10A108': FaultDefinition(
    title: 'Radiator outlet temperature sensor — response faster than expected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response faster than expected in radiator outlet temperature sensor. The code alone does not identify a failed component.',
  ),
  '10A201': FaultDefinition(
    title: 'Radiator outlet temperature sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in radiator outlet temperature sensor. The code alone does not identify a failed component.',
  ),
  '10A208': FaultDefinition(
    title: 'Radiator outlet temperature sensor — signal stuck at one value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal stuck at one value in radiator outlet temperature sensor. The code alone does not identify a failed component.',
  ),
  '10AA20': FaultDefinition(
    title:
        'Coolant temperature sensor, plausibility, cold start — temperature above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coolant temperature sensor, plausibility, cold start: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '10AA21': FaultDefinition(
    title:
        'Coolant temperature sensor, plausibility, cold start — temperature below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coolant temperature sensor, plausibility, cold start: temperature below expected range. The code alone does not establish which part caused it.',
  ),
  '10AA30': FaultDefinition(
    title: 'Coolant temperature sensor — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coolant temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '10AA52': FaultDefinition(
    title: 'Coolant temperature sensor, signal — fixed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coolant temperature sensor, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '10B101': FaultDefinition(
    title: 'External temperature sensor — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving external temperature sensor: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '10B102': FaultDefinition(
    title: 'External temperature sensor — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving external temperature sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '10B104': FaultDefinition(
    title: 'External temperature sensor, signal — CAN message faulty',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving external temperature sensor, signal: can message faulty. The code alone does not establish which part caused it.',
  ),
  '10BA30': FaultDefinition(
    title:
        'External temperature sensor, collection error — electrical and plausibility',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving external temperature sensor, collection error: electrical and plausibility. The code alone does not establish which part caused it.',
  ),
  '10BA40': FaultDefinition(
    title:
        'Outdoor temperature sensor, plausibility — outdoor temperature greater than model temperature',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving outdoor temperature sensor, plausibility: outdoor temperature greater than model temperature. The code alone does not establish which part caused it.',
  ),
  '10BA41': FaultDefinition(
    title:
        'Exterior temperature sensor, plausibility — exterior temperature less than model temperature',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving exterior temperature sensor, plausibility: exterior temperature less than model temperature. The code alone does not establish which part caused it.',
  ),
  '10BA4B': FaultDefinition(
    title:
        'Charge air temperature sensor, plausibility, cold start — temperature below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor, plausibility, cold start: temperature below expected range. The code alone does not establish which part caused it.',
  ),
  '10BA51': FaultDefinition(
    title:
        'Charge air temperature sensor, cold start — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor, cold start: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '10BA52': FaultDefinition(
    title: 'Charge air temperature sensor — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '10C001': FaultDefinition(
    title: 'Charge-air temperature — response faster than expected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response faster than expected in charge-air temperature. The code alone does not identify a failed component.',
  ),
  '10C004': FaultDefinition(
    title:
        'Charge air temperature sensor, plausibility, cold start — temperature above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge air temperature sensor, plausibility, cold start: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '110001': FaultDefinition(
    title:
        'Cylinder injection shutdown — Cat guard due to pressure below expected range in the fuel system',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving cylinder injection shutdown: cat guard due to pressure below expected range in the fuel system. The code alone does not establish which part caused it.',
  ),
  '110101': FaultDefinition(
    title: 'Cylinder injector 1 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 1. The code alone does not identify a failed component.',
  ),
  '110102': FaultDefinition(
    title: 'Cylinder injector 1 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 1. The code alone does not identify a failed component.',
  ),
  '110104': FaultDefinition(
    title: 'Cylinder injector 1 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 1. The code alone does not identify a failed component.',
  ),
  '110108': FaultDefinition(
    title: 'Cylinder injector 1 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 1. The code alone does not identify a failed component.',
  ),
  '110201': FaultDefinition(
    title: 'Cylinder injector 2 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 2. The code alone does not identify a failed component.',
  ),
  '110202': FaultDefinition(
    title: 'Cylinder injector 2 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 2. The code alone does not identify a failed component.',
  ),
  '110204': FaultDefinition(
    title: 'Cylinder injector 2 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 2. The code alone does not identify a failed component.',
  ),
  '110208': FaultDefinition(
    title: 'Cylinder injector 2 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 2. The code alone does not identify a failed component.',
  ),
  '110301': FaultDefinition(
    title: 'Cylinder injector 3 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 3. The code alone does not identify a failed component.',
  ),
  '110302': FaultDefinition(
    title: 'Cylinder injector 3 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 3. The code alone does not identify a failed component.',
  ),
  '110304': FaultDefinition(
    title: 'Cylinder injector 3 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 3. The code alone does not identify a failed component.',
  ),
  '110308': FaultDefinition(
    title: 'Cylinder injector 3 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 3. The code alone does not identify a failed component.',
  ),
  '110401': FaultDefinition(
    title: 'Cylinder injector 4 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 4. The code alone does not identify a failed component.',
  ),
  '110402': FaultDefinition(
    title: 'Cylinder injector 4 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 4. The code alone does not identify a failed component.',
  ),
  '110404': FaultDefinition(
    title: 'Cylinder injector 4 — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in cylinder injector 4. The code alone does not identify a failed component.',
  ),
  '110408': FaultDefinition(
    title: 'Cylinder injector 4 — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in cylinder injector 4. The code alone does not identify a failed component.',
  ),
  '111030': FaultDefinition(
    title: 'Cylinder injector 1 — response slower than expected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response slower than expected in cylinder injector 1. The code alone does not identify a failed component.',
  ),
  '111031': FaultDefinition(
    title: 'Cylinder injector 2 — response slower than expected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response slower than expected in cylinder injector 2. The code alone does not identify a failed component.',
  ),
  '111032': FaultDefinition(
    title: 'Cylinder injector 3 — response slower than expected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response slower than expected in cylinder injector 3. The code alone does not identify a failed component.',
  ),
  '111033': FaultDefinition(
    title: 'Cylinder injector 4 — response slower than expected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response slower than expected in cylinder injector 4. The code alone does not identify a failed component.',
  ),
  '111110': FaultDefinition(
    title: 'DME internal control — communication fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded communication fault in DME internal control. The code alone does not identify a failed component.',
  ),
  '111112': FaultDefinition(
    title: 'DME internal control — communication fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded communication fault in DME internal control. The code alone does not identify a failed component.',
  ),
  '111114': FaultDefinition(
    title: 'DME internal control — communication fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded communication fault in DME internal control. The code alone does not identify a failed component.',
  ),
  '112101': FaultDefinition(
    title: 'Injector cylinder 1, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 1, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112104': FaultDefinition(
    title:
        'Injector cylinder 1, control — short circuit high-voltage side to low-voltage side',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 1, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112201': FaultDefinition(
    title: 'Injector cylinder 2, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 2, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112204': FaultDefinition(
    title:
        'Injector cylinder 2, control — short circuit high-voltage side to low-voltage side',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 2, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112301': FaultDefinition(
    title: 'Injector cylinder 3, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 3, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112304': FaultDefinition(
    title:
        'Injector cylinder 3, control — short circuit high-voltage side to low-voltage side',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 3, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '112401': FaultDefinition(
    title: 'Injector cylinder 4, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 4, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '112404': FaultDefinition(
    title:
        'Injector cylinder 4, control — short circuit high-voltage side to low-voltage side',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving injector cylinder 4, control: short circuit high-voltage side to low-voltage side. The code alone does not establish which part caused it.',
  ),
  '113025': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage injection — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, supply voltage injection: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '113026': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage injection — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, supply voltage injection: short to ground. The code alone does not establish which part caused it.',
  ),
  '113027': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage injection — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, supply voltage injection: open circuit. The code alone does not establish which part caused it.',
  ),
  '114101': FaultDefinition(
    title: 'Cylinder mixture monitoring — mixture too lean',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded mixture too lean in cylinder mixture monitoring. The code alone does not identify a failed component.',
  ),
  '114102': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 1 — mixture too rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 1: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114201': FaultDefinition(
    title: 'Cylinder mixture monitoring — mixture too lean',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded mixture too lean in cylinder mixture monitoring. The code alone does not identify a failed component.',
  ),
  '114202': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 2 — mixture too rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 2: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114301': FaultDefinition(
    title: 'Cylinder mixture monitoring — mixture too lean',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded mixture too lean in cylinder mixture monitoring. The code alone does not identify a failed component.',
  ),
  '114302': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 3 — mixture too rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 3: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '114401': FaultDefinition(
    title: 'Cylinder mixture monitoring — mixture too lean',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded mixture too lean in cylinder mixture monitoring. The code alone does not identify a failed component.',
  ),
  '114402': FaultDefinition(
    title:
        'Cylinder-specific mixture monitoring for running irregularity, cylinder 4 — mixture too rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving cylinder-specific mixture monitoring for running irregularity, cylinder 4: mixture too rich. The code alone does not establish which part caused it.',
  ),
  '117120': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1 — adaptation value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 1: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117121': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 1 — regulator value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 1: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117123': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1, basic adaptation — transient control failed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 1, basic adaptation: transient control failed. The code alone does not establish which part caused it.',
  ),
  '117124': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 1, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 1, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117125': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 1, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest-quantity adaptation, injector cylinder 1, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117126': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1, signal detection, basic adaptation — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 1, signal detection, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117127': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 1, signal detection — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 1, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117128': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 1, plausibility — signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 1, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117220': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3 — adaptation value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 3: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117221': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3 — controller value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 3: controller value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117223': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3, basic adaptation — transient response of the controller failed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 3, basic adaptation: transient response of the controller failed. The code alone does not establish which part caused it.',
  ),
  '117224': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 3, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 3, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117225': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 3, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest-quantity adaptation, injector cylinder 3, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117226': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3, signal recognition, basic adaptation — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 3, signal recognition, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117227': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 3, signal detection — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 3, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117228': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 3, plausibility — signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 3, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117320': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4 — adaptation value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 4: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117321': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 4 — regulator value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 4: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117323': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4, basic adaptation — transient response of the regulator failed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 4, basic adaptation: transient response of the regulator failed. The code alone does not establish which part caused it.',
  ),
  '117324': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 4, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 4, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117325': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 4, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest-quantity adaptation, injector cylinder 4, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117326': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4, signal detection, basic adaptation — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 4, signal detection, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117327': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 4, signal detection — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 4, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117328': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 4, plausibility — signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 4, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '117420': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2 — adaptation value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 2: adaptation value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117421': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2 — regulator value outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 2: regulator value outside valid range. The code alone does not establish which part caused it.',
  ),
  '117423': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2, basic adaptation — transient response of the regulator failed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 2, basic adaptation: transient response of the regulator failed. The code alone does not establish which part caused it.',
  ),
  '117424': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 2, basic adaptation, plausibility — opening delay time inconsistent with respect to default value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 2, basic adaptation, plausibility: opening delay time inconsistent with respect to default value. The code alone does not establish which part caused it.',
  ),
  '117425': FaultDefinition(
    title:
        'Smallest-quantity adaptation, injector cylinder 2, basic adaptation, plausibility — opening delay time inconsistent compared with the value learned last',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest-quantity adaptation, injector cylinder 2, basic adaptation, plausibility: opening delay time inconsistent compared with the value learned last. The code alone does not establish which part caused it.',
  ),
  '117426': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2, signal recognition, basic adaptation — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 2, signal recognition, basic adaptation: operation fault. The code alone does not establish which part caused it.',
  ),
  '117427': FaultDefinition(
    title:
        'Small-quantity adaptation, injector cylinder 2, signal detection — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving small-quantity adaptation, injector cylinder 2, signal detection: operation fault. The code alone does not establish which part caused it.',
  ),
  '117428': FaultDefinition(
    title:
        'Smallest quantity adaptation, injector cylinder 2, plausibility — signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving smallest quantity adaptation, injector cylinder 2, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '118001': FaultDefinition(
    title: 'Mixture regulation — mixture to lean',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving mixture regulation: mixture to lean. The code alone does not establish which part caused it.',
  ),
  '118002': FaultDefinition(
    title: 'Mixture regulation — mixture to rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving mixture regulation: mixture to rich. The code alone does not establish which part caused it.',
  ),
  '118401': FaultDefinition(
    title: 'Mixture regulation — mixture to lean, large deviation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving mixture regulation: mixture to lean, large deviation. The code alone does not establish which part caused it.',
  ),
  '118402': FaultDefinition(
    title: 'Mixture control — mixture too rich, large deviation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving mixture control: mixture too rich, large deviation. The code alone does not establish which part caused it.',
  ),
  '118601': FaultDefinition(
    title:
        'Lambda sensor before catalytic converter, fine mixture control — exhaust gas by catalytic converter too rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda sensor before catalytic converter, fine mixture control: exhaust gas by catalytic converter too rich. The code alone does not establish which part caused it.',
  ),
  '118602': FaultDefinition(
    title:
        'Lambda probe before catalytic converter, fine mixture control — exhaust gas lean by catalytic converter',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe before catalytic converter, fine mixture control: exhaust gas lean by catalytic converter. The code alone does not establish which part caused it.',
  ),
  '119001': FaultDefinition(
    title: 'Rail pressure sensor, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving rail pressure sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '119002': FaultDefinition(
    title: 'Rail pressure sensor, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving rail pressure sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '119301': FaultDefinition(
    title: 'Fuel rail pressure sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in fuel rail pressure sensor. The code alone does not identify a failed component.',
  ),
  '119304': FaultDefinition(
    title:
        'Rail pressure sensor, plausibility — pressure above expected range before engine start',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving rail pressure sensor, plausibility: pressure above expected range before engine start. The code alone does not establish which part caused it.',
  ),
  '119308': FaultDefinition(
    title:
        'Rail pressure sensor, plausibility — pressure below expected range before engine start',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving rail pressure sensor, plausibility: pressure below expected range before engine start. The code alone does not establish which part caused it.',
  ),
  '119404': FaultDefinition(
    title: 'Rail pressure sensor, signal — fixed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving rail pressure sensor, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '11A001': FaultDefinition(
    title: 'High fuel pressure, plausibility — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving high fuel pressure, plausibility: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '11A002': FaultDefinition(
    title: 'High fuel pressure, plausibility — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving high fuel pressure, plausibility: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11A031': FaultDefinition(
    title: 'Low-pressure fuel supply — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in low-pressure fuel supply. The code alone does not identify a failed component.',
  ),
  '11A032': FaultDefinition(
    title: 'Low-pressure fuel supply — fuel-level inconsistency',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded fuel-level inconsistency in low-pressure fuel supply. The code alone does not identify a failed component.',
  ),
  '11A401': FaultDefinition(
    title:
        'High fuel pressure at injection release — Pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving high fuel pressure at injection release: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11A701': FaultDefinition(
    title: 'Fuel rail pressure sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in fuel rail pressure sensor. The code alone does not identify a failed component.',
  ),
  '11A702': FaultDefinition(
    title: 'Fuel rail pressure sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in fuel rail pressure sensor. The code alone does not identify a failed component.',
  ),
  '11AC01': FaultDefinition(
    title:
        'High fuel pressure, plausibility, cold start — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving high fuel pressure, plausibility, cold start: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '11AC02': FaultDefinition(
    title:
        'High fuel pressure, plausibility, cold start — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving high fuel pressure, plausibility, cold start: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11B120': FaultDefinition(
    title: 'Ethanol sensor — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B121': FaultDefinition(
    title: 'Ethanol sensor — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B122': FaultDefinition(
    title: 'Ethanol sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B123': FaultDefinition(
    title: 'Ethanol sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B124': FaultDefinition(
    title: 'Ethanol sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B125': FaultDefinition(
    title: 'Ethanol sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B126': FaultDefinition(
    title: 'Ethanol sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B127': FaultDefinition(
    title: 'Ethanol sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B128': FaultDefinition(
    title: 'Ethanol sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in ethanol sensor. The code alone does not identify a failed component.',
  ),
  '11B401': FaultDefinition(
    title:
        'High fuel pressure at or after release of injection (2nd environmental condition set after time delay) — Pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving high fuel pressure at or after release of injection (2nd environmental condition set after time delay): pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11B501': FaultDefinition(
    title:
        'High fuel pressure after release of injection — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving high fuel pressure after release of injection: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '11B510': FaultDefinition(
    title: 'Fuel injection — cylinder operation lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded cylinder operation lost in fuel injection. The code alone does not identify a failed component.',
  ),
  '11C401': FaultDefinition(
    title: 'Quantity control valve, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving quantity control valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '11C402': FaultDefinition(
    title: 'Quantity control valve, control — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving quantity control valve, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '11C404': FaultDefinition(
    title: 'Quantity control valve, triggering — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving quantity control valve, triggering: open circuit. The code alone does not establish which part caused it.',
  ),
  '11CF30': FaultDefinition(
    title: 'Mixture control — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving mixture control: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '120208': FaultDefinition(
    title:
        'Charge pressure control, plausibility — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure control, plausibility: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '120308': FaultDefinition(
    title:
        'Charge pressure control, plausibility — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure control, plausibility: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '120408': FaultDefinition(
    title: 'Charge pressure control — shutdown as a follow-up reaction',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure control: shutdown as a follow-up reaction. The code alone does not establish which part caused it.',
  ),
  '121001': FaultDefinition(
    title: 'Charge pressure sensor, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '121002': FaultDefinition(
    title: 'Charge pressure sensor, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '121201': FaultDefinition(
    title:
        'Charge pressure sensor, plausibility, follow-up — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure sensor, plausibility, follow-up: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '121202': FaultDefinition(
    title:
        'Charge pressure sensor, plausibility, follow-up — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure sensor, plausibility, follow-up: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '121521': FaultDefinition(
    title: 'Charge pressure sensor — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure sensor: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '12152F': FaultDefinition(
    title: 'Boost pressure — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in boost pressure. The code alone does not identify a failed component.',
  ),
  '121531': FaultDefinition(
    title: 'Charge pressure, working range — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure, working range: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '121532': FaultDefinition(
    title:
        'Charge pressure - ambient pressure, comparison — charge pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure - ambient pressure, comparison: charge pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '121533': FaultDefinition(
    title:
        'Charge pressure - ambient pressure, comparison — charge pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving charge pressure - ambient pressure, comparison: charge pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '122001': FaultDefinition(
    title:
        'Thrust air recirculation valve, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving thrust air recirculation valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '122002': FaultDefinition(
    title: 'Thrust air recirculation valve, triggering — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving thrust air recirculation valve, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '122004': FaultDefinition(
    title: 'Thrust circulating air valve, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving thrust circulating air valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '122108': FaultDefinition(
    title: 'Charge-air recirculation valve — stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck closed in charge-air recirculation valve. The code alone does not identify a failed component.',
  ),
  '122201': FaultDefinition(
    title:
        'Thrust air recirculation valve, mechanics — suspected of open-clamping thrust air recirculation valve',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving thrust air recirculation valve, mechanics: suspected of open-clamping thrust air recirculation valve. The code alone does not establish which part caused it.',
  ),
  '123001': FaultDefinition(
    title: 'Wastegate — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in wastegate. The code alone does not identify a failed component.',
  ),
  '123002': FaultDefinition(
    title: 'Wastegate — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in wastegate. The code alone does not identify a failed component.',
  ),
  '123004': FaultDefinition(
    title: 'Wastegate — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in wastegate. The code alone does not identify a failed component.',
  ),
  '123201': FaultDefinition(
    title: 'Wastegate, control — Suspicion of errors in the wastegate control',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wastegate, control: suspicion of errors in the wastegate control. The code alone does not establish which part caused it.',
  ),
  '123401': FaultDefinition(
    title: 'Electrical wastegate, stop learning, cold start — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electrical wastegate, stop learning, cold start: operation fault. The code alone does not establish which part caused it.',
  ),
  '123411': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate open) not found',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate open) not found. The code alone does not establish which part caused it.',
  ),
  '123412': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate closed) not found',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate closed) not found. The code alone does not establish which part caused it.',
  ),
  '123421': FaultDefinition(
    title:
        'Electric wastegate, stop learning — starting position (wastegate open) not found',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, stop learning: starting position (wastegate open) not found. The code alone does not establish which part caused it.',
  ),
  '123422': FaultDefinition(
    title:
        'Electric wastegate, stop learning — starting position (wastegate closed) not found',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, stop learning: starting position (wastegate closed) not found. The code alone does not establish which part caused it.',
  ),
  '123431': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate open) outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate open) outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123432': FaultDefinition(
    title:
        'Electric wastegate, stop learning — stop position (wastegate closed) outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, stop learning: stop position (wastegate closed) outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123433': FaultDefinition(
    title:
        'Electric wastegate, stop learning — adjustment range outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, stop learning: adjustment range outside tolerance. The code alone does not establish which part caused it.',
  ),
  '123511': FaultDefinition(
    title: 'Electrical wastegate, wastegate flap — difficult to move',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electrical wastegate, wastegate flap: difficult to move. The code alone does not establish which part caused it.',
  ),
  '123512': FaultDefinition(
    title:
        'Electrical wastegate, wastegate flap, cold start — difficult to move',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electrical wastegate, wastegate flap, cold start: difficult to move. The code alone does not establish which part caused it.',
  ),
  '123513': FaultDefinition(
    title:
        'Electrical wastegate, position sensor, supply voltage, plausibility — voltage inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electrical wastegate, position sensor, supply voltage, plausibility: voltage inconsistent. The code alone does not establish which part caused it.',
  ),
  '123514': FaultDefinition(
    title: 'Electric wastegate — warning threshold exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded warning threshold exceeded in electric wastegate. The code alone does not identify a failed component.',
  ),
  '123515': FaultDefinition(
    title: 'Electric wastegate — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in electric wastegate. The code alone does not identify a failed component.',
  ),
  '123516': FaultDefinition(
    title: 'Electrical wastegate, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electrical wastegate, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '123601': FaultDefinition(
    title: 'Electric wastegate, control — short circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, control: short circuit. The code alone does not establish which part caused it.',
  ),
  '123602': FaultDefinition(
    title:
        'Electric wastegate, output stage — temperature above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, output stage: temperature above expected range. The code alone does not establish which part caused it.',
  ),
  '123608': FaultDefinition(
    title:
        'DME, internal error, electrical wastegate — SPI communication faulty',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, electrical wastegate: spi communication faulty. The code alone does not establish which part caused it.',
  ),
  '123609': FaultDefinition(
    title:
        'Electrical wastegate, thermal overload protection — warning threshold exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electrical wastegate, thermal overload protection: warning threshold exceeded. The code alone does not establish which part caused it.',
  ),
  '12360B': FaultDefinition(
    title:
        'Electric wastegate, thermal overload protection — emergency running active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, thermal overload protection: emergency running active. The code alone does not establish which part caused it.',
  ),
  '123701': FaultDefinition(
    title:
        'Electric wastegate, position sensor, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric wastegate, position sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '123702': FaultDefinition(
    title:
        'Electrical wastegate, position sensor, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electrical wastegate, position sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '128101': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter, system test — signal fixed on lean',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda sensor in front of catalytic converter, system test: signal fixed on lean. The code alone does not establish which part caused it.',
  ),
  '128301': FaultDefinition(
    title:
        'Lambda probe before catalytic converter, system test — oxygen signal fixed rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe before catalytic converter, system test: oxygen signal fixed rich. The code alone does not establish which part caused it.',
  ),
  '128901': FaultDefinition(
    title: 'Lambda probe before catalyst, dynamics — slow reaction',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe before catalyst, dynamics: slow reaction. The code alone does not establish which part caused it.',
  ),
  '128B01': FaultDefinition(
    title: 'Lambda probe in front of catalyst — false air detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe in front of catalyst: false air detected. The code alone does not establish which part caused it.',
  ),
  '128E01': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter, electrical — interruption Nernstleitung',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe in front of catalytic converter, electrical: interruption nernstleitung. The code alone does not establish which part caused it.',
  ),
  '128E03': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter, electrical — interruption of balancing resistance line',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda sensor in front of catalytic converter, electrical: interruption of balancing resistance line. The code alone does not establish which part caused it.',
  ),
  '128E05': FaultDefinition(
    title:
        'Lambda sensor upstream of catalytic converter 2, electrical — interruption of balancing resistance line',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda sensor upstream of catalytic converter 2, electrical: interruption of balancing resistance line. The code alone does not establish which part caused it.',
  ),
  '129001': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter, signal lines — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe in front of catalytic converter, signal lines: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '129002': FaultDefinition(
    title:
        'Lambda probe before catalytic converter, signal lines — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe before catalytic converter, signal lines: short to ground. The code alone does not establish which part caused it.',
  ),
  '129201': FaultDefinition(
    title:
        'DME, internal error, lambda probe before catalyst — initialization error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, lambda probe before catalyst: initialization error. The code alone does not establish which part caused it.',
  ),
  '129202': FaultDefinition(
    title:
        'DME, internal error, lambda probe before catalyst — communication error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, lambda probe before catalyst: communication error. The code alone does not establish which part caused it.',
  ),
  '129A20': FaultDefinition(
    title:
        'DME, internal fault, lambda probe before catalytic converter — lambda probe component, signal circuit adaptation values above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, lambda probe before catalytic converter: lambda probe component, signal circuit adaptation values above expected range. The code alone does not establish which part caused it.',
  ),
  '129A21': FaultDefinition(
    title:
        'DME, internal fault, lambda sensor before catalytic converter — lambda sensor module, low voltage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, lambda sensor before catalytic converter: lambda sensor module, low voltage. The code alone does not establish which part caused it.',
  ),
  '12A101': FaultDefinition(
    title: 'Downstream oxygen sensor — signal stuck at one value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal stuck at one value in downstream oxygen sensor. The code alone does not identify a failed component.',
  ),
  '12A102': FaultDefinition(
    title: 'Downstream oxygen sensor — signal stuck at one value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal stuck at one value in downstream oxygen sensor. The code alone does not identify a failed component.',
  ),
  '12A308': FaultDefinition(
    title:
        'Lambda probe by catalyst, dynamics, from fat to lean — slow reaction',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe by catalyst, dynamics, from fat to lean: slow reaction. The code alone does not establish which part caused it.',
  ),
  '12A701': FaultDefinition(
    title:
        'Lambda probe after catalytic converter, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe after catalytic converter, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12A902': FaultDefinition(
    title: 'Lambda probe by catalytic converter, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe by catalytic converter, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '12AB04': FaultDefinition(
    title: 'Lambda sensor by catalytic converter, electrical — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda sensor by catalytic converter, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '12AD01': FaultDefinition(
    title: 'Lambda probe after catalyst — signal fixed on lean',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe after catalyst: signal fixed on lean. The code alone does not establish which part caused it.',
  ),
  '12AE01': FaultDefinition(
    title: 'Lambda probe after catalyst — oxygen signal fixed rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe after catalyst: oxygen signal fixed rich. The code alone does not establish which part caused it.',
  ),
  '12AF01': FaultDefinition(
    title: 'Downstream oxygen sensor — response delayed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response delayed in downstream oxygen sensor. The code alone does not identify a failed component.',
  ),
  '12AF08': FaultDefinition(
    title: 'Downstream oxygen sensor — response delayed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response delayed in downstream oxygen sensor. The code alone does not identify a failed component.',
  ),
  '12AF10': FaultDefinition(
    title: 'Downstream oxygen sensor — response delayed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response delayed in downstream oxygen sensor. The code alone does not identify a failed component.',
  ),
  '12AF11': FaultDefinition(
    title: 'Downstream oxygen sensor — response delayed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response delayed in downstream oxygen sensor. The code alone does not identify a failed component.',
  ),
  '12AF20': FaultDefinition(
    title: 'Lambda probe after catalyst — oxygen signal fixed rich',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe after catalyst: oxygen signal fixed rich. The code alone does not establish which part caused it.',
  ),
  '12B001': FaultDefinition(
    title: 'Lambda probe by catalyst, from fat to lean — delayed reaction',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe by catalyst, from fat to lean: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '12B101': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating before catalytic converter, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12B102': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, driving — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating before catalytic converter, driving: short to ground. The code alone does not establish which part caused it.',
  ),
  '12B104': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating before catalytic converter, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '12B301': FaultDefinition(
    title:
        'Lambda probe heating after catalytic converter, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating after catalytic converter, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '12B302': FaultDefinition(
    title:
        'Lambda probe heating by catalytic converter, driving — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating by catalytic converter, driving: short to ground. The code alone does not establish which part caused it.',
  ),
  '12B304': FaultDefinition(
    title:
        'Lambda probe heating by catalytic converter, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating by catalytic converter, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '12B505': FaultDefinition(
    title:
        'Lambda probe heating before catalytic converter, function — heater fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating before catalytic converter, function: heater fault. The code alone does not establish which part caused it.',
  ),
  '12B701': FaultDefinition(
    title:
        'Lambda probe heating by catalyst, function — internal resistance above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe heating by catalyst, function: internal resistance above expected range. The code alone does not establish which part caused it.',
  ),
  '12BB01': FaultDefinition(
    title: 'Lambda probe by catalyst, lean to fat — delayed reaction',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe by catalyst, lean to fat: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '12BD52': FaultDefinition(
    title:
        'Lambda sensor in front of catalytic converter, electrical — interruption of pump current line',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda sensor in front of catalytic converter, electrical: interruption of pump current line. The code alone does not establish which part caused it.',
  ),
  '12BD60': FaultDefinition(
    title:
        'Lambda probe in front of catalytic converter, electrical — interrupt virtual mass',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe in front of catalytic converter, electrical: interrupt virtual mass. The code alone does not establish which part caused it.',
  ),
  '12BD80': FaultDefinition(
    title: 'Lambda probe before catalyst — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe before catalyst: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '12BE08': FaultDefinition(
    title: 'Lambda probe by catalyst, dynamics, lean to fat — slow reaction',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe by catalyst, dynamics, lean to fat: slow reaction. The code alone does not establish which part caused it.',
  ),
  '130001': FaultDefinition(
    title: 'VANOS solenoid valve inlet, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos solenoid valve inlet, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '130002': FaultDefinition(
    title: 'VANOS solenoid valve inlet, triggering — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos solenoid valve inlet, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '130004': FaultDefinition(
    title: 'VANOS solenoid valve inlet, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos solenoid valve inlet, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '130104': FaultDefinition(
    title: 'VANOS, inlet — control error, camshaft jammed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, inlet: control error, camshaft jammed. The code alone does not establish which part caused it.',
  ),
  '130108': FaultDefinition(
    title: 'VANOS, inlet — control error, position target not reached',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, inlet: control error, position target not reached. The code alone does not establish which part caused it.',
  ),
  '130201': FaultDefinition(
    title: 'VANOS solenoid valve outlet, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos solenoid valve outlet, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '130202': FaultDefinition(
    title: 'VANOS solenoid valve outlet, control — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos solenoid valve outlet, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '130204': FaultDefinition(
    title: 'VANOS solenoid valve outlet, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos solenoid valve outlet, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '130304': FaultDefinition(
    title: 'VANOS, outlet — control error, camshaft jammed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, outlet: control error, camshaft jammed. The code alone does not establish which part caused it.',
  ),
  '130308': FaultDefinition(
    title: 'VANOS, outlet — control error, position target not reached',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, outlet: control error, position target not reached. The code alone does not establish which part caused it.',
  ),
  '130E11': FaultDefinition(
    title: 'Inlet camshaft sensor, plausibility — pattern invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving inlet camshaft sensor, plausibility: pattern invalid. The code alone does not establish which part caused it.',
  ),
  '130E20': FaultDefinition(
    title:
        'Inlet camshaft — angular offset to the crankshaft outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving inlet camshaft: angular offset to the crankshaft outside tolerance. The code alone does not establish which part caused it.',
  ),
  '130F11': FaultDefinition(
    title: 'Exhaust camshaft sensor, plausibility — pattern invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving exhaust camshaft sensor, plausibility: pattern invalid. The code alone does not establish which part caused it.',
  ),
  '130F20': FaultDefinition(
    title:
        'Exhaust camshaft — angular offset to the crankshaft outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving exhaust camshaft: angular offset to the crankshaft outside tolerance. The code alone does not establish which part caused it.',
  ),
  '131401': FaultDefinition(
    title: 'VANOS, outlet, cold start — not controllable',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, outlet, cold start: not controllable. The code alone does not establish which part caused it.',
  ),
  '131501': FaultDefinition(
    title: 'VANOS, inlet, cold start — not controllable',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, inlet, cold start: not controllable. The code alone does not establish which part caused it.',
  ),
  '131808': FaultDefinition(
    title: 'VANOS, outlet, cold start — position target not reached',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, outlet, cold start: position target not reached. The code alone does not establish which part caused it.',
  ),
  '131908': FaultDefinition(
    title: 'VANOS, inlet, cold start — position target not reached',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, inlet, cold start: position target not reached. The code alone does not establish which part caused it.',
  ),
  '132101': FaultDefinition(
    title: 'VANOS, outlet — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, outlet: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '132201': FaultDefinition(
    title: 'VANOS, inlet — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos, inlet: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '132301': FaultDefinition(
    title: 'VANOS — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vanos: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '132408': FaultDefinition(
    title:
        'Variable valve timing — camshaft not in its expected start position',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded camshaft not in its expected start position in variable valve timing. The code alone does not identify a failed component.',
  ),
  '132508': FaultDefinition(
    title:
        'Variable valve timing — camshaft not in its expected start position',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded camshaft not in its expected start position in variable valve timing. The code alone does not identify a failed component.',
  ),
  '133010': FaultDefinition(
    title: 'Valvetronic actuator, control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic actuator, control: operation fault. The code alone does not establish which part caused it.',
  ),
  '133011': FaultDefinition(
    title: 'Valvetronic, supply voltage — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, supply voltage: operation fault. The code alone does not establish which part caused it.',
  ),
  '133101': FaultDefinition(
    title: 'Valvetronic relay, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic relay, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '133102': FaultDefinition(
    title: 'Valvetronic relay, control — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic relay, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '133104': FaultDefinition(
    title: 'Valvetronic relay, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic relay, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '133201': FaultDefinition(
    title: 'Valvetronic servomotor, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '133202': FaultDefinition(
    title: 'Valvetronic servomotor, control — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '133206': FaultDefinition(
    title: 'Valvetronic servomotor, control — shutdown in driving mode',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, control: shutdown in driving mode. The code alone does not establish which part caused it.',
  ),
  '133304': FaultDefinition(
    title: 'Valvetronic — component protection, shutdown system',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic: component protection, shutdown system. The code alone does not establish which part caused it.',
  ),
  '133710': FaultDefinition(
    title: 'Valvetronic, eccentric shaft adaptation — lower stop reached',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, eccentric shaft adaptation: lower stop reached. The code alone does not establish which part caused it.',
  ),
  '133B04': FaultDefinition(
    title: 'Valvetronic system — no adjustment possible',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic system: no adjustment possible. The code alone does not establish which part caused it.',
  ),
  '133E10': FaultDefinition(
    title: 'Valvetronic system — deactivated, too frequent adjustment errors',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic system: deactivated, too frequent adjustment errors. The code alone does not establish which part caused it.',
  ),
  '134A02': FaultDefinition(
    title: 'Valvetronic actuator — overload',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic actuator: overload. The code alone does not establish which part caused it.',
  ),
  '134F01': FaultDefinition(
    title: 'Valvetronic, adjustment range — learning outside tolerances',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, adjustment range: learning outside tolerances. The code alone does not establish which part caused it.',
  ),
  '134F02': FaultDefinition(
    title: 'Valvetronic, adjustment range — stop not learned',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, adjustment range: stop not learned. The code alone does not establish which part caused it.',
  ),
  '134F04': FaultDefinition(
    title: 'Valvetronic, Adjustment Range — Error Range Checking',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, adjustment range: error range checking. The code alone does not establish which part caused it.',
  ),
  '134F08': FaultDefinition(
    title:
        'Valvetronic, Adjustment Range — Range Check Deviation to UrLearning',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, adjustment range: range check deviation to urlearning. The code alone does not establish which part caused it.',
  ),
  '134F10': FaultDefinition(
    title:
        'Valvetronic, range of adjustment — stop not learned due to environmental conditions',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, range of adjustment: stop not learned due to environmental conditions. The code alone does not establish which part caused it.',
  ),
  '135302': FaultDefinition(
    title: 'Valvetronic actuator — component protection, shutdown system',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic actuator: component protection, shutdown system. The code alone does not establish which part caused it.',
  ),
  '135401': FaultDefinition(
    title: 'Valvetronic — power stage overloaded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic: power stage overloaded. The code alone does not establish which part caused it.',
  ),
  '135501': FaultDefinition(
    title: 'Valvetronic — Warning threshold overload protection exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic: warning threshold overload protection exceeded. The code alone does not establish which part caused it.',
  ),
  '135502': FaultDefinition(
    title:
        'Valvetronic actuator — warning threshold overload protection exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic actuator: warning threshold overload protection exceeded. The code alone does not establish which part caused it.',
  ),
  '135608': FaultDefinition(
    title: 'Valvetronic system — no movement detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic system: no movement detected. The code alone does not establish which part caused it.',
  ),
  '135704': FaultDefinition(
    title: 'Valvetronic system — warning threshold control deviation exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic system: warning threshold control deviation exceeded. The code alone does not establish which part caused it.',
  ),
  '135705': FaultDefinition(
    title:
        'Valvetronic system — deactivated, warning threshold control deviation too often exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic system: deactivated, warning threshold control deviation too often exceeded. The code alone does not establish which part caused it.',
  ),
  '135706': FaultDefinition(
    title: 'Valvetronic System — lower stop learned',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic system: lower stop learned. The code alone does not establish which part caused it.',
  ),
  '135808': FaultDefinition(
    title:
        'Valvetronic actuators, position sensors, electrical — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic actuators, position sensors, electrical: operation fault. The code alone does not establish which part caused it.',
  ),
  '135908': FaultDefinition(
    title:
        'Valvetronic servomotor, position sensors — supply voltage not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, position sensors: supply voltage not received. The code alone does not establish which part caused it.',
  ),
  '135A08': FaultDefinition(
    title:
        'Valvetronic servomotor, position sensors, plausibility — signals inconsistent to each other',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, position sensors, plausibility: signals inconsistent to each other. The code alone does not establish which part caused it.',
  ),
  '135A10': FaultDefinition(
    title:
        'Valvetronic servomotor, position sensors — absolute value eccentric angle wrong',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, position sensors: absolute value eccentric angle wrong. The code alone does not establish which part caused it.',
  ),
  '135B10': FaultDefinition(
    title: 'Valvetronic servomotor, control phase U — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, control phase u: open circuit. The code alone does not establish which part caused it.',
  ),
  '135B11': FaultDefinition(
    title: 'Valvetronic actuator, control phase V — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic actuator, control phase v: open circuit. The code alone does not establish which part caused it.',
  ),
  '135B12': FaultDefinition(
    title: 'Valvetronic servomotor, control phase W — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, control phase w: open circuit. The code alone does not establish which part caused it.',
  ),
  '135C10': FaultDefinition(
    title: 'Valvetronic servomotor, position sensors — error detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic servomotor, position sensors: error detected. The code alone does not establish which part caused it.',
  ),
  '135C11': FaultDefinition(
    title: 'Valvetronic actuator, position sensors — signals inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic actuator, position sensors: signals inconsistent. The code alone does not establish which part caused it.',
  ),
  '138101': FaultDefinition(
    title: 'Exhaust flap control — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in exhaust flap control. The code alone does not identify a failed component.',
  ),
  '138102': FaultDefinition(
    title: 'Exhaust flap control — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in exhaust flap control. The code alone does not identify a failed component.',
  ),
  '138104': FaultDefinition(
    title: 'Exhaust flap control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in exhaust flap control. The code alone does not identify a failed component.',
  ),
  '138201': FaultDefinition(
    title: 'Radiator air shutter — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138203': FaultDefinition(
    title: 'Active air flap control — control deviation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control deviation in active air flap control. The code alone does not identify a failed component.',
  ),
  '138204': FaultDefinition(
    title: 'Active air flap control — control deviation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control deviation in active air flap control. The code alone does not identify a failed component.',
  ),
  '138205': FaultDefinition(
    title: 'Active air flap control — position differs from command',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded position differs from command in active air flap control. The code alone does not identify a failed component.',
  ),
  '138206': FaultDefinition(
    title: 'Active air flap control — movement blocked',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded movement blocked in active air flap control. The code alone does not identify a failed component.',
  ),
  '138207': FaultDefinition(
    title: 'Active air flap control — movement blocked',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded movement blocked in active air flap control. The code alone does not identify a failed component.',
  ),
  '138208': FaultDefinition(
    title: 'Active air flap control — control deviation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control deviation in active air flap control. The code alone does not identify a failed component.',
  ),
  '138209': FaultDefinition(
    title: 'Active air flap control — control deviation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control deviation in active air flap control. The code alone does not identify a failed component.',
  ),
  '13820A': FaultDefinition(
    title: 'Active air flap control — movement blocked',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded movement blocked in active air flap control. The code alone does not identify a failed component.',
  ),
  '13820B': FaultDefinition(
    title: 'Active air flap control — movement blocked',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded movement blocked in active air flap control. The code alone does not identify a failed component.',
  ),
  '13820C': FaultDefinition(
    title: 'Active air flap control — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '13820D': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '13820E': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '13820F': FaultDefinition(
    title: 'Active air flap control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in active air flap control. The code alone does not identify a failed component.',
  ),
  '138210': FaultDefinition(
    title: 'Active air flap control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in active air flap control. The code alone does not identify a failed component.',
  ),
  '138211': FaultDefinition(
    title: 'Active air flap control — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in active air flap control. The code alone does not identify a failed component.',
  ),
  '138212': FaultDefinition(
    title: 'Active air flap control — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in active air flap control. The code alone does not identify a failed component.',
  ),
  '138213': FaultDefinition(
    title: 'Active air flap control — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in active air flap control. The code alone does not identify a failed component.',
  ),
  '138214': FaultDefinition(
    title: 'Active air flap control — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in active air flap control. The code alone does not identify a failed component.',
  ),
  '138215': FaultDefinition(
    title: 'Active air flap control — operation lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation lost in active air flap control. The code alone does not identify a failed component.',
  ),
  '138216': FaultDefinition(
    title: 'Active air flap control — backup function active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded backup function active in active air flap control. The code alone does not identify a failed component.',
  ),
  '138217': FaultDefinition(
    title: 'Active air flap control — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in active air flap control. The code alone does not identify a failed component.',
  ),
  '138218': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '138219': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '13821A': FaultDefinition(
    title: 'Active air flap control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in active air flap control. The code alone does not identify a failed component.',
  ),
  '13821B': FaultDefinition(
    title: 'Active air flap control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in active air flap control. The code alone does not identify a failed component.',
  ),
  '13821C': FaultDefinition(
    title: 'Active air flap control — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in active air flap control. The code alone does not identify a failed component.',
  ),
  '13821D': FaultDefinition(
    title: 'Active air flap control — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in active air flap control. The code alone does not identify a failed component.',
  ),
  '13821E': FaultDefinition(
    title: 'Active air flap control — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in active air flap control. The code alone does not identify a failed component.',
  ),
  '13821F': FaultDefinition(
    title: 'Active air flap control — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in active air flap control. The code alone does not identify a failed component.',
  ),
  '138220': FaultDefinition(
    title: 'Active air flap control — electrical fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded electrical fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '138301': FaultDefinition(
    title: 'Radiator air shutter — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138401': FaultDefinition(
    title: 'Radiator air shutter — electrical fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded electrical fault in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138501': FaultDefinition(
    title: 'Radiator air shutter — end stop not detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded end stop not detected in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138601': FaultDefinition(
    title: 'Radiator air shutter — end stop not detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded end stop not detected in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138701': FaultDefinition(
    title: 'Radiator air shutter — end stop detected too early',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded end stop detected too early in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138901': FaultDefinition(
    title: 'Radiator air shutter — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138902': FaultDefinition(
    title: 'Radiator air shutter — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138904': FaultDefinition(
    title: 'Radiator air shutter — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in radiator air shutter. The code alone does not identify a failed component.',
  ),
  '138A11': FaultDefinition(
    title: 'Exhaust flap, plausibility — adjustment time inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving exhaust flap, plausibility: adjustment time inconsistent. The code alone does not establish which part caused it.',
  ),
  '138A12': FaultDefinition(
    title: 'Exhaust flap — no feedback',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving exhaust flap: no feedback. The code alone does not establish which part caused it.',
  ),
  '139001': FaultDefinition(
    title: 'Lambda probe by catalyst, from fat to lean — delayed reaction',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lambda probe by catalyst, from fat to lean: delayed reaction. The code alone does not establish which part caused it.',
  ),
  '140001': FaultDefinition(
    title:
        'Combustion misfires, multiple cylinders — injection is switched off',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfires, multiple cylinders: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140002': FaultDefinition(
    title:
        'Combustion misfires, multiple cylinders — detrimental to exhaust after starting',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfires, multiple cylinders: detrimental to exhaust after starting. The code alone does not establish which part caused it.',
  ),
  '140004': FaultDefinition(
    title: 'Combustion misfires, multiple cylinders — harmful to exhaust gas',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfires, multiple cylinders: harmful to exhaust gas. The code alone does not establish which part caused it.',
  ),
  '140010': FaultDefinition(
    title: 'Misfires, multiple cylinders — detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving misfires, multiple cylinders: detected. The code alone does not establish which part caused it.',
  ),
  '140011': FaultDefinition(
    title: 'Misfires — injection cut-off',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving misfires: injection cut-off. The code alone does not establish which part caused it.',
  ),
  '140101': FaultDefinition(
    title: 'Combustion misfire, cylinder 1 — injection is switched off',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 1: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140102': FaultDefinition(
    title:
        'Combustion misfire, cylinder 1 — exhaust gas damaging after starting process',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 1: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140104': FaultDefinition(
    title: 'Combustion misfire, cylinder 1 — exhaust gas damaging',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 1: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140110': FaultDefinition(
    title: 'Combustion misfire, cylinder 1 — detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 1: detected. The code alone does not establish which part caused it.',
  ),
  '140201': FaultDefinition(
    title: 'Combustion misfire, cylinder 2 — injection is switched off',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 2: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140202': FaultDefinition(
    title:
        'Combustion misfire, cylinder 2 — exhaust gas damaging after starting process',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 2: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140204': FaultDefinition(
    title: 'Combustion misfire, cylinder 2 — exhaust gas damaging',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 2: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140210': FaultDefinition(
    title: 'Combustion misfire, cylinder 2 — detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 2: detected. The code alone does not establish which part caused it.',
  ),
  '140301': FaultDefinition(
    title: 'Combustion misfire, cylinder 3 — injection is switched off',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 3: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140302': FaultDefinition(
    title:
        'Combustion misfire, cylinder 3 — exhaust gas damaging after starting process',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 3: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140304': FaultDefinition(
    title: 'Combustion misfire, cylinder 3 — exhaust gas damaging',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 3: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140310': FaultDefinition(
    title: 'Combustion misfire, cylinder 3 — detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 3: detected. The code alone does not establish which part caused it.',
  ),
  '140401': FaultDefinition(
    title: 'Combustion misfire, cylinder 4 — injection is switched off',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 4: injection is switched off. The code alone does not establish which part caused it.',
  ),
  '140402': FaultDefinition(
    title:
        'Combustion misfire, cylinder 4 — exhaust gas damaging after starting process',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 4: exhaust gas damaging after starting process. The code alone does not establish which part caused it.',
  ),
  '140404': FaultDefinition(
    title: 'Combustion misfire, cylinder 4 — exhaust gas damaging',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 4: exhaust gas damaging. The code alone does not establish which part caused it.',
  ),
  '140410': FaultDefinition(
    title: 'Combustion misfire, cylinder 4 — detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving combustion misfire, cylinder 4: detected. The code alone does not establish which part caused it.',
  ),
  '142003': FaultDefinition(
    title: 'Cylinder deactivation — condensate-related cylinder deactivation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded condensate-related cylinder deactivation in cylinder deactivation. The code alone does not identify a failed component.',
  ),
  '142004': FaultDefinition(
    title: 'Combustion misfire — forced upshift requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded forced upshift requested in combustion misfire. The code alone does not identify a failed component.',
  ),
  '142005': FaultDefinition(
    title: 'Combustion misfire — torque reduction requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded torque reduction requested in combustion misfire. The code alone does not identify a failed component.',
  ),
  '144053': FaultDefinition(
    title: 'Cylinder mixture monitoring — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded multiple related faults in cylinder mixture monitoring. The code alone does not identify a failed component.',
  ),
  '144055': FaultDefinition(
    title: 'Cylinder mixture monitoring — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded multiple related faults in cylinder mixture monitoring. The code alone does not identify a failed component.',
  ),
  '150102': FaultDefinition(
    title: 'Ignition, cylinder 1 — Burning time too short',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 1: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150202': FaultDefinition(
    title: 'Ignition, cylinder 2 — Burning time too short',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 2: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150302': FaultDefinition(
    title: 'Ignition, cylinder 3 — Burning time too short',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 3: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150402': FaultDefinition(
    title: 'Ignition, cylinder 4 — Burning time too short',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 4: burning time too short. The code alone does not establish which part caused it.',
  ),
  '150C11': FaultDefinition(
    title: 'Ignition, cylinder 1 — Burning time outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 1: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C12': FaultDefinition(
    title: 'Ignition, cylinder 2 — Burning time outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 2: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C13': FaultDefinition(
    title: 'Ignition, cylinder 3 — Burning time outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 3: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '150C14': FaultDefinition(
    title: 'Ignition, cylinder 4 — Burning time outside tolerance',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition, cylinder 4: burning time outside tolerance. The code alone does not establish which part caused it.',
  ),
  '151001': FaultDefinition(
    title:
        'Ignition angle adjustment in idle, cold start — Ignition angle too early',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition angle adjustment in idle, cold start: ignition angle too early. The code alone does not establish which part caused it.',
  ),
  '151101': FaultDefinition(
    title:
        'Ignition angle adjustment in part load, cold start — Ignition angle too early',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition angle adjustment in part load, cold start: ignition angle too early. The code alone does not establish which part caused it.',
  ),
  '152001': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage ignition — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, supply voltage ignition: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '152007': FaultDefinition(
    title:
        'Relay ignition and injectors, supply voltage ignition — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, supply voltage ignition: short to ground. The code alone does not establish which part caused it.',
  ),
  '152008': FaultDefinition(
    title: 'Ignition circuit, supply voltage — bank failure or engine failure',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ignition circuit, supply voltage: bank failure or engine failure. The code alone does not establish which part caused it.',
  ),
  '152009': FaultDefinition(
    title: 'Ignition circuit — bank operation lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded bank operation lost in ignition circuit. The code alone does not identify a failed component.',
  ),
  '152108': FaultDefinition(
    title: 'Super-knock cylinder 1 — injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super-knock cylinder 1: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152118': FaultDefinition(
    title: 'Super knock cylinder 1 — permanent injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super knock cylinder 1: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152208': FaultDefinition(
    title: 'Super knock cylinder 2 — injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super knock cylinder 2: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152218': FaultDefinition(
    title: 'Super knock cylinder 2 — permanent injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super knock cylinder 2: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152308': FaultDefinition(
    title: 'Super knock cylinder 3 — injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super knock cylinder 3: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152318': FaultDefinition(
    title: 'Super-knock cylinder 3 — permanent injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super-knock cylinder 3: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152408': FaultDefinition(
    title: 'Super knock cylinder 4 — injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super knock cylinder 4: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152418': FaultDefinition(
    title: 'Super-knock cylinder 4 — permanent injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super-knock cylinder 4: permanent injection shutdown. The code alone does not establish which part caused it.',
  ),
  '152D08': FaultDefinition(
    title: 'Super knocking — injection shutdown',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving super knocking: injection shutdown. The code alone does not establish which part caused it.',
  ),
  '160001': FaultDefinition(
    title: 'Crankshaft sensor, signal — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving crankshaft sensor, signal: not received. The code alone does not establish which part caused it.',
  ),
  '160003': FaultDefinition(
    title: 'Crankshaft sensor — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in crankshaft sensor. The code alone does not identify a failed component.',
  ),
  '160020': FaultDefinition(
    title: 'Crankshaft sensor, signal — inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving crankshaft sensor, signal: inconsistent. The code alone does not establish which part caused it.',
  ),
  '160021': FaultDefinition(
    title: 'Crankshaft sensor — general synchronization loss',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving crankshaft sensor: general synchronization loss. The code alone does not establish which part caused it.',
  ),
  '160510': FaultDefinition(
    title: 'Crankshaft sensor [plausibility] — pulse width inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving crankshaft sensor [plausibility]: pulse width inconsistent. The code alone does not establish which part caused it.',
  ),
  '164020': FaultDefinition(
    title: 'Inlet camshaft sensor, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving inlet camshaft sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '164021': FaultDefinition(
    title: 'Inlet camshaft sensor, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving inlet camshaft sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '164030': FaultDefinition(
    title: 'Exhaust camshaft sensor, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving exhaust camshaft sensor, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '164031': FaultDefinition(
    title: 'Electric exhaust camshaft sensor — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric exhaust camshaft sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '164040': FaultDefinition(
    title: 'Inlet camshaft — assembly faulty',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving inlet camshaft: assembly faulty. The code alone does not establish which part caused it.',
  ),
  '164041': FaultDefinition(
    title: 'Output camshaft — assembly incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving output camshaft: assembly incorrect. The code alone does not establish which part caused it.',
  ),
  '168001': FaultDefinition(
    title: 'Knock sensor 1, signal — motor noise above limit value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 1, signal: motor noise above limit value. The code alone does not establish which part caused it.',
  ),
  '168002': FaultDefinition(
    title: 'Knock sensor 1, signal — engine noise below limit or open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 1, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '168101': FaultDefinition(
    title: 'Knock sensor 2, signal — motor noise over limit value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 2, signal: motor noise over limit value. The code alone does not establish which part caused it.',
  ),
  '168102': FaultDefinition(
    title: 'Knock sensor 2, signal — engine noise below limit or open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 2, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '168A20': FaultDefinition(
    title: 'Knock control — system error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock control: system error. The code alone does not establish which part caused it.',
  ),
  '168A30': FaultDefinition(
    title:
        'Knock sensor 1, electrical — signal input A, short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 1, electrical: signal input a, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A31': FaultDefinition(
    title: 'Knock sensor 1, electrical — signal input A, short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 1, electrical: signal input a, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A40': FaultDefinition(
    title:
        'Knock sensor 1, electrical — signal input B, short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 1, electrical: signal input b, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A41': FaultDefinition(
    title: 'Knock sensor 1, electrical — signal input B, short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 1, electrical: signal input b, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A50': FaultDefinition(
    title:
        'Knock sensor 2, electrical — signal input A, short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 2, electrical: signal input a, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A51': FaultDefinition(
    title: 'Knock sensor 2, electrical — signal input A, short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 2, electrical: signal input a, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A60': FaultDefinition(
    title:
        'Knock sensor 2, electrical — signal input B, short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 2, electrical: signal input b, short to battery positive. The code alone does not establish which part caused it.',
  ),
  '168A61': FaultDefinition(
    title: 'Knock sensor 2, electrical — signal input B, short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 2, electrical: signal input b, short to ground. The code alone does not establish which part caused it.',
  ),
  '168A70': FaultDefinition(
    title: 'Knock sensor — engine noise above limit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded engine noise above limit in knock sensor. The code alone does not identify a failed component.',
  ),
  '168A71': FaultDefinition(
    title: 'Knock sensor 1, signal — engine noise below limit or open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 1, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '168A80': FaultDefinition(
    title: 'Knock sensor — engine noise above limit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded engine noise above limit in knock sensor. The code alone does not identify a failed component.',
  ),
  '168A81': FaultDefinition(
    title: 'Knock sensor 2, signal — engine noise below limit or open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving knock sensor 2, signal: engine noise below limit or open circuit. The code alone does not establish which part caused it.',
  ),
  '180001': FaultDefinition(
    title: 'Catalyst — efficiency below limit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving catalyst: efficiency below limit. The code alone does not establish which part caused it.',
  ),
  '180110': FaultDefinition(
    title: 'Catalyst — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in catalyst. The code alone does not identify a failed component.',
  ),
  '190001': FaultDefinition(
    title: 'Tank leak diagnosis — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190002': FaultDefinition(
    title: 'Tank leak diagnosis — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190004': FaultDefinition(
    title: 'Tank leak diagnosis — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190201': FaultDefinition(
    title: 'Tank ventilation — leak detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded leak detected in tank ventilation. The code alone does not identify a failed component.',
  ),
  '190302': FaultDefinition(
    title:
        'Tank ventilation and purge air system, fine-sleck — leakage exceeding 0,5 mm',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank ventilation and purge air system, fine-sleck: leakage exceeding 0,5 mm. The code alone does not establish which part caused it.',
  ),
  '190401': FaultDefinition(
    title: 'Tank leak diagnosis — pump current outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded pump current outside expected range in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190402': FaultDefinition(
    title: 'Tank leak diagnosis — pump current outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded pump current outside expected range in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190404': FaultDefinition(
    title: 'Tank leak diagnosis — operation interrupted',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation interrupted in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190408': FaultDefinition(
    title: 'Tank leak diagnosis — pump current outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded pump current outside expected range in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190501': FaultDefinition(
    title: 'Tank leak diagnosis — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190502': FaultDefinition(
    title: 'Tank leak diagnosis — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190504': FaultDefinition(
    title: 'Tank leak diagnosis — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190601': FaultDefinition(
    title: 'Tank leak diagnosis — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190702': FaultDefinition(
    title: 'Tank leak diagnosis — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190704': FaultDefinition(
    title: 'Tank leak diagnosis — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank leak diagnosis. The code alone does not identify a failed component.',
  ),
  '190F08': FaultDefinition(
    title: 'Tank ventilation system — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank ventilation system: operation fault. The code alone does not establish which part caused it.',
  ),
  '191001': FaultDefinition(
    title: 'Tank ventilation valve, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank ventilation valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '191002': FaultDefinition(
    title: 'Tank ventilation valve, triggering — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank ventilation valve, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '191004': FaultDefinition(
    title: 'Tank ventilation valve, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank ventilation valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '191A21': FaultDefinition(
    title: 'Tank ventilation — stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck open in tank ventilation. The code alone does not identify a failed component.',
  ),
  '191B01': FaultDefinition(
    title: 'Tank ventilation — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in tank ventilation. The code alone does not identify a failed component.',
  ),
  '191B02': FaultDefinition(
    title: 'Tank ventilation — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in tank ventilation. The code alone does not identify a failed component.',
  ),
  '191B04': FaultDefinition(
    title: 'Tank ventilation — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank ventilation. The code alone does not identify a failed component.',
  ),
  '191C01': FaultDefinition(
    title: 'Tank ventilation — stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck open in tank ventilation. The code alone does not identify a failed component.',
  ),
  '191C02': FaultDefinition(
    title: 'Tank ventilation system, 2nd discharge point — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank ventilation system, 2nd discharge point: operation fault. The code alone does not establish which part caused it.',
  ),
  '191D01': FaultDefinition(
    title: 'Tank ventilation — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in tank ventilation. The code alone does not identify a failed component.',
  ),
  '193001': FaultDefinition(
    title: 'Fuel level sensor, left, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fuel level sensor, left, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '193002': FaultDefinition(
    title: 'Fuel level sensor, left, electric — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fuel level sensor, left, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '193008': FaultDefinition(
    title: 'Fuel level sensor, left, plausibility — CAN value inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fuel level sensor, left, plausibility: can value inconsistent. The code alone does not establish which part caused it.',
  ),
  '193101': FaultDefinition(
    title: 'Fuel level sensor, right, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fuel level sensor, right, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '193102': FaultDefinition(
    title: 'Fuel level sensors, right, electric — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fuel level sensors, right, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '193108': FaultDefinition(
    title: 'Fuel level sensor, right, plausibility — CAN value inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fuel level sensor, right, plausibility: can value inconsistent. The code alone does not establish which part caused it.',
  ),
  '193120': FaultDefinition(
    title: 'Fuel level — fuel-level inconsistency',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded fuel-level inconsistency in fuel level. The code alone does not identify a failed component.',
  ),
  '193121': FaultDefinition(
    title: 'Fuel level — fuel-level inconsistency',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded fuel-level inconsistency in fuel level. The code alone does not identify a failed component.',
  ),
  '193208': FaultDefinition(
    title:
        'Tank level, plausibility — deviation between consumption and change in level',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank level, plausibility: deviation between consumption and change in level. The code alone does not establish which part caused it.',
  ),
  '193218': FaultDefinition(
    title:
        'Tank level sensor — signal inconsistent due to hanging tank level sensor',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank level sensor: signal inconsistent due to hanging tank level sensor. The code alone does not establish which part caused it.',
  ),
  '193220': FaultDefinition(
    title: 'Fuel level — fuel-level inconsistency',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded fuel-level inconsistency in fuel level. The code alone does not identify a failed component.',
  ),
  '193221': FaultDefinition(
    title: 'Fuel level — fuel-level change inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded fuel-level change inconsistent in fuel level. The code alone does not identify a failed component.',
  ),
  '193A20': FaultDefinition(
    title: 'Tank level, collection error — signal and electrical',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank level, collection error: signal and electrical. The code alone does not establish which part caused it.',
  ),
  '194001': FaultDefinition(
    title:
        'Tank leakage module, temperature sensor, electrical — voltage below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, temperature sensor, electrical: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '194002': FaultDefinition(
    title:
        'Tank leakage module, temperature sensor, electrical — voltage above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, temperature sensor, electrical: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '194004': FaultDefinition(
    title:
        'Tank leakage module, temperature, plausibility, cold start — temperature inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, temperature, plausibility, cold start: temperature inconsistent. The code alone does not establish which part caused it.',
  ),
  '194101': FaultDefinition(
    title: 'Tank leakage module, temperature sensor, signal change — too fast',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, temperature sensor, signal change: too fast. The code alone does not establish which part caused it.',
  ),
  '194201': FaultDefinition(
    title: 'Tank leakage module, timer — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, timer: operation fault. The code alone does not establish which part caused it.',
  ),
  '194301': FaultDefinition(
    title: 'Tank leak diagnosis module — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in tank leak diagnosis module. The code alone does not identify a failed component.',
  ),
  '194401': FaultDefinition(
    title: 'Tank leakage module, communication — disturbed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, communication: disturbed. The code alone does not establish which part caused it.',
  ),
  '194501': FaultDefinition(
    title: 'Tank leakage module, communication — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, communication: operation fault. The code alone does not establish which part caused it.',
  ),
  '194601': FaultDefinition(
    title: 'Tank leakage module, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '194602': FaultDefinition(
    title: 'Tank leakage module, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '194604': FaultDefinition(
    title: 'Tank leakage module, electrical — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '194701': FaultDefinition(
    title: 'Tank leakage module, pressure switch — clamped',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, pressure switch: clamped. The code alone does not establish which part caused it.',
  ),
  '194801': FaultDefinition(
    title:
        'Tank leakage module, pressure switch, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, pressure switch, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '194802': FaultDefinition(
    title: 'Tank leakage module, pressure switch, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, pressure switch, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '194804': FaultDefinition(
    title: 'Tank leakage module, pressure switch, electrical — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving tank leakage module, pressure switch, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '195001': FaultDefinition(
    title:
        'Differential pressure sensor, tank ventilation valve, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving differential pressure sensor, tank ventilation valve, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '195002': FaultDefinition(
    title:
        'Differential pressure sensor, tank ventilation valve, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving differential pressure sensor, tank ventilation valve, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '195012': FaultDefinition(
    title: 'Tank ventilation — pressure fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded pressure fault in tank ventilation. The code alone does not identify a failed component.',
  ),
  '195013': FaultDefinition(
    title:
        'Differential pressure sensor, tank ventilation valve, working range — absolute pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving differential pressure sensor, tank ventilation valve, working range: absolute pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '195014': FaultDefinition(
    title: 'Tank ventilation — signal stuck at one value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal stuck at one value in tank ventilation. The code alone does not identify a failed component.',
  ),
  '1A2001': FaultDefinition(
    title: 'Electric fan, control line — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fan, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1A2002': FaultDefinition(
    title: 'Electric fan, control line — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fan, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '1A2004': FaultDefinition(
    title: 'Electric fan, control line — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fan, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '1A2108': FaultDefinition(
    title: 'Electric fan, self-diagnosis stage 1 — slight fan error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fan, self-diagnosis stage 1: slight fan error. The code alone does not establish which part caused it.',
  ),
  '1A2308': FaultDefinition(
    title:
        'Electric fan, self-diagnosis Stage 2 — fan failures with potential risk to the fan',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fan, self-diagnosis stage 2: fan failures with potential risk to the fan. The code alone does not establish which part caused it.',
  ),
  '1A2408': FaultDefinition(
    title:
        'Electric fan, self-diagnosis Stage 3 — Fan failure with engine function impairment',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fan, self-diagnosis stage 3: fan failure with engine function impairment. The code alone does not establish which part caused it.',
  ),
  '1A2508': FaultDefinition(
    title: 'Electric fan, self-diagnosis stage 4 — severe fan error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fan, self-diagnosis stage 4: severe fan error. The code alone does not establish which part caused it.',
  ),
  '1A2601': FaultDefinition(
    title:
        'Safety relay electric fan, control line — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving safety relay electric fan, control line: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1A2602': FaultDefinition(
    title: 'Safety relay electric fan, control line — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving safety relay electric fan, control line: short to ground. The code alone does not establish which part caused it.',
  ),
  '1A2604': FaultDefinition(
    title: 'Safety relay electric fan, control line — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving safety relay electric fan, control line: open circuit. The code alone does not establish which part caused it.',
  ),
  '1A2804': FaultDefinition(
    title: 'Electric fans, operational readiness — restricted',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fans, operational readiness: restricted. The code alone does not establish which part caused it.',
  ),
  '1A2904': FaultDefinition(
    title: 'Electric fans, ready for use — not available',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric fans, ready for use: not available. The code alone does not establish which part caused it.',
  ),
  '1B0808': FaultDefinition(
    title: 'Vehicle speed, plausibility — speed signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, plausibility: speed signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A20': FaultDefinition(
    title: 'Bad track detection — wheel speed above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving bad track detection: wheel speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1B0A21': FaultDefinition(
    title: 'Bad track detection — No wheel speed signal received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving bad track detection: no wheel speed signal received. The code alone does not establish which part caused it.',
  ),
  '1B0A40': FaultDefinition(
    title: 'Vehicle speed, plausibility — speed above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, plausibility: speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1B0A50': FaultDefinition(
    title: 'Vehicle speed — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded multiple related faults in vehicle speed. The code alone does not identify a failed component.',
  ),
  '1B0A60': FaultDefinition(
    title:
        'Vehicle speed, plausibility — minimum speed under load inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, plausibility: minimum speed under load inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A61': FaultDefinition(
    title: 'Vehicle speed, plausibility — minimum thrust speed inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, plausibility: minimum thrust speed inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A62': FaultDefinition(
    title: 'Vehicle speed, plausibility — speed signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, plausibility: speed signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A64': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/left, signal change — inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, wheel speed sensor rear/left, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A65': FaultDefinition(
    title:
        'Vehicle speed, front/left wheel speed sensor, signal change — inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, front/left wheel speed sensor, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A66': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/right, signal change — inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, wheel speed sensor rear/right, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B0A67': FaultDefinition(
    title:
        'Vehicle speed, front/right wheel speed sensor, signal change — inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, front/right wheel speed sensor, signal change: inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B2001': FaultDefinition(
    title: 'EWS manipulation protection — engine running blocked by EWS',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ews manipulation protection: engine running blocked by ews. The code alone does not establish which part caused it.',
  ),
  '1B2002': FaultDefinition(
    title: 'EWS Manipulation Protection — no starting value programmed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ews manipulation protection: no starting value programmed. The code alone does not establish which part caused it.',
  ),
  '1B2008': FaultDefinition(
    title: 'EWS Manipulation Protection — Answer inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ews manipulation protection: answer inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B2101': FaultDefinition(
    title: 'Interface EWS-DME — Hardware error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving interface ews-dme: hardware error. The code alone does not establish which part caused it.',
  ),
  '1B2102': FaultDefinition(
    title: 'Interface EWS-DME — frame error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving interface ews-dme: frame error. The code alone does not establish which part caused it.',
  ),
  '1B2104': FaultDefinition(
    title: 'EWS-DME interface — time-out',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving ews-dme interface: time-out. The code alone does not establish which part caused it.',
  ),
  '1B2109': FaultDefinition(
    title: 'Interface EWS-DME — reception error CAS interface',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving interface ews-dme: reception error cas interface. The code alone does not establish which part caused it.',
  ),
  '1B2201': FaultDefinition(
    title: 'DME, internal error, EWS data — no available storage option',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, ews data: no available storage option. The code alone does not establish which part caused it.',
  ),
  '1B2202': FaultDefinition(
    title: 'DME, internal error, EWS data — error release code storage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, ews data: error release code storage. The code alone does not establish which part caused it.',
  ),
  '1B2208': FaultDefinition(
    title: 'DME, internal error, EWS data — checksum error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, ews data: checksum error. The code alone does not establish which part caused it.',
  ),
  '1B2209': FaultDefinition(
    title: 'DME, internal error, EWS data — spelling error Secret Key',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, ews data: spelling error secret key. The code alone does not establish which part caused it.',
  ),
  '1B2301': FaultDefinition(
    title: 'FlexRay, Message (EWS Information FEM, 103.1.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (ews information fem, 103.1.4): not received. The code alone does not establish which part caused it.',
  ),
  '1B2302': FaultDefinition(
    title: 'FA-CAN, message (EWS service DME1/DDE1, 0x5C0) — frame error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (ews service dme1/dde1, 0x5c0): frame error. The code alone does not establish which part caused it.',
  ),
  '1B2304': FaultDefinition(
    title: 'FA-CAN, message (EWS service DME1/DDE1, 0x5C0) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (ews service dme1/dde1, 0x5c0): not received. The code alone does not establish which part caused it.',
  ),
  '1B2305': FaultDefinition(
    title:
        'FlexRay, message (stabilization status DSC 2, 47.1.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (stabilization status dsc 2, 47.1.2): not received. The code alone does not establish which part caused it.',
  ),
  '1B2904': FaultDefinition(
    title: 'Functional release, speed limitation — Code invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving functional release, speed limitation: code invalid. The code alone does not establish which part caused it.',
  ),
  '1B5101': FaultDefinition(
    title:
        'Terminal 15 3, line from CAS, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving terminal 15 3, line from cas, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1B5102': FaultDefinition(
    title: 'Terminal 15 3, line from CAS, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving terminal 15 3, line from cas, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1B5202': FaultDefinition(
    title: 'Terminal 15N 1 — no voltage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving terminal 15n 1: no voltage. The code alone does not establish which part caused it.',
  ),
  '1B5302': FaultDefinition(
    title: 'Terminal 15N 2 — no voltage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving terminal 15n 2: no voltage. The code alone does not establish which part caused it.',
  ),
  '1B5402': FaultDefinition(
    title: 'Terminal 15N 3 — no voltage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving terminal 15n 3: no voltage. The code alone does not establish which part caused it.',
  ),
  '1B6008': FaultDefinition(
    title: 'Brake light switch, plausibility — signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving brake light switch, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1B7101': FaultDefinition(
    title: 'Brake vacuum sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in brake vacuum sensor. The code alone does not identify a failed component.',
  ),
  '1B7201': FaultDefinition(
    title: 'Brake vacuum sensor — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in brake vacuum sensor. The code alone does not identify a failed component.',
  ),
  '1B7202': FaultDefinition(
    title: 'Brake vacuum sensor — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in brake vacuum sensor. The code alone does not identify a failed component.',
  ),
  '1B8004': FaultDefinition(
    title: 'EAC sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in EAC sensor. The code alone does not identify a failed component.',
  ),
  '1B8008': FaultDefinition(
    title: 'EAC sensor — response slower than expected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response slower than expected in EAC sensor. The code alone does not identify a failed component.',
  ),
  '1B8108': FaultDefinition(
    title: 'EAC sensor — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in EAC sensor. The code alone does not identify a failed component.',
  ),
  '1B8201': FaultDefinition(
    title: 'EAC sensor — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in EAC sensor. The code alone does not identify a failed component.',
  ),
  '1B8204': FaultDefinition(
    title: 'EAC sensor — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in EAC sensor. The code alone does not identify a failed component.',
  ),
  '1B8208': FaultDefinition(
    title: 'EAC sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in EAC sensor. The code alone does not identify a failed component.',
  ),
  '1B8302': FaultDefinition(
    title: 'Communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in communication. The code alone does not identify a failed component.',
  ),
  '1B8304': FaultDefinition(
    title: 'LIN communication — network frame error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded network frame error in LIN communication. The code alone does not identify a failed component.',
  ),
  '1B8308': FaultDefinition(
    title: 'Communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in communication. The code alone does not identify a failed component.',
  ),
  '1B9508': FaultDefinition(
    title:
        'Engine shutdown time, plausibility — time too short in correlation to engine coolant cooling',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine shutdown time, plausibility: time too short in correlation to engine coolant cooling. The code alone does not establish which part caused it.',
  ),
  '1B9608': FaultDefinition(
    title:
        'Engine shutdown time, plausibility — time too long in correlation with engine coolant cooling',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine shutdown time, plausibility: time too long in correlation with engine coolant cooling. The code alone does not establish which part caused it.',
  ),
  '1B9701': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combi - time counter DME, comparison — value time counter Combi above expected range in engine running',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving motor shutdown time, time counter combi - time counter dme, comparison: value time counter combi above expected range in engine running. The code alone does not establish which part caused it.',
  ),
  '1B9702': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combine - time counter DME, comparison — value time counter Combine below expected range in engine running',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving motor shutdown time, time counter combine - time counter dme, comparison: value time counter combine below expected range in engine running. The code alone does not establish which part caused it.',
  ),
  '1B9804': FaultDefinition(
    title: 'Engine shut-off time, signal — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine shut-off time, signal: not received. The code alone does not establish which part caused it.',
  ),
  '1B9A01': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combi - time counter DME, comparison — value time counter Combi above expected range in lag',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving motor shutdown time, time counter combi - time counter dme, comparison: value time counter combi above expected range in lag. The code alone does not establish which part caused it.',
  ),
  '1B9A02': FaultDefinition(
    title:
        'Motor shutdown time, time counter Combi - time counter DME, comparison — value time counter Combi below expected range in lag',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving motor shutdown time, time counter combi - time counter dme, comparison: value time counter combi below expected range in lag. The code alone does not establish which part caused it.',
  ),
  '1B9B01': FaultDefinition(
    title: 'Engine shut-off time — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine shut-off time: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '1BC004': FaultDefinition(
    title: 'Zero-speed sensor, adaptation — not learned (MSA deactivated)',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving zero-speed sensor, adaptation: not learned (msa deactivated). The code alone does not establish which part caused it.',
  ),
  '1BC101': FaultDefinition(
    title: 'Zero-speed sensor, plausibility — signal inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving zero-speed sensor, plausibility: signal inconsistent. The code alone does not establish which part caused it.',
  ),
  '1BC110': FaultDefinition(
    title: 'Zero gear sensor, signal — pulse duty factor above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving zero gear sensor, signal: pulse duty factor above expected range. The code alone does not establish which part caused it.',
  ),
  '1BC111': FaultDefinition(
    title: 'Zero gear sensor, signal — pulse duty factor below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving zero gear sensor, signal: pulse duty factor below expected range. The code alone does not establish which part caused it.',
  ),
  '1BC112': FaultDefinition(
    title: 'Zero-speed sensor, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving zero-speed sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BC113': FaultDefinition(
    title: 'Electric zero speed sensor — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving electric zero speed sensor: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BC114': FaultDefinition(
    title: 'Neutral gear sensor — outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded outside expected range in neutral gear sensor. The code alone does not identify a failed component.',
  ),
  '1BD001': FaultDefinition(
    title: 'Vehicle speed — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in vehicle speed. The code alone does not identify a failed component.',
  ),
  '1BD101': FaultDefinition(
    title: 'Vehicle speed — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in vehicle speed. The code alone does not identify a failed component.',
  ),
  '1BD201': FaultDefinition(
    title: 'Vehicle speed — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in vehicle speed. The code alone does not identify a failed component.',
  ),
  '1BD301': FaultDefinition(
    title: 'Vehicle speed — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in vehicle speed. The code alone does not identify a failed component.',
  ),
  '1BD401': FaultDefinition(
    title: 'Wheel speed sensor rear/left, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wheel speed sensor rear/left, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BD402': FaultDefinition(
    title: 'Rear/left wheel speed sensor, electric — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving rear/left wheel speed sensor, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD404': FaultDefinition(
    title: 'Wheel speed sensor — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in wheel speed sensor. The code alone does not identify a failed component.',
  ),
  '1BD408': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/left, electric — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, wheel speed sensor rear/left, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1BD501': FaultDefinition(
    title:
        'Wheel speed sensor front/left, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wheel speed sensor front/left, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BD502': FaultDefinition(
    title: 'Wheel speed sensor front/left, electric — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wheel speed sensor front/left, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD504': FaultDefinition(
    title: 'Wheel speed sensor — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in wheel speed sensor. The code alone does not identify a failed component.',
  ),
  '1BD508': FaultDefinition(
    title:
        'Vehicle speed, front/left wheel speed sensor, electric — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, front/left wheel speed sensor, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1BD601': FaultDefinition(
    title: 'Wheel speed sensor rear/right, electric — short to plus',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wheel speed sensor rear/right, electric: short to plus. The code alone does not establish which part caused it.',
  ),
  '1BD602': FaultDefinition(
    title: 'Wheel speed sensor rear/right, electric — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wheel speed sensor rear/right, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD604': FaultDefinition(
    title: 'Wheel speed sensor — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in wheel speed sensor. The code alone does not identify a failed component.',
  ),
  '1BD608': FaultDefinition(
    title:
        'Vehicle speed, wheel speed sensor rear/right, electric — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, wheel speed sensor rear/right, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1BD701': FaultDefinition(
    title:
        'Wheel speed sensor front/right, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wheel speed sensor front/right, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1BD702': FaultDefinition(
    title: 'Wheel speed sensor front/right, electric — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving wheel speed sensor front/right, electric: short to ground. The code alone does not establish which part caused it.',
  ),
  '1BD704': FaultDefinition(
    title: 'Wheel speed sensor — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in wheel speed sensor. The code alone does not identify a failed component.',
  ),
  '1BD708': FaultDefinition(
    title:
        'Vehicle speed, front/right wheel speed sensor, electric — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle speed, front/right wheel speed sensor, electric: operation fault. The code alone does not establish which part caused it.',
  ),
  '1C0001': FaultDefinition(
    title: 'Engine oil pressure control, plausibility — pressure variations',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control, plausibility: pressure variations. The code alone does not establish which part caused it.',
  ),
  '1C0101': FaultDefinition(
    title:
        'Engine oil pressure control, plausibility, static — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control, plausibility, static: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '1C0102': FaultDefinition(
    title:
        'Engine oil pressure control, plausibility, static — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control, plausibility, static: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '1C0201': FaultDefinition(
    title:
        'Engine oil pressure control valve, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control valve, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1C0202': FaultDefinition(
    title: 'Engine oil pressure control valve, triggering — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control valve, triggering: short to ground. The code alone does not establish which part caused it.',
  ),
  '1C0204': FaultDefinition(
    title: 'Engine oil pressure control valve, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control valve, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1C0301': FaultDefinition(
    title:
        'Engine oil pressure control valve — clamped in fully energized position (minimum oil pressure)',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control valve: clamped in fully energized position (minimum oil pressure). The code alone does not establish which part caused it.',
  ),
  '1C0302': FaultDefinition(
    title:
        'Engine oil pressure control valve — clamped in deenergized position (maximum oil pressure)',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control valve: clamped in deenergized position (maximum oil pressure). The code alone does not establish which part caused it.',
  ),
  '1C0401': FaultDefinition(
    title: 'Engine oil pressure control — unstable',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure control: unstable. The code alone does not establish which part caused it.',
  ),
  '1C2001': FaultDefinition(
    title: 'Engine oil pump — pressure above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pump: pressure above expected range. The code alone does not establish which part caused it.',
  ),
  '1C2002': FaultDefinition(
    title: 'Engine oil pump — pressure below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pump: pressure below expected range. The code alone does not establish which part caused it.',
  ),
  '1C3001': FaultDefinition(
    title: 'Engine oil pressure sensor, electric — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure sensor, electric: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1C3002': FaultDefinition(
    title: 'Engine oil pressure sensor, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure sensor, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '1C3101': FaultDefinition(
    title:
        'Engine oil pressure sensor, plausibility — pressure above expected range before engine start',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure sensor, plausibility: pressure above expected range before engine start. The code alone does not establish which part caused it.',
  ),
  '1C3102': FaultDefinition(
    title:
        'Engine oil pressure sensor, plausibility — pressure before engine start below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure sensor, plausibility: pressure before engine start below expected range. The code alone does not establish which part caused it.',
  ),
  '1C3108': FaultDefinition(
    title: 'Engine oil pressure sensor, signal — fixed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil pressure sensor, signal: fixed. The code alone does not establish which part caused it.',
  ),
  '1C3110': FaultDefinition(
    title: 'Engine oil pressure and temperature sensor — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C3111': FaultDefinition(
    title:
        'Engine oil pressure and temperature sensor — component fault reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded component fault reported in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C3112': FaultDefinition(
    title: 'Engine oil pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C3113': FaultDefinition(
    title: 'Engine oil pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C3114': FaultDefinition(
    title: 'Engine oil pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C3115': FaultDefinition(
    title: 'Engine oil pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C3116': FaultDefinition(
    title: 'Engine oil pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C3117': FaultDefinition(
    title: 'Engine oil pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in engine oil pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '1C4002': FaultDefinition(
    title: 'Engine oil level — below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil level: below expected range. The code alone does not establish which part caused it.',
  ),
  '1C4110': FaultDefinition(
    title: 'Oil state sensor — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving oil state sensor: operation fault. The code alone does not establish which part caused it.',
  ),
  '1C4116': FaultDefinition(
    title: 'Oil condition monitoring — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in oil condition monitoring. The code alone does not identify a failed component.',
  ),
  '1C4118': FaultDefinition(
    title: 'Oil condition sensor — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in oil condition sensor. The code alone does not identify a failed component.',
  ),
  '1C4119': FaultDefinition(
    title: 'Engine oil temperature sensor, electrical — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving engine oil temperature sensor, electrical: operation fault. The code alone does not establish which part caused it.',
  ),
  '1C4121': FaultDefinition(
    title: 'Oil condition sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in oil condition sensor. The code alone does not identify a failed component.',
  ),
  '1C4122': FaultDefinition(
    title: 'Oil condition sensor — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in oil condition sensor. The code alone does not identify a failed component.',
  ),
  '1D2008': FaultDefinition(
    title: 'Characteristic thermostat — clamps open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving characteristic thermostat: clamps open. The code alone does not establish which part caused it.',
  ),
  '1D2401': FaultDefinition(
    title:
        'Characteristic field thermostat, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving characteristic field thermostat, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1D2402': FaultDefinition(
    title: 'Characteristic field thermostat, control — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving characteristic field thermostat, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '1D2404': FaultDefinition(
    title: 'Characteristic field thermostat, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving characteristic field thermostat, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1D3001': FaultDefinition(
    title:
        'Coupling, plausibility — transferable torque below expected range, coupling slightly damaged',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coupling, plausibility: transferable torque below expected range, coupling slightly damaged. The code alone does not establish which part caused it.',
  ),
  '1D3101': FaultDefinition(
    title:
        'Coupling, plausibility — transferable torque below expected range, clutch damaged',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coupling, plausibility: transferable torque below expected range, clutch damaged. The code alone does not establish which part caused it.',
  ),
  '1D3201': FaultDefinition(
    title:
        'Coupling, plausibility — transferable torque below expected range, clutch severely damaged',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coupling, plausibility: transferable torque below expected range, clutch severely damaged. The code alone does not establish which part caused it.',
  ),
  '1D3211': FaultDefinition(
    title:
        'Coupling temperature — warning threshold value 1 is exceeded without damage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coupling temperature: warning threshold value 1 is exceeded without damage. The code alone does not establish which part caused it.',
  ),
  '1D3212': FaultDefinition(
    title:
        'Coupling temperature — warning threshold value 2 is exceeded without damage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving coupling temperature: warning threshold value 2 is exceeded without damage. The code alone does not establish which part caused it.',
  ),
  '1D3650': FaultDefinition(
    title: 'Rear axle transmission, plausibility — translation inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving rear axle transmission, plausibility: translation inconsistent. The code alone does not establish which part caused it.',
  ),
  '1D3701': FaultDefinition(
    title: 'Power management, battery — speed increase due to low charge level',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management, battery: speed increase due to low charge level. The code alone does not establish which part caused it.',
  ),
  '1D3702': FaultDefinition(
    title: 'Power management — operation interrupted',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation interrupted in power management. The code alone does not identify a failed component.',
  ),
  '1D3810': FaultDefinition(
    title: 'Clutch switch — positions inconsistent relative to each other',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving clutch switch: positions inconsistent relative to each other. The code alone does not establish which part caused it.',
  ),
  '1D3901': FaultDefinition(
    title: 'Transmission communication — signal lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal lost in transmission communication. The code alone does not identify a failed component.',
  ),
  '1D3A01': FaultDefinition(
    title:
        'Communication — signal (speed transmission train output) in A-CAN, message (transmission train data, 0x1AF): invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving communication: signal (speed transmission train output) in a-can, message (transmission train data, 0x1af): invalid. The code alone does not establish which part caused it.',
  ),
  '1D3B01': FaultDefinition(
    title: 'Drivetrain — signal lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal lost in drivetrain. The code alone does not identify a failed component.',
  ),
  '1D3C01': FaultDefinition(
    title:
        'Communication — signal (status shift active transmission) in A- / FA-CAN, message (status transmission control, 0x39A): invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving communication: signal (status shift active transmission) in a- / fa-can, message (status transmission control, 0x39a): invalid. The code alone does not establish which part caused it.',
  ),
  '1D3F01': FaultDefinition(
    title: 'Transmission oil temperature — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in transmission oil temperature. The code alone does not identify a failed component.',
  ),
  '1D4001': FaultDefinition(
    title: 'Transmission oil temperature — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in transmission oil temperature. The code alone does not identify a failed component.',
  ),
  '1D4101': FaultDefinition(
    title: 'Transmission communication — reduced-power mode active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power mode active in transmission communication. The code alone does not identify a failed component.',
  ),
  '1E0001': FaultDefinition(
    title: 'Idle control — speed above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving idle control: speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1E0002': FaultDefinition(
    title: 'Idle control — speed below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving idle control: speed below expected range. The code alone does not establish which part caused it.',
  ),
  '1E0101': FaultDefinition(
    title: 'Idle control, cold start — speed above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving idle control, cold start: speed above expected range. The code alone does not establish which part caused it.',
  ),
  '1E0102': FaultDefinition(
    title: 'Idle control, cold start — speed below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving idle control, cold start: speed below expected range. The code alone does not establish which part caused it.',
  ),
  '1E0108': FaultDefinition(
    title: 'Idle control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in idle control. The code alone does not identify a failed component.',
  ),
  '1E0308': FaultDefinition(
    title: 'Idle control, plausibility, cold start — speed inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving idle control, plausibility, cold start: speed inconsistent. The code alone does not establish which part caused it.',
  ),
  '1E2000': FaultDefinition(
    title: 'Engine oil — warning threshold exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded warning threshold exceeded in engine oil. The code alone does not identify a failed component.',
  ),
  '1E2001': FaultDefinition(
    title: 'Engine oil — warning threshold exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded warning threshold exceeded in engine oil. The code alone does not identify a failed component.',
  ),
  '1E5201': FaultDefinition(
    title:
        'Speed limitation with vehicle stationary — idle speed too long above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving speed limitation with vehicle stationary: idle speed too long above expected range. The code alone does not establish which part caused it.',
  ),
  '1E5301': FaultDefinition(
    title: 'Manipulation protection — engine power above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving manipulation protection: engine power above expected range. The code alone does not establish which part caused it.',
  ),
  '1E5A20': FaultDefinition(
    title: 'Drive, safety function — power reduction through safety concept',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: power reduction through safety concept. The code alone does not establish which part caused it.',
  ),
  '1F0513': FaultDefinition(
    title: 'Valvetronic control — outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded outside expected range in Valvetronic control. The code alone does not identify a failed component.',
  ),
  '1F0514': FaultDefinition(
    title: 'Valvetronic, supply voltage — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, supply voltage: short to ground. The code alone does not establish which part caused it.',
  ),
  '1F0515': FaultDefinition(
    title: 'Valvetronic, supply voltage — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving valvetronic, supply voltage: open circuit. The code alone does not establish which part caused it.',
  ),
  '1F0516': FaultDefinition(
    title: 'Drive, safety function — AD converter idle test pulse test',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: ad converter idle test pulse test. The code alone does not establish which part caused it.',
  ),
  '1F0517': FaultDefinition(
    title: 'Drive, safety function — AD converter test voltage test',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: ad converter test voltage test. The code alone does not establish which part caused it.',
  ),
  '1F0518': FaultDefinition(
    title: 'DME, internal error, safety function — air volume adjustment',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, safety function: air volume adjustment. The code alone does not establish which part caused it.',
  ),
  '1F0519': FaultDefinition(
    title:
        'Drive, safety function — accelerator pedal module or pedal transducer inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: accelerator pedal module or pedal transducer inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0520': FaultDefinition(
    title: 'Drive, safety function — speed sensor inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: speed sensor inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0521': FaultDefinition(
    title:
        'DME, internal error, safety function — plausibility check of the mixture correction factors',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, safety function: plausibility check of the mixture correction factors. The code alone does not establish which part caused it.',
  ),
  '1F0522': FaultDefinition(
    title:
        'DME, internal fault, safety function — injection limitation level 1',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, safety function: injection limitation level 1. The code alone does not establish which part caused it.',
  ),
  '1F0523': FaultDefinition(
    title: 'Drive, safety function — safety shutdown injection',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: safety shutdown injection. The code alone does not establish which part caused it.',
  ),
  '1F0524': FaultDefinition(
    title: 'DME, internal error, safety function — Lambda setpoint',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, safety function: lambda setpoint. The code alone does not establish which part caused it.',
  ),
  '1F0525': FaultDefinition(
    title:
        'DME, internal fault, safety function — plausibility check relative fuel mass',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, safety function: plausibility check relative fuel mass. The code alone does not establish which part caused it.',
  ),
  '1F0526': FaultDefinition(
    title: 'DME, internal error, safety function — moment comparison',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, safety function: moment comparison. The code alone does not establish which part caused it.',
  ),
  '1F0527': FaultDefinition(
    title:
        'DME, internal error, safety function — drive train transmission ratio inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, safety function: drive train transmission ratio inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0528': FaultDefinition(
    title: 'Drive, safety function — transmission variant inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: transmission variant inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0529': FaultDefinition(
    title: 'DME, internal fault, safety function — ignition angle monitoring',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, safety function: ignition angle monitoring. The code alone does not establish which part caused it.',
  ),
  '1F052A': FaultDefinition(
    title: 'DME internal control — speed-controller torque fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded speed-controller torque fault in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F0530': FaultDefinition(
    title: 'Drive, safety function — switch-off path test negative',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving drive, safety function: switch-off path test negative. The code alone does not establish which part caused it.',
  ),
  '1F0531': FaultDefinition(
    title:
        'DME, internal fault, safety function — plausibility check fuel mass',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, safety function: plausibility check fuel mass. The code alone does not establish which part caused it.',
  ),
  '1F0532': FaultDefinition(
    title: 'Communication — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in communication. The code alone does not identify a failed component.',
  ),
  '1F0538': FaultDefinition(
    title: 'DME internal control — total torque outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded total torque outside expected range in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F0539': FaultDefinition(
    title: 'DME internal control — total torque outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded total torque outside expected range in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F053A': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F053B': FaultDefinition(
    title:
        'DME, internal error, safety function — torque requirement inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, safety function: torque requirement inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F053E': FaultDefinition(
    title: 'DME internal control — ethanol content check failed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded ethanol content check failed in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F0904': FaultDefinition(
    title: 'DME, internal error, Valvetronic control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, valvetronic control: operation fault. The code alone does not establish which part caused it.',
  ),
  '1F0905': FaultDefinition(
    title: 'DME, internal error, Valvetronic — power inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, valvetronic: power inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F0906': FaultDefinition(
    title: 'DME, internal fault, Valvetronic — voltage outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, valvetronic: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1401': FaultDefinition(
    title: 'DME, internal error, MSA monitoring — incorrect calculation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, msa monitoring: incorrect calculation. The code alone does not establish which part caused it.',
  ),
  '1F1A40': FaultDefinition(
    title: 'DME, internal error — SPI communication monitoring',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: spi communication monitoring. The code alone does not establish which part caused it.',
  ),
  '1F1A41': FaultDefinition(
    title: 'Communication — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in communication. The code alone does not identify a failed component.',
  ),
  '1F1A42': FaultDefinition(
    title: 'Communication — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in communication. The code alone does not identify a failed component.',
  ),
  '1F1A50': FaultDefinition(
    title: 'DME, internal error — erasing EEPROM incorrectly',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: erasing eeprom incorrectly. The code alone does not establish which part caused it.',
  ),
  '1F1A51': FaultDefinition(
    title: 'DME, internal error — reading EEPROM incorrectly',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: reading eeprom incorrectly. The code alone does not establish which part caused it.',
  ),
  '1F1A52': FaultDefinition(
    title: 'DME, internal error — Write EEPROM incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: write eeprom incorrect. The code alone does not establish which part caused it.',
  ),
  '1F1A60': FaultDefinition(
    title: 'DME, internal error — monitoring module error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: monitoring module error. The code alone does not establish which part caused it.',
  ),
  '1F1A70': FaultDefinition(
    title: 'DME, internal failure, monitoring 5V supply — overvoltage detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal failure, monitoring 5v supply: overvoltage detected. The code alone does not establish which part caused it.',
  ),
  '1F1A71': FaultDefinition(
    title: 'DME, internal fault, monitoring 5V supply — undervoltage detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal fault, monitoring 5v supply: undervoltage detected. The code alone does not establish which part caused it.',
  ),
  '1F1A80': FaultDefinition(
    title: 'DME, internal error, watchdog output — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, watchdog output: operation fault. The code alone does not establish which part caused it.',
  ),
  '1F1A81': FaultDefinition(
    title:
        'DME, internal error, watchdog output — incorrect question/answer communication',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, watchdog output: incorrect question/answer communication. The code alone does not establish which part caused it.',
  ),
  '1F1A82': FaultDefinition(
    title: 'DME, internal error, watchdog output — surge detection',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, watchdog output: surge detection. The code alone does not establish which part caused it.',
  ),
  '1F1A90': FaultDefinition(
    title: 'Monitoring 5V sensor supply — voltage outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving monitoring 5v sensor supply: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1A91': FaultDefinition(
    title: 'Monitoring 5V sensor supply 2 — voltage outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving monitoring 5v sensor supply 2: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1A92': FaultDefinition(
    title: 'Monitoring 5V sensor supply 3 — voltage outside valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving monitoring 5v sensor supply 3: voltage outside valid range. The code alone does not establish which part caused it.',
  ),
  '1F1AA0': FaultDefinition(
    title: 'DME, internal error — software reset',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: software reset. The code alone does not establish which part caused it.',
  ),
  '1F1AA1': FaultDefinition(
    title: 'DME, internal error — software reset',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: software reset. The code alone does not establish which part caused it.',
  ),
  '1F1AA2': FaultDefinition(
    title: 'DME, internal error — software reset',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error: software reset. The code alone does not establish which part caused it.',
  ),
  '1F1B40': FaultDefinition(
    title: 'Starting unit pinion starter, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving starting unit pinion starter, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1F1B41': FaultDefinition(
    title: 'Starting unit pinion starter, control — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving starting unit pinion starter, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '1F1B42': FaultDefinition(
    title: 'Starting unit pinion starter, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving starting unit pinion starter, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1F1B50': FaultDefinition(
    title: 'Vehicle electrical supply — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in vehicle electrical supply. The code alone does not identify a failed component.',
  ),
  '1F1B54': FaultDefinition(
    title: 'Power management — electrical generation lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded electrical generation lost in power management. The code alone does not identify a failed component.',
  ),
  '1F1B55': FaultDefinition(
    title: 'Power management — voltage fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded voltage fault in power management. The code alone does not identify a failed component.',
  ),
  '1F2102': FaultDefinition(
    title: 'Function release, power increase — not performed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving function release, power increase: not performed. The code alone does not establish which part caused it.',
  ),
  '1F2104': FaultDefinition(
    title:
        'DME, incorrect data set — FA-CAN, message (vehicle type, 0x388): not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, incorrect data set: fa-can, message (vehicle type, 0x388): not received. The code alone does not establish which part caused it.',
  ),
  '1F2108': FaultDefinition(
    title: 'DME, wrong data set — variant monitoring',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, wrong data set: variant monitoring. The code alone does not establish which part caused it.',
  ),
  '1F2601': FaultDefinition(
    title: 'DME, coding — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: not received. The code alone does not establish which part caused it.',
  ),
  '1F2604': FaultDefinition(
    title: 'DME, coding — VIN wrong',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: vin wrong. The code alone does not establish which part caused it.',
  ),
  '1F2701': FaultDefinition(
    title: 'DME, coding — spelling error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: spelling error. The code alone does not establish which part caused it.',
  ),
  '1F2702': FaultDefinition(
    title: 'DME, coding — Signature verification incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: signature verification incorrect. The code alone does not establish which part caused it.',
  ),
  '1F2704': FaultDefinition(
    title: 'DME, coding — data inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, coding: data inconsistent. The code alone does not establish which part caused it.',
  ),
  '1F2801': FaultDefinition(
    title: 'DME internal control — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F2802': FaultDefinition(
    title: 'DME internal control — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F4005': FaultDefinition(
    title: 'Power management — relay or valve stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded relay or valve stuck closed in power management. The code alone does not identify a failed component.',
  ),
  '1F4006': FaultDefinition(
    title: 'Power management — relay or valve stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded relay or valve stuck open in power management. The code alone does not identify a failed component.',
  ),
  '1F4A01': FaultDefinition(
    title: 'Relay ignition and injectors, control — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, control: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '1F4A02': FaultDefinition(
    title: 'Relay ignition and injectors, control — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, control: short to ground. The code alone does not establish which part caused it.',
  ),
  '1F4A10': FaultDefinition(
    title: 'Relay ignition and injectors, control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving relay ignition and injectors, control: open circuit. The code alone does not establish which part caused it.',
  ),
  '1F4D10': FaultDefinition(
    title: 'DME internal control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in DME internal control. The code alone does not identify a failed component.',
  ),
  '1F5020': FaultDefinition(
    title:
        'DME, internal error, internal temperature sensor — value above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, internal temperature sensor: value above expected range. The code alone does not establish which part caused it.',
  ),
  '1F5021': FaultDefinition(
    title:
        'DME, internal error, internal temperature sensor — value below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, internal error, internal temperature sensor: value below expected range. The code alone does not establish which part caused it.',
  ),
  '1F5101': FaultDefinition(
    title: 'DME Temperature — Overtemperature',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme temperature: overtemperature. The code alone does not establish which part caused it.',
  ),
  '1FB001': FaultDefinition(
    title: 'Power Management — Transport monitoring battery charge status OK',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: transport monitoring battery charge status ok. The code alone does not establish which part caused it.',
  ),
  '1FB101': FaultDefinition(
    title:
        'Power Management — Battery below the upper start-up capability limit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: battery below the upper start-up capability limit. The code alone does not establish which part caused it.',
  ),
  '1FB201': FaultDefinition(
    title: 'Check-Control message (ID 257) — Engine too hot! Moderate driving',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check-control message (id 257): engine too hot! moderate driving. The code alone does not establish which part caused it.',
  ),
  '1FB301': FaultDefinition(
    title: 'Check control message (ID 39) — Engine overheated. Be careful',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check control message (id 39): engine overheated. be careful. The code alone does not establish which part caused it.',
  ),
  '1FB401': FaultDefinition(
    title: 'Check control message (ID 367) — Drive moderately',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check control message (id 367): drive moderately. The code alone does not establish which part caused it.',
  ),
  '1FB501': FaultDefinition(
    title: 'Check-Control Message (ID 27) — Refill engine oil',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check-control message (id 27): refill engine oil. The code alone does not establish which part caused it.',
  ),
  '1FB601': FaultDefinition(
    title:
        'Check control message (ID 450) — Auto Start Stop function deactivated',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check control message (id 450): auto start stop function deactivated. The code alone does not establish which part caused it.',
  ),
  '1FB701': FaultDefinition(
    title: 'Check control message (ID 397) — Auto Start Stop function failed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check control message (id 397): auto start stop function failed. The code alone does not establish which part caused it.',
  ),
  '1FB801': FaultDefinition(
    title:
        'Check control message (ID 212) — engine oil pressure. Persistent cautiously',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check control message (id 212): engine oil pressure. persistent cautiously. The code alone does not establish which part caused it.',
  ),
  '1FB901': FaultDefinition(
    title: 'Check control message (ID 278) — Select low gear',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check control message (id 278): select low gear. The code alone does not establish which part caused it.',
  ),
  '1FBA01': FaultDefinition(
    title: 'Check-control message — fuel cap reported open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded fuel cap reported open in check-control message. The code alone does not identify a failed component.',
  ),
  '1FBB01': FaultDefinition(
    title: 'Check-control message (ID 567) — Engine fan. Moderate driving',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check-control message (id 567): engine fan. moderate driving. The code alone does not establish which part caused it.',
  ),
  '1FBC01': FaultDefinition(
    title: 'Check control message (ID 584) — Transport mode',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving check control message (id 584): transport mode. The code alone does not establish which part caused it.',
  ),
  '1FBD00': FaultDefinition(
    title: 'Check-control message — stop-driving warning requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stop-driving warning requested in check-control message. The code alone does not identify a failed component.',
  ),
  '1FBD01': FaultDefinition(
    title: 'Check-control message — stop-driving warning requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stop-driving warning requested in check-control message. The code alone does not identify a failed component.',
  ),
  '1FBD05': FaultDefinition(
    title: 'Check-control message — charge cable condition reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded charge cable condition reported in check-control message. The code alone does not identify a failed component.',
  ),
  '1FBD06': FaultDefinition(
    title: 'Check-control message — charge cable condition reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded charge cable condition reported in check-control message. The code alone does not identify a failed component.',
  ),
  '1FBD10': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '1FBE06': FaultDefinition(
    title: 'Check-control message — fuel level reported empty',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded fuel level reported empty in check-control message. The code alone does not identify a failed component.',
  ),
  '200D04': FaultDefinition(
    title: 'Drivetrain — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in drivetrain. The code alone does not identify a failed component.',
  ),
  '200F11': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F12': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F13': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F14': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F15': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F16': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F17': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F18': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F19': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F20': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F21': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F22': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F23': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F24': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F25': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F26': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F27': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F28': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F29': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F2A': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F2B': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F2C': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F2D': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '200F2E': FaultDefinition(
    title: 'DME internal control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in DME internal control. The code alone does not identify a failed component.',
  ),
  '201004': FaultDefinition(
    title: 'CBS client — output of replacement value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving cbs client: output of replacement value. The code alone does not establish which part caused it.',
  ),
  '201010': FaultDefinition(
    title: 'A- / FA-CAN Hardware — defective',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a- / fa-can hardware: defective. The code alone does not establish which part caused it.',
  ),
  '201020': FaultDefinition(
    title: 'FlexRay hardware — defective',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray hardware: defective. The code alone does not establish which part caused it.',
  ),
  '201101': FaultDefinition(
    title:
        'DME, manipulation protection — program or data manipulation detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme, manipulation protection: program or data manipulation detected. The code alone does not establish which part caused it.',
  ),
  '20A701': FaultDefinition(
    title: 'Engine cooling system — outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded outside expected range in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A703': FaultDefinition(
    title: 'Engine cooling system — protective power reduction active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded protective power reduction active in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A704': FaultDefinition(
    title: 'Engine cooling system — reduced-power mode requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power mode requested in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A705': FaultDefinition(
    title: 'Engine cooling system — operation interrupted',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation interrupted in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A706': FaultDefinition(
    title: 'Engine cooling system — operation completed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation completed in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A707': FaultDefinition(
    title: 'Engine cooling system — operation started',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation started in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A801': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A802': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A804': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A820': FaultDefinition(
    title: 'Engine cooling system — coolant flow below expected level',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant flow below expected level in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A901': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A902': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A904': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A908': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20A910': FaultDefinition(
    title:
        'Engine cooling system — cooling-system contamination or trapped air reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded cooling-system contamination or trapped air reported in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20AB08': FaultDefinition(
    title: 'Engine cooling system — coolant pump operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded coolant pump operation fault in engine cooling system. The code alone does not identify a failed component.',
  ),
  '20BA20': FaultDefinition(
    title: 'Clutch switch, signal — inconsistent gear change detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving clutch switch, signal: inconsistent gear change detected. The code alone does not establish which part caused it.',
  ),
  '20F226': FaultDefinition(
    title: 'Engine cooling system — temporary engine-speed limit active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temporary engine-speed limit active in engine cooling system. The code alone does not identify a failed component.',
  ),
  '210201': FaultDefinition(
    title: 'Generator, electrical — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator, electrical: operation fault. The code alone does not establish which part caused it.',
  ),
  '210301': FaultDefinition(
    title: 'Generator, plausibility, electrical — calculated',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator, plausibility, electrical: calculated. The code alone does not establish which part caused it.',
  ),
  '210401': FaultDefinition(
    title: 'Generator, temperature — overtemperature',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator, temperature: overtemperature. The code alone does not establish which part caused it.',
  ),
  '210601': FaultDefinition(
    title: 'Generator, mechanical — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator, mechanical: operation fault. The code alone does not establish which part caused it.',
  ),
  '210801': FaultDefinition(
    title: 'Generator — Type Wrong',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator: type wrong. The code alone does not establish which part caused it.',
  ),
  '210C01': FaultDefinition(
    title: 'Generator, communication — bus error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator, communication: bus error. The code alone does not establish which part caused it.',
  ),
  '211F01': FaultDefinition(
    title: 'Generator/Starter Generator — Coding not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator/starter generator: coding not received. The code alone does not establish which part caused it.',
  ),
  '211F03': FaultDefinition(
    title: 'Generator/Starter Generator — Coding or program status incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving generator/starter generator: coding or program status incorrect. The code alone does not establish which part caused it.',
  ),
  '213301': FaultDefinition(
    title: 'Power management — central overvoltage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: central overvoltage. The code alone does not establish which part caused it.',
  ),
  '213401': FaultDefinition(
    title: 'Power management — central undervoltage',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: central undervoltage. The code alone does not establish which part caused it.',
  ),
  '213501': FaultDefinition(
    title: 'Power Management — Battery Deep Discharge',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: battery deep discharge. The code alone does not establish which part caused it.',
  ),
  '213601': FaultDefinition(
    title: 'Power management — quiescent current breach',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: quiescent current breach. The code alone does not establish which part caused it.',
  ),
  '213604': FaultDefinition(
    title: 'Power management — resting current outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded resting current outside expected range in power management. The code alone does not identify a failed component.',
  ),
  '213701': FaultDefinition(
    title: 'Power Management — batteryless operation',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: batteryless operation. The code alone does not establish which part caused it.',
  ),
  '213801': FaultDefinition(
    title:
        'Power Management — Transport monitoring battery state deep discharge',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: transport monitoring battery state deep discharge. The code alone does not establish which part caused it.',
  ),
  '213901': FaultDefinition(
    title: 'Power Management — Consumer Reduction Active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving power management: consumer reduction active. The code alone does not establish which part caused it.',
  ),
  '213A01': FaultDefinition(
    title: 'Powermanagement — transport monitoring battery state discharge',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving powermanagement: transport monitoring battery state discharge. The code alone does not establish which part caused it.',
  ),
  '213A20': FaultDefinition(
    title:
        'Vehicle electrical system voltage, working range — voltage above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle electrical system voltage, working range: voltage above expected range. The code alone does not establish which part caused it.',
  ),
  '213A21': FaultDefinition(
    title:
        'Vehicle electrical system voltage, working range — voltage below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving vehicle electrical system voltage, working range: voltage below expected range. The code alone does not establish which part caused it.',
  ),
  '213A22': FaultDefinition(
    title: 'Vehicle electrical supply — component fault reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded component fault reported in vehicle electrical supply. The code alone does not identify a failed component.',
  ),
  '213B01': FaultDefinition(
    title: 'Battery status detection — defective battery',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving battery status detection: defective battery. The code alone does not establish which part caused it.',
  ),
  '213B08': FaultDefinition(
    title: 'Power management — component fault reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded component fault reported in power management. The code alone does not identify a failed component.',
  ),
  '213C01': FaultDefinition(
    title: 'Battery state detection — battery deep discharge',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving battery state detection: battery deep discharge. The code alone does not establish which part caused it.',
  ),
  '213C08': FaultDefinition(
    title: 'Power management — battery deeply discharged',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded battery deeply discharged in power management. The code alone does not identify a failed component.',
  ),
  '215001': FaultDefinition(
    title:
        'Advanced communication, intelligent battery sensor — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving advanced communication, intelligent battery sensor: operation fault. The code alone does not establish which part caused it.',
  ),
  '21501D': FaultDefinition(
    title: 'Auxiliary battery charging unit — voltage fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded voltage fault in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '215101': FaultDefinition(
    title:
        'Intelligent battery sensor, plausibility — temperature inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intelligent battery sensor, plausibility: temperature inconsistent. The code alone does not establish which part caused it.',
  ),
  '215104': FaultDefinition(
    title: 'Intelligent battery sensor, plausibility — voltage inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intelligent battery sensor, plausibility: voltage inconsistent. The code alone does not establish which part caused it.',
  ),
  '215108': FaultDefinition(
    title:
        'Intelligent battery sensor, plausibility — electricity inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intelligent battery sensor, plausibility: electricity inconsistent. The code alone does not establish which part caused it.',
  ),
  '215701': FaultDefinition(
    title: 'Intelligent battery sensor, self-diagnosis — system error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intelligent battery sensor, self-diagnosis: system error. The code alone does not establish which part caused it.',
  ),
  '215801': FaultDefinition(
    title:
        'Intelligent battery sensor, wake-up line, electrical — short to battery positive or ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intelligent battery sensor, wake-up line, electrical: short to battery positive or ground. The code alone does not establish which part caused it.',
  ),
  '215901': FaultDefinition(
    title: 'Intelligent battery sensor, compatibility — version not plausible',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intelligent battery sensor, compatibility: version not plausible. The code alone does not establish which part caused it.',
  ),
  '215A01': FaultDefinition(
    title:
        'Intelligent battery sensor, wake-up line, electrical — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving intelligent battery sensor, wake-up line, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '215C01': FaultDefinition(
    title: 'Intelligent battery sensor — system fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded system fault in intelligent battery sensor. The code alone does not identify a failed component.',
  ),
  '215F40': FaultDefinition(
    title: 'Intelligent battery sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in intelligent battery sensor. The code alone does not identify a failed component.',
  ),
  '215F41': FaultDefinition(
    title: 'Intelligent battery sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in intelligent battery sensor. The code alone does not identify a failed component.',
  ),
  '215F42': FaultDefinition(
    title: 'Intelligent battery sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in intelligent battery sensor. The code alone does not identify a failed component.',
  ),
  '215F43': FaultDefinition(
    title: 'Intelligent battery sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in intelligent battery sensor. The code alone does not identify a failed component.',
  ),
  '215F44': FaultDefinition(
    title: 'Intelligent battery sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in intelligent battery sensor. The code alone does not identify a failed component.',
  ),
  '215F45': FaultDefinition(
    title: 'Intelligent battery sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in intelligent battery sensor. The code alone does not identify a failed component.',
  ),
  '216002': FaultDefinition(
    title: 'MSA, monitoring — time-out',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving msa, monitoring: time-out. The code alone does not establish which part caused it.',
  ),
  '216104': FaultDefinition(
    title: 'MSA, Monitoring — Start Delay',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving msa, monitoring: start delay. The code alone does not establish which part caused it.',
  ),
  '216110': FaultDefinition(
    title: 'Gear starter — number of MSA reflex starts exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving gear starter: number of msa reflex starts exceeded. The code alone does not establish which part caused it.',
  ),
  '216111': FaultDefinition(
    title: 'Starter unit pinion starter — number of engine starts exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving starter unit pinion starter: number of engine starts exceeded. The code alone does not establish which part caused it.',
  ),
  '218001': FaultDefinition(
    title: 'Battery Charger — Internal Error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving battery charger: internal error. The code alone does not establish which part caused it.',
  ),
  '218101': FaultDefinition(
    title: 'Battery charging unit, line monitoring — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving battery charging unit, line monitoring: operation fault. The code alone does not establish which part caused it.',
  ),
  '218201': FaultDefinition(
    title: 'Battery charging unit, secondary battery — defective',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving battery charging unit, secondary battery: defective. The code alone does not establish which part caused it.',
  ),
  '218202': FaultDefinition(
    title: 'Auxiliary battery charging unit — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218203': FaultDefinition(
    title:
        'Auxiliary battery charging unit — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218204': FaultDefinition(
    title: 'Auxiliary battery charging unit — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218205': FaultDefinition(
    title: 'Auxiliary battery charging unit — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218206': FaultDefinition(
    title: 'Auxiliary battery charging unit — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218207': FaultDefinition(
    title: 'Auxiliary battery charging unit — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218208': FaultDefinition(
    title:
        'Auxiliary battery charging unit — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218209': FaultDefinition(
    title: 'Auxiliary battery charging unit — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '21820A': FaultDefinition(
    title: 'Auxiliary battery charging unit — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '21820B': FaultDefinition(
    title:
        'Auxiliary battery charging unit — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '21820C': FaultDefinition(
    title: 'Auxiliary battery charging unit — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '21820D': FaultDefinition(
    title: 'Auxiliary battery charging unit — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '21820E': FaultDefinition(
    title:
        'Auxiliary battery charging unit — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '21820F': FaultDefinition(
    title: 'Auxiliary battery charging unit — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218210': FaultDefinition(
    title: 'Auxiliary battery charging unit — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218211': FaultDefinition(
    title: 'Auxiliary battery charging unit — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218212': FaultDefinition(
    title: 'Auxiliary battery charging unit — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218214': FaultDefinition(
    title: 'Auxiliary battery charging unit — internal control fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded internal control fault in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218215': FaultDefinition(
    title: 'Auxiliary battery charging unit — voltage fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded voltage fault in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218216': FaultDefinition(
    title:
        'Auxiliary battery charging unit — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218217': FaultDefinition(
    title: 'Auxiliary battery charging unit — component fault reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded component fault reported in auxiliary battery charging unit. The code alone does not identify a failed component.',
  ),
  '218301': FaultDefinition(
    title:
        'Battery charging unit — failure in the separating element/cable tree',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving battery charging unit: failure in the separating element/cable tree. The code alone does not establish which part caused it.',
  ),
  '218401': FaultDefinition(
    title:
        'Starting voltage converter/starter generator, drive — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving starting voltage converter/starter generator, drive: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '218402': FaultDefinition(
    title:
        'Starting voltage converter/starter generator, drive — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving starting voltage converter/starter generator, drive: short to ground. The code alone does not establish which part caused it.',
  ),
  '218404': FaultDefinition(
    title: 'Start voltage converter/starter generator, drive — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving start voltage converter/starter generator, drive: open circuit. The code alone does not establish which part caused it.',
  ),
  '219001': FaultDefinition(
    title: 'Active engine mount, electrical — short to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving active engine mount, electrical: short to battery positive. The code alone does not establish which part caused it.',
  ),
  '219002': FaultDefinition(
    title: 'Active engine mount, electrical — short to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving active engine mount, electrical: short to ground. The code alone does not establish which part caused it.',
  ),
  '219004': FaultDefinition(
    title: 'Active engine mount, electrical — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving active engine mount, electrical: open circuit. The code alone does not establish which part caused it.',
  ),
  '21A001': FaultDefinition(
    title: 'Assembly mode — active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving assembly mode: active. The code alone does not establish which part caused it.',
  ),
  '21A002': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A003': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A004': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A005': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A009': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A00A': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A00F': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A010': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A011': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A012': FaultDefinition(
    title: 'Reduced-power management — transmission fault reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded transmission fault reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A013': FaultDefinition(
    title: 'Reduced-power management — transmission fault reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded transmission fault reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A014': FaultDefinition(
    title: 'Reduced-power management — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A015': FaultDefinition(
    title: 'Reduced-power management — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A016': FaultDefinition(
    title: 'Reduced-power management — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A017': FaultDefinition(
    title: 'Reduced-power management — forced upshift requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded forced upshift requested in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A018': FaultDefinition(
    title: 'Reduced-power management — forced upshift requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded forced upshift requested in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A01C': FaultDefinition(
    title: 'Reduced-power management — forced upshift requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded forced upshift requested in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A01D': FaultDefinition(
    title: 'Reduced-power management — hybrid transmission control fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded hybrid transmission control fault in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A01E': FaultDefinition(
    title: 'Reduced-power management — operation lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation lost in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A01F': FaultDefinition(
    title: 'Reduced-power management — engine not detected after start attempt',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded engine not detected after start attempt in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A020': FaultDefinition(
    title: 'Reduced-power management — operation lost',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation lost in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A021': FaultDefinition(
    title: 'Reduced-power management — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A022': FaultDefinition(
    title: 'Reduced-power management — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A023': FaultDefinition(
    title:
        'Internal combustion engine — false start or engine started without driver influence',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving internal combustion engine: false start or engine started without driver influence. The code alone does not establish which part caused it.',
  ),
  '21A024': FaultDefinition(
    title: 'Reduced-power management — gear selection limited',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded gear selection limited in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A110': FaultDefinition(
    title: 'Engine torque limitation — reduced-power request recorded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power request recorded in engine torque limitation. The code alone does not identify a failed component.',
  ),
  '21A111': FaultDefinition(
    title: 'Engine speed limitation — reduced-power request recorded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power request recorded in engine speed limitation. The code alone does not identify a failed component.',
  ),
  '21A112': FaultDefinition(
    title: 'Engine speed limitation — reduced-power request recorded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power request recorded in engine speed limitation. The code alone does not identify a failed component.',
  ),
  '21A113': FaultDefinition(
    title: 'Engine speed limitation — reduced-power request recorded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power request recorded in engine speed limitation. The code alone does not identify a failed component.',
  ),
  '21A114': FaultDefinition(
    title:
        'Reduced-power management — freewheel or start-system change requested',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded freewheel or start-system change requested in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A117': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A118': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A119': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A11A': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A11B': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A11C': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A11D': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A11F': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A120': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A121': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A122': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A210': FaultDefinition(
    title:
        'Communication — signal (status wavelength FSSP) in FA-CAN, message (services 0x5E0, electrical request consumer ID2: 68): invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving communication: signal (status wavelength fssp) in fa-can, message (services 0x5e0, electrical request consumer id2: 68): invalid. The code alone does not establish which part caused it.',
  ),
  '21A310': FaultDefinition(
    title: 'Emergency operation 1 — multiple related faults for DME coupling',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving emergency operation 1: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A330': FaultDefinition(
    title: 'Emergency operation 2 — multiple related faults for DME coupling',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving emergency operation 2: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A350': FaultDefinition(
    title: 'Emergency operation 3 — multiple related faults for DME coupling',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving emergency operation 3: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A370': FaultDefinition(
    title: 'Emergency operation 4 — multiple related faults for DME coupling',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving emergency operation 4: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A372': FaultDefinition(
    title: 'Emergency running 5 — multiple related faults for DME coupling',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving emergency running 5: multiple related faults for dme coupling. The code alone does not establish which part caused it.',
  ),
  '21A411': FaultDefinition(
    title:
        'Breakdown data memory, measured value — Address measuring channel invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory, measured value: address measuring channel invalid. The code alone does not establish which part caused it.',
  ),
  '21A412': FaultDefinition(
    title:
        'Breakdown data memory — Configured memory requirement exceeds valid range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory: configured memory requirement exceeds valid range. The code alone does not establish which part caused it.',
  ),
  '21A413': FaultDefinition(
    title:
        'Breakdown data memory — Application modified at runtime or CRC collision with footer possible',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory: application modified at runtime or crc collision with footer possible. The code alone does not establish which part caused it.',
  ),
  '21A414': FaultDefinition(
    title: 'Breakdown data memory, measured value — memory area invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory, measured value: memory area invalid. The code alone does not establish which part caused it.',
  ),
  '21A415': FaultDefinition(
    title: 'Breakdown data memory, measured value — memory area exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory, measured value: memory area exceeded. The code alone does not establish which part caused it.',
  ),
  '21A416': FaultDefinition(
    title: 'Breakdown memory — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown memory: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '21A417': FaultDefinition(
    title: 'Breakdown data memory — maximum sector change achieved',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory: maximum sector change achieved. The code alone does not establish which part caused it.',
  ),
  '21A418': FaultDefinition(
    title: 'Breakdown data memory, header — address measuring channel invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory, header: address measuring channel invalid. The code alone does not establish which part caused it.',
  ),
  '21A419': FaultDefinition(
    title: 'Breakdown data memory, header — memory area invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory, header: memory area invalid. The code alone does not establish which part caused it.',
  ),
  '21A41A': FaultDefinition(
    title: 'Breakdown data memory, header — memory area exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving breakdown data memory, header: memory area exceeded. The code alone does not establish which part caused it.',
  ),
  '21A430': FaultDefinition(
    title: 'Long-term quality memory — multiple related faults',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving long-term quality memory: multiple related faults. The code alone does not establish which part caused it.',
  ),
  '21A431': FaultDefinition(
    title: 'Long-term quality memory — maximum sector change achieved',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving long-term quality memory: maximum sector change achieved. The code alone does not establish which part caused it.',
  ),
  '21A432': FaultDefinition(
    title: 'Long-term quality memory, measured value — address invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving long-term quality memory, measured value: address invalid. The code alone does not establish which part caused it.',
  ),
  '21A433': FaultDefinition(
    title:
        'Long-term quality memory — Application modified at runtime or CRC collision with footer possible',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving long-term quality memory: application modified at runtime or crc collision with footer possible. The code alone does not establish which part caused it.',
  ),
  '21A434': FaultDefinition(
    title: 'Long-term quality memory, measured value — memory area exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving long-term quality memory, measured value: memory area exceeded. The code alone does not establish which part caused it.',
  ),
  '21A435': FaultDefinition(
    title:
        'DME — internal error [software, TripRec - Gen.] Trigger, measured value: address measuring channel invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [software, triprec - gen.] trigger, measured value: address measuring channel invalid. The code alone does not establish which part caused it.',
  ),
  '21A436': FaultDefinition(
    title:
        'DME — internal error [software, TripRec - Gen.] Trigger: parameter change at runtime',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving dme: internal error [software, triprec - gen.] trigger: parameter change at runtime. The code alone does not establish which part caused it.',
  ),
  '21A500': FaultDefinition(
    title: 'Reduced-power management — protective power reduction active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded protective power reduction active in reduced-power management. The code alone does not identify a failed component.',
  ),
  '21A501': FaultDefinition(
    title: 'Starting clutch — stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck closed in starting clutch. The code alone does not identify a failed component.',
  ),
  '21A502': FaultDefinition(
    title: 'Transmission oil pump — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in transmission oil pump. The code alone does not identify a failed component.',
  ),
  '21A503': FaultDefinition(
    title: 'Disconnect clutch — stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck closed in disconnect clutch. The code alone does not identify a failed component.',
  ),
  '21A504': FaultDefinition(
    title: 'Disconnect clutch — stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck open in disconnect clutch. The code alone does not identify a failed component.',
  ),
  '21A505': FaultDefinition(
    title: 'Transmission communication — reduced-power mode active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power mode active in transmission communication. The code alone does not identify a failed component.',
  ),
  '21A506': FaultDefinition(
    title: 'Transmission communication — reduced-power mode active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reduced-power mode active in transmission communication. The code alone does not identify a failed component.',
  ),
  '21A507': FaultDefinition(
    title: 'Transmission communication — reset recorded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reset recorded in transmission communication. The code alone does not identify a failed component.',
  ),
  '21A510': FaultDefinition(
    title: 'Starting system — response timeout',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response timeout in starting system. The code alone does not identify a failed component.',
  ),
  '21A514': FaultDefinition(
    title: 'Starting system — response timeout',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response timeout in starting system. The code alone does not identify a failed component.',
  ),
  '21A515': FaultDefinition(
    title: 'Starting system — response timeout',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded response timeout in starting system. The code alone does not identify a failed component.',
  ),
  '21A519': FaultDefinition(
    title: 'Deep-water driving event — deep-water event detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded deep-water event detected in deep-water driving event. The code alone does not identify a failed component.',
  ),
  '21B000': FaultDefinition(
    title: 'Tank pressure and temperature sensor — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B001': FaultDefinition(
    title: 'Tank pressure and temperature sensor — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B002': FaultDefinition(
    title: 'Tank pressure and temperature sensor — control circuit level high',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level high in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B003': FaultDefinition(
    title: 'Tank pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B004': FaultDefinition(
    title:
        'Tank pressure and temperature sensor — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B005': FaultDefinition(
    title:
        'Tank pressure and temperature sensor — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B006': FaultDefinition(
    title: 'Tank pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B007': FaultDefinition(
    title: 'Tank pressure and temperature sensor — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B008': FaultDefinition(
    title: 'Tank pressure and temperature sensor — temperature fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded temperature fault in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B009': FaultDefinition(
    title: 'Tank pressure and temperature sensor — signal stuck at one value',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal stuck at one value in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B00A': FaultDefinition(
    title: 'Tank pressure and temperature sensor — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in tank pressure and temperature sensor. The code alone does not identify a failed component.',
  ),
  '21B00B': FaultDefinition(
    title: 'Tank ventilation — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in tank ventilation. The code alone does not identify a failed component.',
  ),
  '21B00C': FaultDefinition(
    title: 'Tank ventilation — tank-system leak detected',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded tank-system leak detected in tank ventilation. The code alone does not identify a failed component.',
  ),
  '21B00D': FaultDefinition(
    title: 'Tank shutoff valve — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank shutoff valve. The code alone does not identify a failed component.',
  ),
  '21B00E': FaultDefinition(
    title: 'Tank shutoff valve — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank shutoff valve. The code alone does not identify a failed component.',
  ),
  '21B00F': FaultDefinition(
    title: 'Tank shutoff valve — control circuit level high',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level high in tank shutoff valve. The code alone does not identify a failed component.',
  ),
  '21B010': FaultDefinition(
    title: 'Tank shutoff valve — stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck open in tank shutoff valve. The code alone does not identify a failed component.',
  ),
  '21B011': FaultDefinition(
    title: 'Tank shutoff valve — stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck closed in tank shutoff valve. The code alone does not identify a failed component.',
  ),
  '21B012': FaultDefinition(
    title: 'Tank shutoff valve — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank shutoff valve. The code alone does not identify a failed component.',
  ),
  '21B013': FaultDefinition(
    title: 'Tank isolation valve — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank isolation valve. The code alone does not identify a failed component.',
  ),
  '21B014': FaultDefinition(
    title: 'Tank isolation valve — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank isolation valve. The code alone does not identify a failed component.',
  ),
  '21B015': FaultDefinition(
    title: 'Tank isolation valve — control circuit level high',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level high in tank isolation valve. The code alone does not identify a failed component.',
  ),
  '21B016': FaultDefinition(
    title: 'Tank isolation valve — stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck open in tank isolation valve. The code alone does not identify a failed component.',
  ),
  '21B017': FaultDefinition(
    title: 'Tank isolation valve — stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck closed in tank isolation valve. The code alone does not identify a failed component.',
  ),
  '21B018': FaultDefinition(
    title: 'Tank isolation valve — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank isolation valve. The code alone does not identify a failed component.',
  ),
  '21B019': FaultDefinition(
    title: 'Tank flap position sensor — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank flap position sensor. The code alone does not identify a failed component.',
  ),
  '21B01A': FaultDefinition(
    title: 'Tank flap position sensor — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank flap position sensor. The code alone does not identify a failed component.',
  ),
  '21B01B': FaultDefinition(
    title: 'Tank flap position sensor — control circuit level high',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level high in tank flap position sensor. The code alone does not identify a failed component.',
  ),
  '21B01C': FaultDefinition(
    title: 'Tank flap — stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck open in tank flap. The code alone does not identify a failed component.',
  ),
  '21B01D': FaultDefinition(
    title: 'Tank flap — stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck closed in tank flap. The code alone does not identify a failed component.',
  ),
  '21B01E': FaultDefinition(
    title: 'Tank flap position sensor — control circuit level high',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level high in tank flap position sensor. The code alone does not identify a failed component.',
  ),
  '21B01F': FaultDefinition(
    title: 'Tank flap opening switch — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank flap opening switch. The code alone does not identify a failed component.',
  ),
  '21B020': FaultDefinition(
    title: 'Tank flap opening switch — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank flap opening switch. The code alone does not identify a failed component.',
  ),
  '21B021': FaultDefinition(
    title: 'Tank flap opening switch — control circuit level high',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level high in tank flap opening switch. The code alone does not identify a failed component.',
  ),
  '21B022': FaultDefinition(
    title: 'Tank flap opening switch — stuck open',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck open in tank flap opening switch. The code alone does not identify a failed component.',
  ),
  '21B023': FaultDefinition(
    title: 'Tank flap opening switch — stuck closed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded stuck closed in tank flap opening switch. The code alone does not identify a failed component.',
  ),
  '21B024': FaultDefinition(
    title: 'Tank flap lock — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in tank flap lock. The code alone does not identify a failed component.',
  ),
  '21B025': FaultDefinition(
    title: 'Tank flap lock — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank flap lock. The code alone does not identify a failed component.',
  ),
  '21B026': FaultDefinition(
    title: 'Tank flap lock — control circuit level high',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level high in tank flap lock. The code alone does not identify a failed component.',
  ),
  '21B029': FaultDefinition(
    title: 'Tank flap lock — control circuit level low',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control circuit level low in tank flap lock. The code alone does not identify a failed component.',
  ),
  '21B02A': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B02B': FaultDefinition(
    title: 'Active air flap control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B02C': FaultDefinition(
    title: 'Active air flap control — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B02D': FaultDefinition(
    title: 'Active air flap control — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B02E': FaultDefinition(
    title: 'Active air flap control — outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded outside expected range in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B02F': FaultDefinition(
    title: 'Active air flap control — backup function active',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded backup function active in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B030': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B031': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B032': FaultDefinition(
    title: 'Active air flap control — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B033': FaultDefinition(
    title: 'Active air flap control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B034': FaultDefinition(
    title: 'Active air flap control — outside expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded outside expected range in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B035': FaultDefinition(
    title: 'Active air flap control — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B036': FaultDefinition(
    title: 'Active air flap control — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B038': FaultDefinition(
    title: 'Active air flap control — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B03A': FaultDefinition(
    title: 'Active air flap control — warning threshold exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded warning threshold exceeded in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B03B': FaultDefinition(
    title: 'Active air flap control — inconsistent signal',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded inconsistent signal in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B03C': FaultDefinition(
    title: 'Active air flap control — reading above expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading above expected range in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B03D': FaultDefinition(
    title: 'Active air flap control — operation fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation fault in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B03E': FaultDefinition(
    title: 'Active air flap control — open circuit',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded open circuit in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B03F': FaultDefinition(
    title: 'Active air flap control — circuit shorted to battery positive',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to battery positive in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B040': FaultDefinition(
    title: 'Active air flap control — circuit shorted to ground',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded circuit shorted to ground in active air flap control. The code alone does not identify a failed component.',
  ),
  '21B041': FaultDefinition(
    title: 'Active air flap control — reading below expected range',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded reading below expected range in active air flap control. The code alone does not identify a failed component.',
  ),
  '230008': FaultDefinition(
    title: 'Communication sleep coordinator — message inconsistent',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving communication sleep coordinator: message inconsistent. The code alone does not establish which part caused it.',
  ),
  '231501': FaultDefinition(
    title: 'Error memory entry — transmit buffer full',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving error memory entry: transmit buffer full. The code alone does not establish which part caused it.',
  ),
  '231502': FaultDefinition(
    title: 'Error memory entry — Send failed',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving error memory entry: send failed. The code alone does not establish which part caused it.',
  ),
  '231F04': FaultDefinition(
    title: 'A- / FA-CAN, messages (transmission) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a- / fa-can, messages (transmission): not received. The code alone does not establish which part caused it.',
  ),
  '233004': FaultDefinition(
    title:
        'FA-CAN, message (OBD sensor diagnostic status, 0x5E0) — not received, transmitter combination',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (obd sensor diagnostic status, 0x5e0): not received, transmitter combination. The code alone does not establish which part caused it.',
  ),
  '234A05': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  '235410': FaultDefinition(
    title: 'Reduced-power management — control request reported',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded control request reported in reduced-power management. The code alone does not identify a failed component.',
  ),
  'CD840A': FaultDefinition(
    title: 'DME report: fA-CAN Control Module Bus OFF',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged this condition: fa-can control module bus off. Review the operating context and related faults before drawing a diagnosis.',
  ),
  'CD841F': FaultDefinition(
    title: 'FlexRay Bus — Line error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray bus: line error. The code alone does not establish which part caused it.',
  ),
  'CD8420': FaultDefinition(
    title: 'FlexRay Bus — communication error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray bus: communication error. The code alone does not establish which part caused it.',
  ),
  'CD8430': FaultDefinition(
    title: 'FlexRay communication — communication fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded communication fault in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD8486': FaultDefinition(
    title: 'DME report: a-CAN Control Module Bus OFF',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged this condition: a-can control module bus off. Review the operating context and related faults before drawing a diagnosis.',
  ),
  'CD8801': FaultDefinition(
    title: 'FlexRay Controller, Startup — maximum startup time exceeded',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray controller, startup: maximum startup time exceeded. The code alone does not establish which part caused it.',
  ),
  'CD8802': FaultDefinition(
    title: 'FlexRay communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD8803': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD8B02': FaultDefinition(
    title:
        'FlexRay, message (diagnosis OBD 1, 263.3.4) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (diagnosis obd 1, 263.3.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CD8B04': FaultDefinition(
    title: 'FlexRay, message (diagnosis OBD 1, 263.3.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (diagnosis obd 1, 263.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD8B05': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD8BFF': FaultDefinition(
    title: 'Network error — only for testing',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving network error: only for testing. The code alone does not establish which part caused it.',
  ),
  'CD8E10': FaultDefinition(
    title: 'LIN Bus — communication error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lin bus: communication error. The code alone does not establish which part caused it.',
  ),
  'CD8E11': FaultDefinition(
    title:
        'LIN, communication (charge unit for auxiliary battery) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lin, communication (charge unit for auxiliary battery): not received. The code alone does not establish which part caused it.',
  ),
  'CD8E12': FaultDefinition(
    title: 'LIN, communication (generator) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lin, communication (generator): not received. The code alone does not establish which part caused it.',
  ),
  'CD8F01': FaultDefinition(
    title: 'LIN, communication (intelligent battery sensor) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving lin, communication (intelligent battery sensor): not received. The code alone does not establish which part caused it.',
  ),
  'CD8F04': FaultDefinition(
    title: 'Communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in communication. The code alone does not identify a failed component.',
  ),
  'CD9010': FaultDefinition(
    title: 'Communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in communication. The code alone does not identify a failed component.',
  ),
  'CD9203': FaultDefinition(
    title: 'Radiator air shutter — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in radiator air shutter. The code alone does not identify a failed component.',
  ),
  'CD9402': FaultDefinition(
    title: 'FlexRay communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9404': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9408': FaultDefinition(
    title: 'FlexRay communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9432': FaultDefinition(
    title:
        'A-CAN, message (status transmission control unit, 0x39A) at low voltage — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (status transmission control unit, 0x39a) at low voltage: not received. The code alone does not establish which part caused it.',
  ),
  'CD9435': FaultDefinition(
    title:
        'A-CAN, message (transmission train data, 0x1AF) at low voltage — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (transmission train data, 0x1af) at low voltage: not received. The code alone does not establish which part caused it.',
  ),
  'CD9437': FaultDefinition(
    title:
        'FlexRay, Message (request wheel torque drivetrain sum stabilization / nominal distribution longitudinal torque front axle rear axle, 43.1.4) under voltage — communication error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / nominal distribution longitudinal torque front axle rear axle, 43.1.4) under voltage: communication error. The code alone does not establish which part caused it.',
  ),
  'CD944D': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.0.1) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is speed wheel, 46.0.1): signal error. The code alone does not establish which part caused it.',
  ),
  'CD9462': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9463': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9464': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9465': FaultDefinition(
    title: 'FlexRay communication — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9502': FaultDefinition(
    title:
        'FlexRay, Message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9504': FaultDefinition(
    title:
        'FlexRay, Message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD9508': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum stabilization / target distribution longitudinal torque front axle rear axle, 43.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9602': FaultDefinition(
    title:
        'FlexRay, message (request wheel torque powertrain sum recuperation, 47.0.2) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque powertrain sum recuperation, 47.0.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9604': FaultDefinition(
    title:
        'FlexRay, message (request wheel torque drivetrain sum recuperation, 47.0.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum recuperation, 47.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9608': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque powertrain sum recuperation, 47.0.2) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque powertrain sum recuperation, 47.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9610': FaultDefinition(
    title: 'Drivetrain — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in drivetrain. The code alone does not identify a failed component.',
  ),
  'CD9702': FaultDefinition(
    title:
        'FlexRay, message (configuration switch driving dynamics, 272.4.8) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (configuration switch driving dynamics, 272.4.8): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9704': FaultDefinition(
    title:
        'FlexRay, message (configuration switch driving dynamics, 272.4.8) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (configuration switch driving dynamics, 272.4.8): not received. The code alone does not establish which part caused it.',
  ),
  'CD9708': FaultDefinition(
    title:
        'FlexRay, Message (Drive Dynamics Switch configuration, 272.4.8) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (drive dynamics switch configuration, 272.4.8): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9710': FaultDefinition(
    title:
        'FlexRay, message (configuration switch driving dynamics 2, 272.4.8) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (configuration switch driving dynamics 2, 272.4.8): not received. The code alone does not establish which part caused it.',
  ),
  'CD9711': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9730': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9902': FaultDefinition(
    title: 'FlexRay, message (vehicle speed, 55.3.4) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CD9904': FaultDefinition(
    title: 'FlexRay, message (vehicle speed, 55.3.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD9908': FaultDefinition(
    title: 'FlexRay, Message (vehicle speed, 55.3.4) — checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CD9932': FaultDefinition(
    title:
        'FlexRay, message (yaw velocity vehicle, 56.0.2) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (yaw velocity vehicle, 56.0.2): message counter error. The code alone does not establish which part caused it.',
  ),
  'CD9933': FaultDefinition(
    title: 'FlexRay, message (yaw velocity vehicle, 56.0.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (yaw velocity vehicle, 56.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9934': FaultDefinition(
    title:
        'FlexRay, message (yaw velocity vehicle, 56.0.2) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (yaw velocity vehicle, 56.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9A02': FaultDefinition(
    title: 'FlexRay, Message (Is braking torque sum, 43.3.4) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is braking torque sum, 43.3.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9A04': FaultDefinition(
    title:
        'FlexRay, message (actual braking torque sum, 43.3.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (actual braking torque sum, 43.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CD9A08': FaultDefinition(
    title:
        'FlexRay, Message (is braking torque sum, 43.3.4) — checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is braking torque sum, 43.3.4): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CD9A10': FaultDefinition(
    title:
        'FlexRay, message (status contact hand brake, 243.1.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (status contact hand brake, 243.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9B02': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.1.2) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is speed wheel, 46.1.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9B04': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.1.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is speed wheel, 46.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9B08': FaultDefinition(
    title: 'FlexRay, Message (is speed wheel, 46.1.2) — checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is speed wheel, 46.1.2): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CD9C12': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CD9D02': FaultDefinition(
    title:
        'FlexRay, message (longitudinal acceleration center of gravity, 55.0.2) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (longitudinal acceleration center of gravity, 55.0.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9D04': FaultDefinition(
    title:
        'FlexRay, message (longitudinal acceleration center of gravity, 55.0.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (longitudinal acceleration center of gravity, 55.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9D08': FaultDefinition(
    title:
        'FlexRay, message (longitudinal acceleration center of gravity, 55.0.2) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (longitudinal acceleration center of gravity, 55.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9E02': FaultDefinition(
    title:
        'FlexRay, message (center of gravity transverse acceleration, 55.0.2) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (center of gravity transverse acceleration, 55.0.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9E04': FaultDefinition(
    title:
        'FlexRay, message (center of gravity transverse acceleration, 55.0.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (center of gravity transverse acceleration, 55.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9E08': FaultDefinition(
    title:
        'FlexRay, message (center of gravity transverse acceleration, 55.0.2) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (center of gravity transverse acceleration, 55.0.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9F02': FaultDefinition(
    title: 'FlexRay, message (stabilization status DSC, 47.1.2) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): alive check. The code alone does not establish which part caused it.',
  ),
  'CD9F04': FaultDefinition(
    title: 'FlexRay, message (stabilization status DSC, 47.1.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CD9F08': FaultDefinition(
    title:
        'FlexRay, message (stabilization status DSC, 47.1.2) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CD9F10': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CD9F11': FaultDefinition(
    title: 'FlexRay, message (stabilization status DSC, 47.1.2) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (stabilization status dsc, 47.1.2): signal error. The code alone does not establish which part caused it.',
  ),
  'CD9F12': FaultDefinition(
    title:
        'FlexRay, message (configuration of the vehicle dynamics switch, 272.4.8) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (configuration of the vehicle dynamics switch, 272.4.8): signal error. The code alone does not establish which part caused it.',
  ),
  'CD9F13': FaultDefinition(
    title: 'FlexRay, message (vehicle speed, 55.3.4) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (vehicle speed, 55.3.4): signal error. The code alone does not establish which part caused it.',
  ),
  'CDA002': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque drivetrain sum FAS, 33.1.4) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum fas, 33.1.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA004': FaultDefinition(
    title:
        'FlexRay, message (request wheel torque drivetrain sum FAS, 33.1.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum fas, 33.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA008': FaultDefinition(
    title:
        'FlexRay, Message (Request wheel torque drivetrain sum FAS, 33.1.4) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request wheel torque drivetrain sum fas, 33.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA102': FaultDefinition(
    title: 'FlexRay, Message (inclination roadway, 56.1.2) — Alivetest',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (inclination roadway, 56.1.2): alivetest. The code alone does not establish which part caused it.',
  ),
  'CDA104': FaultDefinition(
    title: 'FlexRay, message (inclination roadway, 56.1.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (inclination roadway, 56.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA108': FaultDefinition(
    title: 'FlexRay, Message (inclination roadway, 56.1.2) — checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (inclination roadway, 56.1.2): checksum mismatch. The code alone does not establish which part caused it.',
  ),
  'CDA204': FaultDefinition(
    title:
        'FlexRay, Message (Request Power Electric EPS, 234.0.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (request power electric eps, 234.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA302': FaultDefinition(
    title:
        'FlexRay, message (status vehicle standstill, 263.1.4) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (status vehicle standstill, 263.1.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDA304': FaultDefinition(
    title:
        'FlexRay, message (status vehicle standstill, 263.1.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (status vehicle standstill, 263.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA308': FaultDefinition(
    title:
        'FlexRay, message (status vehicle standstill, 263.1.4) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (status vehicle standstill, 263.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA310': FaultDefinition(
    title: 'FlexRay communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA311': FaultDefinition(
    title: 'FlexRay communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA312': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA313': FaultDefinition(
    title: 'FlexRay communication — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA321': FaultDefinition(
    title: 'FlexRay, Message (units BN2020, 252.0.4 ) — Signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (units bn2020, 252.0.4 ): signal error. The code alone does not establish which part caused it.',
  ),
  'CDA322': FaultDefinition(
    title: 'FlexRay, message (units BN2020, 252.0.4 ) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (units bn2020, 252.0.4 ): not received. The code alone does not establish which part caused it.',
  ),
  'CDA402': FaultDefinition(
    title:
        'FlexRay, Message (actual steering angle front axle, 57.1.2) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (actual steering angle front axle, 57.1.2): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDA404': FaultDefinition(
    title:
        'FlexRay, message (actual steering angle front axle, 57.1.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (actual steering angle front axle, 57.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA408': FaultDefinition(
    title:
        'FlexRay, Message (actual steering angle front axle, 57.1.2) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (actual steering angle front axle, 57.1.2): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA421': FaultDefinition(
    title:
        'FlexRay, message (Secured door sensor status, 256.3.4) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (secured door sensor status, 256.3.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA422': FaultDefinition(
    title:
        'FlexRay, message (Secured door sensor status, 256.3.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (secured door sensor status, 256.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA423': FaultDefinition(
    title:
        'FlexRay, Message (Secured door sensor status, 256.3.4) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (secured door sensor status, 256.3.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA426': FaultDefinition(
    title:
        'FlexRay, message (status distribution longitudinal torque front axle rear axle, 19.3.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (status distribution longitudinal torque front axle rear axle, 19.3.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA428': FaultDefinition(
    title:
        'FlexRay, message (status distribution longitudinal torque front axle rear axle, 19.3.4) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (status distribution longitudinal torque front axle rear axle, 19.3.4): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA429': FaultDefinition(
    title:
        'FlexRay, message (status distribution longitudinal torque front axle rear axle, 19.3.4) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (status distribution longitudinal torque front axle rear axle, 19.3.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA432': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA435': FaultDefinition(
    title: 'FlexRay, Message (mass/weight vehicle, 108.1.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (mass/weight vehicle, 108.1.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA437': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA451': FaultDefinition(
    title:
        'FlexRay, message (actual steering torque driver actuator, 49.0.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (actual steering torque driver actuator, 49.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA452': FaultDefinition(
    title: 'FlexRay, Message (Is power rack, 49.0.2) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is power rack, 49.0.2): not received. The code alone does not establish which part caused it.',
  ),
  'CDA491': FaultDefinition(
    title:
        'FlexRay, Message (target distribution longitudinal torque front axle rear axle, 43.1.4) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (target distribution longitudinal torque front axle rear axle, 43.1.4): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDA492': FaultDefinition(
    title:
        'FlexRay, Message (target distribution longitudinal torque front axle rear axle, 43.1.4) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (target distribution longitudinal torque front axle rear axle, 43.1.4): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA493': FaultDefinition(
    title:
        'FlexRay, message (target distribution longitudinal torque front axle rear axle, 43.1.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (target distribution longitudinal torque front axle rear axle, 43.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA494': FaultDefinition(
    title:
        'FlexRay, message (target braking torque sum coordinated, 63.1.4) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (target braking torque sum coordinated, 63.1.4): not received. The code alone does not establish which part caused it.',
  ),
  'CDA498': FaultDefinition(
    title: 'FlexRay communication — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA509': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA512': FaultDefinition(
    title:
        'FA-CAN, message (status belt contact seat occupancy, 0x297) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (status belt contact seat occupancy, 0x297): alive check. The code alone does not establish which part caused it.',
  ),
  'CDA514': FaultDefinition(
    title:
        'FA-CAN, message (status belt contact seat occupancy, 0x297) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (status belt contact seat occupancy, 0x297): not received. The code alone does not establish which part caused it.',
  ),
  'CDA515': FaultDefinition(
    title: 'A-CAN communication — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA516': FaultDefinition(
    title: 'A-CAN communication — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA518': FaultDefinition(
    title:
        'FA-CAN, message (status belt contact seat occupancy, 0x297) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (status belt contact seat occupancy, 0x297): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDA520': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA521': FaultDefinition(
    title: 'FlexRay communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in FlexRay communication. The code alone does not identify a failed component.',
  ),
  'CDA524': FaultDefinition(
    title: 'FA-CAN, message (Electric fuel pump status, 0x335) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (electric fuel pump status, 0x335): not received. The code alone does not establish which part caused it.',
  ),
  'CDA525': FaultDefinition(
    title: 'FA-CAN, message (status Electric fuel pump, 0x335) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (status electric fuel pump, 0x335): signal error. The code alone does not establish which part caused it.',
  ),
  'CDA56F': FaultDefinition(
    title: 'A-CAN communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA643': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA644': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA665': FaultDefinition(
    title: 'A-CAN communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA666': FaultDefinition(
    title: 'A-CAN communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA667': FaultDefinition(
    title: 'A-CAN communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA668': FaultDefinition(
    title: 'A-CAN communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA669': FaultDefinition(
    title: 'A-CAN communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA66D': FaultDefinition(
    title: 'Drivetrain — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDA66F': FaultDefinition(
    title: 'A-CAN communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA670': FaultDefinition(
    title: 'A-CAN communication — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA672': FaultDefinition(
    title: 'Communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in communication. The code alone does not identify a failed component.',
  ),
  'CDA677': FaultDefinition(
    title: 'A-CAN communication — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA679': FaultDefinition(
    title: 'Communication — operation did not complete',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded operation did not complete in communication. The code alone does not identify a failed component.',
  ),
  'CDA67B': FaultDefinition(
    title: 'A-CAN communication — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA67C': FaultDefinition(
    title: 'Drivetrain — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDA67F': FaultDefinition(
    title:
        'Communication — signal (status wavelength FSSP) in FA-CAN, message (services 0x5E0, electrical request consumer ID2: 68): invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving communication: signal (status wavelength fssp) in fa-can, message (services 0x5e0, electrical request consumer id2: 68): invalid. The code alone does not establish which part caused it.',
  ),
  'CDA682': FaultDefinition(
    title: 'Drivetrain — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDA702': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA704': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA708': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDA804': FaultDefinition(
    title: 'FA-CAN, message (relative time, 0x328) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (relative time, 0x328): not received. The code alone does not establish which part caused it.',
  ),
  'CDA904': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDAB04': FaultDefinition(
    title: 'FA-CAN, message (Reverse status, 0x3B0) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (reverse status, 0x3b0): not received. The code alone does not establish which part caused it.',
  ),
  'CDAC04': FaultDefinition(
    title:
        'FA-CAN, message (status transmission control unit, 0x39A) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (status transmission control unit, 0x39a): not received. The code alone does not establish which part caused it.',
  ),
  'CDAD04': FaultDefinition(
    title:
        'FA-CAN, Message (control of crash shutdown electric fuel pump, 0x135) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (control of crash shutdown electric fuel pump, 0x135): not received. The code alone does not establish which part caused it.',
  ),
  'CDAE04': FaultDefinition(
    title: 'FA-CAN, message (time/date, 0x2F8) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (time/date, 0x2f8): not received. The code alone does not establish which part caused it.',
  ),
  'CDAF04': FaultDefinition(
    title: 'FA-CAN, message (ZV and flap state, 0x2FC) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (zv and flap state, 0x2fc): not received. The code alone does not establish which part caused it.',
  ),
  'CDB204': FaultDefinition(
    title: 'FA-CAN, message (external temperature, 0x2CA) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (external temperature, 0x2ca): not received. The code alone does not establish which part caused it.',
  ),
  'CDB302': FaultDefinition(
    title: 'FA-CAN, message (data display gear train, 0x3FD) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): alive check. The code alone does not establish which part caused it.',
  ),
  'CDB304': FaultDefinition(
    title: 'FA-CAN, message (data display gear train, 0x3FD) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): not received. The code alone does not establish which part caused it.',
  ),
  'CDB308': FaultDefinition(
    title:
        'FA-CAN, Message (data display gear train, 0x3FD) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDB404': FaultDefinition(
    title: 'FA-CAN, message (vehicle condition, 0x3A0) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (vehicle condition, 0x3a0): not received. The code alone does not establish which part caused it.',
  ),
  'CDB504': FaultDefinition(
    title: 'FA-CAN, message (km/range, 0x330) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (km/range, 0x330): not received. The code alone does not establish which part caused it.',
  ),
  'CDB602': FaultDefinition(
    title: 'FA-CAN, Message (terminal, 0x12F) — Alivecheck',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (terminal, 0x12f): alivecheck. The code alone does not establish which part caused it.',
  ),
  'CDB604': FaultDefinition(
    title: 'FA-CAN, message (terminal, 0x12F) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (terminal, 0x12f): not received. The code alone does not establish which part caused it.',
  ),
  'CDB608': FaultDefinition(
    title: 'FA-CAN, Message (terminal, 0x12F) — Checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (terminal, 0x12f): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDB804': FaultDefinition(
    title:
        'FA-CAN, embassy (conditioning system request, 0x2F9) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, embassy (conditioning system request, 0x2f9): not received. The code alone does not establish which part caused it.',
  ),
  'CDB904': FaultDefinition(
    title: 'FA-CAN, message (diagnosis OBD transmission, 0x396) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (diagnosis obd transmission, 0x396): not received. The code alone does not establish which part caused it.',
  ),
  'CDBA04': FaultDefinition(
    title: 'FA-CAN, Embassy (Global FZM, 0x3A5) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, embassy (global fzm, 0x3a5): not received. The code alone does not establish which part caused it.',
  ),
  'CDBA09': FaultDefinition(
    title: 'A-CAN communication — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA10': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA11': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA12': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA13': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA14': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA15': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA17': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA25': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBA27': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBB02': FaultDefinition(
    title:
        'A-CAN, Message (Request torque crankshaft gearbox 2, 0xA0) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDBB04': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox 2, 0xA0) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): not received. The code alone does not establish which part caused it.',
  ),
  'CDBB08': FaultDefinition(
    title:
        'A-CAN, Message (request torque crankshaft gearbox 2, 0xA0) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDBB09': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox 2, 0xA0) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (request torque crankshaft gearbox 2, 0xa0): signal error. The code alone does not establish which part caused it.',
  ),
  'CDBB10': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBB11': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBB12': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBB13': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBB14': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBB15': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBB23': FaultDefinition(
    title: 'Communication — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in communication. The code alone does not identify a failed component.',
  ),
  'CDBB24': FaultDefinition(
    title:
        'Communication — signal (speed transmission train output) in A-CAN, message (transmission train data, 0x1AF): invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving communication: signal (speed transmission train output) in a-can, message (transmission train data, 0x1af): invalid. The code alone does not establish which part caused it.',
  ),
  'CDBB25': FaultDefinition(
    title: 'Communication — invalid data',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded invalid data in communication. The code alone does not identify a failed component.',
  ),
  'CDBB26': FaultDefinition(
    title:
        'Communication — signal (status shift active transmission) in A- / FA-CAN, message (status transmission control, 0x39A): invalid',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving communication: signal (status shift active transmission) in a- / fa-can, message (status transmission control, 0x39a): invalid. The code alone does not establish which part caused it.',
  ),
  'CDBC10': FaultDefinition(
    title: 'Drivetrain — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDBC11': FaultDefinition(
    title: 'Drivetrain — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDBC20': FaultDefinition(
    title: 'Drivetrain — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDBC21': FaultDefinition(
    title: 'Drivetrain — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDBC22': FaultDefinition(
    title: 'Drivetrain — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDBC23': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBC24': FaultDefinition(
    title: 'Drivetrain — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in drivetrain. The code alone does not identify a failed component.',
  ),
  'CDBD09': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBD0A': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBE02': FaultDefinition(
    title:
        'A-CAN, message (indicating speed motor dynamics, 0xF8) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (indicating speed motor dynamics, 0xf8): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDBE04': FaultDefinition(
    title:
        'A-CAN, message (indication speed motor dynamics, 0xF8) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (indication speed motor dynamics, 0xf8): not received. The code alone does not establish which part caused it.',
  ),
  'CDBE20': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBE21': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBE22': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBE23': FaultDefinition(
    title: 'A-CAN communication — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDBF04': FaultDefinition(
    title:
        'A-CAN, message (status transmission control unit, 0x39A) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (status transmission control unit, 0x39a): not received. The code alone does not establish which part caused it.',
  ),
  'CDC004': FaultDefinition(
    title: 'A-CAN, message (diagnosis OBD transmission, 0x396) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (diagnosis obd transmission, 0x396): not received. The code alone does not establish which part caused it.',
  ),
  'CDC102': FaultDefinition(
    title: 'A-CAN, message (transmission train data, 0x1AF) — Alive check',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (transmission train data, 0x1af): alive check. The code alone does not establish which part caused it.',
  ),
  'CDC104': FaultDefinition(
    title: 'A-CAN, message (transmission train data, 0x1AF) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (transmission train data, 0x1af): not received. The code alone does not establish which part caused it.',
  ),
  'CDC108': FaultDefinition(
    title:
        'A-CAN, message (transmission train data, 0x1AF) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (transmission train data, 0x1af): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDC109': FaultDefinition(
    title: 'A-CAN, message (transmission train data, 0x1AF) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (transmission train data, 0x1af): signal error. The code alone does not establish which part caused it.',
  ),
  'CDC120': FaultDefinition(
    title: 'A-CAN communication — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message counter error in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDC121': FaultDefinition(
    title: 'A-CAN communication — message checksum mismatch',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded message checksum mismatch in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDC122': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDC123': FaultDefinition(
    title: 'A-CAN communication — signal fault',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded signal fault in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDC202': FaultDefinition(
    title:
        'A-CAN, Message (crankshaft torque request, 0xB0) — message counter error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (crankshaft torque request, 0xb0): message counter error. The code alone does not establish which part caused it.',
  ),
  'CDC203': FaultDefinition(
    title: 'A-CAN communication — expected input not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME recorded expected input not received in A-CAN communication. The code alone does not identify a failed component.',
  ),
  'CDC204': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox, 0xB0) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (request torque crankshaft gearbox, 0xb0): not received. The code alone does not establish which part caused it.',
  ),
  'CDC208': FaultDefinition(
    title:
        'A-CAN, Message (request torque crankshaft transmission, 0xB0) — checksum incorrect',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (request torque crankshaft transmission, 0xb0): checksum incorrect. The code alone does not establish which part caused it.',
  ),
  'CDC209': FaultDefinition(
    title:
        'A-CAN, message (request torque crankshaft gearbox, 0xB0) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (request torque crankshaft gearbox, 0xb0): signal error. The code alone does not establish which part caused it.',
  ),
  'CDC304': FaultDefinition(
    title: 'A-CAN, message (Electric fuel pump status, 0x335) — not received',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (electric fuel pump status, 0x335): not received. The code alone does not establish which part caused it.',
  ),
  'CDC310': FaultDefinition(
    title: 'A-CAN, message (Electric fuel pump status, 0x335) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving a-can, message (electric fuel pump status, 0x335): signal error. The code alone does not establish which part caused it.',
  ),
  'CDDB09': FaultDefinition(
    title: 'FlexRay, message (is speed wheel, 46.0.1) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving flexray, message (is speed wheel, 46.0.1): signal error. The code alone does not establish which part caused it.',
  ),
  'CDF209': FaultDefinition(
    title: 'FA-CAN, Message (data display gear train, 0x3FD) — signal error',
    system: 'N20 DME reference',
    explanation:
        'The N20 DME logged a condition involving fa-can, message (data display gear train, 0x3fd): signal error. The code alone does not establish which part caused it.',
  ),
};
