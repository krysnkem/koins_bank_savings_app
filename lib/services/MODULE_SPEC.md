# MockBackendService – Specification

> Single “fake API” that answers every network request in the app.  
> Pragmatic choice for a 6–8 hour assessment.  
> Acts as the remote source of truth for Auth, Products, Savings Plans and Tips.

---

## Location

```
lib/services/backend_service.dart          ← abstract
lib/services/mock_backend_service.dart      ← concrete
lib/core/network/network_checker.dart       ← abstract + NetworkCheckerImpl
```

Feature data sources depend on `BackendService`, never on `MockBackendService`.

---

## Dependencies

| Package / File              | Purpose                                      |
|-----------------------------|----------------------------------------------|
| `connectivity_plus`         | Real device connectivity status              |
| `http` or `dio`             | Real call to dummyjson for Financial Tips    |
| `NetworkException`          | Thrown when offline                          |
| `AuthException`             | Thrown on bad credentials                    |
| `ServerException`           | Thrown on not-found / HTTP / parsing errors  |
| `AppConstants`              | Mock credentials & user data                 |

---

## Class Skeleton

```dart
class MockBackendService {
  MockBackendService({
    NetworkChecker? networkChecker,
    http.Client? httpClient,
  })  : _networkChecker = networkChecker ?? NetworkChecker(),
        _httpClient = httpClient ?? http.Client();

  final NetworkChecker _networkChecker;
  final http.Client _httpClient;

  /// Demo / test override – when true every call throws NetworkException
  bool forceOffline = false;

  // ── Private helpers ──────────────────────────────────
  Future<void> _ensureOnline();
  Future<void> _simulateLatency([int ms = 700]);

  // ── Auth ─────────────────────────────────────────────
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  // ── Products ─────────────────────────────────────────
  Future<List<SavingsProduct>> getSavingsProducts();
  Future<SavingsProduct> getProductById(String id);

  // ── Savings Plans ────────────────────────────────────
  Future<List<SavingsPlan>> getSavingsPlans();
  Future<SavingsPlan> createSavingsPlan({
    required String name,
    required String productId,
    required double targetAmount,
    required double monthlyContribution,
    required String duration,
  });

  // ── Tips (real API integration) ──────────────────────
  Future<List<FinancialTip>> getFinancialTips();
}
```

---

## 1. Network Layer

### NetworkChecker (thin wrapper)

**File**: `lib/core/network/network_checker.dart`

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  Future<bool> get isAvailable async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
```

### _ensureOnline()

```dart
Future<void> _ensureOnline() async {
  if (forceOffline || !(await _networkChecker.isAvailable)) {
    throw const NetworkException('No internet connection');
  }
}
```

### _simulateLatency()

```dart
Future<void> _simulateLatency([int ms = 700]) async {
  await Future.delayed(Duration(milliseconds: ms));
}
```

**Rule**: Every public method **must** call `_ensureOnline()` first, then `_simulateLatency()`.

---

## 2. Auth

### Method

```dart
Future<AuthUser> login({
  required String email,
  required String password,
})
```

### Behaviour

1. `await _ensureOnline()`
2. `await _simulateLatency()`
3. If `email == AppConstants.mockEmail && password == AppConstants.mockPassword`  
   → return  
   ```dart
   AuthUser(
     fullName: AppConstants.mockUserName,   // John Doe
     email: AppConstants.mockUserEmail,     // test@bank.com
     phone: AppConstants.mockUserPhone,     // +234 801 234 5678
   )
   ```
4. Otherwise → throw `AuthException('Invalid email or password')`

> **Important**  
> Session persistence (SharedPreferences / Hive) is **not** the responsibility of this service.  
> The AuthRepository / AuthLocalDataSource owns the logged-in user session.

---

## 3. Products

### Hardcoded data (owned by the service)

| id  | name              | interestRate | duration   | shortDescription                                       | minimumDeposit |
|-----|-------------------|--------------|------------|--------------------------------------------------------|----------------|
| `1` | Target Savings    | 12.0         | 12 Months  | Save towards a specific goal with competitive returns. | 5000           |
| `2` | Fixed Deposit     | 18.0         | 6 Months   | Lock funds for a fixed period and earn higher interest.| 5000           |
| `3` | Education Savings | 10.0         | Flexible   | Flexible savings plan designed for education goals.    | 5000           |
| `4` | Vacation Savings  | 8.0          | Flexible   | Build your travel fund at your own pace.               | 5000           |

### Methods

```dart
Future<List<SavingsProduct>> getSavingsProducts()
Future<SavingsProduct> getProductById(String id)
```

- Both call `_ensureOnline()` + `_simulateLatency()`
- `getProductById` throws `ServerException('Product not found')` if the id does not exist

---

## 4. Savings Plans

### In-memory store (owned by the service)

```dart
final List<SavingsPlan> _plans = [
  // Seed with 3 mock plans so the Dashboard is never empty on first launch
  SavingsPlan(
    id: 'seed-1',
    name: 'Emergency Fund',
    productId: '1',
    productName: 'Target Savings',
    amount: 120000,
    targetAmount: 500000,
    monthlyContribution: 20000,
    frequency: 'Monthly',
    duration: '12 Months',
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
  ),
  // … two more seed plans
];
```

### Methods

```dart
Future<List<SavingsPlan>> getSavingsPlans()

