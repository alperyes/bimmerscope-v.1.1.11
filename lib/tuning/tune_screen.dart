import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:bmw_app/vehicle/vehicle_capabilities.dart';
import 'package:bmw_app/vehicle/vehicle_identity.dart';
import 'package:bmw_app/tuning/stock_file_store.dart';
import 'package:bmw_app/tuning/tune_product.dart';
import 'package:bmw_app/tuning/tuner_package.dart';
import 'package:bmw_app/logging/data_logger.dart';
import 'package:bmw_app/tuning/tuner_request.dart';
import 'package:bmw_app/tuning/tune_compatibility.dart';
import 'package:bmw_app/tuning/calibration_artifact.dart';
import 'package:bmw_app/tuning/write_preflight.dart';
import 'package:bmw_app/vehicle/simulator_transport.dart';
import 'package:bmw_app/src/rust/api/vehicle.dart' as rust_vehicle;
import 'package:bmw_app/vehicle/garage_screen.dart';
import 'package:bmw_app/vehicle/vehicle_garage.dart';
import 'package:bmw_app/logging/log_quality.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:lottie/lottie.dart';

class TuneScreen extends StatefulWidget {
  const TuneScreen({
    super.key,
    required this.isDark,
    required this.vin,
    required this.mileageKm,
    required this.connectionLabel,
    this.demoMode = false,
    required this.simulatorMode,
    required this.engineEcuDetected,
    required this.engineEcuIdentity,
    required this.engineEcuHardware,
    required this.engineEcuSoftware,
    required this.engineEcuBootloader,
    required this.engineEcuCalibration,
    required this.engineEcuApplicationSoftware,
    required this.engineEcuSoftwareVersion,
    required this.engineEcuSupplierHardware,
    required this.engineEcuSupplierSoftware,
    required this.engineEcuBootloaderFingerprint,
    required this.engineEcuSoftwareFingerprint,
    required this.engineEcuCalibrationFingerprint,
    required this.engineEcuSgbdIndex,
    required this.engineEcuSerialNumber,
    required this.engineEcuManufacturingDate,
    required this.engineEcuCodingId,
    required this.engineEcuCvn,
    required this.sessionId,
    required this.identityCapturedAt,
    required this.onSelectGarageVehicle,
    required this.onShowGuide,
    required this.onToggleTheme,
    required this.onBeforeVehicleCheck,
    required this.onAfterVehicleCheck,
    required this.onOpenDrawer,
  });

  final bool isDark;
  final String vin;
  final double? mileageKm;
  final String connectionLabel;
  final bool demoMode;
  final bool simulatorMode;
  final bool engineEcuDetected;
  final String? engineEcuIdentity;
  final String? engineEcuHardware;
  final String? engineEcuSoftware;
  final String? engineEcuBootloader;
  final String? engineEcuCalibration;
  final String? engineEcuApplicationSoftware;
  final String? engineEcuSoftwareVersion;
  final String? engineEcuSupplierHardware;
  final String? engineEcuSupplierSoftware;
  final String? engineEcuBootloaderFingerprint;
  final String? engineEcuSoftwareFingerprint;
  final String? engineEcuCalibrationFingerprint;
  final String? engineEcuSgbdIndex;
  final String? engineEcuSerialNumber;
  final String? engineEcuManufacturingDate;
  final String? engineEcuCodingId;
  final String? engineEcuCvn;
  final String sessionId;
  final DateTime? identityCapturedAt;
  final ValueChanged<GarageVehicle> onSelectGarageVehicle;
  final VoidCallback onShowGuide;
  final VoidCallback onToggleTheme;
  final Future<void> Function() onBeforeVehicleCheck;
  final Future<void> Function() onAfterVehicleCheck;
  final VoidCallback onOpenDrawer;

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
  bool get _actionsAvailable => const {
    'Connected',
    'Monitoring',
    'Degraded',
  }.contains(widget.connectionLabel);

  File? importedStockFile;
  int? importedStockFileSize;
  String? importedStockFileHash;
  bool readingEcu = false;
  final stockFileStore = StockFileStore();
  final tunerPackageStore = TunerPackageStore();
  final tunerRequestStore = TunerRequestStore();
  final modificationsController = TextEditingController();
  final fuelController = TextEditingController();
  final hardwareController = TextEditingController();
  final _tunerRequestPanelKey = GlobalKey();
  final _tunerRequestExpansionController = ExpansibleController();
  final ValueNotifier<int> _tunerRequestRevision = ValueNotifier(0);
  Widget? _tunerRequestWorkspace;
  bool _tunerRequestPageOpen = false;
  Timer? _draftSaveTimer;
  List<File> availableLogs = [];
  final selectedLogs = <String>{};
  List<TunerRequest> savedRequests = [];
  TuneProduct selectedProduct = s55RemapProducts.first;
  File? originalMap;
  File? comparisonMap;
  Map<String, Map<String, dynamic>> mapMetadata = {};

  @override
  void initState() {
    super.initState();
    modificationsController.addListener(_scheduleDraftSave);
    fuelController.addListener(_scheduleDraftSave);
    hardwareController.addListener(_scheduleDraftSave);
    unawaited(_loadWorkspace());
  }

  Future<void> _loadWorkspace() async {
    await loadBackup();
    await loadLogs();
    await loadRequests();
    await loadDraft();
  }

  Future<void> loadRequests() async {
    final requests = await tunerRequestStore.loadAll();
    if (mounted) {
      setState(
        () =>
            savedRequests = requests.where((r) => r.vin == widget.vin).toList(),
      );
    }
  }

  Future<void> loadDraft() async {
    final requests = await tunerRequestStore.loadAll();
    final draft = requests
        .where(
          (r) => r.vin == widget.vin && r.status == TunerRequestStatus.draft,
        )
        .firstOrNull;
    if (!mounted || draft == null) return;
    modificationsController.text = draft.modifications;
    fuelController.text = draft.fuel;
    hardwareController.text = draft.hardware;
    selectedProduct = findTuneProduct(draft.productId) ?? selectedProduct;
    final draftLogNames = draft.logFiles.toSet();
    selectedLogs
      ..clear()
      ..addAll(
        availableLogs
            .where((log) => draftLogNames.contains(log.uri.pathSegments.last))
            .map((log) => log.path),
      );
    setState(() {});
  }

  @override
  void dispose() {
    _draftSaveTimer?.cancel();
    modificationsController.removeListener(_scheduleDraftSave);
    fuelController.removeListener(_scheduleDraftSave);
    hardwareController.removeListener(_scheduleDraftSave);
    unawaited(saveDraft());
    modificationsController.dispose();
    fuelController.dispose();
    hardwareController.dispose();
    _tunerRequestExpansionController.dispose();
    _tunerRequestRevision.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _tunerRequestRevision.value++;
  }

  void _scheduleDraftSave() {
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(const Duration(milliseconds: 700), () {
      unawaited(_saveDraftSafely());
    });
  }

  Future<void> _saveDraftSafely() async {
    try {
      await saveDraft();
    } catch (_) {
      // Draft persistence must never interrupt an edit if local storage is
      // temporarily unavailable. The user can still prepare/share a package.
    }
  }

