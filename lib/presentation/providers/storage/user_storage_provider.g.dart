// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Almacenamiento de cuentas; `main()` lo sobrescribe con lo leído del disco.

@ProviderFor(userStorage)
final userStorageProvider = UserStorageProvider._();

/// Almacenamiento de cuentas; `main()` lo sobrescribe con lo leído del disco.

final class UserStorageProvider
    extends $FunctionalProvider<UserStorage, UserStorage, UserStorage>
    with $Provider<UserStorage> {
  /// Almacenamiento de cuentas; `main()` lo sobrescribe con lo leído del disco.
  UserStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStorageHash();

  @$internal
  @override
  $ProviderElement<UserStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserStorage create(Ref ref) {
    return userStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserStorage>(value),
    );
  }
}

String _$userStorageHash() => r'398f11a1a78a93981396b61e17962b7a82f858a7';
