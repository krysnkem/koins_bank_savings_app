import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Database manager for Koins Savings App.
/// Manages SQLite tables: users, savings_products, savings_plans, transactions, and financial_tips.
/// Specifically scoped to manage the user account: test@bank.com.
class AppDatabase {
  AppDatabase({Database? db}) : _db = db;

  static AppDatabase? _instance;
  static AppDatabase get instance => _instance ??= AppDatabase();

  Database? _db;

  /// Specifically managed user email
  static const String managedUserEmail = 'test@bank.com';

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  /// Sets up FFI for desktop or headless unit testing if necessary.
  static void ensureFfiInitialized() {
    if (!kIsWeb && (Platform.isMacOS || Platform.isLinux || Platform.isWindows)) {
      sqfliteFfiInit();
      databaseFactory = createDatabaseFactoryFfi(noIsolate: true);
    }
  }

  /// Creates an in-memory SQLite database instance for fast, isolated tests.
  static Future<AppDatabase> createInMemory() async {
    ensureFfiInitialized();
    final factory = createDatabaseFactoryFfi(noIsolate: true);
    final db = await factory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await _createTables(db);
          await _seedTables(db);
        },
      ),
    );
    return AppDatabase(db: db);
  }

  Future<Database> _initDatabase() async {
    ensureFfiInitialized();
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      final factory = createDatabaseFactoryFfi(noIsolate: true);
      return factory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await _createTables(db);
            await _seedTables(db);
          },
        ),
      );
    }

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'koins_savings.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedTables(db);
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        avatar_initials TEXT NOT NULL,
        created_at TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE savings_products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        interest_rate REAL NOT NULL,
        duration TEXT NOT NULL,
        short_description TEXT NOT NULL,
        minimum_deposit REAL NOT NULL,
        icon_key TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      );
    ''');

    await db.execute('''
      CREATE TABLE savings_plans (
        id TEXT PRIMARY KEY,
        user_email TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        target_amount REAL NOT NULL,
        monthly_contribution REAL NOT NULL,
        frequency TEXT NOT NULL,
        duration TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'active',
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_email) REFERENCES users (email),
        FOREIGN KEY (product_id) REFERENCES savings_products (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        user_email TEXT NOT NULL,
        plan_id TEXT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        is_credit INTEGER NOT NULL DEFAULT 1,
        status TEXT NOT NULL DEFAULT 'Completed',
        date_label TEXT NOT NULL,
        icon_key TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_email) REFERENCES users (email)
      );
    ''');

    await db.execute('''
      CREATE TABLE financial_tips (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        category TEXT NOT NULL,
        icon_key TEXT NOT NULL
      );
    ''');
  }

  static Future<void> _seedTables(Database db) async {
    final now = DateTime.now().toIso8601String();

    // 1. Seed user: test@bank.com
    await db.insert('users', {
      'id': 'usr_001',
      'email': managedUserEmail,
      'password': 'Password123',
      'full_name': 'John Doe',
      'phone': '+234 801 234 5678',
      'avatar_initials': 'JD',
      'created_at': now,
    });

    // 2. Seed savings products
    final products = [
      {
        'id': '1',
        'name': 'Target Savings',
        'interest_rate': 12.0,
        'duration': '12 Months',
        'short_description': 'Save towards a specific goal with competitive returns.',
        'minimum_deposit': 5000.0,
        'icon_key': 'flag',
        'is_active': 1,
      },
      {
        'id': '2',
        'name': 'Fixed Deposit',
        'interest_rate': 18.0,
        'duration': '6 Months',
        'short_description': 'Lock funds for a fixed period and earn higher interest.',
        'minimum_deposit': 5000.0,
        'icon_key': 'lock',
        'is_active': 1,
      },
      {
        'id': '3',
        'name': 'Education Savings',
        'interest_rate': 10.0,
        'duration': 'Flexible',
        'short_description': 'Flexible savings plan designed for education goals.',
        'minimum_deposit': 5000.0,
        'icon_key': 'school',
        'is_active': 1,
      },
      {
        'id': '4',
        'name': 'Vacation Savings',
        'interest_rate': 8.0,
        'duration': 'Flexible',
        'short_description': 'Build your travel fund at your own pace.',
        'minimum_deposit': 5000.0,
        'icon_key': 'flight',
        'is_active': 1,
      },
    ];
    for (final p in products) {
      await db.insert('savings_products', p);
    }

    // 3. Seed savings plans for test@bank.com
    final plans = [
      {
        'id': 'seed-1',
        'user_email': managedUserEmail,
        'product_id': '1',
        'product_name': 'Target Savings',
        'name': 'Emergency Fund',
        'amount': 120000.0,
        'target_amount': 500000.0,
        'monthly_contribution': 20000.0,
        'frequency': 'Monthly',
        'duration': '12 Months',
        'status': 'active',
        'created_at': now,
      },
      {
        'id': 'seed-2',
        'user_email': managedUserEmail,
        'product_id': '2',
        'product_name': 'Fixed Deposit',
        'name': 'House Savings Plan',
        'amount': 250000.0,
        'target_amount': 2000000.0,
        'monthly_contribution': 50000.0,
        'frequency': 'Monthly',
        'duration': '6 Months',
        'status': 'active',
        'created_at': now,
      },
      {
        'id': 'seed-3',
        'user_email': managedUserEmail,
        'product_id': '3',
        'product_name': 'Education Savings',
        'name': 'Education Plan',
        'amount': 180000.0,
        'target_amount': 800000.0,
        'monthly_contribution': 15000.0,
        'frequency': 'Monthly',
        'duration': 'Flexible',
        'status': 'active',
        'created_at': now,
      },
    ];
    for (final plan in plans) {
      await db.insert('savings_plans', plan);
    }

    // 4. Seed transactions for test@bank.com
    final transactions = [
      {
        'id': 'tx_001',
        'user_email': managedUserEmail,
        'plan_id': 'seed-1',
        'title': 'Emergency Fund Deposit',
        'category': 'Automatic Savings',
        'amount': 25000.0,
        'is_credit': 1,
        'status': 'Completed',
        'date_label': 'Today, 10:45 AM',
        'icon_key': 'shield',
        'created_at': now,
      },
      {
        'id': 'tx_002',
        'user_email': managedUserEmail,
        'plan_id': 'seed-2',
        'title': 'New Car Contribution',
        'category': 'Target Savings',
        'amount': 50000.0,
        'is_credit': 1,
        'status': 'Completed',
        'date_label': 'Yesterday, 02:15 PM',
        'icon_key': 'car',
        'created_at': now,
      },
      {
        'id': 'tx_003',
        'user_email': managedUserEmail,
        'plan_id': 'seed-2',
        'title': 'Monthly Interest Payout',
        'category': 'Interest Yield (12% p.a.)',
        'amount': 3750.0,
        'is_credit': 1,
        'status': 'Completed',
        'date_label': '12 Oct 2026',
        'icon_key': 'trending_up',
        'created_at': now,
      },
      {
        'id': 'tx_004',
        'user_email': managedUserEmail,
        'plan_id': 'seed-3',
        'title': 'School Fees Plan Deposit',
        'category': 'Education Savings',
        'amount': 15000.0,
        'is_credit': 1,
        'status': 'Completed',
        'date_label': '08 Oct 2026',
        'icon_key': 'school',
        'created_at': now,
      },
    ];
    for (final tx in transactions) {
      await db.insert('transactions', tx);
    }

    // 5. Seed financial tips
    final tips = [
      {
        'id': 'tip_1',
        'title': 'Pay Yourself First',
        'body': 'Before budgeting for discretionary spending, automatically route 10–20% of your earnings into high-yield savings.',
        'category': 'Budgeting',
        'icon_key': 'lightbulb',
      },
      {
        'id': 'tip_2',
        'title': 'Compound Interest Acceleration',
        'body': 'Locking funds into fixed deposits allows compound interest to generate recurring yield safely over time.',
        'category': 'Investing',
        'icon_key': 'track_changes',
      },
      {
        'id': 'tip_3',
        'title': 'Three-Month Safety Net',
        'body': 'Keep at least 3 months of basic living expenses liquid in your emergency fund for total peace of mind.',
        'category': 'Emergency Fund',
        'icon_key': 'savings',
      },
    ];
    for (final tip in tips) {
      await db.insert('financial_tips', tip);
    }
  }

  /// Closes database
  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }
}
