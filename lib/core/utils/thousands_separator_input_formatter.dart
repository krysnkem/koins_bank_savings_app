import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// [TextInputFormatter] that formats numeric entries into thousands-separated amounts
/// using the `intl` package's [NumberFormat.decimalPattern].
///
/// Example: typing `100000` automatically formats to `100,000`.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  ThousandsSeparatorInputFormatter({String locale = 'en_US'})
      : _formatter = NumberFormat.decimalPattern(locale);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String textToFormat = newValue.text;
    int selectionIndex = newValue.selection.end;

    // Handle backspacing a comma: if the user pressed backspace directly after a comma,
    // also remove the digit that preceded that comma to avoid getting stuck.
    if (oldValue.text.length == newValue.text.length + 1 &&
        oldValue.selection.end > 0 &&
        oldValue.selection.end <= oldValue.text.length) {
      final deletedChar = oldValue.text[oldValue.selection.end - 1];
      if (deletedChar == ',') {
        final commaIndex = oldValue.selection.end - 1;
        if (commaIndex > 0) {
          final beforeDigit = textToFormat.substring(0, commaIndex - 1);
          final afterDigit = textToFormat.substring(commaIndex);
          textToFormat = beforeDigit + afterDigit;
          selectionIndex = commaIndex - 1;
        }
      }
    }

    // Determine how many digits were positioned before the cursor in newValue
    final safeSelectionIndex = selectionIndex.clamp(0, textToFormat.length);
    final textBeforeCursor = textToFormat.substring(0, safeSelectionIndex);
    final digitsBeforeCursor =
        textBeforeCursor.replaceAll(RegExp(r'[^\d]'), '').length;

    // Extract raw digits
    final digitsOnly = textToFormat.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Strip superfluous leading zeros (e.g. "0500" -> "500"), but preserve single "0"
    final cleanedDigits = digitsOnly.replaceFirst(RegExp(r'^0+(?=\d)'), '');

    // Parse with intl / int
    final number = int.tryParse(cleanedDigits);
    if (number == null) {
      return oldValue;
    }

    // Format using intl NumberFormat
    final formatted = _formatter.format(number);

    // If leading zeros before cursor were removed, adjust target digit count
    final strippedLeadingZeros = digitsOnly.length - cleanedDigits.length;
    final targetDigitCount = (digitsBeforeCursor - strippedLeadingZeros)
        .clamp(0, cleanedDigits.length);

    // Find the cursor position in the newly formatted text corresponding to targetDigitCount
    int newOffset = 0;
    int countedDigits = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp(r'\d').hasMatch(formatted[i])) {
        countedDigits++;
      }
      newOffset = i + 1;
      if (countedDigits >= targetDigitCount) {
        break;
      }
    }

    // If cursor was at or past the end of the input, anchor to the end of formatted string
    if (safeSelectionIndex >= textToFormat.length) {
      newOffset = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newOffset.clamp(0, formatted.length),
      ),
    );
  }
}
