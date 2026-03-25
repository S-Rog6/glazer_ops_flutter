import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    isDark: false,
    scaffoldBackgroundColor: AppColors.lightBackground,
    surfaceColor: AppColors.lightSurface,
    raisedSurfaceColor: AppColors.lightSurfaceRaised,
    borderColor: AppColors.lightBorder,
  );

  static ThemeData get darkTheme => _buildTheme(
    isDark: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    surfaceColor: AppColors.darkSurface,
    raisedSurfaceColor: AppColors.darkSurfaceRaised,
    borderColor: AppColors.darkBorder,
  );

  static ThemeData _buildTheme({
    required bool isDark,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color raisedSurfaceColor,
    required Color borderColor,
  }) {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
    final colorScheme = baseScheme.copyWith(
      primary: isDark ? AppColors.primaryLight : AppColors.primary,
      secondary: isDark ? AppColors.secondary : AppColors.secondaryDark,
      tertiary: isDark ? AppColors.secondaryLight : AppColors.secondary,
      surface: surfaceColor,
      surfaceContainerHighest: raisedSurfaceColor,
      primaryContainer: isDark ? const Color(0xFF5A0A11) : const Color(0xFFF8D9DC),
      secondaryContainer: isDark ? const Color(0xFF222933) : const Color(0xFFE5E9EF),
      tertiaryContainer: isDark ? const Color(0xFF28303B) : const Color(0xFFE2E6EC),
      onSurface: isDark ? const Color(0xFFE7EBF2) : const Color(0xFF181C22),
      onSurfaceVariant: isDark ? const Color(0xFFB9C0CB) : const Color(0xFF58606D),
      outline: borderColor,
      error: AppColors.error,
    );

    final baseTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
    );

    return baseTheme.copyWith(
      canvasColor: surfaceColor,
      appBarTheme: AppBarTheme(
        backgroundColor: raisedSurfaceColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: raisedSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          side: BorderSide(color: borderColor),
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        side: BorderSide(color: borderColor),
        backgroundColor: raisedSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: raisedSurfaceColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: DividerThemeData(color: borderColor, thickness: 1),
      drawerTheme: DrawerThemeData(backgroundColor: surfaceColor),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: raisedSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        selectedTileColor: colorScheme.primary.withValues(
          alpha: isDark ? 0.16 : 0.1,
        ),
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
        ),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
