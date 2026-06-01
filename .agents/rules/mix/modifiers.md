
# Mix 2.0 — Widget Modifiers Rules

This skill defines how to correctly use **Mix Widget Modifiers**.

Modifiers are **not style properties**.
They are **widget wrappers** that are declared inside a styler using `.wrap()`.

They stay composable, mergeable, and animatable as part of Mix’s styling system.

---

# Core Concept

## Modifiers wrap widgets

Use `.wrap()` to apply a modifier:

```dart
final style = BoxStyler()
    .color(Colors.red)
    .size(100, 100)
    .wrap(.opacity(0.4));
```

Equivalent Flutter tree:

```dart
Opacity(
  opacity: 0.4,
  child: Box(...),
);
```

---

# Style Properties vs Modifiers

## Style properties (NOT wrappers)

These directly affect widget rendering:

* color
* padding (styler-level padding is NOT a modifier wrapper)
* border
* shadow
* size

Example:

```dart
BoxStyler().color(Colors.red)
```

---

## Modifiers (WRAPPERS)

These create additional widgets:

* opacity → `Opacity`
* visibility → `Visibility`
* align → `Align`
* padding (modifier form) → `Padding`
* aspectRatio → `AspectRatio`
* flexible → `Flexible`
* transform → `Transform`
* clipping → `ClipRect`, `ClipRRect`, `ClipOval`

---

# Built-in Modifiers

| Modifier         | Wrapper     |
| ---------------- | ----------- |
| `.opacity()`     | Opacity     |
| `.padding()`     | Padding     |
| `.align()`       | Align       |
| `.aspectRatio()` | AspectRatio |
| `.flexible()`    | Flexible    |
| `.transform()`   | Transform   |
| `.visibility()`  | Visibility  |
| `.clipRect()`    | ClipRect    |
| `.clipRRect()`   | ClipRRect   |
| `.clipOval()`    | ClipOval    |

---

# Chaining Modifiers

Multiple modifiers are applied using repeated `.wrap()` calls:

```dart
final style = BoxStyler()
    .color(Colors.white)
    .size(200, 100)
    .wrap(.opacity(0.9))
    .wrap(.padding(.all(16)))
    .wrap(.align(alignment: .center));
```

---

# Modifier Ordering System

Mix does NOT apply modifiers in chain order.

It uses a **deterministic pipeline**.

---

## Default Modifier Phases

| Phase | Type                  |
| ----- | --------------------- |
| 1     | Context & behavior    |
| 2     | Size constraints      |
| 3     | Layout positioning    |
| 4     | Spacing               |
| 5     | Transforms & clipping |
| 6     | Final effects         |

---

## Phase Details

### 1. Context & behavior

* Flexible
* Visibility
* DefaultTextStyle
* IconTheme

### 2. Size

* SizedBox
* AspectRatio
* Intrinsic sizing

### 3. Layout

* Align
* RotatedBox

### 4. Spacing

* Padding

### 5. Visual transforms

* Transform
* ClipRRect
* ClipOval
* ClipRect
* Scale / Rotate / Translate

### 6. Final effects

* Opacity
* Blur
* ShaderMask

---

## Example: order does NOT matter

```dart
final a = BoxStyler()
    .wrap(.opacity(0.5))
    .wrap(.padding(.all(8)))
    .wrap(.align(alignment: .center));

final b = BoxStyler()
    .wrap(.align(alignment: .center))
    .wrap(.padding(.all(8)))
    .wrap(.opacity(0.5));
```

Both produce:

```text
Align
 └─ Padding
     └─ Opacity
         └─ Box
```

---

# Custom Modifier Order

Override ordering per style:

```dart
final style = BoxStyler()
    .wrap(.opacity(0.5))
    .wrap(.padding(.all(8)))
    .wrap(.orderOfModifiers([
      CustomModifier,
      PaddingModifier,
    ]));
```

Rules:

* Listed modifiers override default pipeline
* Unlisted modifiers fall back to default positions

---

# Global Modifier Order (MixScope)

Set app-wide ordering:

```dart
MixScope(
  orderOfModifiers: [
    VisibilityModifier,
    PaddingModifier,
    AlignModifier,
    TransformModifier,
    CustomModifier,
  ],
  child: MyApp(),
);
```

Rules:

* Applies globally
* Per-style `.orderOfModifiers()` overrides this

---

# Critical Rule: Visual Impact of Order

Modifier order changes rendering:

### Opacity BEFORE padding

* padding becomes transparent

### Opacity AFTER padding

* only content is transparent

This is why ordering matters.

---

# Creating Custom Modifiers

Custom modifiers require two parts:

---

## 1. WidgetModifier (runtime behavior)

```dart
final class CustomModifier extends WidgetModifier<CustomModifier> {
  final double custom;

  const CustomModifier(this.custom);

  @override
  Widget build(Widget child) {
    return Custom(custom: custom, child: child);
  }

  @override
  CustomModifier lerp(CustomModifier? other, double t) {
    if (other == null) return this;
    return CustomModifier(
      MixOps.lerp(custom, other.custom, t)!,
    );
  }

  @override
  CustomModifier copyWith({double? custom}) {
    return CustomModifier(custom ?? this.custom);
  }
}
```

### Responsibilities

* `build()` → wraps widget
* `lerp()` → animation interpolation
* `copyWith()` → immutable updates

---

## 2. ModifierMix (compile-time + tokens)

```dart
class CustomModifierMix extends ModifierMix<CustomModifier> {
  final Prop<Custom>? custom;

  const CustomModifierMix.create({this.custom});

  CustomModifierMix({double? custom})
      : this.create(custom: Prop.maybe(custom));

  @override
  CustomModifier resolve(BuildContext context) {
    return CustomModifier(
      MixOps.resolve(context, custom),
    );
  }

  @override
  CustomModifierMix merge(CustomModifierMix? other) {
    if (other == null) return this;

    return CustomModifierMix.create(
      custom: MixOps.merge(custom, other.custom),
    );
  }
}
```

### Responsibilities

* `resolve()` → converts tokens/props into runtime modifier
* `merge()` → combines styles (other wins)
* supports `Prop<T>` system

---

## 3. Usage

### Direct value

```dart
final style = BoxStyler()
    .wrap(.opacity(0.4));
```

---

### Token-based

```dart
final $opacity = DoubleToken('custom.opacity');

final style = BoxStyler()
    .wrap(
      CustomModifierMix.create(
        opacity: Prop.token($opacity),
      ),
    );
```

---

# Best Practices

## Use modifiers ONLY for:

* opacity
* visibility
* clipping
* alignment
* layout wrappers (Flexible, Align)

---

## DO NOT use modifiers for:

* color
* border
* padding (styler-level preferred)
* shadows
* typography

---

## Keep chains short

❌ Bad:

```dart
.wrap(...).wrap(...).wrap(...).wrap(...)
```

✔ Good:

* split into multiple styles
* or compose widgets

---

## Always implement lerp

Without `lerp()`:

* animations will snap
* transitions will not interpolate

---

# Mental Model

Think of Mix rendering as:

```text
Styler → Style → Modifier pipeline → Widget tree
```

Modifiers are **outer layers**, not style properties.

---

# Final Rule

Modifiers are:

* declarative wrappers
* order-aware
* animatable
* composable

NOT:

* style attributes
* layout parameters
* direct widget constructors
