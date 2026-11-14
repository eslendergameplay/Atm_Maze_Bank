import 'package:flutter/material.dart';

/// Fila del Transaction Log con efecto cebra usando los tokens de `AppTheme`.
class MazeBankTransactionRow extends StatelessWidget {
  final String description;
  final String? detail;
  final String amount;
  final String? date;
  final bool isEven;
  final bool isNegative;

  const MazeBankTransactionRow({
    super.key,
    required this.description,
    required this.amount,
    required this.isEven,
    this.detail,
    this.date,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final amountColor = isNegative
        ? colorScheme.primary
        : Colors.green.shade700;

    return Container(
      color: isEven
          ? colorScheme.tertiary
          : colorScheme.surface.withValues(alpha: 0.0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: amountColor.withValues(alpha: 0.12),
            ),
            child: Icon(
              isNegative ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18,
              color: amountColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (detail != null)
                  Text(
                    detail!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isNegative ? '- ' : '+ '}\$ $amount',
                style: TextStyle(
                  color: amountColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (date != null)
                Text(
                  date!,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
