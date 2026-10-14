import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:koins_savings_app/core/router/app_router.dart';

void main() {
  group('AppRouter configuration', () {
    test('has rootNavigatorKey assigned', () {
      expect(appRouter.configuration.navigatorKey, rootNavigatorKey);
    });

    test('configures top-level and shell routes', () {
      final routes = appRouter.configuration.routes;
      
      // Top-level splash route
      final splashRoute = routes.whereType<GoRoute>().firstWhere((r) => r.path == '/');
      expect(splashRoute.path, '/');

      // Top-level login route
      final loginRoute = routes.whereType<GoRoute>().firstWhere((r) => r.path == '/login');
      expect(loginRoute.path, '/login');

      // StatefulShellRoute
      final shellRoute = routes.whereType<StatefulShellRoute>().first;
      expect(shellRoute.branches.length, 4);

      // Branch 0: Dashboard
      final dashboardBranch = shellRoute.branches[0];
      expect(dashboardBranch.routes.first, isA<GoRoute>());
      expect((dashboardBranch.routes.first as GoRoute).path, '/dashboard');

      // Branch 1: Savings (Products)
      final savingsBranch = shellRoute.branches[1];
      expect((savingsBranch.routes.first as GoRoute).path, '/products');

      // Branch 2: Transactions
      final transactionsBranch = shellRoute.branches[2];
      expect((transactionsBranch.routes.first as GoRoute).path, '/transactions');

      // Branch 3: Profile
      final profileBranch = shellRoute.branches[3];
      expect((profileBranch.routes.first as GoRoute).path, '/profile');

      // Full screen routes
      final productDetailsRoute = routes.whereType<GoRoute>().firstWhere((r) => r.path == '/product/:id');
      expect(productDetailsRoute.path, '/product/:id');

      final createSavingsRoute = routes.whereType<GoRoute>().firstWhere((r) => r.path == '/create');
      expect(createSavingsRoute.path, '/create');
    });
  });
}
