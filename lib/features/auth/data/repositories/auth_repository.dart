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
    // TODO: user = await _remote.login(...)
    // TODO: await _local.saveSession(user) only after success
    // TODO: rethrow AuthException and NetworkException without saving
    throw UnimplementedError('TODO $_remote $_local');
  }

  @override
  Future<void> logout() async {
    // TODO: await _local.clearSession()
    throw UnimplementedError('TODO $_remote $_local');
  }

  @override
  Future<AuthUser?> getCurrentUser() {
    // TODO: return _local.getSession()
    throw UnimplementedError('TODO $_remote $_local');
  }

  @override
  Future<bool> isLoggedIn() {
    // TODO: return _local.isLoggedIn()
    throw UnimplementedError('TODO $_remote $_local');
  }
}
