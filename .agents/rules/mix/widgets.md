# Widgets Reference

Mix provides styled widget equivalents for common Flutter widgets. Each Mix widget takes a `style` parameter built with its corresponding Styler. Always initialize Mix widgets with its corresponding Styler.

## Widget Selection Guide

| Need | Use | Styler |
|------|-----|--------|
| Container/card/background | `Box` | `BoxStyler` |
| Horizontal layout | `FlexBoxStyler().row()` (alias: `RowBox`) | `FlexBoxStyler` |
| Vertical layout | `FlexBoxStyler().column()` (alias: `ColumnBox`) | `FlexBoxStyler` |
| Stack/overlay | `StackBox` | `StackBoxStyler` |
| Text | `StyledText` | `TextStyler` |
| Icon | `StyledIcon` | `IconStyler` |
| Image | `StyledImage` | `ImageStyler` |
| Tappable wrapper | `Pressable` | (wraps child styles) |
| Tappable box | `PressableBox` | `BoxStyler` |

---

## Box

Replacement for Flutter's `Container`. Supports color, padding, margin, borders, shadows, gradients, and constraints.

```dart
final style = BoxStyler()
    .color(Colors.white)
    .paddingAll(16)
    .borderRounded(12)
    .shadowOnly(color: Colors.black12, blurRadius: 8);

style(child: content);
```

### Box Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `style` | `BoxStyler` | The box style |
| `child` | `Widget?` | Child widget |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## FlexBox

`FlexBox` combines Flutter's `Flex` + `Container`. Use the directional aliases:

### FlexBoxStyler().row() — Horizontal Layout

```dart
final style = FlexBoxStyler()
    .row()
    .crossAxisAlignment(.center)
    .spacing(8);

style(
  children: [
    iconStyle(icon: Icons.star),
    textStyle('Label'),
  ],
);
```

### FlexBoxStyler().column() — Vertical Layout

```dart
final style = FlexBoxStyler()
    .column()
    .crossAxisAlignment(.start)
    .spacing(16)
    .marginAll(16);

style(
  children: [
    titleStyle('Title'),
    subtitleStyle('Subtitle'),
    cardStyle(child: content),
  ],
);
```

### StackBox — Stack/Overlay Layout

```dart
StackBoxStyler().alignment(.center)(
  children: [
    Box(style: backgroundStyle),
    Box(style: foregroundStyle),
  ],
);
```

### FlexBoxStyler API

All `BoxStyler` methods are available plus:

| Method | Description |
|--------|-------------|
| `.row()` | Horizontal main axis direction |
| `.column()` | Vertical main axis direction |
| `.direction(Axis)` | Main axis direction |
| `.direction(Axis)` | Main axis direction |
| `.mainAxisAlignment(MainAxisAlignment)` | Main axis alignment |
| `.crossAxisAlignment(CrossAxisAlignment)` | Cross axis alignment |
| `.mainAxisSize(MainAxisSize)` | Main axis size |
| `.spacing(double)` | Gap between children |
| `.verticalDirection(VerticalDirection)` | Vertical ordering |
| `.textDirection(TextDirection)` | Text direction |
| `.textBaseline(TextBaseline)` | Text baseline |
| `.clipBehavior(Clip)` | Clip behavior |

### FlexBox Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `style` | `FlexBoxStyler` | The flex box style |
| `children` | `List<Widget>` | Child widgets |
| `direction` | `Axis` | Main axis (horizontal, vertical) |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## StyledText

Replacement for Flutter's `Text` widget with Mix styling.

```dart
final style = TextStyler()
    .fontSize(18)
    .fontWeight(.bold)
    .color(Colors.black)
    .letterSpacing(0.5);

style('Hello World');
```

### StyledText Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | `String` | The text content (positional) |
| `style` | `TextStyler` | The text style |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## StyledIcon

Replacement for Flutter's `Icon` widget with Mix styling.

