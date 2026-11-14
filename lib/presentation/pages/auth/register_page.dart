import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/providers/auth/form/register_form.dart';
import 'package:atm_app/presentation/widgets/widgets.dart';

/// Registro de nuevos clientes; usa `RegisterForm` y no modifica reglas de negocio.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  int _shakeKey = 0;

  void _onSubmit() {
    final form = ref.read(registerFormProvider);
    if (!form.isValid) {
      setState(() => _shakeKey++);
    }
    // Se envía aunque sea inválido para que `_touchEveryField` muestre todos los errores.
    ref.read(registerFormProvider.notifier).onFormSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final form = ref.watch(registerFormProvider);
    final formNotifier = ref.read(registerFormProvider.notifier);
    final authState = ref.watch(authProvider);

    return MazeBankScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: MazeBankThemeToggle(),
            ),
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: const MazeBankSectionTitle(
                title: 'Apertura de cuenta',
                subtitle: 'Complete sus datos para operar en Maze Bank.',
              ),
            ),
            const SizedBox(height: 20),

            if (authState.message.isNotEmpty) ...[
              MazeBankMessageBanner(message: authState.message),
              const SizedBox(height: 20),
            ],

            ShakeX(
              key: ValueKey('register-shake-$_shakeKey'),
              animate: _shakeKey > 0,
              duration: const Duration(milliseconds: 450),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    label: 'Nombre completo',
                    hint: 'Ej: Michael De Santa',
                    onChanged: formNotifier.onNameChanged,
                    errorMessage: form.name.errorMessage,
                  ),
                  const SizedBox(height: 14),
                  CustomTextFormField(
                    label: 'Identificación',
                    hint: 'Ej: 12345678',
                    onChanged: formNotifier.onIdentificationChanged,
                    errorMessage: form.identification.errorMessage,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          label: 'Edad',
                          hint: '18',
                          keyboardType: TextInputType.number,
                          onChanged: formNotifier.onAgeChanged,
                          errorMessage: form.age.errorMessage,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextFormField(
                          label: 'Saldo inicial',
                          hint: '0.00',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: formNotifier.onAmountChanged,
                          errorMessage: form.balance.errorMessage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  MazeBankPasswordField(
                    label: 'Contraseña',
                    hint: '••••••••••••',
                    onChanged: formNotifier.onPasswordChanged,
                    errorMessage: form.password.errorMessage,
                  ),
                  const SizedBox(height: 14),
                  MazeBankPasswordField(
                    label: 'Repetir contraseña',
                    hint: '••••••••••••',
                    onChanged: formNotifier.onPasswordRepeatedChanged,
                    errorMessage: form.passwordRepeated.errorMessage,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Selección de bancos afiliados.
            Text(
              'BANCOS AFILIADOS',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seleccione uno o varios bancos para vincular su cuenta.',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              constraints: const BoxConstraints(maxHeight: 168),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.18),
                ),
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < form.allBanks.length; i++)
                      Builder(
                        builder: (context) {
                          final bankName = form.allBanks[i].name;
                          final isSelected = form.selectedBanks.any(
                            (bank) => bank.name == bankName,
                          );
                          return ChoiceChip(
                            label: Text(bankName),
                            selected: isSelected,
                            onSelected: (value) {
                              if (!value || isSelected) return;
                              formNotifier.onSelectedBanksChanged(i);
                            },
                            selectedColor: colorScheme.primary,
                            backgroundColor: colorScheme.surface,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : colorScheme.onSurface,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(
                              color: colorScheme.primary.withValues(
                                alpha: isSelected ? 1 : 0.30,
                              ),
                            ),
                            showCheckmark: true,
                            checkmarkColor: Colors.white,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${form.selectedBanks.length} banco(s) seleccionado(s)',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.55),
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 28),
            MazeBankButton(
              text: 'Crear cuenta',
              icon: Icons.person_add_alt_1,
              isLoading: form.isPosting,
              onPressed: _onSubmit,
            ),
            const SizedBox(height: 12),
            MazeBankButton(
              text: 'Back',
              icon: Icons.keyboard_return,
              variant: MazeBankButtonVariant.secondary,
              onPressed: () => context.pop(),
            ),
            const SizedBox(height: 14),
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
    );
  }
}
