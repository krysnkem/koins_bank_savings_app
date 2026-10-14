# Dashboard Module – Specification

> Simple Feature-First structure with sealed classes for state.

---

## Folder Structure

```
lib/features/dashboard/
├── data/
│   ├── models/
│   │   └── financial_tip.dart
│   ├── datasources/
│   │   └── tips_data_source.dart
│   └── repositories/
│       └── dashboard_repository.dart
├── presentation/
│   ├── providers/
│   │   └── dashboard_provider.dart
│   ├── screens/
│   │   └── dashboard_screen.dart
│   └── widgets/
└── dashboard.dart                         # barrel file
```

Shared dependencies:

```
lib/services/mock_backend_service.dart
lib/features/savings/   (for recent plans)
lib/features/auth/      (for user name)
```

---

## 1. FinancialTip Model

**File**: `data/models/financial_tip.dart`

```dart
class FinancialTip {
  final String id;
  final String title;
  final String body;
}
```

---

## 2. MockBackendService (Tips portion)

```dart
Future<List<FinancialTip>> getFinancialTips()
```

**Behaviour**
1. If `!isNetworkAvailable` → throw `NetworkException`
2. Artificial delay (~800ms)
3. Return 2–3 tips (can be hardcoded mock or mapped from dummyjson posts)

**Example tips**
- “Start small, stay consistent”
- “Emergency funds give you peace of mind”
- “Pay yourself first every month”

---

## 3. Tips + dashboard repository

- Abstract `TipsRemoteDataSource` / concrete `TipsRemoteDataSourceImpl(BackendService)`.
- Abstract `DashboardRepository` / concrete `DashboardRepositoryImpl`.
- Recent plans come from `SavingsRepository`, not from the tips source.
- `DashboardNotifier` is concrete and takes those two repository abstractions. There is no notifier abstraction.

---

## 4. DashboardProvider (Riverpod)

**File**: `presentation/providers/dashboard_provider.dart`

### DashboardState (Sealed Classes)

```dart
sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<SavingsPlan> recentPlans;
  final List<FinancialTip> tips;
  const DashboardLoaded({
    required this.recentPlans,
    required this.tips,
  });
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
}
```

### Methods
- `loadDashboard()`

**Behaviour**
- Emit `DashboardLoading`
- Fetch recent plans + tips in parallel
- Emit `DashboardLoaded` or `DashboardError`

---

## 5. DashboardScreen

**File**: `presentation/screens/dashboard_screen.dart`

**UI Hierarchy**
1. AppBar: “Dashboard” (optional logo / profile icon)
2. Greeting: “Good Morning, John Doe” (time-based + user name from Auth)
3. Total Savings card
   - Label: “Total Savings”
   - Value: ₦850,000 (static for now)
4. Quick Actions row (with icons)
   - Create Savings
   - View Products
5. Section: “Recent Savings”
   - Up to 3 plan cards (name, amount, frequency)
6. Section: “Financial Tips”
   - 2–3 tip cards (title + body)
7. Bottom safe area

**Interactions**
- Create Savings → CreateSavingsScreen
- View Products → ProductsScreen
- Profile icon (optional) → ProfileScreen

**States**
- Loading (full screen or section-level)
- Loaded
- Error on tips section (can still show the rest of the dashboard)
- Empty recent savings

---

## 6. Acceptance Criteria

- [ ] Greeting shows correct time of day + user name
- [ ] Total Savings displays ₦850,000
- [ ] Quick actions navigate correctly
- [ ] Recent Savings shows up to 3 plans
- [ ] Financial Tips load from backend
- [ ] Offline → tips section shows error (rest of UI still usable)
- [ ] Loading state works

---

## Implementation Order

1. `FinancialTip` model
2. `MockBackendService.getFinancialTips()`
3. Data source + repository
4. `DashboardProvider`
5. `DashboardScreen` + supporting widgets
6. Barrel file
