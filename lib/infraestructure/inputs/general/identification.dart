import 'package:formz/formz.dart';

enum IdentificationError { empty, format }

class Identification extends FormzInput<String, IdentificationError> {
  const Identification.pure() : super.pure('');
  const Identification.dirty([super.value = '']) : super.dirty();
  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == IdentificationError.empty) {
      return 'El Campo es Requerido';
    }
    if (displayError == IdentificationError.format) {
      return 'Minimo 8 carateres y maximo 20 carateres';
    }

    return null;
  }

  @override
  IdentificationError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return IdentificationError.empty;
    if (value.length < 8 || value.length > 20) {
      return IdentificationError.format;
    }
    return null;
  }
}
