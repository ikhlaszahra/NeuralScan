import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgDeep      = Color(0xFF07071A);
  static const Color bgCard      = Color(0xFF0D0D24);
  static const Color bgCardLight = Color(0xFF070718);
  static const Color neonCyan    = Color(0xFF00E5FF);
  static const Color neonViolet  = Color(0xFF9D4EDD);
  static const Color neonPink    = Color(0xFFFF2D78);
  static const Color neonGreen   = Color(0xFF00FFA3);
  static const Color textPrimary = Color(0xFFE8E8FF);
  static const Color textMuted   = Color(0xFF5A5A8A);
  static const Color border      = Color(0xFF1E1E40);

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
