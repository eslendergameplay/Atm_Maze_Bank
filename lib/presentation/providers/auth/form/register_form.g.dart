// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterForm)
final registerFormProvider = RegisterFormProvider._();

final class RegisterFormProvider
    extends $NotifierProvider<RegisterForm, RegisterFormState> {
  RegisterFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerFormHash();

  @$internal
  @override
  RegisterForm create() => RegisterForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterFormState>(value),
    );
  }
}

String _$registerFormHash() => r'6b7f52693bd319becbb003bd697f63aac11e0256';

abstract class _$RegisterForm extends $Notifier<RegisterFormState> {
  RegisterFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RegisterFormState, RegisterFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RegisterFormState, RegisterFormState>,
              RegisterFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
