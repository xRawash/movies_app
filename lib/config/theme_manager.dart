import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/colors_manager.dart';

class ThemeManager {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: ColorsManager.black,
    textTheme: TextTheme(
      labelLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
      labelMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white.withOpacity(0.6)),
      bodyMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: ColorsManager.black),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: ColorsManager.yellow),
    )
  );
}