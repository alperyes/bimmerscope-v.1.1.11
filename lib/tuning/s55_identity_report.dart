import 'package:bmw_app/tuning/tune_compatibility.dart';

/// Formats the read-only S55 identity evidence for a tuner or ISTA comparison.
/// Values remain exactly as returned by the ECU; binary values are represented
/// as spaced hexadecimal by the transport layer.
String buildS55IdentityReport({
  required String vin,
  required TuneDmeEvidence evidence,
}) {
  final lines = <String>[
    'BIMMERSCOPE S55 IDENTITY REPORT',
    'Scope: read-only ECU identity evidence',
    'VIN: $vin',
    'Source: ${evidence.source ?? 'unknown'}',
    'Session: ${evidence.sessionId ?? 'not recorded'}',
    'Captured: ${evidence.capturedAt?.toIso8601String() ?? 'not recorded'}',
    'DME address: HSFZ 0x12',
    '',
    'FIELD | DID | VALUE',
    'DME identity / SGBD index | 22 F1 50 | ${_value(evidence.identity)}',
    'BMW software reference | 22 40 1F | ${_value(evidence.software)}',
    'Startup / boot block | 22 40 98 | ${_value(evidence.bootloader)}',
    'Calibration / CVN record | 22 40 3C | ${_value(evidence.calibration)}',
    'Physical hardware number (optional) | 22 3F 41 | ${_value(evidence.hardware)}',
    'Coding proof stamp | 22 37 FE | ${_value(evidence.codingId)}',
    'Software vehicle key | 22 F1 01 | ${_value(evidence.svk)}',
    'ECU serial number | 22 F1 8C | ${_value(evidence.serialNumber)}',
    '',
    'Core evidence: ${evidence.complete ? 'complete for professional review' : 'incomplete'}',
    'Physical hardware: ${evidence.hasPhysicalHardware ? 'available' : 'optional / unavailable'}',
    'No ECU programming, calibration writing, or flashing is enabled.',
  ];
  return '${lines.join('\n')}\n';
}

String _value(String? value) =>
    value?.trim().isNotEmpty == true ? value!.trim() : 'Not read / unavailable';
