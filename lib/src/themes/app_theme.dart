import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromARGB(255, 33, 33, 41);
  static const Color secondary = Color.fromARGB(255, 50, 57, 73);
  static const Color accent = Color.fromARGB(255, 76, 82, 101);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: primary,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'ClashDisplay',
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'ClashGrotesk',
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'ClashGrotesk',
        color: Colors.white70,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: 'ClashGrotesk',
        color: Colors.white60,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accent,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
