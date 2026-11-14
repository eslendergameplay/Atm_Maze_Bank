import 'dart:async';

import 'package:atm_app/config/config.dart';
import 'package:atm_app/infraestructure/storage/theme_storage.dart';
import 'package:atm_app/presentation/providers/storage/theme_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme_provider.g.dart';

@riverpod
class AppThemeNotifier extends _$AppThemeNotifier {
  @override
  AppTheme build() {
    // Valor leído del disco en `main()`; sin preferencia se usa el tema claro.
    final bool? initialDark = ref.watch(initialDarkModeProvider);
    return AppTheme(isDark: initialDark ?? false);
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDark);

    final ThemeStorage storage = ref.read(themeStorageProvider);
    unawaited(storage.saveDarkMode(state.isDark).catchError((Object _) {}));
  }
}
