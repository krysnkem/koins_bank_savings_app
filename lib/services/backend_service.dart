import '../features/auth/data/models/auth_user.dart';
import '../features/dashboard/data/models/financial_tip.dart';
import '../features/products/data/models/savings_product.dart';
import '../features/savings/data/models/savings_plan.dart';

/// Remote API contract. Feature data sources depend on this, not on
/// [MockBackendService].
abstract class BackendService {
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<List<SavingsProduct>> getSavingsProducts();

  Future<SavingsProduct> getProductById(String id);

  Future<List<SavingsPlan>> getSavingsPlans();

  Future<SavingsPlan> createSavingsPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  });

  Future<List<FinancialTip>> getFinancialTips();
}
