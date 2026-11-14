import 'package:flutter/material.dart';

class AppTheme {
  final bool isDark;

  const AppTheme({this.isDark = false});

  ThemeData getTheme() {
    if (isDark) {
      return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141414),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFC82328), // Rojo icónico de Maze Bank
          secondary: const Color(
            0xFF5BC2E7,
          ), // Celeste del botón "Back" / acciones
          tertiary: const Color(
            0xFF4A2527,
          ), // Tono rojizo oscuro para filas/listas
          surface: const Color(0xFF1F1F1F), // Tarjetas y contenedores
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFC82328),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
    }

    // Modo claro: 100% fiel a la pantalla del cajero de Maze Bank en GTA V
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(
        0xFFEAEAEA,
      ), // Gris claro del fondo con marca de agua
      colorScheme: ColorScheme.light(
        primary: const Color(
          0xFFC82328,
        ), // Rojo Maze Bank (Header, Logo, Títulos de sección)
        secondary: const Color(
          0xFF5BC2E7,
        ), // Azul celeste (Botón "Back" y botones de acción)
        tertiary: const Color(
          0xFFDFB4B6,
        ), // Rosa salmón de las filas del Transaction Log
        surface: Colors.white, // Barra superior del logo
        onSurface: const Color(
          0xFF4A4A4A,
        ), // Texto oscuro suave de transacciones y logo (modo claro)
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Color(0xFFC82328), // Barra roja de usuario/saldo
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  AppTheme copyWith({bool? isDarkMode}) =>
      AppTheme(isDark: isDarkMode ?? isDark);
}
