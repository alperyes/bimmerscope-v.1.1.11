import 'dart:convert';
import 'dart:io';

import 'package:bmw_app/design/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'app_diagnostics_store.dart';

class AppDiagnosticsScreen extends StatefulWidget {
  const AppDiagnosticsScreen({
    super.key,
    required this.isDark,
    this.onExportCurrent,
  });
  final bool isDark;
  final Future<void> Function()? onExportCurrent;

  @override
  State<AppDiagnosticsScreen> createState() => _AppDiagnosticsScreenState();
}

class _AppDiagnosticsScreenState extends State<AppDiagnosticsScreen> {
  final store = AppDiagnosticsStore();
  final searchController = TextEditingController();
  late Future<List<File>> files = store.list();
  String filter = 'all';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void refresh() => setState(() => files = store.list());

  Future<void> share(File file) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'BimmerScope session diagnostics',
      ),
    );
  }

  Future<void> shareAll() async {
    final entries = await store.list();
    if (entries.isEmpty) return;
    await SharePlus.instance.share(
      ShareParams(
        files: entries.map((file) => XFile(file.path)).toList(),
        subject: 'BimmerScope diagnostics archive',
        text: 'BimmerScope archived connection sessions',
      ),
    );
  }

  Future<void> delete(File file) async {
    await store.delete(file);
    if (mounted) refresh();
  }

  Future<void> clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete saved diagnostics?'),
        content: const Text(
          'This removes every archived session from this device. Shared or exported copies are not affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await store.deleteAll();
      if (mounted) refresh();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('App diagnostics'),
      actions: [
        if (widget.onExportCurrent != null)
          IconButton(
            tooltip: 'Share current app state',
            onPressed: widget.onExportCurrent,
            icon: const Icon(Icons.ios_share_rounded),
          ),
        IconButton(
          tooltip: 'Refresh diagnostics',
          onPressed: refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    ),
    backgroundColor: AppPalette.background(widget.isDark),
    body: FutureBuilder<List<File>>(
      future: files,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final entries = snapshot.data!;
        final query = searchController.text.trim().toLowerCase();
        final filtered = entries.where((file) {
          final name = file.path
              .split(Platform.pathSeparator)
              .last
              .toLowerCase();
          final matchesQuery = query.isEmpty || name.contains(query);
          final matchesFilter =
              filter == 'all' ||
              (filter == 'sessions' && name.contains('session')) ||
              (filter == 'transport' && name.contains('raw_hsfz')) ||
              (filter == 'exports' &&
                  (name.contains('diagnostics') || name.contains('session_')));
          return matchesQuery && matchesFilter;
        }).toList();
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              _introCard(entries.length),
              const SizedBox(height: 14),
              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by file name',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('All')),
                  ButtonSegment(value: 'sessions', label: Text('Sessions')),
                  ButtonSegment(value: 'transport', label: Text('Transport')),
                  ButtonSegment(value: 'exports', label: Text('Exports')),
                ],
                selected: {filter},
                onSelectionChanged: (value) =>
                    setState(() => filter = value.first),
              ),
              const SizedBox(height: 14),
              if (entries.isEmpty)
                _emptyState()
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${filtered.length} matching file${filtered.length == 1 ? '' : 's'}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextButton(
                      onPressed: clearAll,
                      child: const Text('Clear all'),
                    ),
                    IconButton(
                      tooltip: 'Share all archives',
                      onPressed: shareAll,
                      icon: const Icon(Icons.share_outlined, size: 19),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      'No files match this filter.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppPalette.secondary(widget.isDark),
                      ),
                    ),
                  )
                else
                  for (final file in filtered) ...[
                    _fileTile(file),
                    const SizedBox(height: 9),
                  ],
              ],
            ],
          ),
        );
      },
    ),
  );

  Widget _introCard(int count) => Container(
    padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
    decoration: BoxDecoration(
      color: AppPalette.blue.withValues(alpha: widget.isDark ? .13 : .08),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppPalette.blue.withValues(alpha: .24)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.archive_outlined, color: AppPalette.blue, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            count == 0
                ? 'Sessions will be captured here automatically when you connect.'
                : 'Every connection is kept as an append-only session journal. Open one to inspect the timeline or share it with support.',
            style: const TextStyle(height: 1.4),
          ),
        ),
      ],
    ),
  );

  Widget _emptyState() => Padding(
    padding: const EdgeInsets.only(top: 58),
    child: Column(
      children: [
        Icon(
          Icons.description_outlined,
          size: 48,
          color: AppPalette.secondary(widget.isDark),
        ),
        const SizedBox(height: 12),
        const Text(
          'No archived sessions',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Text(
          'Connect once and the full app timeline will appear here.',
          style: TextStyle(color: AppPalette.secondary(widget.isDark)),
        ),
      ],
    ),
  );

  Widget _fileTile(File file) => FutureBuilder<_SessionSummary>(
    future: _summary(file),
    builder: (context, snapshot) {
      final summary = snapshot.data;
      return Material(
        color: AppPalette.surface(widget.isDark),
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(14, 6, 8, 6),
          leading: const Icon(Icons.timeline_rounded, color: AppPalette.blue),
          title: Text(
            summary?.title ?? 'Reading session…',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            summary?.subtitle ?? file.path.split(Platform.pathSeparator).last,
          ),
          trailing: PopupMenuButton<String>(
            tooltip: 'Session actions',
            onSelected: (value) async {
              if (value == 'share') await share(file);
              if (value == 'delete') await delete(file);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'share', child: Text('Share session')),
              PopupMenuItem(value: 'delete', child: Text('Delete session')),
            ],
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => AppDiagnosticDetailScreen(
                file: file,
                isDark: widget.isDark,
                onShare: () => share(file),
              ),
            ),
          ),
        ),
      );
    },
  );

  Future<_SessionSummary> _summary(File file) async {
    final lines = await file.readAsLines();
    Map<String, dynamic>? start;
    Map<String, dynamic>? end;
    var reconnects = 0;
    var pollRetries = 0;
    var gaps = 0;
    var warnings = 0;
    for (final line in lines) {
      try {
        final value = jsonDecode(line);
        if (value is Map<String, dynamic>) {
          if (value['type'] == 'session_start') start = value;
          if (value['type'] == 'telemetry_gap') gaps++;
          if (value['kind'] == 'reconnecting' || value['type'] == 'reconnect') {
            reconnects++;
          }
          if (value['kind'] == 'poll_retry') pollRetries++;
          if (value['kind'] == 'warning' || value['type'] == 'error') {
            warnings++;
          }
          if (value['type'] == 'session_end') end = value;
        }
      } catch (_) {}
    }
    final name = file.path.split(Platform.pathSeparator).last;
    final source = start?['source'] == null
        ? name.contains('App_Diagnostics')
              ? 'app state'
              : name.contains('Raw_HSFZ')
              ? 'raw transport'
              : 'session export'
        : '${start?['source']}';
    final vin = '${end?['vin'] ?? start?['vin'] ?? 'VIN pending'}';
    final timestamp =
        '${start?['timestamp'] ?? file.lastModifiedSync().toIso8601String()}'
            .replaceFirst('T', ' ');
    final shortTimestamp = timestamp.substring(
      0,
      timestamp.length < 19 ? timestamp.length : 19,
    );
    final issueSummary = [
      if (reconnects > 0) '$reconnects reconnect${reconnects == 1 ? '' : 's'}',
      if (pollRetries > 0)
        '$pollRetries same-socket poll retr${pollRetries == 1 ? 'y' : 'ies'}',
      if (gaps > 0) '$gaps telemetry gap${gaps == 1 ? '' : 's'}',
      if (warnings > 0) '$warnings warning${warnings == 1 ? '' : 's'}',
      if (end == null) 'open journal',
    ];
    return _SessionSummary(
      start == null ? source : '$source session',
      '$vin · $shortTimestamp · ${lines.length} records${issueSummary.isEmpty ? '' : ' · ${issueSummary.join(', ')}'}',
    );
  }
}

