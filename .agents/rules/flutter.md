# AI rules for Flutter

You are an expert in Flutter and Dart development. Your goal is to build
beautiful, performant, and maintainable applications following modern best
practices. You have expert experience with application writing, testing, and
running Flutter applications for various platforms, including desktop, web, and
mobile platforms.

## Interaction Guidelines
* **User Persona:** Assume the user is familiar with programming concepts but
  may be new to Dart.
* **Explanations:** When generating code, provide explanations for Dart-specific
  features like null safety, futures, and streams.
* **Clarification:** If a request is ambiguous, ask for clarification on the
  intended functionality and the target platform (e.g., command-line, web,
  server).
* **Dependencies:** When suggesting new dependencies from `pub.dev`, explain
  their benefits.
* **Formatting:** Use the `dart_format` tool to ensure consistent code
  formatting.
* **Fixes:** Use the `dart_fix` tool to automatically fix many common errors,
  and to help code conform to configured analysis options.
* **Linting:** Use the Dart linter with a recommended set of rules to catch
  common issues. Use the `analyze_files` tool to run the linter.

## Project Structure (Architecture Overview)

This project follows a **feature-oriented, layered Flutter architecture** with strong separation between:

* Data layer (database, API)
* State layer (providers)
* Navigation layer (routes)
* UI system (styles, Mix-based design system)
* Utilities (hooks, guards, helpers)

The entry point is `lib/main.dart`, which bootstraps providers, routing, and global configuration.

### Root Layer

#### Application Entry

* `lib/main.dart` → main bootstrap file
  Responsible for:

  * initializing providers
  * configuring routing
  * setting up theme & global state
  * attaching database and API layers

### Database Layer

#### Local Persistence (Drift-based or equivalent)

```
lib/database/
```

* `database.dart` → main database instance & configuration
* `tables/` → schema definitions

#### Tables

```
lib/database/tables/
```

* `settings.dart` → persistent user settings table

> This layer represents the **single source of truth for local state persistence**.

### Providers Layer (State Management Core)

```
lib/providers/
```

This is the **central reactive layer** of the application. It is split by responsibility.

### API Providers

```
lib/providers/api/
```

* `api.dart` → base API client and request layer

> Handles all remote communication logic.

### Database Providers

```
lib/providers/database/
```

* Bridges database layer into reactive providers
* Exposes typed access to local persistence

### Preferences System (Core Feature State)

```
lib/providers/preferences/
```

This is a **modular preference system**, where each setting is isolated into its own provider for fine-grained reactivity.

### Reader Preferences (domain-specific settings)

* `locale.dart` → language / localization
* `theme.dart` → theme mode control
* `reader_font_scale.dart` → font scaling
* `reader_font.dart` → font selection
* `reader_music_enabled.dart` → background music toggle
* `reader_music_volume.dart` → music volume control
* `reader_narrator_enabled.dart` → narrator toggle
* `reader_narrator_volume.dart` → narrator volume control

> Each file represents a **single reactive preference unit**, enabling granular updates without rebuilding global state.

### Supabase Integration Layer

```
lib/providers/supabase/
```

* `authorization.dart` → authentication & session management

> Responsible for auth state, session lifecycle, and secure access control.

### Provider Aggregation

* `lib/providers/preferences.dart` → exports or composes all preference providers

### Routing Layer

```
lib/routes/
```

This layer defines **typed navigation using GoRouter-style route objects**.

* `onboarding_00_splash_route.dart`
* `onboarding_01_welcome_route.dart`

Each route is:

* strongly typed
* self-contained
* integrated into a centralized routing system

#### Route Registry

* `lib/routes.dart` → central route enum/registry

> Acts as a **navigation map and abstraction layer over GoRouter**.

### Styling System

```
lib/styles/
```

This project uses a **Mix-based design system + custom extensions**.

#### Glass Design System

* `glass.dart` → glassmorphism styling utilities

> Defines blur, transparency, and layered UI effects.

#### Global Style Registry

* `lib/styles.dart` → central style export/aggregation

> Acts as the **entry point for all design tokens and style utilities**.

### Utilities Layer

```
lib/utils/
```

Generic reusable helpers and hooks.

* `guard_hook.dart` → safety/guard logic for hooks or async state
* `use_previous_not_null_hook.dart` → retains previous non-null reactive value

> This layer contains **framework-agnostic logic helpers** used across UI and providers.

### Architecture Summary

#### Layer Hierarchy

```
main.dart
 ├── routes (navigation layer)
 ├── providers (state layer)
 │     ├── api
 │     ├── database
 │     ├── preferences (granular reactive settings)
 │     └── supabase (auth)
 │
 ├── database (local persistence)
 │     └── tables
 │
 ├── styles (Mix-based design system)
 │     └── glass system
 │
 └── utils (hooks + helpers)
```

---

### Key Architectural Principles

#### 1. Feature Isolation

Each preference or feature is split into its own provider file.

#### 2. Reactive Granularity

No monolithic state — everything is independently reactive.

#### 3. Strong Separation of Concerns

* database = persistence
* providers = state
* routes = navigation
* styles = UI system
* utils = logic helpers

#### 4. Mix-first UI System

All UI styling is expected to follow the **Mix design system**, not Flutter Material theming.

#### 5. Scalable Navigation

Routes are isolated per screen and centrally composed.


## Flutter style guide
* **SOLID Principles:** Apply SOLID principles throughout the codebase.
* **Concise and Declarative:** Write concise, modern, technical Dart code.
  Prefer functional and declarative patterns.
