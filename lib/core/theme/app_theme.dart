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
      onPrimary: Colors.white,
      primaryContainer: isDark ? const Color(0xFF480008) : const Color(0xFFEDD5D6),
      onPrimaryContainer: isDark ? const Color(0xFFFFB0B4) : const Color(0xFF50000A),
      secondary: isDark ? AppColors.secondary : AppColors.secondaryDark,
      onSecondary: Colors.white,
      secondaryContainer: isDark ? const Color(0xFF1E2229) : const Color(0xFFE0E2E8),
      onSecondaryContainer: isDark ? const Color(0xFFB0B6C2) : const Color(0xFF1E2229),
      tertiary: isDark ? AppColors.secondaryLight : AppColors.secondary,
      onTertiary: Colors.white,
      tertiaryContainer: isDark ? const Color(0xFF22262F) : const Color(0xFFDCDEE4),
      onTertiaryContainer: isDark ? const Color(0xFFB0B6C2) : const Color(0xFF22262F),
      surface: surfaceColor,
      surfaceContainerHighest: raisedSurfaceColor,
      onSurface: isDark ? const Color(0xFFE8EBF2) : const Color(0xFF181C22),
      onSurfaceVariant: isDark ? const Color(0xFFB0B6C2) : const Color(0xFF55606D),
      outline: borderColor,
      outlineVariant: isDark ? const Color(0xFF2A2F3A) : const Color(0xFFD0D4DB),
      error: AppColors.error,
      onError: Colors.white,
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