  Future<void> saveDraft() async {
    final identity = identifyVehicle(widget.vin);
    if (identity == null) return;
    final draftId =
        'draft_${widget.vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_')}';
    final existingDraft = (await tunerRequestStore.loadAll())
        .where((request) => request.id == draftId)
        .firstOrNull;
    await tunerRequestStore.save(
      TunerRequest(
        id: draftId,
        vin: widget.vin,
        vehicleLabel: identity.displayLabel,
        modifications: modificationsController.text.trim(),
        fuel: fuelController.text.trim(),
        hardware: hardwareController.text.trim(),
        mileageKm: widget.mileageKm,
        stockFileName: importedStockFile?.uri.pathSegments.last,
        logFiles: selectedLogs
            .map((path) => File(path).uri.pathSegments.last)
            .toList(),
        status: TunerRequestStatus.draft,
        createdAt: existingDraft?.createdAt ?? DateTime.now(),
        productId: selectedProduct.id,
        productLabel: selectedProduct.displayName,
      ),
    );
  }

  Future<void> loadLogs() async {
    final logs = await DataLogger.savedLogs();
    final safeVin = widget.vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final matchingLogs = <File>[];
    for (final log in logs) {
      final lines = await log
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .take(4)
          .toList();
      if (lines.any((line) => line.trim() == '# vehicle,$safeVin')) {
        matchingLogs.add(log);
      }
    }
    if (mounted) {
      setState(() {
        availableLogs = matchingLogs;
        selectedLogs.addAll(matchingLogs.map((file) => file.path));
      });
    }
  }

  Future<void> loadBackup() async {
    final backup = await stockFileStore.load(widget.vin);
    if (backup != null) {
      await setStockFile(backup.file);
    }
  }

  Future<void> setStockFile(File file) async {
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() {
      importedStockFile = file;
      importedStockFileSize = bytes.length;
      importedStockFileHash = sha256.convert(bytes).toString();
    });
  }

  Future<void> showBackupHistory() async {
    final backups = await stockFileStore.loadAll(widget.vin);
    if (!mounted) return;
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
                'Stock backup history',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            if (backups.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPalette.surface(widget.isDark),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Semantics(
                  container: true,
                  label:
                      'No stock backups saved for this vehicle. Read-only backup files will appear here after an ECU read.',
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: AppPalette.secondary(widget.isDark),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('No backups saved for this vehicle'),
                      ),
                    ],
                  ),
                ),
              ),
            for (final backup in backups)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.verified_user_outlined),
                title: Text(backup.fileName),
                subtitle: FutureBuilder<int>(
                  future: backup.size,
                  builder: (context, snapshot) => Text(
                    snapshot.hasData
                        ? _formatFileSize(snapshot.data!)
                        : 'Checking file…',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<({rust_vehicle.N20UnlockReferenceCheck? result, String? error})>
  _readN20UnlockReference() async {
    var paused = false;
    rust_vehicle.N20UnlockReferenceCheck? result;
    String? checkError;
    try {
      await widget.onBeforeVehicleCheck();
      paused = true;
      result = await rust_vehicle.checkN20BenchUnlockReference(
        expectedVin: widget.vin,
      );
    } catch (error) {
      checkError = '$error';
    } finally {
      if (paused) {
        try {
          await widget.onAfterVehicleCheck();
        } catch (error) {
          result = null;
          checkError = 'Vehicle reconnect failed: $error';
        }
      }
    }
    return (result: result, error: checkError);
  }

  Future<String> _loadUnlockStatus() async {
    final identity = identifyVehicle(widget.vin);
    final n20Check =
        _actionsAvailable &&
            !widget.simulatorMode &&
            widget.vin == 'WBA3A52010F360747'
        ? await _readN20UnlockReference()
        : null;
    return n20Check != null
        ? n20Check.result == null
              ? 'Unable to verify N20 bench DME: ${n20Check.error}'
              : '${n20Check.result!.status == 'reference_match' ? 'N20 bench reference matched' : 'Unable to verify'}\n\n${n20Check.result!.detail}\n\nVIN: ${n20Check.result!.vin}'
        : identity == null
        ? 'Connect and identify a supported vehicle to check its DME requirements.'
        : '${identity.displayLabel}\n\nUnlock checks are informational only in this build. No ECU write or flash operation is available.';
  }

  void showUnlockStatus() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _UnlockStatusPage(
          isDark: widget.isDark,
          status: _loadUnlockStatus(),
        ),
      ),
    );
  }

  Future<void> showTuneReadiness() async {
    final identity = identifyVehicle(widget.vin);
    final report = compatibilityReport;
    final connected = widget.connectionLabel == 'Connected';
    // Simulator evidence is valid only for the active simulator session. A
    // simulator running on the desktop must never influence a real or
    // disconnected vehicle check.
    final simulatorUnlockStatus = connected && widget.simulatorMode
        ? await readSimulatorDmeUnlockStatus()
        : null;
    final n20Check =
        connected && !widget.simulatorMode && widget.vin == 'WBA3A52010F360747'
        ? await _readN20UnlockReference()
        : null;
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Tune vehicle check'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CheckResult(
              label: 'Vehicle connection',
              passed: connected,
              detail: connected ? 'Connected' : 'Connect to the vehicle',
            ),
            _CheckResult(
              label: 'BimmerScope profile',
              passed:
                  identity != null && selectedProduct.matchesVehicle(identity),
              detail: identity?.displayLabel ?? 'Vehicle not identified',
            ),
            _CheckResult(
              label: 'Package compatibility',
              passed: report.readyForProfessionalReview,
              detail: report.label,
            ),
            _CheckResult(
              label: 'DME unlock status',
              passed: simulatorUnlockStatus == 'unlocked',
              detail: n20Check != null
                  ? n20Check.result?.status == 'reference_match'
                        ? 'N20 bench reference matched'
                        : 'Unable to verify N20 bench reference'
                  : simulatorUnlockStatus == null ||
                        simulatorUnlockStatus == 'unknown'
                  ? 'Unable to verify'
                  : simulatorUnlockStatus.replaceAll('_', ' '),
            ),
            _CheckResult(
              label: 'ECU fingerprint',
              passed: report.evidence.complete,
              detail: report.evidence.complete
                  ? report.evidence.hasPhysicalHardware
                        ? 'Core DME identifiers and physical hardware are available for review'
                        : 'Core DME identifiers are available; physical hardware is optional on some S55 software levels'
                  : widget.engineEcuIdentity == null
                  ? 'DME identity, software, boot/startup, and calibration IDs unavailable'
                  : 'DME identity read (${widget.engineEcuIdentity}); some identifiers are still unavailable',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<GarageVehicle>(
                  builder: (_) => GarageScreen(
                    onSelect: (vehicle) {
                      widget.onSelectGarageVehicle(vehicle);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Selected ${vehicle.label} for offline review',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              icon: const Icon(Icons.garage_outlined),
              label: const Text('Open vehicle garage'),
            ),
            if (n20Check != null)
              Text(
                n20Check.result?.detail ??
                    'N20 bench check failed: ${n20Check.error}',
                style: const TextStyle(fontSize: 12),
              )
            else if (simulatorUnlockStatus == null ||
                simulatorUnlockStatus == 'unknown')
              const Text(
                'DME preflight requires a validated VIN, hardware, software, bootloader, and calibration fingerprint.',
                style: TextStyle(fontSize: 12),
              ),
            const SizedBox(height: 8),
            ...report.reasons.map(
              (reason) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• $reason', style: const TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),
            const Text('No ECU writing or flashing is enabled.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> importStockFile() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Calibration files',
          extensions: ['bin', 'ori', 'hex', 'json'],
        ),
      ],
    );
    if (file == null || !mounted) return;
    final backup = await stockFileStore.importFile(
      sourcePath: file.path,
      vin: widget.vin,
    );
    await setStockFile(backup.file);
  }

  Future<void> readEcuCalibration() async {
    if (readingEcu ||
        widget.connectionLabel != 'Connected' ||
        widget.simulatorMode) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Read calibration from ECU?'),
        content: const Text(
          'This performs a read-only 512 KiB ISTA-pattern read and saves an immutable ECU-read backup. It does not write to the vehicle.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Read ECU'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => readingEcu = true);
    try {
      final bytes = await rust_vehicle.readIstaS55Calibration();
      final backup = await stockFileStore.saveBytes(
        bytes: bytes,
        vin: widget.vin,
        sourceName: 'ecu_read_ista_s55.bin',
        metadata: {
          'source': 'live_enet',
          'readStatus': 'compatibility_unverified',
          'profile': 'ista_s55_6MC9ED0B',
          'dmeAddress': 0x12,
          'softwareToken': '6MC9ED0B',
          'startAddress': '0x80180000',
          'length': 0x80000,
          'chunkSize': 0x100,
          'responseSid': '0x63',
          'vin': widget.vin,
          'sessionId': widget.sessionId,
          'identityCapturedAt': widget.identityCapturedAt?.toIso8601String(),
          'dmeIdentity': widget.engineEcuIdentity,
          'hardware': widget.engineEcuHardware,
          'software': widget.engineEcuSoftware,
          'bootloader': widget.engineEcuBootloader,
          'calibration': widget.engineEcuCalibration,
        },
      );
      await setStockFile(backup.file);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ECU read saved: ${backup.fileName}')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ECU read stopped: $error')));
      }
    } finally {
      if (mounted) setState(() => readingEcu = false);
    }
  }

  Future<void> createTunerPackage() async {
    try {
      await _createTunerPackage();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not prepare package: $error')),
      );
    }
  }

  Future<void> _createTunerPackage() async {
    final identity = identifyVehicle(widget.vin);
    final report = compatibilityReport;
    if (identity == null || !report.readyForProfessionalReview) return;
    final evidenceCapabilities = resolvedEcuProfile?.capabilities;
    final logs = await DataLogger.savedLogs();
    final selectedLogFiles = [
      for (final log in logs)
        if (selectedLogs.contains(log.path)) log,
    ];
    final logQuality = await Future.wait(
      selectedLogFiles.map(
        (log) => inspectLogQuality(
          log,
          vin: widget.vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_'),
          profileId: identity.profile.id,
        ),
      ),
    );
    final file = await tunerPackageStore.create(
      vin: widget.vin,
      vehicleLabel: identity.displayLabel,
      profileId: identity.profile.id,
      productId: selectedProduct.id,
      productLabel: selectedProduct.displayName,
      capabilities: [
        for (final capability in VehicleCapability.values)
          if (evidenceCapabilities?.contains(capability) ??
              identity.profile.supports(capability))
            capability.name,
      ],
      stockFileName: importedStockFile?.uri.pathSegments.last,
      stockFilePath: importedStockFile?.path,
      logFiles: selectedLogFiles.map((log) => log.path).toList(),
      modifications: modificationsController.text.trim(),
      fuel: fuelController.text.trim(),
      hardware: hardwareController.text.trim(),
      mileageKm: widget.mileageKm,
      compatibility: report.toJson(),
      logQuality: logQuality.map((report) => report.toJson()).toList(),
    );
    final packageValidation = await tunerPackageStore.validate(file);
    if (!packageValidation.valid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Package could not be verified: ${packageValidation.errors.join(' ')}',
            ),
          ),
        );
      }
      return;
    }
    final request = TunerRequest(
      id: 'request_${DateTime.now().microsecondsSinceEpoch}',
      vin: widget.vin,
      vehicleLabel: identity.displayLabel,
      modifications: modificationsController.text.trim(),
      fuel: fuelController.text.trim(),
      hardware: hardwareController.text.trim(),
      mileageKm: widget.mileageKm,
      stockFileName: importedStockFile?.uri.pathSegments.last,
      logFiles: [
        for (final log in logs)
          if (selectedLogs.contains(log.path)) log.uri.pathSegments.last,
      ],
      status: TunerRequestStatus.readyToSend,
      createdAt: DateTime.now(),
      productId: selectedProduct.id,
      productLabel: selectedProduct.displayName,
      packageManifestPath: file.path,
    );
    if (!mounted) return;
    var shareAsArchive = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review tuner package'),
        content: Text(
          '${identity.displayLabel}\n'
          'Product: ${selectedProduct.displayName}\n\n'
          'Stock backup: ${request.stockFileName ?? 'Not attached'}\n'
          'Logs: ${request.logFiles.length}\n'
          'Fuel: ${request.fuel.isEmpty ? 'Not specified' : request.fuel}\n'
          'Hardware: ${request.hardware.isEmpty ? 'Not specified' : request.hardware}\n'
          'Mileage: ${request.mileageKm?.toStringAsFixed(0) ?? 'Not specified'} km\n'
          'Context: ${request.hasCompleteTunerContext ? 'Complete' : 'Missing ${request.missingTunerContext.join(', ')}'}\n'
          'Notes: ${request.modifications.isEmpty ? 'None added' : request.modifications}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Share package'),
          ),
          FilledButton(
            onPressed: () {
              shareAsArchive = true;
              Navigator.pop(context, true);
            },
            child: const Text('Share ZIP'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final archive = shareAsArchive
        ? await tunerPackageStore.createArchive(file)
        : null;
    await tunerRequestStore.save(request);
    await SharePlus.instance.share(
      ShareParams(
        files: [
          if (archive != null) XFile(archive.path, mimeType: 'application/zip'),
          if (archive == null) ...[
            XFile(file.path),
            ...tunerPackageStore.lastAttachments.map((f) => XFile(f.path)),
          ],
        ],
        text: 'BimmerScope tuner package',
      ),
    );
    await loadRequests();
  }

  Future<void> chooseMap({required bool original}) async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Calibration files',
          extensions: ['bin', 'ori', 'hex', 'json'],
        ),
      ],
    );
    if (file == null || !mounted) return;
    final selected = File(file.path);
    final inspection = await inspectCalibrationArtifact(selected);
    final metadata = <String, dynamic>{
      'hash': inspection.sha256,
      'size': inspection.size,
      'imported': DateTime.now(),
      'inspection': inspection.toJson(),
    };
    if (!mounted) return;
    setState(() {
      if (original) {
        originalMap = selected;
        mapMetadata['original'] = metadata;
      } else {
        comparisonMap = selected;
        mapMetadata['comparison'] = metadata;
      }
    });
  }

  Future<void> showRequestDetails(TunerRequest request) async {
    final missingContext = request.missingTunerContext;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: ListView(
            shrinkWrap: true,
            children: [
              Semantics(
                header: true,
                child: Text(
                  request.vehicleLabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (request.productLabel != null) ...[
                const SizedBox(height: 4),
                Text(
                  request.productLabel!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
              const SizedBox(height: 4),
              Text(request.vin, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color:
                      (request.status == TunerRequestStatus.readyToSend
                              ? AppPalette.green
                              : AppPalette.blue)
                          .withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      request.status == TunerRequestStatus.readyToSend
                          ? Icons.check_circle_outline_rounded
                          : Icons.flag_outlined,
                      size: 18,
                      color: request.status == TunerRequestStatus.readyToSend
                          ? AppPalette.green
                          : AppPalette.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        requestStatusLabel(request.status),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      'Revision ${request.revision}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  request.hasCompleteTunerContext
                      ? Icons.verified_outlined
                      : Icons.info_outline,
                  color: request.hasCompleteTunerContext
                      ? AppPalette.green
                      : AppPalette.orange,
                ),
                title: Semantics(
                  header: true,
                  child: const Text('Tuner context'),
                ),
                subtitle: Text(
                  request.hasCompleteTunerContext
                      ? 'Fuel, hardware, mileage, notes, and logs are included.'
                      : 'Still useful to share, but add: ${missingContext.join(', ')}.',
                ),
              ),
              ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                childrenPadding: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(Icons.history_rounded),
                title: Semantics(
                  header: true,
                  child: const Text('Request timeline'),
                ),
                subtitle: Text('${request.timeline.length} recorded events'),
                children: [
                  for (final event in request.timeline.reversed)
                    Semantics(
                      container: true,
                      label:
                          '${event.action}, recorded ${event.recordedAt.toLocal()}${event.detail == null ? '' : '. ${event.detail}'}',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(event.action),
                        subtitle: Text(
                          '${event.recordedAt.toLocal()}${event.detail == null ? '' : '\n${event.detail}'}',
                        ),
                        isThreeLine: event.detail != null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  modificationsController.text = request.modifications;
                  fuelController.text = request.fuel;
                  hardwareController.text = request.hardware;
                  selectedProduct =
                      findTuneProduct(request.productId) ?? selectedProduct;
                  selectedLogs
                    ..clear()
                    ..addAll(
                      availableLogs
                          .where(
                            (log) => request.logFiles.contains(
                              log.uri.pathSegments.last,
                            ),
                          )
                          .map((log) => log.path),
                    );
                  Navigator.pop(context);
                  setState(() {});
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Use these details'),
              ),
              if (request.status == TunerRequestStatus.readyToSend) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await tunerRequestStore.save(request.markSent());
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    await loadRequests();
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Mark as sent'),
                ),
              ],
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.local_gas_station_outlined),
                title: const Text('Fuel'),
                subtitle: Text(
                  request.fuel.isEmpty ? 'Not specified' : request.fuel,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.precision_manufacturing_outlined),
                title: const Text('Hardware'),
                subtitle: Text(
                  request.hardware.isEmpty ? 'Not specified' : request.hardware,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.speed_outlined),
                title: const Text('Mileage'),
                subtitle: Text(
                  request.mileageKm == null
                      ? 'Not specified'
                      : '${request.mileageKm!.toStringAsFixed(0)} km',
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.build_outlined),
                title: const Text('Modifications and notes'),
                subtitle: Text(
                  request.modifications.isEmpty
                      ? 'No notes added'
                      : request.modifications,
                ),
              ),
              if (request.packageManifestPath != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified_outlined),
                  title: const Text('Verified package manifest'),
                  subtitle: Text(
                    File(request.packageManifestPath!).uri.pathSegments.last,
                  ),
                ),
              if (request.packageManifestPath != null)
                OutlinedButton.icon(
                  onPressed: () => shareSavedPackage(request),
                  icon: const Icon(Icons.ios_share_outlined),
                  label: const Text('Share saved package ZIP'),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.save_outlined),
                title: const Text('Stock backup'),
                subtitle: Text(
                  request.stockFileName ?? 'No stock backup attached',
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined),
                title: const Text('Attached logs'),
                subtitle: Text(
                  request.logFiles.isEmpty
                      ? 'No logs attached'
                      : request.logFiles.join(', '),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> shareSavedPackage(TunerRequest request) async {
    final path = request.packageManifestPath;
    if (path == null) return;
    try {
      final archive = await tunerPackageStore.createArchive(File(path));
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(archive.path, mimeType: 'application/zip')],
          text: 'BimmerScope tuner package · ${request.vehicleLabel}',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share saved package: $error')),
      );
    }
  }

  String requestStatusLabel(TunerRequestStatus status) => switch (status) {
    TunerRequestStatus.draft => 'Draft',
    TunerRequestStatus.readyToSend => 'Ready to send',
    TunerRequestStatus.sent => 'Sent',
  };

  String _formatFileSize(int bytes) => bytes < 1024 * 1024
      ? '${(bytes / 1024).toStringAsFixed(1)} KB'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';

  void _openFlashMap() => Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => _TuneActionPage(
        isDark: widget.isDark,
        title: 'Flash a map',
        icon: Icons.map_outlined,
        message: 'Map flashing is not available in this version.',
        detail:
            'BimmerScope does not write calibration data to the ECU. This page is informational; no map will be sent to the vehicle.',
        products: s55Connected ? s55RemapProducts : null,
        selectedProduct: selectedProduct,
        identity: connectedIdentity,
        onProductSelected: (product) {
          setState(() => selectedProduct = product);
          _scheduleDraftSave();
        },
      ),
    ),
  );

  void _openFlashBackToStock() => Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => _TuneActionPage(
        isDark: widget.isDark,
        title: 'Flash back to stock',
        icon: Icons.settings_backup_restore_rounded,
        message: 'Stock restoration is not available in this version.',
        detail:
            'A safe restore requires the verified original calibration for this exact ECU and a validated recovery procedure. BimmerScope does not write calibration data.',
      ),
    ),
  );

  void _openDmeIdentity() => Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => _EcuIdentityPage(
        isDark: widget.isDark,
        vin: widget.vin,
        identity: widget.engineEcuIdentity,
        hardware: widget.engineEcuHardware,
        software: widget.engineEcuSoftware,
        bootloader: widget.engineEcuBootloader,
        calibration: widget.engineEcuCalibration,
        manufacturingDate: widget.engineEcuManufacturingDate,
        codingId: widget.engineEcuCodingId,
      ),
    ),
  );

  Future<void> _openTunerRequestPage() async {
    if (_tunerRequestPageOpen) return;
    _tunerRequestExpansionController.expand();
    setState(() => _tunerRequestPageOpen = true);
    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => _TunerRequestPage(
            isDark: widget.isDark,
            revision: _tunerRequestRevision,
            workspace: () => _tunerRequestWorkspace ?? const SizedBox.shrink(),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _tunerRequestPageOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppPalette.background(widget.isDark),
    body: SafeArea(
      top: true,
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
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
                      child: IconButton(
                        onPressed: widget.onOpenDrawer,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: ConnectionStatusChip(
                      label: widget.connectionLabel,
                      isDark: widget.isDark,
                      iconOnly: true,
                      isDemo: widget.demoMode || widget.simulatorMode,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TuneReadinessPanel(
                  isDark: widget.isDark,
                  vin: widget.vin,
                  connectionLabel: widget.connectionLabel,
                  onCheckVehicle: showTuneReadiness,
                ),
                const SizedBox(height: 12),
                _TuneActionMenu(
                  isDark: widget.isDark,
                  enabled: _actionsAvailable,
                  items: [
                    _TuneActionItem(
                      key: const Key('tune-dme-identity-open'),
                      title: 'DME identity',
                      subtitle: 'ECU identifiers',
                      icon: Icons.memory_rounded,
                      onTap: _openDmeIdentity,
                    ),
                    _TuneActionItem(
                      key: const Key('tune-check-unlock-open'),
                      title: 'Check unlock status',
                      subtitle: 'Read-only DME check',
                      icon: Icons.lock_open_outlined,
                      onTap: showUnlockStatus,
                    ),
                    _TuneActionItem(
                      key: const Key('tune-flash-map-open'),
                      title: 'Flash a map',
                      subtitle: 'Map options and compatibility',
                      icon: Icons.map_outlined,
                      onTap: _openFlashMap,
                    ),
                    _TuneActionItem(
                      key: const Key('tune-flash-stock-open'),
                      title: 'Flash back to stock',
                      subtitle: 'Stock restoration information',
                      icon: Icons.settings_backup_restore_rounded,
                      onTap: _openFlashBackToStock,
                    ),
                    _TuneActionItem(
                      key: const Key('tune-request-open'),
                      title: 'Tuner Request',
                      subtitle: 'Stock files, details, logs and history',
                      icon: Icons.assignment_outlined,
                      onTap: _openTunerRequestPage,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final workspace = Container(
                      key: _tunerRequestPanelKey,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(appCardRadius),
                      ),
                      child: ExpansionTile(
                        controller: _tunerRequestExpansionController,
                        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        leading: const Icon(Icons.tune_rounded),
                        title: Semantics(
                          header: true,
                          child: const Text('Request workspace'),
                        ),
                        subtitle: const Text(
                          'Stock files, map review, details, and logs',
                        ),
                        children: [
                          ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            childrenPadding: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: const Icon(Icons.map_outlined),
                            title: Semantics(
                              header: true,
                              child: const Text('Optional map review'),
                            ),
                            subtitle: const Text(
                              'Browse, review, and prepare map files',
                            ),
                            children: [
                              if (s55Connected)
                                ListTile(
                                  leading: const Icon(
                                    Icons.storefront_outlined,
                                  ),
                                  title: Semantics(
                                    header: true,
                                    child: const Text('S55 remap products'),
                                  ),
                                  subtitle: const Text(
                                    'Choose a Competition or CS product track',
                                  ),
                                  onTap: _openFlashMap,
                                ),
                              ListTile(
                                leading: const Icon(Icons.tune_outlined),
                                title: const Text('Review a map file'),
                                subtitle: const Text(
                                  'Compare a tuner-provided file safely',
                                ),
                                onTap: hasSupportedVehicleProfile
                                    ? () => chooseMap(original: false)
                                    : null,
                              ),
                              ListTile(
                                leading: const Icon(Icons.save_outlined),
                                title: const Text('Review stock backup'),
                                subtitle: Text(
                                  importedStockFile == null
                                      ? 'Import a stock backup first'
                                      : 'View the verified backup and its history',
                                ),
                                onTap: importedStockFile == null
                                    ? importStockFile
                                    : showBackupHistory,
                              ),
                              Semantics(
                                enabled: false,
                                label:
                                    'Review backend options unavailable until vehicle-specific support is validated.',
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.info_outline_rounded,
                                  ),
                                  title: const Text('Review backend options'),
                                  subtitle: const Text(
                                    'Unavailable until vehicle-specific support is validated',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    header: true,
                                    child: Text(
                                      'Stock file & backups',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    importedStockFile == null
                                        ? 'Import a known stock file to keep it with this Tune workspace.'
                                        : 'Imported: ${importedStockFile!.uri.pathSegments.last}',
                                  ),
                                  if (importedStockFile != null &&
                                      importedStockFileSize != null &&
                                      importedStockFileHash != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      '${_formatFileSize(importedStockFileSize!)} · SHA-256 ${importedStockFileHash!.substring(0, 12)}…',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: importStockFile,
                                    icon: const Icon(
                                      Icons.upload_file_outlined,
                                    ),
                                    label: Text(
                                      importedStockFile == null
                                          ? 'Import stock file'
                                          : 'Replace stock file',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: readingEcu
                                        ? null
                                        : readEcuCalibration,
                                    icon: readingEcu
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.memory_outlined),
                                    label: Text(
                                      readingEcu
                                          ? 'Reading ECU…'
                                          : 'Read calibration from ECU',
                                    ),
                                  ),
                                  if (readingEcu) ...[
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed:
                                          rust_vehicle.cancelIstaS55Calibration,
                                      icon: const Icon(
                                        Icons.stop_circle_outlined,
                                      ),
                                      label: const Text('Cancel ECU read'),
                                    ),
                                  ],
                                  if (importedStockFile != null) ...[
                                    const SizedBox(height: 4),
                                    TextButton.icon(
                                      onPressed: showBackupHistory,
                                      icon: const Icon(Icons.history_rounded),
                                      label: const Text('View backup history'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    header: true,
                                    child: Text(
                                      'Read-only map comparison',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Compare file metadata before sending anything to a tuner.',
                                  ),
                                  if (!hasSupportedVehicleProfile) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Identify a supported vehicle before comparing map files.',
                                      style: TextStyle(
                                        color: AppPalette.orange,
                                      ),
                                    ),
                                  ] else if (!identityAvailable) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Offline review only. Connect to capture live ECU evidence before requesting a calibration read.',
                                      style: TextStyle(
                                        color: AppPalette.secondary(
                                          widget.isDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  _MapSlot(
                                    label: 'Original / stock',
                                    file: originalMap,
                                    metadata: mapMetadata['original'],
                                    onPressed: hasSupportedVehicleProfile
                                        ? () => chooseMap(original: true)
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  _MapSlot(
                                    label: 'Comparison map',
                                    file: comparisonMap,
                                    metadata: mapMetadata['comparison'],
                                    onPressed: hasSupportedVehicleProfile
                                        ? () => chooseMap(original: false)
                                        : null,
                                  ),
                                  if (originalMap != null &&
                                      comparisonMap != null) ...[
                                    const SizedBox(height: 12),
                                    _ComparisonSummary(
                                      original: mapMetadata['original']!,
                                      comparison: mapMetadata['comparison']!,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    header: true,
                                    child: Text(
                                      'Tuner request details',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Saved automatically for this vehicle. Add the hardware, fuel, and map notes your tuner needs.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: fuelController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: const InputDecoration(
                                      labelText: 'Fuel',
                                      hintText:
                                          'Example: 98 RON / 93 AKI / E30',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: hardwareController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: const InputDecoration(
                                      labelText: 'Hardware',
                                      hintText:
                                          'Example: stock turbos, intake, charge pipes',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: modificationsController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      labelText: 'Modifications and notes',
                                      hintText:
                                          'Example: intake, charge pipes, fuel, requested map…',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ...[
                            const SizedBox(height: 16),
                            Card(
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        8,
                                        16,
                                        4,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Logs to include',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedLogs.addAll(
                                                  availableLogs.map(
                                                    (log) => log.path,
                                                  ),
                                                );
                                              });
                                              _scheduleDraftSave();
                                            },
                                            child: const Text('Select all'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(selectedLogs.clear);
                                              _scheduleDraftSave();
                                            },
                                            child: const Text('Clear'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        0,
                                        16,
                                        4,
                                      ),
                                      child: Text(
                                        'Select saved logs to attach to the tuner package.',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ),
                                    if (availableLogs.isEmpty)
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                          16,
                                          4,
                                          16,
                                          8,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppPalette.surface(
                                            widget.isDark,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Semantics(
                                          container: true,
                                          label:
                                              'No saved logs yet. Record a live-data log first, then return here to attach it.',
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.info_outline_rounded,
                                                color: AppPalette.secondary(
                                                  widget.isDark,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'No saved logs yet',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      'Record a live-data log first, then return here to attach it.',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    for (final log in availableLogs)
                                      CheckboxListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                        value: selectedLogs.contains(log.path),
                                        title: Text(log.uri.pathSegments.last),
                                        onChanged: (value) {
                                          setState(
                                            () => value == true
                                                ? selectedLogs.add(log.path)
                                                : selectedLogs.remove(log.path),
                                          );
                                          _scheduleDraftSave();
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          if (savedRequests.isNotEmpty) ...[
                            Text(
                              'Saved tuner requests',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            for (final request in savedRequests.take(5))
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.assignment_outlined),
                                title: Text(
                                  request.productLabel ?? request.vehicleLabel,
                                ),
                                subtitle: Text(
                                  '${request.vehicleLabel} · ${requestStatusLabel(request.status)} · ${request.logFiles.length} log(s) · ${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                                onTap: () => showRequestDetails(request),
                              ),
                            const SizedBox(height: 8),
                          ],
                          Card(
                            margin: EdgeInsets.zero,
                            color: AppPalette.surface(widget.isDark),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.lock_outline_rounded, size: 20),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Calibration writing is locked. ${writePreflight.blockingReasons.isEmpty ? 'A validated programming backend is still required.' : writePreflight.blockingReasons.first}.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    _tunerRequestWorkspace = workspace;
                    return _tunerRequestPageOpen
                        ? const SizedBox.shrink()
                        : const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 12),
                _VehicleSnapshotStrip(
                  isDark: widget.isDark,
                  connectionLabel: widget.connectionLabel,
                  vin: widget.vin,
                  mileageKm: widget.mileageKm,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  bool get identityAvailable =>
      widget.connectionLabel == 'Connected' &&
      widget.engineEcuDetected &&
      identifyVehicle(widget.vin) != null;

  bool get hasSupportedVehicleProfile => identifyVehicle(widget.vin) != null;

  VehicleIdentity? get connectedIdentity =>
      identityAvailable ? identifyVehicle(widget.vin) : null;

  bool get s55Connected => connectedIdentity?.engine == 'S55';

  bool get selectedProductCompatible {
    return compatibilityReport.readyForProfessionalReview;
  }

  TuneCompatibilityReport get compatibilityReport => assessTuneCompatibility(
    vehicle: connectedIdentity,
    product: selectedProduct,
    evidence: TuneDmeEvidence(
      connected: widget.connectionLabel == 'Connected',
      detected: widget.engineEcuDetected,
      identity: widget.engineEcuIdentity,
      hardware: widget.engineEcuHardware,
      software: widget.engineEcuSoftware,
      bootloader: widget.engineEcuBootloader,
      calibration: widget.engineEcuCalibration,
      codingId: widget.engineEcuCodingId,
      svk: widget.engineEcuSgbdIndex,
      serialNumber: widget.engineEcuSerialNumber,
      sessionId: widget.sessionId.isEmpty ? null : widget.sessionId,
      source: widget.simulatorMode ? 'simulator' : 'live_enet',
      capturedAt: widget.identityCapturedAt,
    ),
  );

  /// Resolves only read-only, evidence-gated capabilities. The vehicle profile
  /// remains visible independently so a partial live read never hides an
  /// existing feature from the user.
  ResolvedEcuProfile? get resolvedEcuProfile {
    final identity = connectedIdentity;
    if (identity == null) return null;
    return resolveEcuProfile(
      identity: identity,
      vehicleVin: widget.vin,
      fingerprint: EcuFingerprint(
        // The vehicle VIN is not proof that this DME belongs to it. Keep the
        // fingerprint VIN empty until the transport exposes a DME-associated
        // VIN, so the UI cannot overstate a family match as an exact match.
        vin: '',
        identity: widget.engineEcuIdentity ?? '',
        boschHardware: widget.engineEcuSupplierHardware,
        bmwHardware: widget.engineEcuHardware,
        softwareId: widget.engineEcuSoftware,
        calibrationId: widget.engineEcuCalibration,
        bootloaderId: widget.engineEcuBootloader,
        verified:
            widget.connectionLabel == 'Connected' &&
            widget.engineEcuDetected &&
            _ecuFingerprintComplete,
      ),
    );
  }

  bool get _ecuFingerprintComplete => compatibilityReport.evidence.complete;

  WritePreflight get writePreflight => WritePreflight(
    profile: resolvedEcuProfile,
    sessionVin: widget.vin,
    ecuFingerprint: resolvedEcuProfile?.fingerprint,
    transport: widget.simulatorMode ? 'simulator' : 'wired_enet',
    externalPowerStable: false,
    ignitionReady: false,
    immutableBackupHash: importedStockFileHash,
    packageSignatureVerified: false,
    recoveryProcedureVerified: false,
    backendValidated: false,
  );
}

class _TuneProductSelector extends StatelessWidget {
  const _TuneProductSelector({
    required this.isDark,
    required this.products,
    required this.selectedProductId,
    required this.identity,
    required this.onSelected,
  });

  final bool isDark;
  final List<TuneProduct> products;
  final String selectedProductId;
  final VehicleIdentity? identity;
  final ValueChanged<TuneProduct> onSelected;

  @override
  Widget build(BuildContext context) {
    final muted = AppPalette.secondary(isDark);
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  'S55 remap',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            Text('2 products', style: TextStyle(color: muted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Choose the calibration track before preparing your tuner package.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 10),
        for (var index = 0; index < products.length; index++) ...[
          _TuneProductCard(
            product: products[index],
            selected: products[index].id == selectedProductId,
            compatible:
                identity != null && products[index].matchesVehicle(identity!),
            identity: identity,
            isDark: isDark,
            primary: primary,
            onTap: () => onSelected(products[index]),
          ),
          if (index != products.length - 1) const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        Text(
          identity == null
              ? 'Fitment is checked after a supported vehicle is identified.'
              : 'Competition and CS trim must be confirmed separately; VIN data alone is not used to infer the product.',
          style: TextStyle(color: muted, fontSize: 11, height: 1.3),
        ),
      ],
    );
  }
}

class _TuneProductCard extends StatelessWidget {
  const _TuneProductCard({
    required this.product,
    required this.selected,
    required this.compatible,
    required this.identity,
    required this.isDark,
    required this.primary,
    required this.onTap,
  });

  final TuneProduct product;
  final bool selected;
  final bool compatible;
  final VehicleIdentity? identity;
  final bool isDark;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppPalette.secondary(isDark);
    final surface = AppPalette.surface(isDark);
    final statusLabel = compatible ? 'Vehicle match' : identityStatusLabel;
    return Semantics(
      button: true,
      selected: selected,
      label:
          '${product.displayName}, $statusLabel${selected ? ', selected' : ''}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(appCardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(appCardRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected
                  ? primary.withValues(alpha: isDark ? .12 : .07)
                  : surface,
              borderRadius: BorderRadius.circular(appCardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.displayName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: selected
                          ? primary
                          : compatible
                          ? muted
                          : muted.withValues(alpha: .65),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  product.description,
                  style: TextStyle(color: muted, fontSize: 12, height: 1.3),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _TuneProductTag(label: product.fitment, color: primary),
                    _TuneProductTag(
                      label: statusLabel,
                      color: compatible ? AppPalette.green : muted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get identityStatusLabel =>
      identity == null ? 'Fitment pending' : 'Not compatible';
}

class _TuneProductTag extends StatelessWidget {
  const _TuneProductTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class _VehicleSnapshotStrip extends StatelessWidget {
  const _VehicleSnapshotStrip({
    required this.isDark,
    required this.connectionLabel,
    required this.vin,
    required this.mileageKm,
  });

  final bool isDark;
  final String connectionLabel;
  final String vin;
  final double? mileageKm;

  @override
  Widget build(BuildContext context) {
    final muted = AppPalette.secondary(isDark);
    final connected = connectionLabel == 'Connected';
    final vehicleId = vin == 'Not identified' || vin.isEmpty ? '—' : vin;
    final mileage = mileageKm == null ? '—' : '${mileageKm!.round()} km';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(
        color: AppPalette.surface(isDark),
        borderRadius: BorderRadius.circular(appCardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _item(
              icon: connected ? Icons.link_rounded : Icons.link_off_rounded,
              label: 'Connection',
              value: connectionLabel,
              valueColor: connected ? AppPalette.green : muted,
              muted: muted,
            ),
          ),
          _divider(muted),
          Expanded(
            child: _item(
              icon: Icons.confirmation_number_outlined,
              label: 'VIN',
              value: vehicleId,
              muted: muted,
            ),
          ),
          _divider(muted),
          Expanded(
            child: _item(
              icon: Icons.route_outlined,
              label: 'Mileage',
              value: mileage,
              muted: muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(Color muted) =>
      Container(width: 1, height: 34, color: muted.withValues(alpha: .22));

  Widget _item({
    required IconData icon,
    required String label,
    required String value,
    required Color muted,
    Color? valueColor,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppPalette.blue),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: muted, fontSize: 9),
        ),
      ],
    ),
  );
}

class _TuneActionItem {
  const _TuneActionItem({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final Key key;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

class _TuneActionMenu extends StatelessWidget {
  const _TuneActionMenu({
    required this.isDark,
    required this.enabled,
    required this.items,
  });

  final bool isDark;
  final bool enabled;
  final List<_TuneActionItem> items;

  @override
  Widget build(BuildContext context) {
    final primaryActions = items.take(4).toList();
    final requestAction = items.length > 4 ? items[4] : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 640 ? 4 : 2;
            return GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: primaryActions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 152,
              ),
              itemBuilder: (context, index) => _TuneActionTile(
                isDark: isDark,
                enabled: enabled,
                item: primaryActions[index],
              ),
            );
          },
        ),
        if (requestAction != null) ...[
          const SizedBox(height: 12),
          _TuneRequestTile(
            isDark: isDark,
            enabled: enabled,
            item: requestAction,
          ),
        ],
      ],
    );
  }
}

Color _tuneMenuSurface(bool isDark) =>
    AppPalette.blue.withValues(alpha: isDark ? .13 : .07);

class _TuneActionTile extends StatelessWidget {
  const _TuneActionTile({
    required this.isDark,
    required this.enabled,
    required this.item,
  });

  final bool isDark;
  final bool enabled;
  final _TuneActionItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      child: Material(
        color: _tuneMenuSurface(isDark),
        borderRadius: BorderRadius.circular(appCardRadius),
        child: InkWell(
          key: item.key,
          onTap: enabled ? item.onTap : null,
          borderRadius: BorderRadius.circular(appCardRadius),
          child: Opacity(
            opacity: enabled ? 1 : .45,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppPalette.blue.withValues(
                            alpha: isDark ? .18 : .1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          color: AppPalette.blue,
                          size: 21,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 22,
                        color: AppPalette.secondary(isDark),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.secondary(isDark),
                      height: 1.2,
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
}

class _TuneRequestTile extends StatelessWidget {
  const _TuneRequestTile({
    required this.isDark,
    required this.enabled,
    required this.item,
  });

  final bool isDark;
  final bool enabled;
  final _TuneActionItem item;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: enabled,
    child: Material(
      color: _tuneMenuSurface(isDark),
      borderRadius: BorderRadius.circular(appCardRadius),
      child: InkWell(
        key: item.key,
        onTap: enabled ? item.onTap : null,
        borderRadius: BorderRadius.circular(appCardRadius),
        child: Opacity(
          opacity: enabled ? 1 : .45,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppPalette.blue.withValues(alpha: isDark ? .2 : .12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: AppPalette.blue, size: 21),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppPalette.secondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, color: AppPalette.blue),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _UnlockStatusPage extends StatelessWidget {
  const _UnlockStatusPage({required this.isDark, required this.status});

  final bool isDark;
  final Future<String> status;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppPalette.background(isDark),
    appBar: AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppPalette.blue.withValues(alpha: isDark ? .16 : .1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.lock_open_rounded,
              color: AppPalette.blue,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Check unlock status'),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: AppPalette.separator(isDark).withValues(alpha: .65),
        ),
      ),
    ),
    body: FutureBuilder<String>(
      future: status,
      builder: (context, snapshot) {
        final muted = isDark
            ? const Color(0xFF9DA8B8)
            : const Color(0xFF58677B);
        final complete = snapshot.connectionState == ConnectionState.done;
        final message = snapshot.hasError
            ? 'Unable to verify unlock status: ${snapshot.error}'
            : snapshot.data ?? 'Unable to verify unlock status.';
        final sections = message.split('\n\n');
        final positive = message.contains('reference matched');
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPalette.surface(isDark),
                    AppPalette.surface(isDark).withValues(alpha: .72),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: (positive ? AppPalette.green : AppPalette.blue)
                      .withValues(alpha: .22),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (positive ? AppPalette.green : AppPalette.blue)
                              .withValues(alpha: .14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          positive
                              ? Icons.verified_rounded
                              : Icons.search_rounded,
                          color: positive ? AppPalette.green : AppPalette.blue,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          complete
                              ? 'Unlock status result'
                              : 'Checking unlock status…',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -.2,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (!complete)
                    const LinearProgressIndicator()
                  else
                    for (var i = 0; i < sections.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      Text(
                        sections[i],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: i == 0 ? null : muted,
                          height: 1.45,
                          fontWeight: i == 0
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
              decoration: BoxDecoration(
                color: AppPalette.surface(isDark).withValues(alpha: .72),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppPalette.separator(isDark)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: AppPalette.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This check is informational only. It does not unlock, write to, or flash the ECU.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _EcuIdentityPage extends StatelessWidget {
  const _EcuIdentityPage({
    required this.isDark,
    required this.vin,
    required this.identity,
    required this.hardware,
    required this.software,
    required this.bootloader,
    required this.calibration,
    required this.manufacturingDate,
    required this.codingId,
  });

  final bool isDark;
  final String vin;
  final String? identity;
  final String? hardware;
  final String? software;
  final String? bootloader;
  final String? calibration;
  final String? manufacturingDate;
  final String? codingId;

  @override
  Widget build(BuildContext context) {
    final muted = AppPalette.secondary(isDark);
    final fields = <(String, String?)>[
      ('VIN', vin),
      ('Hardware ID (HWEL)', hardware),
      ('Software ID (SWFL)', software),
      ('Bootloader ID (BTLD)', bootloader),
      ('Calibration ID (SWFL)', calibration),
      ('Raw ECU ID (F1 50)', identity),
      ('Manufactured', manufacturingDate),
      ('Coding ID (CAFD)', codingId),
    ];
    return Scaffold(
      backgroundColor: AppPalette.background(isDark),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppPalette.blue.withValues(alpha: isDark ? .16 : .1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.memory_rounded,
                color: AppPalette.blue,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text('DME identity'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: AppPalette.separator(isDark).withValues(alpha: .65),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 42) / 2;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 18,
                children: [
                  for (final field in fields)
                    SizedBox(
                      width: itemWidth,
                      child: _EcuIdentityField(
                        label: field.$1,
                        value: field.$2,
                        muted: muted,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EcuIdentityField extends StatelessWidget {
  const _EcuIdentityField({
    required this.label,
    required this.value,
    required this.muted,
  });

  final String label;
  final String? value;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final shown = value?.trim().isNotEmpty == true ? value!.trim() : 'Not read';
    final valueColor = shown == 'Not read'
        ? muted.withValues(alpha: .82)
        : Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: muted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            shown,
            maxLines: 1,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              height: 1.1,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _MapSlot extends StatelessWidget {
  const _MapSlot({
    required this.label,
    required this.file,
    required this.metadata,
    required this.onPressed,
  });
  final String label;
  final File? file;
  final Map<String, dynamic>? metadata;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: file == null
        ? '$label, no file selected'
        : '$label, ${file!.uri.pathSegments.last}',
    child: Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: .28),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  file == null
                      ? label
                      : '$label · ${file!.uri.pathSegments.last}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(
                  file == null
                      ? Icons.upload_file_outlined
                      : Icons.swap_horiz_rounded,
                  size: 17,
                ),
                label: Text(file == null ? 'Choose file' : 'Replace file'),
              ),
            ],
          ),
          if (metadata != null)
            Text(
              '${_formatBytes(metadata!['size'] as int)} · SHA-256 ${('${metadata!['hash']}').substring(0, 12)}…',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (metadata?['inspection'] is Map) ...[
            const SizedBox(height: 4),
            _MapInspectionSummary(
              inspection: Map<String, dynamic>.from(
                metadata!['inspection'] as Map,
              ),
            ),
          ],
        ],
      ),
    ),
  );

  String _formatBytes(int bytes) => bytes < 1024 * 1024
      ? '${(bytes / 1024).toStringAsFixed(1)} KB'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

class _MapInspectionSummary extends StatelessWidget {
  const _MapInspectionSummary({required this.inspection});

  final Map<String, dynamic> inspection;

  @override
  Widget build(BuildContext context) {
    final provider = inspection['provider'] as String?;
    final revision = inspection['revision'] as String?;
    final isManifest = inspection['kind'] == 'provider_manifest';
    final color = isManifest ? AppPalette.blue : AppPalette.orange;
    final summary = isManifest
        ? 'Provider manifest · signature ${inspection['signature_status']}'
        : 'Opaque artifact · professional review only';
    final details = [
      summary,
      if (provider != null && provider.isNotEmpty) 'Provider: $provider',
      if (revision != null && revision.isNotEmpty) 'Revision: $revision',
    ].join('\n');
    return Semantics(
      label: details,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isManifest ? Icons.verified_outlined : Icons.visibility_outlined,
              size: 17,
              color: color,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                details,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonSummary extends StatelessWidget {
  const _ComparisonSummary({required this.original, required this.comparison});
  final Map<String, dynamic> original;
  final Map<String, dynamic> comparison;

  @override
  Widget build(BuildContext context) {
    final identical = original['hash'] == comparison['hash'];
    final color = identical ? AppPalette.orange : AppPalette.blue;
    final status = identical
        ? 'Files match byte-for-byte. Review only.'
        : 'Files differ. Review only.';
    return Semantics(
      label: status,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  identical ? Icons.info_outline : Icons.compare_arrows_rounded,
                  color: color,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Text(
                  identical
                      ? 'Files match byte-for-byte'
                      : 'Files differ · review only',
                  style: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Original: ${_size(original['size'] as int)} · imported ${_time(original['imported'] as DateTime)}',
            ),
            Text(
              'Comparison: ${_size(comparison['size'] as int)} · imported ${_time(comparison['imported'] as DateTime)}',
            ),
            const SizedBox(height: 8),
            const Text(
              'Byte comparison only · no calibration interpretation or writing is enabled.',
            ),
          ],
        ),
      ),
    );
  }

  String _size(int bytes) => bytes < 1024 * 1024
      ? '${(bytes / 1024).toStringAsFixed(1)} KB'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  String _time(DateTime value) => '${value.day}/${value.month}/${value.year}';
}

class _CheckResult extends StatelessWidget {
  const _CheckResult({
    required this.label,
    required this.passed,
    required this.detail,
  });
  final String label;
  final bool passed;
  final String detail;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    dense: true,
    leading: Icon(
      passed ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
      color: passed ? AppPalette.green : AppPalette.orange,
    ),
    title: Text(label),
    subtitle: Text(detail),
  );
}

class _TuneReadinessPanel extends StatelessWidget {
  const _TuneReadinessPanel({
    required this.isDark,
    required this.vin,
    required this.connectionLabel,
    required this.onCheckVehicle,
  });
  final bool isDark;
  final String vin;
  final String connectionLabel;
  final VoidCallback onCheckVehicle;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final muted = isDark ? const Color(0xFF9DA8B8) : const Color(0xFF58677B);
    final connecting =
        connectionLabel == 'Connecting' || connectionLabel == 'Searching';
    final connected = connectionLabel == 'Connected';
    final statusColor = connected
        ? AppPalette.green
        : connecting
        ? primary
        : muted;

    final statusDetail = vin == 'Not identified'
        ? 'Connect vehicle'
        : connected
        ? 'Connected'
        : 'Waiting for a verified vehicle session';
    return Semantics(
      container: true,
      label: 'Tune. $statusDetail',
      child: Container(
        height: appTopActionCardHeight,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          color: AppPalette.surface(isDark),
          borderRadius: BorderRadius.circular(appCardRadius),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: isDark ? .16 : .09),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AnimatedSwitcher(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 220),
                    child: connecting && !reduceMotion
                        ? ExcludeSemantics(
                            key: const ValueKey('connection-pulse'),
                            child: Lottie.asset(
                              'assets/animations/connection_pulse.json',
                              width: 36,
                              height: 36,
                              repeat: true,
                            ),
                          )
                        : Icon(
                            connected
                                ? Icons.check_circle_rounded
                                : Icons.link_off_rounded,
                            key: ValueKey(
                              connected ? 'ready-icon' : 'offline-icon',
                            ),
                            color: statusColor,
                            size: 22,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tune',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusDetail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: muted, fontSize: 11),
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
              height: 48,
              child: FilledButton.icon(
                key: const Key('tune-check-vehicle-button'),
                onPressed: connected ? onCheckVehicle : null,
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white.withValues(alpha: .65),
                ),
                icon: const Icon(Icons.manage_search_rounded, size: 20),
                label: const Text('Check vehicle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TunerRequestPage extends StatelessWidget {
  const _TunerRequestPage({
    required this.isDark,
    required this.revision,
    required this.workspace,
  });

  final bool isDark;
  final ValueListenable<int> revision;
  final Widget Function() workspace;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppPalette.background(isDark),
    appBar: AppBar(title: const Text('Tuner Request')),
    body: ValueListenableBuilder<int>(
      valueListenable: revision,
      builder: (context, value, _) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: workspace(),
      ),
    ),
  );
}

class _TuneActionPage extends StatefulWidget {
  const _TuneActionPage({
    required this.isDark,
    required this.title,
    required this.icon,
    required this.message,
    required this.detail,
    this.products,
    this.selectedProduct,
    this.identity,
    this.onProductSelected,
  });

  final bool isDark;
  final String title;
  final IconData icon;
  final String message;
  final String detail;
  final List<TuneProduct>? products;
  final TuneProduct? selectedProduct;
  final VehicleIdentity? identity;
  final ValueChanged<TuneProduct>? onProductSelected;

  @override
  State<_TuneActionPage> createState() => _TuneActionPageState();
}

class _TuneActionPageState extends State<_TuneActionPage> {
  TuneProduct? selectedProduct;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.selectedProduct;
  }

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;
    final muted = widget.isDark
        ? const Color(0xFF9DA8B8)
        : const Color(0xFF58677B);
    return Scaffold(
      backgroundColor: AppPalette.background(widget.isDark),
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.surface(widget.isDark),
              borderRadius: BorderRadius.circular(appCardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(widget.icon, color: AppPalette.blue, size: 30),
                const SizedBox(height: 18),
                Text(
                  widget.message,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.detail,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: muted, height: 1.45),
                ),
              ],
            ),
          ),
          if (widget.products != null) ...[
            const SizedBox(height: 20),
            _TuneProductSelector(
              isDark: widget.isDark,
              products: widget.products!,
              selectedProductId: selectedProduct!.id,
              identity: widget.identity,
              onSelected: (product) {
                setState(() => selectedProduct = product);
                widget.onProductSelected?.call(product);
              },
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.orange.withValues(
                alpha: widget.isDark ? .12 : .08,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: AppPalette.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No ECU programming or calibration writing is enabled.',
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
