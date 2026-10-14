import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';

void main() {
  group('AppException hierarchy', () {
    test('NetworkException has correct default message and code', () {
      const e = NetworkException();
      expect(e.message, 'No internet connection');
      expect(e.code, 'NETWORK_ERROR');
      expect(e.toString(), contains('No internet connection'));
    });

    test('AuthException has correct default message and code', () {
      const e = AuthException();
      expect(e.message, 'Authentication failed');
      expect(e.code, 'AUTH_ERROR');
    });

    test('ServerException has correct default message and code', () {
      const e = ServerException();
      expect(e.message, 'Server error occurred');
      expect(e.code, 'SERVER_ERROR');
    });

    test('custom message is preserved', () {
      const e = AuthException('Invalid email or password');
      expect(e.message, 'Invalid email or password');
    });
  });
}
