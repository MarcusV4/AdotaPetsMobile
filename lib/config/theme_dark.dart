import 'package:flutter/material.dart';

class ThemeDark {
  static final ThemeData theme = ThemeData(
    // textTheme: GoogleFonts.interTextTheme(
    //   ThemeData(brightness: Brightness.dark).textTheme,
    // ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFE8622A), // laranja principal — mantido
      onPrimary: Colors.white,
      secondary: Color(0xFF3D2010), // laranja escuro (fundo de tags no dark)
      onSecondary: Color(0xFFE8622A),
      tertiary: Color(0xFF1A1A1A), // fundo das telas no dark
      onTertiary: Color(0xFFF5F0EB),
      error: Color(0xFFFF6B6B),
      onError: Colors.white,
      surface: Color(0xFF1B1614), // cards, modais, campos
      onSurface: Color(0xFFF0EBE5), // texto principal no dark
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0B0A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Color(0xFFF0EBE5),
      elevation: 0,
    ),
    cardColor: const Color(0xFF252525),
    dividerColor: const Color(0xFF333333),
    hintColor: const Color(0xFF8A817A),
    iconTheme: const IconThemeData(color: Color(0xFF999999)),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? const Color(0xFFE8622A)
            : const Color(0xFF999999),
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? const Color(0xFFE8622A).withOpacity(0.4)
            : const Color(0xFF333333),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1B1614),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF2A2421)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF2A2421)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFE8622A), width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE8622A),
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFE8622A),
      foregroundColor: Colors.white,
    ),
  );
}
