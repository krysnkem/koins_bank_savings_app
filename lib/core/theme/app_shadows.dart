import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized shadow design tokens for Koins Savings App.
///
/// Strictly avoid writing inline BoxShadows.
/// Reference [AppShadows] constants instead.
class AppShadows {
  AppShadows._();

  /// Standard soft ambient drop shadow for cards and list tiles.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.cardShadow,
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Subtle drop shadow for form input wrappers and compact elements.
  static const List<BoxShadow> cardSubtle = [
    BoxShadow(
      color: AppColors.cardShadowSubtle,
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// Elevated shadow for prominent modal cards and floating overlays.
  static const List<BoxShadow> cardElevated = [
    BoxShadow(
      color: AppColors.shadowMedium,
      offset: Offset(0, 6),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  /// Soft upward ambient shadow for bottom navigation bars.
  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: AppColors.shadowLight,
      offset: Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Emerald-tinted soft circular glow for avatars and hero icons.
  static const List<BoxShadow> avatarGlow = [
    BoxShadow(
      color: AppColors.primaryGlow,
      offset: Offset(0, 6),
      blurRadius: 24,
      spreadRadius: 2,
    ),
  ];

  /// Emerald button shadow for elevated primary action buttons.
  static const List<BoxShadow> buttonGlow = [
    BoxShadow(
      color: AppColors.buttonShadow,
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
}
