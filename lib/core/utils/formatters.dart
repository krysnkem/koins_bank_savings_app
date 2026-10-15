import 'package:intl/intl.dart';

export 'thousands_separator_input_formatter.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _nairaFormat = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 0,
  );

  static final NumberFormat _nairaFormatWithDecimals = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  static final NumberFormat _amountFormat = NumberFormat.decimalPattern('en_US');

  /// Formats a number as Nigerian Naira (e.g. ₦850,000)
  static String naira(num amount, {bool showDecimals = false}) {
    if (showDecimals) {
      return _nairaFormatWithDecimals.format(amount);
    }
    return _nairaFormat.format(amount);
  }

  /// Formats an amount with comma thousands separators (e.g. 100,000) using intl
  static String formatAmount(num amount) => _amountFormat.format(amount);

  /// Parses a formatted amount string (e.g. "100,000") to double
  static double? parseAmount(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    return double.tryParse(text.replaceAll(',', '').trim());
  }

  /// Returns a greeting based on the current time of day
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// Formats percentage (e.g. 12%)
  static String percentage(num value) {
    return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}%';
  }
}

