import 'package:formz/formz.dart';

enum AmountError { empty, notNan, negative }

class Amount extends FormzInput<String, AmountError> {
  const Amount.pure() : super.pure('');
  const Amount.dirty([super.value = '']) : super.dirty();
  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == AmountError.empty) return 'Este campo es requerido';
    if (displayError == AmountError.notNan) return 'Debe ser un numero';
    if (displayError == AmountError.negative) return 'No puede ser negativo';

    return null;
  }

  @override
  AmountError? validator(String value) {
    if (value.isEmpty) return AmountError.empty;
    final parsedValue = double.tryParse(value.replaceAll(',', '.'));
    if (parsedValue == null) {
      return AmountError.notNan;
    }
    if (parsedValue.isNegative) {
      return AmountError.negative;
    }
    return null;
  }
}
