import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

export 'auth_state.dart';

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Concrete notifier. Depends on [AuthRepository], not [AuthRepositoryImpl].
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    return const AuthInitial();
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _repository.login(email: email, password: password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(ErrorHandler.getUserMessage(e));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthUnauthenticated();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (_) {
      state = const AuthUnauthenticated();
    }
  }
}
