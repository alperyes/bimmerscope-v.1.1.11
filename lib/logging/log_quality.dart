import 'dart:io';

class LogQualityReport {
  const LogQualityReport({
    required this.sampleCount,
    required this.durationMs,
    required this.channels,
    required this.provenanceMatches,
    required this.maxGapMs,
    required this.reasons,
  });

  final int sampleCount;
  final int durationMs;
  final Set<String> channels;
  final bool provenanceMatches;
  final int maxGapMs;
  final List<String> reasons;

  bool get suitableForTunerReview => reasons.isEmpty;

  Map<String, dynamic> toJson() => {
    'sample_count': sampleCount,
    'duration_ms': durationMs,
    'channels': channels.toList()..sort(),
    'provenance_matches': provenanceMatches,
    'max_gap_ms': maxGapMs,
    'suitable_for_tuner_review': suitableForTunerReview,
    'reasons': reasons,
  };
}

Future<LogQualityReport> inspectLogQuality(
  File file, {
  required String vin,
  required String profileId,
}) async {
  final lines = await file.readAsLines();
  final header = <String, String>{};
  final channels = <String>{};
  var samples = 0;
  var durationMs = 0;
  var maxGapMs = 0;
  int? previousElapsedMs;
  for (final line in lines) {
    if (line.startsWith('# ')) {
      final comma = line.indexOf(',');
      if (comma > 2) {
        header[line.substring(2, comma)] = line
            .substring(comma + 1)
            .replaceAll('"', '');
      }
      continue;
    }
    if (line.startsWith('timestamp,') || line.trim().isEmpty) {
      continue;
    }
    final fields = _parseCsvLine(line);
    if (fields.length < 5) {
      continue;
    }
    final elapsedMs = int.tryParse(fields[1]) ?? 0;
    if (previousElapsedMs != null) {
      maxGapMs = maxGapMs > elapsedMs - previousElapsedMs
          ? maxGapMs
          : elapsedMs - previousElapsedMs;
    }
    previousElapsedMs = elapsedMs;
    samples++;
    channels.add(fields[2].replaceAll('"', ''));
    durationMs = durationMs > elapsedMs ? durationMs : elapsedMs;
  }
  final matches =
      header['vehicle'] == _safeVehicleId(vin) &&
      header['vehicle_profile'] == profileId;
  final reasons = <String>[];
  if (!matches) {
    reasons.add('Log provenance does not match the current VIN and profile.');
  }
  if (samples < 30) {
    reasons.add('Log has fewer than 30 samples.');
  }
  if (durationMs < 10000) {
    reasons.add('Log duration is under 10 seconds.');
  }
  if (channels.length < 2) {
    reasons.add('Log contains fewer than two live-data channels.');
  }
  if (maxGapMs > 5000) {
    reasons.add('Log has a telemetry gap longer than 5 seconds.');
  }
  return LogQualityReport(
    sampleCount: samples,
    durationMs: durationMs,
    channels: channels,
    provenanceMatches: matches,
    maxGapMs: maxGapMs,
    reasons: reasons,
  );
}

String _safeVehicleId(String vin) => vin == 'Not identified'
    ? 'unknown-vehicle'
    : vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

List<String> _parseCsvLine(String line) {
  final fields = <String>[];
  var buffer = StringBuffer();
  var quoted = false;
  for (var index = 0; index < line.length; index++) {
    final character = line[index];
    if (character == '"') {
      if (quoted && index + 1 < line.length && line[index + 1] == '"') {
        buffer.write('"');
        index++;
      } else {
        quoted = !quoted;
      }
    } else if (character == ',' && !quoted) {
      fields.add(buffer.toString());
      buffer = StringBuffer();
    } else {
      buffer.write(character);
    }
  }
  fields.add(buffer.toString());
  return fields;
}
