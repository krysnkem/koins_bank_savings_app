import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_service.dart';
import 'sqflite_database_service.dart';

/// Riverpod provider exposing the abstracted [DatabaseService].
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return SqfliteDatabaseService();
});
