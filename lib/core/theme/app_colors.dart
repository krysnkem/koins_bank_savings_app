import 'package:flutter/material.dart';

/// Koins MFB official brand colors and design tokens.
/// Central source of truth for all application colors.
class AppColors {
  AppColors._();

  // Basic System Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color scrim = Color(0x8A000000);

  // Primary Brand Colors (Calibrated via Pixel Litmus Test)
  static const Color primary = Color(0xFF0B9234); // Deep banking emerald
  static const Color primaryDark = Color(0xFF076B24); // Darker green for pressed states
  static const Color primaryLight = Color(0xFF16A34A); // Lighter emerald
  static const Color primaryContainer = Color(0xFFE2F8E7); // Soft mint container

  // Secondary / Deep Teal
  static const Color secondary = Color(0xFF0F766E);
  static const Color secondaryDark = Color(0xFF134E4A);
  static const Color secondaryContainer = Color(0xFFCCFBF1);

  // Neutrals & Surfaces
  static const Color background = Color(0xFFFFFFFF); // Pure white canvas
  static const Color backgroundSubtle = Color(0xFFFAFCFA); // Ultra subtle backdrop
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color onSurface = Color(0xFF001D0B); // Deep forest black text
  static const Color onSurfaceVariant = Color(0xFF475569);
  static const Color outline = Color(0xFFE2E8F0);

  // Borders & Dividers
  static const Color divider = Color(0xFFE2E8F0);
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color bannerBorder = Color(0x330B9234);
  static const Color bannerBackground = Color(0x66E2F8E7);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF0B9234);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF001D0B); // Deep forest black (high contrast)
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Shadows & Overlays
  static const Color shadow = Color(0x10000000);
  static const Color shadowLight = Color(0x0A000000); // 4% black ambient
  static const Color shadowMedium = Color(0x12000000); // 7% black ambient
  static const Color cardShadow = Color(0x0A001D0B); // 4% forest black ambient
  static const Color cardShadowSubtle = Color(0x08001D0B); // 3% forest black subtle
  static const Color primaryGlow = Color(0x180B9234); // 9% emerald glow for avatars/badges
  static const Color buttonShadow = Color(0x250B9234); // 15% emerald button shadow
  static const Color disabled = Color(0xFF94A3B8);

  // Logo & Emblem Facet Palette
  static const Color logoEmeraldLight = Color(0xFF34D399);
  static const Color logoEmerald = Color(0xFF10B981);
  static const Color logoEmeraldDark = Color(0xFF059669);
  static const Color logoMintLight = Color(0xFF4ADE80);
  static const Color logoMint = Color(0xFF22C55E);
  static const Color logoMintDark = Color(0xFF16A34A);
  static const Color logoDeepGreen = Color(0xFF15803D);
  static const Color logoDarkest = Color(0xFF064E3B);
}
