import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mix/mix.dart';
import 'package:portal_labs/portal_labs.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'generated/i18n.g.dart';
import 'providers/preferences.dart';
import 'providers/supabase/authorization.dart';
import 'routes/onboarding_00_splash_route.dart';
import 'routes/onboarding_01_welcome_route.dart';
import 'styles.dart';

/// The route in the app.
enum Routes<Extra extends Object?> {
  /// The splash screen.
  onboarding00Splash<Onboarding00SplashScreen?>(Onboarding00SplashRoute()),

  /// The welcome screen.
  onboarding01Welcome<Onboarding01WelcomeScreen?>(Onboarding01WelcomeRoute());

  /// The route in the app.
  const Routes(this._route, {this.key});

  /// The name of this route.
  GoRouteData get route => _route!;
  final GoRouteData? _route;

  /// The key for this route.
  final Key? key;

  /// Return the current route depending on app's state.
  static Routes<Object?> get initial => onboarding00Splash;

  /// Return the current route depending on app's state.
  static Future<Routes<Object?>> current(ProviderContainer container) async {
    await container.read(authorizationProvider.future);
    return onboarding01Welcome;
  }

  /// The route location as specified in [route].
  String get location => route.location;

  /// The wrapper method on [GoRouter.go].
  void go(GoRouter router, {Extra? extra}) =>
      router.go(location, extra: extra);

  /// The wrapper method on [GoRouter.push].
  Future<T?> push<T extends Object?>(GoRouter router, {Extra? extra}) =>
      router.push<T>(location, extra: extra);

  /// The wrapper method on [GoRouter.pushReplacement].
  Future<T?> pushReplacement<T extends Object?>(
    GoRouter router, {
    Extra? extra,
  }) => router.pushReplacement<T>(location, extra: extra);

  /// The wrapper method on [GoRouter.replace].
  Future<T?> replace<T extends Object?>(GoRouter router, {Extra? extra}) =>
      router.replace<T>(location, extra: extra);
}

/// The wrapper around [MaterialApp] to support hot reload.
@immutable
class RoutesApp extends HookConsumerWidget {
  /// The wrapper around [MaterialApp] to support hot reload.
  const RoutesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final I18N i18n = I18N.of(context);
    final AppTheme appTheme = ref.watch(themeProvider).requireValue.instance;
    final Locale appLocale = ref.watch(localeProvider).requireValue;
    final GoRouter router = useMemoized(
      () => GoRouter(
        initialLocation: Routes.initial.location,
        observers: <NavigatorObserver>[
          SentryNavigatorObserver(setRouteNameAsTransaction: true),
        ],
        routes: <RouteBase>[
          $onboarding00SplashRoute,
          $onboarding01WelcomeRoute,
        ],
      ),
    );
    return MixScope(
      colors: appTheme.colors,
      spaces: appTheme.spaces,
      radii: appTheme.radii,
      textStyles: appTheme.textStyles,
      doubles: appTheme.blurRadii,
      child: PortalTheme(
        data: PortalThemeData(
          colors: appTheme.portalColors,
          typography: appTheme.portalTypography,
        ),
        child: MaterialApp.router(
          title: i18n.appName,
          debugShowCheckedModeBanner: false,
          locale: appLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: router,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            overscroll: false,
          ),
          builder: (BuildContext context, Widget? child) {
            final ThemeData theme = Theme.of(context);
            final MediaQueryData mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
              child: DefaultTextStyle(
                style: theme.textTheme.titleMedium ?? const TextStyle(),
                textAlign: TextAlign.center,
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Colors.transparent,
                    systemNavigationBarDividerColor: Colors.transparent,
                    statusBarBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(mediaQuery.size),
                    child: Material(child: child),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
