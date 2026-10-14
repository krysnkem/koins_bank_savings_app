# Products Module – Specification

> Simple Feature-First structure with sealed classes for state.

---

## Folder Structure

```
lib/features/products/
├── data/
│   ├── models/
│   │   └── savings_product.dart
│   ├── datasources/
│   │   └── products_data_source.dart
│   └── repositories/
│       └── products_repository.dart
├── presentation/
│   ├── providers/
│   │   └── products_provider.dart
│   ├── screens/
│   │   ├── products_screen.dart
│   │   └── product_details_screen.dart
│   └── widgets/
└── products.dart                          # barrel file
```

Shared dependency:

```
lib/services/mock_backend_service.dart
```

---

## 1. SavingsProduct Model

**File**: `data/models/savings_product.dart`

```dart
class SavingsProduct {
  final String id;
  final String name;
  final double interestRate;       // e.g. 12.0
  final String duration;           // e.g. "12 Months" or "Flexible"
  final String shortDescription;
  final double minimumDeposit;     // e.g. 5000
}
```

**Hardcoded products**

| id | name               | interestRate | duration   | shortDescription                                      | minimumDeposit |
|----|--------------------|--------------|------------|-------------------------------------------------------|----------------|
| 1  | Target Savings     | 12           | 12 Months  | Save towards a specific goal with competitive returns.| 5000           |
| 2  | Fixed Deposit      | 18           | 6 Months   | Lock funds for a fixed period and earn higher interest.| 5000          |
| 3  | Education Savings  | 10           | Flexible   | Flexible savings plan designed for education goals.   | 5000           |
| 4  | Vacation Savings   | 8            | Flexible   | Build your travel fund at your own pace.              | 5000           |

---

## 2. MockBackendService (Products portion)

```dart
Future<List<SavingsProduct>> getSavingsProducts()
```

**Behaviour**
1. If `!isNetworkAvailable` → throw `NetworkException`
2. Artificial delay (~800ms)
3. Return the hardcoded list of 4 products

---

## 3. ProductsRemoteDataSource

Abstract `ProductsRemoteDataSource`, concrete `ProductsRemoteDataSourceImpl(BackendService)`.

Methods: `getSavingsProducts()`, `getProductById(String id)`.

## 4. ProductsRepository

Abstract `ProductsRepository` (`getProducts`, `getProductById`). Concrete `ProductsRepositoryImpl` depends only on the data-source abstraction. The notifier depends on `ProductsRepository`, not the impl.

---

## 5. ProductsProvider (Riverpod)

**File**: `presentation/providers/products_provider.dart`

### ProductsState (Sealed Classes)

```dart
sealed class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<SavingsProduct> products;
  const ProductsLoaded(this.products);
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
}
```

### Methods
- `loadProducts()`

**Behaviour**
- Emit `ProductsLoading` → call repository → emit `ProductsLoaded` or `ProductsError`

---

## 6. Screens

### ProductsScreen
**File**: `presentation/screens/products_screen.dart`

- AppBar: “Savings Products” + back
- Vertical list of product cards
- Each card shows:
  - Product name
  - Interest rate (highlighted green)
  - Short description
  - Duration
  - “View Details” button
- States: Loading / Loaded / Error / Empty

### ProductDetailsScreen
**File**: `presentation/screens/product_details_screen.dart`

- AppBar: product name or “Plan Details” + back
- Displays:
  - Plan Name
  - Interest Rate
  - Minimum Deposit (₦5,000)
  - Duration
  - Short description
- Primary button: “Create Savings”
- On “Create Savings” → navigate to Create Savings screen (pre-select this product)

---

## 7. Acceptance Criteria

- [ ] Shows 4 products with correct data
- [ ] Offline → error state with retry
- [ ] Tap card / “View Details” → Details screen
- [ ] “Create Savings” → navigates to Create Savings (product pre-selected)
- [ ] Loading and error states work correctly

---

## Implementation Order

1. `SavingsProduct` model
2. `MockBackendService.getSavingsProducts()`
3. `ProductsDataSource` + `ProductsRepository`
4. `ProductsProvider`
5. `ProductsScreen`
6. `ProductDetailsScreen`
7. Barrel file
