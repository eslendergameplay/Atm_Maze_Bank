import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

/// Cabecera superior con el logo de Maze Bank y una línea inferior del color primario.
class MazeBankHeader extends StatelessWidget {
  final bool showSubtitle;

  const MazeBankHeader({super.key, this.showSubtitle = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeInDown(
      duration: const Duration(milliseconds: 450),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            bottom: BorderSide(color: colorScheme.primary, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Column(
          children: [
            Image.asset(
              'assets/LogoCompleteBank.png',
              height: 56,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.account_balance,
                color: colorScheme.primary,
                size: 48,
              ),
            ),
            if (showSubtitle) ...[
              const SizedBox(height: 6),
              Text(
                'MAZE BANK',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
