import 'package:atm_app/config/config.dart';
import 'package:atm_app/infraestructure/storage/theme_storage.dart';
import 'package:atm_app/infraestructure/storage/user_storage.dart';
import 'package:atm_app/presentation/providers/auth/auth_snapshot_provider.dart';
import 'package:atm_app/presentation/providers/storage/theme_storage_provider.dart';
import 'package:atm_app/presentation/providers/storage/user_storage_provider.dart';
import 'package:atm_app/presentation/providers/theme/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPrefsUserStorage storage = SharedPrefsUserStorage();
  final SharedPrefsThemeStorage themeStorage = SharedPrefsThemeStorage();
  List<AtmUser> users = const [];
  String? sessionId;
  bool? isDark;

  try {
    users = await storage.loadUsers();
    sessionId = await storage.loadSessionId();
  } catch (_) {
    // Si el almacenamiento no está disponible se arranca sin cuentas guardadas.
  }

  try {
    isDark = await themeStorage.loadDarkMode();
  } catch (_) {
    // Sin preferencia de tema se arranca en modo claro.
  }

  runApp(
    ProviderScope(
      overrides: [
        userStorageProvider.overrideWithValue(storage),
        authSnapshotProvider.overrideWithValue(
          AuthSnapshot(users: users, sessionId: sessionId),
        ),
        themeStorageProvider.overrideWithValue(themeStorage),
        initialDarkModeProvider.overrideWithValue(isDark),
      ],
      child: const AtmApp(),
    ),
  );
}

class AtmApp extends ConsumerWidget {
  const AtmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);
    final isDark = ref.watch(appThemeProvider).isDark;

    return MaterialApp.router(
      title: 'ATM_APP',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: AppTheme(isDark: isDark).getTheme(),
    );
  }
}
