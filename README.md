# Koins Savings App

A simple savings application built for the **Koins MFB Flutter Developer Technical Assessment**.

> **Flutter Version**: Latest Stable (3.47.x / Dart 3.13.x recommended)

**Design Specs**: See [`DESIGN_SPECS.md`](./DESIGN_SPECS.md) for the complete UI & functional specifications (validated 100% against the original assessment).

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App-wide constants & strings
│   ├── theme/           # Colors, spacing, typography, theme
│   ├── errors/          # Custom exceptions
│   └── utils/           # Validators, formatters
├── models/              # Data models
├── services/            # API & external services
├── repositories/        # Data layer abstraction
├── providers/           # Riverpod state management
├── screens/             # Full page screens
├── widgets/
│   ├── common/          # Reusable UI components
│   └── savings/         # Savings-specific widgets
├── utils/
└── main.dart
```

---

## Theme

The UI theme closely replicates the official **Koins MFB** brand identity:

| Token              | Value          | Usage                     |
|--------------------|----------------|---------------------------|
| Primary            | `#22C55E`      | Buttons, accents, logo    |
| Primary Dark       | `#16A34A`      | Pressed states            |
| Secondary          | `#0F766E`      | Deep teal accents         |
| Background         | `#F0FDF4`      | Soft mint page background |
| Surface            | `#FFFFFF`      | Cards                     |
| Text Primary       | `#064E3B`      | Headings & body text      |

Logo included: `assets/images/koins_logo.png` (official Koins logo)

---

## Getting Started

### Prerequisites
- Flutter SDK **3.47.x** or later (latest stable)
- Dart 3.13+
- Android Studio / VS Code with Flutter extensions

### Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd koins_savings_app

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Generate code (if using Riverpod generators / Hive)
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Packages Used

| Package              | Purpose                        |
|----------------------|--------------------------------|
| flutter_riverpod     | State management               |
| google_fonts         | Inter typography               |
| shared_preferences   | Simple local storage           |
| hive + hive_flutter  | Structured local persistence   |
| dio / http           | REST API calls                 |
| intl                 | Currency & date formatting     |
| equatable            | Value equality for models      |

---

## State Management Choice

**Riverpod** was chosen because:
- Compile-safe and testable
- Excellent support for async data (FutureProvider / AsyncNotifier)
- Scales well without boilerplate explosion
- Clear separation between UI and business logic

---

## Local Storage Strategy

- `SharedPreferences` → login session flag & basic user info
- `Hive` → created savings plans (structured data)

---

## Mock Credentials

```
Email:    test@bank.com
Password: Password123
```

---

## Architecture Notes

The project follows a clean layered architecture:

1. **Screens / Widgets** → UI only
2. **Providers** → State & business logic
3. **Repositories** → Abstract data sources
4. **Services** → API / local storage implementations
5. **Models** → Pure data classes

---

## Assumptions

- No real authentication backend (mock login as specified)
- Savings products are currently mocked (will integrate public API)
- Currency is Nigerian Naira (₦)
- Portrait orientation only for v1

---

## Future Improvements (if given more time)

- Full go_router navigation
- Dark mode support
- Biometric / PIN login (bonus)
- Pull-to-refresh & search/filter on products
- Unit + Widget tests
- Offline-first with better caching
- Animations & micro-interactions

---

## Deliverables Checklist

- [x] Project foundation & folder structure
- [x] Theme matching Koins MFB
- [x] Official logo included
- [ ] Login screen
- [ ] Dashboard
- [ ] Savings Products
- [ ] Savings Details
- [ ] Create Savings
- [ ] Profile + Logout
- [ ] API Integration
- [ ] Local persistence of savings plans
- [ ] README + Architecture explanation
- [ ] Screenshots
- [ ] APK

---

Built with ❤️ for the Koins MFB Technical Assessment.
