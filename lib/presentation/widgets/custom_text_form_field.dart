import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextFormField extends ConsumerWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onFieldSubmitted;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.onTap,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    const borderRadius = Radius.circular(15);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: borderRadius,
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        controller: controller,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 20, color: colors.onSurface),
        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(
            color: colors.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorMaxLines: 3,
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          hintStyle: TextStyle(
            color: colors.onSurface.withValues(alpha: 0.5),
            fontSize: 18,
          ),
          suffixIcon: suffixIcon,
          errorText: errorMessage,
          focusColor: colors.primary,
        ),
      ),
    );
  }
}
