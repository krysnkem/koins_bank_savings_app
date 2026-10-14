import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/constants/app_constants.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:koins_savings_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:koins_savings_app/features/auth/data/models/auth_user.dart';
import 'package:koins_savings_app/features/auth/data/repositories/auth_repository.dart';

/// Simple in-memory fakes so tests do not need Mockito yet.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  FakeAuthRemoteDataSource({this.shouldFail = false, this.networkError = false});

  bool shouldFail;
  bool networkError;

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    if (networkError) throw const NetworkException();
    if (shouldFail) throw const AuthException('Invalid email or password');
    if (email == AppConstants.mockEmail && password == AppConstants.mockPassword) {
      return const AuthUser(
        fullName: AppConstants.mockUserName,
        email: AppConstants.mockUserEmail,
        phone: AppConstants.mockUserPhone,
      );
    }
    throw const AuthException('Invalid email or password');
  }
}

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  AuthUser? _session;

  @override
  Future<void> saveSession(AuthUser user) async => _session = user;

  @override
  Future<AuthUser?> getSession() async => _session;

  @override
  Future<void> clearSession() async => _session = null;

  @override
  Future<bool> isLoggedIn() async => _session != null;
}

void main() {
  late FakeAuthRemoteDataSource remote;
  late FakeAuthLocalDataSource local;
  late AuthRepository repository;

  setUp(() {
    remote = FakeAuthRemoteDataSource();
    local = FakeAuthLocalDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: remote, localDataSource: local);
  });

  group('AuthRepository.login', () {
    test('on success: calls remote, saves session, returns user', () async {
      final user = await repository.login(
        email: AppConstants.mockEmail,
        password: AppConstants.mockPassword,
      );

      expect(user.email, AppConstants.mockEmail);
      expect(user.fullName, AppConstants.mockUserName);

      final session = await local.getSession();
      expect(session, isNotNull);
      expect(session!.email, AppConstants.mockEmail);
      expect(await local.isLoggedIn(), isTrue);
    });

    test('on AuthException: does not save session and rethrows', () async {
      remote.shouldFail = true;

      expect(
        () => repository.login(email: 'bad@mail.com', password: 'wrong'),
        throwsA(isA<AuthException>()),
      );

      expect(await local.getSession(), isNull);
      expect(await local.isLoggedIn(), isFalse);
    });

    test('on NetworkException: does not save session and rethrows', () async {
      remote.networkError = true;

      expect(
        () => repository.login(
          email: AppConstants.mockEmail,
          password: AppConstants.mockPassword,
        ),
        throwsA(isA<NetworkException>()),
      );

      expect(await local.getSession(), isNull);
    });
  });

  group('AuthRepository.logout', () {
    test('clears the local session', () async {
      await repository.login(
        email: AppConstants.mockEmail,
        password: AppConstants.mockPassword,
      );
      expect(await local.isLoggedIn(), isTrue);

      await repository.logout();

      expect(await local.getSession(), isNull);
      expect(await local.isLoggedIn(), isFalse);
    });
  });

  group('AuthRepository.getCurrentUser', () {
    test('returns user when session exists', () async {
      await repository.login(
        email: AppConstants.mockEmail,
        password: AppConstants.mockPassword,
      );

      final user = await repository.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.email, AppConstants.mockEmail);
    });

    test('returns null when no session', () async {
      final user = await repository.getCurrentUser();
      expect(user, isNull);
    });
  });

  group('AuthRepository.isLoggedIn', () {
    test('reflects local storage state', () async {
      expect(await repository.isLoggedIn(), isFalse);

      await repository.login(
        email: AppConstants.mockEmail,
        password: AppConstants.mockPassword,
      );
      expect(await repository.isLoggedIn(), isTrue);

      await repository.logout();
      expect(await repository.isLoggedIn(), isFalse);
    });
  });
}
