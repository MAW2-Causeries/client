import 'package:flutter/material.dart';

class AppTheme {
  // Brand palette
  static const Color brandPrimary = Color(0xFF6367FF);
  static const Color brandSecondary = Color(0xFF8494FF);
  static const Color brandTertiary = Color(0xFFC9BEFF);
  static const Color brandAccent = Color(0xFFFFDBFD);

  // Discord-like dark neutrals
  static const Color darkBackground = Color(0xFF11121A);
  static const Color darkSurface = Color(0xFF1A1C27);
  static const Color darkSurfaceHigh = Color(0xFF23263A);

  // Soft light neutrals
  static const Color lightBackground = Color(0xFFF7F7FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFEFEEFF);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: brandPrimary,
    onPrimary: Colors.white,
    primaryContainer: brandTertiary,
    onPrimaryContainer: Color(0xFF20225C),
    secondary: brandSecondary,
    onSecondary: Color(0xFF111321),
    secondaryContainer: Color(0xFFDDE0FF),
    onSecondaryContainer: Color(0xFF202543),
    tertiary: brandAccent,
    onTertiary: Color(0xFF4F3153),
    tertiaryContainer: Color(0xFFFFE9FE),
    onTertiaryContainer: Color(0xFF513953),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: lightSurface,
    onSurface: Color(0xFF141424),
    surfaceContainerHighest: lightSurfaceAlt,
    onSurfaceVariant: Color(0xFF4A4861),
    outline: Color(0xFF807D9C),
    outlineVariant: Color(0xFFD0CCE8),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF28293A),
    onInverseSurface: Color(0xFFF0EEFF),
    inversePrimary: brandSecondary,
    surfaceTint: brandPrimary,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: brandPrimary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF353AC7),
    onPrimaryContainer: Color(0xFFE2E0FF),
    secondary: brandSecondary,
    onSecondary: Color(0xFF14172B),
    secondaryContainer: Color(0xFF353D66),
    onSecondaryContainer: Color(0xFFDDE0FF),
    tertiary: brandAccent,
    onTertiary: Color(0xFF5A3D5A),
    tertiaryContainer: Color(0xFF684868),
    onTertiaryContainer: Color(0xFFFFD9FC),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: darkSurface,
    onSurface: Color(0xFFE4E1F8),
    surfaceContainerHighest: darkSurfaceHigh,
    onSurfaceVariant: Color(0xFFC8C4DD),
    outline: Color(0xFF9490AE),
    outlineVariant: Color(0xFF46435D),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE4E1F8),
    onInverseSurface: Color(0xFF2E2F40),
    inversePrimary: Color(0xFF5559E3),
    surfaceTint: brandPrimary,
  );

  static const TextTheme appTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    titleLarge: TextStyle(
      fontFamily: 'ClashDisplay',
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: 'ClashGrotesk',
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'ClashGrotesk',
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'ClashGrotesk',
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontFamily: 'ClashGrotesk',
      fontWeight: FontWeight.w600,
    ),
  );

  static ThemeData lightTheme = _buildTheme(
    colorScheme: lightColorScheme,
    background: lightBackground,
  );

  static ThemeData darkTheme = _buildTheme(
    colorScheme: darkColorScheme,
    background: darkBackground,
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color background,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: colorScheme.surface,
      textTheme: appTextTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: colorScheme.surfaceContainerHighest,
        side: BorderSide(color: colorScheme.outlineVariant),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'ClashGrotesk',
          fontWeight: FontWeight.w500,
        ),
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.primary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        selectedColor: colorScheme.primary,
        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 70,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant;
          return TextStyle(
            color: color,
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w600,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: colorScheme.onInverseSurface,
          fontFamily: 'ClashGrotesk',
        ),
        actionTextColor: colorScheme.inversePrimary,
      ),
    );
  }
}
