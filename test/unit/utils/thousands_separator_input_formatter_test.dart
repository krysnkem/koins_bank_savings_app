import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/utils/thousands_separator_input_formatter.dart';

void main() {
  group('ThousandsSeparatorInputFormatter (intl-backed)', () {
    late ThousandsSeparatorInputFormatter formatter;

    setUp(() {
      formatter = ThousandsSeparatorInputFormatter();
    });

    test('formats numbers with comma separators correctly', () {
      const input = TextEditingValue(
        text: '100000',
        selection: TextSelection.collapsed(offset: 6),
      );
      final output = formatter.formatEditUpdate(TextEditingValue.empty, input);

      expect(output.text, '100,000');
      expect(output.selection.baseOffset, 7);
    });

    test('formats millions correctly', () {
      const input = TextEditingValue(
        text: '1500000',
        selection: TextSelection.collapsed(offset: 7),
      );
      final output = formatter.formatEditUpdate(TextEditingValue.empty, input);

      expect(output.text, '1,500,000');
      expect(output.selection.baseOffset, 9);
    });

    test('retains empty string when cleared', () {
      const input = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      final output = formatter.formatEditUpdate(
        const TextEditingValue(
          text: '500',
          selection: TextSelection.collapsed(offset: 3),
        ),
        input,
      );

      expect(output.text, '');
      expect(output.selection.baseOffset, 0);
    });

    test('handles single digit', () {
      const input = TextEditingValue(
        text: '5',
        selection: TextSelection.collapsed(offset: 1),
      );
      final output = formatter.formatEditUpdate(TextEditingValue.empty, input);

      expect(output.text, '5');
      expect(output.selection.baseOffset, 1);
    });

    test('handles inserting a digit in the middle with accurate cursor placement', () {
      // User has 10,000 with cursor after '1' (offset 1), and inserts '5' -> text becomes '150,000'
      const oldValue = TextEditingValue(
        text: '10,000',
        selection: TextSelection.collapsed(offset: 1),
      );
      const newValue = TextEditingValue(
        text: '150,000',
        selection: TextSelection.collapsed(offset: 2), // right after '5'
      );

      final output = formatter.formatEditUpdate(oldValue, newValue);

      expect(output.text, '150,000');
      expect(output.selection.baseOffset, 2); // right after '5' in '150,000'
    });

    test('handles backspacing directly on a comma by removing preceding digit', () {
      // User has '1,000' and presses backspace right after ',' (cursor was at 2)
      const oldValue = TextEditingValue(
        text: '1,000',
        selection: TextSelection.collapsed(offset: 2),
      );
      const newValue = TextEditingValue(
        text: '1000',
        selection: TextSelection.collapsed(offset: 1),
      );

      final output = formatter.formatEditUpdate(oldValue, newValue);

      // Preceding digit '1' deleted, leaving '000' -> '0'
      expect(output.text, '0');
    });

    test('strips non-numeric characters', () {
      const input = TextEditingValue(
        text: '₦100000NGN',
        selection: TextSelection.collapsed(offset: 10),
      );
      final output = formatter.formatEditUpdate(TextEditingValue.empty, input);

      expect(output.text, '100,000');
    });

    test('handles single 0 cleanly', () {
      const input = TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );
      final output = formatter.formatEditUpdate(TextEditingValue.empty, input);

      expect(output.text, '0');
      expect(output.selection.baseOffset, 1);
    });

    test('strips leading zeros when entering larger numbers', () {
      const input = TextEditingValue(
        text: '0500',
        selection: TextSelection.collapsed(offset: 4),
      );
      final output = formatter.formatEditUpdate(TextEditingValue.empty, input);

      expect(output.text, '500');
      expect(output.selection.baseOffset, 3);
    });
  });
}
