import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GarageVehicle {
  const GarageVehicle({
    required this.vin,
    required this.label,
    required this.profileId,
    this.nickname = '',
    this.modifications = const [],
    this.mileageKm,
    this.notes = '',
    this.lastConnectedAt,
  });

  final String vin;
  final String label;
  final String profileId;
  final String nickname;
  final List<String> modifications;
  final double? mileageKm;
  final String notes;
  final DateTime? lastConnectedAt;

  GarageVehicle copyWith({
    String? nickname,
    List<String>? modifications,
    double? mileageKm,
    String? notes,
    DateTime? lastConnectedAt,
  }) => GarageVehicle(
    vin: vin,
    label: label,
    profileId: profileId,
    nickname: nickname ?? this.nickname,
    modifications: modifications ?? this.modifications,
    mileageKm: mileageKm ?? this.mileageKm,
    notes: notes ?? this.notes,
    lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
  );

  Map<String, dynamic> toJson() => {
    'vin': vin,
    'label': label,
    'profileId': profileId,
    'nickname': nickname,
    'modifications': modifications,
    'mileageKm': mileageKm,
    'notes': notes,
    'lastConnectedAt': lastConnectedAt?.toIso8601String(),
  };

  factory GarageVehicle.fromJson(Map<String, dynamic> json) => GarageVehicle(
    vin: json['vin'] as String? ?? '',
    label: json['label'] as String? ?? 'BMW',
    profileId: json['profileId'] as String? ?? 'unsupported-f-series',
    nickname: json['nickname'] as String? ?? '',
    modifications: [
      for (final item in (json['modifications'] as List<dynamic>? ?? const []))
        item.toString(),
    ],
    mileageKm: (json['mileageKm'] as num?)?.toDouble(),
    notes: json['notes'] as String? ?? '',
    lastConnectedAt: DateTime.tryParse(
      json['lastConnectedAt'] as String? ?? '',
    ),
  );
}

class VehicleGarageStore {
  static const _key = 'bimmerscope.vehicle_garage.v1';

  Future<List<GarageVehicle>> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null) return [];
    try {
      final values = jsonDecode(raw) as List<dynamic>;
      return [
        for (final value in values)
          GarageVehicle.fromJson(Map<String, dynamic>.from(value as Map)),
      ];
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }

  Future<void> save(List<GarageVehicle> vehicles) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _key,
      jsonEncode([for (final vehicle in vehicles) vehicle.toJson()]),
    );
  }

  Future<void> upsert(GarageVehicle vehicle) async {
    final vehicles = await load();
    final index = vehicles.indexWhere((item) => item.vin == vehicle.vin);
    if (index >= 0) {
      vehicles[index] = vehicle;
    } else {
      vehicles.add(vehicle);
    }
    await save(vehicles);
  }

  Future<void> remove(String vin) async {
    final vehicles = await load();
    vehicles.removeWhere((vehicle) => vehicle.vin == vin);
    await save(vehicles);
  }
}
