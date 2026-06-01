---
name: mix-coding
description: "Use when the user asks to write Flutter code using Mix, or mentions Mix styling, BoxStyler, TextStyler, IconStyler, variants, animations, design tokens, theming, MixScope, or Mix widgets like Box, RowBox, ColumnBox, StyledText, StyledIcon, StyledImage, and PressableBox. Also trigger when user references 'package:mix', fluent styling, token systems, or glassmorphism interfaces in Flutter. This skill ensures correct, idiomatic Mix 2.0 code using the project's custom architecture, token system, and theme implementation patterns."
---

# Mix 2.0 — Correct Code Patterns

This skill ensures you write correct Mix 2.0 code using the project's documented architecture and APIs.

Mix separates style semantics from widgets using a **Spec / Style / Widget** architecture with immutable fluent stylers.

**This is a rigid skill.**
Do not invent APIs, method names, or widget patterns.
Always follow the documented structures and reference files.

---

# Core Principles

These rules apply to ALL Mix code.

## Always Import Mix

```dart
import 'package:mix/mix.dart';
```
---

## Use Fluent Chaining

Build styles by chaining methods on stylers.

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .paddingAll(16)
    .borderRounded(12);
```

---

## Specs Are Immutable

Never construct Specs directly.

Always use Stylers:

* `BoxStyler`
* `TextStyler`
* `IconStyler`
* `ImageStyler`
* `FlexBoxStyler`

Correct:

```dart
final style = BoxStyler().color(Colors.red);
```

Wrong:

```dart
final spec = BoxSpec(...);
```

---

## Define Styles as Variables

Prefer extracted styles over inline styling.

Correct:

```dart
final cardStyle = BoxStyler()
    .color(Colors.white)
    .paddingAll(16);

cardStyle();
```

Wrong:

```dart
BoxStyler()
      .color(Colors.white)
      .paddingAll(16)();
```

---

## Dart SDK >= 3.11

Dot shorthands are enabled.

Examples:

```dart
.center
.bold
.topLeft
.bottomRight
.dark
.light
```

---

## Stylers Are Callable

Stylers can directly create widgets.

```dart
final box = BoxStyler()
    .color(Colors.blue)
    .size(100, 100);

Box(style: box);

box(); // prefer shorthand
```

---

## Factory Constructors

Prefer factory constructors when appropriate.

```dart
BoxStyler.color(Colors.blue)

TextStyler.fontSize(16)

IconStyler.size(20)
```

---

# Widget ↔ Styler Mapping

| Widget         | Styler                   | Purpose                   |
| -------------- | ------------------------ | ------------------------- |
| `Box`          | `BoxStyler`              | Container/card/background |
| `RowBox`       | `FlexBoxStyler.row()`    | Horizontal layouts        |
| `ColumnBox`    | `FlexBoxStyler.column()` | Vertical layouts          |
| `StackBox`     | `StackBoxStyler`         | Overlay/stack layouts     |
| `StyledText`   | `TextStyler`             | Typography                |
| `StyledIcon`   | `IconStyler`             | Icons                     |
| `StyledImage`  | `ImageStyler`            | Images                    |
| `PressableBox` | wraps styles             | Interactive components    |

---

# Common Mistakes

| Wrong                         | Correct                                | Why                        |
| ----------------------------- | -------------------------------------- | -------------------------- |
| `Container(color: ...)`       | `BoxStyler()(...)`                      | Use Mix widgets            |
| `Text(style: TextStyle(...))` | `TextStyler()(...)` | Use Mix typography         |
| `Icon(Icons.star)`            | `IconStyler()(icon: ...)`    | Use Mix icon system        |
| Inline complex styles         | Extract style variables                | Reusability/readability    |
| `Theme.of(context)` colors    | Use tokens                             | Consistent design system   |
| Nested `Padding` widgets      | `.paddingAll()`                        | Styling belongs in stylers |
| Mutating stylers              | Chain methods                          | Stylers are immutable      |

---

# Reference Routing

Read only the relevant reference files before generating code.

| User Request                          | Reference                  |
| ------------------------------------- | -------------------------- |
| Styling, gradients, shadows, borders  | `references/styling.md`    |
| Hover, pressed, dark mode, variants   | `references/variants.md`   |
| Animations, keyframes, spring physics | `references/animations.md` |
| Tokens, MixScope, themes              | `references/tokens.md`     |
| Layout/widgets                        | `references/widgets.md`    |
| Full examples/patterns                | `references/examples.md`   |

Do not load unnecessary references.

---

# Style Composition

Styles compose through chaining and merging.

```dart
final base = BoxStyler()
    .paddingX(16)
    .paddingY(12)
    .borderRounded(12);

