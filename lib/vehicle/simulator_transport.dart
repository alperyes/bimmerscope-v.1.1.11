import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bmw_app/src/rust/api/vehicle.dart';

/// HTTP transport for the standalone BimmerScopeSimulator desktop service.
/// Android emulators reach the host computer through 10.0.2.2.
Stream<VehicleEvent> startSimulatorSession({
  String? host,
  int port = 8765,
  List<String>? activeSensorIds,
}) async* {
  final base = Uri.parse('http://${host ?? _defaultSimulatorHost}:$port');
  final vehicle = await _get(base.resolve('/api/vehicle'));
  yield VehicleEvent(
    kind: 'connected',
    message: 'Simulator session active',
    sensorId: '',
    value: 0,
    rawValue: 0,
    vin: '',
    ecuAddress: 0,
    ecuIdentity: '',
    ecuHardware: '',
    ecuSoftware: '',
    ecuBootloader: '',
    ecuCalibration: '',
    ecuApplicationSoftware: '',
    ecuSoftwareVersion: '',
    ecuSupplierHardware: '',
    ecuSupplierSoftware: '',
    ecuBootloaderFingerprint: '',
    ecuSoftwareFingerprint: '',
    ecuCalibrationFingerprint: '',
    ecuSgbdIndex: '',
    ecuSerialNumber: '',
    ecuManufacturingDate: '',
    ecuDiagnosticSession: '',
    ecuCodingId: '',
    ecuCvn: '',
    ecuBmwRoutine0205Raw: '',
    ecuBmwRoutine0205Software: '',
    ecuBmwControllerFamily: '',
    ecuBmwVariant: '',
    ecuBmwTransmission: '',
    ecuBmwEmissions: '',
    ecuBmwInternalToken: '',
    transportRequestId: BigInt.zero,
    transportRequestOperation: '',
    transportRequestAgeMs: BigInt.zero,
    transportRetryCount: 0,
    transportSocketState: 'simulator',
    transportRecoveryAction: 'none',
    transportRecoveryResult: 'not_required',
  );
  yield VehicleEvent(
    kind: 'vin',
    message: 'Vehicle identified',
    sensorId: '',
    value: 0,
    rawValue: 0,
    vin: vehicle['vin'] as String? ?? 'SIMULATED-F82-S55',
    ecuAddress: 0,
    ecuIdentity: '',
    ecuHardware: '',
    ecuSoftware: '',
    ecuBootloader: '',
    ecuCalibration: '',
    ecuApplicationSoftware: '',
    ecuSoftwareVersion: '',
    ecuSupplierHardware: '',
    ecuSupplierSoftware: '',
    ecuBootloaderFingerprint: '',
    ecuSoftwareFingerprint: '',
    ecuCalibrationFingerprint: '',
    ecuSgbdIndex: '',
    ecuSerialNumber: '',
    ecuManufacturingDate: '',
    ecuDiagnosticSession: '',
    ecuCodingId: '',
    ecuCvn: '',
    ecuBmwRoutine0205Raw: '',
    ecuBmwRoutine0205Software: '',
    ecuBmwControllerFamily: '',
    ecuBmwVariant: '',
    ecuBmwTransmission: '',
    ecuBmwEmissions: '',
    ecuBmwInternalToken: '',
    transportRequestId: BigInt.zero,
    transportRequestOperation: '',
    transportRequestAgeMs: BigInt.zero,
    transportRetryCount: 0,
    transportSocketState: 'simulator',
    transportRecoveryAction: 'none',
    transportRecoveryResult: 'not_required',
  );
  yield VehicleEvent(
    kind: 'ecu_identity',
    message: 'Engine ECU identity read',
    sensorId: '',
    value: 0,
    rawValue: 0,
    vin: '',
    ecuAddress: 0x12,
    ecuIdentity: 'MEVD17.2.G · simulator',
    ecuHardware: '',
    ecuSoftware: '',
    ecuBootloader: '',
    ecuCalibration: '',
    ecuApplicationSoftware: '',
    ecuSoftwareVersion: '',
    ecuSupplierHardware: '',
    ecuSupplierSoftware: '',
    ecuBootloaderFingerprint: '',
    ecuSoftwareFingerprint: '',
    ecuCalibrationFingerprint: '',
    ecuSgbdIndex: '',
    ecuSerialNumber: '',
    ecuManufacturingDate: '',
    ecuDiagnosticSession: '',
    ecuCodingId: '',
    ecuCvn: '',
    ecuBmwRoutine0205Raw: '',
    ecuBmwRoutine0205Software: '',
    ecuBmwControllerFamily: '',
    ecuBmwVariant: '',
    ecuBmwTransmission: '',
    ecuBmwEmissions: '',
    ecuBmwInternalToken: '',
    transportRequestId: BigInt.zero,
    transportRequestOperation: '',
    transportRequestAgeMs: BigInt.zero,
    transportRetryCount: 0,
    transportSocketState: 'simulator',
    transportRecoveryAction: 'none',
    transportRecoveryResult: 'not_required',
  );
  yield VehicleEvent(
    kind: 'ecu_fingerprint',
    message: 'Read-only ECU fingerprint collected',
    sensorId: '',
    value: 0,
    rawValue: 0,
    vin: '',
    ecuAddress: 0x12,
    ecuIdentity: '',
    ecuHardware: 'S55-SIM-HW-01',
    ecuSoftware: 'S55-SIM-SW-01',
    ecuBootloader: 'S55-SIM-BL-01',
    ecuCalibration: 'S55-SIM-CAL-01',
    ecuApplicationSoftware: 'S55-SIM-APP-01',
    ecuSoftwareVersion: 'SIM-1.0.0',
    ecuSupplierHardware: 'BOSCH-SIM-HW',
    ecuSupplierSoftware: 'BOSCH-SIM-SW',
    ecuBootloaderFingerprint: 'A1B2C3D4',
    ecuSoftwareFingerprint: '1122334455667788',
    ecuCalibrationFingerprint: '99AABBCCDDEEFF00',
    ecuSgbdIndex: '0F 1E A0',
    ecuSerialNumber: '0170170211',
    ecuManufacturingDate: '07.08.14',
    ecuDiagnosticSession: '',
    ecuCodingId: 'SIM-CODING-STAMP',
    ecuCvn: 'SIM-CVN',
    ecuBmwRoutine0205Raw: '',
    ecuBmwRoutine0205Software: '',
    ecuBmwControllerFamily: '',
    ecuBmwVariant: '',
    ecuBmwTransmission: '',
    ecuBmwEmissions: '',
    ecuBmwInternalToken: '',
    transportRequestId: BigInt.zero,
    transportRequestOperation: '',
    transportRequestAgeMs: BigInt.zero,
    transportRetryCount: 0,
    transportSocketState: 'simulator',
    transportRecoveryAction: 'none',
    transportRecoveryResult: 'not_required',
  );
  yield VehicleEvent(
    kind: 'mileage',
    message: 'Mileage received',
    sensorId: '',
    value: (vehicle['mileage_km'] as num?)?.toDouble() ?? 0,
    rawValue: 0,
    vin: '',
    ecuAddress: 0,
    ecuIdentity: '',
    ecuHardware: '',
    ecuSoftware: '',
    ecuBootloader: '',
    ecuCalibration: '',
    ecuApplicationSoftware: '',
    ecuSoftwareVersion: '',
    ecuSupplierHardware: '',
    ecuSupplierSoftware: '',
    ecuBootloaderFingerprint: '',
    ecuSoftwareFingerprint: '',
    ecuCalibrationFingerprint: '',
    ecuSgbdIndex: '',
    ecuSerialNumber: '',
    ecuManufacturingDate: '',
    ecuDiagnosticSession: '',
    ecuCodingId: '',
    ecuCvn: '',
    ecuBmwRoutine0205Raw: '',
    ecuBmwRoutine0205Software: '',
    ecuBmwControllerFamily: '',
    ecuBmwVariant: '',
    ecuBmwTransmission: '',
    ecuBmwEmissions: '',
    ecuBmwInternalToken: '',
    transportRequestId: BigInt.zero,
    transportRequestOperation: '',
    transportRequestAgeMs: BigInt.zero,
    transportRetryCount: 0,
    transportSocketState: 'simulator',
    transportRecoveryAction: 'none',
    transportRecoveryResult: 'not_required',
  );

  final sensors = defaultSensors();
  final selectedIds = (activeSensorIds == null || activeSensorIds.isEmpty)
      ? sensors.take(6).map((sensor) => sensor.id).toSet()
      : activeSensorIds.take(6).toSet();
  while (true) {
    Map<String, dynamic> data;
    try {
      data = await _get(base.resolve('/api/telemetry'));
    } catch (error) {
      yield VehicleEvent(
        kind: 'warning',
        message: 'Simulator telemetry unavailable: $error',
        sensorId: '',
        value: 0,
        rawValue: 0,
        vin: '',
        ecuAddress: 0,
        ecuIdentity: '',
        ecuHardware: '',
        ecuSoftware: '',
        ecuBootloader: '',
        ecuCalibration: '',
        ecuApplicationSoftware: '',
        ecuSoftwareVersion: '',
        ecuSupplierHardware: '',
        ecuSupplierSoftware: '',
        ecuBootloaderFingerprint: '',
        ecuSoftwareFingerprint: '',
        ecuCalibrationFingerprint: '',
        ecuSgbdIndex: '',
        ecuSerialNumber: '',
        ecuManufacturingDate: '',
        ecuDiagnosticSession: '',
        ecuCodingId: '',
        ecuCvn: '',
        ecuBmwRoutine0205Raw: '',
        ecuBmwRoutine0205Software: '',
        ecuBmwControllerFamily: '',
        ecuBmwVariant: '',
        ecuBmwTransmission: '',
        ecuBmwEmissions: '',
        ecuBmwInternalToken: '',
        transportRequestId: BigInt.zero,
        transportRequestOperation: '',
        transportRequestAgeMs: BigInt.zero,
        transportRetryCount: 0,
        transportSocketState: 'simulator',
        transportRecoveryAction: 'none',
        transportRecoveryResult: 'not_required',
      );
      await Future<void>.delayed(const Duration(seconds: 1));
      continue;
    }
    for (final sensor in sensors) {
      if (!selectedIds.contains(sensor.id)) continue;
      final value = (data[sensor.id] as num?)?.toDouble();
      if (value == null) continue;
      final raw = ((value - sensor.offset) / sensor.scale).round().clamp(
        0,
        0xFFFFFFFF,
      );
      yield VehicleEvent(
        kind: 'sensor',
        message: sensor.label,
        sensorId: sensor.id,
        value: value,
        rawValue: raw,
        vin: '',
        ecuAddress: sensor.ecu,
        ecuIdentity: '',
        ecuHardware: '',
        ecuSoftware: '',
        ecuBootloader: '',
        ecuCalibration: '',
        ecuApplicationSoftware: '',
        ecuSoftwareVersion: '',
        ecuSupplierHardware: '',
        ecuSupplierSoftware: '',
        ecuBootloaderFingerprint: '',
        ecuSoftwareFingerprint: '',
        ecuCalibrationFingerprint: '',
        ecuSgbdIndex: '',
        ecuSerialNumber: '',
        ecuManufacturingDate: '',
        ecuDiagnosticSession: '',
        ecuCodingId: '',
        ecuCvn: '',
        ecuBmwRoutine0205Raw: '',
        ecuBmwRoutine0205Software: '',
        ecuBmwControllerFamily: '',
        ecuBmwVariant: '',
        ecuBmwTransmission: '',
        ecuBmwEmissions: '',
        ecuBmwInternalToken: '',
        transportRequestId: BigInt.zero,
        transportRequestOperation: '',
        transportRequestAgeMs: BigInt.zero,
        transportRetryCount: 0,
        transportSocketState: 'simulator',
        transportRecoveryAction: 'none',
        transportRecoveryResult: 'not_required',
      );
    }
    // Keep simulator telemetry visually smooth while leaving the real ENET
    // polling cadence unchanged. The simulator endpoint is local and cheap;
    // 100 ms gives the monitor enough samples to animate RPM transitions.
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<List<DiagnosticTroubleCode>> scanSimulatorDiagnostics({
  String? host,
  int port = 8765,
}) async {
  final response = await _get(
    Uri.parse('http://${host ?? _defaultSimulatorHost}:$port/api/faults'),
  );
  final faults = response['faults'] as List<dynamic>? ?? const [];
  return faults.map((item) {
    final fault = item as Map<String, dynamic>;
    return DiagnosticTroubleCode(
      code: fault['code'] as String? ?? 'UNKNOWN',
      rawCode: (fault['raw_code'] as num?)?.toInt() ?? 0,
      status: (fault['status'] as num?)?.toInt() ?? 1,
      statusText: fault['status_text'] as String? ?? 'Stored',
      ecu: 'DME',
    );
  }).toList();
}

Future<String?> readSimulatorDmeUnlockStatus({
  String? host,
  int port = 8765,
}) async {
  try {
    final response = await _get(
      Uri.parse('http://${host ?? _defaultSimulatorHost}:$port/api/status'),
    );
    return parseSimulatorDmeUnlockStatus(response['dme_unlock_status']);
  } on Object {
    return null;
  }
}

String? parseSimulatorDmeUnlockStatus(Object? value) {
  const allowed = {'unknown', 'unlocked', 'locked', 'bench_unlock_required'};
  final status = value is String ? value.trim().toLowerCase() : null;
  return status != null && allowed.contains(status) ? status : null;
}

Future<void> clearSimulatorDiagnostics({String? host, int port = 8765}) async {
  if (port == 8765) {
    await _clearSimulatorHsfz(host: host, port: 6801);
    return;
  }
  final client = HttpClient();
  try {
    final request = await client.postUrl(
      Uri.parse(
        'http://${host ?? _defaultSimulatorHost}:$port/api/clear-codes',
      ),
    );
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({'confirmed': true}));
    final response = await request.close().timeout(const Duration(seconds: 3));
    await response.drain();
    if (response.statusCode != 200) {
      throw HttpException('Simulator returned HTTP ${response.statusCode}');
    }
  } finally {
    client.close(force: true);
  }
}

Future<void> _clearSimulatorHsfz({String? host, required int port}) async {
  final socket = await Socket.connect(
    host ?? _defaultSimulatorHost,
    port,
  ).timeout(const Duration(seconds: 3));
  try {
    socket.add(_hsfzFrame(1, 0xF4, 0xDF, const [0x14, 0xFF, 0xFF, 0xFF]));
    await socket.flush();
    var positive = false;
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (!positive && DateTime.now().isBefore(deadline)) {
      final frame = await _readHsfzFrame(socket);
      final type = (frame[0] << 8) | frame[1];
      if (type != 1 || frame[3] != 0xF4) continue;
      final uds = frame.sublist(4);
      if (uds.length == 1 && uds[0] == 0x54) positive = true;
      if (uds.length >= 3 &&
          uds[0] == 0x7F &&
          uds[1] == 0x14 &&
          uds[2] != 0x78) {
        throw StateError(
          'Simulator rejected clear-DTC request (NRC 0x${uds[2].toRadixString(16)})',
        );
      }
    }
    if (!positive) {
      throw StateError('Simulator did not confirm clear-DTC completion');
    }
  } finally {
    await socket.close();
  }
}

Uint8List _hsfzFrame(int type, int source, int target, List<int> uds) {
  final body = BytesBuilder()
    ..add([type >> 8, type & 0xFF, source, target])
    ..add(uds);
  final bytes = body.toBytes();
  return Uint8List.fromList([
    (bytes.length >> 24) & 0xFF,
    (bytes.length >> 16) & 0xFF,
    (bytes.length >> 8) & 0xFF,
    bytes.length & 0xFF,
    ...bytes,
  ]);
}

Future<Uint8List> _readHsfzFrame(Socket socket) async {
  final header = await _readExact(socket, 4);
  final length =
      (header[0] << 24) | (header[1] << 16) | (header[2] << 8) | header[3];
  return _readExact(socket, length);
}

Future<Uint8List> _readExact(Socket socket, int length) async {
  final bytes = <int>[];
  await for (final chunk in socket.timeout(const Duration(seconds: 3))) {
    bytes.addAll(chunk);
    if (bytes.length >= length) {
      return Uint8List.fromList(bytes.sublist(0, length));
    }
  }
  throw const SocketException('Simulator closed the HSFZ connection early');
}

String get _defaultSimulatorHost =>
    // USB-connected Android devices reach the PC through adb reverse. The
    // Android emulator reaches the host computer through 10.0.2.2.
    Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';

Future<Map<String, dynamic>> _get(Uri uri) async {
  final client = HttpClient();
  try {
    final request = await client
        .getUrl(uri)
        .timeout(const Duration(seconds: 3));
    final response = await request.close().timeout(const Duration(seconds: 3));
    if (response.statusCode != 200) {
      throw HttpException(
        'Simulator returned HTTP ${response.statusCode}',
        uri: uri,
      );
    }
    return jsonDecode(await response.transform(utf8.decoder).join())
        as Map<String, dynamic>;
  } finally {
    client.close(force: true);
  }
}
