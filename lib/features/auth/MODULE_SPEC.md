# Auth Module – Specification

> Simple Feature-First structure with sealed classes for state.

---

## Folder Structure

```
lib/features/auth/
├── data/
│   ├── models/
│   │   └── auth_user.dart
│   ├── datasources/
│   │   └── auth_local_data_source.dart
│   └── repositories/
│       └── auth_repository.dart
├── presentation/
│   ├── providers/
│   │   └── auth_provider.dart
│   ├── screens/
│   │   └── login_screen.dart
│   └── widgets/
└── auth.dart                          # barrel file
```

Shared dependency (outside this feature):

```
lib/services/mock_backend_service.dart
```

---

## 1. AuthUser Model

**File**: `data/models/auth_user.dart`

```dart
class AuthUser {
  final String fullName;
  final String email;
  final String phone;

  const AuthUser({
    required this.fullName,
    required this.email,
    required this.phone,
  });
}
```

**Mock success data**
- fullName: `John Doe`
- email: `test@bank.com`
- phone: `+234 801 234 5678`

---

## 2. MockBackendService (Auth portion)

**File**: `lib/services/mock_backend_service.dart` (shared singleton)

- Singleton
- `bool isNetworkAvailable = true`

```dart
Future<AuthUser> login({
  required String email,
  required String password,
})
```

**Behaviour**
1. If `!isNetworkAvailable` → throw `NetworkException`
2. Artificial delay (~800ms)
3. If credentials match `test@bank.com` / `Password123` → return `AuthUser`
4. Otherwise → throw `AuthException('Invalid email or password')`

---

## 3. Data sources (abstract + concrete)

Remote calls `BackendService` (not `MockBackendService`). Local owns SharedPreferences.

| Role | Abstract | Concrete |
|---|---|---|
| Remote | `AuthRemoteDataSource` | `AuthRemoteDataSourceImpl` |
| Local | `AuthLocalDataSource` | `AuthLocalDataSourceImpl` |

Local methods: `saveSession`, `getSession`, `clearSession`, `isLoggedIn`.

## 4. AuthRepository (abstract + concrete)

`AuthRepository` is what the notifier depends on. `AuthRepositoryImpl` takes the two data-source abstractions and combines them: login calls remote, then saves locally only on success.

---

## 5. AuthProvider (Riverpod)

**File**: `presentation/providers/auth_provider.dart`

### AuthState (Sealed Classes)

```dart
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
```

### AuthNotifier Methods
- `login(String email, String password)`
- `logout()`
- `checkAuthStatus()`   // called on app start

**Behaviour**
- `login` → emit `AuthLoading` → call repository → emit `AuthAuthenticated` or `AuthError`
- `logout` → clear session → emit `AuthUnauthenticated`
- `checkAuthStatus` → read local session → emit `AuthAuthenticated` or `AuthUnauthenticated`

---

## 6. Login Screen

**File**: `presentation/screens/login_screen.dart`

**UI**
- Logo
- Title: “Welcome Back”
- Subtitle: “Sign in to continue to Koins”
- Email field
- Password field (with show/hide toggle)
- “Forgot Password?” (non-functional)
- Login button
- “Don’t have an account? Register” (non-functional)

**Logic**
- Form validation (email required + valid format, password required + min 8 chars)
- On submit → call `ref.read(authProvider.notifier).login(...)`
- Listen to `authProvider`:
  - `AuthLoading` → disable form + show loading on button
  - `AuthError` → show SnackBar with message
  - `AuthAuthenticated` → navigate to Dashboard (replace)

---

## 7. Acceptance Criteria

- [ ] Correct credentials → session saved → navigate to Dashboard
- [ ] Wrong credentials → `AuthError` shown
- [ ] No internet → `NetworkException` → shown as error
- [ ] Form validation works before calling backend
- [ ] Loading state disables UI correctly
- [ ] App restart restores session if previously logged in
- [ ] Logout clears session and returns to Login
- [ ] Forgot Password & Register are non-functional

---

## Implementation Order

1. `AuthUser` model
2. `MockBackendService` (login method)
3. `AuthLocalDataSource`
4. `AuthRepository`
5. `AuthProvider` (sealed states + notifier)
6. `LoginScreen`
7. Barrel file (`auth.dart`)
8. Wire `checkAuthStatus()` in `main.dart`