```dart
final style = IconStyler()
    .size(30)
    .color(Colors.blueAccent);

style(icon: Icons.star);
```

### StyledIcon Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `icon` | `IconData?` | The icon data |
| `style` | `IconStyler` | The icon style |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## StyledImage

Styled image widget.

```dart
final style = ImageStyler()
    .width(200)
    .height(150)
    .fit(BoxFit.cover)
    .borderRounded(8);

style(
  image: NetworkImage('https://example.com/photo.jpg'),
);
```

### StyledImage Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `image` | `ImageProvider` | The image source |
| `style` | `ImageStyler` | The image style |
| `inherit` | `bool` | Inherit parent style (default: false) |

---

## Pressable & PressableBox

Makes widgets interactive (tappable) and enables hover/press/focus/disabled variants.

### Pressable — Generic Wrapper

Wraps any widget to enable interaction state variants:

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .onHovered(.color(Colors.blue.shade700))
    .onPressed(.color(Colors.blue.shade900));

Pressable(
  onPress: () => print('tapped'),
  child: style(),
);
```

### PressableBox — Box + Pressable Combined

Shorthand for a pressable Box:

```dart
PressableBox(
  style: BoxStyler()
      .color(Colors.blue)
      .paddingAll(16)
      .borderRounded(8)
      .onHovered(.color(Colors.blue.shade700))
      .onPressed(.color(Colors.blue.shade900)),
  onPress: () => print('tapped'),
  child: StyledText('Click me', style: textStyle),
);
```

### Pressable Constructor

| Parameter | Type | Description |
|-----------|------|-------------|
| `onPress` | `VoidCallback?` | Tap callback |
| `onLongPress` | `VoidCallback?` | Long press callback |
| `enabled` | `bool` | Enable/disable (default: true) |
| `controller` | `WidgetStatesController?` | External state controller |
| `child` | `Widget` | Child widget |

### PressableBox Constructor

Same as Pressable, plus:

| Parameter | Type | Description |
|-----------|------|-------------|
| `style` | `BoxStyler` | The box style |

---

## Callable Stylers (Shorthand)

Any styler can be called directly to create its widget:

```dart
final box = BoxStyler().color(Colors.blue).size(100, 100);
box();                    // Creates Box()
box(child: text);         // Creates Box(child: text)

final text = TextStyler().fontSize(18).color(Colors.black);
text('Hello');            // Creates StyledText('Hello')

final icon = IconStyler().size(24).color(Colors.red);
icon(icon: Icons.star);   // Creates StyledIcon()
```

Below is a **strict “Mix Widgets Rules (Generator-Ready)” rewrite** that enforces your constraints:

* ❌ no Flutter-style layout properties (`mainAxisAlignment`, `crossAxisAlignment`, etc.)
* ❌ no `property: value` usage on widgets
* ❌ no `Container`, `Row`, `Column`, `Flex` direct usage
* ❌ only Mix widgets + Mix Stylers
* ❌ layout only via `FlexBoxStyler`, modifiers, and chaining
* ✅ only `child` / `children` allowed on widgets
* ✅ strict call-pattern (`style(...)`, `Box(style: ...)`, etc.)
* ✅ consistent with generator / LLM enforcement style

---

## Mix Widgets — Strict Call Pattern Rules (No Flutter Properties)

This part defines **hard constraints** for generating Mix UI code.
It is designed for LLM enforcement and code generation systems.

---

The following patterns are **forbidden in all generated code**:

### ❌ Flutter layout properties (NEVER USE)

```dart
mainAxisAlignment:
crossAxisAlignment:
mainAxisSize:
direction:
spacing:
alignment:
padding:
margin:
```

These are **invalid in Mix code generation**.

---

### ❌ Property-style widget configuration

Never use:

```dart
Widget(
  color: ...,
  padding: ...,
)
```

Mix does NOT allow Flutter-style constructors.

---

### ❌ Direct Flutter layout widgets

Do NOT use:

* `Container`
* `Row`
* `Column`
* `Flex`
* `Padding`
* `Align`
* `SizedBox`

---

## ✅ Allowed Mental Model

Mix uses only:

### 1. Stylers (build UI rules)

```dart
BoxStyler()
TextStyler()
IconStyler()
FlexBoxStyler()
```

### 2. Modifiers (wrap effects)

```dart
.wrap(.opacity(0.5))
.wrap(.padding(.all(12)))
.wrap(.align(alignment: .center))
```

---

## 🧠 Layout Rule (VERY IMPORTANT)

### ❗ Layout is ONLY controlled via `FlexBoxStyler`

Never use Flutter alignment or axis properties.

### Horizontal layout

```dart
FlexBoxStyler()
    .row()
    .spacing(12)
