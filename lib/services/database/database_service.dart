/// Contract for database persistence, abstracting all table reads and writes.
/// Feature services and mock backends interact with this interface, never raw SQL.
abstract class DatabaseService {
  /// Initializes or verifies the underlying database tables and seeds if uninitialized.
  Future<void> initialize();

  // Users
  Future<Map<String, dynamic>?> getUserByEmail(String email);

  // Products
  Future<List<Map<String, dynamic>>> getSavingsProducts();
  Future<Map<String, dynamic>?> getProductById(String id);

  // Savings Plans
  Future<List<Map<String, dynamic>>> getSavingsPlans({required String email});
  Future<void> insertSavingsPlan(Map<String, dynamic> plan);

  // Transactions
  Future<List<Map<String, dynamic>>> getTransactions({required String email});
  Future<void> insertTransaction(Map<String, dynamic> transaction);

  // Financial Tips
  Future<List<Map<String, dynamic>>> getFinancialTips();

  /// Closes database connection if applicable.
  Future<void> close();
}
