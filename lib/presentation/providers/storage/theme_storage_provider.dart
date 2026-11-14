import 'package:atm_app/infraestructure/storage/theme_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_storage_provider.g.dart';

/// Almacenamiento del tema; `main()` lo sobrescribe con lo leído del disco.
@Riverpod(keepAlive: true)
ThemeStorage themeStorage(Ref ref) => SharedPrefsThemeStorage();

/// Tema leído antes de `runApp`; `null` = nunca se eligió (modo claro).
@Riverpod(keepAlive: true)
bool? initialDarkMode(Ref ref) => null;
