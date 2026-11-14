import 'package:formz/formz.dart';

enum AgeError { empty, notNan, negative, ageError }

class Age extends FormzInput<String, AgeError> {
  const Age.pure() : super.pure('');
  const Age.dirty([super.value = '']) : super.dirty();
  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == AgeError.empty) return 'Este campo es requerido';
    if (displayError == AgeError.notNan) return 'Debe ser un numero';
    if (displayError == AgeError.negative) return 'No puede ser negativo';
    if (displayError == AgeError.ageError) {
      return 'Usted debe tener 18 años de edad como minimo';
    }
    return null;
  }

  @override
  AgeError? validator(String value) {
    if (value.isEmpty) return AgeError.empty;
    final parsedValue = double.tryParse(value.replaceAll(',', '.'));
    if (parsedValue == null) {
      return AgeError.notNan;
    }
    if (parsedValue.isNegative) {
      return AgeError.negative;
    }
    if (parsedValue < 18) return AgeError.ageError;
    return null;
  }
}
