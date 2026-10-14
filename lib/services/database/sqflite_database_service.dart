import 'package:sqflite/sqflite.dart';

import 'app_database.dart';
import 'database_service.dart';

/// Concrete SQLite implementation of [DatabaseService] using sqflite.
class SqfliteDatabaseService implements DatabaseService {
  SqfliteDatabaseService({AppDatabase? appDatabase})
      : _appDatabase = appDatabase ?? AppDatabase.instance;

  final AppDatabase _appDatabase;

  Future<Database> get _db => _appDatabase.database;

  @override
  Future<void> initialize() async {
    await _db;
  }

  @override
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _db;
    final results = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return results.first;
  }

  @override
  Future<List<Map<String, dynamic>>> getSavingsProducts() async {
    final db = await _db;
    return db.query(
      'savings_products',
      where: 'is_active = 1',
      orderBy: 'id ASC',
    );
  }

  @override
  Future<Map<String, dynamic>?> getProductById(String id) async {
    final db = await _db;
    final results = await db.query(
      'savings_products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return results.first;
  }

  @override
  Future<List<Map<String, dynamic>>> getSavingsPlans({
    required String email,
  }) async {
    final db = await _db;
    return db.query(
      'savings_plans',
      where: 'LOWER(user_email) = ?',
      whereArgs: [email.trim().toLowerCase()],
      orderBy: 'created_at DESC',
    );
  }

  @override
  Future<void> insertSavingsPlan(Map<String, dynamic> plan) async {
    final db = await _db;
    await db.insert(
      'savings_plans',
      plan,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactions({
    required String email,
  }) async {
    final db = await _db;
    return db.query(
      'transactions',
      where: 'LOWER(user_email) = ?',
      whereArgs: [email.trim().toLowerCase()],
      orderBy: 'created_at DESC',
    );
  }

  @override
  Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await _db;
    await db.insert(
      'transactions',
      transaction,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getFinancialTips() async {
    final db = await _db;
    return db.query(
      'financial_tips',
      orderBy: 'id ASC',
      limit: 5,
    );
  }

  @override
  Future<void> close() async {
    await _appDatabase.close();
  }
}
