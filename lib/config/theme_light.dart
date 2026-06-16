import 'package:flutter/material.dart';

class ThemeLight {
  static final ThemeData theme = ThemeData(
    // textTheme: GoogleFonts.interTextTheme(),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE8622A), // laranja principal
      onPrimary: Colors.white,
      secondary: Color(0xFFFFF3EE), // laranja claro (fundo de tags)
      onSecondary: Color(0xFFE8622A),
      tertiary: Color(0xFFF5F0EB), // bege (fundo das telas)
      onTertiary: Color(0xFF1A1A1A),
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white, // cards, modais, campos
      onSurface: Color(0xFF1A1A1A), // texto principal
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F0EB),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F0EB),
      foregroundColor: Color(0xFF1A1A1A),
      elevation: 0,
    ),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFE0D9D1),
    hintColor: const Color(0xFFBBB3AA),
    iconTheme: const IconThemeData(color: Color(0xFF666666)),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? const Color(0xFFE8622A)
            : Colors.white,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? const Color(0xFFE8622A).withOpacity(0.4)
            : const Color(0xFFE0D9D1),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFE8622A),
      foregroundColor: Colors.white,
    ),
  );
}
