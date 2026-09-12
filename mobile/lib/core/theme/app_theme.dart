import 'package:flutter/material.dart';

/// Palette de marque "Souk" — reprend les couleurs validées dans la maquette.
class AppColors {
  static const primary = Color(0xFF1B2A4A); // bleu nuit
  static const primaryLight = Color(0xFF2E4470);
  static const gold = Color(0xFFE8A33D); // ocre sahel
  static const clay = Color(0xFFC1502E); // terracotta
  static const green = Color(0xFF4C7A5E); // vert acacia (succès / livraison)
  static const background = Color(0xFFF6EFE3); // sable
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF23201B);
  static const muted = Color(0xFF8B8172);
  static const line = Color(0xFFE7DDC9);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.clay,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      fontFamily: 'Manrope',
    );
  }
}
