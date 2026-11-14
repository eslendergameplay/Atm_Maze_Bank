// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoRouterNotifier)
final goRouterProvider = GoRouterNotifierProvider._();

final class GoRouterNotifierProvider
    extends $NotifierProvider<GoRouterNotifier, AuthStatus> {
  GoRouterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterNotifierHash();

  @$internal
  @override
  GoRouterNotifier create() => GoRouterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStatus>(value),
    );
  }
}

String _$goRouterNotifierHash() => r'b091c25bf4dcbda9408bf6810361a4524ad7d248';

abstract class _$GoRouterNotifier extends $Notifier<AuthStatus> {
  AuthStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthStatus, AuthStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthStatus, AuthStatus>,
              AuthStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
