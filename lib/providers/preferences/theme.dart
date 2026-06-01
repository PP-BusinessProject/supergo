part of '../preferences.dart';

/// The currently selected [AppTheme].
///
/// Stored in Drift:
/// - `null` → follow system theme
/// - `light` → light theme
/// - `dark` → dark theme
@Riverpod(keepAlive: true, dependencies: <Object>[preferences])
class ThemeNotifier extends _$ThemeNotifier with WidgetsBindingObserver {
  late final SharedPreferencesAsync _preferences;
  Themes? _cachedTheme;

  @override
  Future<Themes> build() async {
    _preferences = ref.read(preferencesProvider);
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    _cachedTheme = await _preferences.readTheme();
    return _cachedTheme ?? _getSystemTheme();
  }

  @override
  void didChangePlatformBrightness() {
    if (_cachedTheme == null) {
      state = AsyncValue<Themes>.data(_getSystemTheme());
    }
  }

  /// Set [AppTheme].
  Future<void> set(Themes? theme) async {
    await _preferences.updateTheme(theme);
    state = AsyncValue<Themes>.data(
      (_cachedTheme = theme) ?? _getSystemTheme(),
    );
  }

  /// Toggle between [Themes.light] and [Themes.dark].
  Future<void> toggle() async {
    final Themes next = state.requireValue == Themes.light
        ? Themes.dark
        : Themes.light;
    await _preferences.updateTheme(next);
    state = AsyncValue<Themes>.data(_cachedTheme = next);
  }

  Themes _getSystemTheme() {
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return switch (brightness) {
      Brightness.dark => Themes.dark,
      Brightness.light => Themes.light,
    };
  }
}

extension on SharedPreferencesAsync {
  static const String key = 'theme';

  Future<Themes?> readTheme() async {
    final String? theme = await getString(key);
    if (theme == null) {
      return null;
    }
    return Themes.values.firstWhereOrNull(
      (Themes $theme) => $theme.name == theme,
    );
  }

  Future<void> updateTheme(Themes? theme) =>
      theme == null ? remove(key) : setString(key, theme.name);
}
