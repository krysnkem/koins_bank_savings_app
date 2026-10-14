import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

export 'app_colors.dart';
export 'app_radius.dart';
export 'app_spacing.dart';
export 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.secondaryDark,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnPrimary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.secondaryDark,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.divider,
      shadow: AppColors.shadow,
      scrim: AppColors.scrim,
      inverseSurface: AppColors.secondaryDark,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.primaryLight,
      tertiary: AppColors.info,
      onTertiary: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Cards
      cardTheme: const CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 18,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textTertiary,
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.error,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.secondaryDark,
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.white,
          fontSize: 14,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.snackBar,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryContainer,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryDark,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.chip,
        ),
      ),
    );
  }
}

