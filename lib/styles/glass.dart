import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../styles.dart';

/// A slowly shifting multi-stop linear gradient background best used for
/// app-level canvases.
///
/// Animates between the background and surface colors on a 1-second ease curve.
///
/// Example:
/// ```dart
/// Box(style: futuristicBackground(context))
/// ```
BoxStyler futuristicBackground(BuildContext context) => BoxStyler()
    .gradient(
      .linear(
        .begin(.topLeft).end(.bottomRight).colors(<Color>[
          $Colors.background.resolve(context),
          $Colors.surface.resolve(context),
          $Colors.background.resolve(context),
        ]),
      ),
    )
    .animate(.ease(const Duration(seconds: 1)));

/// A frosted-glass card surface with rounded corners, subtle border and
/// a layered inner gradient that adds depth.
///
/// Uses `$GlassColors.primary` as the base color, `$GlassColors.border` for
/// the outline, and `$Radius.large()` for rounded corners. The inner radial
/// gradient darkens edges slightly for a natural lensing effect.
///
/// Requires a `BuildContext` so that token values can be resolved from the
/// nearest [MixScope].
///
/// Example:
/// ```dart
/// Box(style: glassStyle(context), child: content)
/// ```
BoxStyler glassStyle(BuildContext context) => BoxStyler()
    .color($GlassColors.primary())
    .border(.all(.color($GlassColors.border()).width(1.2)))
    .borderRadius(.all($Radius.large()))
    .wrap(.clipRRect(borderRadius: .all($Radius.large())))
    .padding(.all($Spaces.lg()))
    .shadow(
      .color(
        $GlassColors.shadow(),
      ).blurRadius($BlurRadius.medium()).offset(x: 0, y: 20),
    )
    .clipBehavior(Clip.antiAlias)
    .foregroundDecoration(
      .gradient(
        .linear(
          .begin(.topLeft).end(.bottomRight).colors(<Color>[
            $GlassColors.primary.resolve(context),
            $Colors.surface.resolve(context).withValues(alpha: 0.02),
          ]),
        ),
      ),
    )
    .wrap(
      .box(
        BoxStyler().foregroundDecoration(
          .gradient(
            .radial(
              .center(.center).radius(1.2).colors(<Color>[
                Colors.transparent,
                const Color(0x12000000), // soft edge darkening
              ]),
            ),
          ),
        ),
      ),
    );

/// A neon-accented glass style combining `$GlassColors.neonBlue` and
/// `$GlassColors.neonPurple` gradients with a glow shadow.
///
/// Best suited for highlighted panels, call-to-action cards, or futuristic
/// UI surfaces that need a vibrant colour wash.
///
/// Requires a `BuildContext` so that token values can be resolved from the
/// nearest [MixScope].
///
/// Example:
/// ```dart
/// Box(style: neonGlassStyle(context))
/// ```
BoxStyler neonGlassStyle(BuildContext context) => BoxStyler()
    .gradient(
      .linear(
        .begin(.topLeft).end(.bottomRight).colors(<Color>[
          $GlassColors.neonBlue.resolve(context).withValues(alpha: 0.18),
          $GlassColors.neonPurple.resolve(context).withValues(alpha: 0.10),
        ]),
      ),
    )
    .borderRadius(.all($Radius.large()))
    .border(.all(.color($GlassColors.border()).width(1)))
    .padding(.all($Spaces.lg()))
    .shadow(
      .color(
        $GlassColors.neonBlue(),
      ).blurRadius($BlurRadius.large()).offset(x: 0, y: 0),
    )
    .clipBehavior(Clip.antiAlias);

/// An elevated floating panel with deep elevation shadow and a soft top-left
/// highlight gradient.
///
/// Uses `$Radius.xlarge()` corners and `$Colors.surface` with 72 % opacity for
/// a true levitating look. Ideal for bottom sheets, modals, or overlays that
/// need to feel detached from the background.
///
/// Requires a `BuildContext` so that token values can be resolved from the
/// nearest [MixScope].
///
/// Example:
/// ```dart
/// Box(style: floatingPanelStyle(context))
/// ```
BoxStyler floatingPanelStyle(BuildContext context) => BoxStyler()
    .color($Colors.surface().withValues(alpha: 0.72))
    .borderRadius(.all($Radius.xlarge()))
    .padding(.all($Spaces.xl()))
    .border(.all(.color($Colors.border()).width(1)))
    .shadow(
      .color(
        $GlassColors.shadow(),
      ).blurRadius($BlurRadius.xlarge()).offset(x: 0, y: 40),
    )
    .foregroundDecoration(
      .gradient(
        .linear(
          .begin(.topLeft).end(.bottomRight).colors(<Color>[
            $GlassColors.primary.resolve(context),
            Colors.transparent,
          ]),
        ),
      ),
    );

/// Base glass button style without interaction states.
///
/// Uses `$GlassColors.primary` as the button fill, rounded via `$Radius.medium()`,
/// with `$Spaces.lg()` horizontal and `$Spaces.md()` vertical padding.
///
/// Hovered state scales up (1.03×) and adds a neon-blue inner glow shadow.
/// Pressed state scales down (0.97×). All transitions use a 180 ms ease-out curve.
///
/// Intended for use with [Pressable] or [PressableBox].
///
/// Requires a `BuildContext` so that token values can be resolved from the
/// nearest [MixScope].
///
/// Example:
/// ```dart
/// PressableBox(
///   style: glassButtonInteractive(context),
///   onPress: () {},
///   child: StyledText('Action', style: textStyle),
/// )
/// ```
BoxStyler glassButtonStyle(BuildContext context) => BoxStyler()
    .color($GlassColors.primary())
    .borderRadius(.all($Radius.medium()))
    .padding(.symmetric(horizontal: $Spaces.lg(), vertical: $Spaces.md()))
    .border(.all(.color($GlassColors.border()).width(1)))
    .shadow(
      .color(
        $GlassColors.shadow(),
      ).blurRadius($BlurRadius.xsmall()).offset(x: 0, y: 10),
    )
    .onHovered(
      BoxStyler()
          .color($GlassColors.secondary())
          .scale(1.03)
          .shadow(
            .color(
              $GlassColors.neonBlue(),
            ).blurRadius($BlurRadius.small()).offset(x: 0, y: 0),
          ),
    )
    .onPressed(BoxStyler().color($GlassColors.primary()).scale(0.97))
    .animate(.easeOut(const Duration(milliseconds: 180)));

BoxStyler glassIconButtonStyle(BuildContext context) => BoxStyler()
    .color($GlassColors.primary())
    .borderRadius(.all($Radius.medium()))
    .padding(.all($Spaces.sm()))
    .border(.all(.color($GlassColors.border()).width(1)))
    .shadow(
      .color(
        $GlassColors.shadow(),
      ).blurRadius($BlurRadius.medium()).offset(x: 0, y: 0),
    )
    .onHovered(
      BoxStyler()
          .scale(1.06)
          .shadow(
            .color(
              $GlassColors.neonBlue(),
            ).blurRadius($BlurRadius.small()).offset(x: 0, y: 0),
          )
          .color($GlassColors.secondary()),
    )
    .onPressed(
      BoxStyler()
          .scale(0.92)
          .shadow(
            .color(
              $GlassColors.shadow(),
            ).blurRadius($BlurRadius.xxsmall()).offset(x: 0, y: 0),
          ),
    )
    .animate(.easeInOut(180.ms));
