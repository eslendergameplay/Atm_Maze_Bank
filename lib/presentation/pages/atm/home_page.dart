import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/widgets/widgets.dart';

/// Menú principal de operaciones del cajero de Maze Bank.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return MazeBankScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MazeBankSectionTitle(
                  title: 'Menú principal',
                  subtitle: 'Seleccione la operación que desea realizar.',
                ),
                const SizedBox(height: 20),

                FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  child: MazeBankOperationTile(
                    icon: Icons.savings_outlined,
                    title: 'Depósito',
                    subtitle: 'Ingrese dinero a su cuenta',
                    onTap: () => context.push('/newDeposit'),
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 400),
                  child: MazeBankOperationTile(
                    icon: Icons.swap_horiz,
                    title: 'Transferencia',
                    subtitle: 'Envíe fondos a otra cuenta',
                    onTap: () => context.push('/newTransaction'),
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 400),
                  child: MazeBankOperationTile(
                    icon: Icons.payments_outlined,
                    title: 'Retiro',
                    subtitle: 'Retire efectivo de su cuenta',
                    onTap: () => context.push('/NewWithdraw'),
                  ),
                ),

                const SizedBox(height: 28),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 400),
                  child: MazeBankButton(
                    text: 'Transaction Log',
                    icon: Icons.receipt_long_outlined,
                    variant: MazeBankButtonVariant.secondary,
                    onPressed: () => context.push('/checkLog'),
                  ),
                ),

                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  icon: Icon(
                    Icons.logout,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'CERRAR SESIÓN',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                Text(
                  'Maze Bank © Terminal de autoservicio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
