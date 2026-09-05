import 'package:flutter/material.dart';

class AppTheme {
  // Classic Electric Lime-Green & Deep Black
  static const Color primary = Color(0xFFE2F163); // Classic electric lime/volt green
  static const Color primaryDark = Color(0xFFC7D74B);
  static const Color secondary = Color(0xFFD4E84B); // Complementary lime accent
  static const Color background = Color(0xFF0A0A0A); // True pitch black
  static const Color surface = Color(0xFF141414); // Deep neutral graphite card surface
  static const Color surfaceVariant = Color(0xFF1E1E1E); // Elevated dark surface
  static const Color border = Color(0xFF262626); // Crisp neutral border
  static const Color borderLight = Color(0xFF333333);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E); // Neutral gray
  static const Color error = Color(0xFFFF4444);
  static const Color warning = Color(0xFFFFB300);

  // Dedicated vibrant shades for category discrimination
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase().trim()) {
      case 'chest':
        return const Color(0xFF38BDF8); // Electric Sky Blue
      case 'back':
        return const Color(0xFF8B5CF6); // Deep Electric Violet
      case 'legs':
        return const Color(0xFFEC4899); // Vibrant Hot Pink
      case 'shoulders':
        return const Color(0xFFD946EF); // Radiant Magenta
      case 'arms':
      case 'biceps':
      case 'triceps':
        return const Color(0xFFFF7A00); // High-Voltage Orange
      case 'core':
      case 'abs':
      case 'abs & core':
        return const Color(0xFFFBBF24); // Amber Gold
      case 'cardio':
        return const Color(0xFF00E5FF); // Electric Cyan
      case 'hiit':
        return const Color(0xFFFF3366); // Neon Coral Red
      default:
        return primary;
    }
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onPrimary: Color(0xFF000000),
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 12,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF000000),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),
    );
  }
}