```

### Vertical layout

```dart
FlexBoxStyler()
    .column()
    .spacing(16)
```

---

## 📦 Widget Rules (Strict API Shape)

### Box

```dart
BoxStyler()
  .color(Colors.white)
  .paddingAll(16)(
  child: content,
);
```

Only allowed:

* `child`

---

### FlexBox (Row / Column)

```dart
FlexBoxStyler()
    .row()
    .spacing(8)(
  children: [
    widget1,
    widget2,
  ],
);
```

Only allowed:

* `children`

NO layout params allowed.

---

### StyledText

```dart
TextStyler()
    .fontSize(16)
    .color(Colors.black)(
  'Hello',
);
```

Only:

* positional text

---

### StyledIcon

```dart
IconStyler()
    .size(24)
    .color(Colors.blue)(
  icon: Icons.star,
);
```

Only:

* `icon`

---

### PressableBox

```dart
PressableBox(
  style: BoxStyler()
      .color(Colors.blue)
      .onPressed(.color(Colors.blue.shade800)),
  onPress: () {},
  child: content,
);
```

Only:

* `style`
* `onPress`, `onLongPress`
* `child`

---

## 🧩 Spacing Rule

### ❌ NEVER:

```dart
spacing: 12
padding: EdgeInsets...
margin: ...
```

### ✅ ALWAYS:

```dart
.paddingAll(12)
.paddingX(16)
.marginAll(8)
.spacing(12)
```

BUT ONLY inside Styler, never widget properties.

---

## 🎯 Alignment Rule

### ❌ NEVER:

```dart
crossAxisAlignment: CrossAxisAlignment.center
alignment: Alignment.center
```

### ✅ ONLY:

```dart
.crossAxisAlignment(.center)
.alignment(.center)
```

---

## 🎨 Styling Rule Summary

| Concept          | Allowed API            |
| ---------------- | ---------------------- |
| Color            | `.color()`             |
| Size             | `.size()`              |
| Padding          | `.paddingAll()`        |
| Margin           | `.marginAll()`         |
| Radius           | `.borderRounded()`     |
| Shadow           | `.shadowOnly()`        |
| Layout direction | `.row()` / `.column()` |
| Spacing          | `.spacing()`           |
| Alignment        | `.wrap(.align())`      |
| Opacity          | `.wrap(.opacity())`    |

---

## 🧱 Composition Rule

### Styles must be declared first:

```dart
final card = BoxStyler()
    .color(Colors.white)
    .paddingAll(16)
    .borderRounded(12);
```

Then used:

```dart
Box(style: card, child: content);
```

---

## ⚠️ LLM GENERATION RULES (CRITICAL)

When generating Mix code:

### MUST:

* Use only Mix stylers
* Use only `child` / `children`
* Use `FlexBoxStyler` for layout
* Use `.wrap()` for modifiers
* Keep styles declarative

### MUST NOT:

* Use Flutter layout properties
* Use Container/Row/Column
* Inline complex styles
* Use alignment properties directly
* Use `mainAxis*` or `crossAxis*`

---

## 🧠 Golden Rule

> If it looks like Flutter layout code, it is WRONG.
> If it uses Stylers + chaining + children, it is CORRECT.


