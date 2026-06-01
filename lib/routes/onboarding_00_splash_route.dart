import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mix/mix.dart';

import '../generated/assets.gen.dart';
import '../generated/i18n.g.dart';
import '../routes.dart';
import '../styles/glass.dart';

part 'onboarding_00_splash_route.g.dart';

/// The welcome screen of the onboarding flow.
@TypedGoRoute<Onboarding00SplashRoute>(path: '/onboarding/00_splash')
class Onboarding00SplashRoute extends GoRouteData
    with $Onboarding00SplashRoute {
  /// The welcome screen of the onboarding flow.
  const Onboarding00SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      state.extra as Onboarding00SplashScreen? ??
      const Onboarding00SplashScreen();

  @override
  CustomTransitionPage<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) => CustomTransitionPage<void>(
    key: state.pageKey,
    child: build(context, state),
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) => FadeTransition(opacity: animation, child: child),
  );
}

/// The welcome screen of the onboarding flow.
class Onboarding00SplashScreen extends HookConsumerWidget {
  /// The welcome screen of the onboarding flow.
  const Onboarding00SplashScreen({
    this.showFirst = const Duration(seconds: 2),
    this.curve = Curves.easeInOut,
    this.transitionDuration = const Duration(seconds: 1),
    this.showSecond = const Duration(seconds: 1),
    super.key,
  });

  /// How much to show the first part.
  final Duration showFirst;

  /// How much time to animate the transition.
  final Curve curve;

  /// How much time to animate the transition.
  final Duration transitionDuration;

  /// How much to show the second part.
  final Duration showSecond;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final I18NOnboardingA00SplashEnUs i18n = I18N
        .of(context)
        .onboarding
        .a00Splash;
    final $SourceAssetsOnboarding00SplashGen assets =
        Assets.source.assets.onboarding.a00Splash;

    unawaited(
      useMemoized(() async {
        final ProviderContainer container = ProviderScope.containerOf(context);
        final Routes<Object?> route = await Routes.current(container);
        await Future<void>.delayed(const Duration(seconds: 3));
        if (context.mounted) {
          await route.pushReplacement(GoRouter.of(context));
        }
      }),
    );

    // final rive.FileLoader fileLoader = useMemoized(assets.book.riveFileLoader);
    // useEffect(() => fileLoader.dispose);
    // final ObjectRef<rive.RiveWidgetController?> controller =
    //     useRef<rive.RiveWidgetController?>(null);
    // useEffect(() {
    //   final Timer timer = Timer.periodic(const Duration(seconds: 2), (_) {
    //     final rive.RiveWidgetController? controllerV = controller.value;
    //     if (controllerV != null) {
    //       final rive.ViewModel? vm = controllerV.file.viewModelByName(
    //         'My View Model',
    //       );
    //       final rive.ViewModelInstance viewModelInstance = controllerV
    //           .dataBind(rive.DataBind.auto());
    //       viewModelInstance.trigger('R')?.trigger();
    //       print('ok');
    //     }
    //   });
    //   return timer.cancel;
    // });

    return futuristicBackground(
      context,
    ).alignment(.center).padding(.horizontal(20).vertical(64))(
      child:
          StackBoxStyler().keyframeAnimation(
            timeline: <KeyframeTrack<double>>[
              KeyframeTrack<double>('opacity', <Keyframe<double>>[
                .easeIn(1, 500.ms),
                .linear(1, 2000.ms),
                .easeOut(0, 500.ms),
                // extra waiting time for route navigation
                .linear(0, 1000.ms),
              ], initial: 0),
            ],
            styleBuilder:
                (KeyframeAnimationResult values, StackBoxStyler style) =>
                    style.wrap(.opacity(values.get('opacity') as double)),
          )(
            children: <Widget>[
              assets.loader.lottie(animate: true, repeat: true),
              // rive.RiveWidgetBuilder(
              //   fileLoader: fileLoader,
              //   controller: (rive.File file) =>
              //       controller.value = rive.RiveWidgetController(file),
              //   builder: (BuildContext context, rive.RiveState state) =>
              //       switch (state) {
              //         rive.RiveLoading() => const SizedBox.shrink(),
              //         rive.RiveFailed() => ErrorWidget.withDetails(
              //           message: state.error.toString(),
              //           error: FlutterError(state.error.toString()),
              //         ),
              //         rive.RiveLoaded() => rive.RiveWidget(
              //           controller: state.controller,
              //         ),
              //       },
              // ),
            ],
          ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(DiagnosticsProperty<Duration>('showFirst', showFirst))
          ..add(DiagnosticsProperty<Curve>('curve', curve))
          ..add(
            DiagnosticsProperty<Duration>(
              'transitionDuration',
              transitionDuration,
            ),
          )
          ..add(DiagnosticsProperty<Duration>('showSecond', showSecond)),
      );
}
