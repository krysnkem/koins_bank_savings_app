import 'package:flutter_test/flutter_test.dart';
import 'package:koins_savings_app/core/constants/app_constants.dart';
import 'package:koins_savings_app/core/errors/app_exception.dart';
import 'package:koins_savings_app/features/auth/data/models/auth_user.dart';
import 'package:koins_savings_app/features/products/data/models/savings_product.dart';
import 'package:koins_savings_app/features/savings/data/models/savings_plan.dart';
import 'package:koins_savings_app/services/mock_backend_service.dart';

import '../../helpers/mock_network_checker.dart';

void main() {
  late MockNetworkChecker networkChecker;
  late MockBackendService service;

  setUp(() {
    networkChecker = MockNetworkChecker(isOnline: true);
    service = MockBackendService(networkChecker: networkChecker);
  });

  group('MockBackendService.login', () {
    test('returns AuthUser when credentials are correct', () async {
      final user = await service.login(
        email: AppConstants.mockEmail,
        password: AppConstants.mockPassword,
      );

      expect(user, isA<AuthUser>());
      expect(user.email, AppConstants.mockEmail);
      expect(user.fullName, AppConstants.mockUserName);
      expect(user.phone, AppConstants.mockUserPhone);
    });

    test('throws AuthException when credentials are wrong', () async {
      expect(
        () => service.login(email: 'wrong@bank.com', password: 'wrong'),
        throwsA(isA<AuthException>()),
      );
    });

    test('throws NetworkException when offline', () async {
      networkChecker.isOnline = false;

      expect(
        () => service.login(
          email: AppConstants.mockEmail,
          password: AppConstants.mockPassword,
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('throws NetworkException when forceOffline is true', () async {
      service.forceOffline = true;

      expect(
        () => service.login(
          email: AppConstants.mockEmail,
          password: AppConstants.mockPassword,
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('MockBackendService.getSavingsProducts', () {
    test('returns exactly 4 products', () async {
      final products = await service.getSavingsProducts();

      expect(products, isA<List<SavingsProduct>>());
      expect(products.length, 4);
    });

    test('contains Target Savings with 12% interest', () async {
      final products = await service.getSavingsProducts();
      final target = products.firstWhere((p) => p.name == 'Target Savings');

      expect(target.interestRate, 12.0);
      expect(target.duration, '12 Months');
      expect(target.minimumDeposit, 5000);
    });

    test('throws NetworkException when offline', () async {
      networkChecker.isOnline = false;

      expect(
        () => service.getSavingsProducts(),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('MockBackendService.getProductById', () {
    test('returns product for valid id', () async {
      final product = await service.getProductById('1');

      expect(product, isA<SavingsProduct>());
      expect(product.id, '1');
      expect(product.name, 'Target Savings');
    });

    test('throws ServerException for unknown id', () async {
      expect(
        () => service.getProductById('999'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('MockBackendService.createSavingsPlan', () {
    test('returns a new SavingsPlan and adds it to the list', () async {
      final before = await service.getSavingsPlans();
      final initialCount = before.length;

      final plan = await service.createSavingsPlan(
        name: 'Holiday Fund',
        productId: '1',
        targetAmount: 200000,
        monthlyContribution: 20000,
        duration: '12 Months',
      );

      expect(plan, isA<SavingsPlan>());
      expect(plan.name, 'Holiday Fund');
      expect(plan.targetAmount, 200000);

      final after = await service.getSavingsPlans();
      expect(after.length, initialCount + 1);
    });

    test('throws ServerException for unknown productId', () async {
      expect(
        () => service.createSavingsPlan(
          name: 'Bad Plan',
          productId: 'unknown',
          targetAmount: 10000,
          monthlyContribution: 1000,
          duration: '6 Months',
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws NetworkException when offline', () async {
      networkChecker.isOnline = false;

      expect(
        () => service.createSavingsPlan(
          name: 'Offline Plan',
          productId: '1',
          targetAmount: 10000,
          monthlyContribution: 1000,
          duration: '6 Months',
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('MockBackendService.getSavingsPlans', () {
    test('returns seed plans on first call', () async {
      final plans = await service.getSavingsPlans();

      expect(plans, isA<List<SavingsPlan>>());
      expect(plans.length, greaterThanOrEqualTo(1));
    });
  });

  group('MockBackendService.getFinancialTips', () {
    test('returns a non-empty list of tips when online', () async {
      // This will call the real dummyjson endpoint (or fail if no network).
      // In CI we can inject a fake http.Client later.
      try {
        final tips = await service.getFinancialTips();
        expect(tips, isNotEmpty);
      } on NetworkException {
        // Acceptable in offline environments
      } on ServerException {
        // Acceptable if the external API is down
      }
    }, skip: 'Requires network or injected http.Client – enable when backend is implemented',);
  });
}
