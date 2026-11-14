import 'package:shared_preferences/shared_preferences.dart';

const String _darkModeKey = 'maze_bank.theme.v1';

/// Contrato de persistencia del tema (implementación en memoria para pruebas).
abstract class ThemeStorage {
  /// Tema guardado, o `null` si el usuario nunca cambió el tema.
  Future<bool?> loadDarkMode();

  Future<void> saveDarkMode(bool isDark);
}

/// Persistencia local del tema con `shared_preferences`.
class SharedPrefsThemeStorage implements ThemeStorage {
  final SharedPreferencesAsync _prefs;

  SharedPrefsThemeStorage([SharedPreferencesAsync? prefs])
    : _prefs = prefs ?? SharedPreferencesAsync();

  @override
  Future<bool?> loadDarkMode() => _prefs.getBool(_darkModeKey);

  @override
  Future<void> saveDarkMode(bool isDark) =>
      _prefs.setBool(_darkModeKey, isDark);
}
