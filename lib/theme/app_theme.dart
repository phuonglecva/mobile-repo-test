import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.light,
      surface: AppColors.canvas,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: AppColors.ink, fontSize: 21, fontWeight: FontWeight.w900),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.ink, fontSize: 30, fontWeight: FontWeight.w900, height: 1.08),
        headlineMedium: TextStyle(color: AppColors.ink, fontSize: 24, fontWeight: FontWeight.w900),
        titleLarge: TextStyle(color: AppColors.ink, fontSize: 19, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w800),
        bodyLarge: TextStyle(color: AppColors.ink, fontSize: 15, height: 1.4),
        bodyMedium: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.35),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
      ),
    );
  }
}
