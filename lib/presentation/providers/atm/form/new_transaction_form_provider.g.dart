// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_transaction_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewTransactionForm)
final newTransactionFormProvider = NewTransactionFormProvider._();

final class NewTransactionFormProvider
    extends $NotifierProvider<NewTransactionForm, NewTransactionFormState> {
  NewTransactionFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newTransactionFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newTransactionFormHash();

  @$internal
  @override
  NewTransactionForm create() => NewTransactionForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewTransactionFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewTransactionFormState>(value),
    );
  }
}

String _$newTransactionFormHash() =>
    r'c40f2b8745b36abea87c2fb16f065fff6b043b1d';

abstract class _$NewTransactionForm extends $Notifier<NewTransactionFormState> {
  NewTransactionFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<NewTransactionFormState, NewTransactionFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NewTransactionFormState, NewTransactionFormState>,
              NewTransactionFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
