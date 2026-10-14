import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/auth_user.dart';
import '../../data/repositories/auth_repository.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Concrete notifier. Depends on [AuthRepository], not [AuthRepositoryImpl].
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> login(String email, String password) async {
    // TODO: emit AuthLoading, call _repository.login, emit Authenticated or AuthError
    throw UnimplementedError('TODO $_repository');
  }

  Future<void> logout() async {
    // TODO: _repository.logout then emit AuthUnauthenticated
    throw UnimplementedError('TODO $_repository');
  }

  Future<void> checkAuthStatus() async {
    // TODO: _repository.getCurrentUser then Authenticated or Unauthenticated
    throw UnimplementedError('TODO $_repository');
  }
}
