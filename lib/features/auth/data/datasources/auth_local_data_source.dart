import '../models/auth_user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(AuthUser user);

  Future<AuthUser?> getSession();

  Future<void> clearSession();

  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> saveSession(AuthUser user) {
    // TODO: SharedPreferences keys is_logged_in, user_name, user_email, user_phone
    throw UnimplementedError();
  }

  @override
  Future<AuthUser?> getSession() {
    // TODO: read the keys above and return AuthUser, or null
    throw UnimplementedError();
  }

  @override
  Future<void> clearSession() {
    // TODO: remove the session keys
    throw UnimplementedError();
  }

  @override
  Future<bool> isLoggedIn() {
    // TODO: return the is_logged_in flag
    throw UnimplementedError();
  }
}