Future<SavingsPlan> createSavingsPlan({
  required String name,
  required String productId,
  required double targetAmount,
  required double monthlyContribution,
  required String duration,
})
```

**createSavingsPlan behaviour**

1. `_ensureOnline()` + latency
2. Validate that `productId` exists (otherwise `ServerException`)
3. Create a new `SavingsPlan` with:
   - generated unique id
   - current timestamp
   - product name looked up from the products list
4. Append to `_plans`
5. Return the newly created plan

> **Important**  
> Long-term local persistence (Hive / SharedPreferences) is the responsibility of the SavingsRepository / DataSource.  
> This service only acts as the “remote” source of truth for the current app session.

---

## 5. DummyJSON Posts (Real API Integration)

```dart
Future<List<DummyPost>> getPosts()
```

**Behaviour**

1. `await _ensureOnline()`
2. GET `https://dummyjson.com/posts?limit=3`
3. Parse response into `List<DummyPost>`
4. On non-200 HTTP response or network/parsing failure → throw `ServerException` or `NetworkException`

This is the **required** real REST API call demanded by the assessment. Always fetched directly from the REST API without database persistence.

---

## 6. Error Contract

| Situation                              | Exception                          |
|----------------------------------------|------------------------------------|
| No connectivity **or** `forceOffline`  | `NetworkException`                 |
| Wrong login credentials                | `AuthException`                    |
| Product / Plan not found               | `ServerException`                  |
| Database query failure                 | `ServerException`                  |
| Any unexpected error                   | `ServerException`                  |

---

## 7. Lifecycle & Registration

- Registered once as a Riverpod `Provider`:
  ```dart
  final mockBackendServiceProvider = Provider<BackendService>((ref) {
    return MockBackendService();
  });
  ```
- Lifetime = whole app session.
- `forceOffline` can be toggled from a hidden debug button or from unit tests.

---

## 8. Acceptance Criteria

- [x] Every public method checks real connectivity first (`connectivity_plus`)
- [x] Setting `forceOffline = true` makes every call throw `NetworkException`
- [x] Login succeeds **only** with `test@bank.com` / `Password123`
- [x] `getSavingsProducts()` returns products from database/in-memory
- [x] `createSavingsPlan()` adds the plan to database and returns it
- [x] `getPosts()` performs a real HTTP call to dummyjson with SQLite fallback
- [x] All methods have realistic latency (400–900 ms)
- [x] Service is easily mockable in unit tests via constructor injection of `NetworkChecker` and `http.Client`

---

## 9. Implementation Order

1. `NetworkChecker` (`lib/core/network/network_checker.dart`)
2. `MockBackendService` skeleton + private helpers
3. Auth methods
4. Products methods + hardcoded list
5. Savings Plans methods + seed data
6. Tips method (real HTTP)
7. Register as Riverpod provider
8. Update feature repositories to call this service

---

## Relationship to Feature Modules

```
┌─────────────────────┐
│   UI / Providers    │
└─────────┬───────────┘
          │
┌─────────▼───────────┐
│   Repositories      │  ← thin wrappers, one per feature
└─────────┬───────────┘
          │
┌─────────▼───────────┐
│ MockBackendService  │  ← this file (single source of truth)
└─────────────────────┘
```

Feature repositories **never** contain mock data or network simulation logic.  
They simply forward calls to `MockBackendService` and (where needed) handle local caching.
```
