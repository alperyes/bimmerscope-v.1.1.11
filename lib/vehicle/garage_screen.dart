import 'package:flutter/material.dart';
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
              Text(
                vehicle.vin,
                style: Theme.of(dialogContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nickname,
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              TextField(
                controller: mileage,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Mileage (km)'),
              ),
              TextField(
                controller: modifications,
                decoration: const InputDecoration(
                  labelText: 'Modifications / hardware',
                  hintText: 'Intake, charge pipes, fuel…',
                ),
              ),
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
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Text(
                'No vehicles saved yet. Connect a vehicle, then save its identity from Tune.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        : ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (_, index) {
              final vehicle = vehicles[index];
              return ListTile(
                leading: const Icon(Icons.directions_car_outlined),
                title: Text(
                  vehicle.nickname.isEmpty ? vehicle.label : vehicle.nickname,
                ),
                subtitle: Text(
                  '${vehicle.vin}\n'
                  '${vehicle.mileageKm == null ? 'Mileage not recorded' : '${vehicle.mileageKm!.toStringAsFixed(0)} km'} · '
                  '${vehicle.modifications.isEmpty ? 'No modifications recorded' : vehicle.modifications.join(', ')}'
                  '${vehicle.notes.trim().isEmpty ? '' : '\n${vehicle.notes.trim()}'}',
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
              );
            },
          ),
  );
}
