import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:bmw_app/dashboard/gauge_card.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:bmw_app/design/section_title.dart';
import 'package:bmw_app/diagnostics/diagnostics_screen.dart';
import 'package:bmw_app/diagnostics/flap_control_screen.dart';
import 'package:bmw_app/diagnostics/app_diagnostics_screen.dart';
import 'package:bmw_app/diagnostics/app_diagnostics_store.dart';
import 'package:bmw_app/logging/data_logger.dart';
import 'package:bmw_app/logging/auto_log_trigger.dart';
import 'package:bmw_app/logging/logging_screen.dart';
import 'package:bmw_app/onboarding/connection_guide_screen.dart';
import 'package:bmw_app/help/help_screen.dart';
import 'package:bmw_app/product/product_config.dart';
import 'package:bmw_app/about/about_screen.dart';
import 'package:bmw_app/app/build_info.dart';
import 'package:bmw_app/app/android_settings.dart';
import 'package:bmw_app/settings/settings_screen.dart';
import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:bmw_app/tuning/tune_screen.dart';
import 'package:bmw_app/tuning/tune_guide_screen.dart';
import 'package:bmw_app/vehicle/vehicle_identity.dart';
import 'package:bmw_app/vehicle/vehicle_capabilities.dart';
import 'package:bmw_app/vehicle/vehicle_garage.dart';
import 'package:bmw_app/vehicle/simulator_transport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

const maxDiagnosticEvents = 100000;
const maxTraceSessionBytes = 12 * 1024 * 1024;
const maxConnectionTimelineEntries = 10000;

const dashboardHorizontalPadding = 16.0;
const maxLiveSensors = 6;
const floatingConnectionPanelClearance = 96.0;
const _androidNetworkChannel = MethodChannel('bimmerscope/android_network');

void _startAndroidVehicleSessionService() {
  if (!Platform.isAndroid) return;
  unawaited(
    _androidNetworkChannel
        .invokeMethod<bool>('startVehicleSessionService')
        .catchError((_) => false),
  );
}

void _stopAndroidVehicleSessionService() {
  if (!Platform.isAndroid) return;
  unawaited(
    _androidNetworkChannel
        .invokeMethod<bool>('stopVehicleSessionService')
        .catchError((_) => false),
  );
}

