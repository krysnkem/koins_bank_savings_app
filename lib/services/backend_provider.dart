import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backend_service.dart';
import 'database/database_provider.dart';
import 'mock_backend_service.dart';

/// Riverpod provider exposing [BackendService], injecting the abstracted [DatabaseService].
final backendServiceProvider = Provider<BackendService>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return MockBackendService(databaseService: dbService);
});