* **Composition over Inheritance:** Favor composition for building complex
  widgets and logic.
* **Immutability:** Prefer immutable data structures. Widgets (especially
  `StatelessWidget`) should be immutable.
* **State Management:** Separate ephemeral state and app state. Use a state
  management solution for app state to handle the separation of concerns.
* **Widgets are for UI:** Everything in Flutter's UI is a widget. Compose
  complex UIs from smaller, reusable widgets.
* **Navigation:** Use a modern routing package like `auto_route` or `go_router`.
  For more guidelines around navigation, see the section on [routing](#routing).

## Package Management
* **Pub Tool:** To manage packages, use the `pub` tool, if available.
* **External Packages:** If a new feature requires an external package, use the
  `pub_dev_search` tool, if it is available. Otherwise, identify the most
  suitable and stable package from pub.dev.
* **Adding Dependencies:** To add a regular dependency, use the `pub` tool, if
  it is available. Otherwise, run `flutter pub add <package_name>`.
* **Adding Dev Dependencies:** To add a development dependency, use the `pub`
  tool, if it is available, with `dev:<package name>`. Otherwise, run `flutter
  pub add dev:<package_name>`.
* **Dependency Overrides:** To add a dependency override, use the `pub` tool, if
  it is available, with `override:<package name>:1.0.0`. Otherwise, run `flutter
  pub add override:<package_name>:1.0.0`.
* **Removing Dependencies:** To remove a dependency, use the `pub` tool, if it
  is available. Otherwise, run `dart pub remove <package_name>`.

## Code Quality
* **Code structure:** Adhere to maintainable code structure and separation of
  concerns (e.g., UI logic separate from business logic).
* **Naming conventions:** Avoid abbreviations and use meaningful, consistent,
  descriptive names for variables, functions, and classes.
* **Conciseness:** Write code that is as short as it can be while remaining
  clear.
* **Simplicity:** Write straightforward code. Code that is clever or
  obscure is difficult to maintain.
* **Error Handling:** Anticipate and handle potential errors. Don't let your
  code fail silently.
* **Styling (STRICT):**
    * Line length: Lines should be 80 characters or fewer.
    * Use `PascalCase` for classes, `camelCase` for
      members/variables/functions/enums, and `snake_case` for files.
* **Functions:**
    * Keep functions short and with a single purpose.
      Strive for less than 20 lines.
* **Testing:** Write code with testing in mind. Use the `file`, `process`, and
  `platform` packages, if appropriate, so you can inject in-memory and fake
  versions of the objects.
* **Logging:** Use the `logging` package instead of `print`.

## Dart Best Practices
* **Effective Dart:** Follow the official Effective Dart guidelines
  (https://dart.dev/effective-dart)
* **Class Organization:** Define related classes within the same library file.
  For large libraries, export smaller, private libraries from a single top-level
  library.
* **Library Organization:** Group related libraries in the same folder.
* **API Documentation:** Add documentation comments to all public APIs,
  including classes, constructors, methods, and top-level functions.
* **Comments:** Write clear comments for complex or non-obvious code. Avoid
  over-commenting.
* **Trailing Comments:** Don't add trailing comments.
* **Async/Await:** Ensure proper use of `async`/`await` for asynchronous
  operations with robust error handling.
    * Use `Future`s, `async`, and `await` for asynchronous operations.
    * Use `Stream`s for sequences of asynchronous events.
* **Null Safety:** Write code that is soundly null-safe. Leverage Dart's null
  safety features. Avoid `!` unless the value is guaranteed to be non-null.
* **Pattern Matching:** Use pattern matching features where they simplify the
  code.
* **Records:** Use records to return multiple types in situations where defining
  an entire class is cumbersome.
* **Switch Statements:** Prefer using exhaustive `switch` statements or
  expressions, which don't require `break` statements.
* **Exception Handling:** Use `try-catch` blocks for handling exceptions, and
  use exceptions appropriate for the type of exception. Use custom exceptions
  for situations specific to your code.
* **Arrow Functions:** Use arrow syntax for simple one-line functions.

Here is a **clean “LLM skill rule” block** for documentation standards in the same style as your Mix/Riverpod skills:

## Public API Documentation (STRICT)

### Rule: All public members MUST be documented

Any non-private API must have `///` documentation.

### Applies to:
- classes
- constructors
- methods
- functions
- fields (if public)
- getters/setters

---

#### Correct Example

```dart
/// Represents a user in the system.
class User {
  /// Creates a new user instance.
  const User(this.id);

  /// Unique identifier of the user.
  final String id;

  /// Loads a user from API.
  Future<User> fetch() async => ...
}
```

---

#### Incorrect Example

```dart
class User {
  final String id;

  Future<User> fetch() async => ...
}
```

---

### Overrides Rule

If a method overrides a documented parent method:

* ❌ DO NOT repeat documentation unless behavior changes significantly
* ✅ Inherit documentation from base class

```dart
abstract class Base {
  /// Initialize system.
  void init();
}

class Impl extends Base {
  @override
  void init() {
    // implementation
  }
}
```

---

### Commenting Rules

#### Use comments ONLY when necessary

✔ Good:

* explaining WHY something exists
* describing non-obvious logic
* documenting edge cases

❌ Bad:

* repeating code
* stating the obvious

---

#### Example

```dart
// Cache is used because API rate limits are strict.
final cache = <String, User>{};
```

---

### Forbidden Comments

Do NOT use trailing comments:

```dart
// ❌ bad
final x = 1; // counter value
```


## Flutter Best Practices
* **Immutability:** Widgets (especially `StatelessWidget`) are immutable; when
  the UI needs to change, Flutter rebuilds the widget tree.
* **Composition:** Prefer composing smaller widgets over extending existing
  ones. Use this to avoid deep widget nesting.
* **Private Widgets:** Use small, private `Widget` classes instead of private
  helper methods that return a `Widget`.
* **Build Methods:** Break down large `build()` methods into smaller, reusable
  private Widget classes.
* **List Performance:** Use `ListView.builder` or `SliverList` for long lists to
  create lazy-loaded lists for performance.
* **Isolates:** Use `compute()` to run expensive calculations in a separate
  isolate to avoid blocking the UI thread, such as JSON parsing.
* **Const Constructors:** Use `const` constructors for widgets and in `build()`
  methods whenever possible to reduce rebuilds.
* **Build Method Performance:** Avoid performing expensive operations, like
  network calls or complex computations, directly within `build()` methods.

## API Design Principles
When building reusable APIs, such as a library, follow these principles.

* **Consider the User:** Design APIs from the perspective of the person who will
  be using them. The API should be intuitive and easy to use correctly.
* **Documentation is Essential:** Good documentation is a part of good API
  design. It should be clear, concise, and provide examples.

## Application Architecture
* **Separation of Concerns:** Aim for separation of concerns similar to MVC/MVVM, with defined Model,
  View, and ViewModel/Controller roles.
* **Logical Layers:** Organize the project into logical layers:
    * Presentation (widgets, screens)
    * Domain (business logic classes)
    * Data (model classes, API clients)
    * Core (shared classes, utilities, and extension types)
* **Feature-based Organization:** For larger projects, organize code by feature,
  where each feature has its own presentation, domain, and data subfolders. This
  improves navigability and scalability.

## Lint Rules

Include the package in the `analysis_options.yaml` file. Use the following
`analysis_options.yaml` file as a starting point:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Add additional lint rules here:
    # avoid_print: false
    # prefer_single_quotes: true
```

### Data Flow
* **Data Structures:** Define data structures (classes) to represent the data
  used in the application.
* **Data Abstraction:** Abstract data sources (e.g., API calls, database
  operations) using Repositories/Services to promote testability.

### Routing
* **GoRouter:** Use the `go_router` package for declarative navigation, deep
  linking, and web support.
* **GoRouter Setup:** To use `go_router`, first add it to your `pubspec.yaml`
  using the `pub` tool's `add` command.

  ```dart
  // 1. Add the dependency
  // flutter pub add go_router

  // 2. Configure the router
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'details/:id', // Route with a path parameter
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return DetailScreen(id: id);
            },
          ),
        ],
      ),
    ],
  );

  // 3. Use it in your MaterialApp
  MaterialApp.router(
    routerConfig: _router,
  );
  ```

* **Authentication Redirects:** Configure `go_router`'s `redirect` property to
  handle authentication flows, ensuring users are redirected to the login screen
  when unauthorized, and back to their intended destination after successful
  login.

Here’s a rewritten version of your docs, aligned with your custom `Routes` enum + `GoRouter` wrapper style, while keeping the same clarity and tone:

* **Custom Routes (GoRouter wrapper):** Use the generated `Routes` enum for all app navigation that should be type-safe, consistent, and optionally deep-linkable. This is the preferred approach for any screen that is part of the app flow (authentication, onboarding, main features, etc.).

  ```dart
  // Navigate to a route (replaces current location)
  Routes.onboardingWelcome.go(router);

  // Push a route onto the stack
  Routes.onboardingWelcome.push(router);

  // Replace current route
  Routes.onboardingWelcome.pushReplacement(router);

  // Replace current route without keeping history
  Routes.onboardingWelcome.replace(router);
  ```

  You can also resolve the current route based on app state:

  ```dart
  final route = await Routes.current(container);
  route.go(router);
  ```

  Or access the initial route:

  ```dart
  final initial = Routes.initial;
  initial.go(router);
  ```

---

### Data Handling & Serialization

* **Serialization:** Use `dart_mappable` for JSON serialization and mapping between Dart objects and external data sources. It provides type-safe, code-generated mappers with minimal boilerplate.

* **Field Renaming:** Use `caseStyle: CaseStyle.snakeCase` to automatically convert Dart’s `camelCase` fields into `snake_case` JSON keys when encoding/decoding data.

  ```dart
  // In your model file
  import 'package:dart_mappable/dart_mappable.dart';

  part 'user.mapper.dart';

  @MappableClass(caseStyle: CaseStyle.snakeCase)
  class User with UserMappable {
    final String firstName;
    final String lastName;

    const User({
      required this.firstName,
      required this.lastName,
    });
  }
  ```

  ```dart
  // Usage examples

  // From JSON
  final user = UserMapper.fromJson({
    'first_name': 'John',
    'last_name': 'Doe',
  });

  // To JSON
  final json = user.toJson();
  ```

### Logging

* **Structured Logging:** Use `Sentry.logger` for structured application logging. It integrates directly with Sentry, allowing logs to be correlated with errors, performance traces, and user sessions.

  ```dart
  import 'package:sentry_flutter/sentry_flutter.dart';

  // Simple informational log
  Sentry.logger.info('User logged in successfully.');
  ```

* **Error & Structured Logging:** Use appropriate log levels and include error + stack trace for better observability and debugging in Sentry.

  ```dart
  try {
    // ... code that might fail
  } catch (e, s) {
    Sentry.logger.error(
      'Failed to fetch data',
      exception: e,
      stackTrace: s,
    );
  }
  ```

* **Contextual Logging:** Add structured context using tags or additional data when needed for debugging complex flows.

  ```dart
  Sentry.logger.warning(
    'Unexpected API response format',
    exception: e,
    stackTrace: s,
    // Optional structured context
    data: {
      'endpoint': '/api/user',
      'retryCount': 3,
    },
  );
  ```

## Code Generation
* **Build Runner:** If the project uses code generation, ensure that
  `build_runner` is listed as a dev dependency in `pubspec.yaml`.
* **Code Generation Tasks:** Use `build_runner` for all code generation tasks,
  such as for `json_serializable`.
* **Running Build Runner:** After modifying files that require code generation,
  run the build command:

  ```shell
  dart run build_runner build --delete-conflicting-outputs
  ```

## Testing
* **Running Tests:** To run tests, use the `run_tests` tool if it is available,
  otherwise use `flutter test`.
* **Unit Tests:** Use `package:test` for unit tests.
* **Widget Tests:** Use `package:flutter_test` for widget tests.
* **Integration Tests:** Use `package:integration_test` for integration tests.
* **Assertions:** Prefer using `package:checks` for more expressive and readable
  assertions over the default `matchers`.

### Testing Best practices
* **Convention:** Follow the Arrange-Act-Assert (or Given-When-Then) pattern.
* **Unit Tests:** Write unit tests for domain logic, data layer, and state
  management.
* **Widget Tests:** Write widget tests for UI components.
* **Integration Tests:** For broader application validation, use integration
  tests to verify end-to-end user flows.
* **integration_test package:** Use the `integration_test` package from the
  Flutter SDK for integration tests. Add it as a `dev_dependency` in
  `pubspec.yaml` by specifying `sdk: flutter`.
* **Mocks:** Prefer fakes or stubs over mocks. If mocks are absolutely
  necessary, use `mockito` or `mocktail` to create mocks for dependencies. While
  code generation is common for state management (e.g., with `freezed`), try to
  avoid it for mocks.
* **Coverage:** Aim for high test coverage.

## Visual Design & Theming
* **UI Design:** Build beautiful and intuitive user interfaces that follow
  modern design guidelines.
* **Responsiveness:** Ensure the app is mobile responsive and adapts to
  different screen sizes, working perfectly on mobile and web.
* **Navigation:** If there are multiple pages for the user to interact with,
  provide an intuitive and easy navigation bar or controls.
* **Typography:** Stress and emphasize font sizes to ease understanding, e.g.,
  hero text, section headlines, list headlines, keywords in paragraphs.
* **Background:** Apply subtle noise texture to the main background to add a
  premium, tactile feel.
* **Shadows:** Multi-layered drop shadows create a strong sense of depth; cards
  have a soft, deep shadow to look "lifted."
* **Icons:** Incorporate icons to enhance the user’s understanding and the
  logical navigation of the app.
* **Interactive Elements:** Buttons, checkboxes, sliders, lists, charts, graphs,
  and other interactive elements have a shadow with elegant use of color to
  create a "glow" effect.


### Theming (Mix-based design system)

* **Token-driven Design System:**
  Use a fully token-based theming system built on `mix`, where all design values (colors, spacing, radius, typography, blur) are defined through strongly typed tokens instead of raw values. This ensures consistency, scalability, and compile-time safety across the app.

* **Centralized Theme Architecture:**
  All theme values are centralized in `AppTheme` implementations (`LightTheme`, `DarkTheme`).
  The `BaseTheme` provides shared design logic (spacing, radius, typography structure), while concrete themes only override color definitions.

* **Light and Dark Themes:**
  The system supports switching between `Themes.light` and `Themes.dark`, allowing runtime theme switching via `ThemeMode.light`, `ThemeMode.dark`, or `ThemeMode.system`.

  ```dart
  final theme = Themes.light.instance; // AppTheme
  ```

* **Color System (Semantic + Layered):**
  Colors are split into multiple semantic groups:

  * Base UI colors (`$Colors`)
  * Glass effects (`$GlassColors`)
  * Component-specific colors (`$ComponentColors`)

  This separation allows consistent UI layering and easier maintenance of glassmorphism and component styling.

  ```dart
  final primary = $Colors.primary.resolve(context);
  final glass = $GlassColors.primary();
  ```

* **Design Tokens (Spaces, Radius, Blur):**
  Spacing, border radius, and blur effects are fully tokenized using enums backed by `SpaceToken`, `RadiusToken`, and `DoubleToken`.

  ```dart
  final padding = $Spaces.md();        // spacing token
  final radius = $Radius.large();      // corner radius
  final blur = $BlurRadius.medium();   // backdrop blur
  ```

* **Typography System:**
  Text styles are defined via `$TextStyles` and mapped in `BaseTheme` into a structured `TextStyle` system.
  This ensures consistent typography scaling across headings, body text, and UI labels.

  ```dart
  final title = $TextStyles.h1.resolve(context);
  ```

* **Glass UI Support:**
  Dedicated glass tokens (`$GlassColors`) provide consistent styling for glassmorphic UI elements such as cards, buttons, and navigation bars, including blur, transparency, and neon accents.

* **Component-Level Styling:**
  Component-specific tokens (`$ComponentColors`) allow styling reusable UI blocks independently of global colors, improving modularity for design system components like:

  * Cards
  * Buttons
  * Navigation bars

* **Theme Extension Pattern:**
  Themes are extended via `BaseTheme`, which defines shared logic:

  ```dart
  abstract base class BaseTheme implements AppTheme
  ```

  Each theme only overrides:

  * `colors`

  while inheriting:

  * spacing
  * radius
  * blur
  * typography structure

* **Portal Integration:**
  Each theme exposes:

  * `PortalColors` → app-wide semantic colors
  * `PortalTypography` → global text styles

  This allows external modules to consume a simplified design API without directly accessing tokens.

* **Custom Fonts (via token system):**
  Fonts are managed via `Fonts` enum, ensuring consistent font usage across themes without hardcoding font families in widgets.

  ```dart
  enum Fonts {
    gotham('Gotham Pro'),
    sf('.SF Pro Text');
  }
  ```


### Assets & Media System (FlutterGen-based)

* **Type-safe Asset Management:**
  Use the generated `Assets` API instead of raw string paths. All assets are strongly typed and compile-time safe, preventing invalid paths and improving refactor safety.

  ```dart
  Assets.source.assets.logo.image();
  ```

* **Centralized Asset Registry:**
  All assets are organized under a single entry point (`Assets.source`), grouped by feature and domain (e.g. onboarding, splash, UI assets). This ensures predictable structure and scalability.

* **Local Images (AssetGenImage):**
  Use `AssetGenImage` for all raster images. It provides both widget rendering and `ImageProvider` access.

  ```dart
  // Widget usage
  Assets.source.assets.splash.image(
    width: 200,
    fit: BoxFit.cover,
  );

  // Provider usage
  final provider = Assets.source.assets.logo.provider();
  ```

* **SVG Assets (SvgGenImage):**
  Use `SvgGenImage` for vector assets with full support for Flutter SVG rendering.

  ```dart
  Assets.source.assets.onboarding.a01Welcome.star34.svg(
    width: 24,
    height: 24,
  );
  ```

* **Lottie Animations:**
  Use `LottieGenImage` for JSON or optimized `.lottie` animations with full control over playback.

  ```dart
  Assets.source.assets.onboarding.a00Splash.bookLottie.lottie(
    repeat: true,
    animate: true,
  );
  ```

* **Rive Animations:**
  Use `RiveGenImage` for interactive vector animations and state machines.

  ```dart
  Assets.source.assets.onboarding.a00Splash.bookRiv
      .riveFileLoader();
  ```

* **Asset Grouping by Feature:**
  Assets are structured by feature modules (e.g. onboarding), enabling:

  * better scalability
  * easier cleanup
  * feature isolation

  ```dart
  Assets.source.assets.onboarding.a01Welcome.girl.image();
  ```

* **Error & Loading Handling:**
  Always provide graceful loading and error states when working with dynamic or network-based media (especially when mixing with assets in UI composition).

  ```dart
  Assets.source.assets.splash.image(
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.error);
    },
  );
  ```

* **Performance Best Practices:**

  * Prefer `.svg` over raster images for scalable UI icons
  * Use Lottie for lightweight animations instead of GIFs
  * Cache providers when reusing assets in multiple widgets
  * Avoid rebuilding large animations unnecessarily

* **Do Not Use Raw Asset Strings:**
  Never use direct paths like:

  ```dart
  Image.asset('source/assets/logo.png'); // ❌ avoid
  ```

  Always use generated references:

  ```dart
  Assets.source.assets.logo.image(); // ✅ recommended
  ```


## UI Theming and Styling Code (Mix 2.0 Standard)

All UI styling in this project must use the **Mix design system**, not Flutter Material theming APIs.

Before writing any UI code, **always consult the Mix rule files**:

* `.agents/rules/mix/SKILL.md` → core Mix usage rules
* `.agents/rules/mix/styling.md` → styling system (BoxStyler, TextStyler, etc.)
* `.agents/rules/mix/tokens.md` → design tokens (colors, spacing, radius, blur)
* `.agents/rules/mix/variants.md` → state-based styling (hover, press, selected, etc.)
* `.agents/rules/mix/animations.md` → animations and transitions
* `.agents/rules/mix/widgets.md` → widget ↔ styler mapping
* `.agents/rules/mix/examples.md` → reference implementations

> If a pattern is not in these files, do not guess — read the reference first.

Yeah — this is a classic “LLM knows Flutter too well” problem. It defaults to raw `Flex` properties unless you hard-ban the mental path.

You need a **hard constraint rule**, not a suggestion.

Here’s a strict skill-style rule you can drop into your Mix docs:

---

### 🚫 Flutter Flex API Ban (Strict Mix Rule)

**Never use Flutter Flex properties directly.**
If using Mix, all layout configuration must go through `FlexBoxStyler`.

---

#### ❌ Forbidden Flutter Flex API

Do NOT generate or use:

```dart
MainAxisAlignment
CrossAxisAlignment
MainAxisSize
Column(...)
Row(...)
Flex(...)
```

---

### ✅ Required Mix Pattern

Always use `FlexBoxStyler` with fluent API.

---

### Alignment Mapping

#### Main axis alignment

| Flutter                        | Mix                                 |
| ------------------------------ | ----------------------------------- |
| MainAxisAlignment.center       | `.mainAxisAlignment(.center)`       |
| MainAxisAlignment.start        | `.mainAxisAlignment(.start)`        |
| MainAxisAlignment.end          | `.mainAxisAlignment(.end)`          |
| MainAxisAlignment.spaceBetween | `.mainAxisAlignment(.spaceBetween)` |
| MainAxisAlignment.spaceEvenly  | `.mainAxisAlignment(.spaceEvenly)`  |

---

#### Cross axis alignment

| Flutter                    | Mix                             |
| -------------------------- | ------------------------------- |
| CrossAxisAlignment.center  | `.crossAxisAlignment(.center)`  |
| CrossAxisAlignment.start   | `.crossAxisAlignment(.start)`   |
| CrossAxisAlignment.end     | `.crossAxisAlignment(.end)`     |
| CrossAxisAlignment.stretch | `.crossAxisAlignment(.stretch)` |

---

#### Main axis size

| Flutter          | Mix                   |
| ---------------- | --------------------- |
| MainAxisSize.min | `.mainAxisSize(.min)` |
| MainAxisSize.max | `.mainAxisSize(.max)` |

---

#### ❌ Example (WRONG)

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisSize: MainAxisSize.min,
  children: [],
);
```

