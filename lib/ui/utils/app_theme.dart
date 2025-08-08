import 'package:evently/ui/utils/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const TextTheme _lightTextTheme = TextTheme(
      titleSmall: TextStyle(
        fontSize: 16,
        color: AppColors.gray,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        color: AppColors.blue,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
          fontSize: 20, color: AppColors.blue, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w500));

  static const TextTheme _dartTextTheme = TextTheme(
      titleSmall: TextStyle(
        fontSize: 16,
        color: AppColors.offWhite,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        color: AppColors.blue,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
          fontSize: 20, color: AppColors.blue, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(
          fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w500));

  static final lightDefaultTextBoarder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.gray));
  static final darkDefaultTextBoarder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.gray));

  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.blue,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
      textTheme: _lightTextTheme,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: AppColors.blue)
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.blue),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500))),
      inputDecorationTheme: InputDecorationTheme(
        border: lightDefaultTextBoarder,
        focusedBorder: lightDefaultTextBoarder,
        enabledBorder: lightDefaultTextBoarder,
        hintStyle: _lightTextTheme.titleSmall,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.blue, thickness: 1));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: AppColors.darkPurple,
      primaryColor: AppColors.blue,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
      textTheme: _dartTextTheme,
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, textStyle: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500))),
      inputDecorationTheme: InputDecorationTheme(
        border: darkDefaultTextBoarder,
        focusedBorder: darkDefaultTextBoarder,
        enabledBorder: darkDefaultTextBoarder,
      ));
}