enum ProductEdition { core, tune }

/// Compile-time product configuration.
///
/// The default is Core so a missing build define cannot accidentally expose
/// the Tune workspace. Tune must be selected explicitly with:
/// `--dart-define=BIMMERSCOPE_EDITION=tune`
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
