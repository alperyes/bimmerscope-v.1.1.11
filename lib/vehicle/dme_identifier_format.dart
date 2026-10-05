/// Converts a BMW eight-hex-digit ID plus three decimal version bytes back
/// to the seven bytes returned in an F101 component record.
String? rawDmeComponentId(String formatted) {
  final value = formatted.trim();
  if (!RegExp(r'^[0-9A-Fa-f]{8}[0-9]{9}$').hasMatch(value)) return null;
  final bytes = <int>[];
  for (var offset = 8; offset < 17; offset += 3) {
    final byte = int.parse(value.substring(offset, offset + 3));
    if (byte > 255) return null;
    bytes.add(byte);
  }
  return '${value.substring(0, 8).toUpperCase()}'
      '${bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase()).join()}';
}

/// Shows a compact component ID as XXXXXXXX-XXX.XXX.XXX without changing
/// the identifier kept by the vehicle session or exported elsewhere.
String formatDmeComponentId(String value) {
  final compact = value.trim();
  if (!RegExp(r'^[0-9A-Fa-f]{8}[0-9]{9}$').hasMatch(compact)) return value;
  return '${compact.substring(0, 8).toUpperCase()}-'
      '${compact.substring(8, 11)}.${compact.substring(11, 14)}.'
      '${compact.substring(14, 17)}';
}
