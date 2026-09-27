import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/diagnostics/fault_definitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:bmw_app/vehicle/simulator_transport.dart';

class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onShowGuide,
    required this.connectionLabel,
    required this.vin,
    this.onBeforeVehicleScan,
    this.onAfterVehicleScan,
    this.onScanEvent,
    this.onSetFlapMode,
    this.previewMode = false,
    this.simulatorMode = false,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onShowGuide;
  final bool previewMode;
  final bool simulatorMode;
  final String connectionLabel;
  final String vin;
  final Future<void> Function()? onBeforeVehicleScan;
  final Future<void> Function()? onAfterVehicleScan;
  final void Function(String message)? onScanEvent;
  final Future<void> Function(String mode)? onSetFlapMode;

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DtcSnapshot {
  const _DtcSnapshot(
    this.time,
    this.faults, {
    this.vin = '',
    this.durationMs = 0,
    this.operation = 'Scan',
  });
  final DateTime time;
  final List<DiagnosticTroubleCode> faults;
  final String vin;
  final int durationMs;
  final String operation;
}

enum _DiagnosticsViewState {
  disconnected,
  discovering,
  connected,
  scanning,
  results,
  connectionLost,
  unsupported,
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  var faults = <DiagnosticTroubleCode>[];
  bool scanning = false;
  bool hasScanned = false;
  bool demoProfile = false;
  bool demoScan = false;
  bool clearing = false;
  bool flapTestRunning = false;
  int flapTestStep = 0;
  String? error;
  DateTime? scannedAt;
  String scanStage = 'Ready to scan';
  final List<_DtcSnapshot> history = [];

  bool get _vehicleAvailable {
    if (widget.previewMode) return true;
    return switch (widget.connectionLabel.trim().toLowerCase()) {
      'connected' || 'monitoring' || 'degraded' => true,
      _ => false,
    };
  }

  _DiagnosticsViewState get _viewState {
    if (scanning) return _DiagnosticsViewState.scanning;
    if (hasScanned && error == null) return _DiagnosticsViewState.results;
    final connection = widget.connectionLabel.trim().toLowerCase();
    if (connection == 'unsupported') {
      return _DiagnosticsViewState.unsupported;
    }
    if (connection == 'recovering' || connection == 'error') {
      return _DiagnosticsViewState.connectionLost;
    }
    if ({'searching', 'connecting', 'identifying'}.contains(connection)) {
      return _DiagnosticsViewState.discovering;
    }
    if (_vehicleAvailable) return _DiagnosticsViewState.connected;
    return _DiagnosticsViewState.disconnected;
  }

  ({String title, String detail, IconData icon, Color color})
  get _statePresentation => switch (_viewState) {
    _DiagnosticsViewState.disconnected => (
      title: 'Connect vehicle',
      detail: 'Connect the ENET cable and switch the ignition on.',
      icon: Icons.link_off_rounded,
      color: AppPalette.status(AppStatusTone.neutral, widget.isDark),
    ),
    _DiagnosticsViewState.discovering => (
      title: 'Finding vehicle',
      detail: 'Keep the cable connected and ignition on.',
      icon: Icons.radar_rounded,
      color: AppPalette.status(AppStatusTone.active, widget.isDark),
    ),
    _DiagnosticsViewState.connected => (
      title: 'Ready to scan',
      detail: 'Live monitoring will pause while diagnostics are read.',
      icon: Icons.manage_search_rounded,
      color: AppPalette.status(AppStatusTone.neutral, widget.isDark),
    ),
    _DiagnosticsViewState.scanning => (
      title: scanStage,
      detail: 'Reading the active vehicle session.',
      icon: Icons.manage_search_rounded,
      color: AppPalette.status(AppStatusTone.active, widget.isDark),
    ),
    _DiagnosticsViewState.results => (
      title: 'Results available',
      detail:
          '${faults.length} ${faults.length == 1 ? 'fault' : 'faults'} found in the latest scan.',
      icon: Icons.fact_check_rounded,
      color: AppPalette.status(
        faults.isEmpty ? AppStatusTone.success : AppStatusTone.warning,
        widget.isDark,
      ),
    ),
    _DiagnosticsViewState.connectionLost => (
      title: 'Connection interrupted',
      detail: 'Wait for recovery or reconnect before starting another scan.',
      icon: Icons.sync_problem_rounded,
      color: AppPalette.status(AppStatusTone.warning, widget.isDark),
    ),
    _DiagnosticsViewState.unsupported => (
      title: 'Vehicle not supported',
      detail: 'Diagnostics are unavailable for this vehicle profile.',
      icon: Icons.block_rounded,
      color: AppPalette.status(AppStatusTone.danger, widget.isDark),
    ),
  };

