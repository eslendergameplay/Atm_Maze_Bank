// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AuthClass> {
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthClass value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthClass>(value),
    );
  }
}

String _$authNotifierHash() => r'61b18914809175d6f0463484a117f7a624c046d1';

abstract class _$AuthNotifier extends $Notifier<AuthClass> {
  AuthClass build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthClass, AuthClass>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthClass, AuthClass>,
              AuthClass,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
