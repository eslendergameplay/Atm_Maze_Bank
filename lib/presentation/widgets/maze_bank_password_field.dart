import 'package:flutter/material.dart';
import 'package:atm_app/presentation/widgets/custom_text_form_field.dart';

/// Campo de contraseña con botón para mostrar u ocultar el texto.
class MazeBankPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final Function(String)? onChanged;
  final void Function(String?)? onFieldSubmitted;

  const MazeBankPasswordField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<MazeBankPasswordField> createState() => _MazeBankPasswordFieldState();
}

class _MazeBankPasswordFieldState extends State<MazeBankPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: widget.label,
      hint: widget.hint,
      errorMessage: widget.errorMessage,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      suffixIcon: IconButton(
        tooltip: _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
        onPressed: _toggleVisibility,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        splashRadius: 20,
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.black38,
          size: 20,
        ),
      ),
    );
  }
}
