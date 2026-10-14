import 'package:intl/intl.dart';

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

  /// Formats a number as Nigerian Naira (e.g. ₦850,000)
  static String naira(num amount, {bool showDecimals = false}) {
    if (showDecimals) {
      return _nairaFormatWithDecimals.format(amount);
    }
    return _nairaFormat.format(amount);
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
