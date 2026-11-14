import 'package:atm_app/infraestructure/storage/theme_storage.dart';

/// Implementación en memoria de [ThemeStorage] para pruebas, sin plugins.
class InMemoryThemeStorage implements ThemeStorage {
  bool? isDark;

  InMemoryThemeStorage({this.isDark});

  @override
  Future<bool?> loadDarkMode() async => isDark;

  @override
  Future<void> saveDarkMode(bool isDark) async {
    this.isDark = isDark;
  }
}
