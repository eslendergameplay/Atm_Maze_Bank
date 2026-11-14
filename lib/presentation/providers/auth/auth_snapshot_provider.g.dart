// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_snapshot_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `main()` lo sobrescribe con lo que devolvió `UserStorage`.

@ProviderFor(authSnapshot)
final authSnapshotProvider = AuthSnapshotProvider._();

/// `main()` lo sobrescribe con lo que devolvió `UserStorage`.

final class AuthSnapshotProvider
    extends $FunctionalProvider<AuthSnapshot, AuthSnapshot, AuthSnapshot>
    with $Provider<AuthSnapshot> {
  /// `main()` lo sobrescribe con lo que devolvió `UserStorage`.
  AuthSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSnapshotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSnapshotHash();

  @$internal
  @override
  $ProviderElement<AuthSnapshot> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthSnapshot create(Ref ref) {
    return authSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSnapshot>(value),
    );
  }
}

String _$authSnapshotHash() => r'c8f59da4dc28c9a10c43efb993d4a649229c4e36';
