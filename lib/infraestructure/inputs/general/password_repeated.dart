import 'package:formz/formz.dart';

enum PasswordRepeatedError { empty, length, format, notRepeated }

class PasswordR extends FormzInput<String, PasswordRepeatedError> {
  final String? firstPassword;

  static final RegExp passwordRepeatedRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  const PasswordR.pure({this.firstPassword = ''}) : super.pure('');

  const PasswordR.dirty([super.value = '', this.firstPassword = ''])
    : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PasswordRepeatedError.empty) {
      return 'El Campo es requerido';
    }
    if (displayError == PasswordRepeatedError.length) {
      return 'Minimo 12 Caracteres y hasta 100 Caracteres';
    }
    if (displayError == PasswordRepeatedError.format) {
      return '1 letra Mayuscula,minuscula y un numero minimo.';
    }
    if (displayError == PasswordRepeatedError.notRepeated) {
      return 'Las contraseñas deben ser iguales';
    }
    return null;
  }

  @override
  PasswordRepeatedError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return PasswordRepeatedError.empty;
    }
    if (value.length < 12 || value.length > 100) {
      return PasswordRepeatedError.length;
    }
    if (!passwordRepeatedRegExp.hasMatch(value)) {
      return PasswordRepeatedError.format;
    }
    if (value != firstPassword) {
      return PasswordRepeatedError.notRepeated;
    }
    return null;
  }
}
