import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/connection_status_chip.dart';
import 'package:bmw_app/vehicle/vehicle_capabilities.dart';
import 'package:bmw_app/vehicle/vehicle_identity.dart';
import 'package:bmw_app/tuning/stock_file_store.dart';
import 'package:bmw_app/tuning/tune_product.dart';
import 'package:bmw_app/tuning/tuning_platform.dart';
import 'package:bmw_app/tuning/tuner_package.dart';
import 'package:bmw_app/logging/data_logger.dart';
import 'package:bmw_app/tuning/tuner_request.dart';
import 'package:bmw_app/tuning/tune_compatibility.dart';
import 'package:bmw_app/tuning/s55_identity_report.dart';
import 'package:bmw_app/tuning/calibration_artifact.dart';
import 'package:bmw_app/vehicle/simulator_transport.dart';
import 'package:bmw_app/src/rust/api/vehicle.dart' as rust_vehicle;
import 'package:bmw_app/vehicle/garage_screen.dart';
import 'package:bmw_app/vehicle/vehicle_garage.dart';
import 'package:bmw_app/logging/log_quality.dart';
import 'package:flutter/material.dart';
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
  });

  final bool isDark;
  final String vin;
  final double? mileageKm;
  final String connectionLabel;
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

  @override
  State<TuneScreen> createState() => _TuneScreenState();
}

