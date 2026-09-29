abstract final class BuildInfo {
  static const version = String.fromEnvironment(
    'BIMMERSCOPE_VERSION',
    // Match pubspec.yaml when a local build omits the version define.
    // Release automation may still override this with an explicit value.
    defaultValue: '1.1.9-experimental.1+74',
  );
  static const date = String.fromEnvironment(
    'BIMMERSCOPE_BUILD_DATE',
    defaultValue: '2026-09-13',
  );
  static const time = String.fromEnvironment(
    'BIMMERSCOPE_BUILD_TIME',
    defaultValue: 'development build',
  );
}
