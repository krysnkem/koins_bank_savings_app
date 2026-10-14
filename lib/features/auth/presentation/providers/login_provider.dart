import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'login_state.dart';

export 'login_state.dart';

class LoginNotifier extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    // Listen to AuthNotifier's state changes to dictate loading and result states
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      _syncFromAuthState(next);
    });
    // Sync current AuthState on initialization
    final currentAuth = ref.read(authNotifierProvider);
    return _stateFromAuth(currentAuth, obscurePassword: true);
  }

  LoginState _stateFromAuth(AuthState authState, {required bool obscurePassword}) {
    return switch (authState) {
      AuthLoading() => LoginLoading(obscurePassword: obscurePassword),
      AuthAuthenticated(:final user) =>
        LoginSuccess(user, obscurePassword: obscurePassword),
      AuthError(:final message) =>
        LoginError(message, obscurePassword: obscurePassword),
      AuthInitial() || AuthUnauthenticated() =>
        LoginInitial(obscurePassword: obscurePassword),
    };
  }

  void _syncFromAuthState(AuthState authState) {
    state = _stateFromAuth(authState, obscurePassword: state.obscurePassword);
  }

  void togglePasswordVisibility() {
    final newObscure = !state.obscurePassword;
    state = switch (state) {
      LoginInitial() => LoginInitial(obscurePassword: newObscure),
      LoginLoading() => LoginLoading(obscurePassword: newObscure),
      LoginSuccess(:final user) =>
        LoginSuccess(user, obscurePassword: newObscure),
      LoginError(:final message) =>
        LoginError(message, obscurePassword: newObscure),
    };
  }

  Future<void> submit({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    await ref.read(authNotifierProvider.notifier).login(email.trim(), password);
  }
}

final loginNotifierProvider =
    NotifierProvider.autoDispose<LoginNotifier, LoginState>(LoginNotifier.new);