---

#### ✅ Example (CORRECT Mix)

```dart
final style = FlexBoxStyler()
    .direction(.vertical)
    .mainAxisAlignment(.center)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

ColumnBox(
  style: style,
  children: [],
);
```

---

#### Or shorthand widgets

```dart
FlexBoxStyler()
  .column()
  .mainAxisAlignment(.center)
  .crossAxisAlignment(.center)(
  children: [],
);
```

---

### 🔥 Hard LLM Instruction (IMPORTANT)

When generating Flutter UI code with Mix:

#### ALWAYS:

* Use `BoxStyler`, `FlexBoxStyler`, `TextStyler`
* Use `.wrap()` only for modifiers
* Use `.mainAxisAlignment()`, `.crossAxisAlignment()` via styler
* Use `.row()/.column()` instead of `Row`/`Column` logic where applicable

#### NEVER:

* Output raw Flutter layout enums
* Output `Column(...)` with alignment params
* Mix Flutter + Mix APIs in same layout declaration

---

#### 🧠 Extra Guardrail (prevents regression)

Add this mental filter:

> If I see `Row` / `Column` → rewrite using `FlexBoxStyler`.



### Responsiveness (Mix-first approach)

Use Mix-compatible layout primitives and Flutter constraints only when necessary:

* Prefer `FlexBoxStyler().row()`, `FlexBoxStyler().column()`, `StackBox` for layout
* Use `LayoutBuilder` only for breakpoint logic
* Avoid `MediaQuery` unless reading screen dimensions

