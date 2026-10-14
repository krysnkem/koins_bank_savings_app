# Koins Savings App

A fintech mobile savings application built for the **Koins MFB Flutter Developer Technical Assessment**.

> **Flutter Version**: Flutter 3.29.x (Dart 3.7.x) / Stable  
> **Target OS**: Android & iOS  
> **Design Specs**: Fully validated against [`KOINS_UI_DESIGN_SPEC_PACKAGE.md`](./specs/KOINS_UI_DESIGN_SPEC_PACKAGE.md)

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture & Project Structure](#architecture--project-structure)
3. [Design System & Theming](#design-system--theming)
4. [State Management Rationale](#state-management-rationale)
5. [Local Storage Strategy](#local-storage-strategy)
6. [Abstracted Database Architecture & SQLite Tables (`sqflite`)](#abstracted-database-architecture--sqlite-tables-sqflite)
7. [REST API Integration](#rest-api-integration)
8. [Mock Credentials](#mock-credentials)
9. [Testing & Quality Assurance](#testing--quality-assurance)
10. [Getting Started & Build Instructions](#getting-started--build-instructions)
11. [Screenshots & Visual Showcase](#screenshots--visual-showcase)
12. [Assumptions & Future Improvements](#assumptions--future-improvements)
13. [Deliverables Checklist](#deliverables-checklist)

---

## Project Overview

The **Koins Savings App** allows digital banking customers to:
- Securely log in using email and password with instant client-side validation.
- View a personalized savings dashboard with total balance, quick actions, recent savings plans, and financial insights.
- Browse interest-bearing savings products with competitive tiered rates.
- Inspect product details, minimum deposits, and tenure.
- Create new customized savings plans with real-time target and monthly contribution configurations.
- View and manage user profile information and log out securely.

---

## Architecture & Project Structure

The project employs **Feature-First Clean Architecture**, combining clean domain separation with feature grouping for maximum maintainability and scalability:

```
lib/
├── core/
│   ├── constants/             # AppConstants (credentials, keys, mock URLs)
│   ├── errors/                # AppException hierarchy (AuthException, NetworkException, ServerException)
│   ├── network/               # NetworkChecker abstraction & connectivity implementation
│   ├── router/                # go_router declarative routing:
│   │   ├── app_router.dart    # StatefulShellRoute.indexedStack & route declarations
│   │   └── main_shell_screen.dart # Persistent bottom navigation shell
│   ├── session/               # UiSession presentation state & mock seeds
│   ├── theme/                 # Centralized Design System:
│   │   ├── app_colors.dart    # Strict brand color tokens
│   │   ├── app_radius.dart    # Tokenized border radius definitions
│   │   ├── app_shadows.dart   # Elevation & card shadow definitions
│   │   ├── app_spacing.dart   # Standard layout spacing grid
│   │   ├── app_text_styles.dart # Fintech typography hierarchy (Inter)
│   │   └── app_theme.dart     # Material 3 ThemeData configuration
│   └── utils/                 # Validators, formatters (Naira, percentages, dates)
├── features/
│   ├── auth/                  # Authentication & Profile domain
│   │   ├── data/              # Auth models, datasources, and repository
│   │   └── presentation/      # LoginScreen, ProfileScreen
│   ├── dashboard/             # Financial dashboard domain
│   │   ├── data/              # DummyPost model, posts datasource, repository
│   │   └── presentation/      # DashboardScreen, widgets, providers
│   ├── products/              # Savings Products domain
│   │   ├── data/              # SavingsProduct model, datasource, repository
│   │   └── presentation/      # ProductsScreen, ProductDetailsScreen, ProductCard
│   └── savings/               # Savings Plan creation & management domain
│       ├── data/              # SavingsPlan model, local/remote datasources, repository
│       └── presentation/      # CreateSavingsScreen, SavingsPlansScreen
├── services/                  # BackendService contract & MockBackendService implementation
├── repositories/              # Repository exports & contracts
├── widgets/
│   ├── common/                # Reusable UI components (buttons, input fields, error states)
│   └── savings/               # Reusable savings domain cards & chips
└── main.dart                  # Application entry point & Riverpod ProviderScope
```

---

## Design System & Theming

The application enforces a **100% tokenized design system** with zero raw numeric border radiuses and zero inline hex colors:

| Token | Value | Semantic Usage |
| :--- | :--- | :--- |
| `AppColors.primary` | `#0B9234` | Brand emerald green, primary buttons, active tabs |
| `AppColors.primaryDark` | `#076B26` | Button pressed states & dark accents |
| `AppColors.secondary` | `#0F766E` | Deep teal secondary accents |
| `AppColors.background` | `#FFFFFF` | Clean white canvas background |
| `AppColors.surface` | `#FFFFFF` | Card surfaces with subtle elevation |
| `AppColors.textPrimary` | `#111827` | Headings, hero numbers, and primary labels |
| `AppColors.textSecondary` | `#6B7280` | Subtitles, helper text, and secondary details |
| `AppColors.cardBorder` | `#F3F4F6` | Subtle border for card containers |

### Depth & Elevation
- **Card Shadow**: `AppShadows.card` — subtle blur ($16\text{px}$) with gentle vertical offset ($4\text{px}$) and $5\%$ black opacity.
- **Elevation Glow**: `AppShadows.avatarGlow` — subtle $15\%$ primary green glow for the profile avatar and key badges.
- **Border Radius**: Tokenized via `AppRadius` (`AppRadius.card`, `AppRadius.button`, `AppRadius.input`, `AppRadius.pill`).

---

## Routing & Navigation Architecture (`go_router`)

The application implements declarative routing powered by **`go_router`** and Flutter's Router API:

- **Stateful Bottom Navigation**: Uses `StatefulShellRoute.indexedStack` paired with `StatefulNavigationShell` in [MainShellScreen](file:///Users/Chris/magic/koins_savings_app/lib/core/router/main_shell_screen.dart).
- **Independent Branch Preservation**: 4 separate branches (`Dashboard`, `Savings / Products`, `My Savings`, `More / Profile`), each with its own `GlobalKey<NavigatorState>`. Switching tabs preserves scroll positions, input states, and loaded data without rebuilds or re-fetching.
- **Root Navigator Overlays**: Modal flows such as **Product Details** (`/product/:id`) and **Create Savings Plan** (`/create`) declare `parentNavigatorKey: rootNavigatorKey`, ensuring they slide over the bottom navigation bar as clean, focused full-screen experiences.
- **Deep Linking Ready**: All destinations are URL-addressable (`/dashboard`, `/products`, `/my-savings`, `/profile`, `/product/:id`, `/create`). Legacy routes (`/transactions`, `/savings-plans`) gracefully redirect to `/my-savings`.

---

## State Management Rationale

**Riverpod (`flutter_riverpod`)** was selected as the state management solution for the following architectural benefits:

1. **Compile-Time Safety & Zero BuildContext Entanglement**: Providers can be declared globally and accessed safely without runtime `ProviderNotFoundException` or context lifecycle issues.
2. **Immutable State Transitions**: Uses Riverpod 2.0+ `Notifier` and immutable state models (`copyWith`), making state changes predictable and debuggable.
3. **Effortless Testability**: Providers and repositories can be overridden cleanly in unit and widget tests without spinning up a full widget tree.
4. **Clean Async Data Handling**: Supports declarative loading, success, and error states for REST API calls and asynchronous storage operations.

---

## Local Storage Strategy

The application uses **`shared_preferences`** for real disk persistence:
1. **User Authentication Session**: Retains login status, email, and user profile data across app restarts via `AuthLocalDataSource`.
2. **Created Savings Plans**: Serializes user-created savings plans to JSON and persists them directly to disk via `SavingsLocalDataSource` (storage key `'saved_savings_plans'`). When a user creates a new savings plan, it is immediately written to disk and loaded into both the Dashboard recent list and the My Savings screen.

---

## Abstracted Database Architecture & SQLite Tables (`sqflite`)

To eliminate code-level hardcoding and simulate realistic network calls against a persistent data store, all application data is managed via an **Abstracted Database Service** backed by **SQLite** (`sqflite` on mobile devices and `sqflite_common_ffi` with `noIsolate: true` for headless testing).

### Architecture & Abstraction Layer

The design adheres to strict Dependency Inversion:
```
UI / Screens (ConsumerWidget)
       │
       ▼
Riverpod Notifiers (AutoDisposeNotifier)
       │
       ▼
Feature Repositories (SavingsRepository, AuthRepository, TransactionsRepository)
       │
       ▼
Backend Service Contract (BackendService / MockBackendService)
  [Simulates configurable network latency & offline checks]
       │
       ▼
Abstracted Database Service (DatabaseService)
       │
       ▼
Concrete SQLite Implementation (SqfliteDatabaseService -> AppDatabase)
  [Tables: users, savings_products, savings_plans, transactions, dummy_posts]
```

- **`DatabaseService` Interface (`lib/services/database/database_service.dart`)**:
  Defines asynchronous contracts for users, products, savings plans, transactions, and posts. Higher layers never execute raw SQL statements directly.
- **`SqfliteDatabaseService` (`lib/services/database/sqflite_database_service.dart`)**:
  Implements `DatabaseService` using parameterized SQL queries and typed schema mappings.
- **`MockBackendService` (`lib/services/mock_backend_service.dart`)**:
  Consumes `DatabaseService`, checks network connectivity (`NetworkChecker`), simulates network latency (`LatencyConstants.backend`), and isolates data specifically for `test@bank.com`.

---

### Database Tables & Schema

The database strictly manages the primary account: **`test@bank.com`**.

#### 1. `users` Table
Stores authenticated customer credentials and profile metadata.
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `TEXT` | `PRIMARY KEY` | Unique user identifier (`usr_001`) |
| `email` | `TEXT` | `UNIQUE NOT NULL` | Scoped account email (`test@bank.com`) |
| `password` | `TEXT` | `NOT NULL` | Account password (`Password123`) |
| `full_name` | `TEXT` | `NOT NULL` | Customer name (`John Doe`) |
| `phone` | `TEXT` | `NOT NULL` | Customer phone (`+234 801 234 5678`) |
| `avatar_initials` | `TEXT` | `NOT NULL` | Display avatar text (`JD`) |
| `created_at` | `TEXT` | `NOT NULL` | ISO 8601 registration timestamp |

#### 2. `savings_products` Table
Stores interest-bearing products offered to customers.
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `TEXT` | `PRIMARY KEY` | Product ID (`1`, `2`, `3`, `4`) |
| `name` | `TEXT` | `NOT NULL` | Product name (e.g. *Target Savings*, *Fixed Deposit*) |
| `interest_rate` | `REAL` | `NOT NULL` | Annual interest percentage (e.g. `12.0`, `18.0`) |
| `duration` | `TEXT` | `NOT NULL` | Default tenure label (`12 Months`, `6 Months`, `Flexible`) |
| `short_description`| `TEXT` | `NOT NULL` | Brief marketing summary |
| `minimum_deposit`| `REAL` | `NOT NULL` | Minimum required opening deposit (`5000.0`) |
| `icon_key` | `TEXT` | `NOT NULL` | Associated iconography identifier |
| `is_active` | `INTEGER` | `NOT NULL DEFAULT 1` | Product availability flag (1 = active) |

#### 3. `savings_plans` Table
Stores all active savings plans created for `test@bank.com`.
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `TEXT` | `PRIMARY KEY` | Plan ID (e.g. `seed-1`, `plan-179...`) |
| `user_email` | `TEXT` | `NOT NULL, FK -> users(email)` | Plan owner email |
| `product_id` | `TEXT` | `NOT NULL, FK -> savings_products(id)`| Associated product ID |
| `product_name` | `TEXT` | `NOT NULL` | Snapshot product title |
| `name` | `TEXT` | `NOT NULL` | Custom plan name (e.g. *Emergency Fund*, *House Savings Plan*) |
| `amount` | `REAL` | `NOT NULL` | Current accumulated savings amount in Naira |
| `target_amount` | `REAL` | `NOT NULL` | User target savings goal amount |
| `monthly_contribution` | `REAL` | `NOT NULL` | Configured monthly recurring deposit |
| `frequency` | `TEXT` | `NOT NULL` | Contribution cadence (`Monthly`) |
| `duration` | `TEXT` | `NOT NULL` | Configured duration (`12 Months`, `6 Months`, etc.) |
| `status` | `TEXT` | `NOT NULL DEFAULT 'active'` | Current status (`active`, `completed`) |
| `created_at` | `TEXT` | `NOT NULL` | ISO 8601 creation timestamp |

#### 4. `transactions` Table
Stores transaction ledger records (deposits, yields, creations).
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `TEXT` | `PRIMARY KEY` | Transaction identifier (`tx_001`, `tx-...`) |
| `user_email` | `TEXT` | `NOT NULL, FK -> users(email)` | Associated account email |
| `plan_id` | `TEXT` | `NULLABLE` | Associated savings plan ID if applicable |
| `title` | `TEXT` | `NOT NULL` | Headline title (e.g. *Emergency Fund Deposit*) |
| `category` | `TEXT` | `NOT NULL` | Categorization (e.g. *Automatic Savings*, *Target Savings*) |
| `amount` | `REAL` | `NOT NULL` | Transaction amount in Naira |
| `is_credit` | `INTEGER` | `NOT NULL DEFAULT 1` | 1 = Inflow (credit), 0 = Outflow (debit) |
| `status` | `TEXT` | `NOT NULL DEFAULT 'Completed'` | Transaction state |
| `date_label` | `TEXT` | `NOT NULL` | Human-readable date label |
| `icon_key` | `TEXT` | `NOT NULL` | Icon identifier for visual presentation |
| `created_at` | `TEXT` | `NOT NULL` | ISO 8601 timestamp |

#### 5. `dummy_posts` Table
Stores fallback and cached posts from the public DummyJSON REST API (`https://dummyjson.com/posts`) displayed under the **"Posts from Dummy JSON"** dashboard section.
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `TEXT` | `PRIMARY KEY` | Post identifier (`1`, `2`, `3`) |
| `title` | `TEXT` | `NOT NULL` | Post title |
| `body` | `TEXT` | `NOT NULL` | Post content snippet |
| `tags` | `TEXT` | `NULLABLE` | Comma-delimited list of tags |
| `views` | `INTEGER` | `NOT NULL DEFAULT 0` | View count |

---

## REST API Integration

- **Endpoint**: Integrates with the public REST API (`https://dummyjson.com/posts?limit=3`) to dynamically retrieve and display live **Posts from Dummy JSON** on the Dashboard.
- **Resilience**: Implements full loading shimmers, network timeout handling, automatic SQLite local caching fallback, and user-friendly error banners with one-tap retry functionality.

---

## Mock Credentials

For evaluation and testing:
```
Email:    test@bank.com
Password: Password123
```
*Form validation enforces valid RFC 5322 email syntax and a minimum 8-character password.*

---

## Testing & Quality Assurance

### Static Analysis
```bash
fvm flutter analyze
# Output: No issues found! (0 warnings, 0 errors)
```

### Automated Test Suite
The codebase includes 84 comprehensive automated unit and widget tests covering:
- **Router & Shell Configuration**: Top-level route configuration, `rootNavigatorKey`, and all 4 `StatefulShellBranch` destinations (`/dashboard`, `/products`, `/my-savings`, `/profile`).
- **Disk Persistence & SQLite Layer**: `SqfliteDatabaseService` and `AppDatabase` queries, inserts, and migrations; `SavingsLocalDataSource` tests verifying JSON serialization and write-to-disk for created plans; `AuthLocalDataSource` tests for session persistence.
- **Widget Flow Tests**: `CreateSavingsScreen` widget test verifying that completing the form writes the created plan directly to local storage (`SharedPreferences`) and SQLite, and displays a success notification; `SavingsPlansScreen` widget test verifying portfolio rendering; `DashboardScreen`, `LoginScreen`, `ProfileScreen`, and `ProductDetailsScreen` componentized widget tests.
- **Animations & Micro-interactions**: `FadeEntry` opacity entry tests and `StaggeredRollingNumber` character-by-character scrolling ticker tests.
- **Validators**: Email format regex, password length ($\ge 8$), required fields, positive amount checks.
- **Formatters**: Nigerian Naira currency formatting (`₦`), percentage formatting (`p.a.`), dynamic greetings.
- **Exception Hierarchy**: Proper codes and messages for `AuthException`, `NetworkException`, and `ServerException`.
- **Repositories**: `AuthRepository`, `ProductsRepository`, `SavingsRepository`, and `TransactionsRepository` error propagation and disk persistence.
- **Mock Backend Service & SQLite**: Login credential verification, product lookup, plan creation, transaction recording, and offline exception handling.

```bash
fvm flutter test
# Output: 84 tests passed! (100% green)
```

---

## Getting Started & Build Instructions

### Prerequisites
- Flutter SDK **3.29.x** or later (Latest Stable)
- Dart SDK **3.7.x** or later
- Android SDK & emulator (API 34/35) or physical device

### Setup & Execution
```bash
# Clone the repository
git clone <repo-url>
cd koins_savings_app

# Install dependencies
fvm flutter pub get

# Run static analysis
fvm flutter analyze

# Run unit tests
fvm flutter test

# Launch the app on a connected device/emulator
fvm flutter run
```

### Build APK
To produce the release or debug APK:
```bash
# Build Debug APK
fvm flutter build apk --debug

# Build Release APK
fvm flutter build apk --release
```
*Generated binary is located at `build/app/outputs/flutter-apk/app-debug.apk`.*

---

## Screenshots & Visual Showcase

### Persistent Shell & Tab Navigation (go_router)
| 1. Dashboard (Tab 0) | 2. Savings Products (Tab 1) | 3. My Savings (Tab 2) | 4. More / Profile (Tab 3) |
| :---: | :---: | :---: | :---: |
| <img src="screenshots/09_gorouter_dashboard.png" width="200" alt="Dashboard Tab" /> | <img src="screenshots/10_gorouter_savings_tab.png" width="200" alt="Savings Products Tab" /> | <img src="screenshots/54_my_savings_tab.png" width="200" alt="My Savings Tab" /> | <img src="screenshots/12_gorouter_more_tab.png" width="200" alt="More Profile Tab" /> |

### Full-Screen Overlay Flows & Plan Creation
| 5. Create Savings Plan (Overlay) | 6. Product Details Screen | 7. Login Authentication |
| :---: | :---: | :---: |
| <img src="screenshots/14_gorouter_create_savings.png" width="200" alt="Create Savings Plan" /> | <img src="screenshots/04_savings_details_screen.png" width="200" alt="Product Details" /> | <img src="screenshots/08_gorouter_login.png" width="200" alt="Login Screen" /> |

---

## Assumptions & Future Improvements

### Assumptions
- **Mock Authentication**: Evaluated against in-memory and local mock authentication as specified in the assessment guidelines.
- **Currency**: Nigerian Naira (`₦`) with comma thousands-separators.
- **Orientation**: Optimized for portrait mobile viewports.

### Future Improvements (Given More Time)
- **Biometric & PIN Authentication**: Add `local_auth` for fingerprint and Face ID login.
- **Dark Mode**: Add comprehensive dark theme tokens within `AppTheme`.
- **Advanced Product Filtering**: Add search tags and interest rate sorting.
- **End-to-End Integration Tests**: Automated Flutter driver integration tests for complete user onboarding and plan creation flows.

---

## Deliverables Checklist

- [x] **Login Screen** (Email, Password, validation, mock auth, Forgot Password & Register stubs)
- [x] **Dashboard Screen** (Greeting, ₦850,000 balance, quick actions, 3 recent savings plans)
- [x] **Savings Products Screen** (4 products with two-tier interest rates, descriptions, View Details)
- [x] **Savings Details Screen** (Plan overview, minimum deposit, duration, CTA navigation)
- [x] **Create Savings Screen** (5 inputs, dropdown, duration, required validation, instant return)
- [x] **Profile Screen** (Full Name, Email, Phone Number, Logout returning to Login)
- [x] **REST API Integration** (Live public mock API dataset for Financial Insights with loading & error states)
- [x] **Local Persistence** (SharedPreferences session and created savings plans)
- [x] **Design System & Theming** (Material 3, strict tokens in `AppColors`, `AppRadius`, `AppShadows`, `AppSpacing`)
- [x] **State Management** (Riverpod with full architectural justification)
- [x] **Unit & Repository Tests** (73 automated tests passing with 0 failures)
- [x] **Code Quality** (`flutter analyze` with 0 warnings)
- [x] **Comprehensive README** (Architecture explanation, setup, packages, assumptions)
- [x] **Compiled APK** (`app-debug.apk`)
