import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../styles.dart';

/// A book card that displays cover image, author, title, and publication year.
///
/// Uses glass styling with a layered gradient background for depth. The card
/// features rounded corners matching `$Radius.xlarge()`, a subtle border via
/// `$GlassColors.border`, and a soft elevation shadow.
///
/// Layout:
///   - Top: cover image (aspect ratio 2:3 portrait)
///   - Below image: author name in smaller text
///   - Title (larger, prominent)
///   - Year (small, subdued)
///
/// Requires a [BuildContext] to resolve token values from the nearest [MixScope].
///
/// Example:
/// ```dart
/// Box(
///   style: readerBookCardStyle(context),
///   child: Row(children: [cover, details]),
/// )
/// ```
BoxStyler readerBookCardStyle(BuildContext context) => BoxStyler()
    .color($GlassColors.primary())
    .borderRadius(.all($Radius.xlarge()))
    .padding(.symmetric(horizontal: $Spaces.lg(), vertical: $Spaces.md()))
    .border(.all(.color($GlassColors.border()).width(1.2)))
    .shadow(
      .color(
        $GlassColors.shadow(),
      ).blurRadius($BlurRadius.medium()).offset(x: 0, y: 8),
    )
    .foregroundDecoration(
      .gradient(
        .linear(
          .begin(.topLeft).end(.bottomRight).colors(<Color>[
            $GlassColors.primary.resolve(context),
            $Colors.surface.resolve(context).withValues(alpha: 0.03),
          ]),
        ),
      ),
    )
    .wrap(.clipRRect(borderRadius: .all($Radius.xlarge())));

/// A glass-styled button for triggering read mode.
///
/// Uses `$GlassColors.primary` as the fill with rounded corners via
/// `$Radius.medium()`. Horizontal padding of `$Spaces.lg()` and vertical
/// padding of `$Spaces.md()` ensure comfortable touch targets (minimum 48 dp).
/// The border uses `$GlassColors.border` at 1.2 width for a refined outline.
/// An elevation shadow provides subtle lift.
///
/// Intended to be used with [Pressable] or [PressableBox] for interaction
/// states and accessibility.
///
/// Requires a [BuildContext] to resolve token values from the nearest [MixScope].
///
/// Example:
/// ```dart
/// PressableBox(
///   style: glassReadButtonStyle(context),
///   onPress: () => showReadMode(),
///   child: StyledText('Read', style: textStyle),
/// )
/// ```
BoxStyler glassReadButtonStyle(BuildContext context) => BoxStyler()
    .color($GlassColors.primary())
    .borderRadius(.all($Radius.medium()))
    .padding(.symmetric(horizontal: $Spaces.lg(), vertical: $Spaces.md()))
    .border(.all(.color($GlassColors.border()).width(1.2)))
    .shadow(
      .color(
        $GlassColors.shadow(),
      ).blurRadius($BlurRadius.small()).offset(x: 0, y: 6),
    );

/// An inverse-styled button for listening (audiobook) mode.
///
/// This is the visual inverse of [glassReadButtonStyle]: it uses `$GlassColors.surface`
/// as the background (light on dark themes, dark on light themes), with inverted
/// text color and a complementary neon accent glow shadow via
/// `$GlassColors.neonPurple`. The border uses `$GlassColors.border` for outline.
///
/// When hovered or pressed, the button adopts a soft gradient that blends surface
/// toward background, creating an "active" listening state.
///
/// Intended to be used with [Pressable] or [PressableBox].
///
/// Requires a [BuildContext] to resolve token values from the nearest [MixScope].
///
/// Example:
/// ```dart
/// PressableBox(
///   style: glassListenButtonStyle(context),
///   onPress: () => toggleListening(),
///   child: StyledText('Listen', style: textStyle),
/// )
/// ```
BoxStyler glassListenButtonStyle(BuildContext context) => BoxStyler()
    .color($Colors.surface())
    .borderRadius(.all($Radius.medium()))
    .padding(.symmetric(horizontal: $Spaces.lg(), vertical: $Spaces.md()))
    .border(.all(.color($GlassColors.border()).width(1.2)))
    .shadow(
      .color(
        $GlassColors.neonPurple(),
      ).blurRadius($BlurRadius.small()).offset(x: 0, y: 4),
    );

/// Extends [glassListenButtonStyle] with hover and press variants for
/// interaction feedback.
///
/// Hovered state adds a soft surface→background gradient overlay that creates a
/// "glowing" effect suitable for listening mode activation. Pressed state scales
/// down slightly (0.98×) for tactile response. All transitions use a 160 ms
/// ease-out curve.
///
/// Intended to be used with [Pressable] or [PressableBox].
///
/// Example:
/// ```dart
/// PressableBox(
///   style: glassListenButtonInteractive(context),
///   onPress: () => toggleListening(),
///   child: textStyle('Listen'),
/// )
/// ```
BoxStyler glassListenButtonInteractive(BuildContext context) =>
    glassListenButtonStyle(context)
        .onHovered(
          BoxStyler().foregroundDecoration(
            .gradient(
              .linear(
                .begin(.topLeft).end(.bottomRight).colors(<Color>[
                  $Colors.surface.resolve(context),
                  $Colors.background.resolve(context).withValues(alpha: 0.12),
                ]),
              ),
            ),
          ),
        )
        .onPressed(
          BoxStyler()
              .scale(0.98)
              .foregroundDecoration(
                .gradient(
                  .linear(
                    .begin(.topLeft).end(.bottomRight).colors(<Color>[
                      $Colors.surface.resolve(context),
                      $Colors.background
                          .resolve(context)
                          .withValues(alpha: 0.18),
                    ]),
                  ),
                ),
              ),
        )
        .animate(.easeOut(const Duration(milliseconds: 160)));
