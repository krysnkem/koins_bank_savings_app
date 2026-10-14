# State Management Rule

- **NO Legacy APIs**: Never use `StateNotifier` or `StateNotifierProvider`.
- Use modern Riverpod 2.0+ APIs: `Notifier` / `NotifierProvider`, `AutoDisposeNotifier` / `NotifierProvider.autoDispose`, `AutoDisposeFamilyNotifier` / `NotifierProvider.autoDispose.family`, or `AsyncNotifier` / `AsyncNotifierProvider`.
- **Zero `setState` on Screens**: Screen-bound states must live in an `autoDispose` Notifier.
- **Sealed State Classes**: States must use Dart `sealed class` hierarchies, and loading states must be dictated by watching these sealed classes.
