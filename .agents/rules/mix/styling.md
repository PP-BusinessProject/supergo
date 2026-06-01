# Styling Reference

## Patterns

### Creating a Style

```dart
// Start from constructor
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .borderRounded(12);

// Start from factory (equivalent)
final style = BoxStyler.color(Colors.blue)
    .size(100, 100)
    .borderRounded(12);
```

### Composing Styles

Build new styles on top of existing ones. Later values override earlier ones:

```dart
final base = BoxStyler()
    .paddingX(16)
    .paddingY(8)
    .borderRounded(8)
    .color(Colors.black);

final solid = base.color(Colors.blue);        // Override color only
final soft = base.color(Colors.blue.shade100); // Different override
```

### Merging Styles

Use `.merge()` to combine two stylers:

```dart
final layout = BoxStyler().paddingAll(16).size(200, 200);
final visual = BoxStyler().color(Colors.blue).borderRounded(12);
final combined = layout.merge(visual);
```

### Applying to Widgets

```dart
// Explicit style parameter
Box(style: style, child: child);

// Prefer callable shorthand
final box = BoxStyler().color(Colors.blue).size(100, 100);
box(child: child);  // Creates a Box widget
```

### Widget Modifiers (wrap)

Add widget-level behavior without nesting widgets:

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .wrap(
      .defaultTextStyle(
        style: TextStyler().color(Colors.white).fontWeight(.bold),
      ),
    );
```

---

## BoxStyler API

### Color & Background

| Method | Description |
|--------|-------------|
| `.color(Color)` | Background color |
| `.linearGradient({colors, begin, end, stops, tileMode})` | Linear gradient background |
| `.radialGradient({center, radius, colors, stops, tileMode})` | Radial gradient background |
| `.sweepGradient({center, startAngle, endAngle, colors, stops, tileMode})` | Sweep gradient background |
| `.backgroundImage(ImageProvider, {fit, alignment, repeat})` | Background image |
| `.backgroundImageUrl(String, {fit, alignment, repeat})` | Background image from URL |
| `.backgroundImageAsset(String, {fit, alignment, repeat})` | Background image from asset |

### Sizing & Constraints

| Method | Description |
|--------|-------------|
| `.width(double)` | Fixed width |
| `.height(double)` | Fixed height |
| `.size(double w, double h)` | Fixed width and height |
| `.minWidth(double)` | Minimum width |
| `.maxWidth(double)` | Maximum width |
| `.minHeight(double)` | Minimum height |
| `.maxHeight(double)` | Maximum height |

### Spacing

| Method | Description |
|--------|-------------|
| `.paddingAll(double)` | Padding on all sides |
| `.paddingX(double)` | Horizontal padding (left + right) |
| `.paddingY(double)` | Vertical padding (top + bottom) |
| `.paddingTop(double)` | Top padding |
| `.paddingBottom(double)` | Bottom padding |
| `.paddingLeft(double)` | Left padding |
| `.paddingRight(double)` | Right padding |
| `.paddingStart(double)` | Start padding (RTL-aware) |
| `.paddingEnd(double)` | End padding (RTL-aware) |
| `.paddingOnly({top, bottom, left, right})` | Individual padding |
| `.marginAll(double)` | Margin on all sides |
| `.marginX(double)` | Horizontal margin |
| `.marginY(double)` | Vertical margin |
| `.marginTop(double)` / `.marginBottom(double)` / `.marginLeft(double)` / `.marginRight(double)` | Directional margin |
| `.marginStart(double)` / `.marginEnd(double)` | RTL-aware margin |

### Border

| Method | Description |
|--------|-------------|
| `.borderAll({color, width, style, strokeAlign})` | Border on all sides |
| `.borderTop({color, width, style, strokeAlign})` | Top border |
| `.borderBottom({color, width, style, strokeAlign})` | Bottom border |
| `.borderLeft({color, width, style, strokeAlign})` | Left border |
| `.borderRight({color, width, style, strokeAlign})` | Right border |
| `.borderStart({color, width, style, strokeAlign})` | Start border (RTL-aware) |
| `.borderEnd({color, width, style, strokeAlign})` | End border (RTL-aware) |
| `.borderVertical({color, width, style, strokeAlign})` | Top + bottom borders |
| `.borderHorizontal({color, width, style, strokeAlign})` | Left + right borders |

### Border Radius

| Method | Description |
|--------|-------------|
| `.borderRounded(double)` | Uniform circular radius |
| `.borderRadiusAll(Radius)` | Uniform custom radius |
| `.borderRoundedTop(double)` | Top corners |
| `.borderRoundedBottom(double)` | Bottom corners |
| `.borderRoundedLeft(double)` | Left corners |
| `.borderRoundedRight(double)` | Right corners |
| `.borderRoundedTopLeft(double)` / `.borderRoundedTopRight(double)` | Individual corners |
| `.borderRoundedBottomLeft(double)` / `.borderRoundedBottomRight(double)` | Individual corners |

### Shadows

| Method | Description |
|--------|-------------|
| `.shadowOnly({color, offset, blurRadius, spreadRadius})` | Single box shadow |
| `.elevation(ElevationShadow)` | Material elevation shadow |

### Shape

| Method | Description |
|--------|-------------|
| `.shapeCircle({side})` | Circular shape |
| `.shapeStadium({side})` | Stadium/pill shape |
| `.shapeRoundedRectangle({side, borderRadius})` | Rounded rectangle |
| `.shapeBeveledRectangle({side, borderRadius})` | Beveled rectangle |
| `.shapeSuperellipse({side, borderRadius})` | Superellipse shape |

### Layout

| Method | Description |
|--------|-------------|
| `.alignment(AlignmentGeometry)` | Child alignment |
| `.clipBehavior(Clip)` | Clip behavior |

### Transform

| Method | Description |
|--------|-------------|
| `.rotate(double angle, {alignment})` | Rotation |
| `.scale(double, {alignment})` | Scale |
| `.translate(double x, double y)` | Translation |
| `.skew(double skewX, double skewY)` | Skew |

---

## TextStyler API

### Typography

| Method | Description |
|--------|-------------|
| `.fontSize(double)` | Font size |
| `.fontWeight(FontWeight)` | Font weight (e.g., `.bold`, `.w700`) |
| `.fontStyle(FontStyle)` | Italic/normal |
| `.fontFamily(String)` | Font family |
| `.letterSpacing(double)` | Letter spacing |
| `.wordSpacing(double)` | Word spacing |
| `.height(double)` | Line height multiplier |
| `.color(Color)` | Text color |
| `.backgroundColor(Color)` | Text background color |

### Text Layout

| Method | Description |
|--------|-------------|
| `.textAlign(TextAlign)` | Alignment (`.center`, `.left`, `.right`) |
| `.maxLines(int)` | Maximum line count |
| `.overflow(TextOverflow)` | Overflow behavior |
| `.softWrap(bool)` | Enable/disable soft wrapping |

### Text Decoration

| Method | Description |
|--------|-------------|
| `.decoration(TextDecoration)` | Underline, strikethrough, etc. |
| `.decorationColor(Color)` | Decoration color |
| `.decorationStyle(TextDecorationStyle)` | Decoration style |

### Text Directives (transforms)

| Method | Description |
|--------|-------------|
| `.uppercase()` | ALL CAPS |
| `.lowercase()` | all lowercase |
| `.capitalize()` | First letter uppercase |
| `.titlecase()` | Title Case |
| `.sentencecase()` | Sentence case |

### Using TextStyler

```dart
final style = TextStyler()
    .fontSize(20)
    .fontWeight(.w700)
    .color(Colors.red)
    .titlecase();

