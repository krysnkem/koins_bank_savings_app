import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/transactions_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/savings/presentation/screens/create_savings_screen.dart';
import 'main_shell_screen.dart';

/// Global navigation keys for top-level root and shell branches.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final dashboardNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final savingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'savings');
final transactionsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'transactions');
final profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

/// Riverpod provider delivering the configured [GoRouter].
final appRouterProvider = Provider<GoRouter>((ref) {
  return appRouter;
});

/// Centralized declarative router configuration for Koins Savings App.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Splash & Onboarding
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Authentication
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Stateful Navigation Shell with IndexedStack for persistent bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Dashboard
        StatefulShellBranch(
          navigatorKey: dashboardNavigatorKey,
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        // Branch 1: Savings (Products catalog)
        StatefulShellBranch(
          navigatorKey: savingsNavigatorKey,
          routes: [
            GoRoute(
              path: '/products',
              builder: (context, state) => const ProductsScreen(),
            ),
          ],
        ),

        // Branch 2: Transactions
        StatefulShellBranch(
          navigatorKey: transactionsNavigatorKey,
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const TransactionsScreen(),
            ),
          ],
        ),

        // Branch 3: More (Profile & Settings)
        StatefulShellBranch(
          navigatorKey: profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Full-screen overlay routes (outside the bottom navigation shell)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/create',
      builder: (context, state) {
        final productId = state.uri.queryParameters['productId'];
        return CreateSavingsScreen(productId: productId);
      },
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: ':productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId'];
            return CreateSavingsScreen(productId: productId);
          },
        ),
      ],
    ),
  ],
);
