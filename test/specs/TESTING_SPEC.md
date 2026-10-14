# Testing Specification – Koins Savings App

> Bonus feature from the assessment.  
> Focus on high-value, maintainable tests rather than 100% coverage.

---

## Goals

1. Prove the most critical business logic works
2. Catch regressions in validation, auth flow, and persistence
3. Keep the suite fast and easy to run (`flutter test`)

---

## Test Pyramid (what we will write)

| Layer              | Type            | Priority | Approx. count |
|--------------------|-----------------|----------|---------------|
| Domain / Data      | Unit tests      | High     | 12–18         |
| Presentation logic | Unit / Provider | Medium   | 6–10          |
| UI                 | Widget tests    | Medium   | 4–6           |
| End-to-end         | Integration     | Low      | 0 (skip for assessment) |

---

## Folder Structure

```
test/
├── specs/
│   └── TESTING_SPEC.md              ← this file
├── helpers/
│   ├── mock_backend_service.dart    ← test double
│   ├── mock_network_checker.dart
│   └── test_utils.dart
├── unit/
│   ├── core/
│   │   └── network_checker_test.dart
│   ├── services/
│   │   └── mock_backend_service_test.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── auth_repository_test.dart
│   │   │   └── auth_local_data_source_test.dart
│   │   ├── products/
│   │   │   └── products_repository_test.dart
│   │   └── savings/
│   │       └── savings_repository_test.dart
│   └── utils/
│       ├── validators_test.dart
│       └── formatters_test.dart
├── widget/
│   ├── login_screen_test.dart
│   ├── create_savings_screen_test.dart
│   └── common/
│       ├── empty_state_test.dart
│       └── error_state_test.dart
└── README.md                        ← how to run the tests
```

---

## 1. Unit Tests – Core & Services

### 1.1 NetworkChecker
- Returns `true` when connectivity is available
- Returns `false` when `ConnectivityResult.none`

### 1.2 MockBackendService

| Test case                                      | Expected result                          |
|------------------------------------------------|------------------------------------------|
| `login` with correct credentials               | Returns `AuthUser`                       |
| `login` with wrong credentials                 | Throws `AuthException`                   |
| `login` when `forceOffline = true`             | Throws `NetworkException`                |
| `getSavingsProducts`                           | Returns list of 4 products               |
| `getProductById` with valid id                 | Returns the product                      |
| `getProductById` with invalid id               | Throws `ServerException`                 |
| `createSavingsPlan`                            | Returns plan and adds it to in-memory list |
| `getFinancialTips` (mocked HTTP)               | Returns mapped tips                      |
| Any method when offline                        | Throws `NetworkException`                |

> Use constructor injection of a fake `NetworkChecker` and a fake `http.Client`.

---

## 2. Unit Tests – Feature Repositories

### 2.1 AuthRepository

| Test case                                      | Expected result                          |
|------------------------------------------------|------------------------------------------|
| `login` success                                | Calls remote → saves session → returns user |
| `login` failure (AuthException)                | Does **not** save session, rethrows      |
| `login` failure (NetworkException)             | Does **not** save session, rethrows      |
| `logout`                                       | Clears local session                     |
| `getCurrentUser` when logged in                | Returns user from local                  |
| `getCurrentUser` when logged out               | Returns `null`                           |
| `isLoggedIn`                                   | Reflects local storage                   |

### 2.2 ProductsRepository
- `getProducts` returns the list from remote
- Propagates `NetworkException` / `ServerException`

### 2.3 SavingsRepository
- `getPlans` returns remote (or cached) list
- `createPlan` calls remote then persists locally
- Offline behaviour

---

## 3. Unit Tests – Utils

### 3.1 Validators
- Email required / invalid format / valid
- Password required / too short / valid
- Amount required / zero / negative / valid

### 3.2 Formatters
- `formatNaira(850000)` → `₦850,000`
- Handles 0, decimals, large numbers

---

## 4. Widget Tests

### 4.1 LoginScreen
- Renders logo, title, two fields, Login button
- Shows validation errors when submitting empty form
- Shows loading state on the button when provider is loading
- Calls login on valid submit
- Shows SnackBar on auth error (use `ProviderScope` overrides)

### 4.2 CreateSavingsScreen
- All 5 fields are present
- Validation errors appear for empty fields
- Submit button shows loading state
- Success triggers navigation / SnackBar (mock the provider)

### 4.3 Common widgets
- `EmptyState` shows title + optional action
- `ErrorState` shows message + Retry button and calls callback

---

## 5. Test Helpers

```dart
// test/helpers/mock_network_checker.dart
class MockNetworkChecker implements NetworkChecker {
  bool isOnline = true;
  @override
  Future<bool> get isAvailable async => isOnline;
}

// test/helpers/test_utils.dart
ProviderContainer createContainer({
  List<Override> overrides = const [],
}) { ... }
```

Always override `mockBackendServiceProvider` and any local storage providers in tests so they never hit real SharedPreferences or the real network.

---

## 6. Running the Tests

```bash
# All tests
flutter test

# Only unit
flutter test test/unit

# Only widget
flutter test test/widget

# Single file
flutter test test/unit/features/auth/auth_repository_test.dart
```

---

## 7. Acceptance Criteria (Testing)

- [ ] `flutter test` passes with zero failures
- [ ] Critical paths covered: login success/failure, session persistence, create plan, product list
- [ ] Validators and Naira formatter have unit tests
- [ ] At least Login and Create Savings have widget tests
- [ ] No real network or real SharedPreferences is hit during tests
- [ ] Tests are fast (< 5 seconds for the whole suite on a normal machine)

---

## 8. Implementation Order

1. Test helpers + mock NetworkChecker
2. `MockBackendService` unit tests
3. Validators + Formatters
4. AuthRepository tests
5. Products + Savings repository tests
6. LoginScreen widget test
7. CreateSavingsScreen widget test
8. Common widget tests

---

## Notes

- Prefer `mockito` or manual fakes over heavy code generation for this assessment.
- Keep widget tests focused on behaviour, not pixel-perfect layout.
- Do **not** write golden tests unless time permits (nice-to-have only).
```
