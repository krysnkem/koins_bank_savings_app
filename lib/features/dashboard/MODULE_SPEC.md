# Dashboard Module – Specification

> Simple Feature-First structure with sealed classes for state.

---

## Folder Structure

```
lib/features/dashboard/
├── data/
│   ├── models/
│   │   └── dummy_post.dart
│   ├── datasources/
│   │   └── posts_remote_data_source.dart
│   └── repositories/
│       ├── posts_repository.dart
│       └── dashboard_repository.dart
├── presentation/
│   ├── providers/
│   │   ├── posts_state.dart
│   │   ├── posts_provider.dart
│   │   ├── dashboard_state.dart
│   │   └── dashboard_provider.dart
│   ├── screens/
│   │   └── dashboard_screen.dart
│   └── widgets/
│       ├── dashboard_header_section.dart
│       ├── dashboard_quick_actions_section.dart
│       ├── dashboard_recent_savings_section.dart
│       └── dashboard_posts_section.dart
└── dashboard.dart                         # barrel file
```

Shared dependencies:

```
lib/services/mock_backend_service.dart
lib/features/savings/   (for recent plans)
lib/features/auth/      (for user name)
```

---

## 1. DummyPost Model

**File**: `data/models/dummy_post.dart`

```dart
class DummyPost {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int views;
}
```

---

## 2. MockBackendService (DummyJSON Posts portion)

```dart
Future<List<DummyPost>> getPosts()
```

**Behaviour**
1. If `!isNetworkAvailable` → throw `NetworkException`
2. Fetch live data from `https://dummyjson.com/posts?limit=3`
3. Returns parsed List<DummyPost> directly from the REST API without database persistence

---

## 3. Posts + Dashboard Repository

- Abstract `PostsRemoteDataSource` / concrete `PostsRemoteDataSourceImpl(BackendService)`.
- Abstract `PostsRepository` / concrete `PostsRepositoryImpl(PostsRemoteDataSource)`.
- Abstract `DashboardRepository` / concrete `DashboardRepositoryImpl(SavingsRepository, PostsRepository)`.
- `PostsNotifier` consumes `PostsRepository`.
- `DashboardNotifier` consumes `DashboardRepository` which aggregates plans and posts into `DashboardData`.

---

## 4. Dashboard & Posts Providers (Riverpod)

**Files**:
- `presentation/providers/posts_state.dart`
- `presentation/providers/posts_provider.dart`
- `presentation/providers/dashboard_state.dart`
- `presentation/providers/dashboard_provider.dart`

### Sealed Classes for State
- `PostsState`: `PostsInitial`, `PostsLoading`, `PostsLoaded(posts)`, `PostsError(message)`
- `DashboardState`: `DashboardInitial`, `DashboardLoading`, `DashboardLoaded(recentPlans, posts)`, `DashboardError(message)`

---

## 5. DashboardScreen

**File**: `presentation/screens/dashboard_screen.dart`

**UI Hierarchy**
1. DashboardHeaderSection: Greeting + Total Savings Card
2. DashboardQuickActionsSection: Create Savings, View Products
3. DashboardRecentSavingsSection: Up to 3 recent savings plan cards
4. DashboardPostsSection: "Posts from Dummy JSON" section with REST API tag badge, 3 post cards with tags and view counts

---

## 6. Acceptance Criteria

- [x] Greeting shows correct time of day + user name
- [x] Total Savings displays ₦850,000 with animated counter
- [x] Quick actions navigate correctly
- [x] Recent Savings shows up to 3 plans
- [x] Posts from Dummy JSON load from live REST API / SQLite fallback
- [x] Offline → posts section shows error/retry (rest of UI still usable)
- [x] Independent loading shimmer states
