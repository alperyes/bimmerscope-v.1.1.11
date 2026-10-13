"""Generate cautious DME fault summaries from the local S55/N20 reference workbook.

Usage: python tool/generate_dme_fault_catalog.py WORKBOOK N20_B1V
The generated Dart is source data; hand-written definitions take precedence.
"""

import re
import sys
from pathlib import Path

from openpyxl import load_workbook


def dart(value: str) -> str:
    return "'" + value.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$').replace('\n', ' ') + "'"


def english_issue(value: str) -> str:
    text = value.strip().rstrip('.')
    replacements = [
        (r'short circuit to plus', 'short to battery positive'),
        (r'short circuit to ground', 'short to ground'),
        (r'short circuit after plus', 'short to battery positive'),
        (r'signal fixed to fat', 'oxygen signal fixed rich'),
        (r'\bfat\b', 'rich'),
        (r'collection error', 'multiple related faults'),
        (r'\belectric\b', 'electrical'),
        (r'line interruption', 'open circuit'),
        (r'open circuit', 'open circuit'),
        (r'checksum wrong', 'checksum mismatch'),
        (r'alive test', 'message counter error'),
        (r'period duration too large', 'signal period above range'),
        (r'period duration too small', 'signal period below range'),
        (r'too high', 'above expected range'),
        (r'too low', 'below expected range'),
        (r'missing', 'not received'),
        (r'implausible', 'inconsistent'),
        (r'malfunction', 'operation fault'),
        (r'not reached', 'target not reached'),
    ]
    for old, new in replacements:
        text = re.sub(old, new, text, flags=re.I)
    return re.sub(r'\s+', ' ', text).strip(' ,:;')


SUBJECTS = [
    ('Aktive Kühlluftklappensteuerung', 'active air flap control'),
    ('Kühlerjalousie', 'radiator air shutter'),
    ('Automatische Kühlluftklappensteuerung', 'active air flap control'),
    ('Abgasklappe', 'exhaust flap control'),
    ('Notlaufmanager', 'reduced-power management'),
    ('Batterieladeeinheit für Zustart', 'auxiliary battery charging unit'),
    ('Motor-Kühlsystem', 'engine cooling system'),
    ('Motordrehzahlbegrenzung', 'engine speed limitation'),
    ('Motordrehmomentbegrenzung', 'engine torque limitation'),
    ('Getriebeöltemperatur', 'transmission oil temperature'),
    ('Trennkupplung', 'disconnect clutch'),
    ('Integrierte elektrische Getriebeölpumpe', 'transmission oil pump'),
    ('Integrierte Anfahrkupplung', 'starting clutch'),
    ('DOBD-TFM-Kraftstofftank Drucksensor', 'tank pressure and temperature sensor'),
    ('DOBD-TFM-Tankklappe Verriegelung', 'tank flap lock'),
    ('DOBD-TFM-Tankklappe Positionssensor', 'tank flap position sensor'),
    ('DOBD-TFM-Tankklappe Öffnungsanforderung', 'tank flap opening switch'),
    ('DOBD-TFM-Tankklappe', 'tank flap'),
    ('DOBD-TFM-Tankabsperrventil', 'tank shutoff valve'),
    ('DOBD-TFM-Atmosphären Isolationsventil', 'tank isolation valve'),
    ('Motoröl-Druck-Temperatursensor', 'engine oil pressure and temperature sensor'),
    ('Ölzustandssensor', 'oil condition sensor'),
    ('Ölzustand', 'oil condition monitoring'),
    ('Intelligenter Batteriesensor', 'intelligent battery sensor'),
    ('Zylinderindividuelle Gemischüberwachung', 'cylinder mixture monitoring'),
    ('Zylinderausblendung', 'cylinder deactivation'),
    ('Nullgangsensor', 'neutral gear sensor'),
    ('Durchfahrt tiefen Wassers', 'deep-water driving event'),
    ('Lambdasonde nach Katalysator', 'downstream oxygen sensor'),
    ('Temperatursensor Kühleraustritt', 'radiator outlet temperature sensor'),
    ('Raildrucksensor', 'fuel rail pressure sensor'),
    ('Luftmassenmesser', 'air mass meter'),
    ('Fahrpedalmodul', 'accelerator pedal module'),
    ('Umgebungsdruck', 'ambient pressure'),
    ('Injektor Zylinder', 'cylinder injector'),
    ('Ethanolsensor', 'ethanol sensor'),
    ('Elektrisches Wastegate', 'electric wastegate'),
    ('Wastegate', 'wastegate'),
    ('Ladedruck', 'boost pressure'),
    ('DMTL', 'tank leak diagnosis'),
    ('Tankleckagemodul', 'tank leak diagnosis module'),
    ('Bremsunterdrucksensor', 'brake vacuum sensor'),
    ('Tankentlüftung', 'tank ventilation'),
    ('Fahrzeuggeschwindigkeit', 'vehicle speed'),
    ('Kühlmitteltemperatur', 'coolant temperature'),
    ('Ladelufttemperatur', 'charge-air temperature'),
    ('Kraftstoffniederdruck', 'low-pressure fuel supply'),
    ('Kraftstoff-Füllstand', 'fuel level'),
    ('Kurbelwellensensor', 'crankshaft sensor'),
    ('Klopfsensor', 'knock sensor'),
    ('Differenzdrucksensor', 'differential pressure sensor'),
    ('Raddrehzahlsensor', 'wheel speed sensor'),
    ('Verbrennungsaussetzer', 'combustion misfire'),
    ('Bordnetzspannung', 'vehicle electrical supply'),
    ('Powermanagement', 'power management'),
    ('Kommunikation', 'communication'),
    ('Startsystem', 'starting system'),
    ('Antrieb', 'drivetrain'),
    ('Motoröl', 'engine oil'),
    ('Einspritzung', 'fuel injection'),
    ('Zündkreis', 'ignition circuit'),
    ('Katalysator', 'catalyst'),
    ('Schubumluftventil', 'charge-air recirculation valve'),
    ('Tankfüllstand', 'fuel level'),
    ('Leerlaufregelung', 'idle control'),
    ('DME', 'DME internal control'),
    ('EGS', 'transmission communication'),
    ('A-CAN', 'A-CAN communication'),
    ('FA-CAN', 'FA-CAN communication'),
    ('FlexRay', 'FlexRay communication'),
    ('LIN', 'LIN communication'),
    ('VANOS', 'variable valve timing'),
    ('Valvetronic', 'Valvetronic control'),
    ('EAC Sensor', 'EAC sensor'),
    ('Check-Control', 'check-control message'),
]


