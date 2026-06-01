---

## title: Animations Reference

Mix provides three animation approaches, ordered from simplest to most powerful:

1. **Implicit animations** — automatic transitions between style changes
2. **Phase animations** — multi-step sequences triggered by events
3. **Keyframe animations** — full timeline-based control

---

## Implicit Animations

Implicit animations automatically interpolate between style states whenever a change occurs.

They are defined by attaching `.animate()` to a style.

### Basic implicit animation

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .animate(.easeInOut(300.ms))
    .onHovered(.color(Colors.red).size(120, 120));
```

When hover state changes, Mix automatically interpolates between the two styles.

---

### Animation configurations

The `.animate()` method accepts an `AnimationConfig`:

| Config                  | Behavior             |
| ----------------------- | -------------------- |
| `.easeInOut(duration)`  | Smooth start and end |
| `.ease(duration)`       | Standard easing      |
| `.linear(duration)`     | Constant speed       |
| `.spring(duration)`     | Physics-based motion |
| `.decelerate(duration)` | Fast start, slow end |
| `.bounceIn(duration)`   | Bouncy entrance      |
| `.bounceOut(duration)`  | Bouncy exit          |
| `.elasticIn(duration)`  | Elastic entrance     |
| `.elasticOut(duration)` | Elastic exit         |

Durations use the `.ms` extension:

```dart
300.ms
600.ms
```

---

### State-driven implicit animation

Implicit animations also respond to state changes:

```dart
class Counter extends HookConsumerWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = useState(0);
    final style = BoxStyler()
        .color(Colors.blue)
        .size(100 + count * 20, 100 + count * 20)
        .borderRounded(10 + count * 5)
        .animate(.spring(600.ms));

    return GestureDetector(
      onTap: () => count.value++,
      child: style(),
    );
  }
}
```

---

### Variant-driven implicit animation

```dart
final style = BoxStyler()
    .color(Colors.blue)
    .size(100, 100)
    .animate(.easeInOut(200.ms))
    .onHovered(
      BoxStyler()
          .color(Colors.deepPurple)
          .size(120, 120)
          .borderRounded(20),
    );
```

---

## Phase Animations

Phase animations run a sequence of steps, each with its own timing and curve.

### Basic phase animation

```dart
class CompressExample extends HookConsumerWidget {
  const CompressExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(PhaseAnimationController.new);
    useEffect(() => controller.dispose);
    final base = BoxStyler()
        .color(Colors.blue)
        .size(100, 100)
        .borderRounded(12);

    return GestureDetector(
      onTap: () => controller.forward(),
      child: PhaseAnimationBuilder(
        controller: controller,
        phases: [
          PhaseConfig(
            base.size(80, 80).borderRounded(20),
            duration: 150.ms,
            curve: Curves.easeIn,
          ),
          PhaseConfig(
            base.size(120, 120),
            duration: 300.ms,
            curve: Curves.bounceOut,
          ),
          PhaseConfig(
            base,
            duration: 200.ms,
            curve: Curves.easeOut,
          ),
        ],
        builder: (context, style) => style(),
      ),
    );
  }
}
```

---

### PhaseConfig

| Property   | Type     | Description                |
| ---------- | -------- | -------------------------- |
| `style`    | Styler   | Target style for the phase |
| `duration` | Duration | Duration of the phase      |
| `curve`    | Curve    | Interpolation curve        |

---

### Controller

| Method      | Description         |
| ----------- | ------------------- |
| `forward()` | Starts the sequence |
| `dispose()` | Releases resources  |

---

## Keyframe Animations

Keyframe animations define a timeline with multiple tracks controlling independent properties.

---

### Basic keyframe animation

```dart
class HeartAnimation extends HookConsumerWidget {
  const HeartAnimation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final base = IconStyler()
        .icon(Icons.favorite)
        .size(40)
        .color(Colors.red);

    return KeyframeAnimationBuilder(
      duration: 1200.ms,
      repeat: true,
      keyframes: {
        KeyframeTrack<double>(
          property: KeyframeProperty.iconSize,
          keyframes: [
            Keyframe(0.0, 40),
            Keyframe(0.3, 56),
            Keyframe(0.5, 40),
            Keyframe(0.7, 52),
            Keyframe(1.0, 40),
          ],
        ),
        KeyframeTrack<Color>(
          property: KeyframeProperty.iconColor,
          keyframes: [
            Keyframe(0.0, Colors.red),
            Keyframe(0.3, Colors.red.shade900),
            Keyframe(0.5, Colors.red),
            Keyframe(0.7, Colors.red.shade800),
            Keyframe(1.0, Colors.red),
          ],
        ),
      },
      builder: (context, style) {
        return StyledIcon(style: base.merge(style));
      },
    );
  }
}
```

---

### Toggle-based keyframes

```dart
KeyframeAnimationBuilder(
  duration: 400.ms,
  playing: isOn,
  keyframes: {
    KeyframeTrack<double>(
      property: KeyframeProperty.width,
      keyframes: [
        Keyframe(0.0, 24),
        Keyframe(0.5, 40),
        Keyframe(1.0, 24),
      ],
    ),
    KeyframeTrack<double>(
      property: KeyframeProperty.translateX,
      keyframes: [
        Keyframe(0.0, 0),
        Keyframe(1.0, 20),
      ],
    ),
  },
  builder: (context, style) => Box(style: base.merge(style)),
);
```

---

### Looping animations

```dart
KeyframeAnimationBuilder(
  duration: 2000.ms,
  repeat: true,
  keyframes: { /* tracks */ },
  builder: (context, style) => widget,
);
```

---

## Simplest form (implicit hover/press)

For UI-only interactions, no controller is needed:

```dart
final style = BoxStyler()
    .size(100, 100)
    .color(Colors.blue)
    .borderRounded(8)
    .animate(.spring(300.ms))
    .onHovered(
      BoxStyler()
          .size(110, 110)
          .color(Colors.blue.shade700),
    );
```

