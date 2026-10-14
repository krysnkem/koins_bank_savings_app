import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error when value is null', () {
      expect(Validators.email(null), 'Email is required');
    });

    test('returns error when value is empty', () {
      expect(Validators.email(''), 'Email is required');
      expect(Validators.email('   '), 'Email is required');
    });

    test('returns error for invalid format', () {
      expect(Validators.email('not-an-email'), 'Enter a valid email address');
      expect(Validators.email('missing@domain'), 'Enter a valid email address');
      expect(Validators.email('@nodomain.com'), 'Enter a valid email address');
    });

    test('returns null for valid email', () {
      expect(Validators.email('test@bank.com'), isNull);
      expect(Validators.email('john.doe@example.co.uk'), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error when value is null or empty', () {
      expect(Validators.password(null), 'Password is required');
      expect(Validators.password(''), 'Password is required');
    });

    test('returns error when shorter than 8 characters', () {
      expect(Validators.password('1234567'), 'Password must be at least 8 characters');
      expect(Validators.password('short'), 'Password must be at least 8 characters');
    });

    test('returns null for valid password', () {
      expect(Validators.password('Password123'), isNull);
      expect(Validators.password('12345678'), isNull);
    });
  });

  group('Validators.required', () {
    test('returns error when null or empty', () {
      expect(Validators.required(null), 'This field is required');
      expect(Validators.required(''), 'This field is required');
      expect(Validators.required('  '), 'This field is required');
    });

    test('uses custom field name', () {
      expect(
        Validators.required(null, fieldName: 'Savings Name'),
        'Savings Name is required',
      );
    });

    test('returns null for non-empty value', () {
      expect(Validators.required('Emergency Fund'), isNull);
    });
  });

  group('Validators.amount', () {
    test('returns error when null or empty', () {
      expect(Validators.amount(null), 'Amount is required');
      expect(Validators.amount(''), 'Amount is required');
    });

    test('returns error for zero or negative', () {
      expect(Validators.amount('0'), 'Enter a valid amount');
      expect(Validators.amount('-100'), 'Enter a valid amount');
    });

    test('returns error for non-numeric', () {
      expect(Validators.amount('abc'), 'Enter a valid amount');
    });

    test('returns null for valid positive amount', () {
      expect(Validators.amount('5000'), isNull);
      expect(Validators.amount('120000'), isNull);
      expect(Validators.amount('1,200.50'), isNull);
    });
  });
}