class _SessionSummary {
  const _SessionSummary(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

class AppDiagnosticDetailScreen extends StatelessWidget {
  const AppDiagnosticDetailScreen({
    super.key,
    required this.file,
    required this.isDark,
    required this.onShare,
  });
  final File file;
  final bool isDark;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Session detail'),
      actions: [
        IconButton(
          tooltip: 'Copy detail',
          onPressed: () async {
            final content = await _loadContent();
            await Clipboard.setData(ClipboardData(text: content.text));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Diagnostic detail copied')),
              );
            }
          },
          icon: const Icon(Icons.copy_all_rounded),
        ),
        IconButton(
          tooltip: 'Share session',
          onPressed: onShare,
          icon: const Icon(Icons.share_outlined),
        ),
      ],
    ),
    backgroundColor: AppPalette.background(isDark),
    body: FutureBuilder<_DiagnosticContent>(
      future: _loadContent(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to open this archive.',
                style: TextStyle(color: AppPalette.secondary(isDark)),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
        final content = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Text(
              file.path.split(Platform.pathSeparator).last,
              style: TextStyle(
                color: AppPalette.secondary(isDark),
                fontFamily: 'Geist Mono',
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 12),
            if (content.isBinary) ...[
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: AppPalette.orange.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppPalette.orange.withValues(alpha: .28),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.memory_rounded, color: AppPalette.orange),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Binary transport capture. A hex preview is shown; share the original file for protocol analysis.',
                        style: TextStyle(height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppPalette.surface(isDark),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SelectableText(
                content.text,
                style: const TextStyle(
                  fontFamily: 'Geist Mono',
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  Future<_DiagnosticContent> _loadContent() async {
    final bytes = await file.readAsBytes();
    final decoded = utf8.decode(bytes, allowMalformed: true);
    final binary =
        file.path.toLowerCase().endsWith('.log') && _looksBinary(bytes);
    if (binary) {
      final hex = bytes
          .take(512)
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join(' ');
      return _DiagnosticContent(
        'BINARY HSFZ CAPTURE\nbytes: ${bytes.length}\npreview: first ${bytes.take(512).length} bytes\n\n$hex',
        isBinary: true,
      );
    }
    final lines = decoded.trimRight().split('\n');
    return _DiagnosticContent(lines.map(_prettyLine).join('\n'));
  }

  bool _looksBinary(List<int> bytes) {
    if (bytes.isEmpty) return false;
    final sample = bytes.take(1024);
    final controlCount = sample
        .where((byte) => byte == 0 || (byte < 9) || (byte > 13 && byte < 32))
        .length;
    return controlCount / sample.length > .08;
  }

  String _prettyLine(String line) {
    try {
      final value = jsonDecode(line);
      if (value is Map<String, dynamic>) {
        return const JsonEncoder.withIndent('  ').convert(value);
      }
    } catch (_) {}
    return line;
  }
}

class _DiagnosticContent {
  const _DiagnosticContent(this.text, {this.isBinary = false});
  final String text;
  final bool isBinary;
}
