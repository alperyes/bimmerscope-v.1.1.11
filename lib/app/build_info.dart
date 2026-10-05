import 'package:package_info_plus/package_info_plus.dart';

abstract final class BuildInfo {
  static const _buildVersion = String.fromEnvironment(
    'BIMMERSCOPE_VERSION',
    defaultValue: 'Version unavailable',
  );
  static final Future<String> version = _installedVersion();

  static Future<String> _installedVersion() async {
    try {
      final package = await PackageInfo.fromPlatform();
      return '${package.version}+${package.buildNumber}';
    } catch (_) {
      return _buildVersion;
    }
  }
  static const date = String.fromEnvironment(
    'BIMMERSCOPE_BUILD_DATE',
    defaultValue: '2026-09-13',
  );
  static const time = String.fromEnvironment(
    'BIMMERSCOPE_BUILD_TIME',
    defaultValue: 'development build',
  );
}
