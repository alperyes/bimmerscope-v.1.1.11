import 'dart:io';

import 'package:bmw_app/tuning/stock_file_store.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReadDme2Screen extends StatefulWidget {
  const ReadDme2Screen({
    super.key,
    required this.vin,
    required this.isN20Reference,
    required this.canRead,
    required this.onRead,
    required this.onCancel,
    required this.store,
  });

  final String vin;
  final bool isN20Reference;
  final bool Function() canRead;
  final Future<void> Function() onRead;
  final VoidCallback onCancel;
  final StockFileStore store;

  @override
  State<ReadDme2Screen> createState() => _ReadDme2ScreenState();
}

class _ReadDme2ScreenState extends State<ReadDme2Screen> {
  bool _loading = true;
  bool _reading = false;
  bool _deleting = false;
  String? _error;
  List<_ReadDme2File> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final backups = await widget.store.loadAll(widget.vin);
      final selected = backups.where((backup) {
        final name = backup.fileName.toLowerCase();
        return name.endsWith('_ecu_read_bm3_pattern_s55.bin') ||
            name.endsWith('_n20_bench_80180000_7fc00.bin') ||
            name.endsWith('_n20_bench_memory_probe_sample.bin');
      });
      final files = <_ReadDme2File>[];
      for (final backup in selected) {
        final file = backup.file;
        final bytes = await file.readAsBytes();
        files.add(
          _ReadDme2File(
            file: file,
            size: bytes.length,
            sha256: sha256.convert(bytes).toString(),
            savedAt: await file.lastModified(),
          ),
        );
      }
      if (mounted) {
        setState(() {
          _files = files;
          _error = null;
          _loading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = 'Could not load saved reads: $error';
          _loading = false;
        });
      }
    }
  }

  Future<void> _read() async {
    if (_reading || !widget.canRead()) return;
    setState(() => _reading = true);
    try {
      await widget.onRead();
      await _loadFiles();
    } finally {
      if (mounted) setState(() => _reading = false);
    }
  }

  Future<void> _share(_ReadDme2File artifact) async {
    try {
      if (!await artifact.file.exists()) {
        await _loadFiles();
        throw const FileSystemException('Saved BIN is no longer available');
      }
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(artifact.file.path, mimeType: 'application/octet-stream'),
          ],
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not share BIN: $error')));
      }
    }
  }

  Future<void> _delete(_ReadDme2File artifact) async {
    if (_reading || _deleting) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete saved BIN?'),
        content: Text('Delete ${artifact.file.uri.pathSegments.last} from this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await widget.store.deleteBackup(file: artifact.file, vin: widget.vin);
      await _loadFiles();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved BIN deleted')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not delete BIN: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final n20 = widget.isN20Reference;
    return Scaffold(
      appBar: AppBar(title: const Text('Read DME 2')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '${n20 ? 'N20 bench' : 'S55'}: reads 0x80180000–0x801FFBFF (511 KiB). This is a partial DME memory region, not a complete DME image.',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('read-dme-2-start'),
            onPressed: _reading || !widget.canRead() ? null : _read,
            style: FilledButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            icon: _reading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.memory_outlined),
            label: Text(_reading ? 'Reading…' : 'Start read'),
          ),
          if (_reading)
            TextButton.icon(
              onPressed: widget.onCancel,
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('Cancel read'),
            ),
          const SizedBox(height: 24),
          Text('Saved reads', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (!_loading && _files.isEmpty)
            const Text('No Read DME 2 file saved for this vehicle yet.'),
          for (final artifact in _files)
            Card(
              key: Key('read-dme-2-file-${artifact.file.path}'),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      artifact.file.uri.pathSegments.last,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${artifact.size} bytes · ${artifact.savedAt.toLocal()}',
                    ),
                    const SizedBox(height: 4),
                    SelectableText('SHA-256 ${artifact.sha256}'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _deleting ? null : () => _share(artifact),
                          icon: const Icon(Icons.ios_share_outlined),
                          label: const Text('Share BIN'),
                        ),
                        TextButton.icon(
                          onPressed: _reading || _deleting
                              ? null
                              : () => _delete(artifact),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReadDme2File {
  const _ReadDme2File({
    required this.file,
    required this.size,
    required this.sha256,
    required this.savedAt,
  });

  final File file;
  final int size;
  final String sha256;
  final DateTime savedAt;
}
