# Savings Module – Specification

> Simple Feature-First structure with sealed classes for state.

---

## Folder Structure

```
lib/features/savings/
├── data/
│   ├── models/
│   │   └── savings_plan.dart
│   ├── datasources/
│   │   └── savings_data_source.dart
│   └── repositories/
│       └── savings_repository.dart
├── presentation/
│   ├── providers/
│   │   └── savings_provider.dart
│   ├── screens/
│   │   └── create_savings_screen.dart
│   └── widgets/
└── savings.dart                           # barrel file
```

Shared dependency:

```
lib/services/mock_backend_service.dart
```

---

## 1. SavingsPlan Model

**File**: `data/models/savings_plan.dart`

```dart
class SavingsPlan {
  final String id;
  final String name;
  final String productType;          // e.g. "Target Savings"
  final double targetAmount;
  final double monthlyContribution;
  final String duration;
  final DateTime createdAt;
}
```

---

## 2. MockBackendService (Savings portion)

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

**Behaviour**
1. If `!isNetworkAvailable` → throw `NetworkException`
2. Artificial delay (~800ms)
3. `createSavingsPlan` → add to in-memory list + return the plan
4. `getUserSavingsPlans` → return current list (seed with 3 mock plans if empty)

**Initial mock plans** (for Dashboard Recent Savings)
- Emergency Fund – ₦120,000 – Monthly
- Holiday Trip – ₦85,000 – Monthly
- New Laptop – ₦45,000 – Weekly

---

## 3. Data sources (abstract + concrete)

| Role | Abstract | Concrete | Depends on |
|---|---|---|---|
| Remote | `SavingsRemoteDataSource` | `SavingsRemoteDataSourceImpl` | `BackendService` |
| Local | `SavingsLocalDataSource` | `SavingsLocalDataSourceImpl` | SharedPreferences / Hive |

Remote: `getSavingsPlans`, `createSavingsPlan(...)`.
Local: `savePlans`, `getPlans`, `addPlan`.

## 4. SavingsRepository

Abstract `SavingsRepository`: `getPlans`, `createPlan(...)`.
Concrete `SavingsRepositoryImpl` takes both data-source abstractions. It writes locally only after the remote call succeeds. The notifier depends on `SavingsRepository`.

---

## 5. SavingsProvider (Riverpod)

**File**: `presentation/providers/savings_provider.dart`

### SavingsState (Sealed Classes)

```dart
sealed class SavingsState {
  const SavingsState();
}

class SavingsInitial extends SavingsState {
  const SavingsInitial();
}

class SavingsLoading extends SavingsState {
  const SavingsLoading();
}

class SavingsLoaded extends SavingsState {
  final List<SavingsPlan> plans;
  const SavingsLoaded(this.plans);
}

class SavingsCreated extends SavingsState {
  const SavingsCreated();
}

class SavingsError extends SavingsState {
  final String message;
  const SavingsError(this.message);
}
```

### Methods
- `loadPlans()`
- `createPlan({name, productType, targetAmount, monthlyContribution, duration})`

**Behaviour**
- `createPlan` → emit `SavingsLoading` → call repository → emit `SavingsCreated` (then usually reload or navigate)
- On error → emit `SavingsError`

---

## 6. CreateSavingsScreen

**File**: `presentation/screens/create_savings_screen.dart`

**UI**
- AppBar: “Create Savings Plan” + back
- Form fields (scrollable):
  - Savings Name (text)
  - Product Type (dropdown – populated from Products)
  - Target Amount (number)
  - Monthly Contribution (number)
  - Duration (text or dropdown)
- Primary button: “Create”

**Logic**
- All fields required
- Amounts must be valid positive numbers
- On submit → validate → call `savingsProvider.createPlan(...)`
- Success → show SnackBar “Savings Created Successfully” → navigate back to Dashboard
- Pre-select product when navigated from Product Details

**States**
- Default
- Validation errors under fields
- Loading (button spinner)
- Error (SnackBar)

---

## 7. Acceptance Criteria

- [ ] All fields required validation works
- [ ] Success message “Savings Created Successfully” shown
- [ ] Returns to Dashboard after success
- [ ] Plan is persisted and appears in Recent Savings
- [ ] Offline → error shown
- [ ] Product pre-selected when coming from Details
- [ ] Loading state works correctly

---

## Implementation Order

1. `SavingsPlan` model
2. `MockBackendService` savings methods
3. `SavingsDataSource` + `SavingsRepository`
4. `SavingsProvider`
5. `CreateSavingsScreen`
6. Barrel file
