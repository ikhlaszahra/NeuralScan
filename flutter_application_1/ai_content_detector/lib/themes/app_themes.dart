import 'package:flutter/material.dart';

class AppTheme {
  // Core palette — deep space dark + electric cyan + hot violet
  static const Color bgDeep       = Color(0xFF060612);
  static const Color bgCard       = Color(0xFF0E0E22);
  static const Color bgCardLight  = Color(0xFF14142E);
  static const Color neonCyan     = Color(0xFF00E5FF);
  static const Color neonViolet   = Color(0xFF9D4EDD);
  static const Color neonPink     = Color(0xFFFF2D78);
  static const Color neonGreen    = Color(0xFF00FFA3);
  static const Color textPrimary  = Color(0xFFF0F0FF);
  static const Color textMuted    = Color(0xFF6B6B9A);
  static const Color border       = Color(0xFF1E1E40);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonViolet, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [neonPink, neonViolet],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient safeGradient = LinearGradient(
    colors: [neonCyan, neonGreen],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDeep,
    colorScheme: const ColorScheme.dark(
      primary: neonCyan,
      secondary: neonViolet,
      surface: bgCard,
    ),
    useMaterial3: true,
  );
}
