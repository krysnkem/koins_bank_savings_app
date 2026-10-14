import 'package:koins_savings_app/core/network/network_checker.dart';

/// Test double for NetworkChecker.
class MockNetworkChecker implements NetworkChecker {
  MockNetworkChecker({this.isOnline = true});

  bool isOnline;

  @override
  Future<bool> get isAvailable async => isOnline;
}
