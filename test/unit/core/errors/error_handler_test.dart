import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:koins_savings_app/core/errors/app_exception.dart';

void main() {
  group('ErrorHandler', () {
    test('getUserMessage handles SocketException and failed host lookup', () {
      const rawError =
          "ClientException with SocketException: Failed host lookup: 'dummyjson.com' (OS Error: No address associated with hostname, errno = 7), uri=https://dummyjson.com/posts?limit=3";
      final message = ErrorHandler.getUserMessage(rawError);

      expect(message, ErrorHandler.defaultNetworkMessage);
      expect(message, contains('Unable to connect to the internet'));
      expect(message, isNot(contains('errno = 7')));
      expect(message, isNot(contains('SocketException')));
    });

    test('getUserMessage handles http.ClientException', () {
      final clientException =
          http.ClientException('Connection reset by peer');
      final message = ErrorHandler.getUserMessage(clientException);

      expect(message, ErrorHandler.defaultNetworkMessage);
    });

    test('getUserMessage handles TimeoutException', () {
      final timeoutException = TimeoutException('Operation timed out');
      final message = ErrorHandler.getUserMessage(timeoutException);

      expect(message, ErrorHandler.defaultTimeoutMessage);
      expect(message, contains('Connection timed out'));
    });

    test('getUserMessage handles database errors', () {
      const dbError = 'DatabaseException(1) no such table: dummy_posts';
      final message = ErrorHandler.getUserMessage(dbError);

      expect(message, ErrorHandler.defaultDatabaseMessage);
      expect(message, contains('local financial records'));
      expect(message, isNot(contains('dummy_posts')));
    });

    test('getUserMessage handles disk and storage errors', () {
      const diskError = 'FileSystemException: No space left on device';
      final message = ErrorHandler.getUserMessage(diskError);

      expect(message, ErrorHandler.defaultDiskMessage);
      expect(message, contains('device storage'));
    });

    test('getUserMessage handles format and JSON parsing errors', () {
      const formatError = FormatException('Unexpected character at line 1');
      final message = ErrorHandler.getUserMessage(formatError);

      expect(message, ErrorHandler.defaultFormatMessage);
    });

    test('getUserMessage preserves clean business validation and auth messages', () {
      const authErr = AuthException('Invalid email or password');
      expect(ErrorHandler.getUserMessage(authErr), 'Invalid email or password');

      const valErr = ValidationException('All fields are required');
      expect(ErrorHandler.getUserMessage(valErr), 'All fields are required');
    });

    test('getUserMessage sanitizes technical AppException messages', () {
      const leakedErr = ServerException(
        'Failed to fetch posts from DummyJSON: SocketException: Failed host lookup: dummyjson.com',
      );
      final message = ErrorHandler.getUserMessage(leakedErr);

      expect(message, ErrorHandler.defaultNetworkMessage);
      expect(message, isNot(contains('SocketException')));
    });

    test('toAppException maps network error to NetworkException', () {
      const rawError =
          "SocketException: Failed host lookup: 'dummyjson.com' (OS Error: No address, errno = 7)";
      final exception = ErrorHandler.toAppException(rawError);

      expect(exception, isA<NetworkException>());
      expect(exception.message, ErrorHandler.defaultNetworkMessage);
    });

    test('toAppException maps database error to AppDatabaseException', () {
      const rawError = 'DatabaseException: sqlite syntax error';
      final exception = ErrorHandler.toAppException(rawError);

      expect(exception, isA<AppDatabaseException>());
      expect(exception.message, ErrorHandler.defaultDatabaseMessage);
    });
  });
}
