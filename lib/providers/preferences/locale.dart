part of '../preferences.dart';

/// The currently selected app language.
///
/// Stored in Drift:
/// - `null` → follow system locale
/// - `'en'`, `'uk'`, `'ru'` → explicit language override
@Riverpod(keepAlive: true, dependencies: <Object>[preferences])
class LocaleNotifier extends _$LocaleNotifier with WidgetsBindingObserver {
  late final SharedPreferencesAsync _preferences;
  I18NLocale? _cachedLocale;

  @override
  Future<Locale> build() async {
    _preferences = ref.read(preferencesProvider);

    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    _cachedLocale = await _preferences.readLocale();
    return (_cachedLocale ?? _getSystemLocale()).flutterLocale;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (_cachedLocale == null) {
      state = AsyncValue<Locale>.data(_getSystemLocale().flutterLocale);
    }
  }

  /// Set language.
  ///
  /// If [locale] is null → system locale is used.
  Future<void> set(I18NLocale? locale) async {
    await _preferences.updateLocale(locale);
    _cachedLocale = locale;
    state = AsyncValue<Locale>.data(
      (locale ?? _getSystemLocale()).flutterLocale,
    );
  }

  I18NLocale _getSystemLocale() => AppLocaleUtils.instance.findDeviceLocale();
}

extension on SharedPreferencesAsync {
  static const String key = 'locale';

  Future<I18NLocale?> readLocale() async {
    final String? locale = await getString(key);
    return I18NLocale.values.firstWhereOrNull(
      (I18NLocale $locale) => $locale.name == locale,
    );
  }

  Future<void> updateLocale(I18NLocale? locale) =>
      locale == null ? remove(key) : setString(key, locale.name);
}
