import 'package:flutter/material.dart';

class NeoBrutalistTheme {
  // Neo-Brutalism Core Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFDF5); // Warm creamy milk canvas
  static const Color surfaceElevated = Color(0xFFF4F0EA);

  // Soft Pastel Palette
  static const Color pastelMint = Color(0xFFB8F2E6);
  static const Color pastelLilac = Color(0xFFE8D7FF);
  static const Color pastelPeach = Color(0xFFFFD8BE);
  static const Color pastelButter = Color(0xFFFFF1A8);
  static const Color pastelSky = Color(0xFFBAE6FD);
  static const Color pastelRose = Color(0xFFFFCCD5);
  static const Color pastelLime = Color(0xFFD9F99D);

  // Neo-Brutalist Box Shadow Decorator
  static List<BoxShadow> hardShadow({
    double x = 4.0,
    double y = 4.0,
    Color color = black,
  }) {
    return [
      BoxShadow(
        color: color,
        offset: Offset(x, y),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ];
  }

  // Neo-Brutalist Container Decoration
  static BoxDecoration neoBox({
    required Color color,
    double radius = 16.0,
    double borderWidth = 2.5,
    double shadowOffset = 4.0,
    Color borderColor = black,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: hardShadow(x: shadowOffset, y: shadowOffset),
    );
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: black,
        secondary: pastelLilac,
        surface: white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: black, size: 24),
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
