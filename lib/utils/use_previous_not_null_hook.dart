import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns the previous value passed to [usePrevious]
/// (from the previous widget `build`).
T? usePreviousNotNull<T extends Object?>(T val) =>
    use(_PreviousNotNullHook<T>(val));

class _PreviousNotNullHook<T extends Object?> extends Hook<T?> {
  const _PreviousNotNullHook(this.value);

  final T value;

  @override
  _PreviousHookState<T> createState() => _PreviousHookState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties..add(DiagnosticsProperty<T>('value', value)),
      );
}

class _PreviousHookState<T extends Object?>
    extends HookState<T?, _PreviousNotNullHook<T>> {
  T? previous;

  @override
  void didUpdateHook(_PreviousNotNullHook<T> old) =>
      previous = old.value ?? previous;

  @override
  T? build(BuildContext context) => previous;

  @override
  String get debugLabel => 'usePreviousNotNull';

  @override
  Object? get debugValue => previous;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties..add(DiagnosticsProperty<T?>('previous', previous)),
      );
}
