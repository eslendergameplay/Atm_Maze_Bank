import 'package:formz/formz.dart';

enum PasswordError { empty, length, format }

class Password extends FormzInput<String, PasswordError> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PasswordError.empty) return 'El Campo es requerido';
    if (displayError == PasswordError.length) {
      return 'Minimo 12 caracteres y hasta 100 Caracteres';
    }
    if (displayError == PasswordError.format) {
      return 'Debe de tener una letra Mayuscula,una minuscula y un numero como minimo';
    }

    return null;
  }

  @override
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.length < 12 || value.length > 100) return PasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return PasswordError.format;
    return null;
  }
}
