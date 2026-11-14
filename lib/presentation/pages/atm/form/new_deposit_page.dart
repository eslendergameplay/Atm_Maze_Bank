import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:atm_app/presentation/providers/atm/atm_provider.dart';
import 'package:atm_app/presentation/providers/atm/form/new_deposit_form_provider.dart';
import 'package:atm_app/presentation/widgets/widgets.dart';

class NewDepositPage extends ConsumerStatefulWidget {
  const NewDepositPage({super.key});

  @override
  ConsumerState<NewDepositPage> createState() => _NewDepositPageState();
}

class _NewDepositPageState extends ConsumerState<NewDepositPage> {
  final _amountController = TextEditingController();
  int _shakeKey = 0;

  static const _quickAmounts = <String>['10', '20', '50', '100', '200'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(String value) {
    _amountController.text = value;
    ref.read(newDepositFormProvider.notifier).onAmountChanged(value);
  }

  Future<void> _onConfirm() async {
    final formNotifier = ref.read(newDepositFormProvider.notifier);
    await formNotifier.onFormSubmit();
    if (!mounted) return;

    if (!ref.read(newDepositFormProvider).isValid) {
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
    final form = ref.watch(newDepositFormProvider);
    final formNotifier = ref.read(newDepositFormProvider.notifier);
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
                    title: 'Depósito de fondos',
                    subtitle: 'Ingrese el monto que desea abonar a su cuenta.',
                  ),
                ),
                const SizedBox(height: 18),

                _BalancePanel(balance: balance, colorScheme: colorScheme),
                const SizedBox(height: 20),

                ShakeX(
                  key: ValueKey('deposit-shake-$_shakeKey'),
                  animate: _shakeKey > 0,
                  duration: const Duration(milliseconds: 450),
                  child: CustomTextFormField(
                    label: 'Monto a depositar',
                    hint: '0.00',
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: formNotifier.onAmountChanged,
                    errorMessage: form.amount.errorMessage,
                  ),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickAmounts
                      .map(
                        (value) => ActionChip(
                          label: Text('\$ $value'),
                          onPressed: () => _setAmount(value),
                          backgroundColor: colorScheme.surface,
                          side: BorderSide(
                            color: colorScheme.primary.withValues(alpha: 0.25),
                          ),
                          labelStyle: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                      .toList(),
                ),

                if (showMessage) ...[
                  const SizedBox(height: 18),
                  MazeBankMessageBanner(
                    message: atmState.message,
                    isError: !isSuccess,
                  ),
                ],

                const SizedBox(height: 28),
                FadeInUp(
                  duration: const Duration(milliseconds: 350),
                  child: MazeBankButton(
                    text: 'Confirmar depósito',
                    icon: Icons.check_circle_outline,
                    isLoading: form.isPosting,
                    onPressed: _onConfirm,
                  ),
                ),
                const SizedBox(height: 12),
                MazeBankButton(
                  text: 'Back',
                  icon: Icons.keyboard_return,
                  variant: MazeBankButtonVariant.secondary,
                  onPressed: _goBack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalancePanel extends StatelessWidget {
  final double balance;
  final ColorScheme colorScheme;

  const _BalancePanel({required this.balance, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'SALDO ACTUAL',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.65),
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
    );
  }
}
