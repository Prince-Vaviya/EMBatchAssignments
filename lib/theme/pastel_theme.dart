import 'package:flutter/material.dart';

class PastelTheme {
  // Soft pastel palette
  static const Color background = Color(0xFFF8FAFC); // Soft milk/slate tint
  static const Color surface = Color(0xFFFFFFFF); // Pure white card
  static const Color surfaceElevated = Color(0xFFF1F5F9); // Light cool gray

  // Pastel Accents
  static const Color pastelLilac = Color(0xFFE9D5FF); // Soft Lavender
  static const Color pastelLilacDark = Color(0xFF7E22CE);
  
  static const Color pastelMint = Color(0xFFDCFCE7); // Soft Mint
  static const Color pastelMintDark = Color(0xFF15803D);
  
  static const Color pastelPeach = Color(0xFFFFEDD5); // Soft Peach
  static const Color pastelPeachDark = Color(0xFFC2410C);
  
  static const Color pastelSky = Color(0xFFE0F2FE); // Soft Sky Blue
  static const Color pastelSkyDark = Color(0xFF0369A1);
  
  static const Color pastelRose = Color(0xFFFFE4E6); // Soft Rose
  static const Color pastelRoseDark = Color(0xFFBE123C);
  
  static const Color pastelButter = Color(0xFFFEF9C3); // Soft Butter
  static const Color pastelButterDark = Color(0xFFA16207);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A); // Deep slate
  static const Color textSecondary = Color(0xFF64748B); // Slate muted
  static const Color textTertiary = Color(0xFF94A3B8); // Light slate
  static const Color border = Color(0xFFE2E8F0); // Subtle card border

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: pastelLilacDark,
        secondary: pastelMintDark,
        surface: surface,
        error: pastelRoseDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border, width: 1.2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: pastelLilac,
        foregroundColor: pastelLilacDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