class _TuneScreenState extends State<TuneScreen> {
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
    super.dispose();
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
    await tunerRequestStore.save(
      TunerRequest(
        id: 'draft_${widget.vin.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_')}',
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
        createdAt: DateTime.now(),
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
            Text(
              'Stock backup history',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (backups.isEmpty)
              const ListTile(title: Text('No backups saved for this vehicle')),
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

  Future<void> showUnlockStatus() async {
    final identity = identifyVehicle(widget.vin);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlock requirement'),
        content: Text(
          identity == null
              ? 'Connect and identify a supported vehicle to check its DME requirements.'
              : '${identity.displayLabel}\n\nUnlock checks are informational only in this build. No ECU write or flash operation is available.',
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
              detail:
                  simulatorUnlockStatus == null ||
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
            if (simulatorUnlockStatus == null ||
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

  Future<void> exportS55IdentityReport() async {
    final capturedAt = widget.identityCapturedAt ?? DateTime.now();
    final stamp = capturedAt
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final file = File(
      '${Directory.systemTemp.path}${Platform.pathSeparator}BimmerScope_S55_Identity_$stamp.txt',
    );
    await file.writeAsString(
      buildS55IdentityReport(
        vin: widget.vin,
        evidence: compatibilityReport.evidence,
      ),
    );
    if (!mounted) return;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/plain')],
        subject: 'BimmerScope S55 identity report',
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
              Text(
                request.vehicleLabel,
                style: Theme.of(context).textTheme.titleLarge,
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Status'),
                subtitle: Text(
                  '${requestStatusLabel(request.status)} · Revision ${request.revision}',
                ),
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                leading: const Icon(Icons.history_rounded),
                title: const Text('Request timeline'),
                subtitle: Text('${request.timeline.length} recorded events'),
                children: [
                  for (final event in request.timeline.reversed)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(event.action),
                      subtitle: Text(
                        '${event.recordedAt.toLocal()}${event.detail == null ? '' : '\n${event.detail}'}',
                      ),
                      isThreeLine: event.detail != null,
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
                const _TuneStepLabel(
                  number: '1',
                  title: 'Check the vehicle',
                  detail: 'Confirm the connection and ECU identity first.',
                ),
                const SizedBox(height: 8),
                if (s55Connected) ...[
                  const _TuneStepLabel(
                    number: '2',
                    title: 'Choose a product',
                    detail:
                        'Products become available only for validated vehicles.',
                  ),
                  const SizedBox(height: 8),
                  _TuneProductSelector(
                    isDark: widget.isDark,
                    products: s55RemapProducts,
                    selectedProductId: selectedProduct.id,
                    identity: connectedIdentity,
                    onSelected: (product) {
                      setState(() => selectedProduct = product);
                      _scheduleDraftSave();
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),
                const _TuneStepLabel(
                  number: '3',
                  title: 'Prepare the request',
                  detail: 'Add a stock file, notes, and logs for your tuner.',
                ),
                const SizedBox(height: 8),
                _VehicleSnapshotStrip(
                  isDark: widget.isDark,
                  connectionLabel: widget.connectionLabel,
                  vin: widget.vin,
                  mileageKm: widget.mileageKm,
                ),
                const SizedBox(height: 12),
                _TuningCoveragePanel(
                  isDark: widget.isDark,
                  currentEngine: connectedIdentity?.engine,
                  ecuDetected: widget.engineEcuDetected,
                ),
                if (widget.connectionLabel == 'Connected' &&
                    widget.engineEcuDetected) ...[
                  const SizedBox(height: 12),
                  _EcuIdentityFieldBar(
                    isDark: widget.isDark,
                    identity: widget.engineEcuIdentity,
                    hardware: widget.engineEcuHardware,
                    software: widget.engineEcuSoftware,
                    applicationSoftware: widget.engineEcuApplicationSoftware,
                    softwareVersion: widget.engineEcuSoftwareVersion,
                    bootloader: widget.engineEcuBootloader,
                    calibration: widget.engineEcuCalibration,
                    supplierHardware: widget.engineEcuSupplierHardware,
                    supplierSoftware: widget.engineEcuSupplierSoftware,
                    bootloaderFingerprint:
                        widget.engineEcuBootloaderFingerprint,
                    softwareFingerprint: widget.engineEcuSoftwareFingerprint,
                    calibrationFingerprint:
                        widget.engineEcuCalibrationFingerprint,
                    sgbdIndex: widget.engineEcuSgbdIndex,
                    serialNumber: widget.engineEcuSerialNumber,
                    manufacturingDate: widget.engineEcuManufacturingDate,
                    codingId: widget.engineEcuCodingId,
                    cvn: widget.engineEcuCvn,
                    sessionId: widget.sessionId,
                    source: widget.simulatorMode ? 'simulator' : 'live ENET',
                    capturedAt: widget.identityCapturedAt,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: exportS55IdentityReport,
                      icon: const Icon(Icons.ios_share_rounded, size: 18),
                      label: const Text('Export identity report'),
                    ),
                  ),
                ],
                if (identifyVehicle(widget.vin) case final identity?) ...[
                  const SizedBox(height: 16),
                  _ProfileCard(
                    isDark: widget.isDark,
                    identity: identity,
                    vin: widget.vin,
                    mileageKm: widget.mileageKm,
                    lastConnectedAt: widget.identityCapturedAt,
                    evidenceProfile: resolvedEcuProfile,
                  ),
                ],
                if (s55Connected) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: selectedProductCompatible
                        ? createTunerPackage
                        : null,
                    icon: const Icon(Icons.send_outlined),
                    label: Text(
                      'Prepare ${selectedProduct.variantLabel} package',
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.tune_rounded),
                    title: const Text('Prepare a tuner request'),
                    subtitle: const Text(
                      'Stock file, notes, logs, and saved requests',
                    ),
                    children: [
                      ExpansionTile(
                        leading: const Icon(Icons.map_outlined),
                        title: const Text('Optional map review'),
                        subtitle: const Text(
                          'Browse, review, and prepare map files',
                        ),
                        children: [
                          if (s55Connected)
                            ListTile(
                              leading: const Icon(Icons.storefront_outlined),
                              title: const Text('S55 remap products'),
                              subtitle: const Text(
                                'Competition and CS product tracks',
                              ),
                              onTap: () => showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('S55 remap products'),
                                  content: const Text(
                                    'Competition and CS are separate product tracks for the F82 M4 S55. Select the track above before preparing a tuner package.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
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
                          ListTile(
                            leading: const Icon(Icons.info_outline_rounded),
                            title: const Text('Review backend options'),
                            subtitle: const Text(
                              'Unavailable until vehicle-specific support is validated',
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock_open_outlined),
                            title: const Text('Check unlock requirement'),
                            subtitle: const Text(
                              'Read-only vehicle capability check',
                            ),
                            onTap: showUnlockStatus,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stock file & backups',
                                style: Theme.of(context).textTheme.titleMedium,
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
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: importStockFile,
                                icon: const Icon(Icons.upload_file_outlined),
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
                                  icon: const Icon(Icons.stop_circle_outlined),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Read-only map comparison',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Compare file metadata before sending anything to a tuner.',
                              ),
                              if (!hasSupportedVehicleProfile) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Identify a supported vehicle before comparing map files.',
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ] else if (!identityAvailable) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Offline review only. Connect to capture live ECU evidence before requesting a calibration read.',
                                  style: TextStyle(
                                    color: AppPalette.secondary(widget.isDark),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tuner request details',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Saved automatically for this vehicle. Add the hardware, fuel, and map notes your tuner needs.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: fuelController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  labelText: 'Fuel',
                                  hintText: 'Example: 98 RON / 93 AKI / E30',
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  const ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    leading: Icon(Icons.info_outline_rounded),
                                    title: Text('No saved logs yet'),
                                    subtitle: Text(
                                      'Record a live-data log first, then return here to attach it.',
                                    ),
                                  ),
                                for (final log in availableLogs)
                                  CheckboxListTile(
                                    contentPadding: const EdgeInsets.symmetric(
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
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => showRequestDetails(request),
                          ),
                        const SizedBox(height: 8),
                      ],
                      Card(
                        color: AppPalette.surface(widget.isDark),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lock_outline_rounded, size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Calibration writing is not available in this build. BimmerScope will only enable it for a validated vehicle profile with backup and recovery protection.',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
            const Expanded(
              child: Text(
                'S55 remap',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
    final borderColor = selected
        ? primary.withValues(alpha: .75)
        : AppPalette.separator(isDark).withValues(alpha: .7);
    return Semantics(
      button: true,
      selected: selected,
      label: product.displayName,
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
              border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
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
                      color: selected ? primary : muted,
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
                      label: compatible ? 'Vehicle match' : identityStatusLabel,
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

class _TuningCoveragePanel extends StatelessWidget {
  const _TuningCoveragePanel({
    required this.isDark,
    required this.currentEngine,
    required this.ecuDetected,
  });

  final bool isDark;
  final String? currentEngine;
  final bool ecuDetected;

  @override
  Widget build(BuildContext context) {
    final muted = AppPalette.secondary(isDark);
    final currentTrack = tuningTrackForEngine(currentEngine);
    final connectedTrack = currentTrack == null
        ? 'Connect a supported vehicle to identify its engine track.'
        : ecuDetected
        ? '${currentTrack.label} · ${currentTrack.statusLabel}'
        : '${currentTrack.label} · ECU identity pending';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppPalette.surface(isDark),
        borderRadius: BorderRadius.circular(appCardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hub_outlined, size: 18, color: AppPalette.blue),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Tuning coverage',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '${tuningEngineTracks.length} engine families',
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(connectedTrack, style: TextStyle(color: muted, fontSize: 11)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final track in tuningEngineTracks)
                _TuningTrackChip(
                  label: track.label,
                  active: track.engine == currentEngine,
                  enabled: track.packagePreparationEnabled,
                  isDark: isDark,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Only the validated S55 F82 DCT track can prepare a product package today. Other families remain read-only until their ECU evidence is validated.',
            style: TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _TuningTrackChip extends StatelessWidget {
  const _TuningTrackChip({
    required this.label,
    required this.active,
    required this.enabled,
    required this.isDark,
  });

  final String label;
  final bool active;
  final bool enabled;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppPalette.blue
        : enabled
        ? AppPalette.green
        : AppPalette.secondary(isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: active ? .16 : .09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: active ? .5 : .18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EcuIdentityFieldBar extends StatelessWidget {
  const _EcuIdentityFieldBar({
    required this.isDark,
    required this.identity,
    required this.hardware,
    required this.software,
    required this.applicationSoftware,
    required this.softwareVersion,
    required this.bootloader,
    required this.calibration,
    required this.supplierHardware,
    required this.supplierSoftware,
    required this.bootloaderFingerprint,
    required this.softwareFingerprint,
    required this.calibrationFingerprint,
    required this.sgbdIndex,
    required this.serialNumber,
    required this.manufacturingDate,
    required this.codingId,
    required this.cvn,
    required this.sessionId,
    required this.source,
    required this.capturedAt,
  });

  final bool isDark;
  final String? identity;
  final String? hardware;
  final String? software;
  final String? applicationSoftware;
  final String? softwareVersion;
  final String? bootloader;
  final String? calibration;
  final String? supplierHardware;
  final String? supplierSoftware;
  final String? bootloaderFingerprint;
  final String? softwareFingerprint;
  final String? calibrationFingerprint;
  final String? sgbdIndex;
  final String? serialNumber;
  final String? manufacturingDate;
  final String? codingId;
  final String? cvn;
  final String sessionId;
  final String source;
  final DateTime? capturedAt;

  String valueOf(String? value) =>
      value?.trim().isNotEmpty == true ? value!.trim() : 'Not read';

  @override
  Widget build(BuildContext context) {
    final muted = AppPalette.secondary(isDark);
    final border = muted.withValues(alpha: .18);
    final fields = [
      ('DME identity', identity),
      ('HW number', hardware),
      ('SW number', software),
      ('App SW', applicationSoftware),
      ('SW version', softwareVersion),
      ('Boot / startup', bootloader),
      ('Calibration', calibration),
      ('Supplier HW', supplierHardware),
      ('Supplier SW', supplierSoftware),
      ('Boot FP', bootloaderFingerprint),
      ('SW FP', softwareFingerprint),
      ('Cal FP', calibrationFingerprint),
      ('SGBD index', sgbdIndex),
      ('ECU serial', serialNumber),
      ('Manufactured', manufacturingDate),
      ('Coding ID', codingId),
      ('CVN', cvn),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: AppPalette.surface(isDark),
        borderRadius: BorderRadius.circular(appCardRadius),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory_rounded, size: 18, color: AppPalette.blue),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'DME identity',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                'READ-ONLY',
                style: TextStyle(
                  color: muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Compatibility fields collected from the connected ECU',
            style: TextStyle(color: muted, fontSize: 11),
          ),
          const SizedBox(height: 3),
          Text(
            'Source: $source${sessionId.isEmpty ? '' : ' · session $sessionId'}${capturedAt == null ? '' : ' · ${capturedAt!.toLocal().toIso8601String().replaceFirst('T', ' ').substring(0, 19)}'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: muted,
              fontFamily: 'Geist Mono',
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var index = 0; index < fields.length; index++) ...[
                  if (index > 0)
                    Container(
                      width: 1,
                      height: 38,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: border,
                    ),
                  _EcuIdentityField(
                    label: fields[index].$1,
                    value: valueOf(fields[index].$2),
                    muted: muted,
                    isUnavailable:
                        fields[index].$2 == null ||
                        fields[index].$2!.trim().isEmpty,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Core review: DME identity, BMW software, boot/startup, and calibration. Physical hardware and supplier fields are optional on some S55 software levels.',
            style: TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _EcuIdentityField extends StatelessWidget {
  const _EcuIdentityField({
    required this.label,
    required this.value,
    required this.muted,
    required this.isUnavailable,
  });

  final String label;
  final String value;
  final Color muted;
  final bool isUnavailable;

  @override
  Widget build(BuildContext context) {
    final valueColor = isUnavailable
        ? muted
        : Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: 132,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
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
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Tooltip(
              message: value,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.isDark,
    required this.identity,
    required this.vin,
    this.mileageKm,
    this.lastConnectedAt,
    this.evidenceProfile,
  });
  final bool isDark;
  final VehicleIdentity identity;
  final String vin;
  final double? mileageKm;
  final DateTime? lastConnectedAt;
  final ResolvedEcuProfile? evidenceProfile;

  @override
  Widget build(BuildContext context) {
    final profile = identity.profile;
    return Card(
      color: AppPalette.surface(isDark),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_outlined, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    profile.label,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Profile capabilities',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final capability in VehicleCapability.values)
                  _CapabilityLabel(
                    capability: capability,
                    enabled: profile.supports(capability),
                  ),
              ],
            ),
            if (evidenceProfile != null) ...[
              const SizedBox(height: 16),
              Text(
                'Current-session evidence',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Text(
                _evidenceDetail,
                style: TextStyle(
                  color: AppPalette.secondary(isDark),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final capability in _evidenceCapabilities)
                    _CapabilityLabel(
                      capability: capability,
                      enabled: evidenceProfile!.supports(capability),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await VehicleGarageStore().upsert(
                  GarageVehicle(
                    vin: vin,
                    label: identity.displayLabel,
                    profileId: profile.id,
                    mileageKm: mileageKm,
                    lastConnectedAt: lastConnectedAt,
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vehicle saved to garage')),
                  );
                }
              },
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Save vehicle to garage'),
            ),
          ],
        ),
      ),
    );
  }

  static const _evidenceCapabilities = <VehicleCapability>[
    VehicleCapability.calibrationRead,
    VehicleCapability.ecuMemoryInventoryRead,
    VehicleCapability.offlinePackageInspection,
  ];

  String get _evidenceDetail => switch (evidenceProfile!.confidence) {
    ProfileConfidence.exact =>
      'VIN and complete DME fingerprint match. Read-only inspection evidence is available.',
    ProfileConfidence.familyMatch =>
      'DME family matches, but the complete VIN-bound fingerprint is not available yet.',
    ProfileConfidence.unknown =>
      'This live DME identity does not match the expected vehicle ECU family.',
    ProfileConfidence.vehicleOnly =>
      'Vehicle profile identified; ECU evidence has not been matched yet.',
  };
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              file == null ? label : '$label · ${file!.uri.pathSegments.last}',
            ),
          ),
          OutlinedButton(
            onPressed: onPressed,
            child: Text(file == null ? 'Choose' : 'Replace'),
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
          inspection: Map<String, dynamic>.from(metadata!['inspection'] as Map),
        ),
      ],
    ],
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
    final color = isManifest ? AppPalette.blue : Colors.orange;
    final summary = isManifest
        ? 'Provider manifest · signature ${inspection['signature_status']}'
        : 'Opaque artifact · professional review only';
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Text(
        [
          summary,
          if (provider != null && provider.isNotEmpty) 'Provider: $provider',
          if (revision != null && revision.isNotEmpty) 'Revision: $revision',
        ].join('\n'),
        style: Theme.of(context).textTheme.bodySmall,
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
    final color = identical ? Colors.orange : AppPalette.blue;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .35)),
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
    );
  }

  String _size(int bytes) => bytes < 1024 * 1024
      ? '${(bytes / 1024).toStringAsFixed(1)} KB'
      : '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  String _time(DateTime value) => '${value.day}/${value.month}/${value.year}';
}

class _CapabilityLabel extends StatelessWidget {
  const _CapabilityLabel({required this.capability, required this.enabled});
  final VehicleCapability capability;
  final bool enabled;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: enabled ? Colors.green.withValues(alpha: .12) : Colors.transparent,
      border: Border.all(
        color: enabled
            ? Colors.green.withValues(alpha: .45)
            : Theme.of(context).dividerColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 12,
          color: enabled ? Colors.green : Theme.of(context).disabledColor,
        ),
      ),
    ),
  );

  String get _label => switch (capability) {
    VehicleCapability.diagnostics => 'Diagnostics',
    VehicleCapability.liveData => 'Live data',
    VehicleCapability.dataLogging => 'Data logging',
    VehicleCapability.flapControl => 'Flap control',
    VehicleCapability.calibrationRead => 'Calibration read',
    VehicleCapability.calibrationWrite => 'Calibration write',
    VehicleCapability.ecuIdentification => 'ECU identification',
    VehicleCapability.ecuDtcRead => 'ECU fault read',
    VehicleCapability.ecuFreezeFrameRead => 'Freeze-frame read',
    VehicleCapability.ecuSoftwareMetadataRead => 'ECU software metadata',
    VehicleCapability.ecuMemoryInventoryRead => 'ECU memory inventory',
    VehicleCapability.ecuBackupEligible => 'ECU backup eligible',
    VehicleCapability.offlinePackageInspection => 'Offline package inspection',
  };
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
      color: passed ? Colors.green : Colors.orange,
    ),
    title: Text(label),
    subtitle: Text(detail),
  );
}

class _TuneStepLabel extends StatelessWidget {
  const _TuneStepLabel({
    required this.number,
    required this.title,
    required this.detail,
  });

  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            number,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(detail, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
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
    final muted = isDark ? const Color(0xFF9DA8B8) : const Color(0xFF58677B);
    final connecting =
        connectionLabel == 'Connecting' || connectionLabel == 'Searching';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: AppPalette.surface(isDark),
        borderRadius: BorderRadius.circular(appCardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: isDark ? .18 : .10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: connecting
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
                      Icons.tune_rounded,
                      key: const ValueKey('tune-icon'),
                      color: primary,
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
                const Text(
                  'Tune your vehicle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  vin == 'Not identified'
                      ? 'Identify a supported vehicle to prepare a package'
                      : 'Vehicle connected · VIN $vin',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onCheckVehicle,
            style: FilledButton.styleFrom(
              minimumSize: const Size(76, 44),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Start here'),
          ),
        ],
      ),
    );
  }
}
