// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AtmNotifier)
final atmProvider = AtmNotifierProvider._();

final class AtmNotifierProvider
    extends $NotifierProvider<AtmNotifier, AtmState> {
  AtmNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'atmProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$atmNotifierHash();

  @$internal
  @override
  AtmNotifier create() => AtmNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AtmState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AtmState>(value),
    );
  }
}

String _$atmNotifierHash() => r'aae812b144d9066d4565cb1035d80522ad9f5ae4';

abstract class _$AtmNotifier extends $Notifier<AtmState> {
  AtmState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AtmState, AtmState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AtmState, AtmState>,
              AtmState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
