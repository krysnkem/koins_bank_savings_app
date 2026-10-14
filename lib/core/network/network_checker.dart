/// Connectivity check used by the backend. Callers depend on this type,
/// never on [NetworkCheckerImpl].
abstract class NetworkChecker {
  Future<bool> get isAvailable;
}

class NetworkCheckerImpl implements NetworkChecker {
  const NetworkCheckerImpl();

  @override
  Future<bool> get isAvailable {
    // TODO: connectivity_plus Connectivity().checkConnectivity()
    // TODO: return false when the result contains ConnectivityResult.none
    throw UnimplementedError();
  }
}
