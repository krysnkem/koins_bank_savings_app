import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/utils/formatters.dart';

void main() {
  group('Formatters.naira', () {
    test('formats whole numbers with ₦ and thousand separators', () {
      expect(Formatters.naira(850000), '₦850,000');
      expect(Formatters.naira(120000), '₦120,000');
      expect(Formatters.naira(5000), '₦5,000');
      expect(Formatters.naira(0), '₦0');
    });

    test('formats with decimals when requested', () {
      final result = Formatters.naira(1500.5, showDecimals: true);
      expect(result, contains('₦'));
      expect(result, contains('1,500'));
    });
  });

  group('Formatters.percentage', () {
    test('formats whole percentages', () {
      expect(Formatters.percentage(12), '12%');
      expect(Formatters.percentage(18), '18%');
      expect(Formatters.percentage(8), '8%');
    });

    test('formats decimal percentages', () {
      expect(Formatters.percentage(12.5), '12.5%');
    });
  });

  group('Formatters.greeting', () {
    test('returns a non-empty greeting string', () {
      final greeting = Formatters.greeting();
      expect(greeting, isNotEmpty);
      expect(
        ['Good Morning', 'Good Afternoon', 'Good Evening'].contains(greeting),
        isTrue,
      );
    });
  });
}
