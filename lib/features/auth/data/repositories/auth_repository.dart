import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<AuthUser?> getCurrentUser();

  Future<bool> isLoggedIn();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final user = await _remote.login(email: email, password: password);
    await _local.saveSession(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _local.clearSession();
  }

  @override
  Future<AuthUser?> getCurrentUser() {
    return _local.getSession();
  }

  @override
  Future<bool> isLoggedIn() {
    return _local.isLoggedIn();
  }
}
