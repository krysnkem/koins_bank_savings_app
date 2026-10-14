import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'backend_service.dart';
import 'database/database_provider.dart';
import 'mock_backend_service.dart';

/// Provider exposing an [http.Client] that closes cleanly on container disposal.
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Riverpod provider exposing [BackendService], injecting the abstracted [DatabaseService]
/// and [http.Client] for remote API integration.
final backendServiceProvider = Provider<BackendService>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  final httpClient = ref.watch(httpClientProvider);
  return MockBackendService(
    databaseService: dbService,
    httpClient: httpClient,
  );
});
