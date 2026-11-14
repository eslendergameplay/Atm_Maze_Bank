import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atm_app/presentation/providers/theme/app_theme_provider.dart';

/// Alterna el modo claro/oscuro usando el `AppThemeNotifier` existente.
class MazeBankThemeToggle extends ConsumerWidget {
  const MazeBankThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(appThemeProvider).isDark;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(40),
      child: IconButton(
        tooltip: isDark ? 'Modo claro' : 'Modo oscuro',
        onPressed: () => ref.read(appThemeProvider.notifier).toggleDarkMode(),
        icon: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