final primary = base.color(Colors.blue);

final danger = base.color(Colors.red);
```

Use `.merge()` when combining styles dynamically.

```dart
final merged = base.merge(overrideStyle);
```

---

# Variants

Use variants for interactive or contextual styling.

## Hover

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .onHovered(
      .color(Colors.blue.shade700),
    );
```

---

## Pressed

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .onPressed(
      .scale(0.96),
    );
```

---

## Dark Mode

```dart
final style = BoxStyler()
    .color(Colors.white)
    .onDark(
      .color(Colors.black),
    );
```

---

# Animations

Mix supports:

1. Implicit animations
2. Phase animations
3. Keyframe animations

---

## Implicit Animation

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .animate(.easeInOut(300.ms))
    .onHovered(
      .color(Colors.purple),
    );
```

---

## Spring Animation

```dart
.animate(.spring(600.ms))
```

---

## Keyframe Animation

```dart
KeyframeAnimationBuilder(
  duration: 400.ms,
  keyframes: {
    KeyframeTrack<double>(
      property: KeyframeProperty.translateX,
      keyframes: [
        Keyframe(0.0, 0),
        Keyframe(1.0, 24),
      ],
    ),
  },
  builder: (context, style) {
    return Box(style: base.merge(style));
  },
);
```

---

# Token Architecture

This project uses enum-based tokens.

Always use tokens instead of hardcoded values whenever possible.

---

# Token Pattern

## Color Tokens

```dart
enum $Colors {
  primary(ColorToken('color.primary')),
  background(ColorToken('color.background'));

  const $Colors(this.token);

  final ColorToken token;

  ColorRef call() => token();

  Color resolve(BuildContext context) {
    return token.resolve(context);
  }
}
```

Usage:

```dart
BoxStyler()
    .color($Colors.primary());
```

---

## Text Style Tokens

```dart
enum $TextStyles {
  h1(TextStyleToken('text.h1'));

  const $TextStyles(this.token);

  final TextStyleToken token;

  TextStyleMixRef call() => token.mix();

  TextStyle resolve(BuildContext context) {
    return token.resolve(context);
  }
}
```

Usage:

```dart
TextStyler()
    .style($TextStyles.h1())
    .color($Colors.textPrimary());
```

---

## Space Tokens

```dart
.paddingAll($Spaces.md())
```

---

## Radius Tokens

```dart
.borderRadiusAll($Radius.medium())
```

---

## Blur Radius Tokens

```dart
.blur($BlurRadius.large())
```

---

# Theme Architecture

The project uses a layered theme architecture.

Structure:

```text
AppTheme
  └── BaseTheme
        ├── LightTheme
        └── DarkTheme
```

---

# AppTheme Contract

```dart
mixin AppTheme {
  Map<SpaceToken, double> get spaces;
  Map<DoubleToken, double> get blurRadii;
  Map<RadiusToken, Radius> get radii;
  Map<ColorToken, Color> get colors;
  Map<TextStyleToken, TextStyle> get textStyles;

  PortalColors get portalColors;
  PortalTypography get portalTypography;
}
```

---

# BaseTheme Pattern

Use abstract base themes for shared definitions.

