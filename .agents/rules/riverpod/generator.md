# Riverpod Code Generation

Code generation in Riverpod allows you to write providers using annotations instead of manually choosing provider types such as `Provider`, `FutureProvider`, or `NotifierProvider`.

It improves readability, enables better tooling, supports flexible parameters, and provides stateful hot reload support.

---

## Before vs After

### Without code generation

```dart
final fetchUserProvider =
    FutureProvider.autoDispose.family<User, int>(
  (ref, userId) async {
    final json = await http.get('api/user/$userId');
    return User.fromJson(json);
  },
);
```

### With code generation

```dart
@riverpod
Future<User> fetchUser(
  Ref ref, {
  required int userId,
}) async {
  final json = await http.get('api/user/$userId');
  return User.fromJson(json);
}
```

---

# Should You Use Code Generation?

Code generation is completely optional.

Use it if your project already relies on generators like:

* `freezed`
* `json_serializable`
* `drift`
* `retrofit`
* `riverpod_generator`

Avoid adding it only for Riverpod if you want:

* faster builds
* simpler tooling
* fewer generated files

The Dart team cancelled macros, so code generation remains build_runner-based.

---

# Benefits

## Cleaner syntax

You no longer manually choose provider types.

Instead of:

```dart
final provider = FutureProvider<String>((ref) async {});
```

You write:

```dart
@riverpod
Future<String> provider(Ref ref) async {}
```

---

## Flexible parameters

Supports:

* named parameters
* optional parameters
* default values
* multiple parameters

```dart
@riverpod
Future<User> fetchUser(
  Ref ref, {
  required int id,
}) async {
  ...
}
```

---

## Better hot reload

Riverpod generators support stateful hot reload.

---

## Better debugging

Generated metadata improves DevTools inspection and provider tracing.

---

# Functional vs Class-Based Providers

## Functional Provider

Best for read-only state.

```dart
@riverpod
Future<String> username(Ref ref) async {
  return 'Alex';
}
```

Cannot expose public mutation methods.

---

## Class-Based Provider

Best for mutable state and side-effects.

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }
}
```

---

# Async Support

Riverpod generators support:

* `Future`
* `FutureOr`
* `Stream`

---

## Future Provider

```dart
@riverpod
Future<String> example(Ref ref) async {
  return Future.value('Hello');
}
```

---

## Stream Provider

```dart
@riverpod
Stream<int> ticker(Ref ref) async* {
  while (true) {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    yield DateTime.now().second;
  }
}
```

---

# autoDispose Behavior

Generated providers are `autoDispose` by default.

That means unused providers are automatically destroyed.

---

## Default behavior

```dart
@riverpod
String username(Ref ref) {
  return 'Alex';
}
```

Equivalent to:

```dart
Provider.autoDispose(...)
```

---

## Disable autoDispose

```dart
@Riverpod(keepAlive: true)
String username(Ref ref) {
  return 'Alex';
}
```

Use `keepAlive` for:

* repositories
* caches
* long-lived services
* websocket connections

---

# Passing Parameters

No more `.family`.

---

## Functional

```dart
@riverpod
String greeting(
  Ref ref,
  int id, {
  String name = 'User',
}) {
  return 'Hello $id $name';
}
```

---

## Class-Based

```dart
@riverpod
class Greeting extends _$Greeting {
  @override
  String build(
    int id, {
    String name = 'User',
  }) {
    return 'Hello $id $name';
  }
}
```

---

# Migration Guide

## Provider

### Before

```dart
final provider =
    Provider.autoDispose<String>((ref) {
  return 'Hello';
});
```

### After

```dart
@riverpod
String provider(Ref ref) {
  return 'Hello';
}
```

---

## FutureProvider

### Before

```dart
final provider =
    FutureProvider.autoDispose<String>(
  (ref) async {
    return 'Hello';
  },
);
```

### After

```dart
@riverpod
Future<String> provider(Ref ref) async {
  return 'Hello';
}
```

---

## StreamProvider

### Before

```dart
final provider =
    StreamProvider.autoDispose<String>(
  (ref) async* {
    yield 'Hello';
  },
);
```

### After

```dart
@riverpod
Stream<String> provider(Ref ref) async* {
  yield 'Hello';
}
```

---

## NotifierProvider

### Before

```dart
final counterProvider =
    NotifierProvider<Counter, int>(
  Counter.new,
);

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() {
    state++;
  }
}
```

### After

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() {
    state++;
  }
}
```

---

## AsyncNotifierProvider

### Before

```dart
final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return api.fetchUser();
  }
}
```

### After

```dart
@riverpod
class User extends _$User {
  @override
  Future<UserModel> build() async {
    return api.fetchUser();
  }
}
```

---

# Required Setup

## Dependencies

```yaml
dependencies:
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0

dev_dependencies:
  riverpod_generator: ^3.0.0
  build_runner: ^2.4.0
```

---

## Part File

```dart
part 'user_provider.g.dart';
```

---

## Run Generator

```bash
dart run build_runner build \
  --delete-conflicting-outputs
```

Watch mode:

```bash
dart run build_runner watch \
  --delete-conflicting-outputs
```

---

# Recommended Architecture

## Prefer small providers

Avoid giant providers with multiple responsibilities.

Good:

```dart
@riverpod
Future<User> user(Ref ref) async {}

@riverpod
Future<List<Post>> posts(Ref ref) async {}
```

Bad:

```dart
@riverpod
Future<AppState> everything(Ref ref) async {}
```

---

# Best Practices

## Use functional providers by default

Use class providers only when state mutation is required.

---

## Avoid side-effects in build()

Bad:

```dart
@override
Future<User> build() async {
  analytics.track('opened');
  return api.fetch();
}
```

Prefer:

```dart
ref.listen(...)
```

or public methods.

---

## Use AsyncValue properly

```dart
final user = ref.watch(userProvider);

return switch (user) {
  AsyncData(:final value) => Text(value.name),
  AsyncError(:final error) => Text('$error'),
  _ => const CircularProgressIndicator(),
};
```

---

# Common Mistakes

## Forgetting part file

```dart
part 'provider.g.dart';
```

---

## Forgetting build_runner

Generated providers will fail without generation.

---

## Mutating state incorrectly

Bad:

```dart
state.items.add(item);
```

Good:

```dart
state = [
  ...state,
  item,
];
```

---

# Recommended Setup for Flutter + Riverpod + Mix

```yaml
dependencies:
  flutter_riverpod:
  riverpod_annotation:
  mix:
  flutter_animate:

dev_dependencies:
  riverpod_generator:
  build_runner:
  custom_lint:
  riverpod_lint:
```

---

# Recommended Riverpod Rules

* Prefer generated providers
* Prefer immutable state
* Keep providers focused
* Avoid business logic in widgets
* Use `ref.watch()` inside UI
* Use `ref.read()` inside callbacks
* Use `ref.listen()` for effects
* Avoid global singletons
* Prefer repositories/services
* Use `keepAlive` intentionally
* Avoid providers depending on UI context

---

# Example Theme Provider

```dart
@riverpod
class ThemeModeNotifier
    extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.dark;
  }

  void toggle() {
    state = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.dark,
    };
  }
}
```

Usage:

```dart
final themeMode = ref.watch(
  themeModeNotifierProvider,
);

MaterialApp(
  themeMode: themeMode,
)
```
