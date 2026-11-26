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
        titleTextStyle: TextStyle(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w900),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.ink, fontSize: 30, fontWeight: FontWeight.w900, height: 1.08),
        headlineMedium: TextStyle(color: AppColors.ink, fontSize: 25, fontWeight: FontWeight.w900),
        titleLarge: TextStyle(color: AppColors.ink, fontSize: 19, fontWeight: FontWeight.w900),
        titleMedium: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w800),
        bodyLarge: TextStyle(color: AppColors.ink, fontSize: 15, height: 1.4),
        bodyMedium: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFE8EEF5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFE8EEF5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.7),
        ),
      ),
    );
  }
}
