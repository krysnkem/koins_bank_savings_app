import 'package:flutter/material.dart';

/// Centralized border radius design tokens for Koins Savings App.
///
/// Strictly avoid writing raw numbers (e.g. `BorderRadius.circular(14)`).
/// Always reference [AppRadius] constants instead.
class AppRadius {
  AppRadius._();

  // ---------------------------------------------------------------------------
  // Numerical Radius Tokens
  // ---------------------------------------------------------------------------
  static const double zeroValue = 0.0;
  static const double xsValue = 4.0;
  static const double smValue = 6.0;
  static const double mdValue = 8.0;
  static const double standardValue = 12.0;
  static const double inputValue = 14.0;
  static const double buttonValue = 14.0;
  static const double cardValue = 16.0;
  static const double chipValue = 20.0;
  static const double lgValue = 20.0;
  static const double xlValue = 24.0;
  static const double xxlValue = 32.0;
  static const double fullValue = 999.0;

  // ---------------------------------------------------------------------------
  // Circular Radius Instances (Radius.circular)
  // ---------------------------------------------------------------------------
  static const Radius rZero = Radius.zero;
  static const Radius rXs = Radius.circular(xsValue);
  static const Radius rSm = Radius.circular(smValue);
  static const Radius rMd = Radius.circular(mdValue);
  static const Radius rStandard = Radius.circular(standardValue);
  static const Radius rInput = Radius.circular(inputValue);
  static const Radius rButton = Radius.circular(buttonValue);
  static const Radius rCard = Radius.circular(cardValue);
  static const Radius rChip = Radius.circular(chipValue);
  static const Radius rLg = Radius.circular(lgValue);
  static const Radius rXl = Radius.circular(xlValue);
  static const Radius rXxl = Radius.circular(xxlValue);
  static const Radius rFull = Radius.circular(fullValue);

  // ---------------------------------------------------------------------------
  // Pre-constructed BorderRadius Tokens
  // ---------------------------------------------------------------------------
  static const BorderRadius zero = BorderRadius.zero;
  static const BorderRadius xs = BorderRadius.all(rXs);
  static const BorderRadius sm = BorderRadius.all(rSm);
  static const BorderRadius md = BorderRadius.all(rMd);
  static const BorderRadius standard = BorderRadius.all(rStandard);
  static const BorderRadius input = BorderRadius.all(rInput);
  static const BorderRadius button = BorderRadius.all(rButton);
  static const BorderRadius card = BorderRadius.all(rCard);
  static const BorderRadius chip = BorderRadius.all(rChip);
  static const BorderRadius lg = BorderRadius.all(rLg);
  static const BorderRadius xl = BorderRadius.all(rXl);
  static const BorderRadius xxl = BorderRadius.all(rXxl);
  static const BorderRadius full = BorderRadius.all(rFull);
  static const BorderRadius pill = BorderRadius.all(rFull);

  // ---------------------------------------------------------------------------
  // Component Specific Semantic Presets
  // ---------------------------------------------------------------------------
  static const BorderRadius textField = input;
  static const BorderRadius primaryButton = button;
  static const BorderRadius outlinedButton = button;
  static const BorderRadius elevatedButton = button;
  static const BorderRadius snackBar = standard;
  static const BorderRadius modalTop = BorderRadius.vertical(top: rXl);
  static const BorderRadius bottomSheet = BorderRadius.vertical(top: rXl);
  static const BorderRadius badge = xs;
  static const BorderRadius tag = sm;

  // ---------------------------------------------------------------------------
  // Backward-compatible named aliases
  // ---------------------------------------------------------------------------
  static const BorderRadius xsRadius = xs;
  static const BorderRadius smRadius = sm;
  static const BorderRadius mdRadius = md;
  static const BorderRadius standardRadius = standard;
  static const BorderRadius inputRadius = input;
  static const BorderRadius buttonRadius = button;
  static const BorderRadius cardRadius = card;
  static const BorderRadius chipRadius = chip;
  static const BorderRadius lgRadius = lg;
  static const BorderRadius xlRadius = xl;
  static const BorderRadius fullRadius = full;
}
