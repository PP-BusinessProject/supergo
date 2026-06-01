## Design System & Token Architecture

Use a centralized token architecture with strongly typed enums and theme contracts. All visual values (colors, typography, spacing, radii, blur values) must come from Mix tokens instead of hardcoded constants.

### Theme Structure

Define themes as enum variants implementing a shared `AppTheme` contract:

```dart
enum Themes {
  light(LightTheme()),
  dark(DarkTheme());

  const Themes(this.instance);

  /// Concrete theme implementation.
  final AppTheme instance;
}
```

### Font Definitions

Store font families in enums instead of string literals:

```dart
enum Fonts {
  gotham('Gotham Pro'),
  sf('.SF Pro Text');

  const Fonts(this.font);

  /// Registered font family name.
  final String font;
}
```

---

# Token Patterns

## Color Tokens

Use semantic color names. Never reference raw colors directly inside features/components.

```dart
enum $Colors {
  primary(ColorToken('color.primary')),
  background(ColorToken('color.background')),
  surface(ColorToken('color.surface')),
  textPrimary(ColorToken('color.textPrimary')),
  textSecondary(ColorToken('color.textSecondary')),
  border(ColorToken('color.border')),
  error(ColorToken('color.error')),
  warning(ColorToken('color.warning'));

  const $Colors(this.token);

  /// Underlying Mix token.
  final ColorToken token;

  /// Returns a ColorRef for Mix styles.
  ColorRef call() => token();

  /// Resolves the concrete color from context.
  Color resolve(BuildContext context) => token.resolve(context);
}
```

### Usage

```dart
final style = BoxStyler()
    .color($Colors.surface())
    .borderColor($Colors.border());

final textStyle = TextStyler()
    .color($Colors.textPrimary());
```

### Rules

* Use semantic names (`primary`, `surface`, `textPrimary`)
* Never use component-specific names (`buttonBlue`)
* Never hardcode colors in widgets
* Resolve colors only when interoperating with Flutter APIs

---

## Text Style Tokens

Centralize typography using `TextStyleToken`.

```dart
enum $TextStyles {
  h1(TextStyleToken('text.h1')),
  h2(TextStyleToken('text.h2')),
  h3(TextStyleToken('text.h3')),
  h4(TextStyleToken('text.h4')),
  bodyLarge(TextStyleToken('text.bodyLarge')),
  bodyMedium(TextStyleToken('text.bodyMedium')),
  caption(TextStyleToken('text.caption')),
  labelButton(TextStyleToken('text.labelButton'));

  const $TextStyles(this.token);

  /// Underlying Mix token.
  final TextStyleToken token;

  /// Returns a TextStyleMixRef for Mix styles.
  TextStyleMixRef call() => token.mix();

  /// Resolves the concrete TextStyle.
  TextStyle resolve(BuildContext context) => token.resolve(context);
}
```

### Usage

```dart
final titleStyle = TextStyler()
    .style($TextStyles.h1())
    .color($Colors.textPrimary());

final bodyStyle = TextStyler()
    .style($TextStyles.bodyMedium())
    .color($Colors.textSecondary());
```

### Rules

* Typography must come from tokens
* Do not manually define font sizes inside widgets
* Use semantic typography (`h1`, `bodyMedium`, `caption`)
* Text styles should define font family, weight, height, spacing, and size centrally

---

## Radius Tokens

Use radius tokens for all rounded corners.

```dart
enum $Radius {
  small(RadiusToken('radius.small')),
  medium(RadiusToken('radius.medium')),
  large(RadiusToken('radius.large')),
  xlarge(RadiusToken('radius.xlarge'));

  const $Radius(this.token);

  /// Underlying Mix token.
  final RadiusToken token;

  /// Returns a RadiusRef for Mix styles.
  RadiusRef call() => token();

  /// Resolves the concrete radius.
  Radius resolve(BuildContext context) => token.resolve(context);
}
```

### Usage

```dart
final cardStyle = BoxStyler()
    .borderRadiusAll($Radius.large());

final buttonStyle = BoxStyler()
    .borderRadiusAll($Radius.medium());
```

### Rules

* Never use `Radius.circular()` directly in components
* Use semantic sizes (`small`, `medium`, `large`)
* Maintain consistent rounding across the app

---

## Blur Radius Tokens

Store blur values as tokens for glassmorphism and shadow consistency.

```dart
enum $BlurRadius {
  xsmall(DoubleToken('blurRadius.xsmall')),
  small(DoubleToken('blurRadius.small')),
  medium(DoubleToken('blurRadius.medium')),
  large(DoubleToken('blurRadius.large')),
  xlarge(DoubleToken('blurRadius.xlarge'));

  const $BlurRadius(this.token);

  /// Underlying Mix token.
  final DoubleToken token;

  /// Returns the token reference value.
  double call() => token();

  /// Resolves the concrete value.
  double resolve(BuildContext context) => token.resolve(context);
}
```

