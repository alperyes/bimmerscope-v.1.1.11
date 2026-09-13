import 'dart:io';
import 'dart:math' as math;

import 'package:bmw_app/logging/data_logger.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/section_title.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bmw_app/logging/log_health_analysis.dart';
import 'package:bmw_app/logging/log_quality.dart';
import 'package:bmw_app/logging/log_sample.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onShowGuide,
    required this.connectionLabel,
    required this.isRecording,
    required this.sampleCount,
    required this.elapsed,
    required this.canRecord,
    required this.onToggleRecording,
    this.telemetryDegraded = false,
    this.telemetryGapCount = 0,
    this.maxTelemetryGapMs = 0,
    this.previewMode = false,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onShowGuide;
  final bool isRecording;
  final int sampleCount;
  final Duration elapsed;
  final bool canRecord;
  final Future<void> Function() onToggleRecording;
  final bool telemetryDegraded;
  final int telemetryGapCount;
  final int maxTelemetryGapMs;
  final bool previewMode;
  final String connectionLabel;

  @override
  State<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  List<File> files = [];
  bool loading = true;
  final searchController = TextEditingController();

  List<File> get filteredFiles {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return files;
    return files
        .where(
          (file) => file.uri.pathSegments.last.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    if (widget.previewMode) {
      if (mounted) setState(() => loading = false);
      return;
    }
    try {
      final result = await DataLogger.savedLogs();
      if (mounted) setState(() => files = result);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppPalette.background(widget.isDark),
    child: SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: header()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(child: recorderPanel()),
          ),
          if (!loading && files.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search saved logs',
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
              ),
            ),
          if (!loading && files.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: sectionTitleHeight,
                  child: Row(
                    children: [
                      const Spacer(),
                      Text(
                        '${filteredFiles.length} ${filteredFiles.length == 1 ? 'session' : 'sessions'}',
                        style: const TextStyle(
                          color: Color(0xFF7A8597),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Refresh logs',
                        onPressed: loadLogs,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (files.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insert_chart_outlined_rounded,
                        size: 44,
                        color: AppPalette.blue,
                      ),
                      const SizedBox(height: 13),
                      const Text(
                        'No saved logs yet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (widget.canRecord)
                        Text(
                          'Start a recording to create your first session.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppPalette.secondary(widget.isDark),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          else if (filteredFiles.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No logs match this search.',
                  style: TextStyle(color: AppPalette.secondary(widget.isDark)),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: filteredFiles.length,
                separatorBuilder: (_, _) => const SizedBox(height: 9),
                itemBuilder: (context, index) => logTile(filteredFiles[index]),
              ),
            ),
        ],
      ),
    ),
  );

  Widget header() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 20, 10, 12),
    child: SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/branding/bimmerscope_icon.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'BIMMERSCOPE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.7,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: const Offset(-2, 0),
              child: Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ConnectionStatusChip(
              label: widget.connectionLabel,
              isDark: widget.isDark,
              compact: true,
            ),
          ),
        ],
      ),
    ),
  );

  Widget recorderPanel() => Container(
    padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
    decoration: BoxDecoration(
      color: AppPalette.surface(widget.isDark),
      borderRadius: BorderRadius.circular(appCardRadius),
      border: Border.all(
        color: AppPalette.separator(widget.isDark).withValues(alpha: .45),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (widget.isRecording ? AppPalette.red : AppPalette.blue)
                .withValues(alpha: .13),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            widget.isRecording
                ? Icons.fiber_manual_record_rounded
                : Icons.show_chart_rounded,
            color: widget.isRecording ? AppPalette.red : AppPalette.blue,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isRecording ? 'Recording' : 'Data recorder',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.isRecording
                    ? '${formatDuration(widget.elapsed)} · ${widget.sampleCount} samples'
                    : widget.telemetryDegraded
                    ? 'Connection degraded · waiting for fresh samples'
                    : widget.telemetryGapCount == 0
                    ? 'CSV logs · no gaps recorded'
                    : 'CSV logs · ${widget.telemetryGapCount} gaps · max ${widget.maxTelemetryGapMs} ms',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppPalette.secondary(widget.isDark),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: widget.isRecording || widget.canRecord
              ? () async {
                  await widget.onToggleRecording();
                  await loadLogs();
                }
              : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(78, 44),
            backgroundColor: widget.isRecording
                ? AppPalette.red
                : AppPalette.blue,
          ),
          child: Text(widget.isRecording ? 'Stop' : 'Record'),
        ),
      ],
    ),
  );

  Widget logTile(File file) {
    final stat = file.statSync();
    final name = file.uri.pathSegments.last;
    return Container(
      padding: appCardPadding,
      decoration: BoxDecoration(
        color: AppPalette.surface(widget.isDark),
        borderRadius: BorderRadius.circular(appCardRadius),
        border: Border.all(
          color: AppPalette.separator(widget.isDark).withValues(alpha: .55),
        ),
      ),
      child: InkWell(
        onTap: () => showPlot(file),
        borderRadius: BorderRadius.circular(appCardRadius),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, color: AppPalette.blue),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatDate(stat.modified)} · ${formatBytes(stat.size)}',
                    style: const TextStyle(
                      color: Color(0xFF7A8597),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Save CSV log as…',
              onPressed: () => saveLog(file),
              icon: const Icon(Icons.save_alt_rounded),
            ),
            IconButton(
              tooltip: 'Share CSV log',
              onPressed: () async {
                final sidecar = File('${file.path}.sha256');
                await SharePlus.instance.share(
                  ShareParams(
                    files: [
                      XFile(file.path, mimeType: 'text/csv'),
                      if (await sidecar.exists())
                        XFile(sidecar.path, mimeType: 'text/plain'),
                    ],
                    subject: 'BimmerScope data log',
                    text: 'BimmerScope vehicle live-data log',
                  ),
                );
              },
              icon: const Icon(Icons.ios_share_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPlot(File file) async {
    final lines = await file.readAsLines();
    final points = <String, List<double>>{};
    final timedPoints = <String, List<LogSample>>{};
    final markers = <String>[];
    var loggedVehicle = 'Not identified';
    var loggedProfile = '';
    var durationSeconds = 0.0;
    for (final line in lines) {
      if (line.startsWith('# vehicle,')) {
        loggedVehicle = line.substring('# vehicle,'.length).trim();
        continue;
      }
      if (line.startsWith('# vehicle_profile,')) {
        loggedProfile = line.substring('# vehicle_profile,'.length).trim();
        continue;
      }
      if (line.startsWith('# marker,')) {
        final fields = _parseCsvLine(line.substring(2));
        if (fields.length >= 4) {
          final elapsed = int.tryParse(fields[2]) ?? 0;
          final label = fields[3].replaceAll('"', '').trim();
          markers.add(
            '${_LoggingScreenState.formatDuration(Duration(milliseconds: elapsed))} · $label',
          );
        }
        continue;
      }
      if (line.startsWith('#') || line.trim().isEmpty) {
        continue;
      }
      final fields = _parseCsvLine(line);
      if (fields.length < 6) {
        continue;
      }
      final value = double.tryParse(fields[4]);
      final elapsedMs = double.tryParse(fields[1]);
      if (elapsedMs != null) {
        durationSeconds = math.max(durationSeconds, elapsedMs / 1000);
      }
      if (value != null) {
        final name = fields[3].replaceAll('"', '');
        final unit = fields[5].replaceAll('"', '').trim();
        final label = unit.isEmpty ? name : '$name ($unit)';
        points.putIfAbsent(label, () => []).add(value);
        timedPoints
            .putIfAbsent(label, () => [])
            .add(LogSample(elapsedMs: (elapsedMs ?? 0).round(), value: value));
      }
    }
    final quality = await inspectLogQuality(
      file,
      vin: loggedVehicle,
      profileId: loggedProfile,
    );
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _LogPlotPage(
          fileName: file.uri.pathSegments.last,
          filePath: file.path,
          points: points,
          timedPoints: timedPoints,
          durationSeconds: durationSeconds,
          markers: markers,
          quality: quality,
        ),
      ),
    );
    /* showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .68,
          child: points.isEmpty
              ? const Center(child: Text('No numeric data in this session.'))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  children: [
                    Text(
                      file.uri.pathSegments.last,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...points.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: SizedBox(
                          height: 175,
                          child: _LogChart(
                            label: entry.key,
                            values: entry.value,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ); */
  }

  Future<void> saveLog(File file) async {
    try {
      final location = await getSaveLocation(
        suggestedName: file.uri.pathSegments.last,
        confirmButtonText: 'Save',
        acceptedTypeGroups: const [
          XTypeGroup(label: 'CSV data log', extensions: ['csv']),
        ],
      );
      if (location == null || !mounted) return;
      if (File(location.path).absolute.path == file.absolute.path) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This log is already saved there.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
      await XFile(file.path, mimeType: 'text/csv').saveTo(location.path);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CSV log saved.'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save the CSV log: $error')),
      );
    }
  }

  static String formatDuration(Duration value) {
    final minutes = value.inMinutes.toString().padLeft(2, '0');
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  static String formatBytes(int bytes) =>
      bytes < 1024 ? '$bytes B' : '${(bytes / 1024).toStringAsFixed(1)} KB';
}

