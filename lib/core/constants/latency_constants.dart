/// Centralized latency constants for simulating asynchronous operations across the application.
class LatencyConstants {
  LatencyConstants._();

  static const Duration defaultBackend = Duration(milliseconds: 750);
  static const Duration defaultDisk = Duration(milliseconds: 400);

  /// Latency for simulated backend API operations (e.g., authentication, fetching products, creating plans).
  /// 750ms provides a comfortably obvious, realistic loading state for fintech UI.
  static Duration backend = defaultBackend;

  /// Latency for local disk I/O operations (e.g., SharedPreferences read/write).
  /// 400ms provides a noticeably realistic disk persistence duration.
  static Duration disk = defaultDisk;

  /// Resets latencies back to their standard values.
  static void reset() {
    backend = defaultBackend;
    disk = defaultDisk;
  }

  /// Sets all latencies to zero for fast, deterministic unit and widget testing.
  static void disableForTesting() {
    backend = Duration.zero;
    disk = Duration.zero;
  }
}