### Usage

```dart
final glassStyle = BoxStyler()
    .backdropBlur($BlurRadius.large());
```

### Rules

* Use standardized blur levels
* Never hardcode blur radii
* Prefer semantic blur scales over arbitrary numbers

---

## Space Tokens

All spacing must come from `SpaceToken`.

```dart
enum $Spaces {
  xxs(SpaceToken('space.xxs')),
  xs(SpaceToken('space.xs')),
  sm(SpaceToken('space.sm')),
  md(SpaceToken('space.md')),
  lg(SpaceToken('space.lg')),
  xl(SpaceToken('space.xl')),
  xxl(SpaceToken('space.xxl'));

  const $Spaces(this.token);

  /// Underlying Mix token.
  final SpaceToken token;

  /// Returns the token reference value.
  double call() => token();

  /// Resolves the concrete spacing value.
  double resolve(BuildContext context) => token.resolve(context);
}
```

### Usage

```dart
final containerStyle = BoxStyler()
    .paddingAll($Spaces.md());

final layoutStyle = FlexBoxStyler()
    .spacing($Spaces.lg());
```

### Rules

* Never hardcode spacing values
* Use spacing scale consistently
* Prefer semantic spacing steps over arbitrary padding

---

# Theme Contract

All themes must implement a shared `AppTheme` mixin/interface.

```dart
mixin AppTheme {
  /// Spacing scale tokens.
  Map<SpaceToken, double> get spaces;

  /// Blur radius tokens.
  Map<DoubleToken, double> get blurRadii;

  /// Radius tokens.
  Map<RadiusToken, Radius> get radii;

  /// Color tokens.
  Map<ColorToken, Color> get colors;

  /// Typography tokens.
  Map<TextStyleToken, TextStyle> get textStyles;

  /// Generated semantic color system.
  PortalColors get portalColors;

  /// Generated typography system.
  PortalTypography get portalTypography;
}
```

---

## Theme Architecture Pattern

Use a shared abstract base theme to centralize all non-color token configuration (spacing, radii, blur, typography) and extend it for light/dark color systems.

This keeps theme structure scalable, type-safe, and consistent across the app.

---

# Base Theme Pattern

## Shared Theme Contract

Create a reusable abstract base class implementing `AppTheme`.

```dart
abstract base class BaseTheme implements AppTheme {
  const BaseTheme();

  @override
  Map<SpaceToken, double> get spaces => <SpaceToken, double>{
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

  @override
  Map<RadiusToken, Radius> get radii => <RadiusToken, Radius>{
    for (final $Radius radius in $Radius.values)
      radius.token: switch (radius) {
        .small => const Radius.circular(16),
        .medium => const Radius.circular(22),
        .large => const Radius.circular(28),
        .xlarge => const Radius.circular(36),
      },
  };

  @override
  Map<DoubleToken, double> get blurRadii => <DoubleToken, double>{
    for (final $BlurRadius radius in $BlurRadius.values)
      radius.token: switch (radius) {
        .xsmall => 20,
        .small => 30,
        .medium => 40,
        .large => 60,
        .xlarge => 80,
      },
  };

  @override
  Map<TextStyleToken, TextStyle> get textStyles => <TextStyleToken, TextStyle>{
    for (final $TextStyles style in $TextStyles.values)
      style.token: switch (style) {
        .h1 => TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: colors[$Colors.textPrimary.token],
          letterSpacing: -1,
        ),

        .h2 => TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: colors[$Colors.textPrimary.token],
          letterSpacing: -0.5,
        ),

        .h3 => TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colors[$Colors.textPrimary.token],
          letterSpacing: -0.5,
        ),

        .h4 => TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colors[$Colors.textPrimary.token],
          letterSpacing: -0.5,
        ),

        .bodyLarge => TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colors[$Colors.textPrimary.token],
        ),

        .bodyMedium => TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: colors[$Colors.textSecondary.token],
        ),

        .caption => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colors[$Colors.textSecondary.token],
        ),

        .labelButton => TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors[$Colors.textPrimary.token],
          letterSpacing: -0.2,
        ),
      },
  };

  @override
  PortalColors get portalColors => PortalColors(
    primary: colors[$Colors.primary.token]!,
    background: colors[$Colors.background.token]!,
    surface: colors[$Colors.surface.token]!,
    textPrimary: colors[$Colors.textPrimary.token]!,
    textSecondary: colors[$Colors.textSecondary.token]!,
    border: colors[$Colors.background.token]!,
    error: colors[$Colors.error.token]!,
    warning: colors[$Colors.warning.token]!,
  );

  @override
  PortalTypography get portalTypography => PortalTypography(
    h1: textStyles[$TextStyles.h1.token]!,
    h2: textStyles[$TextStyles.h2.token]!,
    h3: textStyles[$TextStyles.h3.token]!,
    h4: textStyles[$TextStyles.h4.token]!,
    bodyLarge: textStyles[$TextStyles.bodyLarge.token]!,
    bodyMedium: textStyles[$TextStyles.bodyMedium.token]!,
    caption: textStyles[$TextStyles.caption.token]!,
    labelButton: textStyles[$TextStyles.labelButton.token]!,
  );
}
```

