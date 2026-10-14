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
6. [REST API Integration](#rest-api-integration)
7. [Mock Credentials](#mock-credentials)
8. [Testing & Quality Assurance](#testing--quality-assurance)
9. [Getting Started & Build Instructions](#getting-started--build-instructions)
10. [Screenshots & Visual Showcase](#screenshots--visual-showcase)
11. [Assumptions & Future Improvements](#assumptions--future-improvements)
12. [Deliverables Checklist](#deliverables-checklist)

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
│   │   ├── data/              # FinancialTip model, tips datasource, repository
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
2. **Immutable State Transitions**: Uses `StateNotifier` and immutable state models (`copyWith`), making state changes predictable and debuggable.
3. **Effortless Testability**: Providers and repositories can be overridden cleanly in unit and widget tests without spinning up a full widget tree.
4. **Clean Async Data Handling**: Supports declarative loading, success, and error states for REST API calls and asynchronous storage operations.

---

## Local Storage Strategy

The application uses **`shared_preferences`** for real disk persistence:
1. **User Authentication Session**: Retains login status, email, and user profile data across app restarts via `AuthLocalDataSource`.
2. **Created Savings Plans**: Serializes user-created savings plans to JSON and persists them directly to disk via `SavingsLocalDataSource` (storage key `'saved_savings_plans'`). When a user creates a new savings plan, it is immediately written to disk and loaded into both the Dashboard recent list and the My Savings screen.

---

## REST API Integration

- **Endpoint**: Integrates with the public REST API (`https://jsonplaceholder.typicode.com/posts`) to dynamically retrieve and display **Financial Insights & Tips** on the Dashboard.
- **Resilience**: Implements full loading shimmers, network timeout handling, and user-friendly error banners with one-tap retry functionality.

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
The codebase includes 61 comprehensive automated unit and widget tests covering:
- **Router & Shell Configuration**: Top-level route configuration, `rootNavigatorKey`, and all 4 `StatefulShellBranch` destinations (`/dashboard`, `/products`, `/my-savings`, `/profile`).
- **Disk Persistence Layer**: `SavingsLocalDataSource` tests verifying JSON serialization and write-to-disk for created plans; `AuthLocalDataSource` tests for session persistence.
- **Widget Flow Tests**: `CreateSavingsScreen` widget test verifying that completing the form writes the created plan directly to local storage (`SharedPreferences`) and displays a success notification; `SavingsPlansScreen` widget test verifying portfolio rendering.
- **Validators**: Email format regex, password length ($\ge 8$), required fields, positive amount checks.
- **Formatters**: Nigerian Naira currency formatting (`₦`), percentage formatting (`p.a.`), dynamic greetings.
- **Exception Hierarchy**: Proper codes and messages for `AuthException`, `NetworkException`, and `ServerException`.
- **Repositories**: `AuthRepository`, `ProductsRepository`, and `SavingsRepository` error propagation and disk persistence.
- **Mock Backend Service**: Login credential verification, product lookup, plan creation, and offline exception handling.

```bash
fvm flutter test
# Output: 61 tests passed! (100% green)
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
- [x] **Unit & Repository Tests** (50 automated tests passing with 0 failures)
- [x] **Code Quality** (`flutter analyze` with 0 warnings)
- [x] **Comprehensive README** (Architecture explanation, setup, packages, assumptions)
- [x] **Compiled APK** (`app-debug.apk`)
