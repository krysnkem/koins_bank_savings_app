import 'package:flutter/material.dart';

/// Koins MFB official brand colors extracted from koinsbank.com
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF22C55E); // Vibrant green
  static const Color primaryDark = Color(0xFF16A34A); // Darker green for pressed states
  static const Color primaryLight = Color(0xFF4ADE80); // Lighter green
  static const Color primaryContainer = Color(0xFFDCFCE7); // Soft mint container

  // Secondary / Deep Teal
  static const Color secondary = Color(0xFF0F766E);
  static const Color secondaryDark = Color(0xFF134E4A);
  static const Color secondaryContainer = Color(0xFFCCFBF1);

  // Neutrals
  static const Color background = Color(0xFFF0FDF4); // Very light mint
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color onSurface = Color(0xFF064E3B); // Dark green text
  static const Color onSurfaceVariant = Color(0xFF475569);
  static const Color outline = Color(0xFFCBD5E1);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Text
  static const Color textPrimary = Color(0xFF064E3B);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Misc
  static const Color divider = Color(0xFFE2E8F0);
  static const Color disabled = Color(0xFF94A3B8);
  static const Color shadow = Color(0x1A000000);
}
