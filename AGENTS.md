# Project Rules & Architecture Guidelines

## 1. State Management (Riverpod 2.0+ Standard)
- **NO Legacy APIs (`StateNotifier` / `StateNotifierProvider`)**:
  - Never use `StateNotifier` or `StateNotifierProvider`.
  - Always use modern Riverpod 2.0+ APIs:
    - Synchronous state: `Notifier` / `NotifierProvider`
    - Screen-bound or auto-disposable state: `AutoDisposeNotifier` / `NotifierProvider.autoDispose`
    - Parametrized state: `AutoDisposeFamilyNotifier` / `NotifierProvider.autoDispose.family`
    - Asynchronous state: `AsyncNotifier` / `AsyncNotifierProvider` or `AutoDisposeAsyncNotifier` / `AsyncNotifierProvider.autoDispose`
  - In modern notifiers, access dependencies inside `build()` using `ref.watch()`, and read other notifiers via `ref.read()`.

## 2. Zero `setState` on Screens
- **Never call `setState` inside screen widgets**:
  - All screen-bound state (form values, loading indicators, visibility toggles, selections) must reside in an `autoDispose` Notifier.
  - Screen widgets should be `ConsumerWidget` whenever possible. If a screen requires native resources (e.g., `TextEditingController` or `AnimationController` requiring `dispose()`), use `ConsumerStatefulWidget` strictly for resource lifecycle management—never call `setState`.

## 3. Sealed Classes for State & Loading
- **All Notifier states must be represented by sealed class hierarchies**:
  - Example: `sealed class FeatureState` with subtypes `FeatureInitial`, `FeatureLoading`, `FeatureLoaded` (or `FeatureSuccess`), and `FeatureError`.
  - Loading indicators on screens, buttons, and views must be directly dictated by pattern-matching or inspecting the watched sealed state (e.g., `state is FeatureLoading` or a helper `bool get isLoading => this is FeatureLoading`).
  - Do not use loose boolean `_loading` flags to manage loading states.
