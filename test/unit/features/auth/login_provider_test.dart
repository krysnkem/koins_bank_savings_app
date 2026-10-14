import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/constants/app_constants.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/auth/data/models/auth_user.dart';
import 'package:koins_savings_app/features/auth/data/repositories/auth_repository.dart';
import 'package:koins_savings_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:koins_savings_app/features/auth/presentation/providers/login_provider.dart';

class MockAuthRepository implements AuthRepository {
  bool shouldFail = false;
  bool shouldDelay = false;

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    if (shouldDelay) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    if (shouldFail) {
      throw const AuthException('Invalid email or password');
    }
    return const AuthUser(
      fullName: AppConstants.mockUserName,
      email: AppConstants.mockUserEmail,
      phone: AppConstants.mockUserPhone,
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> isLoggedIn() async => false;

  @override
  Future<AuthUser?> getCurrentUser() async => null;
}

void main() {
  group('LoginNotifier & LoginState', () {
    late ProviderContainer container;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('initial state is LoginInitial with obscurePassword == true', () {
      final state = container.read(loginNotifierProvider);
      expect(state, isA<LoginInitial>());
      expect(state.obscurePassword, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('togglePasswordVisibility toggles obscurePassword flag', () {
      final notifier = container.read(loginNotifierProvider.notifier);
      expect(container.read(loginNotifierProvider).obscurePassword, isTrue);

      notifier.togglePasswordVisibility();
      expect(container.read(loginNotifierProvider).obscurePassword, isFalse);

      notifier.togglePasswordVisibility();
      expect(container.read(loginNotifierProvider).obscurePassword, isTrue);
    });

    test('LoginNotifier dictates its loading state watching AuthNotifier AuthLoading', () async {
      mockAuthRepository.shouldDelay = true;

      // Trigger login on auth notifier directly to observe sync
      final authNotifier = container.read(authNotifierProvider.notifier);
      final loginFuture = authNotifier.login('test@bank.com', 'password123');

      // AuthState enters AuthLoading, which LoginNotifier watches and syncs to LoginLoading
      expect(container.read(authNotifierProvider), isA<AuthLoading>());
      expect(container.read(loginNotifierProvider), isA<LoginLoading>());
      expect(container.read(loginNotifierProvider).isLoading, isTrue);

      await loginFuture;

      expect(container.read(authNotifierProvider), isA<AuthAuthenticated>());
      expect(container.read(loginNotifierProvider), isA<LoginSuccess>());
      expect(container.read(loginNotifierProvider).isLoading, isFalse);
    });

    test('LoginNotifier dictates LoginError when AuthNotifier encounters AuthError', () async {
      mockAuthRepository.shouldFail = true;

      final authNotifier = container.read(authNotifierProvider.notifier);
      await authNotifier.login('wrong@bank.com', 'wrongpassword');

      expect(container.read(authNotifierProvider), isA<AuthError>());
      final loginState = container.read(loginNotifierProvider);
      expect(loginState, isA<LoginError>());
      expect((loginState as LoginError).message, 'Invalid email or password');
    });
  });
}
