import 'package:atm_app/infraestructure/inputs/inputs.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_form.g.dart';

class LoginFormState {
  final Identification identification;
  final Password password;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;

  LoginFormState({
    this.identification = const Identification.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.isFormPosted = false,
    this.isPosting = false,
  });

  LoginFormState copyWith({
    Identification? identification,
    Password? password,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
  }) => LoginFormState(
    identification: identification ?? this.identification,
    password: password ?? this.password,
    isValid: isValid ?? this.isValid,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isPosting: isPosting ?? this.isPosting,
  );
}

@riverpod
class LoginForm extends _$LoginForm {
  @override
  LoginFormState build() {
    return LoginFormState();
  }

  void onIdentificationChanged(String value) {
    final newIdentification = Identification.dirty(value);
    state = state.copyWith(
      identification: newIdentification,
      isValid: Formz.validate([newIdentification, state.password]),
    );
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.identification]),
    );
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();
    state = state.copyWith(isPosting: true);
    if (!state.isValid) {
      state = state.copyWith(isPosting: false, isFormPosted: true);
    }
    try {
      await ref
          .read(authProvider.notifier)
          .login(state.identification.value, state.password.value);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isPosting: false);
      }
    }
  }

  void _touchEveryField() {
    final identification = Identification.dirty(state.identification.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      identification: identification,
      password: password,
      isValid: Formz.validate([identification, password]),
    );
  }
}