---

# Light Theme Pattern

Extend `BaseTheme` and override only color tokens.

```dart
final class LightTheme extends BaseTheme {
  const LightTheme();

  @override
  Map<ColorToken, Color> get colors => <ColorToken, Color>{
    for (final $Colors color in $Colors.values)
      color.token: switch (color) {
        .primary => const Color(0xFF1D1D1F),
        .background => const Color(0xFFE3E6EB),
        .surface => const Color(0xFFF8F9FB),
        .textPrimary => const Color(0xFF1D1D1F),
        .textSecondary => const Color(0xFF5C5C66),
        .border => const Color(0xFFE1E4EA),
        .error => const Color(0xFFFF3B30),
        .warning => const Color(0xFFFFC857),
      },
  };
}
```

---

# Dark Theme Pattern

Dark themes should inherit all typography, spacing, radii, and blur values from the base theme while overriding semantic colors.

```dart
final class DarkTheme extends BaseTheme {
  const DarkTheme();

  @override
  Map<ColorToken, Color> get colors => <ColorToken, Color>{
    for (final $Colors color in $Colors.values)
      color.token: switch (color) {
        .primary => const Color(0xFFEDEDED),
        .background => const Color(0xFF020617),
        .surface => const Color(0xFF0F172A),
        .textPrimary => const Color(0xFFFFFFFF),
        .textSecondary => const Color(0xB3FFFFFF),
        .border => const Color(0x1AFFFFFF),
        .error => const Color(0xFFFF453A),
        .warning => const Color(0xFFFFD60A),
      },
  };
}
```

---

# Why This Pattern

## Centralized Non-Color Tokens

Typography, spacing, blur, and radius values are usually shared across themes. Defining them once prevents duplication.

## Exhaustive Switch Expressions

Using:

```dart
switch (space) { ... }
```

ensures all enum values are handled at compile time.

## Enum-Driven Maps

Using:

```dart
for (final $Spaces space in $Spaces.values)
```

guarantees token maps stay synchronized with enums.

## Semantic Theme Layers

Separate:
- global semantic colors (`$Colors`)
- glassmorphism tokens (`$GlassColors`)
- component-specific semantic tokens (`$ComponentColors`)

instead of mixing everything into one flat token map.

---

# Recommended Usage

Inject the active theme into `MixScope`:

```dart
final theme = Themes.dark.instance;

MixScope(
  colors: theme.colors,
  spaces: theme.spaces,
  radii: theme.radii,
  textStyles: theme.textStyles,
  child: app,
);
```

---

# Best Practices

## Prefer Semantic Tokens

Use:

```dart
$Colors.surface()
```

instead of:

```dart
Colors.white
```

## Keep Theme Values Immutable

Themes should be pure configuration objects with no mutable state.

## Use Strongly Typed Enums

Enums provide:
- autocomplete
- exhaustiveness checking
- centralized discovery
- safer refactoring

## Keep Tokens Hierarchical

Preferred token naming:

```text
color.primary
color.surface
glass.primary
space.md
radius.large
text.h1
```

Avoid arbitrary names like:

```text
buttonBlue
radius24
padding16
```

---

## Built-in Token Types

| Token Class | Value Type | Use Case |
|-------------|-----------|----------|
| `ColorToken` | `Color` | Colors and backgrounds |
| `SpaceToken` | `double` | Spacing (padding, margin) |
| `DoubleToken` | `double` | Any numeric value |
| `RadiusToken` | `Radius` | Border radii |
| `TextStyleToken` | `TextStyle` | Typography styles |
| `BorderSideToken` | `BorderSide` | Border definitions |
| `ShadowToken` | `List<Shadow>` | Text shadows |
| `BoxShadowToken` | `List<BoxShadow>` | Box shadows |
| `FontWeightToken` | `FontWeight` | Font weights |
| `DurationToken` | `Duration` | Animation durations |
| `BreakpointToken` | `Breakpoint` | Responsive breakpoints |

## MixScope Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `colors` | `Map<ColorToken, Color>` | Color token values |
| `spaces` | `Map<SpaceToken, double>` | Space token values |
| `radii` | `Map<RadiusToken, Radius>` | Radius token values |
| `textStyles` | `Map<TextStyleToken, TextStyle>` | Text style token values |
| `tokens` | `Map<MixToken, dynamic>` | Generic/custom tokens |
| `child` | `Widget` | Child widget tree |

---
