import 'package:bmw_app/vehicle/vehicle_identity.dart';

enum TuneProductVariant { competition, cs }

class TuneProduct {
  const TuneProduct({
    required this.id,
    required this.name,
    required this.variantLabel,
    required this.description,
    required this.fitment,
    required this.requirements,
    required this.variant,
  });

  final String id;
  final String name;
  final String variantLabel;
  final String description;
  final String fitment;
  final List<String> requirements;
  final TuneProductVariant variant;

  String get displayName => '$name · $variantLabel';

  bool matchesVehicle(VehicleIdentity identity) =>
      identity.chassis == 'F82' &&
      identity.engine == 'S55' &&
      identity.transmission == 'DCT';
}

const s55RemapProducts = <TuneProduct>[
  TuneProduct(
    id: 's55-remap-competition',
    name: 'S55 remap',
    variantLabel: 'Competition',
    description:
        'Competition-spec product track for the F82 M4 S55. Final map behavior depends on verified hardware, fuel, and DME data.',
    fitment: 'F82 M4 · S55 · DCT',
    requirements: [
      'Complete DME fingerprint',
      'Verified stock backup',
      'Hardware and fuel confirmation',
    ],
    variant: TuneProductVariant.competition,
  ),
  TuneProduct(
    id: 's55-remap-cs',
    name: 'S55 remap',
    variantLabel: 'CS',
    description:
        'CS-spec product track for the F82 M4 S55. Final map behavior depends on verified hardware, fuel, and DME data.',
    fitment: 'F82 M4 · S55 · DCT',
    requirements: [
      'Complete DME fingerprint',
      'Verified stock backup',
      'Hardware and fuel confirmation',
    ],
    variant: TuneProductVariant.cs,
  ),
];

TuneProduct? findTuneProduct(String? id) {
  if (id == null) return null;
  for (final product in s55RemapProducts) {
    if (product.id == id) return product;
  }
  return null;
}
