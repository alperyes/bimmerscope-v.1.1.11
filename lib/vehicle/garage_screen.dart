import 'package:flutter/material.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'vehicle_garage.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key, this.onSelect});
  final ValueChanged<GarageVehicle>? onSelect;
  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  final store = VehicleGarageStore();
  List<GarageVehicle> vehicles = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await store.load();
    if (mounted) setState(() => vehicles = value);
  }

  Future<void> _editVehicle(GarageVehicle vehicle) async {
    final nickname = TextEditingController(text: vehicle.nickname);
    final mileage = TextEditingController(
      text: vehicle.mileageKm?.toStringAsFixed(0) ?? '',
    );
    final modifications = TextEditingController(
      text: vehicle.modifications.join(', '),
    );
    final notes = TextEditingController(text: vehicle.notes);
    final updated = await showDialog<GarageVehicle>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(vehicle.label),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppPalette.blue.withValues(alpha: .07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.fingerprint_rounded,
                      color: AppPalette.blue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Semantics(
                        label: 'Vehicle identification number',
                        child: Text(
                          vehicle.vin,
                          style: TextStyle(
                            fontFamily: 'Geist Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(
                              dialogContext,
                            ).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Read only',
                      style: TextStyle(
                        color: Theme.of(
                          dialogContext,
                        ).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nickname,
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mileage,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Mileage (km)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modifications,
                decoration: const InputDecoration(
                  labelText: 'Modifications / hardware',
                  hintText: 'Intake, charge pipes, fuel…',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notes,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final parsedMileage = double.tryParse(mileage.text.trim());
              Navigator.pop(
                dialogContext,
                vehicle.copyWith(
                  nickname: nickname.text.trim(),
                  mileageKm: parsedMileage,
                  modifications: modifications.text
                      .split(',')
                      .map((item) => item.trim())
                      .where((item) => item.isNotEmpty)
                      .toList(),
                  notes: notes.text.trim(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    nickname.dispose();
    mileage.dispose();
    modifications.dispose();
    notes.dispose();
    if (updated == null) return;
    await store.upsert(updated);
    await _load();
  }

  Future<void> _confirmRemove(GarageVehicle vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove vehicle?'),
        content: Text(
          'Remove ${vehicle.nickname.isEmpty ? vehicle.label : vehicle.nickname} from this device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppPalette.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await store.remove(vehicle.vin);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vehicle garage')),
    body: vehicles.isEmpty
        ? Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(appCardRadius),
              ),
              child: Semantics(
                container: true,
                label:
                    'Vehicle garage is empty. Connect a vehicle, then save its identity from Tune.',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      color: AppPalette.blue,
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No vehicles saved yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Connect a vehicle, then save its identity from Tune.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vehicles.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final vehicle = vehicles[index];
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(appCardRadius),
                ),
                child: Semantics(
                  container: true,
                  label:
                      '${vehicle.nickname.isEmpty ? vehicle.label : vehicle.nickname}. VIN ${vehicle.vin}. ${vehicle.mileageKm == null ? 'Mileage not recorded' : '${vehicle.mileageKm!.toStringAsFixed(0)} kilometres'}. ${vehicle.modifications.isEmpty ? 'No modifications recorded' : vehicle.modifications.join(', ')}.',
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppPalette.blue.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_car_outlined,
                        color: AppPalette.blue,
                      ),
                    ),
                    title: Text(
                      vehicle.nickname.isEmpty
                          ? vehicle.label
                          : vehicle.nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${vehicle.vin}\n'
                      '${vehicle.mileageKm == null ? 'Mileage not recorded' : '${vehicle.mileageKm!.toStringAsFixed(0)} km'} · '
                      '${vehicle.modifications.isEmpty ? 'No modifications recorded' : vehicle.modifications.join(', ')}'
                      '${vehicle.notes.trim().isEmpty ? '' : '\n${vehicle.notes.trim()}'}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit vehicle',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _editVehicle(vehicle),
                        ),
                        IconButton(
                          tooltip: 'Remove vehicle',
                          color: AppPalette.red,
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _confirmRemove(vehicle),
                        ),
                      ],
                    ),
                    onTap: widget.onSelect == null
                        ? null
                        : () {
                            widget.onSelect!(vehicle);
                            Navigator.of(context).pop(vehicle);
                          },
                  ),
                ),
              );
            },
          ),
  );
}