```dart
FlexBoxStyler().column()(
  children: [
    Box(style: cardStyle),
  ],
);
```

### Text Styling (DO NOT use Theme.of)

❌ Do not use:

```dart
Theme.of(context).textTheme
```

✅ Instead use Mix text system:

* `TextStyler`
* `$TextStyles` tokens
* `StyledText`

```dart
TextStyler()
  .fontSize(16)
  .fontWeight(FontWeight.w600)
  .color($Colors.textPrimary())(
  'Hello'
);
```

### Text Fields

Text fields must use Mix styling patterns and Flutter configuration only for input behavior:

```dart
TextField(
  textCapitalization: TextCapitalization.sentences,
  keyboardType: TextInputType.emailAddress,
  decoration: const InputDecoration(
    hintText: 'Enter email',
  ),
);
```

Styling (padding, borders, colors) must be handled via Mix wrappers, not InputDecoration styling hacks.

### Material Theming (Legacy — DO NOT USE for UI styling)

Material `ThemeData` is **only allowed for base app configuration**, not UI styling.

#### Allowed usage:

* system brightness
* seed-based color generation (optional fallback)
* global Material 3 configuration

#### DO NOT use for:

* colors in widgets
* typography
* spacing
* component styling


### ThemeData Setup (App shell only)

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  ),
);
```

> This is ONLY for system-level theming. UI must use Mix tokens.

### Design Tokens (Replace ThemeExtension)

❌ Do not use:

* `ThemeExtension`
* `Theme.of(context).extension`

✅ Use Mix tokens instead:

Defined in:

* `.agents/rules/mix/tokens.md`

Example:

```dart
$Colors.primary()
$Spaces.md()
$Radius.large()
$BlurRadius.medium()
```


### State Styling (Replace WidgetStateProperty)

❌ Do not use:

```dart
WidgetStateProperty.resolveWith
```

Mix replaces this with:

* `variants`
* `Pressable`
* state-aware stylers

Defined in:

* `.agents/rules/mix/variants.md`

Example:

```dart
final buttonStyle = BoxStyler()
    .color($Colors.primary())
    .variant(
      Variant.pressed,
      (style) => style.color($Colors.secondary()),
    );
