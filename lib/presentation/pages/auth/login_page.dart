import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:atm_app/presentation/providers/auth/auth_provider.dart';
import 'package:atm_app/presentation/providers/auth/form/login_form.dart';
import 'package:atm_app/presentation/widgets/widgets.dart';

/// Pantalla de acceso; la autenticación y la redirección las resuelve la lógica existente.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final form = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);
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
                title: 'Acceso a su cuenta',
                subtitle: 'Identifíquese para operar en el cajero.',
              ),
            ),
            const SizedBox(height: 20),

            if (authState.message.isNotEmpty) ...[
              MazeBankMessageBanner(message: authState.message),
              const SizedBox(height: 20),
            ],

            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: CustomTextFormField(
                label: 'Identificación',
                hint: 'Ej: 12345678',
                onChanged: formNotifier.onIdentificationChanged,
                errorMessage: form.identification.errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 400),
              child: MazeBankPasswordField(
                label: 'Contraseña',
                hint: '••••••••••••',
                onChanged: formNotifier.onPasswordChanged,
                errorMessage: form.password.errorMessage,
                onFieldSubmitted: (_) => formNotifier.onFormSubmit(),
              ),
            ),

            const SizedBox(height: 28),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 400),
              child: MazeBankButton(
                text: 'Ingresar',
                icon: Icons.login,
                isLoading: form.isPosting,
                onPressed: formNotifier.onFormSubmit,
              ),
            ),
            const SizedBox(height: 12),

            TextButton(
              onPressed: () => context.push('/register'),
              child: Text(
                '¿No tiene cuenta? Regístrese aquí',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
