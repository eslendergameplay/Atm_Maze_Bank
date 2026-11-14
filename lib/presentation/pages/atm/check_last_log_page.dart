import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:atm_app/config/config.dart';
import 'package:atm_app/presentation/providers/atm/atm_provider.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/widgets/widgets.dart';

/// Transaction Log de Maze Bank: historial de `AtmState.logs`, el más reciente primero.
class CheckLastLogPage extends ConsumerWidget {
  const CheckLastLogPage({super.key});

  static String _formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Un movimiento resta saldo si es un retiro o una transferencia enviada por el usuario actual.
  static bool _isNegative(AtmLog log, AtmUser currentUser) {
    if (log.userToReceive == null) return true;
    if (log.originUser == null) return false;
    return log.originUser!.identification == currentUser.identification;
  }

  static String _description(AtmLog log, AtmUser currentUser) {
    if (log.userToReceive == null) return 'Retiro en efectivo';
    if (log.originUser == null) return 'Depósito en efectivo';

    final bool isReceived =
        log.userToReceive!.identification == currentUser.identification;
    return isReceived
        ? 'Transferencia de ${log.originUser!.name}'
        : 'Transferencia a ${log.userToReceive!.name}';
  }

  static String? _detail(AtmLog log) {
    if (log.originUser != null && log.userToReceive == null) {
      return 'Cajero Maze Bank';
    }
    return log.bankName ?? 'Sin banco';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final authUser = ref.watch(authProvider).user;
    final atmState = authUser == null ? null : ref.watch(atmProvider);
    final AtmUser currentUser = atmState?.user ?? authUser ?? const AtmUser();
    final List<AtmLog> logs = atmState?.logs ?? const [];
    final hasLogs = logs.isNotEmpty;

    return MazeBankScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInLeft(
                  duration: const Duration(milliseconds: 350),
                  child: const MazeBankSectionTitle(
                    title: 'Transaction Log',
                    subtitle: 'Movimientos registrados en su cuenta.',
                  ),
                ),
                const SizedBox(height: 18),

                // Tabla de movimientos
                FadeIn(
                  duration: const Duration(milliseconds: 450),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Encabezado de la tabla
                        Container(
                          color: colorScheme.surface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'DESCRIPCIÓN',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Text(
                                'MONTO',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: colorScheme.primary.withValues(alpha: 0.20),
                        ),

                        if (hasLogs)
                          for (var i = 0; i < logs.length; i++)
                            MazeBankTransactionRow(
                              description: _description(logs[i], currentUser),
                              detail: _detail(logs[i]),
                              amount: MazeBankUserBar.formatMoney(
                                logs[i].amount ?? 0,
                              ),
                              date: _formatDate(logs[i].date),
                              isEven: i.isEven,
                              isNegative: _isNegative(logs[i], currentUser),
                            )
                        else
                          _EmptyLog(colorScheme: colorScheme),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Saldo del usuario autenticado
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'SALDO DISPONIBLE',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$ ${MazeBankUserBar.formatMoney(currentUser.balance)}',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                FadeInUp(
                  duration: const Duration(milliseconds: 350),
                  child: MazeBankButton(
                    text: 'Back',
                    icon: Icons.keyboard_return,
                    variant: MazeBankButtonVariant.secondary,
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/home'),
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

class _EmptyLog extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyLog({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: colorScheme.primary.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 12),
              Text(
                'No hay transacciones registradas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sus movimientos aparecerán aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
