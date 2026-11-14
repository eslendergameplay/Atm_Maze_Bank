// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_withdraw_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewWithdrawForm)
final newWithdrawFormProvider = NewWithdrawFormProvider._();

final class NewWithdrawFormProvider
    extends $NotifierProvider<NewWithdrawForm, NewWithdrawFormState> {
  NewWithdrawFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newWithdrawFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newWithdrawFormHash();

  @$internal
  @override
  NewWithdrawForm create() => NewWithdrawForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewWithdrawFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewWithdrawFormState>(value),
    );
  }
}

String _$newWithdrawFormHash() => r'1d7467a2ea046ba070c49bc63ad3c24062599d83';

abstract class _$NewWithdrawForm extends $Notifier<NewWithdrawFormState> {
  NewWithdrawFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NewWithdrawFormState, NewWithdrawFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NewWithdrawFormState, NewWithdrawFormState>,
              NewWithdrawFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