```

### Animations

❌ Do not use:

* `AnimatedContainer`
* manual `AnimationController` for UI styling

✅ Use Mix animation system instead:

Defined in:

* `.agents/rules/mix/animations.md`

```dart
BoxStyler()
    .wrap(.opacity(1))
    .animate(duration: const Duration(milliseconds: 200));
```

### Summary Rule

#### UI styling rules hierarchy:

1. `.agents/rules/mix/SKILL.md` (must follow first)
2. `.agents/rules/mix/styling.md`
3. `.agents/rules/mix/tokens.md`
4. `.agents/rules/mix/variants.md`
5. `.agents/rules/mix/animations.md`
6. `.agents/rules/mix/widgets.md`
7. `.agents/rules/mix/examples.md`


### Hard Constraints

❌ Never use Material theming for UI styling
❌ Never use Theme.of(context) for design values
❌ Never hardcode colors, spacing, or typography
❌ Never mix Flutter widgets with Mix styling system
❌ Never guess Mix API — always consult rule files first

### Final Principle

> Mix is the **only styling system in this project**.
> Flutter Material is only the rendering shell.


## Layout Best Practices (Mix 2.0 Standard)

All layout must be built using **Mix layout widgets and composable styles**, not Flutter primitives directly.

Before implementing any layout, refer to:

* `.agents/rules/mix/widgets.md` → layout widgets (FlexBox, StackBox)
* `.agents/rules/mix/styling.md` → spacing, alignment, sizing rules
* `.agents/rules/mix/SKILL.md` → core layout constraints
* `.agents/rules/mix/variants.md` → responsive/state layout behavior
* `.agents/rules/mix/examples.md` → real layout patterns

> If a layout pattern is not covered in these files, do not invent it — inspect references first.

---

## Flexible & Overflow-Safe Layouts

### Core Rule

Mix replaces Flutter layout primitives with **styler-driven layout + flex widgets**:

* `FlexBoxStyler().row()` → Row equivalent
* `FlexBoxStyler().column()` → Column equivalent
* `StackBoxStyler()` → Stack equivalent

---

### 1. Flex Layout Control (Expanded / Flexible Replacement)

#### Instead of `Expanded`

Use Mix flex rules inside `FlexBoxStyler().row()` / `FlexBoxStyler().column()`:

```dart id="k9w3la"
FlexBoxStyler().row()(
  children: [
    BoxStyler().wrap(.expanded())(),
    BoxStyler().wrap(.expanded())(),
  ],
);
```

To create expansion behavior, use **flex configuration from Mix widgets API** (see `widgets.md`):

* prefer flex weights
* avoid implicit Flutter Expanded usage patterns

---

#### Instead of `Flexible`

Use flexible sizing via Mix flex configuration:

```dart id="v8q2mn"
FlexBoxStyler().row()(
  children: [
    BoxStyler().flex(1)(),
    BoxStyler().flex(2)(),
  ],
);
```

> Do NOT mix “expand + flexible” concepts manually — Mix handles sizing through flex rules.

---

### 2. Overflow Handling (Wrap Equivalent)

#### Instead of `Wrap`

Use **flow-aware layout patterns defined in Mix examples**.

Preferred approaches:

* responsive `FlexBoxStyler().row()` with wrapping behavior (if supported in widget layer)
* or segmented `FlexBoxStyler().column()` + row grouping

```dart id="w2x8qp"
FlexBoxStyler().column()(
  children: [
    FlexBoxStyler().row()(children: [tag1, tag2, tag3]),
    FlexBoxStyler().row()(children: [tag4, tag5]),
  ],
);
```

> Refer to `.agents/rules/mix/examples.md` for canonical wrap patterns.

---

### 3. Scrollable Content

#### Instead of `SingleChildScrollView`

Use Mix-compatible scroll containers (see `widgets.md`).

```dart id="s9ld2k"
BoxStyler()(
  child: FlexBoxStyler().column()(
    children: [...],
  ),
);
```

Wrap scroll behavior using the appropriate Mix scroll widget (defined in `widgets.md`).

> Rule: Scroll is a **container behavior**, not a layout wrapper.

---

### Lists & Grids

❌ Do not use raw `ListView` / `GridView` without patterns

✅ Use builder-based Mix patterns:

Defined in:

* `.agents/rules/mix/widgets.md`
* `.agents/rules/mix/examples.md`

Key rule:

* always use **builder-based rendering for large datasets**

---

### 4. Scaling Content (FittedBox Replacement)

Instead of `FittedBox`, use Mix sizing + alignment system:

```dart id="f1x9qa"
BoxStyler()
  .alignment(.center)
  .size(120, 120)(
  child: TextStyler()('Hello'),
);
```

> Scaling should be handled via styling, not widget wrapping.

---

### 5. Responsive Layouts

#### Instead of `Stack`

Use:

* `StackBox` (Mix layering container)
* alignment + offset styling
* variant-based positioning (preferred for dynamic states)

---

#### Positioning

Instead of `Positioned`:

```dart id="z4k8qv"
StackStyler()(
  children: [
    Box(style: backgroundStyle),
    Box(style: foregroundStyle),
  ],
);
```

Use:

* alignment tokens
* padding-based positioning
* variant-based layout shifts

---

#### Alignment (instead of Align)

Use styler alignment:

```dart id="a8m1qx"
BoxStyler()
  .alignment(.center)(
  child: child,
);
```

---

### Overflow Safety Rules

#### Always ensure:

* no implicit overflow in `RowBox/ColumnBox`
* use flex rules instead of fixed widths
* avoid hard pixel constraints unless token-driven
* prefer adaptive layouts via variants

---

### Layout Decision Matrix

| Need              | Mix Solution                        |
| ----------------- | ----------------------------------- |
| Horizontal layout | `FlexBoxStyler().row()`             |
| Vertical layout   | `FlexBoxStyler().column()`          |
| Layering          | `StackStyler()`                     |
| Flexible sizing   | `.flex(n)`                          |
| Overflow handling | structured flex or segmented layout |
| Alignment         | `.alignment()` styler               |
| Opacity           | `.wrap(.opacity())` styler          |
| Spacing           | `$Spaces.*()` tokens                |

---

### Forbidden Layout Patterns

❌ `Row`, `Column`, `Stack`
❌ `Expanded`, `Flexible` (Flutter versions)
❌ `Wrap` without documented pattern
❌ `Positioned`, `Align` widgets
❌ hardcoded pixel-based layout logic
❌ mixing Flutter layout + Mix widgets

---

### Final Rule

> Layout in Mix is **declarative, token-driven, and composable**.
> Flutter layout widgets are not part of the system.


## Color Scheme Best Practices

### Contrast Ratios

* **WCAG Guidelines:** Aim to meet the Web Content Accessibility Guidelines
  (WCAG) 2.1 standards.
* **Minimum Contrast:**
    * **Normal Text:** A contrast ratio of at least **4.5:1**.
    * **Large Text:** (18pt or 14pt bold) A contrast ratio of at least **3:1**.

### Palette Selection

* **Primary, Secondary, and Accent:** Define a clear color hierarchy.
* **The 60-30-10 Rule:** A classic design rule for creating a balanced color scheme.
    * **60%** Primary/Neutral Color (Dominant)
    * **30%** Secondary Color
    * **10%** Accent Color

### Complementary Colors

* **Use with Caution:** They can be visually jarring if overused.
* **Best Use Cases:** They are excellent for accent colors to make specific
  elements pop, but generally poor for text and background pairings as they can
  cause eye strain.

### Example Palette

* **Primary:** #0D47A1 (Dark Blue)
* **Secondary:** #1976D2 (Medium Blue)
* **Accent:** #FFC107 (Amber)
* **Neutral/Text:** #212121 (Almost Black)
* **Background:** #FEFEFE (Almost White)

## Font Best Practices

### Font Selection

* **Limit Font Families:** Stick to one or two font families for the entire
  application.
* **Prioritize Legibility:** Choose fonts that are easy to read on screens of
  all sizes. Sans-serif fonts are generally preferred for UI body text.
* **System Fonts:** Consider using platform-native system fonts.
* **Google Fonts:** For a wide selection of open-source fonts, use the
  `google_fonts` package.

### Hierarchy and Scale

* **Establish a Scale:** Define a set of font sizes for different text elements
  (e.g., headlines, titles, body text, captions).
* **Use Font Weight:** Differentiate text effectively using font weights.
* **Color and Opacity:** Use color and opacity to de-emphasize less important
  text.

### Readability

* **Line Height (Leading):** Set an appropriate line height, typically **1.4x to
  1.6x** the font size.
* **Line Length:** For body text, aim for a line length of **45-75 characters**.
* **Avoid All Caps:** Do not use all caps for long-form text.

## Documentation

* **`dartdoc`:** Write `dartdoc`-style comments for all public APIs.


### Documentation Philosophy

* **Comment wisely:** Use comments to explain why the code is written a certain
  way, not what the code does. The code itself should be self-explanatory.
* **Document for the user:** Write documentation with the reader in mind. If you
  had a question and found the answer, add it to the documentation where you
  first looked. This ensures the documentation answers real-world questions.
* **No useless documentation:** If the documentation only restates the obvious
  from the code's name, it's not helpful. Good documentation provides context
  and explains what isn't immediately apparent.
* **Consistency is key:** Use consistent terminology throughout your
  documentation.

### Commenting Style

* **Use `///` for doc comments:** This allows documentation generation tools to
  pick them up.
