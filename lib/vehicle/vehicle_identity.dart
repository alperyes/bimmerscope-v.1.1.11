import 'vehicle_platform_registry.g.dart';

class VehicleIdentity {
  const VehicleIdentity({
    required this.chassis,
    required this.model,
    required this.engine,
    required this.transmission,
    required this.modelYear,
    this.typeKey,
    this.market = '',
    this.steering = '',
    this.bodyStyle = '',
    this.gearboxHint = '',
  });

  final String chassis;
  final String model;
  final String engine;
  final String transmission;
  final int? modelYear;
  final String? typeKey;
  final String market;
  final String steering;
  final String bodyStyle;
  final String gearboxHint;

  String get displayLabel {
    final year = modelYear == null ? '' : ' · $modelYear';
    return 'BMW $chassis $model$year';
  }
}

VehicleIdentity? identifyVehicle(String vin) {
  if (vin == 'DEMOF82S55MOBILE') {
    return const VehicleIdentity(
      chassis: 'F82',
      model: 'M4',
      engine: 'S55',
      transmission: 'DCT',
      modelYear: 2014,
    );
  }
  if (vin == 'DEM0F30335IMOBILE') {
    return const VehicleIdentity(
      chassis: 'F30',
      model: '335i',
      engine: 'N55',
      transmission: '8HP',
      modelYear: 2013,
    );
  }
  if (vin == 'DEM0F10535IMOBILE') {
    return const VehicleIdentity(
      chassis: 'F10',
      model: '535i',
      engine: 'N55',
      transmission: '8HP',
      modelYear: 2012,
    );
  }
  if (vin == 'DEM0F1535IMOBILE') {
    return const VehicleIdentity(
      chassis: 'F15',
      model: 'X5 35i',
      engine: 'N55',
      transmission: '8HP',
      modelYear: 2015,
    );
  }

  // Exact N20 bench vehicle used for the capture-derived reference probes.
  if (vin.trim().toUpperCase() == 'WBA3A52010F360747') {
    return VehicleIdentity(
      chassis: 'F30',
      model: '328i',
      engine: 'N20',
      transmission: '8HP',
      modelYear: _modelYearFromVin(vin),
    );
  }

  final normalized = vin.trim().toUpperCase();
  if (normalized.length < 10) return null;

  final modelYear = _modelYearFromVin(normalized);
  if (normalized.startsWith('WBS3R92')) {
    final record = psdzVehicleRegistry.firstWhere(
      (entry) => entry['typeKey'] == '3R92',
      orElse: () => const <String, String>{},
    );
    return VehicleIdentity(
      chassis: 'F82',
      model: 'M4',
      engine: 'S55',
      transmission: 'DCT',
      modelYear: modelYear,
      typeKey: record['typeKey'],
      market: record['market'] ?? '',
      steering: record['steering'] ?? '',
      bodyStyle: record['bodyStyle'] ?? '',
      gearboxHint: record['gearboxHint'] ?? '',
    );
  }

  // BMW F-generation VINs carry the four-character type key in positions
  // 4–7. Resolve only complete F-series registry rows, and refuse ambiguous
  // keys rather than guessing the vehicle model or engine.
  if (normalized.length == 17 &&
      normalized.codeUnits.every(
        (unit) =>
            (unit >= 0x30 && unit <= 0x39) || (unit >= 0x41 && unit <= 0x5A),
      )) {
    final typeKey = normalized.substring(3, 7);
    final records = psdzVehicleRegistry
        .where(
          (entry) =>
              entry['typeKey'] == typeKey &&
              entry['series']?.startsWith('F') == true &&
              entry['chassis']?.startsWith('F') == true &&
              entry['model']?.isNotEmpty == true &&
              entry['engineFamily']?.isNotEmpty == true &&
              entry['engineVariant']?.isNotEmpty == true,
        )
        .toList(growable: false);
    final identities = records
        .map(
          (entry) =>
              '${entry['chassis']}|${entry['model']?.toUpperCase()}|'
              '${entry['engineFamily']}|${entry['engineVariant']}',
        )
        .toSet();
    if (records.isNotEmpty && identities.length == 1) {
      final record = records.first;
      return VehicleIdentity(
        chassis: record['chassis']!,
        model: _displayModel(record['model']!),
        engine: record['engineFamily']!,
        transmission: _transmissionFromHint(record['gearboxHint']),
        modelYear: modelYear,
        typeKey: typeKey,
        market: '',
        steering: '',
        bodyStyle: record['bodyStyle'] ?? '',
        gearboxHint: '',
      );
    }
  }

  // An otherwise well-formed VIN is not enough to establish a supported
  // vehicle profile. Keep unknown identities absent so capability-gated
  // workflows cannot become available while disconnected or unverified.
  return null;
}

String _displayModel(String value) {
  final model = value.trim();
  if (model.isEmpty) return model;
  if (RegExp(r'^\d').hasMatch(model)) return model.toLowerCase();
  return '${model[0].toUpperCase()}${model.substring(1).toLowerCase()}';
}

String _transmissionFromHint(String? hint) => switch (hint?.toUpperCase()) {
  'M' => 'Manual',
  'A' => 'Automatic',
  _ => 'Unknown',
};

int? _modelYearFromVin(String vin) {
  if (vin.length < 10) return null;
  const yearCodes = <String, int>{
    'A': 2010,
    'B': 2011,
    'C': 2012,
    'D': 2013,
    'E': 2014,
    'F': 2015,
    'G': 2016,
    'H': 2017,
    'J': 2018,
    'K': 2019,
    'L': 2020,
    'M': 2021,
    'N': 2022,
    'P': 2023,
    'R': 2024,
    'S': 2025,
    'T': 2026,
  };
  return yearCodes[vin[9]];
}
