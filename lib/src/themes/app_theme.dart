import 'package:flutter/material.dart';

class AppTheme {
  // main colors
  static const Color colorPrimary = Color.fromRGBO(65, 90, 119, 1);
  static const Color colorBackground = Color.fromRGBO(13, 27, 42, 1);
  static const Color colorSurface = Color.fromRGBO(27, 38, 59, 1);
  static const Color colorSecondary = Color.fromRGBO(119, 141, 169, 1);
  static const Color colorNeutral = Color.fromRGBO(224, 225, 221, 1);
  static const Color colorError = Colors.redAccent;

  // spacing and radius constants
  static const double spacing = 16;
  static const double radius = 12;
  static const double innerRadius = radius / 2;
  static const double maxDesktopWidth = 768;

  // Global color scheme
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: colorPrimary,
    onPrimary: Colors.white,
    secondary: colorSecondary,
    onSecondary: Colors.white,
    surface: colorBackground,
    onSurface: Colors.white,
    error: colorError,
    onError: Colors.white,
  );

  // === Typographie (Clash Display intégré) ===
  static final TextTheme textTheme = const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w600,
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
  );

  // === Thème des champs de formulaire ===
  static final InputDecorationTheme inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: colorSurface,
    hintStyle: const TextStyle(
      color: colorSecondary,
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w400,
    ),
    errorStyle: const TextStyle(
      color: colorError,
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w500,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacing / 2,
      vertical: spacing / 1.2,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: colorSurface, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: colorSecondary, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: colorPrimary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: colorError, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: colorError, width: 1.5),
    ),
  );

  // === Thème principal ===
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorBackground,
      textTheme: textTheme,
      inputDecorationTheme: inputTheme,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(spacing),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'ClashDisplay',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          minimumSize: const Size.fromHeight(50),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorNeutral,
          side: const BorderSide(color: colorSecondary),
          padding: const EdgeInsets.all(spacing),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'ClashDisplay',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: colorSurface,
        elevation: 0,
        margin: const EdgeInsets.all(spacing),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),

      dividerTheme: const DividerThemeData(
        space: spacing,
        thickness: 1,
        color: Color.fromRGBO(119, 141, 169, 0.3),
      ),
    );
  }
}
