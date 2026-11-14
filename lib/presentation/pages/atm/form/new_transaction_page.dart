import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:atm_app/presentation/providers/atm/atm_provider.dart';
import 'package:atm_app/presentation/providers/atm/form/new_transaction_form_provider.dart';
import 'package:atm_app/presentation/widgets/widgets.dart';

/// Transferencia de fondos entre cuentas; la lógica vive en `AtmNotifier`.
class NewTransactionPage extends ConsumerStatefulWidget {
  const NewTransactionPage({super.key});

  @override
  ConsumerState<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends ConsumerState<NewTransactionPage> {
  final _amountController = TextEditingController();
  int _shakeKey = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final formNotifier = ref.read(newTransactionFormProvider.notifier);
    await formNotifier.onFormSubmit();
    if (!mounted) return;

    final form = ref.read(newTransactionFormProvider);
    if (!form.isValid || !form.hasDestination) {
      setState(() => _shakeKey++);
    }
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final form = ref.watch(newTransactionFormProvider);
    final formNotifier = ref.read(newTransactionFormProvider.notifier);
    final atmState = ref.watch(atmProvider);

    final balance = atmState.user?.balance ?? form.balance;
    final showMessage = form.isFormPosted && atmState.message.isNotEmpty;
    final isSuccess = atmState.message.contains('éxito');

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
                    title: 'Transferencia de fondos',
                    subtitle: 'Envíe dinero a otra cuenta de Maze Bank.',
                  ),
                ),
                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'SALDO ACTUAL',
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
                        '\$ ${MazeBankUserBar.formatMoney(balance)}',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                ShakeX(
                  key: ValueKey('transfer-shake-$_shakeKey'),
                  animate: _shakeKey > 0,
                  duration: const Duration(milliseconds: 450),
                  child: Column(
                    children: [
                      if (form.users.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: colorScheme.primary.withValues(
                                alpha: 0.20,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'No hay otras cuentas registradas para transferir.',
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.75,
                                    ),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        DropdownButtonFormField<String>(
                          initialValue: form.hasDestination
                              ? form.selectedUser.identification
                              : null,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Cuenta destino',
                            filled: true,
                            fillColor: colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 1.6,
                              ),
                            ),
                          ),
                          hint: const Text('Seleccione una cuenta'),
                          items: form.users
                              .map(
                                (user) => DropdownMenuItem<String>(
                                  value: user.identification,
                                  child: Text(
                                    '${user.name} · ${user.identification}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            formNotifier.onSelectedUserChanged(value);
                          },
                          validator: (value) => value == null
                              ? 'Debe seleccionar una cuenta destino'
                              : null,
                        ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        label: 'Monto a transferir',
                        hint: '0.00',
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: formNotifier.onAmountChanged,
                        errorMessage: form.amount.errorMessage,
                      ),
                    ],
                  ),
                ),

                if (showMessage) ...[
                  const SizedBox(height: 18),
                  MazeBankMessageBanner(
                    message: atmState.message,
                    isError: !isSuccess,
                  ),
                ],

                const SizedBox(height: 30),
                FadeInUp(
                  duration: const Duration(milliseconds: 350),
                  child: MazeBankButton(
                    text: 'Enviar fondos',
                    icon: Icons.send,
                    isLoading: form.isPosting,
                    onPressed: _onConfirm,
                  ),
                ),
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 120),
                  duration: const Duration(milliseconds: 350),
                  child: MazeBankButton(
                    text: 'Back',
                    icon: Icons.keyboard_return,
                    variant: MazeBankButtonVariant.secondary,
                    onPressed: _goBack,
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
