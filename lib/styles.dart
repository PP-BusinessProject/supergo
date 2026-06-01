// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:portal_labs/portal_labs.dart';

enum Themes {
  light(LightTheme()),
  dark(DarkTheme());

  const Themes(this.instance);

  /// Concrete theme implementation.
  final AppTheme instance;
}

enum Fonts {
  gotham('Gotham Pro'),
  sf('.SF Pro Text');

  const Fonts(this.font);

  /// Registered font family name.
  final String font;
}

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

  /// Underlying [MixToken].
  final ColorToken token;

  /// Returns a [ColorRef] for Mix styles.
  ColorRef call() => token();

  /// Resolves the concrete [Color] from context.
  Color resolve(BuildContext context) => token.resolve(context);
}

enum $GlassColors {
  primary(ColorToken('glass.primary')),
  secondary(ColorToken('glass.secondary')),
  border(ColorToken('glass.border')),
  shadow(ColorToken('glass.shadow')),

  neonBlue(ColorToken('glass.neonBlue')),
  neonPurple(ColorToken('glass.neonPurple'));

  const $GlassColors(this.token);

  /// Underlying [MixToken].
  final ColorToken token;

  /// Returns a [ColorRef] for Mix styles.
  ColorRef call() => token();

  /// Resolves the concrete [Color] from context.
  Color resolve(BuildContext context) => token.resolve(context);
}

enum $ComponentColors {
  cardGlass(ColorToken('component.cardGlass')),
  buttonGlass(ColorToken('component.buttonGlass')),
  navBar(ColorToken('component.navBar'));

  const $ComponentColors(this.token);

  /// Underlying [MixToken].
  final ColorToken token;

  /// Returns a [ColorRef] for Mix styles.
  ColorRef call() => token();

  /// Resolves the concrete [Color] from context.
  Color resolve(BuildContext context) => token.resolve(context);
}

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

  /// Underlying [MixToken].
  final TextStyleToken token;

  /// Returns a [TextStyleMixRef] for Mix styles.
  TextStyleMixRef call() => token.mix();

  /// Resolves the concrete [TextStyle].
  TextStyle resolve(BuildContext context) => token.resolve(context);
}

enum $Radius {
  small(RadiusToken('radius.small')),
  medium(RadiusToken('radius.medium')),
  large(RadiusToken('radius.large')),
  xlarge(RadiusToken('radius.xlarge'));

  const $Radius(this.token);

  /// Underlying [MixToken].
  final RadiusToken token;

  /// Returns a [RadiusRef] for Mix styles.
  RadiusRef call() => token();

  /// Resolves the concrete [Radius].
  Radius resolve(BuildContext context) => token.resolve(context);
}

enum $BlurRadius {
  xxsmall(DoubleToken('blurRadius.xxsmall')),
  xsmall(DoubleToken('blurRadius.xsmall')),
  small(DoubleToken('blurRadius.small')),
  medium(DoubleToken('blurRadius.medium')),
  large(DoubleToken('blurRadius.large')),
  xlarge(DoubleToken('blurRadius.xlarge'));

  const $BlurRadius(this.token);

  /// Underlying [MixToken].
  final DoubleToken token;

  /// Returns the token reference value.
  double call() => token();

  /// Resolves the concrete value.
  double resolve(BuildContext context) => token.resolve(context);
}

enum $Spaces {
  xxs(SpaceToken('space.xxs')),
  xs(SpaceToken('space.xs')),
  sm(SpaceToken('space.sm')),
  md(SpaceToken('space.md')),
  lg(SpaceToken('space.lg')),
  xl(SpaceToken('space.xl')),
  xxl(SpaceToken('space.xxl'));

  const $Spaces(this.token);

  /// Underlying [MixToken].
  final SpaceToken token;

  /// Returns the token reference value.
  double call() => token();

  /// Resolves the concrete spacing value.
  double resolve(BuildContext context) => token.resolve(context);
}

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

  /// Generated semantic color system for [PortalTheme].
  PortalColors get portalColors;

  /// Generated typography system for [PortalTheme].
  PortalTypography get portalTypography;
}

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
        .xxsmall => 10,
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

    for (final $GlassColors color in $GlassColors.values)
      color.token: switch (color) {
        .primary => const Color(0xB3FFFFFF),
        .secondary => const Color(0x80FFFFFF),
        .border => const Color(0x1A000000),
        .shadow => const Color(0x14000000),
        .neonBlue => const Color(0xFF4A90E2),
        .neonPurple => const Color(0xFF8B5CF6),
      },
    for (final $ComponentColors color in $ComponentColors.values)
      color.token: switch (color) {
        .cardGlass => const Color(0xE8FFFFFF),
        .buttonGlass => const Color(0xE6FFFFFF),
        .navBar => const Color(0x00f7f8fa),
      },
  };
}

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

    for (final $GlassColors color in $GlassColors.values)
      color.token: switch (color) {
        .primary => const Color(0x14FFFFFF),
        .secondary => const Color(0x0AFFFFFF),
        .border => const Color(0x26FFFFFF),
        .shadow => const Color(0x66000000),
        .neonBlue => const Color(0xFF60A5FA),
        .neonPurple => const Color(0xFFA78BFA),
      },

    for (final $ComponentColors color in $ComponentColors.values)
      color.token: switch (color) {
        .cardGlass => const Color(0x14101827),
        .buttonGlass => const Color(0x1EFFFFFF),
        .navBar => const Color(0xCC0F172A),
      },
  };
}
