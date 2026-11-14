import 'package:flutter/material.dart';

/// Título de sección con barra de acento roja al estilo de Maze Bank.
class MazeBankSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const MazeBankSectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 5,
              height: 22,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}
