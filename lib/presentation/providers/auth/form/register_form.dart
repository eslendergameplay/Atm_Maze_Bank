import 'package:atm_app/config/config.dart';
import 'package:atm_app/infraestructure/inputs/inputs.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_form.g.dart';

class RegisterFormState {
  final Identification identification;
  final Password password;
  final PasswordR passwordRepeated;
  final Name name;
  final Age age;
  final Amount balance;
  final List<Bank> allBanks;
  final List<Bank> selectedBanks;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;

  RegisterFormState({
    this.identification = const Identification.pure(),
    this.password = const Password.pure(),
    this.passwordRepeated = const PasswordR.pure(),
    this.name = const Name.pure(),
    this.age = const Age.pure(),
    this.balance = const Amount.pure(),
    this.allBanks = const [],
    this.selectedBanks = const [],
    this.isValid = false,
    this.isFormPosted = false,
    this.isPosting = false,
  });

  RegisterFormState copyWith({
    Identification? identification,
    Password? password,
    PasswordR? passwordRepeated,
    Name? name,
    Age? age,
    Amount? balance,
    List<Bank>? allBanks,
    List<Bank>? selectedBanks,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
  }) => RegisterFormState(
    identification: identification ?? this.identification,
    password: password ?? this.password,
    passwordRepeated: passwordRepeated ?? this.passwordRepeated,
    name: name ?? this.name,
    age: age ?? this.age,
    balance: balance ?? this.balance,
    allBanks: allBanks ?? this.allBanks,
    selectedBanks: selectedBanks ?? this.selectedBanks,
    isValid: isValid ?? this.isValid,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isPosting: isPosting ?? this.isPosting,
  );
}

@riverpod
class RegisterForm extends _$RegisterForm {
  @override
  RegisterFormState build() {
    final allBanks = getAllBanks();

    return RegisterFormState(allBanks: allBanks);
  }

  void onIdentificationChanged(String value) {
    final newIdentification = Identification.dirty(value);
    state = state.copyWith(
      identification: newIdentification,
      isValid: Formz.validate([
        newIdentification,
        state.password,
        state.passwordRepeated,
        state.age,
        state.balance,
        state.name,
      ]),
    );
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    final newPasswordRepeated = PasswordR.dirty(
      state.passwordRepeated.value,
      newPassword.value,
    );
    state = state.copyWith(
      password: newPassword,
      passwordRepeated: newPasswordRepeated,
      isValid: Formz.validate([
        newPassword,
        newPasswordRepeated,
        state.identification,
        state.name,
        state.age,
        state.balance,
      ]),
    );
  }

  void onPasswordRepeatedChanged(String value) {
    final newPasswordRepeated = PasswordR.dirty(value, state.password.value);
    state = state.copyWith(
      passwordRepeated: newPasswordRepeated,
      isValid: Formz.validate([
        newPasswordRepeated,
        state.password,
        state.identification,
        state.name,
        state.age,
        state.balance,
      ]),
    );
  }

  void onNameChanged(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([
        newName,
        state.identification,
        state.password,
        state.age,
        state.balance,
        state.passwordRepeated,
      ]),
    );
  }

  void onAgeChanged(String value) {
    final newAge = Age.dirty(value);
    state = state.copyWith(
      age: newAge,
      isValid: Formz.validate([
        newAge,
        state.name,
        state.identification,
        state.password,
        state.balance,
        state.passwordRepeated,
      ]),
    );
  }

  void onAmountChanged(String value) {
    final newAmount = Amount.dirty(value);
    state = state.copyWith(
      balance: newAmount,
      isValid: Formz.validate([
        newAmount,
        state.name,
        state.identification,
        state.password,
        state.age,
        state.passwordRepeated,
      ]),
    );
  }

  void onSelectedBanksChanged(int index) {
    if (index < 0) return;
    final newBank = state.allBanks[index];
    state = state.copyWith(selectedBanks: [...state.selectedBanks, newBank]);
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();
    // Si el formulario es inválido solo se muestran los errores (registrar fallaría al parsear).
    if (!state.isValid) {
      state = state.copyWith(isPosting: false, isFormPosted: true);
      return;
    }

    state = state.copyWith(isPosting: true);
    try {
      final AtmUser newUser = AtmUser.withPassword(
        name: state.name.value,
        identification: state.identification.value,
        plainPassword: state.password.value,
        age: int.parse(state.age.value),
        balance: double.parse(state.balance.value),
        banks: state.selectedBanks,
        lastLog: AtmLog(),
      );

      await ref
          .read(authProvider.notifier)
          .register(newUser, state.password.value);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isPosting: false);
      }
    }
  }

  void _touchEveryField() {
    final identification = Identification.dirty(state.identification.value);
    final password = Password.dirty(state.password.value);
    final passwordRepeated = PasswordR.dirty(
      state.passwordRepeated.value,
      password.value,
    );
    final name = Name.dirty(state.name.value);
    final age = Age.dirty(state.age.value);
    final balance = Amount.dirty(state.balance.value);
    state = state.copyWith(
      identification: identification,
      password: password,
      passwordRepeated: passwordRepeated,
      name: name,
      age: age,
      balance: balance,
      isValid: Formz.validate([
        identification,
        password,
        passwordRepeated,
        name,
        age,
        balance,
      ]),
    );
  }
}
