import 'package:flutter/material.dart';

/// Variante del botón: [primary] acción principal y [secondary] navegación.
enum MazeBankButtonVariant { primary, secondary }

/// Botón rectangular de Maze Bank; solo recibe [onPressed] y usa los tokens del tema.
class MazeBankButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final MazeBankButtonVariant variant;
  final bool isLoading;
  final bool expand;

  const MazeBankButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.variant = MazeBankButtonVariant.primary,
    this.isLoading = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isPrimary = variant == MazeBankButtonVariant.primary;

    final backgroundColor = isPrimary
        ? colorScheme.primary
        : colorScheme.secondary;

    // El celeste necesita texto oscuro para mantener contraste legible.
    final foregroundColor = isPrimary
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF101010)
              : colorScheme.onSurface);

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.45),
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.7),
        elevation: 0,
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    text.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