```dart
abstract base class BaseTheme implements AppTheme {
  const BaseTheme();

  @override
  Map<SpaceToken, double> get spaces => {
    for (final $Spaces space in $Spaces.values)
      space.token: switch (space) {
        .xxs => 4,
        .xs => 8,
        .sm => 12,
        .md => 16,
        .lg => 24,
        .xl => 32,
        .xxl => 48,
      },
  };
}
```

---

# Theme Token Mapping Rules

Use exhaustive `switch` expressions.

Correct:

```dart
switch (space) {
  .md => 16,
  .lg => 24,
}
```

Wrong:

```dart
if (space == $Spaces.md)
```

---

# Text Style Theme Rules

Typography must derive colors from token maps.

Correct:

```dart
TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: colors[$Colors.textPrimary.token],
)
```

Do not hardcode typography colors.

---

# Light/Dark Themes

Themes override only token values.

Correct:

```dart
final class LightTheme extends BaseTheme {
  const LightTheme();

  @override
  Map<ColorToken, Color> get colors => {
    for (final $Colors color in $Colors.values)
      color.token: switch (color) {
        .primary => const Color(0xFF1D1D1F),
        .background => const Color(0xFFF8F9FB),
      },
  };
}
```

---

# Theme Enum Pattern

```dart
enum Themes {
  light(LightTheme()),
  dark(DarkTheme());

  const Themes(this.instance);

  final AppTheme instance;
}
```

---

# Font Enum Pattern

```dart
enum Fonts {
  gotham('Gotham Pro'),
  sf('.SF Pro Text');

  const Fonts(this.font);

  final String font;
}
```

---

# MixScope Usage

Provide themes through `MixScope`.

```dart
MixScope(
  colors: theme.colors,
  spaces: theme.spaces,
  radii: theme.radii,
  textStyles: theme.textStyles,
  child: app,
);
```

---

# Documentation Rules

Follow Effective Dart guidelines.

Reference:
[https://dart.dev/effective-dart](https://dart.dev/effective-dart)

---

## Public API Documentation

All public APIs must use doc comments.

Correct:

```dart
/// A styled profile card widget.
final class ProfileCard extends HookConsumerWidget {
  /// Creates a profile card.
  const ProfileCard(this.title, {super.key});

  /// The displayed title.
  final String title;
}
```

Wrong:

```dart
class ProfileCard {}
```

---

## Use `public_member_api_docs`

Enable:

```yaml
linter:
  rules:
    - public_member_api_docs
```

---

# Dart Best Practices

* Use sound null safety
* Avoid unnecessary `!`
* Prefer exhaustive `switch`
* Use records when appropriate
* Use pattern matching
* Use arrow syntax for simple methods
* Use async/await correctly
* Use Streams for async sequences
* Keep related classes in same library
* Avoid trailing comments
* Write comments only when useful

---

# Preferred Architecture Patterns

## Reusable Styles

```dart
abstract final class AppStyles {
  static final card = BoxStyler()
      .borderRounded(24)
      .paddingAll($Spaces.md());
}
```

---

## Component Styling

```dart
final boxStyle = BoxStyler()
    .color($Colors.surface())
    .borderRadiusAll($Radius.large());

final textStyle = TextStyler()
    .style($TextStyles.bodyLarge())
    .color($Colors.textPrimary());
```

---

# Glassmorphism Pattern

Use tokenized glass colors.

```dart
BoxStyler()
    .color($GlassColors.primary())
    .border(
      color: $GlassColors.border(),
    )
    .blur($BlurRadius.large());
```

---

# Animation Best Practices

Prefer implicit animations for UI state transitions.

Use keyframes only for:

* toggles
* loops
* timelines
* multi-track choreography

Use phase animations for tap flows and sequences.

---

# Final Rules

* Prefer semantic tokens over hardcoded values
* Prefer extracted styles over inline styling
* Use Mix widgets instead of Flutter primitives
* Follow exhaustive switch patterns
* Never invent APIs
* Always follow the project's theme/token architecture
* Use variants and animations idiomatically

```
