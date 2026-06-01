import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// The void callback with async support.
typedef FutureOrVoidCallback = FutureOr<void> Function();

/// The callback to return a function.
typedef GuardCallback =
    FutureOrVoidCallback Function(FutureOrVoidCallback func);

/// Returns the callback to discard any simultaneous function calls.
GuardCallback useGuard() => use(const _GuardHook());

class _GuardHook extends Hook<GuardCallback> {
  const _GuardHook();

  @override
  _GuardHookState createState() => _GuardHookState();
}

class _GuardHookState extends HookState<GuardCallback, _GuardHook> {
  bool _isLoading = false;

  @override
  GuardCallback build(BuildContext context) =>
      (FutureOrVoidCallback func) => () async {
        if (_isLoading) {
          return;
        }

        _isLoading = true;
        try {
          await func();
        } finally {
          _isLoading = false;
        }
      };

  @override
  String get debugLabel => 'useGuard';
}
