enum ProductEdition { core, tune }

/// Compile-time product configuration.
///
/// The default is Core so a missing build define cannot accidentally expose
/// the Tune workspace. Android's Tune flavor adds the Tune define in Gradle;
/// other build targets must pass `--dart-define=BIMMERSCOPE_EDITION=tune`.
class ProductConfig {
  const ProductConfig._();

  static const editionName = String.fromEnvironment(
    'BIMMERSCOPE_EDITION',
    defaultValue: 'core',
  );

  static const edition = editionName == 'core'
      ? ProductEdition.core
      : ProductEdition.tune;

  static const tuningEnabled = edition == ProductEdition.tune;
}
