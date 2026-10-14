import '../../../../services/backend_service.dart';
import '../models/auth_user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUser> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._backend);

  final BackendService _backend;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    // TODO: return _backend.login(email: email, password: password)
    throw UnimplementedError('TODO $_backend');
  }
}
