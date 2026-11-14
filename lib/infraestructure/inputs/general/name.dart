import 'package:formz/formz.dart';

enum NameError { empty, length }

class Name extends FormzInput<String, NameError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();
  String? get errorMessage {
    if (displayError == NameError.empty) return 'El Campo es Requerido';
    if (displayError == NameError.length) return 'Minimo 2 carateres';
    return null;
  }

  @override
  NameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NameError.empty;
    if (value.length < 2) return NameError.length;
    return null;
  }
}
