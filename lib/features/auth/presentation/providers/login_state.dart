import '../../data/models/auth_user.dart';

sealed class LoginState {
  final bool obscurePassword;
  const LoginState({this.obscurePassword = true});

  bool get isLoading => this is LoginLoading;
}

class LoginInitial extends LoginState {
  const LoginInitial({super.obscurePassword = true});
}

class LoginLoading extends LoginState {
  const LoginLoading({super.obscurePassword = true});
}

class LoginSuccess extends LoginState {
  final AuthUser user;
  const LoginSuccess(this.user, {super.obscurePassword = true});
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message, {super.obscurePassword = true});
}
