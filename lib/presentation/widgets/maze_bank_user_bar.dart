import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:atm_app/config/config.dart';
import 'package:atm_app/presentation/providers/atm/atm_provider.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';

/// Franja con nombre y saldo: prefiere `atmProvider` y cae a `authProvider`; solo lee.
class MazeBankUserBar extends ConsumerWidget {
  const MazeBankUserBar({super.key});

  static String formatMoney(double value) => value
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final AtmUser user =
        ref.watch(atmProvider).user ??
        ref.watch(authProvider).user ??
        const AtmUser();
    final balance = user.balance;
    final hasBalance = balance > 0;

    return FadeInDown(
      delay: const Duration(milliseconds: 150),
      duration: const Duration(milliseconds: 450),
      child: Container(
        width: double.infinity,
        color: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              child: ClipOval(
                child: Image.asset(
                  'assets/profile.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, color: Colors.white, size: 26),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'USUARIO',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'C.I. ${user.identification}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'ACCOUNT BALANCE',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '\$ ${formatMoney(balance)}',
                  style: TextStyle(
                    color: hasBalance ? Colors.white : Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
