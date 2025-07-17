import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Poppins',

  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),

  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textTitleMedium,
    ),
    bodyMedium: TextStyle(fontSize: 13, color: Colors.black54),
  ),

  iconTheme: IconThemeData(color: Colors.black54),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF1F1F1),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.grey),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF4CAF50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),

  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
