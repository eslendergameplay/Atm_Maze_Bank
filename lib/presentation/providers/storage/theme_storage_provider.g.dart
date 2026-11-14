// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Almacenamiento del tema; `main()` lo sobrescribe con lo leído del disco.

@ProviderFor(themeStorage)
final themeStorageProvider = ThemeStorageProvider._();

/// Almacenamiento del tema; `main()` lo sobrescribe con lo leído del disco.

final class ThemeStorageProvider
    extends $FunctionalProvider<ThemeStorage, ThemeStorage, ThemeStorage>
    with $Provider<ThemeStorage> {
  /// Almacenamiento del tema; `main()` lo sobrescribe con lo leído del disco.
  ThemeStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeStorageHash();

  @$internal
  @override
  $ProviderElement<ThemeStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeStorage create(Ref ref) {
    return themeStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeStorage>(value),
    );
  }
}

String _$themeStorageHash() => r'cd45ec9fb2164e20e79fc9568e0017cbf5e5c230';

/// Tema leído antes de `runApp`; `null` = nunca se eligió (modo claro).

@ProviderFor(initialDarkMode)
final initialDarkModeProvider = InitialDarkModeProvider._();

/// Tema leído antes de `runApp`; `null` = nunca se eligió (modo claro).

final class InitialDarkModeProvider
    extends $FunctionalProvider<bool?, bool?, bool?>
    with $Provider<bool?> {
  /// Tema leído antes de `runApp`; `null` = nunca se eligió (modo claro).
  InitialDarkModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialDarkModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialDarkModeHash();

  @$internal
  @override
  $ProviderElement<bool?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool? create(Ref ref) {
    return initialDarkMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool?>(value),
    );
  }
}

String _$initialDarkModeHash() => r'b46ef3c2bdba1e1fab46af8f6df5d1cd1d73e84a';
