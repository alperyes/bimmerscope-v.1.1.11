import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Calls the existing SK Python calculator on Android and Windows.
class SecurityResponseProvider {
  static const _channel = MethodChannel('bimmerscope/security_response');
  static const _seedChallenge = [0x27, 0x11, 0xFF, 0xFF, 0xFF, 0xFF];
  static const _windowsFiles = <String>[
    'basic_crypto.py',
    'crypto_main.py',
    'native_resource.py',
    'pdx_key.py',
    'sec_file_parser.py',
    'security.py',
    'security_impl.py',
    'seed_response.py',
    'sgbm_id.py',
    'image3.xml',
    'resources/image1.png',
    'resources/image2.png',
    'resources/key_reference.json',
  ];

  static Future<List<int>> calculate({
    required String currentBootloader,
    required List<int> seed,
  }) async {
    final sgbmId = _readSgbmId(currentBootloader);
    if (seed.length != 8) {
      throw const FormatException('The DME must return an eight-byte seed.');
    }
    final seedHex = _hex(seed);
    final responseHex = switch (Platform.operatingSystem) {
      'android' => await _calculateAndroid(sgbmId, seedHex),
      'windows' => await _calculateWindows(sgbmId, seedHex),
      _ => throw UnsupportedError(
        'SK Python seed calculation is configured for Android and Windows.',
      ),
    };
    final normalized = responseHex.trim().replaceAll(RegExp(r'\s+'), '');
    if (normalized.isEmpty ||
        normalized.length.isOdd ||
        !RegExp(r'^[0-9A-Fa-f]+$').hasMatch(normalized)) {
      throw const FormatException(
        'SK Python returned an invalid key response.',
      );
    }
    return [
      for (var index = 0; index < normalized.length; index += 2)
        int.parse(normalized.substring(index, index + 2), radix: 16),
    ];
  }

  static Future<List<int>?> calculateForChallenge({
    required int target,
    required List<int> request,
    required List<int> response,
    required String currentBootloader,
  }) async {
    if (target != 0x12 ||
        !listEquals(request, _seedChallenge) ||
        response.length < 2 ||
        response[0] != 0x67 ||
        response[1] != 0x11) {
      return null;
    }
    if (response.length != 10) {
      throw FormatException(
        'The DME returned a seed with ${response.length - 2} bytes; '
        'SK Python integration requires exactly eight.',
      );
    }
    return calculate(
      currentBootloader: currentBootloader,
      seed: response.sublist(2),
    );
  }

  static Future<String> _calculateAndroid(String btld, String seed) async {
    final response = await _channel.invokeMethod<String>('calculate', {
      'btld': btld,
      'seed': seed,
    });
    if (response == null) {
      throw StateError('The Android SK Python bridge returned no response.');
    }
    return response;
  }

  static Future<String> _calculateWindows(String btld, String seed) async {
    final support = await getApplicationSupportDirectory();
    final root = Directory('${support.path}${Platform.pathSeparator}sk_python');
    await root.create(recursive: true);
    for (final relative in _windowsFiles) {
      final assetPath = 'SK Python/$relative';
      final target = File(
        '${root.path}${Platform.pathSeparator}${relative.replaceAll('/', Platform.pathSeparator)}',
      );
      await target.parent.create(recursive: true);
      final data = await rootBundle.load(assetPath);
      await target.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }

    final script = '${root.path}${Platform.pathSeparator}seed_response.py';
    ProcessResult result;
    try {
      result = await Process.run('py', [
        '-3',
        script,
        btld,
        seed,
      ], workingDirectory: root.path);
    } on ProcessException {
      result = await Process.run('python', [
        script,
        btld,
        seed,
      ], workingDirectory: root.path);
    }
    if (result.exitCode != 0) {
      final detail = result.stderr.toString().trim();
      throw StateError(
        detail.isEmpty
            ? 'SK Python exited with code ${result.exitCode}.'
            : detail,
      );
    }
    return result.stdout.toString();
  }

  static String _readSgbmId(String value) {
    final normalized = value.trim().replaceFirst(
      RegExp(r'^BTLD\s*', caseSensitive: false),
      '',
    );
    final compact = normalized.replaceAll('/', '');
    final match = RegExp(
      r'^([0-9A-Fa-f]{8})(?:[0-9A-Fa-f]{6}|[0-9A-Fa-f]{9})?$',
    ).firstMatch(compact);
    if (match == null) {
      throw const FormatException(
        'Current DME bootloader ID is unavailable or has an unsupported format.',
      );
    }
    return match.group(1)!.toUpperCase();
  }

  static String _hex(List<int> bytes) => bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join()
      .toUpperCase();
}
