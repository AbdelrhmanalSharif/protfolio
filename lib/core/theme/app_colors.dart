import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF4757);
  static const Color primaryLight = Color(0xFFFF6B7A);
  static const Color primaryDark = Color(0xFFE63946);

  // Background Colors
  static const Color backgroundPrimary = Color(0xFF0A0A0A);
  static const Color backgroundSecondary = Color(0xFF1A1A1A);
  static const Color backgroundTertiary = Color(0xFF2D1B1B);
  static const Color backgroundCard = Color(0xFF1A1A1A);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);

  // Border Colors
  static const Color borderPrimary = Color(0xFF333333);
  static const Color borderSecondary = Color(0xFF1A1A1A);

  // Skill Colors
  static const Color skillBlue = Colors.blue;
  static const Color skillCyan = Colors.cyan;
  static const Color skillOrange = Colors.orange;
  static const Color skillGreen = Colors.green;
  static const Color skillPurple = Colors.purple;
  static const Color skillPink = Colors.pink;

  // Gradient Colors
  static const List<Color> heroGradient = [
    backgroundPrimary,
    Color(0xFF1A0A0A),
    backgroundTertiary,
  ];

  static const List<Color> aboutGradient = [
    backgroundSecondary,
    backgroundPrimary,
  ];

  static const List<Color> contactGradient = [
    backgroundPrimary,
    backgroundSecondary,
    backgroundTertiary,
  ];

  // Opacity Colors
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color textPrimaryWithOpacity(double opacity) =>
      textPrimary.withOpacity(opacity);
  static Color textSecondaryWithOpacity(double opacity) =>
      textSecondary.withOpacity(opacity);
  static Color borderPrimaryWithOpacity(double opacity) =>
      borderPrimary.withOpacity(opacity);
}
