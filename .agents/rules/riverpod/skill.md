---
name: riverpod-core
description: "Use when the user asks to use Riverpod, Flutter state management, providers, NotifierProvider, FutureProvider, StreamProvider, Ref, WidgetRef, or patterns like watch/listen/read/invalidate/refresh. Also trigger when user mentions state management, dependency injection, reactive UI, or Flutter app architecture involving Riverpod."
---

# Riverpod Core — Correct Usage Skill

This skill ensures correct usage of **hooks_riverpod / Riverpod 3.x** patterns.

Riverpod is a **reactive dependency graph system**, not a widget/state replacement.

---

# Core Principles (NON-NEGOTIABLE)

1. **Providers are global singletons of state**
   ```dart
   final provider = Provider<int>((ref) => 0);

2. **Never create providers inside functions or widgets**

   * Always top-level.

3. **State is read via Ref / WidgetRef**

   * `ref.watch()` → reactive UI updates
   * `ref.read()` → one-time access (no rebuild)
   * `ref.listen()` → side effects

4. **Always wrap app with ProviderScope**

   ```dart
   void main() {
     runApp(const ProviderScope(child: MyApp()));
   }
   ```

5. **Riverpod replaces manual state propagation**

   * No lifting state
   * No InheritedWidget usage directly
   * No manual subscription management

---

# Provider Types (Choose based on return type)

| Type                                  | Use case                              |
| ------------------------------------- | ------------------------------------- |
| `Provider<T>`                         | synchronous immutable value           |
| `FutureProvider<T>`                   | async fetch (API, DB)                 |
| `StreamProvider<T>`                   | continuous stream (socket, DB stream) |
| `NotifierProvider<TNotifier, T>`      | mutable sync state                    |
| `AsyncNotifierProvider<TNotifier, T>` | mutable async state                   |

---

# Ref (Core API Object)

Every provider gets a `Ref`.

```dart
final provider = Provider<int>((ref) {
  return 0;
});
```

## Ref capabilities

### Read value (no rebuild)

```dart
ref.read(otherProvider);
```

### Watch value (reactive)

```dart
ref.watch(otherProvider);
```

### Listen (side effects only)

```dart
ref.listen(otherProvider, (prev, next) {
  print(next);
});
```

### Invalidate (reset state)

```dart
ref.invalidate(provider);
```

### Refresh (invalidate + read)

```dart
final value = ref.refresh(provider);
```

---

# Widget Integration (WidgetRef)

Inside widgets:

```dart
Consumer(
  builder: (context, ref, _) {
    final value = ref.watch(myProvider);
    return Text('$value');
  },
);
```

OR:

```dart
ConsumerWidget(
  build: (context, ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  },
);
```

---

# Provider Patterns

## 1. Simple Provider (sync)

```dart
final counterProvider = Provider<int>((ref) => 0);
```

---

## 2. FutureProvider (async fetch)

```dart
final userProvider = FutureProvider<User>((ref) async {
  final response = await api.getUser();
  return User.fromJson(response);
});
```

---

## 3. StreamProvider (live updates)

```dart
final tickProvider = StreamProvider<int>((ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (i) => i,
  );
});
```

---

## 4. NotifierProvider (mutable state)

```dart
final counterProvider =
    NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}
```

Usage:

```dart
ref.read(counterProvider.notifier).increment();
```

---

## 5. AsyncNotifierProvider (async mutable state)

```dart
final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return api.getUser();
  }

  Future<void> refreshUser() async {
    state = const AsyncLoading();
    state = AsyncData(await api.getUser());
  }
}
```

---

# Critical Mental Model

Riverpod = **dependency graph + cached reactive values**

Not:

* not MVC
* not setState replacement
* not widget state holder

---

# Execution Rules (VERY IMPORTANT)

## 1. Always prefer watch over read

```dart
ref.watch(provider); // correct
```

Do NOT use `read` for UI values.

---

## 2. Use listen only for side effects

```dart
ref.listen(authProvider, (prev, next) {
  if (next.hasError) showError();
});
```

Never use listen to derive UI state.

---

## 3. Never store Ref

Ref is ephemeral and context-bound.

---

## 4. Never mutate provider state externally

Only via Notifier / AsyncNotifier.

---

# Common Mistakes

| Wrong                           | Correct                        |
| ------------------------------- | ------------------------------ |
| provider inside widget          | top-level provider             |
| using setState for shared state | use NotifierProvider           |
| ref.read in UI                  | ref.watch                      |
| storing Ref in class field      | pass ref explicitly            |
| async logic in widget           | FutureProvider / AsyncNotifier |

---

# Architecture Rules

## When to use what

* UI state (counter, toggle) → `NotifierProvider`
* API calls → `FutureProvider`
* live data → `StreamProvider`
* cached computed value → `Provider`

---

# Performance Rules

1. Prefer fine-grained providers
2. Avoid heavy logic inside build()
3. Split derived state into separate providers:

   ```dart
   final isEvenProvider = Provider((ref) {
     final count = ref.watch(counterProvider);
     return count.isEven;
   });
   ```

---

# Key Insight

> Riverpod is not about storing state — it is about describing dependencies.

Every `watch()` creates a reactive edge in a graph.

---