def german_subject(label: str) -> str:
    first = label.split(':', 1)[0]
    for german, english in SUBJECTS:
        if (re.search(r'\b' + re.escape(german) + r'\b', first, re.I)
                if len(german) <= 4 else german.casefold() in first.casefold()):
            cylinder = re.search(r'Zylinder\s+(\d+)', first)
            return f'{english} {cylinder.group(1)}' if cylinder and english == 'cylinder injector' else english
    return 'engine management'


def german_issue(label: str) -> str:
    tail = label.split(':', 1)[-1].casefold()
    checks = [
        ('kurzschluss nach plus', 'circuit shorted to battery positive'),
        ('kurzschluss nach masse', 'circuit shorted to ground'),
        ('leitungsunterbrechung', 'open circuit'),
        ('signal fehlt', 'signal not received'),
        ('botschaft fehlt', 'message not received'),
        ('kommunikation', 'communication fault'),
        ('aliveprüfung', 'message counter error'),
        ('prüfsumme falsch', 'message checksum mismatch'),
        ('signalfehler', 'signal fault'),
        ('signalausfall', 'signal lost'),
        ('fehlgeschlagen', 'operation did not complete'),
        ('verzögerte reaktion', 'response delayed'),
        ('sammelfehler', 'multiple related faults'),
        ('ungültig', 'invalid data'),
        ('klemmt geschlossen', 'stuck closed'),
        ('klemmt offen', 'stuck open'),
        ('elektrischer fehler', 'electrical fault'),
        ('notlauf aktiv', 'reduced-power mode active'),
        ('zu schnell', 'response faster than expected'),
        ('defekt', 'component fault reported'),
        ('reset', 'reset recorded'),
        ('kondensat', 'condensate-related cylinder deactivation'),
        ('ausserhalb', 'outside expected range'),
        ('freilauf', 'freewheel or start-system change requested'),
        ('leck entdeckt', 'tank-system leak detected'),
        ('steuerkreis - niedrig', 'control circuit level low'),
        ('steuerkreis - hoch', 'control circuit level high'),
        ('periodendauer ausserhalb', 'signal period outside valid range'),
        ('moment drehzahlregler', 'speed-controller torque fault'),
        ('plausibilisierung ethanolgehalt', 'ethanol content check failed'),
        ('aktivierung notlauf', 'reduced-power mode requested'),
        ('verschmutzt oder luft', 'cooling-system contamination or trapped air reported'),
        ('temporäre motordrehzahlreduzierung', 'temporary engine-speed limit active'),
        ('hybridablaufsteuerung', 'hybrid transmission control fault'),
        ('nicht erkannt nach startversuch', 'engine not detected after start attempt'),
        ('beschränkung auf gang', 'gear selection limited'),
        ('tiefen wassers', 'deep-water event detected'),
        ('gang 1', 'first-gear restriction'),
        ('notlaufanforderung', 'reduced-power request recorded'),
        ('nockenwelle beim start', 'camshaft not in its expected start position'),
        ('ausfallsicherung aktiv', 'backup function active'),
        ('motorgeräusch', 'engine noise above limit'),
        ('vorsichtig anhalten', 'stop-driving warning requested'),
        ('schaltkreis - niedrig', 'control circuit level low'),
        ('schaltkreis - hoch', 'control circuit level high'),
        ('festliegend', 'signal stuck at one value'),
        ('zylinder ausgefallen', 'cylinder operation lost'),
        ('anschlag nicht erkannt', 'end stop not detected'),
        ('zu früh erkannt', 'end stop detected too early'),
        ('zwangshochschaltung', 'forced upshift requested'),
        ('drehmoment reduziert', 'torque reduction requested'),
        ('bankausfall', 'bank operation lost'),
        ('leckage', 'leak detected'),
        ('pumpenstrom', 'pump current outside expected range'),
        ('abbruch', 'operation interrupted'),
        ('tankfüllstand', 'fuel-level inconsistency'),
        ('füllstandsänderung', 'fuel-level change inconsistent'),
        ('framefehler', 'network frame error'),
        ('warnschwelle', 'warning threshold exceeded'),
        ('gesamtmoment', 'total torque outside expected range'),
        ('erzeugerausfall', 'electrical generation lost'),
        ('dauerhaft geschlossen', 'relay or valve stuck closed'),
        ('dauerhaft offen', 'relay or valve stuck open'),
        ('tankverschluss offen', 'fuel cap reported open'),
        ('ladekabel', 'charge cable condition reported'),
        ('tank leer', 'fuel level reported empty'),
        ('bauteileschutz', 'protective power reduction active'),
        ('kühlmittelpumpe', 'coolant pump operation fault'),
        ('kühlmitteldurchflussmenge', 'coolant flow below expected level'),
        ('tiefentladung', 'battery deeply discharged'),
        ('ruhestrom', 'resting current outside expected range'),
        ('systemfehler', 'system fault'),
        ('interner fehler', 'internal control fault'),
        ('anforderung', 'control request reported'),
        ('getriebefehler', 'transmission fault reported'),
        ('unterschritten', 'reading below expected range'),
        ('überschritten', 'reading above expected range'),
        ('ausfall', 'operation lost'),
        ('falsch', 'invalid data'),
        ('abgebrochen', 'operation interrupted'),
        ('gestartet', 'operation started'),
        ('erfolgreich durchgeführt', 'operation completed'),
        ('fehlt', 'expected input not received'),
        ('unplausibel', 'inconsistent signal'),
        ('zu hoch', 'reading above expected range'),
        ('zu niedrig', 'reading below expected range'),
        ('zu langsam', 'response slower than expected'),
        ('zeitüberschreitung', 'response timeout'),
        ('blockade', 'movement blocked'),
        ('regelabweichung', 'control deviation'),
        ('positionsabweichung', 'position differs from command'),
        ('spannung', 'voltage fault'),
        ('temperatur', 'temperature fault'),
        ('druck', 'pressure fault'),
        ('gemisch zu mager', 'mixture too lean'),
        ('gemisch zu fett', 'mixture too rich'),
        ('fehlfunktion', 'operation fault'),
        ('fehler', 'reported fault'),
    ]
    for term, meaning in checks:
        if term in tail:
            return meaning
    return 'reported fault'


