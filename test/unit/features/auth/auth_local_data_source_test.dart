import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:koins_savings_app/features/auth/data/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AuthLocalDataSourceImpl (Disk Persistence)', () {
    late AuthLocalDataSource localDataSource;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      localDataSource = AuthLocalDataSourceImpl();
    });

    test('isLoggedIn returns false initially', () async {
      expect(await localDataSource.isLoggedIn(), isFalse);
      expect(await localDataSource.getSession(), isNull);
    });

    test('saveSession writes user session to disk', () async {
      const user = AuthUser(
        fullName: 'Jane Doe',
        email: 'jane@bank.com',
        phone: '+234 809 999 8888',
      );

      await localDataSource.saveSession(user);

      expect(await localDataSource.isLoggedIn(), isTrue);
      final session = await localDataSource.getSession();
      expect(session, isNotNull);
      expect(session!.fullName, 'Jane Doe');
      expect(session.email, 'jane@bank.com');
      expect(session.phone, '+234 809 999 8888');
    });

    test('clearSession removes session keys from disk', () async {
      const user = AuthUser(
        fullName: 'Jane Doe',
        email: 'jane@bank.com',
        phone: '+234 809 999 8888',
      );

      await localDataSource.saveSession(user);
      expect(await localDataSource.isLoggedIn(), isTrue);

      await localDataSource.clearSession();
      expect(await localDataSource.isLoggedIn(), isFalse);
      expect(await localDataSource.getSession(), isNull);
    });
  });
}