  @override
  void initState() {
    super.initState();
    _restoreHistory();
  }

  @override
  void didUpdateWidget(covariant DiagnosticsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _restoreHistory() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString('diagnostic_scan_history');
    if (encoded == null) return;
    try {
      final stored = (jsonDecode(encoded) as List<dynamic>).map((snapshot) {
        final map = snapshot as Map<String, dynamic>;
        final storedFaults = (map['faults'] as List<dynamic>).map((item) {
          final fault = item as Map<String, dynamic>;
          return DiagnosticTroubleCode(
            code: fault['code'] as String,
            rawCode: fault['rawCode'] as int,
            status: fault['status'] as int,
            statusText: fault['statusText'] as String,
            ecu: fault['ecu'] as String,
          );
        }).toList();
        return _DtcSnapshot(
          DateTime.parse(map['time'] as String),
          storedFaults,
          vin: map['vin'] as String? ?? '',
          durationMs: map['durationMs'] as int? ?? 0,
          operation: map['operation'] as String? ?? 'Scan',
        );
      }).toList();
      if (!mounted || stored.isEmpty) return;
      setState(() {
        history.addAll(stored.take(20));
      });
    } catch (_) {
      await preferences.remove('diagnostic_scan_history');
    }
  }

  Future<void> _saveHistory() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = history
        .map(
          (snapshot) => {
            'time': snapshot.time.toIso8601String(),
            'vin': snapshot.vin,
            'durationMs': snapshot.durationMs,
            'operation': snapshot.operation,
            'faults': snapshot.faults
                .map(
                  (fault) => {
                    'code': fault.code,
                    'rawCode': fault.rawCode,
                    'status': fault.status,
                    'statusText': fault.statusText,
                    'ecu': fault.ecu,
                  },
                )
                .toList(),
          },
        )
        .toList();
    await preferences.setString('diagnostic_scan_history', jsonEncode(encoded));
  }

  String get engineProfile => widget.previewMode || demoProfile
      ? 'S55 · DME'
      : 'Engine DME/DDE · awaiting identification';

  Future<void> scan({bool demo = false}) async {
    if (scanning || (!demo && !_vehicleAvailable)) {
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      scanning = true;
      scanStage = 'Preparing…';
      error = null;
      demoProfile = demo;
      demoScan = demo || widget.simulatorMode;
    });
    widget.onScanEvent?.call('Scan started${demo ? ' (demo)' : ''}');
    final stopwatch = Stopwatch()..start();
    var sessionPaused = false;
    try {
      if (!demo &&
          !widget.simulatorMode &&
          widget.onBeforeVehicleScan != null) {
        await widget.onBeforeVehicleScan!();
        sessionPaused = true;
      }
      if (mounted) setState(() => scanStage = 'Reading ECUs…');
      final result = demo
          ? (widget.previewMode ? previewFaults : demoDiagnostics())
          : widget.simulatorMode
          ? await scanSimulatorDiagnostics()
          : await scanEngineDiagnostics();
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      setState(() {
        faults = result;
        scanStage = 'Scan complete';
        hasScanned = true;
        scannedAt = DateTime.now();
        stopwatch.stop();
        history.insert(
          0,
          _DtcSnapshot(
            scannedAt!,
            List.of(result),
            vin: widget.vin,
            durationMs: stopwatch.elapsedMilliseconds,
            operation: 'DME scan',
          ),
        );
        if (history.length > 20) history.removeLast();
      });
      widget.onScanEvent?.call(
        'Scan completed: ${result.length} fault records',
      );
      await _saveHistory();
    } catch (exception) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() {
        error = exception.toString();
        scanStage = 'Scan failed';
        hasScanned = true;
      });
      widget.onScanEvent?.call('Scan failed: $exception');
    } finally {
      if (sessionPaused && widget.onAfterVehicleScan != null) {
        await widget.onAfterVehicleScan!();
      }
      if (mounted) setState(() => scanning = false);
    }
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
            sliver: SliverToBoxAdapter(child: scanPanel()),
          ),
          if (hasScanned || history.isNotEmpty || flapTestRunning)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(child: resultsHeader()),
            ),
          if (error != null)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(child: errorPanel()),
            )
          else if (hasScanned && faults.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverToBoxAdapter(child: healthyState()),
            )
          else if (!hasScanned && !_vehicleAvailable)
            SliverToBoxAdapter(child: disconnectedState())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: faults.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) => faultCard(faults[index]),
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
              iconOnly: true,
            ),
          ),
        ],
      ),
    ),
  );

  Widget scanPanel() => Container(
    height: appTopActionCardHeight,
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
    decoration: BoxDecoration(
      color: AppPalette.surface(widget.isDark),
      borderRadius: BorderRadius.circular(appCardRadius),
      border: Border.all(
        color: AppPalette.separator(widget.isDark).withValues(alpha: .45),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppPalette.blue.withValues(alpha: .13),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.health_and_safety_rounded,
                color: AppPalette.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Engine DME/DDE',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _statePresentation.title,
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
          ],
        ),
        const Spacer(),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            key: const Key('diagnostics-scan-button'),
            onPressed: scanning || !_vehicleAvailable ? null : () => scan(),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: Colors.white,
            ),
            icon: scanning
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.manage_search_rounded, size: 20),
            label: Text(scanning ? scanStage : 'Scan'),
          ),
        ),
      ],
    ),
  );

  Widget resultsHeader() => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (hasScanned || history.isNotEmpty)
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: AppPalette.red),
                onPressed: clearing || faults.isEmpty
                    ? null
                    : demoScan
                    ? clearDemoCodes
                    : clearVehicleCodes,
                icon: clearing
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_sweep_rounded, size: 18),
                label: Text(clearing ? 'Clearing…' : 'Clear codes'),
              ),
            if (hasScanned && error == null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppPalette.secondary(
                    widget.isDark,
                  ).withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${faults.length} ${faults.length == 1 ? 'fault' : 'faults'}',
                  style: TextStyle(
                    color: AppPalette.secondary(widget.isDark),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (hasScanned && faults.isNotEmpty)
              IconButton(
                tooltip: 'Export fault report',
                onPressed: exportReport,
                icon: const Icon(Icons.ios_share_rounded, size: 18),
              ),
            if (history.isNotEmpty)
              IconButton(
                tooltip: 'Scan history',
                onPressed: showHistory,
                icon: const Icon(Icons.history_rounded),
              ),
          ],
        ),
        if (flapTestRunning) ...[
          const SizedBox(height: 8),
          LinearProgressIndicator(value: flapTestStep / 9),
          const SizedBox(height: 6),
          Text(
            'Exhaust flap test in progress — cycle ${flapTestStep.clamp(1, 8)} of 8',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ],
    ),
  );

  Future<void> showHistory() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                child: Semantics(
                  header: true,
                  child: Text(
                    'Scan history',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final hasFaults = item.faults.isNotEmpty;
                    return Semantics(
                      container: true,
                      button: true,
                      label:
                          '${item.operation}, ${_formatSnapshotTime(item.time)}, '
                          '${hasFaults ? _historyFaultSummary(item.faults) : 'no stored faults'}'
                          '${index == 0 ? ', latest' : ''}',
                      child: ListTile(
                        leading: Icon(
                          hasFaults
                              ? Icons.warning_amber_rounded
                              : Icons.verified_rounded,
                          color: hasFaults
                              ? AppPalette.orange
                              : AppPalette.green,
                        ),
                        title: Text(item.operation),
                        subtitle: Text(
                          '${_formatSnapshotTime(item.time)} · ${hasFaults ? '${item.faults.length} ${item.faults.length == 1 ? 'fault' : 'faults'}' : 'no faults'}\n${hasFaults ? _historyFaultSummary(item.faults) : 'DME reported no stored faults'}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: index == 0
                            ? const Chip(
                                label: Text('Latest'),
                                visualDensity: VisualDensity.compact,
                              )
                            : null,
                        onTap: () {
                          Navigator.pop(context);
                          _showSnapshotDetails(item);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSnapshotTime(DateTime time) =>
      '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year} '
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _historyFaultSummary(List<DiagnosticTroubleCode> snapshotFaults) {
    final codes = snapshotFaults.take(3).map((fault) => fault.code).join(', ');
    final remaining = snapshotFaults.length - 3;
    return remaining > 0 ? '$codes +$remaining more' : codes;
  }

  Future<void> _showSnapshotDetails(_DtcSnapshot snapshot) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * .78,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              Text(
                snapshot.operation,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatSnapshotTime(snapshot.time)}${snapshot.vin.isEmpty ? '' : ' · ${snapshot.vin}'}',
                style: const TextStyle(color: Color(0xFF7A8597), fontSize: 12),
              ),
              const SizedBox(height: 16),
              if (snapshot.faults.isEmpty)
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.verified_rounded,
                    color: AppPalette.green,
                  ),
                  title: Text('No stored DME faults'),
                  subtitle: Text(
                    'The DME verification returned no fault records.',
                  ),
                )
              else
                ...snapshot.faults.map((fault) => _historyFaultDetail(fault)),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    faults = List.of(snapshot.faults);
                    scannedAt = snapshot.time;
                  });
                  Navigator.pop(sheetContext);
                },
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('Show these results on Diagnostics'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _historyFaultDetail(DiagnosticTroubleCode fault) {
    final definition = faultDefinition(fault.code);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppPalette.surface(widget.isDark),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fault.code,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          Text(
            '${fault.ecu} · ${fault.statusText}',
            style: const TextStyle(color: Color(0xFF7A8597), fontSize: 11),
          ),
          const SizedBox(height: 7),
          Text(
            definition?.title ?? 'BMW-specific fault',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            definition?.explanation ?? 'Definition unavailable.',
            style: const TextStyle(fontSize: 11, height: 1.35),
          ),
        ],
      ),
    );
  }

  Future<void> exportReport() async {
    final directory = await getTemporaryDirectory();
    final now = DateTime.now();
    final stamp =
        '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}_'
        '${now.millisecond.toString().padLeft(3, '0')}';
    final file = File(
      '${directory.path}${Platform.pathSeparator}BimmerScope_DTC_Report_$stamp.txt',
    );
    final lines = <String>[
      'BIMMERSCOPE DTC REPORT',
      'Vehicle profile: $engineProfile',
      'Connection: ${widget.connectionLabel}',
      'Scanned: ${scannedAt ?? DateTime.now()}',
      'Faults in scan: ${faults.length}',
      'Faults exported: ${faults.length}',
      '',
    ];
    if (faults.isEmpty) {
      lines.add('No faults found.');
    } else {
      lines.addAll([
        'CODE | STATUS | ECU | DESCRIPTION',
        ...faults.map(
          (fault) =>
              '${fault.code} | ${fault.statusText} | ${fault.ecu} | ${faultDefinition(fault.code)?.title ?? 'Definition unavailable'}',
        ),
      ]);
    }
    await file.writeAsString(
      const LineSplitter().convert(lines.join('\n')).join('\n'),
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/plain')],
        subject: 'BimmerScope DTC report',
      ),
    );
  }

  Future<void> clearDemoCodes() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.simulatorMode ? 'Clear simulator codes?' : 'Clear demo codes?',
        ),
        content: const Text(
          'This clears simulated fault records only. No command will be sent to a vehicle.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      if (widget.simulatorMode) {
        try {
          await clearSimulatorDiagnostics();
        } catch (exception) {
          final transportClosed = exception.toString().toLowerCase().contains(
            'connection reset',
          );
          if (transportClosed) {
            // The simulator applies the clear, then closes its short-lived
            // HTTP socket before Dart finishes reading the response.
          } else {
            // Some desktop Python HTTP servers close the socket immediately
            // after sending the clear response. Confirm the state before
            // surfacing a misleading "connection reset" message.
            try {
              final remaining = await scanSimulatorDiagnostics();
              if (remaining.isEmpty) {
                // The simulator cleared successfully despite the closed socket.
              } else {
                rethrow;
              }
            } catch (_) {
              if (mounted) setState(() => error = exception.toString());
              return;
            }
          }
        }
      }
      setState(() {
        faults = [];
        scannedAt = DateTime.now();
      });
      await _saveHistory();
    }
  }

  Future<void> clearVehicleCodes() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear stored DTCs?'),
        content: const Text(
          'This sends a broadcast clear-fault command. Any responding vehicle '
          'module may clear its stored DTCs; BimmerScope then verifies the S55 DME directly. '
          'Only continue with the vehicle stationary, ignition on, and the '
          'cause of the fault understood. The command cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear DTCs'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      error = null;
      clearing = true;
    });
    try {
      final preClearFaults = List<DiagnosticTroubleCode>.of(faults);
      final preClearTime = DateTime.now();
      setState(() {
        history.insert(
          0,
          _DtcSnapshot(
            preClearTime,
            preClearFaults,
            vin: widget.vin,
            operation: 'Pre-clear DTC snapshot',
          ),
        );
        if (history.length > 20) history.removeLast();
      });
      await _saveHistory();
      widget.onScanEvent?.call(
        'DTC clear requested; pre-clear DME snapshot: '
        '${preClearFaults.isEmpty ? 'no stored faults' : preClearFaults.map((fault) => fault.code).join(', ')}',
      );
      await widget.onBeforeVehicleScan?.call();
      late final List<DiagnosticTroubleCode> remaining;
      try {
        remaining = await clearEngineDiagnostics();
      } finally {
        await widget.onAfterVehicleScan?.call();
      }
      if (!mounted) return;
      setState(() {
        faults = remaining;
        scannedAt = DateTime.now();
        history.insert(
          0,
          _DtcSnapshot(
            scannedAt!,
            List.of(remaining),
            vin: widget.vin,
            operation: 'Post-clear DME verification',
          ),
        );
        if (history.length > 20) history.removeLast();
      });
      await _saveHistory();
      widget.onScanEvent?.call(
        'DTC clear verified on DME: '
        '${remaining.isEmpty ? 'no stored faults remain' : '${remaining.length} fault record(s) remain'}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              remaining.isEmpty
                  ? 'DME clear confirmed — no stored faults remain.'
                  : 'DME clear completed — ${remaining.length} fault record(s) remain.',
            ),
          ),
        );
      }
    } catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    } finally {
      if (mounted) setState(() => clearing = false);
    }
  }

  Future<void> runExhaustFlapServiceTest() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Run exhaust flap service test?'),
        content: const Text(
          'Experimental F82/S55 DME test captured from ISTA. The flap must be connected. '
          'This may move the flap to an installation position and is not open/close control.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Run test'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      error = null;
      flapTestRunning = true;
      flapTestStep = 1;
    });
    try {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await widget.onBeforeVehicleScan?.call();
      try {
        await experimentalExhaustFlapServiceTest();
      } finally {
        await widget.onAfterVehicleScan?.call();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('DME accepted the exhaust flap service test.'),
          ),
        );
      }
    } catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    } finally {
      if (mounted) setState(() => flapTestRunning = false);
    }
  }

  Future<void> setFlapMode(String mode) async {
    if (flapTestRunning) return;
    setState(() {
      error = null;
      flapTestRunning = true;
    });
    try {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      if (widget.onSetFlapMode != null) {
        await widget.onSetFlapMode!(mode);
      } else {
        await experimentalExhaustFlapSetPosition(mode: mode);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Exhaust flap ${mode == 'closed' ? 'closed' : mode} command accepted.',
            ),
          ),
        );
      }
    } catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    } finally {
      if (mounted) setState(() => flapTestRunning = false);
    }
  }

  Widget profilePanel() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    decoration: BoxDecoration(
      color: AppPalette.surface(widget.isDark),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        const Icon(Icons.memory_rounded, color: AppPalette.blue, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Engine',
                style: TextStyle(fontSize: 11, color: Color(0xFF7A8597)),
              ),
              const SizedBox(height: 2),
              Text(
                engineProfile,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (scannedAt != null)
          Text(
            'Scanned ${scannedAt!.hour.toString().padLeft(2, '0')}:${scannedAt!.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 10, color: Color(0xFF7A8597)),
          ),
      ],
    ),
  );

  Widget emptyState() => _CenteredStatus(
    icon: _statePresentation.icon,
    title: _statePresentation.title,
    message: _statePresentation.detail,
    color: _statePresentation.color,
  );

  Widget disconnectedState() => Semantics(
    container: true,
    label: 'Not connected',
    child: Padding(
      padding: const EdgeInsets.only(top: 92, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link_off_rounded, color: AppPalette.blue, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Not connected',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );

  Widget healthyState() => const _CenteredStatus(
    icon: Icons.check_circle_rounded,
    title: 'No engine faults found',
    message: 'The latest scan completed without stored faults.',
    color: AppPalette.green,
  );

  Widget errorPanel() => Semantics(
    container: true,
    label: 'Diagnostics error. $error',
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.red.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.red.withValues(alpha: .3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppPalette.red),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              error!,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    ),
  );

  Widget faultCard(DiagnosticTroubleCode fault) {
    final definition = faultDefinition(fault.code);
    final muted = AppPalette.secondary(widget.isDark);
    final dateLabel = scannedAt == null
        ? 'Not scanned'
        : '${scannedAt!.day.toString().padLeft(2, '0')}/${scannedAt!.month.toString().padLeft(2, '0')}/${scannedAt!.year}';
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.surface(widget.isDark),
        borderRadius: BorderRadius.circular(appCardRadius),
        border: Border.all(
          color: AppPalette.separator(widget.isDark).withValues(alpha: .58),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appCardRadius),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appCardRadius),
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppPalette.orange.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: AppPalette.orange,
            size: 20,
          ),
        ),
        title: Text(
          fault.code,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: .5,
          ),
        ),
        subtitle: Text(
          fault.ecu,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: muted, fontSize: 11),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$dateLabel · ${widget.simulatorMode ? '62,340 km' : 'Mileage unavailable'}',
                  style: TextStyle(color: muted, fontSize: 10),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: _faultStatusFlags(fault.status),
                ),
                const SizedBox(height: 10),
                Text(
                  definition?.title ?? 'BMW-specific fault',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (definition != null && definition.system != fault.ecu) ...[
                  const SizedBox(height: 3),
                  Text(
                    definition.system,
                    style: const TextStyle(
                      color: AppPalette.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 9),
                Text(
                  definition?.explanation ?? 'Definition unavailable.',
                  style: const TextStyle(fontSize: 11, height: 1.45),
                ),
                if (definition != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Next check: ${definition.nextStep}',
                    style: TextStyle(color: muted, fontSize: 10, height: 1.4),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _faultStatusFlags(int status) {
    final flags = <({String label, Color color, IconData icon})>[];
    if ((status & 0x01) != 0) {
      flags.add((
        label: 'Currently failed',
        color: AppPalette.status(AppStatusTone.danger, widget.isDark),
        icon: Icons.error_rounded,
      ));
    }
    if ((status & 0x08) != 0) {
      flags.add((
        label: 'Confirmed',
        color: AppPalette.status(AppStatusTone.warning, widget.isDark),
        icon: Icons.inventory_2_rounded,
      ));
    }
    if ((status & 0x04) != 0) {
      flags.add((
        label: 'Pending',
        color: AppPalette.status(AppStatusTone.warning, widget.isDark),
        icon: Icons.hourglass_top_rounded,
      ));
    }
    if ((status & 0x20) != 0) {
      flags.add((
        label: 'Since clear',
        color: AppPalette.status(AppStatusTone.neutral, widget.isDark),
        icon: Icons.history_rounded,
      ));
    }
    if ((status & 0x02) != 0) {
      flags.add((
        label: 'Failed this operation cycle',
        color: AppPalette.status(AppStatusTone.neutral, widget.isDark),
        icon: Icons.directions_car_filled_rounded,
      ));
    }
    if (flags.isEmpty) {
      flags.add((
        label: 'Status recorded',
        color: AppPalette.status(AppStatusTone.neutral, widget.isDark),
        icon: Icons.info_outline_rounded,
      ));
    }
    return flags
        .map(
          (flag) => Semantics(
            label: flag.label,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: flag.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: flag.color.withValues(alpha: .32)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(flag.icon, size: 13, color: flag.color),
                  const SizedBox(width: 4),
                  Text(
                    flag.label,
                    style: TextStyle(
                      color: flag.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}

const previewFaults = <DiagnosticTroubleCode>[
  DiagnosticTroubleCode(
    code: '138104',
    rawCode: 0x138104,
    status: 0x2C,
    statusText: 'Confirmed · Pending · Failed since clear',
    ecu: 'Engine control unit',
  ),
  DiagnosticTroubleCode(
    code: '1A2002',
    rawCode: 0x1A2002,
    status: 0x08,
    statusText: 'Confirmed',
    ecu: 'Engine control unit',
  ),
];

class _CenteredStatus extends StatelessWidget {
  const _CenteredStatus({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      container: true,
      label: message.isEmpty ? title : '$title. $message',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? .10 : .07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? .18 : .12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppPalette.secondary(isDark),
                        fontSize: 10,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
