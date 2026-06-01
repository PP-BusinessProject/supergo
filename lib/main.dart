import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_compatibility_layer/dio_compatibility_layer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:rhttp/rhttp.dart';
import 'package:rive/rive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_supabase/sentry_supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'api/api.dart';
import 'generated/env.g.dart';
import 'generated/i18n.g.dart';
import 'providers/api/api.dart';
import 'providers/preferences.dart';
import 'routes.dart';

Future<void> main() {
  late final Client compatibleClient;
  return SentryFlutter.init(
    (SentryFlutterOptions options) async {
      if (!kIsWeb) {
        await Rhttp.init();
        compatibleClient = await RhttpCompatibleClient.create();
      } else {
        compatibleClient = Client();
      }
      options
        ..httpClient = compatibleClient
        ..dsn = Config.sentryDsn
        /// Logging
        ..debug = kDebugMode
        ..enableLogs = kDebugMode
        ..beforeSendLog = ((SentryLog log) => log)
        /// Performance
        ..tracesSampleRate = 0
        ..profilesSampleRate = 0
        ..enableAutoPerformanceTracing = false
        ..enableFramesTracking = false
        ..enableTimeToFullDisplayTracing = false
        /// Tracking
        ..enableUserInteractionBreadcrumbs = false
        ..enableUserInteractionTracing = false
        ..enableAutoSessionTracking = false
        /// Native
        ..enableNativeTraceSync = false
        ..enableNdkScopeSync = false
        ..enableAutoNativeBreadcrumbs = false
        /// Crash
        ..anrEnabled = false
        ..enableAppHangTracking = false
        /// Storage
        ..maxCacheItems = 5
        /// Misc
        ..reportPackages = false
        /// Screenshots
        ..attachScreenshot = false
        ..attachViewHierarchy = false
        ..beforeCaptureScreenshot =
            ((SentryEvent event, Hint hint, bool shouldDebounce) =>
                !shouldDebounce && event.level == SentryLevel.fatal);
    },
    appRunner: () async {
      final WidgetsBinding widgetsBinding =
          SentryWidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      final Talker talker = Talker();
      final Dio dio = Dio()
        ..interceptors.add(
          TalkerDioLogger(
            talker: talker,
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
            ),
          ),
        )
        ..httpClientAdapter = ConversionLayerAdapter(compatibleClient)
        ..addSentry();

      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          dioProvider.overrideWithValue(dio),
          apiProvider.overrideWithValue(API(dio, baseUrl: Config.apiUrl)),
          preferencesProvider.overrideWithValue(SharedPreferencesAsync()),
        ],
        observers: <ProviderObserver>[
          TalkerRiverpodObserver(
            talker: talker,
            settings: const TalkerRiverpodLoggerSettings(
              printProviderDisposed: true,
            ),
          ),
        ],
      );

      await Future.wait(<Future<Object?>>[
        container.read(themeProvider.future),
        container.read(localeProvider.future),
      ]);
      runApp(
        UncontrolledProviderScope(
          container: container,
          child: TranslationProvider(child: const RoutesApp()),
        ),
      );

      widgetsBinding.addPostFrameCallback((_) => FlutterNativeSplash.remove());

      Sentry.configureScope((Scope scope) => scope..level = SentryLevel.info);
      await Future.wait(<Future<Object?>>[
        RiveNative.init(),
        Supabase.initialize(
          url: Config.supabaseUrl,
          anonKey: Config.supabaseAnonKey,
          httpClient: SentrySupabaseClient(client: compatibleClient),
        ),
        // GoogleSignIn.instance.initialize(
        //   clientId: Config.googleClientId,
        //   serverClientId: Config.googleServerClientId,
        // );
        if (!kIsWeb) ...<Future<Object?>>[
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
          SystemChrome.setPreferredOrientations(<DeviceOrientation>[
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]),
        ],
      ]);
    },
  );
}
