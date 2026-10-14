import '../models/savings_plan.dart';

abstract class SavingsLocalDataSource {
  Future<void> savePlans(List<SavingsPlan> plans);

  Future<List<SavingsPlan>> getPlans();

  Future<void> addPlan(SavingsPlan plan);
}

class SavingsLocalDataSourceImpl implements SavingsLocalDataSource {
  @override
  Future<void> savePlans(List<SavingsPlan> plans) {
    // TODO: persist the full list (SharedPreferences / Hive)
    throw UnimplementedError();
  }

  @override
  Future<List<SavingsPlan>> getPlans() {
    // TODO: read the cached list
    throw UnimplementedError();
  }

  @override
  Future<void> addPlan(SavingsPlan plan) {
    // TODO: append one plan to the cache
    throw UnimplementedError();
  }
}
