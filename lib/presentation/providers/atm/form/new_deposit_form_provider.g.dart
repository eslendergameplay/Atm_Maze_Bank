// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_deposit_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewDepositForm)
final newDepositFormProvider = NewDepositFormProvider._();

final class NewDepositFormProvider
    extends $NotifierProvider<NewDepositForm, NewDepositFormState> {
  NewDepositFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newDepositFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newDepositFormHash();

  @$internal
  @override
  NewDepositForm create() => NewDepositForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewDepositFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewDepositFormState>(value),
    );
  }
}

String _$newDepositFormHash() => r'4ad4a6643503f6e6b6616883f3caa12a287e6e19';

abstract class _$NewDepositForm extends $Notifier<NewDepositFormState> {
  NewDepositFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NewDepositFormState, NewDepositFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NewDepositFormState, NewDepositFormState>,
              NewDepositFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