def english_record(label: str, engine: str):
    source = re.sub(r'\s+', ' ', label).strip()
    parts = source.split(':', 1)
    subject = parts[0].strip(' ,.')
    issue = english_issue(parts[1] if len(parts) == 2 else parts[0])
    # Structure the display text as a symptom and an observed condition, rather
    # than copying the terse B1V label or inventing a component diagnosis.
    title = f'{subject} — {issue}' if len(parts) == 2 else f'DME report: {issue[0].lower()}{issue[1:]}'
    explanation = (f'The {engine} DME logged a condition involving {subject.lower()}: {issue.lower()}. '
                   'The code alone does not establish which part caused it.') if len(parts) == 2 else (
                   f'The {engine} DME logged this condition: {issue.lower()}. '
                   'Review the operating context and related faults before drawing a diagnosis.')
    return title, explanation


def german_record(label: str, engine: str):
    subject = german_subject(label)
    issue = german_issue(label)
    title = f'{subject[0].upper()}{subject[1:]} — {issue}'
    explanation = (f'The {engine} DME recorded {issue} in {subject}. '
                   'The code alone does not identify a failed component.')
    return title, explanation


def main():
    workbook = load_workbook(sys.argv[1], read_only=True, data_only=True)
    original = Path(sys.argv[2]).read_text(encoding='cp1252', errors='replace')
    fault_table = original.split('TBEG "FORTTEXTE"', 1)[1].split('TEND', 1)[0]
    n20_original = dict(re.findall(r'^LINE "0x([0-9A-Fa-f]{6})", "([^"]+)"', fault_table, re.M))
    rows = {}
    s55_sources = {}
    for sheet in workbook:
        engine = 'S55' if sheet.title.startswith('S55') else 'N20'
        rows[engine] = {}
        for row in list(sheet.values)[5:]:
            if not row or not row[0]:
                continue
            code = str(row[0]).removeprefix('0x').upper()
            if not re.fullmatch(r'[0-9A-F]{6}', code) or code == 'FFFFFF':
                continue
            if engine == 'S55':
                s55_sources[code] = (str(row[1]), str(row[2]))
            matching_s55 = engine == 'N20' and code in s55_sources and str(row[2]) == s55_sources[code][1]
            label = row[1] if engine == 'S55' else (s55_sources[code][0] if matching_s55 else n20_original.get(code, row[2]))
            if not label:
                raise ValueError(f'No label for {engine} {code}')
            rows[engine][code] = english_record(str(label), engine) if engine == 'S55' or matching_s55 else german_record(str(label), engine)
    lines = [
        '// Generated from the S55/N20 DME B1V reference workbook and original N20 B1V.',
        '// These are conservative app summaries, not BMW test-plan interpretations.',
        '// Regenerate with tool/generate_dme_fault_catalog.py; hand-written entries win.',
        "import 'fault_definitions.dart';",
        '',
    ]
    for engine in ('S55', 'N20'):
        lines.append(f'const {engine.lower()}DmeFaultDefinitions = <String, FaultDefinition>{{')
        for code, fields in sorted(rows[engine].items()):
            title, explanation = fields
            lines.append(f'  {dart(code)}: FaultDefinition(')
            lines.append(f'    title: {dart(title)},')
            lines.append(f'    system: {dart(engine + " DME reference")},')
            lines.append(f'    explanation: {dart(explanation)},')
            lines.append('  ),')
        lines.append('};')
        lines.append('')
    path = Path('lib/diagnostics/generated_dme_fault_definitions.dart')
    path.write_text('\n'.join(lines), encoding='utf-8')
    print(f'S55={len(rows["S55"])} N20={len(rows["N20"])} unique={len(rows["S55"].keys() | rows["N20"].keys())} bytes={path.stat().st_size}')


if __name__ == '__main__':
    main()
