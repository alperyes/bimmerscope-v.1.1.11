import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MemoryReadScreen extends StatefulWidget {
  const MemoryReadScreen({
    super.key,
    required this.vin,
    required this.onBeforeRead,
    required this.onAfterRead,
  });

  final String vin;
  final Future<void> Function() onBeforeRead;
  final Future<void> Function() onAfterRead;

  @override
  State<MemoryReadScreen> createState() => _MemoryReadScreenState();
}

class _MemoryReadScreenState extends State<MemoryReadScreen> {
  final _address = TextEditingController();
  final _length = TextEditingController(text: '64');
  bool _reading = false;
  String? _error;
  List<int>? _bytes;
  int? _readAddress;

  @override
  void dispose() {
    _address.dispose();
    _length.dispose();
    super.dispose();
  }

  Future<void> _read() async {
    if (_reading) return;
    final rawAddress = _address.text.trim().replaceFirst(RegExp(r'^0[xX]'), '');
    final address = RegExp(r'^[0-9a-fA-F]{1,8}$').hasMatch(rawAddress)
        ? int.tryParse(rawAddress, radix: 16)
        : null;
    final length = int.tryParse(_length.text.trim());
    if (address == null ||
        length == null ||
        length < 1 ||
        length > 256 ||
        address + length - 1 > 0xFFFFFFFF) {
      setState(() => _error = 'Enter a 32-bit hex address and 1–256 bytes.');
      return;
    }
    setState(() {
      _reading = true;
      _error = null;
      _bytes = null;
    });
    var paused = false;
    try {
      await widget.onBeforeRead();
      paused = true;
      final result = await readDmeMemory(
        address: address,
        length: length,
        expectedVin: widget.vin,
      );
      if (mounted) {
        setState(() {
          _bytes = result;
          _readAddress = address;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (paused) {
        try {
          await widget.onAfterRead();
        } catch (error) {
          if (mounted) {
            setState(() => _error = 'Read finished; reconnect failed: $error');
          }
        }
      }
      if (mounted) setState(() => _reading = false);
    }
  }

  String _hexDump(List<int> bytes, int address) {
    final lines = <String>[];
    for (var offset = 0; offset < bytes.length; offset += 16) {
      final row = bytes.skip(offset).take(16);
      lines.add(
        '${(address + offset).toRadixString(16).toUpperCase().padLeft(8, '0')}  '
        '${row.map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0')).join(' ')}',
      );
    }
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    final dump = bytes == null ? null : _hexDump(bytes, _readAddress!);
    return Scaffold(
      appBar: AppBar(title: const Text('Read DME memory')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Read one address range from the connected DME. Addresses are ECU memory addresses, not BIN file offsets.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _address,
            enabled: !_reading,
            decoration: const InputDecoration(
              labelText: 'Address (hex)',
              hintText: '0xD0000000',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _length,
            enabled: !_reading,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Number of bytes (decimal, 1–256)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _reading ? null : _read,
            icon: _reading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.memory_rounded),
            label: Text(_reading ? 'Reading…' : 'Read memory'),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SelectableText(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (dump != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${bytes!.length} bytes returned',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Copy hex',
                  onPressed: () => Clipboard.setData(ClipboardData(text: dump)),
                  icon: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                dump,
                style: const TextStyle(fontFamily: 'monospace', height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