StyledText('hello world', style: style);
// Prefer shorthand:
style('hello world');
```

---

## IconStyler API

| Method | Description |
|--------|-------------|
| `.icon(IconData)` | Icon data |
| `.size(double)` | Icon size |
| `.color(Color)` | Icon color |
| `.weight(double)` | Icon weight |
| `.fill(double)` | Icon fill |
| `.opacity(double)` | Icon opacity |
| `.shadows(List<ShadowMix>)` | Icon shadows |

### Using IconStyler

```dart
final style = IconStyler.size(30).color(Colors.blueAccent);
StyledIcon(icon: Icons.star, style: style);
// Prefer shorthand:
style(icon: Icons.star);
```

Got it — this is not about “flat vs nested objects”, it’s about enforcing **Modifier-style chained struct arguments inside a single call**, not named parameters.

Here is the corrected rule in your format:

---

## 🚫 Absolute Prohibition: Named Parameters in Complex Styles

Never use named parameters for structured style configuration.

---

### ❌ FORBIDDEN (Flutter-style named arguments)

```dart id="a91kq2"
.shadow(
  color: $GlassColors.shadow(),
  blurRadius: 20,
  offset: Offset.zero,
)
```

```dart id="x7d1lm"
.border(
  color: Colors.black,
  width: 2,
)
```

```dart id="kq8z0p"
.shadow(color: ..., blurRadius: ..., offset: ...)
```

---

## ✅ REQUIRED PATTERN: Modifier Chain Argument DSL

All complex style values MUST use **chained modifier builders inside a single argument**.

---

### ✅ Shadow (correct)

```dart id="m4xq8c"
.shadow(
    .color($GlassColors.shadow())
    .blurRadius($BlurRadius.medium())
    .offset(x: 0, y: 0)
)
```

---

### ✅ Border (correct)

```dart id="z91vkc"
.border(
    .color(Colors.black)
    .width(2)
)
```

---

### ✅ Gradient (correct)

```dart id="p0wqld"
.linearGradient(
  .colors([
    $Colors.primary.resolve(context),
    $Colors.surface.resolve(context),
  ])
  .begin(.topLeft)
  .end(.bottomRight)
)
```

---

## 🧠 Core Rule

> Complex style parameters are NOT arguments — they are **builder chains passed as a single expression**

---

## 🧱 Mental Model

### ❌ Wrong (Flutter model)

```text id="f1k2aa"
method(
  param: value,
  param: value
)
```

---

### ✅ Correct (Mix model)

```text id="f9m3bb"
method(
  .param(value)
   .param(value)
)
```

---

## 📦 Supported Chain Builders

Inside complex style arguments, ONLY these patterns are allowed:

### Shadow builder

```dart id="s1d2cc"
.shadow(
  .color(...)
  .blurRadius(...)
  .offset(...)
)
```

---

### Border builder

```dart id="b7n9dd"
.border(
  .color(...)
  .width(...)
)
```

---

### Gradient builder

```dart id="g4t8ee"
.linearGradient(
  .colors([...])
  .begin(...)
  .end(...)
)
```

---

### Transform builder (if used)

```dart id="t9x2ff"
.transform(
  .translate(x: 0, y: 0)
  .scale(1.0)
)
```

---

## 🚫 Forbidden Inside Chains

Even inside chain builders, NEVER use:

* named parameter blocks
* nested objects
* Flutter constructors

### ❌ WRONG

```dart id="q2w8gg"
.shadow(
  .offset(Offset(0, 0))
)
```

### ❌ WRONG

```dart id="r7e9hh"
.shadow(
  offset: Offset.zero
)
```

---

### ✅ CORRECT

```dart id="u3k1ii"
.shadow(
  .offset(x: 0, y: 0)
)
```

---

## ⚠️ Token Usage Rule

Tokens are ALWAYS resolved inline:

### ✅ Correct

```dart id="t0z2jj"
.color($GlassColors.shadow())
.blurRadius($BlurRadius.medium())
```

### ❌ Wrong

```dart id="t9x1kk"
.blurRadius($BlurRadius.medium) // missing call
```

---

## 🧠 LLM GENERATION RULES (STRICT)

When generating Mix style code:

### MUST:

* use chained modifier DSL inside complex styles
* pass exactly ONE argument expression
* resolve tokens inline
* avoid all named parameters in style APIs

### MUST NOT:

* use `param: value` syntax inside styles
* pass Flutter-style objects
* break chain into multiple arguments
* mix Flutter API patterns with Mix DSL

---

## 🧠 Golden Rule

> If a style has structure, it must be a **single chained expression**, not a parameter list.


---

## 🚫 Absolute Prohibition: Raw Tokens in Nested Structures

Never pass unresolved tokens inside:

* lists (`[]`)
* maps (`{}`)
* non-chain arguments
* Flutter-compatible objects
* Mix DSL builder arguments that expect primitives

---

### ❌ FORBIDDEN: Unresolved tokens in collections

```dart id="a1k9pq"
.colors([
  $Colors.primary(),
  $Colors.surface(),
])
```

```dart id="b2m8xz"
.colors([
  $Colors.primary.token,
  $Colors.surface.token,
])
```

---

## ✅ REQUIRED RULE: Explicit `.resolve(context)` in Nested Contexts

When a token is used inside a **nested structure**, it MUST be resolved explicitly.

---

### ✅ CORRECT: Gradient colors

```dart id="c9v2ld"
.linearGradient(
  .colors([
    $Colors.primary.resolve(context),
    $Colors.surface.resolve(context),
  ])
  .begin(.topLeft)
  .end(.bottomRight)
)
```

---

## 🧠 Core Principle

> Tokens are lazy by default — but **nested DSL boundaries require eager resolution**

---

## 📦 When Resolution IS Required

You MUST use `.resolve(context)` when the token is used in:

### 1. Lists

```dart
[
  token.resolve(context),
  token.resolve(context),
]
```

---

### 2. Maps

```dart
{
  key: token.resolve(context),
}
```

---

### 3. Gradient / multi-value APIs

```dart
.colors([
  token.resolve(context),
])
```

---

## ❌ When Resolution is NOT Needed

Do NOT call `.resolve(context)` when:

### 1. Inside Mix DSL single-value chains

```dart id="x1p9aa"
.color($Colors.primary())
```

---

### 2. Styler methods that accept tokens directly

```dart id="x2p9bb"
BoxStyler().color($Colors.primary())
```

---

## 🧠 Token Resolution Hierarchy

| Context                          | Use                       |
| -------------------------------- | ------------------------- |
| Mix DSL chain                    | `$token()`                |
| Styler property                  | `$token()`                |
| Flutter/native constructor       | `$token.resolve(context)` |
| Lists / maps / nested structures | `$token.resolve(context)` |

---

## ⚠️ LLM GENERATION RULES (STRICT)

When generating Mix code:

### MUST:

* use `.resolve(context)` inside collections and nested structures
* keep DSL chains unresolved
* distinguish between DSL boundary vs Flutter boundary

### MUST NOT:

* pass `$token()` inside lists
* omit `.resolve(context)` in non-DSL contexts
* guess resolution behavior

---

## 🧠 Golden Rule

> Tokens inside Mix DSL are lazy.
> Tokens inside everything else must be resolved.