/// Parses RFC-style CSV rows, including quoted fields containing commas.
List<String> _parseCsvLine(String line) {
  final fields = <String>[];
  final buffer = StringBuffer();
  var quoted = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (quoted && i + 1 < line.length && line[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else {
        quoted = !quoted;
      }
    } else if (char == ',' && !quoted) {
      fields.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  fields.add(buffer.toString());
  return fields;
}

enum _PlotAction { zoomOut, zoomIn, reset, timeScale, rename }

class _LogPlotPage extends StatefulWidget {
  const _LogPlotPage({
    required this.fileName,
    required this.filePath,
    required this.points,
    required this.timedPoints,
    required this.durationSeconds,
    required this.markers,
    required this.quality,
  });
  final String fileName;
  final String filePath;
  final Map<String, List<double>> points;
  final Map<String, List<LogSample>> timedPoints;
  final double durationSeconds;
  final List<String> markers;
  final LogQualityReport quality;

  @override
  State<_LogPlotPage> createState() => _LogPlotPageState();
}

class _LogPlotPageState extends State<_LogPlotPage> {
  late String _displayFileName = widget.fileName;
  static const _chartColors = <Color>[
    Color(0xFF4F8CFF),
    Color(0xFFFF8A5B),
    Color(0xFF33C79A),
    Color(0xFFB084F5),
    Color(0xFFF1C75B),
    Color(0xFFEC6FA8),
  ];
  late final List<ScrollController> _controllers;
  bool _syncing = false;
  double _zoom = 1;
  int? _cursorIndex;
  bool _cursorEnabled = false;
  int? _pullStart;
  int? _pullEnd;
  bool _sharedPlot = true;
  double _gestureZoomStart = 1;
  bool _useMinutes = false;
  late final Set<String> _visibleChannels = widget.points.keys.toSet();

  Map<String, List<double>> get _visiblePoints => {
    for (final entry in widget.points.entries)
      if (_visibleChannels.contains(entry.key)) entry.key: entry.value,
  };
  Map<String, List<LogSample>> get _visibleTimedPoints => {
    for (final entry in widget.timedPoints.entries)
      if (_visibleChannels.contains(entry.key)) entry.key: entry.value,
  };

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.points.length, (_) {
      final controller = ScrollController();
      controller.addListener(() {
        if (_syncing || !controller.hasClients) return;
        _syncing = true;
        for (final other in _controllers) {
          if (other != controller && other.hasClients) {
            final offset = controller.offset.clamp(
              0.0,
              other.position.maxScrollExtent,
            );
            other.jumpTo(offset);
          }
        }
        _syncing = false;
      });
      return controller;
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handlePlotAction(_PlotAction action) {
    switch (action) {
      case _PlotAction.zoomOut:
        setState(() => _zoom = math.max(1, _zoom - .25));
      case _PlotAction.zoomIn:
        setState(() => _zoom = math.min(4, _zoom + .25));
      case _PlotAction.timeScale:
        setState(() => _useMinutes = !_useMinutes);
      case _PlotAction.reset:
        setState(() {
          _zoom = 1;
          _cursorIndex = null;
          _cursorEnabled = false;
          for (final c in _controllers) {
            if (c.hasClients) c.jumpTo(0);
          }
        });
      case _PlotAction.rename:
        _renameFile();
    }
  }

  Future<void> _renameFile() async {
    final controller = TextEditingController(text: _displayFileName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename CSV file'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(suffixText: '.csv'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty) return;
    final clean = name.trim().toLowerCase().endsWith('.csv')
        ? name.trim()
        : '${name.trim()}.csv';
    try {
      final renamed = await File(widget.filePath).rename(
        '${File(widget.filePath).parent.path}${Platform.pathSeparator}$clean',
      );
      if (mounted) {
        setState(() => _displayFileName = renamed.uri.pathSegments.last);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not rename file: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Session', style: TextStyle(fontSize: 16)),
          Text(
            _displayFileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<_PlotAction>(
          tooltip: 'Session options',
          onSelected: _handlePlotAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _PlotAction.zoomOut,
              enabled: _zoom > 1,
              child: const Text('Zoom out'),
            ),
            PopupMenuItem(
              value: _PlotAction.zoomIn,
              enabled: _zoom < 4,
              child: Text('Zoom in · ${(_zoom * 100).round()}%'),
            ),
            const PopupMenuItem(
              value: _PlotAction.reset,
              child: Text('Reset view'),
            ),
            PopupMenuItem(
              value: _PlotAction.timeScale,
              child: Text(_useMinutes ? 'Use seconds' : 'Use minutes'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: _PlotAction.rename,
              child: Text('Rename CSV file'),
            ),
          ],
        ),
        IconButton(
          tooltip: _cursorEnabled ? 'Remove cursor' : 'Add cursor',
          onPressed: () => setState(() {
            _cursorEnabled = !_cursorEnabled;
            if (!_cursorEnabled) _cursorIndex = null;
          }),
          icon: Icon(
            _cursorEnabled ? Icons.close_rounded : Icons.my_location_rounded,
          ),
        ),
        IconButton(
          tooltip: 'Mark pull point',
          onPressed: _cursorIndex == null
              ? null
              : () => setState(() {
                  if (_pullStart == null || _pullEnd != null) {
                    _pullStart = _cursorIndex;
                    _pullEnd = null;
                  } else {
                    _pullEnd = _cursorIndex;
                  }
                }),
          icon: const Icon(Icons.flag_outlined),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.insights_rounded, size: 18),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '${widget.points.length} channels · ${widget.points.values.fold<int>(0, (total, values) => math.max(total, values.length))} samples · ${_LoggingScreenState.formatDuration(Duration(seconds: widget.durationSeconds.round()))}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _cursorEnabled ? 'Cursor synced' : 'Charts synced',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          widget.fileName,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        _sessionSummary(),
        const SizedBox(height: 10),
        _tunerReadinessCard(),
        if (widget.markers.isNotEmpty) ...[
          const SizedBox(height: 10),
          _markersCard(),
        ],
        if (_pullStart != null) ...[
          const SizedBox(height: 8),
          Text(
            _pullEnd == null
                ? 'Pull start marked at sample ${_pullStart! + 1}. Mark another cursor position for the end.'
                : 'Pull interval marked: samples ${_pullStart! + 1}–${_pullEnd! + 1}.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        if (analyzeLog(widget.points).isNotEmpty) ...[
          const SizedBox(height: 14),
          _healthFindingsCard(analyzeLog(widget.points)),
        ],
        const SizedBox(height: 16),
        _plotModeSelector(),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final channel in widget.points.keys)
                FilterChip(
                  label: Text(channel),
                  selected: _visibleChannels.contains(channel),
                  onSelected: (selected) => setState(
                    () => selected
                        ? _visibleChannels.add(channel)
                        : _visibleChannels.remove(channel),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_sharedPlot) _sharedPlotCard(),
        if (!_sharedPlot)
          ...widget.points.entries.toList().asMap().entries.map(
            (indexed) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Container(
                height: 195,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: .5),
                  ),
                ),
                child: _LogChart(
                  label: indexed.value.key,
                  values: indexed.value.value,
                  samples: widget.timedPoints[indexed.value.key],
                  color: _chartColors[indexed.key % _chartColors.length],
                  durationSeconds: widget.durationSeconds,
                  useMinutes: _useMinutes,
                  controller: _controllers[indexed.key],
                  zoom: _zoom,
                  cursorIndex: _cursorEnabled ? _cursorIndex : null,
                  onCursorTap: _cursorEnabled
                      ? (index) => setState(() => _cursorIndex = index)
                      : null,
                  onCursorDrag: _cursorEnabled
                      ? (index) => setState(() => _cursorIndex = index)
                      : null,
                  onScaleStart: () => _gestureZoomStart = _zoom,
                  onScaleUpdate: (scale) => setState(() {
                    _zoom = (_gestureZoomStart * scale).clamp(1.0, 4.0);
                  }),
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Widget _markersCard() => Card(
    margin: EdgeInsets.zero,
    child: ExpansionTile(
      initiallyExpanded: true,
      leading: const Icon(Icons.flag_outlined),
      title: const Text(
        'Log markers',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        '${widget.markers.length} marked event${widget.markers.length == 1 ? '' : 's'}',
      ),
      children: widget.markers
          .map(
            (marker) => ListTile(
              dense: true,
              leading: const Icon(Icons.bookmark_outline_rounded, size: 18),
              title: Text(marker),
            ),
          )
          .toList(),
    ),
  );

  Widget _plotModeSelector() => SegmentedButton<bool>(
    segments: const [
      ButtonSegment(
        value: true,
        icon: Icon(Icons.layers_rounded),
        label: Text('Shared plot'),
      ),
      ButtonSegment(
        value: false,
        icon: Icon(Icons.view_agenda_rounded),
        label: Text('Separate plots'),
      ),
    ],
    selected: {_sharedPlot},
    onSelectionChanged: (selection) =>
        setState(() => _sharedPlot = selection.first),
  );

  Widget _sharedPlotCard() => Container(
    height: 290,
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).dividerColor.withValues(alpha: .5),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All channels',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: widget.points.keys
              .toList()
              .asMap()
              .entries
              .map(
                (entry) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: _chartColors[entry.key % _chartColors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: Text(
                        entry.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _SharedLogChart(
            points: _visiblePoints,
            timedPoints: _visibleTimedPoints,
            colors: _chartColors,
            durationSeconds: widget.durationSeconds,
            useMinutes: _useMinutes,
            zoom: _zoom,
          ),
        ),
      ],
    ),
  );

  Widget _sessionSummary() {
    final rows = widget.points.entries
        .map((entry) {
          final values = entry.value;
          if (values.isEmpty) return null;
          final minimum = values.reduce(math.min);
          final maximum = values.reduce(math.max);
          final average = values.reduce((a, b) => a + b) / values.length;
          return (
            label: entry.key,
            minimum: minimum,
            maximum: maximum,
            average: average,
          );
        })
        .whereType<
          ({String label, double minimum, double maximum, double average})
        >()
        .toList();
    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.analytics_outlined),
        title: const Text(
          'Session summary',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text('${rows.length} channels · min / average / max'),
        children: rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        row.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${row.minimum.toStringAsFixed(1)}  /  ${row.average.toStringAsFixed(1)}  /  ${row.maximum.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _tunerReadinessCard() {
    final quality = widget.quality;
    final ready = quality.suitableForTunerReview;
    final color = ready ? AppPalette.green : AppPalette.orange;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ready ? Icons.verified_outlined : Icons.rule_outlined, color: color, size: 19),
              const SizedBox(width: 8),
              Text(
                ready ? 'Ready for tuner review' : 'Review before sending',
                style: TextStyle(fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            ready
                ? '${quality.sampleCount} samples · ${_LoggingScreenState.formatDuration(Duration(milliseconds: quality.durationMs))} · ${quality.channels.length} channels'
                : quality.reasons.join(' '),
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _healthFindingsCard(List<LogHealthFinding> findings) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review flags',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        for (final finding in findings)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '• ${finding.message}',
              style: TextStyle(
                color: finding.severity == LogFindingSeverity.warning
                    ? Colors.orange
                    : null,
              ),
            ),
          ),
        Text(
          'Conservative review only; confirm units and vehicle-specific limits with your tuner.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class _SharedLogChart extends StatelessWidget {
  const _SharedLogChart({
    required this.points,
    required this.timedPoints,
    required this.colors,
    required this.durationSeconds,
    required this.useMinutes,
    required this.zoom,
  });
  final Map<String, List<double>> points;
  final Map<String, List<LogSample>> timedPoints;
  final List<Color> colors;
  final double durationSeconds;
  final bool useMinutes;
  final double zoom;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width:
          math.max(
            360,
            // Scale the viewport from the recorded session duration so
            // sparse/uneven logs retain visible horizontal space.
            math.max(1.0, useMinutes ? durationSeconds / 60 : durationSeconds) *
                (useMinutes ? 90.0 : 45.0),
          ) *
          zoom,
      child: CustomPaint(
        painter: _SharedLogChartPainter(
          points,
          timedPoints,
          colors,
          durationSeconds,
          useMinutes,
        ),
        child: const SizedBox.expand(),
      ),
    ),
  );
}

class _SharedLogChartPainter extends CustomPainter {
  _SharedLogChartPainter(
    this.points,
    this.timedPoints,
    this.colors,
    this.durationSeconds,
    this.useMinutes,
  );
  final Map<String, List<double>> points;
  final Map<String, List<LogSample>> timedPoints;
  final List<Color> colors;
  final double durationSeconds;
  final bool useMinutes;

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height - 22;
    canvas.drawLine(
      Offset(0, chartHeight),
      Offset(size.width, chartHeight),
      Paint()..color = const Color(0xFF8A94A6),
    );
    var index = 0;
    for (final values in points.values) {
      if (values.isEmpty) continue;
      final min = values.reduce(math.min), max = values.reduce(math.max);
      final span = (max - min).abs() < .0001 ? 1 : max - min;
      final path = Path();
      final samples =
          timedPoints[points.keys.elementAt(index)] ?? const <LogSample>[];
      for (var i = 0; i < values.length; i++) {
        final x = samples.length == values.length && durationSeconds > 0
            ? (samples[i].elapsedMs / 1000) / durationSeconds * size.width
            : i * size.width / math.max(1, values.length - 1);
        final y =
            4 + chartHeight - ((values[i] - min) / span) * (chartHeight - 8);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = colors[index++ % colors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.3,
      );
    }
    final suffix = useMinutes ? 'min' : 's';
    final end = useMinutes ? durationSeconds / 60 : durationSeconds;
    final labels = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: '0$suffix',
        style: const TextStyle(fontSize: 9, color: Color(0xFF7A8597)),
      );
    labels.layout();
    labels.paint(canvas, Offset(0, chartHeight + 4));
    labels.text = TextSpan(
      text: '${end.toStringAsFixed(1)}$suffix',
      style: const TextStyle(fontSize: 9, color: Color(0xFF7A8597)),
    );
    labels.layout();
    labels.paint(canvas, Offset(size.width - labels.width, chartHeight + 4));
  }

  @override
  bool shouldRepaint(covariant _SharedLogChartPainter old) =>
      old.useMinutes != useMinutes || old.durationSeconds != durationSeconds;
}

class _LogChart extends StatelessWidget {
  const _LogChart({
    required this.label,
    required this.values,
    this.samples,
    required this.color,
    required this.durationSeconds,
    required this.useMinutes,
    required this.controller,
    required this.zoom,
    required this.cursorIndex,
    required this.onCursorTap,
    required this.onCursorDrag,
    required this.onScaleStart,
    required this.onScaleUpdate,
  });
  final String label;
  final List<double> values;
  final List<LogSample>? samples;
  final Color color;
  final double durationSeconds;
  final bool useMinutes;
  final ScrollController controller;
  final double zoom;
  final int? cursorIndex;
  final ValueChanged<int>? onCursorTap;
  final ValueChanged<int>? onCursorDrag;
  final VoidCallback onScaleStart;
  final ValueChanged<double> onScaleUpdate;
  @override
  Widget build(BuildContext context) {
    var draggingCursor = false;
    final pointWidth = useMinutes ? 3.0 : 6.0;
    final contentWidth = math.max(360, values.length * pointWidth) * zoom;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 34,
                child: CustomPaint(painter: _LogAxisPainter(values)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: contentWidth,
                    child: GestureDetector(
                      onScaleStart: (_) => onScaleStart(),
                      onScaleUpdate: (details) => onScaleUpdate(details.scale),
                      onHorizontalDragStart: (details) {
                        final cursorX = cursorIndex == null || values.length < 2
                            ? double.negativeInfinity
                            : _xForIndex(cursorIndex!, contentWidth);
                        draggingCursor =
                            onCursorDrag != null &&
                            (details.localPosition.dx - cursorX).abs() < 28;
                      },
                      onHorizontalDragUpdate: (details) {
                        if (draggingCursor && onCursorDrag != null) {
                          final x = details.localPosition.dx.clamp(
                            0.0,
                            contentWidth,
                          );
                          onCursorDrag!(
                            (x / contentWidth * math.max(1, values.length - 1))
                                .round()
                                .clamp(0, math.max(0, values.length - 1))
                                .toInt(),
                          );
                        } else if (controller.hasClients) {
                          controller.jumpTo(
                            (controller.offset - details.delta.dx).clamp(
                              0.0,
                              controller.position.maxScrollExtent,
                            ),
                          );
                        }
                      },
                      onTapDown: onCursorTap == null
                          ? null
                          : (details) {
                              final index =
                                  (details.localPosition.dx /
                                          contentWidth *
                                          math.max(1, values.length - 1))
                                      .round()
                                      .clamp(0, math.max(0, values.length - 1))
                                      .toInt();
                              onCursorTap!(index);
                            },
                      child: CustomPaint(
                        painter: _LogChartPainter(
                          values,
                          color,
                          cursorIndex,
                          label,
                          durationSeconds,
                          useMinutes,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _xForIndex(int index, double width) {
    final points = samples;
    if (points != null &&
        points.length == values.length &&
        durationSeconds > 0) {
      return points[index].elapsedMs / 1000 / durationSeconds * width;
    }
    return index * width / math.max(1, values.length - 1);
  }
}

class _LogChartPainter extends CustomPainter {
  _LogChartPainter(
    this.values,
    this.color,
    this.cursorIndex,
    this.label,
    this.durationSeconds,
    this.useMinutes,
  );
  final List<double> values;
  final Color color;
  final int? cursorIndex;
  final String label;
  final double durationSeconds;
  final bool useMinutes;
  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final min = values.reduce(math.min), max = values.reduce(math.max);
    final span = (max - min).abs() < .0001 ? 1 : max - min;
    final axis = Paint()
      ..color = const Color(0xFF8A94A6)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 22),
      Offset(size.width, size.height - 22),
      axis,
    );
    final labels = TextPainter(textDirection: TextDirection.ltr);
    final displayDuration = useMinutes ? durationSeconds / 60 : durationSeconds;
    final suffix = useMinutes ? 'min' : 's';
    labels.text = TextSpan(
      text: '0$suffix',
      style: TextStyle(fontSize: 9, color: Color(0xFF7A8597)),
    );
    labels.layout();
    labels.paint(canvas, Offset(0, size.height - 16));
    labels.text = TextSpan(
      text: 'Time ($suffix)',
      style: const TextStyle(fontSize: 9, color: Color(0xFF7A8597)),
    );
    labels.layout();
    labels.paint(
      canvas,
      Offset(size.width / 2 - labels.width / 2, size.height - 16),
    );
    labels.text = TextSpan(
      text: '${displayDuration.toStringAsFixed(1)}$suffix',
      style: const TextStyle(fontSize: 9, color: Color(0xFF7A8597)),
    );
    labels.layout();
    labels.paint(canvas, Offset(size.width - labels.width, size.height - 16));
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i * size.width / math.max(1, values.length - 1);
      final y =
          4 +
          (size.height - 26) -
          ((values[i] - min) / span) * (size.height - 30);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    if (cursorIndex != null && values.length > 1) {
      final x =
          cursorIndex!.clamp(0, values.length - 1) *
          size.width /
          (values.length - 1);
      canvas.drawLine(
        Offset(x, 4),
        Offset(x, size.height - 22),
        Paint()
          ..color = const Color(0xFFFFC857)
          ..strokeWidth = 1.5,
      );
      final reading = values[cursorIndex!.clamp(0, values.length - 1)];
      final displayLabel = label.replaceAll('_', ' ');
      final badge = TextPainter(
        text: TextSpan(
          text: '$displayLabel  ${reading.toStringAsFixed(1)}',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final badgeX = (x - badge.width / 2).clamp(
        4.0,
        size.width - badge.width - 4.0,
      );
      final badgeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(badgeX, 5, badge.width + 8, badge.height + 6),
        const Radius.circular(5),
      );
      canvas.drawRRect(badgeRect, Paint()..color = color.withValues(alpha: .9));
      badge.paint(canvas, Offset(badgeX + 4, 8));
    }
  }

  @override
  bool shouldRepaint(covariant _LogChartPainter old) =>
      old.values != values ||
      old.color != color ||
      old.cursorIndex != cursorIndex ||
      old.label != label ||
      old.durationSeconds != durationSeconds ||
      old.useMinutes != useMinutes;
}

class _LogAxisPainter extends CustomPainter {
  _LogAxisPainter(this.values);
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final axis = Paint()
      ..color = const Color(0xFF8A94A6)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width - 1, 4),
      Offset(size.width - 1, size.height - 22),
      axis,
    );
    final min = values.reduce(math.min), max = values.reduce(math.max);
    final labels = TextPainter(textDirection: TextDirection.ltr);
    for (final item in [
      (text: max.toStringAsFixed(1), y: 0.0),
      (text: min.toStringAsFixed(1), y: size.height - 32),
    ]) {
      labels.text = TextSpan(
        text: item.text,
        style: const TextStyle(fontSize: 9, color: Color(0xFF7A8597)),
      );
      labels.layout();
      labels.paint(canvas, Offset(0, item.y));
    }
  }

  @override
  bool shouldRepaint(covariant _LogAxisPainter old) => old.values != values;
}