* **Start with a single-sentence summary:** The first sentence should be a
  concise, user-centric summary ending with a period.
* **Separate the summary:** Add a blank line after the first sentence to create
  a separate paragraph. This helps tools create better summaries.
* **Avoid redundancy:** Don't repeat information that's obvious from the code's
  context, like the class name or signature.
* **Don't document both getter and setter:** For properties with both, only
  document one. The documentation tool will treat them as a single field.

### Writing Style

* **Be brief:** Write concisely.
* **Avoid jargon and acronyms:** Don't use abbreviations unless they are widely
  understood.
* **Use Markdown sparingly:** Avoid excessive markdown and never use HTML for
  formatting.
* **Use backticks for code:** Enclose code blocks in backtick fences, and
  specify the language.

### What to Document

* **Public APIs are a priority:** Always document public APIs.
* **Consider private APIs:** It's a good idea to document private APIs as well.
* **Library-level comments are helpful:** Consider adding a doc comment at the
  library level to provide a general overview.
* **Include code samples:** Where appropriate, add code samples to illustrate usage.
* **Explain parameters, return values, and exceptions:** Use prose to describe
  what a function expects, what it returns, and what errors it might throw.
* **Place doc comments before annotations:** Documentation should come before
  any metadata annotations.

## Accessibility (A11Y)
Implement accessibility features to empower all users, assuming a wide variety
of users with different physical abilities, mental abilities, age groups,
education levels, and learning styles.

* **Color Contrast:** Ensure text has a contrast ratio of at least **4.5:1**
  against its background.
* **Dynamic Text Scaling:** Test your UI to ensure it remains usable when users
  increase the system font size.
* **Semantic Labels:** Use the `Semantics` widget to provide clear, descriptive
  labels for UI elements.
* **Screen Reader Testing:** Regularly test your app with TalkBack (Android) and
  VoiceOver (iOS).
