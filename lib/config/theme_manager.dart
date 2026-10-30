import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/colors_manager.dart';

class ThemeManager {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: ColorsManager.black,
    appBarTheme: AppBarThemeData(
        backgroundColor: ColorsManager.black,
        foregroundColor: ColorsManager.yellow,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: ColorsManager.yellow)
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.darkGrey,
      selectedItemColor: ColorsManager.yellow,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    textTheme: TextTheme(
      labelLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.white.withValues(alpha: 0.6),
      ),
      bodyMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ColorsManager.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ColorsManager.yellow,
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: ColorsManager.yellow,
      ),
    ),
  );
  static final ThemeData dark = ThemeData();
}