String _statusLabelForPhase(String phase) => switch (phase) {
  'connected' => 'Connected',
  'connecting' || 'identifying' || 'discovering' => 'Connecting',
  'reconnecting' => 'Recovering',
  _ => 'Not connected',
};

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    this.previewMode = false,
    required this.isDark,
    required this.onToggleTheme,
  });
  final bool previewMode;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final events = <String>[];
  final eventHistory = <Map<String, dynamic>>[];
  final connectionTimeline = <Map<String, dynamic>>[];
  final values = <String, double>{};
  final visibleSensorIds = <String>[];
  final gaugeWidths = <String, double>{};
  final gaugeHeights = <String, double>{};
  final dialSensorIds = <String>{};
  final customDashboardPresets = <String, Map<String, dynamic>>{};
  final valueColorIds = <String>{};
  final favoriteSensorIds = <String>{};
  final logger = DataLogger();
  final appDiagnosticsStore = AppDiagnosticsStore();
  IOSink? _diagnosticsSink;
  Timer? _diagnosticsFlushTimer;
  final _pendingDiagnostics = <Map<String, Object?>>[];
  int _diagnosticsBytesWritten = 0;
  bool _diagnosticsTruncated = false;
  String? _activeDiagnosticsSessionId;
  bool _diagnosticsArmed = false;
  DateTime? firstSessionStartedAt;
  int diagnosticSessionCount = 0;
  StreamSubscription<VehicleEvent>? subscription;
  late final List<SensorDefinition> sensors;
  late final Map<String, SensorDefinition> sensorsById;
  String phase = 'offline';
  final ValueNotifier<String> connectionStatus = ValueNotifier('Not connected');
  String vin = 'Not identified';
  double? mileageKm;
  bool engineEcuDetected = false;
  String flapMode = 'auto';
  bool flapAutoApply = false;
  String? engineEcuIdentity;
  String? engineEcuHardware;
  String? engineEcuSoftware;
  String? engineEcuBootloader;
  String? engineEcuCalibration;
  String? engineEcuApplicationSoftware;
  String? engineEcuSoftwareVersion;
  String? engineEcuSupplierHardware;
  String? engineEcuSupplierSoftware;
  String? engineEcuBootloaderFingerprint;
  String? engineEcuSoftwareFingerprint;
  String? engineEcuCalibrationFingerprint;
  String? engineEcuSgbdIndex;
  String? engineEcuSerialNumber;
  String? engineEcuManufacturingDate;
  String? engineEcuDiagnosticSession;
  String? engineEcuCodingId;
  String? engineEcuCvn;
  String? engineEcuBmwRoutine0205Raw;
  String? engineEcuBmwRoutine0205Software;
  String? engineEcuBmwControllerFamily;
  String? engineEcuBmwVariant;
  String? engineEcuBmwTransmission;
  String? engineEcuBmwEmissions;
  String? engineEcuBmwInternalToken;
  int _consecutiveZeroRpmSamples = 0;
  DateTime? engineEcuCapturedAt;
  bool simulatorActive = false;
  bool demoActive = false;
  bool monitoringActive = false;
  String detail = 'Switch on ignition and connect the adapter';
  bool editing = false;
  bool fullscreen = false;
  bool landscape = false;
  String? fullscreenGaugeId;
  String? resizingSensorId;
  int selectedTab = 0;
  Timer? loggingTimer;
  Timer? telemetryWatchdog;
  Timer? _layoutSaveTimer;
  DateTime? lastTelemetryAt;
  DateTime? _lastSensorSampleAt;
  final Map<String, DateTime> _lastSensorAtById = {};
  String? _lastSuccessfulSensorId;
  DateTime? _lastSuccessfulSensorAt;
  int telemetryGapCount = 0;
  int maxTelemetryGapMs = 0;
  bool telemetryDegraded = false;
  DateTime? lastConnectionHealthAt;
  DateTime? ignitionOffSince;
  bool ignitionOffDetected = false;
  Duration loggingElapsed = Duration.zero;
  bool autoLogEnabled = false;
  double autoLogThreshold = 70;
  int autoLogReleaseDelaySeconds = 3;
  bool _autoLogRecording = false;
  bool _autoLogStartInProgress = false;
  final _autoLogTrigger = AutoLogTrigger();
  bool sessionResumeInProgress = false;
  bool diagnosticSessionTransition = false;
  DateTime? sessionStartedAt;
  String sessionId = '';
  bool _screenWakeLockEnabled = false;
  bool flapCommandInFlight = false;
  int _sessionGeneration = 0;
  String reconnectPolicy = 'automatic';
  bool useMetric = true;
  String gatewayHost = '169.254.12.64';
  int gatewayPort = 6801;
  AppDiagnosticsLevel _diagnosticsLevel = AppDiagnosticsLevel.normal;

  void _writeDiagnosticRecord(Map<String, Object?> record) {
    if (!_diagnosticsArmed) return;
    final type = record['type'];
    final kind = record['kind'];
    final important =
        type == 'session_start' ||
        type == 'session_end' ||
        type == 'telemetry_gap' ||
        kind == 'poll_retry' ||
        kind == 'reconnecting' ||
        kind == 'error' ||
        kind == 'warning' ||
        (type == 'action' &&
            (record['message'] as String?)?.startsWith('Flap command ') ==
                true);
    if (_diagnosticsLevel == AppDiagnosticsLevel.normal && !important) {
      return;
    }
    if (_diagnosticsLevel == AppDiagnosticsLevel.detailed &&
        type == 'action' &&
        kind == null) {
      return;
    }
    final complete = <String, Object?>{
      'timestamp': DateTime.now().toIso8601String(),
      ...record,
    };
    final encoded = jsonEncode(complete);
    if (_diagnosticsLevel == AppDiagnosticsLevel.trace &&
        _diagnosticsBytesWritten + encoded.length + 1 > maxTraceSessionBytes &&
        !important) {
      if (!_diagnosticsTruncated) {
        _diagnosticsTruncated = true;
        final truncated = jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'type': 'diagnostics_truncated',
          'limitBytes': maxTraceSessionBytes,
          'message':
              'High-volume Trace records were stopped at the session size limit.',
        });
        _diagnosticsBytesWritten += truncated.length + 1;
        final sink = _diagnosticsSink;
        if (sink == null) {
          _pendingDiagnostics.add(
            jsonDecode(truncated) as Map<String, Object?>,
          );
        } else {
          sink.writeln(truncated);
        }
      }
      return;
    }
    _diagnosticsBytesWritten += encoded.length + 1;
    final sink = _diagnosticsSink;
    if (sink == null) {
      if (_pendingDiagnostics.length < maxDiagnosticEvents) {
        _pendingDiagnostics.add(complete);
      }
      return;
    }
    sink.writeln(encoded);
  }

  Future<void> _startDiagnosticsSession({
    required String id,
    required String source,
    required DateTime startedAt,
  }) async {
    await _finishDiagnosticsSession();
    _diagnosticsLevel = await appDiagnosticsStore.level();
    _diagnosticsArmed = true;
    _diagnosticsBytesWritten = 0;
    _diagnosticsTruncated = false;
    diagnosticSessionCount++;
    firstSessionStartedAt ??= startedAt;
    try {
      final file = await appDiagnosticsStore.start(
        sessionId: id,
        source: source,
        startedAt: startedAt,
      );
      if (!_diagnosticsArmed || id != sessionId) return;
      _activeDiagnosticsSessionId = id;
      _diagnosticsSink = file.openWrite(mode: FileMode.append);
      for (final pending in _pendingDiagnostics) {
        _diagnosticsSink!.writeln(jsonEncode(pending));
      }
      _pendingDiagnostics.clear();
      _diagnosticsFlushTimer ??= Timer.periodic(const Duration(seconds: 2), (
        _,
      ) {
        final sink = _diagnosticsSink;
        if (sink != null) unawaited(sink.flush());
      });
    } catch (_) {
      // Diagnostics must never prevent a vehicle connection from starting.
    }
  }

  Future<void> _finishDiagnosticsSession() async {
    if (!_diagnosticsArmed && _diagnosticsSink == null) return;
    _writeDiagnosticRecord({
      'type': 'session_end',
      'sessionId': _activeDiagnosticsSessionId ?? sessionId,
      'vin': vin,
      'phase': phase,
      'source': simulatorActive
          ? 'simulator'
          : demoActive
          ? 'demo'
          : 'vehicle',
    });
    _diagnosticsArmed = false;
    _pendingDiagnostics.clear();
    final sink = _diagnosticsSink;
    _diagnosticsSink = null;
    _activeDiagnosticsSessionId = null;
    if (sink != null) {
      await sink.flush();
      await sink.close();
    }
    _diagnosticsFlushTimer?.cancel();
    _diagnosticsFlushTimer = null;
  }

  bool get active =>
      phase != 'offline' && phase != 'disconnected' && phase != 'error';
  bool get live => phase == 'connected';

  String get connectionStageLabel => diagnosticSessionTransition
      ? 'Scanning'
      : switch (phase) {
          'discovering' => 'Searching',
          'connecting' => 'Connecting',
          'identifying' => 'Identifying',
          'reconnecting' => 'Recovering',
          'connected' =>
            telemetryDegraded
                ? 'Degraded'
                : monitoringActive
                ? 'Monitoring'
                : 'Connected',
          'error' => 'Error',
          _ => 'Connection',
        };

  String get connectionActionLabel => switch (phase) {
    'discovering' ||
    'connecting' ||
    'identifying' ||
    'reconnecting' => 'Cancel',
    'connected' => 'Disconnect',
    'error' => 'Retry',
    _ => 'Connect',
  };

  String get connectionDetailLabel => switch (phase) {
    'discovering' => 'Looking for your vehicle…',
    'connecting' => 'Opening the ENET connection…',
    'identifying' => 'Reading vehicle identity…',
    'reconnecting' => 'Connection interrupted. Retrying…',
    'connected' =>
      telemetryDegraded
          ? 'No fresh samples yet. The session is recovering; keep the ignition on.'
          : monitoringActive
          ? 'Live monitoring is active.'
          : 'Connected',
    'error' => 'Couldn’t connect. Check ignition and adapter.',
    _ => 'Connect ENET cable, switch ignition on',
  };

  void logUserAction(String message) {
    final timestamp = DateTime.now();
    final line =
        '${timestamp.toIso8601String().substring(11, 19)}  ACTION  $message';
    events.insert(0, line);
    eventHistory.insert(0, {
      'timestamp': timestamp.toIso8601String(),
      'type': 'action',
      'message': message,
    });
    if (message.startsWith('Vehicle event:') &&
        !message.contains('Vehicle event: sensor ')) {
      connectionTimeline.insert(0, {
        'timestamp': timestamp.toIso8601String(),
        'message': message,
      });
      if (connectionTimeline.length > maxConnectionTimelineEntries) {
        connectionTimeline.removeLast();
      }
    }
    if (events.length > 500) events.removeLast();
    // Keep the exported development history substantially longer than the
    // on-screen event feed. Sensor samples are intentionally retained here;
    // the raw HSFZ file remains the authoritative transport-level capture.
    if (eventHistory.length > maxDiagnosticEvents) {
      eventHistory.removeLast();
    }
    _writeDiagnosticRecord({'type': 'action', 'message': message});
  }

  void clearVehicleIdentity() {
    vin = 'Not identified';
    mileageKm = null;
    flapMode = 'auto';
    engineEcuDetected = false;
    engineEcuIdentity = null;
    engineEcuHardware = null;
    engineEcuSoftware = null;
    engineEcuBootloader = null;
    engineEcuCalibration = null;
    engineEcuApplicationSoftware = null;
    engineEcuSoftwareVersion = null;
    engineEcuSupplierHardware = null;
    engineEcuSupplierSoftware = null;
    engineEcuBootloaderFingerprint = null;
    engineEcuSoftwareFingerprint = null;
    engineEcuCalibrationFingerprint = null;
    engineEcuSgbdIndex = null;
    engineEcuSerialNumber = null;
    engineEcuManufacturingDate = null;
    engineEcuDiagnosticSession = null;
    engineEcuCodingId = null;
    engineEcuCvn = null;
    engineEcuBmwRoutine0205Raw = null;
    engineEcuBmwRoutine0205Software = null;
    engineEcuBmwControllerFamily = null;
    engineEcuBmwVariant = null;
    engineEcuBmwTransmission = null;
    engineEcuBmwEmissions = null;
    engineEcuBmwInternalToken = null;
    _consecutiveZeroRpmSamples = 0;
    engineEcuCapturedAt = null;
    monitoringActive = false;
  }

  void selectGarageVehicle(GarageVehicle vehicle) {
    if (!mounted || active) return;
    setState(() {
      vin = vehicle.vin;
      simulatorActive = false;
      demoActive = false;
      phase = 'offline';
      detail = 'Offline garage vehicle selected';
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sensors = widget.previewMode ? previewSensors : defaultSensors();
    sensorsById = {for (final sensor in sensors) sensor.id: sensor};
    visibleSensorIds.addAll(
      sensors.take(maxLiveSensors).map((sensor) => sensor.id),
    );
    if (!widget.previewMode) _syncLiveSensorSelection();
    unawaited(_loadSessionPreferences());
    telemetryWatchdog = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _checkTelemetryFreshness(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateScreenWakeLock();
    });
  }

  Future<void> _loadSessionPreferences() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!mounted) return;
      final storedLayout = preferences.getString(
        'bimmerscope.dashboard_layout_v1',
      );
      final storedPresets = preferences.getString(
        'bimmerscope.dashboard_presets_v1',
      );
      final storedFavorites = preferences.getStringList(
        'bimmerscope.dashboard_favorite_sensors_v1',
      );
      final storedDiagnosticsLevel = preferences.getString(
        'bimmerscope.diagnostics.level',
      );
      final diagnosticsLevel = AppDiagnosticsLevel.values.firstWhere(
        (item) => item.name == storedDiagnosticsLevel,
        orElse: () => AppDiagnosticsLevel.normal,
      );
      setState(() {
        _diagnosticsLevel = diagnosticsLevel;
        reconnectPolicy =
            preferences.getString('bimmerscope.reconnect_policy') ??
            'automatic';
        useMetric = preferences.getString('bimmerscope.units') != 'imperial';
        autoLogEnabled =
            preferences.getBool('bimmerscope.auto_log_enabled') ?? false;
        autoLogThreshold =
            (preferences.getDouble('bimmerscope.auto_log_threshold') ?? 70)
                .clamp(30, 95);
        autoLogReleaseDelaySeconds =
            (preferences.getInt('bimmerscope.auto_log_release_delay') ?? 3)
                .clamp(1, 10);
        _restoreDashboardLayout(storedLayout);
        _restoreCustomPresets(storedPresets);
        favoriteSensorIds
          ..clear()
          ..addAll(
            (storedFavorites ?? const <String>[]).where(
              sensorsById.containsKey,
            ),
          );
      });
      if (!widget.previewMode) _syncLiveSensorSelection();
    } catch (_) {}
  }

  Future<bool> setAutoLogEnabled(bool enabled) async {
    if (enabled && !visibleSensorIds.contains('throttle_angle')) {
      if (visibleSensorIds.length >= maxLiveSensors) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Free a live gauge slot, then add Throttle Angle to use automatic logging.',
              ),
            ),
          );
        }
        return false;
      }
      setState(() => visibleSensorIds.add('throttle_angle'));
      _scheduleLayoutSave();
      _syncLiveSensorSelection();
    }
    setState(() => autoLogEnabled = enabled);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('bimmerscope.auto_log_enabled', enabled);
    return true;
  }

  Future<void> setAutoLogThreshold(double threshold) async {
    final next = threshold.clamp(30, 95).toDouble();
    setState(() => autoLogThreshold = next);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('bimmerscope.auto_log_threshold', next);
  }

  Future<void> setAutoLogReleaseDelay(int seconds) async {
    final next = seconds.clamp(1, 10);
    setState(() => autoLogReleaseDelaySeconds = next);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('bimmerscope.auto_log_release_delay', next);
  }

  void _restoreCustomPresets(String? encoded) {
    if (encoded == null || encoded.isEmpty) return;
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map<String, dynamic>) return;
      for (final entry in decoded.entries) {
        final name = entry.key.trim();
        // Migrate the original channel-only presets without losing them.
        final layout = entry.value is List
            ? <String, dynamic>{'visibleSensorIds': entry.value}
            : entry.value;
        if (layout is! Map<String, dynamic>) continue;
        final ids = layout['visibleSensorIds'];
        if (name.isEmpty || ids is! List) continue;
        final valid = ids
            .whereType<String>()
            .where(sensorsById.containsKey)
            .toSet()
            .take(maxLiveSensors)
            .toList();
        if (valid.isNotEmpty) {
          customDashboardPresets[name] = {...layout, 'visibleSensorIds': valid};
        }
      }
    } catch (_) {}
  }

  /// Restores only known, finite layout values. A malformed preference must
  /// never prevent the dashboard from opening with its safe defaults.
  void _restoreDashboardLayout(String? encoded) {
    if (encoded == null || encoded.isEmpty) return;
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map<String, dynamic>) return;
      final ids = decoded['visibleSensorIds'];
      if (ids is List) {
        final restored = ids
            .whereType<String>()
            .where(sensorsById.containsKey)
            .toSet()
            .take(maxLiveSensors)
            .toList();
        if (restored.isNotEmpty) {
          visibleSensorIds
            ..clear()
            ..addAll(restored);
        }
      }
      _restoreFiniteMap(decoded['gaugeWidths'], gaugeWidths);
      _restoreFiniteMap(decoded['gaugeHeights'], gaugeHeights);
      _restoreKnownSet(decoded['dialSensorIds'], dialSensorIds);
      _restoreKnownSet(decoded['valueColorIds'], valueColorIds);
    } catch (_) {}
  }

  void _restoreFiniteMap(Object? value, Map<String, double> target) {
    if (value is! Map) return;
    for (final entry in value.entries) {
      final key = entry.key;
      final number = entry.value;
      if (key is String &&
          sensorsById.containsKey(key) &&
          number is num &&
          number.toDouble().isFinite) {
        target[key] = number.toDouble();
      }
    }
  }

  void _restoreKnownSet(Object? value, Set<String> target) {
    if (value is! List) return;
    target
      ..clear()
      ..addAll(value.whereType<String>().where(sensorsById.containsKey));
  }

  void _scheduleLayoutSave() {
    if (widget.previewMode) return;
    _layoutSaveTimer?.cancel();
    _layoutSaveTimer = Timer(
      const Duration(milliseconds: 350),
      _persistDashboardLayout,
    );
  }

  Future<void> _persistDashboardLayout() async {
    if (widget.previewMode) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        'bimmerscope.dashboard_layout_v1',
        jsonEncode({
          'visibleSensorIds': visibleSensorIds.take(maxLiveSensors).toList(),
          'gaugeWidths': gaugeWidths,
          'gaugeHeights': gaugeHeights,
          'dialSensorIds': dialSensorIds.toList(),
          'valueColorIds': valueColorIds.toList(),
        }),
      );
      await preferences.setString(
        'bimmerscope.dashboard_presets_v1',
        jsonEncode(customDashboardPresets),
      );
      await preferences.setStringList(
        'bimmerscope.dashboard_favorite_sensors_v1',
        favoriteSensorIds.toList()..sort(),
      );
    } catch (_) {}
  }

  Future<void> _loadFlapPreferenceForVin(String vehicleVin) async {
    if (widget.previewMode || vehicleVin == 'Not identified') return;
    try {
      final preferences = await SharedPreferences.getInstance();
      final stored = preferences.getString(
        'bimmerscope.flap_mode.${vehicleVin.toUpperCase()}',
      );
      final autoApply = preferences.getBool(
        'bimmerscope.flap_auto_apply.${vehicleVin.toUpperCase()}',
      );
      if (!mounted || vin != vehicleVin) return;
      setState(() {
        if (stored != null &&
            const {
              'auto',
              'open',
              'open_legacy',
              'open_periodic',
              'open_bm3',
              'closed',
            }.contains(stored)) {
          flapMode = stored == 'open' ? 'open_periodic' : stored;
        }
        flapAutoApply = autoApply ?? false;
      });
      if (phase == 'connected') {
        unawaited(_applySavedFlapPreferenceIfEnabled());
      }
    } catch (_) {
      // A saved preference must never block vehicle connection.
    }
  }

  Future<void> _persistFlapPreference(String vehicleVin, String mode) async {
    if (widget.previewMode || vehicleVin == 'Not identified') return;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        'bimmerscope.flap_mode.${vehicleVin.toUpperCase()}',
        mode,
      );
    } catch (_) {
      // Preference persistence is best-effort only.
    }
  }

  Future<void> _persistFlapAutoApply(String vehicleVin, bool enabled) async {
    if (widget.previewMode || vehicleVin == 'Not identified') return;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(
        'bimmerscope.flap_auto_apply.${vehicleVin.toUpperCase()}',
        enabled,
      );
    } catch (_) {}
  }

  Future<void> _applySavedFlapPreferenceIfEnabled() async {
    if (!flapAutoApply ||
        !live ||
        !const {
          'open',
          'open_legacy',
          'open_periodic',
          'closed',
        }.contains(flapMode)) {
      return;
    }
    await setFlapMode(flapMode);
  }

  void _checkTelemetryFreshness() {
    if (!mounted || !live || lastTelemetryAt == null) return;
    final now = DateTime.now();
    final age = now.difference(lastTelemetryAt!);
    final nextDegraded = age >= const Duration(seconds: 5);
    if (nextDegraded != telemetryDegraded) {
      telemetryDegraded = nextDegraded;
      if (mounted) setState(() {});
      _writeDiagnosticRecord({
        'type': 'telemetry_quality',
        'quality': nextDegraded ? 'degraded' : 'good',
        'telemetryAgeMs': age.inMilliseconds,
      });
    }
    if (lastConnectionHealthAt == null ||
        now.difference(lastConnectionHealthAt!).inSeconds >= 30) {
      connectionTimeline.insert(0, {
        'timestamp': now.toIso8601String(),
        'type': 'health',
        'phase': phase,
        'live': live,
        'telemetryAgeMs': now.difference(lastTelemetryAt!).inMilliseconds,
        'sensorCount': values.length,
      });
      if (connectionTimeline.length > maxConnectionTimelineEntries) {
        connectionTimeline.removeLast();
      }
      lastConnectionHealthAt = now;
    }
    // Rust has a bounded reconnect path. Allow it to finish before the
    // Flutter watchdog ends the session, so short ENET response gaps do not
    // look like a hard disconnect to the user.
    // The Rust session has a bounded recovery path. Give it enough time for a
    // TCP reconnect plus ECU identification before treating a sensor gap as a
    // failed drive session. A confirmed loss of the vehicle network is still
    // reported immediately by Rust as `disconnected`.
    if (age < const Duration(seconds: 30)) return;
    logUserAction('Telemetry became stale; ending the session');
    unawaited(_finishDiagnosticsSession());
    _stopVehicleSession();
    setState(() {
      clearVehicleIdentity();
      values.clear();
      phase = 'error';
      detail = 'Telemetry stopped. Tap Retry to reconnect.';
      engineEcuDetected = false;
      telemetryDegraded = false;
    });
  }

  void _checkIgnitionOffSignature() {
    if (!mounted || !live || demoActive || simulatorActive) return;
    final rpm = values['engine_rpm'];
    final battery = values['battery_voltage'];
    final ignitionOffSignature =
        rpm != null && battery != null && rpm <= 100 && battery <= 12.2;
    if (!ignitionOffSignature) {
      ignitionOffSince = null;
      return;
    }
    ignitionOffSince ??= DateTime.now();
    if (ignitionOffDetected ||
        DateTime.now().difference(ignitionOffSince!).inSeconds < 20) {
      return;
    }
    ignitionOffDetected = true;
    logUserAction(
      'Ignition-off signature detected; ending session '
      '(RPM ${rpm.toStringAsFixed(0)}, battery ${battery.toStringAsFixed(2)} V)',
    );
    _stopVehicleSession();
    subscription?.cancel();
    connectionStatus.dispose();
    subscription = null;
    setState(() {
      clearVehicleIdentity();
      values.clear();
      phase = 'disconnected';
      detail = 'Ignition off; session ended';
      lastTelemetryAt = null;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(WakelockPlus.disable());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    subscription?.cancel();
    loggingTimer?.cancel();
    telemetryWatchdog?.cancel();
    _layoutSaveTimer?.cancel();
    unawaited(logger.dispose());
    unawaited(_finishDiagnosticsSession());
    if (!widget.previewMode) {
      _stopVehicleSession();
    }
    super.dispose();
  }

  Future<void> setFlapMode(String mode) async {
    if (!live || flapCommandInFlight) return;
    logUserAction('Flap command started: $mode');
    flapCommandInFlight = true;
    try {
      if (demoActive) {
        await Future<void>.delayed(const Duration(milliseconds: 180));
        logUserAction('Demo flap command simulated: $mode');
      } else {
        await experimentalExhaustFlapSetPosition(mode: mode);
      }
      if (mounted) {
        setState(() => flapMode = mode);
        unawaited(_persistFlapPreference(vin, mode));
      }
      logUserAction('Flap command acknowledged: $mode');
    } catch (error) {
      logUserAction('Flap command failed: $mode; $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Flap command not confirmed: $error')),
        );
      }
    } finally {
      flapCommandInFlight = false;
    }
  }

  bool get _flapControlAvailable =>
      live &&
      (demoActive ||
          ((engineEcuDetected) &&
              identifyVehicle(
                    vin,
                  )?.profile.supports(VehicleCapability.flapControl) ==
                  true));

  Future<void> showFlapControl() async {
    if ((!_flapControlAvailable && !demoActive) || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FlapControlScreen(
          isDark: widget.isDark,
          connectionStatus: connectionStatus,
          initialMode: flapMode,
          onSetMode: setFlapMode,
          autoApply: flapAutoApply,
          onAutoApplyChanged: (enabled) {
            setState(() => flapAutoApply = enabled);
            unawaited(_persistFlapAutoApply(vin, enabled));
          },
        ),
      ),
    );
  }

  void _syncLiveSensorSelection() {
    if (widget.previewMode) return;
    try {
      setLiveSensorIds(
        sensorIds: visibleSensorIds.take(maxLiveSensors).toList(),
      );
    } catch (error) {
      logUserAction('Unable to update live sensor selection: $error');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateScreenWakeLock();
    } else if (_screenWakeLockEnabled) {
      _screenWakeLockEnabled = false;
      unawaited(WakelockPlus.disable());
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(logger.flush());
    }
  }

  void _updateScreenWakeLock() {
    final shouldStayAwake =
        !widget.previewMode &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    if (shouldStayAwake == _screenWakeLockEnabled) return;
    _screenWakeLockEnabled = shouldStayAwake;
    unawaited(shouldStayAwake ? WakelockPlus.enable() : WakelockPlus.disable());
  }

  Future<void> toggleFullscreen([String? gaugeId]) async {
    final next = !fullscreen;
    await SystemChrome.setEnabledSystemUIMode(
      next ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
    if (!next) {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
    if (mounted) {
      setState(() {
        fullscreen = next;
        fullscreenGaugeId = next ? gaugeId : null;
        editing = false;
        landscape = false;
      });
      _updateScreenWakeLock();
    }
  }

  Future<void> rotateFullscreen() async {
    final next = !landscape;
    await SystemChrome.setPreferredOrientations(
      next
          ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
          : [DeviceOrientation.portraitUp],
    );
    if (mounted) setState(() => landscape = next);
  }

  Future<void> connect({bool demo = false, bool simulator = false}) async {
    if (widget.previewMode) return;
    if (active) {
      disconnect();
      return;
    }
    // A new source/session must never append to the previous recording.
    if (logger.isRecording) unawaited(stopLogging());
    HapticFeedback.selectionClick();
    logUserAction(
      demo || simulator ? 'Started simulated connection' : 'Clicked Connect',
    );
    try {
      File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}BimmerScope_Raw_HSFZ.log',
      ).deleteSync();
    } catch (_) {}
    final generation = ++_sessionGeneration;
    final startedAt = DateTime.now();
    final newSessionId = 'session_${startedAt.microsecondsSinceEpoch}';
    final source = simulator
        ? 'simulator'
        : demo
        ? 'demo'
        : 'vehicle';
    final previousDiagnostics = _finishDiagnosticsSession();
    setState(() {
      simulatorActive = simulator;
      demoActive = demo;
      sessionId = newSessionId;
      lastConnectionHealthAt = null;
      lastTelemetryAt = null;
      _lastSensorSampleAt = null;
      _lastSensorAtById.clear();
      _lastSuccessfulSensorId = null;
      _lastSuccessfulSensorAt = null;
      telemetryGapCount = 0;
      maxTelemetryGapMs = 0;
      telemetryDegraded = false;
      ignitionOffSince = null;
      ignitionOffDetected = false;
      values.clear();
      clearVehicleIdentity();
      phase = demo || simulator ? 'connecting' : 'discovering';
      sessionStartedAt = startedAt;
      detail = simulator
          ? 'Connecting to desktop simulator'
          : demo
          ? 'Starting simulated vehicle'
          : 'Searching for your vehicle';
    });
    await previousDiagnostics;
    await _startDiagnosticsSession(
      id: newSessionId,
      source: source,
      startedAt: startedAt,
    );
    configureTransportDiagnostics(
      level: _diagnosticsLevel.name,
      sessionId: newSessionId,
    );
    if (!demo && !simulator) {
      _startAndroidVehicleSessionService();
      unawaited(
        _androidNetworkChannel
            .invokeMethod<bool>('bindEthernet')
            .catchError((_) => false),
      );
      unawaited(_checkAndroidEthernet());
    }
    _syncLiveSensorSelection();
    final stream = simulator
        ? startSimulatorSession(
            activeSensorIds: visibleSensorIds.take(maxLiveSensors).toList(),
          )
        : demo
        ? startDemoSession()
        : startAutoVehicleSession();
    subscription?.cancel();
    subscription = stream.listen(
      (event) => onEvent(event, generation),
      onError: (Object error, StackTrace stackTrace) =>
          _handleSessionStreamError(error, generation),
    );
  }

  void _stopVehicleSession() {
    _stopAndroidVehicleSessionService();
    stopSession();
  }

  void _handleSessionStreamError(Object error, int generation) {
    if (!mounted || generation != _sessionGeneration) return;
    logUserAction('Session stream error: $error');
    unawaited(_finishDiagnosticsSession());
    _stopVehicleSession();
    if (logger.isRecording) unawaited(stopLogging());
    setState(() {
      sessionResumeInProgress = false;
      clearVehicleIdentity();
      values.clear();
      simulatorActive = false;
      demoActive = false;
      sessionStartedAt = null;
      phase = 'error';
      detail = _friendlyConnectionError(error.toString());
    });
  }

  Future<void> _checkAndroidEthernet() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || !active || !Platform.isAndroid) return;
    final interfaces = await NetworkInterface.list(includeLoopback: false);
    final hasEthernet = interfaces.any((interface) {
      final name = interface.name.toLowerCase();
      return name.contains('eth') ||
          name.contains('usb') ||
          name.contains('rndis');
    });
    if (!hasEthernet && mounted && active) {
      setState(() {
        detail =
            'Enable Ethernet, Ethernet tethering, or Share via Ethernet in Android network settings';
      });
    }
  }

  Future<void> _handleConnectTap() async {
    if (Platform.isAndroid && !widget.previewMode && !active) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Prepare ENET connection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1 - Turn off Wi-Fi and mobile data\n'
                '2 - Connect ENET cable\n'
                '3 - Enable Share via Ethernet (Ethernet tethering)\n'
                '4 - Switch ignition on',
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    final opened = await openPortableHotspotSettings();
                    if (!opened && dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Could not open hotspot settings. Go to Settings → Portable hotspot.',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.settings_ethernet_rounded),
                  label: const Text('Open Portable hotspot settings'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      if (proceed != true || !mounted) return;
    }
    connect();
  }

  void disconnect() {
    _sessionGeneration++;
    if (logger.isRecording) unawaited(stopLogging());
    logUserAction('Clicked Disconnect');
    unawaited(_finishDiagnosticsSession());
    _stopVehicleSession();
    subscription?.cancel();
    subscription = null;
    setState(() {
      sessionResumeInProgress = false;
      diagnosticSessionTransition = false;
      simulatorActive = false;
      demoActive = false;
      clearVehicleIdentity();
      sessionStartedAt = null;
      phase = 'offline';
      detail = 'Session stopped';
    });
  }

  void toggleMonitoring() {
    if (!live || widget.previewMode) return;
    if (monitoringActive) {
      stopMonitoring();
      if (logger.isRecording) unawaited(stopLogging());
      logUserAction('Stopped live monitoring');
    } else {
      startMonitoring();
      logUserAction('Started live monitoring');
    }
    setState(() {
      monitoringActive = !monitoringActive;
      telemetryDegraded = false;
      lastTelemetryAt = monitoringActive ? DateTime.now() : null;
      _lastSensorSampleAt = null;
    });
  }

  Future<void> pauseLiveSessionForScan() async {
    if (!live || simulatorActive) return;
    logUserAction('Paused live session for diagnostic scan');
    _sessionGeneration++;
    if (mounted) setState(() => diagnosticSessionTransition = true);
    try {
      _stopVehicleSession();
      await subscription?.cancel();
      subscription = null;
      await stopSessionAndWait(timeoutMs: BigInt.from(5000));
      if (mounted) setState(() => phase = 'offline');
    } catch (_) {
      if (mounted) {
        setState(() {
          diagnosticSessionTransition = false;
          phase = 'error';
        });
      }
      rethrow;
    }
  }

  Future<void> resumeLiveSessionAfterScan() async {
    if (widget.previewMode ||
        simulatorActive ||
        active ||
        sessionResumeInProgress) {
      return;
    }
    sessionResumeInProgress = true;
    logUserAction('Resuming live session after diagnostic scan');
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (mounted && !active) {
      diagnosticSessionTransition = false;
      connect();
    }
  }

  Future<void> exportAppDiagnostics() async {
    logUserAction('Clicked Export App Diagnostics');
    final interfaces = await NetworkInterface.list(includeLoopback: true);
    final gatewayProbe = await _probeEnetGateway();
    final ethernetInterfaces = interfaces
        .where(
          (item) =>
              item.name.toLowerCase().contains('eth') ||
              item.name.toLowerCase().contains('usb'),
        )
        .map(
          (item) =>
              '${item.name}: ${item.addresses.map((address) => address.address).join(', ')}',
        )
        .join(' | ');
    final directory = await appDiagnosticsStore.directory();
    final capturedAt = DateTime.now();
    final stamp =
        '${capturedAt.year.toString().padLeft(4, '0')}'
        '${capturedAt.month.toString().padLeft(2, '0')}'
        '${capturedAt.day.toString().padLeft(2, '0')}_'
        '${capturedAt.hour.toString().padLeft(2, '0')}'
        '${capturedAt.minute.toString().padLeft(2, '0')}'
        '${capturedAt.second.toString().padLeft(2, '0')}'
        '_${capturedAt.millisecond.toString().padLeft(3, '0')}';
    final file = File(
      '${directory.path}${Platform.pathSeparator}BimmerScope_App_Diagnostics_$stamp.txt',
    );
    final lines = <String>[
      'BIMMERSCOPE APP DIAGNOSTICS',
      'Captured: ${capturedAt.toIso8601String()}',
      'Platform: ${Platform.operatingSystem}',
      'Connection phase: $phase',
      'Connection label: $connectionStageLabel',
      'VIN: $vin',
      'Live session: $live',
      'Simulator active: $simulatorActive',
      'Demo active: $demoActive',
      'Engine ECU detected: $engineEcuDetected',
      'DME identity: ${engineEcuIdentity ?? 'Not read'}',
      'DME hardware number: ${engineEcuHardware ?? 'Not read'}',
      'DME software number: ${engineEcuSoftware ?? 'Not read'}',
      'DME application software: ${engineEcuApplicationSoftware ?? 'Not read'}',
      'DME software version: ${engineEcuSoftwareVersion ?? 'Not read'}',
      'DME bootloader: ${engineEcuBootloader ?? 'Not read'}',
      'DME calibration: ${engineEcuCalibration ?? 'Not read'}',
      'DME supplier hardware: ${engineEcuSupplierHardware ?? 'Not read'}',
      'DME supplier software: ${engineEcuSupplierSoftware ?? 'Not read'}',
      'DME bootloader fingerprint: ${engineEcuBootloaderFingerprint ?? 'Not read'}',
      'DME software fingerprint: ${engineEcuSoftwareFingerprint ?? 'Not read'}',
      'DME calibration fingerprint: ${engineEcuCalibrationFingerprint ?? 'Not read'}',
      'DME coding ID: Not mapped',
      'Visible sensors: ${visibleSensorIds.length}',
      'Current sensor values: ${values.length}',
      'Gateway: $gatewayHost:$gatewayPort (ENET)',
      'Gateway TCP probe: ${gatewayProbe['tcp6801']}',
      'Gateway UDP discovery probe: ${gatewayProbe['udp6811']}',
      'Ethernet interface summary: ${ethernetInterfaces.isEmpty ? 'none detected' : ethernetInterfaces}',
      'Route assessment: ${gatewayProbe['tcp6801'] == 'reachable' ? 'BMW ENET gateway reachable' : 'No confirmed route to BMW ENET gateway'}',
      'Non-loopback interface present: ${interfaces.any((item) => item.name != 'lo')}',
      'Capture scope: app state, session telemetry, interface state, user actions, errors, and raw transport data',
      'Interface count: ${interfaces.length}',
      'First session started: ${firstSessionStartedAt?.toIso8601String() ?? sessionStartedAt?.toIso8601String() ?? 'Unavailable'}',
      'Latest connection started: ${sessionStartedAt?.toIso8601String() ?? 'Unavailable'}',
      'Session duration (first to capture): ${firstSessionStartedAt == null ? 'Unavailable' : '${DateTime.now().difference(firstSessionStartedAt!).inSeconds} seconds'}',
      'Session count: $diagnosticSessionCount',
      'Event count: ${eventHistory.length}',
      'Action count: ${eventHistory.where((event) => event['type'] == 'action').length}',
      'Scan started: ${eventHistory.where((event) => (event['message'] as String? ?? '').startsWith('Scan started')).length}',
      'Scan completed: ${eventHistory.where((event) => (event['message'] as String? ?? '').startsWith('Scan completed')).length}',
      'Reconnect events: ${eventHistory.where((event) => (event['message'] as String? ?? '').toLowerCase().contains('reconnect')).length}',
      'Telemetry gaps >1.5 s: $telemetryGapCount (max $maxTelemetryGapMs ms)',
      '',
      'Network interfaces:',
      ...interfaces.expand(
        (interface) => [
          '- ${interface.name}',
          ...interface.addresses.map(
            (address) =>
                '  ${address.address}${address.isLinkLocal ? ' (link-local)' : ''}${address.type == InternetAddressType.IPv4 ? ' (IPv4)' : ' (IPv6)'}',
          ),
        ],
      ),
      '',
      'Recent connection events:',
      ...connectionTimeline.map(_formatConnectionTimelineEntry),
    ];
    await file.writeAsString('${lines.join('\n')}\n');
    final rawFile = File(
      '${directory.path}${Platform.pathSeparator}BimmerScope_App_Session_$stamp.json',
    );
    await rawFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'capturedAt': capturedAt.toIso8601String(),
        'platform': Platform.operatingSystem,
        'phase': phase,
        'connectionLabel': connectionStageLabel,
        'vin': vin,
        'live': live,
        'simulatorActive': simulatorActive,
        'demoActive': demoActive,
        'engineEcuDetected': engineEcuDetected,
        'dmeIdentity': {
          'identity': engineEcuIdentity,
          'hardwareNumber': engineEcuHardware,
          'softwareNumber': engineEcuSoftware,
          'applicationSoftware': engineEcuApplicationSoftware,
          'softwareVersion': engineEcuSoftwareVersion,
          'bootloader': engineEcuBootloader,
          'calibration': engineEcuCalibration,
          'supplierHardware': engineEcuSupplierHardware,
          'supplierSoftware': engineEcuSupplierSoftware,
          'bootloaderFingerprint': engineEcuBootloaderFingerprint,
          'softwareFingerprint': engineEcuSoftwareFingerprint,
          'calibrationFingerprint': engineEcuCalibrationFingerprint,
          'codingId': null,
        },
        'visibleSensorIds': visibleSensorIds,
        'sensorValues': values,
        'fullscreen': fullscreen,
        'selectedTab': selectedTab,
        'gateway': '$gatewayHost:$gatewayPort',
        'gatewayProbe': gatewayProbe,
        'interfaces': interfaces
            .map(
              (interface) => {
                'name': interface.name,
                'addresses': interface.addresses
                    .map(
                      (address) => {
                        'address': address.address,
                        'type': address.type.name,
                        'isLinkLocal': address.isLinkLocal,
                      },
                    )
                    .toList(),
              },
            )
            .toList(),
        'firstSessionStartedAt': firstSessionStartedAt?.toIso8601String(),
        'latestConnectionStartedAt': sessionStartedAt?.toIso8601String(),
        'sessionCount': diagnosticSessionCount,
        'telemetryGapCount': telemetryGapCount,
        'maxTelemetryGapMs': maxTelemetryGapMs,
        'events': eventHistory,
        'connectionTimeline': connectionTimeline,
      }),
    );
    final protocolFile = File(
      '${directory.path}${Platform.pathSeparator}BimmerScope_Raw_HSFZ_$stamp.log',
    );
    final transportLog = File(
      '${Directory.systemTemp.path}${Platform.pathSeparator}BimmerScope_Raw_HSFZ.log',
    );
    if (await transportLog.exists()) {
      await protocolFile.writeAsBytes(await transportLog.readAsBytes());
    }
    final bundleFiles = <File>[
      file,
      rawFile,
      if (await protocolFile.exists()) protocolFile,
    ];
    final manifestFile = File(
      '${directory.path}${Platform.pathSeparator}BimmerScope_App_Diagnostics_${stamp}_manifest.json',
    );
    final manifestEntries = <Map<String, Object?>>[];
    for (final bundleFile in bundleFiles) {
      final bytes = await bundleFile.readAsBytes();
      manifestEntries.add({
        'file_name': bundleFile.uri.pathSegments.last,
        'size': bytes.length,
        'sha256': sha256.convert(bytes).toString(),
      });
    }
    final manifest = <String, Object?>{
      'format': 'bimmerscope-diagnostics-bundle-v1',
      'capturedAt': capturedAt.toIso8601String(),
      'files': manifestEntries,
    };
    await manifestFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifest),
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
          XFile(rawFile.path),
          if (await protocolFile.exists()) XFile(protocolFile.path),
          XFile(manifestFile.path),
        ],
        text: 'BimmerScope app diagnostics',
      ),
    );
  }

  String _formatConnectionTimelineEntry(Map<String, dynamic> event) {
    if (event['type'] == 'health') {
      return '${event['timestamp']}  HEALTH phase=${event['phase']} live=${event['live']} '
          'telemetryAgeMs=${event['telemetryAgeMs']} sensors=${event['sensorCount']}';
    }
    return '${event['timestamp']}  ${event['message']}';
  }

  Future<Map<String, String>> _probeEnetGateway({
    bool allowDuringActiveSession = false,
  }) async {
    final result = <String, String>{};
    // BMW ENET gateways can be sensitive to an additional TCP/6801 client
    // while a diagnostic session is active. The live Rust session already
    // proves reachability through a successful DME request, so never open a
    // competing socket merely to populate diagnostic UI or exports.
    if (active && !allowDuringActiveSession) {
      return {
        'tcp6801': 'skipped while diagnostic session is active',
        'udp6811': 'skipped while diagnostic session is active',
      };
    }
    try {
      final socket = await Socket.connect(
        gatewayHost,
        gatewayPort,
        timeout: const Duration(seconds: 2),
      );
      result['tcp6801'] = 'reachable';
      await socket.close();
    } catch (error) {
      result['tcp6801'] = '${error.runtimeType}: $error';
    }
    try {
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.broadcastEnabled = true;
      final sent = socket.send(
        const [0, 0, 0, 0, 0, 0x11],
        InternetAddress('169.254.255.255'),
        6811,
      );
      socket.close();
      result['udp6811'] = sent > 0 ? 'sent' : 'not sent';
    } catch (error) {
      result['udp6811'] = '${error.runtimeType}: $error';
    }
    return result;
  }

  void _rememberGatewayEndpoint(String message) {
    final match = RegExp(r'^([^:]+):(\d+)$').firstMatch(message.trim());
    if (match == null) return;
    final port = int.tryParse(match.group(2)!);
    if (port == null || port <= 0 || port > 65535) return;
    gatewayHost = match.group(1)!;
    gatewayPort = port;
  }

  void onEvent(VehicleEvent event, [int? generation]) {
    if (!mounted) {
      return;
    }
    if (generation != null && generation != _sessionGeneration) return;
    // A final F300 reply can arrive immediately after Stop. Do not display or
    // log it as a fresh sample once the user has paused monitoring.
    if (event.kind == 'sensor' && !monitoringActive) return;
    if (event.kind == 'reconnecting' && reconnectPolicy == 'manual') {
      logUserAction('Automatic recovery paused by reconnect setting');
      unawaited(_finishDiagnosticsSession());
      if (logger.isRecording) unawaited(stopLogging());
      _stopVehicleSession();
      setState(() {
        phase = 'error';
        detail = 'Connection paused. Tap Retry when the adapter is ready.';
      });
      return;
    }
    if (event.kind == 'connecting' || event.kind == 'reconnecting') {
      _rememberGatewayEndpoint(event.message);
    }
    _writeDiagnosticRecord({
      'type': 'vehicle_event',
      'kind': event.kind,
      'message': event.message,
      'sensorId': event.sensorId,
      'value': event.value,
      'rawValue': event.rawValue,
      'vin': event.vin,
      'ecuAddress': event.ecuAddress,
      'transportRequestId': event.transportRequestId.toString(),
      'transportRequestOperation': event.transportRequestOperation,
      'transportRequestAgeMs': event.transportRequestAgeMs.toInt(),
      'transportRetryCount': event.transportRetryCount,
      'transportSocketState': event.transportSocketState,
      'transportRecoveryAction': event.transportRecoveryAction,
      'transportRecoveryResult': event.transportRecoveryResult,
    });
    if (event.kind == 'sensor') {
      final now = DateTime.now();
      lastTelemetryAt = now;
      final previousSample = _lastSensorSampleAt;
      if (previousSample != null) {
        final gapMs = now.difference(previousSample).inMilliseconds;
        if (gapMs > 1500) {
          telemetryGapCount++;
          if (gapMs > maxTelemetryGapMs) maxTelemetryGapMs = gapMs;
          final channelAges = <String, Object?>{
            for (final sensorId in visibleSensorIds)
              sensorId: _lastSensorAtById[sensorId] == null
                  ? null
                  : now.difference(_lastSensorAtById[sensorId]!).inMilliseconds,
          };
          _writeDiagnosticRecord({
            'type': 'telemetry_gap',
            'gapMs': gapMs,
            'sensorId': event.sensorId,
            'gapCount': telemetryGapCount,
            'lastSuccessfulChannel': _lastSuccessfulSensorId,
            'lastSuccessfulTimestamp': _lastSuccessfulSensorAt
                ?.toIso8601String(),
            'outstandingRequest': {
              'id': event.transportRequestId == BigInt.zero
                  ? null
                  : event.transportRequestId.toString(),
              'operation': event.transportRequestOperation.isEmpty
                  ? null
                  : event.transportRequestOperation,
              'ageMs': event.transportRequestAgeMs.toInt(),
            },
            'retryCount': event.transportRetryCount,
            'socketState': event.transportSocketState.isEmpty
                ? phase
                : event.transportSocketState,
            'perChannelSampleAgeMs': channelAges,
            'recoveryAction': event.transportRecoveryAction.isEmpty
                ? 'none_recorded'
                : event.transportRecoveryAction,
            'recoveryResult': event.transportRecoveryResult.isEmpty
                ? 'not_recorded'
                : event.transportRecoveryResult,
          });
        }
      }
      _lastSensorSampleAt = now;
      _lastSensorAtById[event.sensorId] = now;
      _lastSuccessfulSensorId = event.sensorId;
      _lastSuccessfulSensorAt = now;
      if (telemetryDegraded) telemetryDegraded = false;
      final sensor = sensorsById[event.sensorId];
      if (sensor?.id == 'engine_rpm' && !_acceptRpmSample(event.value)) {
        logUserAction('Rejected implausible RPM sample: ${event.value}');
        return;
      }
      if (sensor != null) logger.record(event, sensor);
      _considerAutoLog(event);
      // Rust and HSFZ identify the DME at address 0x12 (18 decimal).
      if (sensor?.ecu == 0x12) engineEcuDetected = true;
    }
    setState(() {
      if (event.kind == 'sensor') {
        values[event.sensorId] = event.value;
      } else if (event.kind == 'vin') {
        vin = event.vin;
        unawaited(_loadFlapPreferenceForVin(event.vin));
        if (event.vin == 'DEMOF82S55MOBILE') engineEcuDetected = true;
      } else if (event.kind == 'ecu_identity') {
        engineEcuIdentity = event.ecuIdentity;
        engineEcuDetected = event.ecuAddress == 0x12 || engineEcuDetected;
        engineEcuCapturedAt = DateTime.now();
      } else if (event.kind == 'ecu_fingerprint') {
        engineEcuHardware = event.ecuHardware.isEmpty
            ? null
            : event.ecuHardware;
        engineEcuSoftware = event.ecuSoftware.isEmpty
            ? null
            : event.ecuSoftware;
        engineEcuBootloader = event.ecuBootloader.isEmpty
            ? null
            : event.ecuBootloader;
        engineEcuCalibration = event.ecuCalibration.isEmpty
            ? null
            : event.ecuCalibration;
        engineEcuApplicationSoftware = event.ecuApplicationSoftware.isEmpty
            ? null
            : event.ecuApplicationSoftware;
        engineEcuSoftwareVersion = event.ecuSoftwareVersion.isEmpty
            ? null
            : event.ecuSoftwareVersion;
        engineEcuSupplierHardware = event.ecuSupplierHardware.isEmpty
            ? null
            : event.ecuSupplierHardware;
        engineEcuSupplierSoftware = event.ecuSupplierSoftware.isEmpty
            ? null
            : event.ecuSupplierSoftware;
        engineEcuBootloaderFingerprint = event.ecuBootloaderFingerprint.isEmpty
            ? null
            : event.ecuBootloaderFingerprint;
        engineEcuSoftwareFingerprint = event.ecuSoftwareFingerprint.isEmpty
            ? null
            : event.ecuSoftwareFingerprint;
        engineEcuCalibrationFingerprint =
            event.ecuCalibrationFingerprint.isEmpty
            ? null
            : event.ecuCalibrationFingerprint;
        engineEcuSgbdIndex = event.ecuSgbdIndex.isEmpty
            ? null
            : event.ecuSgbdIndex;
        engineEcuSerialNumber = event.ecuSerialNumber.isEmpty
            ? null
            : event.ecuSerialNumber;
        engineEcuManufacturingDate = event.ecuManufacturingDate.isEmpty
            ? null
            : event.ecuManufacturingDate;
        engineEcuDiagnosticSession = event.ecuDiagnosticSession.isEmpty
            ? null
            : event.ecuDiagnosticSession;
        engineEcuCodingId = event.ecuCodingId.isEmpty
            ? null
            : event.ecuCodingId;
        engineEcuCvn = event.ecuCvn.isEmpty ? null : event.ecuCvn;
        engineEcuBmwRoutine0205Raw = event.ecuBmwRoutine0205Raw.isEmpty
            ? null
            : event.ecuBmwRoutine0205Raw;
        engineEcuBmwRoutine0205Software =
            event.ecuBmwRoutine0205Software.isEmpty
            ? null
            : event.ecuBmwRoutine0205Software;
        engineEcuBmwControllerFamily = event.ecuBmwControllerFamily.isEmpty
            ? null
            : event.ecuBmwControllerFamily;
        engineEcuBmwVariant = event.ecuBmwVariant.isEmpty
            ? null
            : event.ecuBmwVariant;
        engineEcuBmwTransmission = event.ecuBmwTransmission.isEmpty
            ? null
            : event.ecuBmwTransmission;
        engineEcuBmwEmissions = event.ecuBmwEmissions.isEmpty
            ? null
            : event.ecuBmwEmissions;
        engineEcuBmwInternalToken = event.ecuBmwInternalToken.isEmpty
            ? null
            : event.ecuBmwInternalToken;
        engineEcuCapturedAt = DateTime.now();
      } else if (event.kind == 'mileage') {
        mileageKm = event.value;
      } else {
        const phases = {
          'connected',
          'identifying',
          'discovering',
          'connecting',
          'reconnecting',
          'disconnected',
          'error',
        };
        if (phases.contains(event.kind)) phase = event.kind;
        if (event.kind == 'warning') phase = 'error';
        if (event.kind == 'monitoring_started') {
          monitoringActive = true;
          telemetryDegraded = false;
          lastTelemetryAt = DateTime.now();
        }
        if (event.kind == 'monitoring_stopped') {
          monitoringActive = false;
          telemetryDegraded = false;
          lastTelemetryAt = null;
          _lastSensorSampleAt = null;
          _lastSensorAtById.clear();
          _lastSuccessfulSensorId = null;
          _lastSuccessfulSensorAt = null;
          if (logger.isRecording) unawaited(stopLogging());
        }
        connectionStatus.value = connectionStageLabel;
        if (event.kind == 'connected' || event.kind == 'disconnected') {
          sessionResumeInProgress = false;
        }
        if (event.kind == 'disconnected' ||
            event.kind == 'warning' ||
            event.kind == 'error') {
          // Native transport has concluded this session (including loss of
          // the ENET route after ignition-off), so close the diagnostic file
          // at the actual disconnect rather than leaving it marked active.
          if (event.kind == 'disconnected') {
            unawaited(_finishDiagnosticsSession());
          }
          if (logger.isRecording) unawaited(stopLogging());
          clearVehicleIdentity();
          values.clear();
          sessionStartedAt = null;
          engineEcuDetected = false;
          lastTelemetryAt = null;
          _lastSensorSampleAt = null;
          _lastSensorAtById.clear();
          _lastSuccessfulSensorId = null;
          _lastSuccessfulSensorAt = null;
          telemetryDegraded = false;
          monitoringActive = false;
          engineEcuIdentity = null;
          engineEcuHardware = null;
          engineEcuSoftware = null;
          engineEcuBootloader = null;
          engineEcuCalibration = null;
          engineEcuApplicationSoftware = null;
          engineEcuSoftwareVersion = null;
          engineEcuSupplierHardware = null;
          engineEcuSupplierSoftware = null;
          engineEcuBootloaderFingerprint = null;
          engineEcuSoftwareFingerprint = null;
          engineEcuCalibrationFingerprint = null;
          simulatorActive = false;
          demoActive = false;
        }
        final visibleMessage = switch (event.kind) {
          'connected' => 'Session active',
          'identifying' => 'Identifying vehicle',
          'connecting' => 'Opening vehicle session',
          'reconnecting' => 'Trying to reconnect',
          'discovering' => 'Vehicle not found yet',
          _ => event.message,
        };
        detail = event.kind == 'warning'
            ? _friendlyConnectionError(event.message)
            : visibleMessage;
        events.insert(
          0,
          '${DateTime.now().toIso8601String().substring(11, 19)}  $visibleMessage',
        );
        if (events.length > 30) events.removeLast();
      }
    });
    if (event.kind == 'connected') {
      unawaited(_applySavedFlapPreferenceIfEnabled());
    }
    if (event.kind == 'sensor') _checkIgnitionOffSignature();
    logUserAction(
      'Vehicle event: ${event.kind}${event.sensorId.isEmpty ? '' : ' ${event.sensorId}=${event.value}'}${event.message.isEmpty ? '' : ' (${event.message})'}',
    );
    _updateScreenWakeLock();
  }

  bool _acceptRpmSample(double next) {
    final previous = values['engine_rpm'];
    if (next < 0 || next > 8000) return false;
    if (next == 0) {
      _consecutiveZeroRpmSamples++;
      // Ignore one isolated zero while the engine is running, but accept a
      // second consecutive zero. The latter is the normal ignition-on,
      // engine-off state and must clear a stale startup RPM value.
      return previous == null ||
          previous < 300 ||
          _consecutiveZeroRpmSamples >= 2;
    }
    _consecutiveZeroRpmSamples = 0;
    if (previous == null) return true;
    // A one-frame 0/6000 alternation while idling is a transport/parser
    // glitch, not a plausible engine state. Keep the last stable reading.
    if (next < 300) return false;
    if (previous <= 2000 && next >= 4000) return false;
    return true;
  }

  String _friendlyConnectionError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('connection refused')) {
      return 'Error ID NET-002';
    }
    if (lower.contains('timed out') || lower.contains('timeout')) {
      return 'Error ID NET-001';
    }
    if (lower.contains('connection reset')) {
      return 'Error ID NET-003';
    }
    if (lower.contains('no route') ||
        lower.contains('network is unreachable')) {
      return 'Error ID NET-004';
    }
    if (lower.contains('not found') || lower.contains('unreachable')) {
      return 'Error ID NET-005';
    }
    return 'Error ID NET-999';
  }

  void _considerAutoLog(VehicleEvent event) {
    if (event.sensorId != 'throttle_angle') {
      return;
    }
    final decision = _autoLogTrigger.observe(
      enabled: autoLogEnabled && !widget.previewMode,
      sessionActive: live && monitoringActive,
      isRecording: logger.isRecording,
      automaticRecording: _autoLogRecording,
      throttlePercent: event.value,
      startThreshold: autoLogThreshold,
      releaseDelay: Duration(seconds: autoLogReleaseDelaySeconds),
      now: DateTime.now(),
    );
    switch (decision) {
      case AutoLogDecision.start:
        if (!_autoLogStartInProgress) {
          _autoLogStartInProgress = true;
          unawaited(
            startLogging(automatic: true).whenComplete(() {
              _autoLogStartInProgress = false;
            }),
          );
        }
        break;
      case AutoLogDecision.stop:
        unawaited(stopLogging(automatic: true));
        break;
      case AutoLogDecision.none:
        break;
    }
  }

  Future<void> toggleLogging() async {
    if (logger.isRecording) {
      await stopLogging();
      return;
    }
    await startLogging();
  }

  Future<void> startLogging({bool automatic = false}) async {
    if (!live || !monitoringActive || widget.previewMode) return;
    try {
      await logger.start(
        vin: vin,
        sessionId: sessionId,
        source: simulatorActive
            ? 'simulator'
            : demoActive
            ? 'demo'
            : 'vehicle',
        vehicleProfile: identifyVehicle(vin)?.profile.id,
        ecuIdentity: engineEcuIdentity,
        ecuSoftware: engineEcuSoftware ?? engineEcuSoftwareVersion,
        ecuCalibration: engineEcuCalibration ?? engineEcuCvn,
      );
      _autoLogRecording = automatic;
      _autoLogTrigger.reset();
      if (automatic) logger.addMarker('Automatic pull log started');
      loggingElapsed = Duration.zero;
      loggingTimer?.cancel();
      loggingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final started = logger.startedAt;
        if (mounted && started != null) {
          setState(() => loggingElapsed = DateTime.now().difference(started));
        }
      });
      HapticFeedback.mediumImpact();
      if (mounted) setState(() {});
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not start logging: $error')),
      );
    }
  }

  Future<void> stopLogging({bool automatic = false}) async {
    final wasAutomatic = _autoLogRecording || automatic;
    if (wasAutomatic) logger.addMarker('Automatic pull log stopped');
    _autoLogRecording = false;
    _autoLogTrigger.reset();
    loggingTimer?.cancel();
    loggingTimer = null;
    final file = await logger.stop();
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    setState(() {});
    if (file != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${wasAutomatic ? 'Automatic pull log saved' : 'Saved'} ${logger.sampleCount} samples to CSV.',
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Logs',
            onPressed: () => setState(() => selectedTab = 3),
          ),
        ),
      );
    }
  }

  void addLogMarker() {
    if (!logger.addMarker()) return;
    logUserAction('Added manual log marker');
    HapticFeedback.selectionClick();
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marker added to the active log.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> selectTab(int index) async {
    if (index == 4 && !ProductConfig.tuningEnabled) return;
    if (index == 2 && logger.isRecording) await stopLogging();
    if (!mounted) return;
    HapticFeedback.selectionClick();
    logUserAction(
      'Selected ${switch (index) {
        0 => 'Vehicle',
        2 => 'Diagnostics',
        3 => 'Logging',
        _ => 'Other',
      }} page',
    );
    setState(() {
      selectedTab = index;
      editing = false;
      resizingSensorId = null;
    });
  }

  Future<void> showConnectionGuide() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (guideContext) => ConnectionGuideScreen(
          isDark: widget.isDark,
          onDone: () async => Navigator.of(guideContext).pop(),
        ),
      ),
    );
  }

  Future<void> showTuneGuide() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TuneGuideScreen(isDark: widget.isDark),
      ),
    );
  }

  bool get _isDesktop => switch (Theme.of(context).platform) {
    TargetPlatform.windows ||
    TargetPlatform.macOS ||
    TargetPlatform.linux => true,
    _ => false,
  };

  Widget _desktopFrame(Widget child) => _isDesktop
      ? Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: child,
          ),
        )
      : child;

  @override
  Widget build(BuildContext context) => fullscreen
      ? fullscreenDashboard()
      : Scaffold(
          drawer: _sideMenu(context),
          body: Stack(
            children: [
              Positioned.fill(
                child: _desktopFrame(switch (selectedTab) {
                  0 => minimalVehicleHub(),
                  2 => DiagnosticsScreen(
                    isDark: widget.isDark,
                    connectionLabel: connectionStageLabel,
                    onToggleTheme: widget.onToggleTheme,
                    onShowGuide: showConnectionGuide,
                    vin: vin,
                    onBeforeVehicleScan: pauseLiveSessionForScan,
                    onAfterVehicleScan: resumeLiveSessionAfterScan,
                    onScanEvent: logUserAction,
                    onSetFlapMode: setFlapMode,
                    previewMode: widget.previewMode,
                    simulatorMode: simulatorActive,
                  ),
                  3 => LoggingScreen(
                    isDark: widget.isDark,
                    connectionLabel: connectionStageLabel,
                    onToggleTheme: widget.onToggleTheme,
                    onShowGuide: showConnectionGuide,
                    isRecording: logger.isRecording,
                    sampleCount: logger.sampleCount,
                    elapsed: loggingElapsed,
                    canRecord: live && monitoringActive && !widget.previewMode,
                    isConnected: live,
                    onToggleRecording: toggleLogging,
                    autoLogEnabled: autoLogEnabled,
                    autoLogThreshold: autoLogThreshold,
                    autoLogReleaseDelaySeconds: autoLogReleaseDelaySeconds,
                    onAutoLogChanged: setAutoLogEnabled,
                    onAutoLogThresholdChanged: setAutoLogThreshold,
                    onAutoLogReleaseDelayChanged: setAutoLogReleaseDelay,
                    telemetryDegraded: telemetryDegraded,
                    telemetryGapCount: telemetryGapCount,
                    maxTelemetryGapMs: maxTelemetryGapMs,
                    previewMode: widget.previewMode,
                  ),
                  4 when ProductConfig.tuningEnabled => TuneScreen(
                    isDark: widget.isDark,
                    vin: vin,
                    mileageKm: mileageKm,
                    connectionLabel: connectionStageLabel,
                    simulatorMode: simulatorActive,
                    engineEcuDetected: engineEcuDetected,
                    engineEcuIdentity: engineEcuIdentity,
                    engineEcuHardware: engineEcuHardware,
                    engineEcuSoftware: engineEcuSoftware,
                    engineEcuBootloader: engineEcuBootloader,
                    engineEcuCalibration: engineEcuCalibration,
                    engineEcuApplicationSoftware: engineEcuApplicationSoftware,
                    engineEcuSoftwareVersion: engineEcuSoftwareVersion,
                    engineEcuSupplierHardware: engineEcuSupplierHardware,
                    engineEcuSupplierSoftware: engineEcuSupplierSoftware,
                    engineEcuBootloaderFingerprint:
                        engineEcuBootloaderFingerprint,
                    engineEcuSoftwareFingerprint: engineEcuSoftwareFingerprint,
                    engineEcuCalibrationFingerprint:
                        engineEcuCalibrationFingerprint,
                    engineEcuSgbdIndex: engineEcuSgbdIndex,
                    engineEcuSerialNumber: engineEcuSerialNumber,
                    engineEcuManufacturingDate: engineEcuManufacturingDate,
                    engineEcuCodingId: engineEcuCodingId,
                    engineEcuCvn: engineEcuCvn,
                    sessionId: sessionId,
                    identityCapturedAt: engineEcuCapturedAt,
                    onSelectGarageVehicle: selectGarageVehicle,
                    onShowGuide: showTuneGuide,
                    onToggleTheme: widget.onToggleTheme,
                    onBeforeVehicleCheck: pauseLiveSessionForScan,
                    onAfterVehicleCheck: resumeLiveSessionAfterScan,
                  ),
                  _ => ColoredBox(
                    color: AppPalette.background(widget.isDark),
                    child: SafeArea(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Header(
                              phase: phase,
                              vin: vin,
                              detail: detail,
                              isDark: widget.isDark,
                              onToggleTheme: widget.onToggleTheme,
                              editing: editing,
                              onToggleEditing: () => setState(() {
                                editing = !editing;
                                if (!editing) resizingSensorId = null;
                              }),
                              onShowGuide: showConnectionGuide,
                              onSimulator: () => connect(simulator: true),
                            ),
                          ),
                          if (editing)
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(
                                dashboardHorizontalPadding,
                                0,
                                dashboardHorizontalPadding,
                                12,
                              ),
                              sliver: SliverToBoxAdapter(child: editBanner()),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(
                              dashboardHorizontalPadding,
                              sectionTitleTopGap + 6,
                              dashboardHorizontalPadding,
                              sectionTitleBottomGap,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: telemetryHeader(),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: dashboardHorizontalPadding,
                            ),
                            sliver: SliverToBoxAdapter(child: gaugeBoard()),
                          ),
                        ],
                      ),
                    ),
                  ),
                }),
              ),
            ],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedTab == 1) monitorPrimaryAction(),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppPalette.separator(widget.isDark),
                      width: 1,
                    ),
                  ),
                ),
                child: NavigationBar(
                  selectedIndex: selectedTab,
                  onDestinationSelected: selectTab,
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.directions_car_outlined),
                      selectedIcon: Icon(Icons.directions_car_filled),
                      label: 'Vehicle',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.speed_outlined),
                      selectedIcon: Icon(Icons.speed_rounded),
                      label: 'Monitor',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.health_and_safety_outlined),
                      selectedIcon: Icon(Icons.health_and_safety_rounded),
                      label: 'Diagnostics',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.show_chart_outlined),
                      selectedIcon: Icon(Icons.show_chart_rounded),
                      label: 'Logs',
                    ),
                    if (ProductConfig.tuningEnabled)
                      const NavigationDestination(
                        icon: Icon(Icons.tune_outlined),
                        selectedIcon: Icon(Icons.tune_rounded),
                        label: 'Tune',
                      ),
                  ],
                ),
              ),
            ],
          ),
        );

  Widget _sideMenu(BuildContext context) {
    final isDark = widget.isDark;
    final background = isDark
        ? const Color(0xFF1B1F24)
        : const Color(0xFFF7F8FA);
    final foreground = isDark
        ? const Color(0xFFE7EAF0)
        : const Color(0xFF1B1F24);
    final muted = isDark ? const Color(0xFFC3C7D0) : const Color(0xFF656B76);
    final divider = isDark ? const Color(0xFF3B4048) : const Color(0xFFD9DDE3);

    return Drawer(
      width: MediaQuery.sizeOf(context).width * .68,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: background,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: ColoredBox(
          color: background,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 224,
                padding: const EdgeInsets.fromLTRB(30, 28, 28, 22),
                color: AppPalette.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/branding/bimmerscope_icon.png',
                        width: 62,
                        height: 62,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'BimmerScope',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${BuildInfo.version} · ${ProductConfig.editionName}',
                          style: const TextStyle(
                            color: Color(0xFFDAE9FF),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _drawerItem(
                icon: Icons.play_arrow_rounded,
                title: 'Try demo',
                subtitle: 'Explore without a vehicle',
                foreground: foreground,
                muted: muted,
                iconBackground: isDark
                    ? const Color(0xFF20344E)
                    : const Color(0xFFDCEBFF),
                iconColor: AppPalette.blue,
                onTap: () {
                  Navigator.pop(context);
                  if (!active) connect(demo: true);
                },
                topPadding: 22,
                bottomPadding: 20,
              ),
              const SizedBox(height: 4),
              _menuItem(
                context,
                Icons.directions_car_rounded,
                'Vehicle',
                0,
                foreground: foreground,
                muted: muted,
              ),
              _menuItem(
                context,
                Icons.speed_rounded,
                'Monitor',
                1,
                foreground: foreground,
                muted: muted,
              ),
              _menuItem(
                context,
                Icons.health_and_safety_rounded,
                'Diagnostics',
                2,
                foreground: foreground,
                muted: muted,
              ),
              _menuItem(
                context,
                Icons.show_chart_rounded,
                'Logs',
                3,
                foreground: foreground,
                muted: muted,
              ),
              if (ProductConfig.tuningEnabled)
                _menuItem(
                  context,
                  Icons.tune_rounded,
                  'Tune',
                  4,
                  foreground: foreground,
                  muted: muted,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 22, 26, 20),
                child: Divider(height: 1, color: divider),
              ),
              _drawerItem(
                icon: Icons.desktop_windows_rounded,
                title: 'Connect simulator',
                foreground: foreground,
                muted: muted,
                onTap: () {
                  Navigator.pop(context);
                  if (!active) connect(simulator: true);
                },
              ),
              _drawerItem(
                icon: Icons.cable_rounded,
                title: 'Connection guide',
                foreground: foreground,
                muted: muted,
                onTap: () {
                  Navigator.pop(context);
                  showConnectionGuide();
                },
              ),
              _drawerItem(
                icon: Icons.help_outline_rounded,
                title: 'Help',
                foreground: foreground,
                muted: muted,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => HelpScreen(isDark: widget.isDark),
                    ),
                  );
                },
              ),
              _drawerItem(
                icon: Icons.bug_report_rounded,
                title: 'App diagnostics',
                subtitle: 'Browse saved connection sessions',
                foreground: foreground,
                muted: muted,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AppDiagnosticsScreen(
                        isDark: widget.isDark,
                        onExportCurrent: exportAppDiagnostics,
                      ),
                    ),
                  );
                },
              ),
              _drawerItem(
                icon: Icons.info_outline_rounded,
                title: 'About BimmerScope',
                foreground: foreground,
                muted: muted,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AboutScreen(isDark: widget.isDark),
                    ),
                  );
                },
              ),
              _drawerItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                foreground: foreground,
                muted: muted,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SettingsScreen(
                        isDark: widget.isDark,
                        onToggleTheme: widget.onToggleTheme,
                        onShowConnectionGuide: showConnectionGuide,
                        onUnitsChanged: (value) {
                          if (mounted) setState(() => useMetric = !value);
                        },
                      ),
                    ),
                  );
                },
              ),
              _drawerItem(
                icon: widget.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                title: widget.isDark ? 'Use light mode' : 'Use dark mode',
                foreground: foreground,
                muted: muted,
                bottomPadding: 18,
                onTap: () {
                  Navigator.pop(context);
                  widget.onToggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    int index, {
    required Color foreground,
    required Color muted,
  }) => _drawerItem(
    icon: icon,
    title: label,
    foreground: foreground,
    muted: muted,
    selected: selectedTab == index,
    onTap: () {
      Navigator.pop(context);
      selectTab(index);
    },
  );

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required Color foreground,
    required Color muted,
    required VoidCallback onTap,
    String? subtitle,
    Color? iconBackground,
    Color? iconColor,
    bool selected = false,
    double topPadding = 2,
    double bottomPadding = 2,
  }) {
    final activeColor = selected ? AppPalette.blue : muted;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, topPadding, 18, bottomPadding),
      child: Material(
        color: selected
            ? AppPalette.blue.withValues(alpha: .10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Semantics(
          button: true,
          selected: selected,
          label: subtitle == null ? title : '$title, $subtitle',
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 66,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: iconBackground == null
                          ? Icon(icon, color: activeColor, size: 27)
                          : Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: iconBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                color: iconColor ?? activeColor,
                                size: 29,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: selected ? AppPalette.blue : foreground,
                              fontSize: subtitle == null ? 18 : 20,
                              fontWeight: subtitle == null
                                  ? FontWeight.w400
                                  : FontWeight.w500,
                              letterSpacing: subtitle == null ? -.15 : -.35,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: muted,
                                fontSize: 13,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget connectionStatusPill() {
    final label = connectionStageLabel;
    final tone = AppPalette.connectionTone(label);
    final color = AppPalette.status(tone, widget.isDark);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.surface(widget.isDark),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: .28)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppPalette.statusIcon(tone), size: 14, color: color),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget connectionButton() {
    final connecting =
        phase == 'connecting' ||
        phase == 'identifying' ||
        phase == 'discovering' ||
        phase == 'reconnecting';
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final backgroundColor = active
        ? AppPalette.surface(widget.isDark)
        : AppPalette.blue;
    final foregroundColor = active
        ? Theme.of(context).colorScheme.onSurface
        : Colors.white;
    return SizedBox(
      key: const Key('vehicle-connect-button'),
      height: 54,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _handleConnectTap,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: active
              ? BorderSide(color: AppPalette.separator(widget.isDark))
              : BorderSide.none,
        ),
        icon: connecting && !reduceMotion
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                connecting
                    ? Icons.sync_rounded
                    : active
                    ? Icons.check_circle_outline_rounded
                    : Icons.radar_rounded,
              ),
        label: Text(connectionActionLabel),
      ),
    );
  }

  Widget connectionOrb() {
    final connecting =
        phase == 'connecting' ||
        phase == 'identifying' ||
        phase == 'discovering' ||
        phase == 'reconnecting';
    // This is an action control, not a status indicator. Its status is shown
    // separately by connectionStatusPill, so the action remains primary blue.
    const color = AppPalette.blue;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Column(
      children: [
        Semantics(
          button: true,
          label: connectionActionLabel,
          child: InkWell(
            key: const Key('vehicle-connect-orb'),
            onTap: _handleConnectTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: .13),
                border: Border.all(
                  color: color.withValues(alpha: .65),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: .28),
                    blurRadius: 22,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: connecting && !reduceMotion
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: color,
                        ),
                      )
                    : Icon(
                        connecting
                            ? Icons.sync_rounded
                            : active
                            ? Icons.link_rounded
                            : Icons.link_off_rounded,
                        color: color,
                        size: 26,
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          connecting
              ? 'Cancel'
              : active
              ? 'Disconnect'
              : 'Connect',
          style: TextStyle(
            color: widget.isDark ? Colors.white : const Color(0xFF1C1C1E),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          connectionDetailLabel,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.isDark
                ? const Color(0xFF98989F)
                : const Color(0xFF6E6E73),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget minimalVehicleHub() {
    final background = widget.isDark
        ? const Color(0xFF000000)
        : const Color(0xFFF2F2F7);
    final artworkHeight = (MediaQuery.sizeOf(context).width / 1.95).clamp(
      168.0,
      212.0,
    );

    return ColoredBox(
      color: background,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 10, 12),
                  sliver: SliverToBoxAdapter(
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
                                  tooltip: 'Open menu',
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer(),
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
                              label: _statusLabelForPhase(phase),
                              isDark: widget.isDark,
                              iconOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              live && vin != 'Not identified'
                                  ? vin
                                  : 'Your car',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: widget.isDark
                                    ? const Color(0xFF8E98A8)
                                    : const Color(0xFF6E6E73),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 34,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text.rich(
                              live && vin != 'Not identified'
                                  ? TextSpan(
                                      children: [
                                        const TextSpan(text: 'BMW '),
                                        TextSpan(
                                          text:
                                              '${identifyVehicle(vin)?.chassis ?? 'F-series'} '
                                              '${identifyVehicle(vin)?.model ?? ''}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const TextSpan(
                                      text: 'Not identified',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: widget.isDark
                                    ? Colors.white
                                    : const Color(0xFF1C1C1E),
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.45,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 38, child: const SizedBox.shrink()),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
                    child: Container(
                      height: artworkHeight,
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              widget.isDark
                                  ? Color(0xFFB7C0CC)
                                  : Color(0xFF27364A),
                              BlendMode.srcIn,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final cropHeight = artworkHeight * 1.28;
                                final cropWidth = cropHeight * 2.25;
                                return ClipRect(
                                  child: OverflowBox(
                                    alignment: Alignment.centerLeft,
                                    minWidth: 0,
                                    minHeight: 0,
                                    maxWidth: cropWidth,
                                    maxHeight: cropHeight,
                                    child: SizedBox(
                                      width: cropWidth,
                                      height: cropHeight,
                                      child: Image.asset(
                                        'assets/branding/f82_silhouette.png',
                                        fit: BoxFit.fill,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 2, 22, 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              vehicleQuickAction(
                                Icons.settings_remote_rounded,
                                'Flap',
                                (_flapControlAvailable || demoActive)
                                    ? showFlapControl
                                    : null,
                                accentColor: flapMode.startsWith('open')
                                    ? AppPalette.orange
                                    : flapMode == 'closed'
                                    ? AppPalette.red
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              vehicleQuickAction(
                                Icons.directions_car_rounded,
                                'Details',
                                live && vin != 'Not identified'
                                    ? showVehicleDetails
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  // Reserve scroll space for the floating connection action
                  // so the last content card is never hidden behind it.
                  child: Column(
                    children: [
                      SizedBox(height: floatingConnectionPanelClearance),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 33,
              right: 33,
              bottom: 12,
              child: SizedBox(
                height: 92,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: compactConnectionPanel(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get detectedVehicleLabel {
    if (vin == 'Not identified' || vin.isEmpty) return 'BMW F-series';
    return identifyVehicle(vin)?.displayLabel ?? 'BMW F-series';
  }

  Widget compactConnectionPanel() {
    final connecting =
        phase == 'connecting' ||
        phase == 'identifying' ||
        phase == 'discovering' ||
        phase == 'reconnecting';
    final tone = AppPalette.connectionTone(connectionStageLabel);
    final color = AppPalette.status(tone, widget.isDark);
    final buttonColor = active ? color : AppPalette.blue;
    final icon = connecting
        ? Icons.sync_rounded
        : active
        ? Icons.link_rounded
        : Icons.link_off_rounded;
    return Semantics(
      container: true,
      label: '$connectionStageLabel. $connectionDetailLabel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      connectionDetailLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppPalette.secondary(widget.isDark),
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Material(
              color: buttonColor,
              elevation: widget.isDark ? 8 : 4,
              shadowColor: buttonColor.withValues(alpha: .35),
              borderRadius: BorderRadius.circular(14),
              child: FilledButton.icon(
                key: const Key('vehicle-connect-button'),
                onPressed: diagnosticSessionTransition
                    ? null
                    : _handleConnectTap,
                icon: connecting
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(icon, size: 17),
                label: Text(connectionActionLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showVehicleDetails() {
    final identity = identifyVehicle(vin);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VehicleDetailsScreen(
          isDark: widget.isDark,
          vin: vin,
          identity: identity,
          mileageKm: mileageKm,
          engineEcuDetected: engineEcuDetected,
          engineEcuIdentity: engineEcuIdentity,
          engineEcuHardware: engineEcuHardware,
          engineEcuSoftware: engineEcuSoftware,
          engineEcuBootloader: engineEcuBootloader,
          engineEcuCalibration: engineEcuCalibration,
          engineEcuCodingId: engineEcuCodingId,
          engineEcuManufacturingDate: engineEcuManufacturingDate,
          engineEcuDiagnosticSession: engineEcuDiagnosticSession,
          engineEcuApplicationSoftware: engineEcuApplicationSoftware,
          engineEcuSupplierHardware: engineEcuSupplierHardware,
          engineEcuSupplierSoftware: engineEcuSupplierSoftware,
          engineEcuBmwRoutine0205Raw: engineEcuBmwRoutine0205Raw,
          engineEcuBmwRoutine0205Software: engineEcuBmwRoutine0205Software,
          engineEcuBmwControllerFamily: engineEcuBmwControllerFamily,
          engineEcuBmwVariant: engineEcuBmwVariant,
          engineEcuBmwTransmission: engineEcuBmwTransmission,
          engineEcuBmwEmissions: engineEcuBmwEmissions,
          engineEcuBmwInternalToken: engineEcuBmwInternalToken,
        ),
      ),
    );
  }

  String get vehicleDisplayTitle {
    final year = _modelYearLabel;
    if (year == '-' || detectedVehicleLabel.contains(year)) {
      return detectedVehicleLabel;
    }
    return '$detectedVehicleLabel · $year';
  }

  String get vehicleModelTitle {
    final identity = identifyVehicle(vin);
    if (identity == null) return detectedVehicleLabel;
    return 'BMW ${identity.chassis} ${identity.model}';
  }

  Widget toolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) => Semantics(
    button: true,
    label: '$title, $subtitle',
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(appCardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(appCardRadius),
        child: Padding(
          padding: appCardPadding,
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    ),
  );

  Widget minimalAction({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color? separator,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              decoration: separator == null
                  ? null
                  : BoxDecoration(
                      border: Border(bottom: BorderSide(color: separator)),
                    ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -.15,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget vehicleHub() {
    final scheme = Theme.of(context).colorScheme;
    final muted = widget.isDark
        ? const Color(0xFF9AA4B7)
        : const Color(0xFF667085);
    final surface = widget.isDark ? const Color(0xFF151A24) : Colors.white;
    final connected = live;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.isDark
              ? const [Color(0xFF101522), Color(0xFF080A10)]
              : const [Color(0xFFF7F9FE), Color(0xFFEEF1F8)],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BIMMERSCOPE',
                            style: TextStyle(
                              color: scheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.8,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Your vehicle',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ConnectionStatusChip(
                      label: _statusLabelForPhase(phase),
                      isDark: widget.isDark,
                      iconOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF176BDF), Color(0xFF123B86)],
                    ),
                    borderRadius: BorderRadius.circular(appSheetRadius),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33104EAF),
                        blurRadius: 28,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .14),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.cable_rounded,
                                  color: Colors.white,
                                  size: 23,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Text(
                            connected ? detectedVehicleLabel : 'BMW F-series',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            connectionDetailLabel,
                            style: const TextStyle(
                              color: Color(0xFFD9E7FF),
                              fontSize: 14,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 22),
                          connectionOrb(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 9),
              sliver: SliverToBoxAdapter(
                child: Semantics(
                  header: true,
                  child: Text(
                    'Tools',
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.45,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                ),
                delegate: SliverChildListDelegate([
                  hubAction(
                    icon: Icons.speed_rounded,
                    title: 'Monitor',
                    subtitle: '${visibleSensorIds.length} active gauges',
                    surface: surface,
                    muted: muted,
                    onTap: () => selectTab(1),
                  ),
                  hubAction(
                    icon: Icons.health_and_safety_rounded,
                    title: 'Diagnostics',
                    subtitle: 'Read engine faults',
                    surface: surface,
                    muted: muted,
                    onTap: () => selectTab(2),
                  ),
                  hubAction(
                    icon: Icons.settings_remote_rounded,
                    title: 'Flap control',
                    subtitle: demoActive
                        ? 'Demo'
                        : _flapControlAvailable
                        ? 'Validated vehicle'
                        : 'Available after validation',
                    surface: surface,
                    muted: muted,
                    onTap: showFlapControl,
                    enabled: _flapControlAvailable || demoActive,
                  ),
                  hubAction(
                    icon: logger.isRecording
                        ? Icons.stop_circle_rounded
                        : Icons.show_chart_rounded,
                    title: 'Logs',
                    subtitle: logger.isRecording
                        ? '${logger.sampleCount} samples recorded'
                        : 'Record and share CSV',
                    surface: surface,
                    muted: muted,
                    onTap: () => selectTab(3),
                  ),
                  hubAction(
                    icon: Icons.menu_book_rounded,
                    title: 'Connection guide',
                    subtitle: 'Cable, ignition and setup',
                    surface: surface,
                    muted: muted,
                    onTap: showConnectionGuide,
                  ),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: scheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Semantics(
                              header: true,
                              child: Text(
                                'Before you connect',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ignition on · ENET connected · Airplane mode recommended',
                              style: TextStyle(
                                color: muted,
                                height: 1.4,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget identificationPanel({
    required Color surface,
    required Color separator,
    required Color secondary,
  }) {
    final identity = identifyVehicle(vin);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: identityCell(
                  'Mileage',
                  mileageKm == null ? '-' : '${mileageKm!.round()} km',
                  secondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: identityCell(
                  'Engine',
                  identity?.engine.isNotEmpty == true ? identity!.engine : '-',
                  secondary,
                  emphasized: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: identityCell(
                  'Transmission',
                  identity?.transmission.isNotEmpty == true
                      ? identity!.transmission
                      : '-',
                  secondary,
                  emphasized: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: identityCell(
                  'Market / steering',
                  ([identity?.market, identity?.steering]
                              .where((value) => value?.isNotEmpty == true)
                              .join(' · '))
                          .isEmpty
                      ? '-'
                      : [identity?.market, identity?.steering]
                            .where((value) => value?.isNotEmpty == true)
                            .join(' · '),
                  secondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: identityCell(
                  'Engine ECU',
                  engineEcuDetected ? (engineEcuIdentity ?? 'Detected') : '-',
                  secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget vehicleQuickAction(
    IconData icon,
    String label,
    VoidCallback? onTap, {
    Color? accentColor,
  }) => SizedBox(
    width: 84,
    child: Column(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: IconButton.filledTonal(
            onPressed: onTap,
            icon: Icon(icon, size: 24),
            tooltip: label,
            style: IconButton.styleFrom(
              foregroundColor: onTap == null
                  ? AppPalette.secondary(widget.isDark)
                  : accentColor ?? AppPalette.blue,
              backgroundColor: (accentColor ?? AppPalette.blue).withValues(
                alpha: .12,
              ),
              overlayColor: (accentColor ?? AppPalette.blue).withValues(
                alpha: .16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  String get _modelYearLabel {
    return '${identifyVehicle(vin)?.modelYear ?? '-'}';
  }

  Widget identityCell(
    String label,
    String value,
    Color secondary, {
    bool emphasized = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: secondary, fontSize: 10)),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget identityRow(
    String label,
    String value,
    Color secondary,
    Color separator, {
    bool last = false,
    bool emphasized = false,
    bool highlighted = false,
  }) => Container(
    decoration: highlighted
        ? BoxDecoration(
            color: AppPalette.blue.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(10),
          )
        : null,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                color: secondary,
                fontSize: emphasized ? 12 : 13,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: emphasized ? 15 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget hubAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color surface,
    required Color muted,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final tileSurface = enabled
        ? surface
        : Color.alphaBlend(scheme.onSurface.withValues(alpha: .035), surface);
    final tileIcon = enabled
        ? scheme.primary
        : scheme.onSurfaceVariant.withValues(alpha: .6);
    return Semantics(
      button: true,
      enabled: enabled,
      label: enabled
          ? 'Open $title. $subtitle'
          : '$title unavailable. $subtitle',
      child: Material(
        color: tileSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: tileIcon.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: tileIcon, size: 29),
                ),
                const SizedBox(height: 7),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: enabled ? null : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: enabled ? muted : scheme.onSurfaceVariant,
                    fontSize: 10,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fullscreenDashboard() => Scaffold(
    backgroundColor: Colors.black,
    body: ColoredBox(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                // Keep the floating fullscreen controls out of the first row
                // of gauges. The toolbar is rendered above this board.
                padding: const EdgeInsets.only(top: 76),
                child: fullscreenGaugeBoard(),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xD9161A20),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: landscape
                          ? 'Rotate portrait'
                          : 'Rotate landscape',
                      onPressed: rotateFullscreen,
                      color: Colors.white,
                      icon: Icon(
                        landscape
                            ? Icons.stay_current_portrait_rounded
                            : Icons.screen_rotation_rounded,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Exit full screen',
                      onPressed: toggleFullscreen,
                      color: Colors.white,
                      icon: const Icon(Icons.fullscreen_exit_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget fullscreenGaugeBoard() => LayoutBuilder(
    builder: (context, constraints) {
      final ids = fullscreenGaugeId == null
          ? visibleSensorIds
          : [fullscreenGaugeId!];
      if (ids.isEmpty) {
        return const Center(
          child: Text(
            'No gauges selected',
            style: TextStyle(color: Color(0xFF7D8796)),
          ),
        );
      }
      final landscapeLayout = constraints.maxWidth > constraints.maxHeight;
      final count = ids.length;
      final columns = count == 1
          ? 1
          : count == 2
          ? (landscapeLayout ? 2 : 1)
          : count <= 4
          ? 2
          : count <= 6
          ? (landscapeLayout ? 3 : 2)
          : (landscapeLayout ? 4 : 2);
      final rows = (count / columns).ceil();
      const gap = 12.0;
      const inset = 8.0;
      final cellWidth =
          (constraints.maxWidth - inset * 2 - gap * (columns - 1)) / columns;
      final cellHeight =
          (constraints.maxHeight - inset * 2 - gap * (rows - 1)) / rows;
      final byId = {for (final sensor in sensors) sensor.id: sensor};

      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(inset),
        itemCount: count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          childAspectRatio: cellWidth / cellHeight,
        ),
        itemBuilder: (context, index) {
          final id = ids[index];
          return GaugeCard(
            key: ValueKey('fullscreen-$id'),
            sensor: byId[id]!,
            value: values[id],
            isLive: live,
            isDark: true,
            useMetric: useMetric,
            // A tapped dial gets its own fullscreen canvas; the multi-gauge
            // fullscreen grid uses digital cards for a stable hierarchy.
            isDial: fullscreenGaugeId != null && dialSensorIds.contains(id),
            isFullscreen: true,
          );
        },
      );
    },
  );

  Widget gaugeBoard({List<String>? onlyIds, bool fillSingle = false}) =>
      LayoutBuilder(
        builder: (context, constraints) {
          const gap = 12.0;
          final columns = constraints.maxWidth < 320
              ? 1
              : constraints.maxWidth >= 900
              ? 4
              : constraints.maxWidth >= 600
              ? 3
              : 2;
          final compactWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;
          final byId = {for (final sensor in sensors) sensor.id: sensor};
          final displayedIds = onlyIds ?? visibleSensorIds;
          if (displayedIds.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppPalette.surface(widget.isDark),
                borderRadius: BorderRadius.circular(appCardRadius),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.dashboard_customize_outlined,
                    size: 30,
                    color: AppPalette.secondary(widget.isDark),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No gauges visible',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Restore the default dashboard layout to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppPalette.secondary(widget.isDark),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: resetGaugeLayout,
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('Restore gauges'),
                  ),
                ],
              ),
            );
          }
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: displayedIds.map((id) {
              final sensor = byId[id]!;
              final dial = dialSensorIds.contains(id);
              final width = fillSingle
                  ? constraints.maxWidth
                  : (gaugeWidths[id] ?? compactWidth).clamp(
                      compactWidth,
                      constraints.maxWidth,
                    );
              final height = fillSingle
                  ? constraints.maxHeight
                  : (gaugeHeights[id] ?? 164.0).clamp(140.0, 420.0);
              final card = GaugeCard(
                sensor: sensor,
                value: values[id],
                isLive: live,
                isDark: widget.isDark,
                useMetric: useMetric,
                isEditing: editing,
                isDial: dial,
                valueColorBackground: valueColorIds.contains(id),
                isFullscreen: fillSingle,
                onResize: () => startResizing(id),
                onToggleStyle: () => setState(() {
                  dial ? dialSensorIds.remove(id) : dialSensorIds.add(id);
                  _scheduleLayoutSave();
                }),
                onRemove: () {
                  setState(() {
                    visibleSensorIds.remove(id);
                    _scheduleLayoutSave();
                  });
                  _syncLiveSensorSelection();
                },
                onTapDown: editing
                    ? (details) => showGaugeMenu(id, details.globalPosition)
                    : null,
                onTap: !editing ? () => toggleFullscreen(id) : null,
              );
              final resizableCard = Stack(
                children: [
                  Positioned.fill(child: card),
                  if (editing && resizingSensorId == id)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (_) => HapticFeedback.selectionClick(),
                        onPanUpdate: (details) => resizeGauge(
                          id,
                          details.delta,
                          compactWidth,
                          constraints.maxWidth,
                        ),
                        onPanEnd: (_) => HapticFeedback.lightImpact(),
                        child: Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: const Icon(
                            Icons.open_in_full_rounded,
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
              return SizedBox(
                key: ValueKey(id),
                width: width,
                height: height,
                child: editing
                    ? DragTarget<String>(
                        onWillAcceptWithDetails: (details) =>
                            details.data != id,
                        onAcceptWithDetails: (details) =>
                            moveGauge(details.data, id),
                        builder: (context, candidates, rejected) =>
                            LongPressDraggable<String>(
                              data: id,
                              feedback: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: width,
                                  height: 150,
                                  child: resizableCard,
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: .25,
                                child: resizableCard,
                              ),
                              child: AnimatedScale(
                                scale: candidates.isEmpty ? 1 : .96,
                                duration: const Duration(milliseconds: 120),
                                child: resizableCard,
                              ),
                            ),
                      )
                    : resizableCard,
              );
            }).toList(),
          );
        },
      );

  Future<void> showGaugeMenu(String id, Offset position) async {
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final action = await showMenu<_GaugeMenuAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 1, 1),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: [
        const PopupMenuItem(
          value: _GaugeMenuAction.resize,
          child: ListTile(
            leading: Icon(Icons.aspect_ratio_rounded),
            title: Text('Resize'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: _GaugeMenuAction.fullscreen,
          child: ListTile(
            leading: Icon(Icons.fullscreen_rounded),
            title: Text('Full screen'),
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: _GaugeMenuAction.style,
          child: ListTile(
            leading: const Icon(Icons.speed_rounded),
            title: Text(
              dialSensorIds.contains(id) ? 'Digital display' : 'Dial display',
            ),
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: _GaugeMenuAction.valueColor,
          child: ListTile(
            leading: const Icon(Icons.color_lens_rounded),
            title: Text(
              valueColorIds.contains(id)
                  ? 'Neutral background'
                  : 'Reading color',
            ),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _GaugeMenuAction.move,
          child: ListTile(
            leading: Icon(Icons.drag_indicator_rounded),
            title: Text('Drag to move'),
            dense: true,
          ),
        ),
      ],
    );
    if (!mounted || action == null) return;
    switch (action) {
      case _GaugeMenuAction.resize:
        startResizing(id);
      case _GaugeMenuAction.fullscreen:
        HapticFeedback.mediumImpact();
        await toggleFullscreen(id);
      case _GaugeMenuAction.style:
        HapticFeedback.selectionClick();
        setState(() {
          dialSensorIds.contains(id)
              ? dialSensorIds.remove(id)
              : dialSensorIds.add(id);
          _scheduleLayoutSave();
        });
      case _GaugeMenuAction.valueColor:
        setState(() {
          valueColorIds.contains(id)
              ? valueColorIds.remove(id)
              : valueColorIds.add(id);
          _scheduleLayoutSave();
        });
      case _GaugeMenuAction.move:
        setState(() {
          editing = true;
          resizingSensorId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hold the gauge, then drag it to a new position.'),
          ),
        );
    }
  }

  void startResizing(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      editing = true;
      resizingSensorId = id;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Drag the bottom-right handle to resize the gauge.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void resizeGauge(
    String id,
    Offset delta,
    double minimumWidth,
    double maximumWidth,
  ) {
    setState(() {
      gaugeWidths[id] = ((gaugeWidths[id] ?? minimumWidth) + delta.dx).clamp(
        minimumWidth,
        maximumWidth,
      );
      gaugeHeights[id] = ((gaugeHeights[id] ?? 164.0) + delta.dy).clamp(
        140.0,
        420.0,
      );
      _scheduleLayoutSave();
    });
  }

  void moveGauge(String movingId, String targetId) {
    setState(() {
      final from = visibleSensorIds.indexOf(movingId);
      final to = visibleSensorIds.indexOf(targetId);
      if (from < 0 || to < 0) return;
      visibleSensorIds.removeAt(from);
      visibleSensorIds.insert(to, movingId);
      _scheduleLayoutSave();
    });
  }

  void applyGaugePreset(String name) {
    const presets = <String, List<String>>{
      'Road': [
        'engine_rpm',
        'coolant_temp',
        'engine_oil_temp',
        'battery_voltage',
      ],
      'Pull': [
        'engine_rpm',
        'boost_pressure',
        'hp_rail_pressure',
        'throttle_angle',
      ],
      'Health': [
        'coolant_temp',
        'engine_oil_temp',
        'oil_pressure',
        'battery_voltage',
      ],
    };
    final available = presets[name]!
        .where((id) => sensorsById.containsKey(id))
        .take(maxLiveSensors)
        .toList();
    if (available.isEmpty) return;
    setState(() {
      visibleSensorIds
        ..clear()
        ..addAll(available);
      editing = false;
      resizingSensorId = null;
    });
    _scheduleLayoutSave();
    _syncLiveSensorSelection();
    HapticFeedback.selectionClick();
  }

  void applyCustomDashboardPreset(String name) {
    final available = customDashboardPresets[name];
    if (available == null || available.isEmpty) return;
    setState(() {
      gaugeWidths.clear();
      gaugeHeights.clear();
      dialSensorIds.clear();
      valueColorIds.clear();
      _restoreDashboardLayout(jsonEncode(available));
      editing = false;
      resizingSensorId = null;
    });
    _scheduleLayoutSave();
    _syncLiveSensorSelection();
    _warnIfAutoLogNeedsThrottle();
    HapticFeedback.selectionClick();
  }

  Future<void> saveCustomDashboardPreset() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save dashboard layout'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 24,
          decoration: const InputDecoration(hintText: 'e.g. Track day'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    final cleanName = name?.trim() ?? '';
    if (!mounted || cleanName.isEmpty || visibleSensorIds.isEmpty) return;
    customDashboardPresets[cleanName] = {
      'visibleSensorIds': visibleSensorIds
          .where(sensorsById.containsKey)
          .take(maxLiveSensors)
          .toList(),
      'gaugeWidths': Map<String, double>.from(gaugeWidths),
      'gaugeHeights': Map<String, double>.from(gaugeHeights),
      'dialSensorIds': dialSensorIds.toList(),
      'valueColorIds': valueColorIds.toList(),
    };
    _scheduleLayoutSave();
    setState(() {});
  }

  Future<void> manageCustomDashboardPresets() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Semantics(
              header: true,
              child: Text(
                'Saved layouts',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Select a layout to load it, or remove one you no longer need.',
            ),
            const SizedBox(height: 10),
            if (customDashboardPresets.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPalette.surface(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Semantics(
                  container: true,
                  label:
                      'No saved layouts yet. Save the current dashboard to reuse it later.',
                  child: Row(
                    children: [
                      Icon(
                        Icons.dashboard_customize_outlined,
                        color: AppPalette.secondary(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('No saved layouts yet')),
                    ],
                  ),
                ),
              ),
            for (final name in customDashboardPresets.keys.toList())
              ListTile(
                leading: const Icon(Icons.bookmark_outline_rounded),
                title: Text(name),
                subtitle: Text(
                  '${(customDashboardPresets[name]!['visibleSensorIds'] as List).length} gauges',
                ),
                onTap: () {
                  Navigator.pop(context);
                  applyCustomDashboardPreset(name);
                },
                trailing: IconButton(
                  tooltip: 'Remove $name',
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () async {
                    final remove = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Remove $name?'),
                        content: const Text(
                          'This removes only the saved layout. Your current dashboard will stay unchanged.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Keep'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppPalette.red,
                            ),
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    );
                    if (remove != true || !mounted) return;
                    setState(() => customDashboardPresets.remove(name));
                    _scheduleLayoutSave();
                    if (context.mounted) Navigator.pop(context);
                    unawaited(manageCustomDashboardPresets());
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void resetGaugeLayout() {
    setState(() {
      visibleSensorIds
        ..clear()
        ..addAll(sensors.take(maxLiveSensors).map((sensor) => sensor.id));
      gaugeWidths.clear();
      gaugeHeights.clear();
      dialSensorIds.clear();
      valueColorIds.clear();
      resizingSensorId = null;
    });
    _scheduleLayoutSave();
    _syncLiveSensorSelection();
    _warnIfAutoLogNeedsThrottle();
    HapticFeedback.selectionClick();
  }

  void _warnIfAutoLogNeedsThrottle() {
    if (!autoLogEnabled ||
        visibleSensorIds.contains('throttle_angle') ||
        !mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Automatic logging is on. Add Throttle Angle to this layout before your next pull.',
        ),
      ),
    );
  }

  Widget editBanner() => Container(
    padding: const EdgeInsets.fromLTRB(14, 11, 10, 11),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(
          Icons.drag_indicator_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Hold and drag to move gauges',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        TextButton.icon(
          onPressed: chooseGauges,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Gauges'),
        ),
      ],
    ),
  );

  Future<void> chooseGauges() async {
    var query = '';
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final matchingSensors =
              sensors
                  .where(
                    (sensor) =>
                        query.isEmpty ||
                        sensor.label.toLowerCase().contains(query) ||
                        sensor.id.toLowerCase().contains(query) ||
                        sensor.unit.toLowerCase().contains(query),
                  )
                  .toList()
                ..sort((a, b) {
                  final aFavorite = favoriteSensorIds.contains(a.id);
                  final bFavorite = favoriteSensorIds.contains(b.id);
                  if (aFavorite != bFavorite) {
                    return aFavorite ? -1 : 1;
                  }
                  return a.label.compareTo(b.label);
                });
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .72,
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Choose gauges',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      '${favoriteSensorIds.length} favorites · ${visibleSensorIds.length}/$maxLiveSensors active',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Search gauges',
                      ),
                      onChanged: (value) {
                        query = value.trim().toLowerCase();
                        setSheetState(() {});
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      children: matchingSensors.map((sensor) {
                        final selected = visibleSensorIds.contains(sensor.id);
                        return CheckboxListTile(
                          value: selected,
                          title: Text(sensor.label),
                          subtitle: Text(sensor.unit),
                          secondary: IconButton(
                            tooltip: favoriteSensorIds.contains(sensor.id)
                                ? 'Remove ${sensor.label} from favorites'
                                : 'Add ${sensor.label} to favorites',
                            icon: Icon(
                              favoriteSensorIds.contains(sensor.id)
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                            ),
                            onPressed: () {
                              setState(() {
                                if (!favoriteSensorIds.add(sensor.id)) {
                                  favoriteSensorIds.remove(sensor.id);
                                }
                                _scheduleLayoutSave();
                              });
                              setSheetState(() {});
                            },
                          ),
                          onChanged: (checked) {
                            if ((checked ?? false) &&
                                !selected &&
                                visibleSensorIds.length >= maxLiveSensors) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Select up to 6 live gauges at a time.',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              if (checked ?? false) {
                                visibleSensorIds.add(sensor.id);
                              } else {
                                visibleSensorIds.remove(sensor.id);
                              }
                              _scheduleLayoutSave();
                            });
                            _syncLiveSensorSelection();
                            setSheetState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget monitorCard() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF176BDF), Color(0xFF123B86)],
      ),
      borderRadius: BorderRadius.circular(appSheetRadius),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33104EAF),
          blurRadius: 28,
          offset: Offset(0, 14),
        ),
      ],
    ),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.speed_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${visibleSensorIds.length} active gauges',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFD9E7FF),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  for (final preset in const ['Road', 'Pull', 'Health'])
                    ActionChip(
                      avatar: const Icon(Icons.auto_awesome_rounded, size: 15),
                      label: Text(preset),
                      onPressed: () => applyGaugePreset(preset),
                      backgroundColor: Colors.white.withValues(alpha: .12),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: .18),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  for (final preset in customDashboardPresets.keys)
                    ActionChip(
                      avatar: const Icon(
                        Icons.bookmark_outline_rounded,
                        size: 15,
                      ),
                      label: Text(preset),
                      onPressed: () => applyCustomDashboardPreset(preset),
                      backgroundColor: Colors.white.withValues(alpha: .12),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: .18),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: live && !widget.previewMode
                    ? toggleMonitoring
                    : null,
                icon: Icon(
                  monitoringActive
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_rounded,
                ),
                label: Text(
                  monitoringActive ? 'Stop monitoring' : 'Start monitoring',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 54),
                  backgroundColor: monitoringActive
                      ? AppPalette.red
                      : Colors.white,
                  foregroundColor: monitoringActive
                      ? Colors.white
                      : const Color(0xFF123B86),
                  disabledBackgroundColor: Colors.white.withValues(alpha: .18),
                  disabledForegroundColor: Colors.white.withValues(alpha: .65),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => setState(() {
                  editing = !editing;
                  if (!editing) resizingSensorId = null;
                }),
                icon: Icon(
                  editing
                      ? Icons.check_rounded
                      : Icons.dashboard_customize_rounded,
                ),
                label: Text(editing ? 'Finish' : 'Customize'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 54),
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF123B86),
                ),
              ),
            ),
            if (editing) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: saveCustomDashboardPreset,
                  icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                  label: const Text('Save current layout'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: .9),
                  ),
                ),
              ),
              if (customDashboardPresets.isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: manageCustomDashboardPresets,
                    icon: const Icon(Icons.bookmarks_outlined, size: 18),
                    label: const Text('Manage saved layouts'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: .9),
                    ),
                  ),
                ),
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: resetGaugeLayout,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Reset gauge layout'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: .9),
                  ),
                ),
              ),
            ],
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: ConnectionStatusChip(
            label: _statusLabelForPhase(phase),
            isDark: widget.isDark,
            iconOnly: true,
          ),
        ),
      ],
    ),
  );

  Widget monitorControl({
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? accent,
    bool highlighted = false,
  }) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon, size: 23),
    style: IconButton.styleFrom(
      fixedSize: const Size(44, 44),
      padding: EdgeInsets.zero,
      foregroundColor: accent ?? AppPalette.secondary(widget.isDark),
      disabledForegroundColor: AppPalette.secondary(
        widget.isDark,
      ).withValues(alpha: .45),
      backgroundColor: highlighted
          ? (accent ?? AppPalette.blue).withValues(alpha: .16)
          : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  Widget telemetryHeader() => SizedBox(
    height: sectionTitleHeight,
    child: Row(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppPalette.surface(widget.isDark),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              monitorControl(
                tooltip: 'Add or choose gauges',
                icon: Icons.add_box_outlined,
                onPressed: chooseGauges,
                accent: AppPalette.blue,
                highlighted: true,
              ),
              monitorControl(
                tooltip: editing ? 'Finish customizing' : 'Customize gauges',
                icon: editing
                    ? Icons.check_rounded
                    : Icons.dashboard_customize_rounded,
                onPressed: () => setState(() {
                  editing = !editing;
                  if (!editing) resizingSensorId = null;
                }),
                accent: editing ? AppPalette.blue : null,
                highlighted: editing,
              ),
              if (logger.isRecording)
                monitorControl(
                  tooltip: 'Add log marker',
                  icon: Icons.flag_outlined,
                  onPressed: addLogMarker,
                  accent: AppPalette.orange,
                ),
              monitorControl(
                tooltip: logger.isRecording
                    ? 'Stop data logging'
                    : 'Start data logging',
                icon: logger.isRecording
                    ? Icons.stop_rounded
                    : Icons.play_circle_outline_rounded,
                onPressed:
                    logger.isRecording ||
                        (live && monitoringActive && !widget.previewMode)
                    ? toggleLogging
                    : null,
                accent: logger.isRecording ? AppPalette.red : null,
                highlighted: logger.isRecording,
              ),
              monitorControl(
                tooltip: 'Full-screen gauges',
                icon: Icons.fullscreen_rounded,
                onPressed: toggleFullscreen,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget monitorPrimaryAction() => SafeArea(
    top: false,
    bottom: false,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(33, 12, 33, 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              key: const Key('monitor-primary-action'),
              onPressed: live && !widget.previewMode ? toggleMonitoring : null,
              icon: Icon(
                monitoringActive
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outline_rounded,
              ),
              label: Text(monitoringActive ? 'Stop' : 'Start'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: monitoringActive
                    ? AppPalette.red
                    : AppPalette.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget eventPanel() => ExpansionTile(
    collapsedBackgroundColor: AppPalette.surface(widget.isDark),
    backgroundColor: AppPalette.surface(widget.isDark),
    tilePadding: const EdgeInsets.symmetric(horizontal: 14),
    childrenPadding: const EdgeInsets.only(bottom: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    collapsedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    leading: const Icon(Icons.timeline_rounded, size: 20),
    title: Semantics(
      header: true,
      child: const Text(
        'Session events',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    ),
    subtitle: Text(
      events.isEmpty ? 'No events captured' : '${events.length} recent events',
      style: TextStyle(
        fontSize: 11,
        color: AppPalette.secondary(widget.isDark),
      ),
    ),
    children: [
      Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.all(14),
        color: widget.isDark
            ? const Color(0xFF0A0E13)
            : const Color(0xFFF6F8FB),
        child: events.isEmpty
            ? Semantics(
                container: true,
                label:
                    'No session events yet. Connection and monitoring activity will appear here.',
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hourglass_empty_rounded,
                        size: 18,
                        color: AppPalette.secondary(widget.isDark),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'No events yet',
                        style: TextStyle(
                          color: AppPalette.secondary(widget.isDark),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                children: events
                    .map(
                      (text) => Semantics(
                        container: true,
                        label: 'Session event: $text',
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: widget.isDark
                                  ? Color(0xFF9AA7B8)
                                  : Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    ],
  );
}

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({
    super.key,
    required this.isDark,
    required this.vin,
    required this.identity,
    required this.mileageKm,
    required this.engineEcuDetected,
    required this.engineEcuIdentity,
    this.engineEcuHardware,
    this.engineEcuSoftware,
    this.engineEcuBootloader,
    this.engineEcuCalibration,
    this.engineEcuCodingId,
    this.engineEcuManufacturingDate,
    this.engineEcuDiagnosticSession,
    this.engineEcuApplicationSoftware,
    this.engineEcuSupplierHardware,
    this.engineEcuSupplierSoftware,
    this.engineEcuBmwRoutine0205Raw,
    this.engineEcuBmwRoutine0205Software,
    this.engineEcuBmwControllerFamily,
    this.engineEcuBmwVariant,
    this.engineEcuBmwTransmission,
    this.engineEcuBmwEmissions,
    this.engineEcuBmwInternalToken,
  });

  final bool isDark;
  final String vin;
  final VehicleIdentity? identity;
  final double? mileageKm;
  final bool engineEcuDetected;
  final String? engineEcuIdentity;
  final String? engineEcuHardware;
  final String? engineEcuSoftware;
  final String? engineEcuBootloader;
  final String? engineEcuCalibration;
  final String? engineEcuCodingId;
  final String? engineEcuManufacturingDate;
  final String? engineEcuDiagnosticSession;
  final String? engineEcuApplicationSoftware;
  final String? engineEcuSupplierHardware;
  final String? engineEcuSupplierSoftware;
  final String? engineEcuBmwRoutine0205Raw;
  final String? engineEcuBmwRoutine0205Software;
  final String? engineEcuBmwControllerFamily;
  final String? engineEcuBmwVariant;
  final String? engineEcuBmwTransmission;
  final String? engineEcuBmwEmissions;
  final String? engineEcuBmwInternalToken;

  @override
  Widget build(BuildContext context) {
    final secondary = AppPalette.secondary(isDark);
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Semantics(
            header: true,
            child: Text(
              identity?.displayLabel ?? 'Vehicle',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 24),
          _section(
            icon: Icons.directions_car_outlined,
            title: 'Vehicle',
            children: [
              _detail(
                'VIN',
                vin == 'Not identified' ? '-' : vin,
                secondary,
                identifier: true,
              ),
              _detail('Chassis', identity?.chassis ?? '-', secondary),
              _detail('Model', identity?.model ?? '-', secondary),
              _detail('Model year', '${identity?.modelYear ?? '-'}', secondary),
              _detail(
                'Mileage',
                mileageKm == null ? '-' : '${mileageKm!.round()} km',
                secondary,
              ),
              _detail('Engine', identity?.engine ?? '-', secondary),
              _detail('Transmission', identity?.transmission ?? '-', secondary),
            ],
          ),
          const SizedBox(height: 18),
          _section(
            icon: Icons.memory_rounded,
            title: 'Engine ECU · DME/DDE',
            children: [
              _detail(
                'ECU identity',
                engineEcuDetected ? (engineEcuIdentity ?? 'Detected') : '-',
                secondary,
              ),
              _detail('Hardware number', _value(engineEcuHardware), secondary),
              _detail(
                'Software ID',
                _value(engineEcuSoftware),
                secondary,
                identifier: true,
              ),
              _detail(
                'Bootloader ID',
                _value(engineEcuBootloader),
                secondary,
                identifier: true,
              ),
              _detail(
                'Calibration ID',
                _value(engineEcuCalibration),
                secondary,
                identifier: true,
              ),
              _detail(
                'Coding ID',
                _value(engineEcuCodingId),
                secondary,
                identifier: true,
              ),
              _detail(
                'Manufactured',
                _value(engineEcuManufacturingDate),
                secondary,
              ),
              _detail(
                'Diagnostic session',
                _value(engineEcuDiagnosticSession),
                secondary,
              ),
              _detail(
                'Application software',
                _value(engineEcuApplicationSoftware),
                secondary,
              ),
              _detail(
                'Supplier hardware',
                _value(engineEcuSupplierHardware),
                secondary,
              ),
              _detail(
                'Supplier software',
                _value(engineEcuSupplierSoftware),
                secondary,
              ),
              const SizedBox(height: 16),
              Semantics(
                header: true,
                child: Text(
                  'BMW routine 0205',
                  style: TextStyle(
                    color: secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _detail(
                'Routine software',
                _value(engineEcuBmwRoutine0205Software),
                secondary,
                identifier: true,
              ),
              _detail(
                'Controller family',
                _value(engineEcuBmwControllerFamily),
                secondary,
              ),
              _detail('Variant', _value(engineEcuBmwVariant), secondary),
              _detail(
                'Transmission',
                _value(engineEcuBmwTransmission),
                secondary,
              ),
              _detail('Emissions', _value(engineEcuBmwEmissions), secondary),
              _detail(
                'Internal token',
                _value(engineEcuBmwInternalToken),
                secondary,
              ),
              _detail(
                'Raw routine data',
                _value(engineEcuBmwRoutine0205Raw),
                secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _value(String? value) => value == null || value.isEmpty ? '-' : value;

  Widget _section({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) => Container(
    padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
    decoration: BoxDecoration(
      color: AppPalette.surface(isDark),
      borderRadius: BorderRadius.circular(appCardRadius),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Row(
            children: [
              Icon(icon, color: AppPalette.blue, size: 21),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );

  Widget _detail(
    String label,
    String value,
    Color secondary, {
    bool identifier = false,
  }) => Semantics(
    container: true,
    label: '$label: $value',
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: secondary, fontSize: 13)),
          const SizedBox(height: 5),
          SelectableText(
            value,
            style: TextStyle(
              fontFamily: identifier ? 'monospace' : null,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

enum _GaugeMenuAction { resize, fullscreen, style, valueColor, move }

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.phase,
    required this.vin,
    required this.detail,
    required this.isDark,
    required this.onToggleTheme,
    required this.editing,
    required this.onToggleEditing,
    required this.onShowGuide,
    this.onSimulator,
  });
  final String phase;
  final String vin;
  final String detail;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final bool editing;
  final VoidCallback onToggleEditing;
  final VoidCallback onShowGuide;
  final VoidCallback? onSimulator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
                        tooltip: 'Open menu',
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
                    label: _statusLabelForPhase(phase),
                    isDark: isDark,
                    iconOnly: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const previewSensors = <SensorDefinition>[
  SensorDefinition(
    id: 'engine_rpm',
    label: 'Engine RPM',
    did: 18439,
    ecu: 18,
    size: 2,
    unit: 'RPM',
    minimum: 0,
    maximum: 8000,
    warning: 5500,
    danger: 7000,
    decimals: 0,
    scale: .25,
    offset: 0,
  ),
];
