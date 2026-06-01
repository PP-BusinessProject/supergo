import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authorization.g.dart';

/// The provider which contains current authorization [Session] with [User].
@Riverpod(keepAlive: true)
class Authorization extends _$Authorization {
  static GoTrueClient get _auth => Supabase.instance.client.auth;
  bool _loading = false;

  @override
  FutureOr<Session?> build() {
    listenSelf((_, AsyncValue<Session?> next) async {
      final User? user = next.value?.user;
      if (user != null) {
        await Sentry.configureScope(
          (Scope scope) => scope.setUser(
            SentryUser(
              id: user.id,
              email: user.email,
              data: <String, Object?>{
                ...?user.userMetadata,
                'is_anonymous': user.isAnonymous,
              },
            ),
          ),
        );
      }
    });
    final StreamSubscription<AuthState> subscription = _auth.onAuthStateChange
        .listen(
          (AuthState auth) =>
              !_loading ? state = AsyncData<Session?>(auth.session) : null,
        );
    ref.onDispose(subscription.cancel);
    return _auth.currentSession;
  }

  /// Only one callback allowed at a time.
  Future<void> _guarded(Future<Session?> Function() callback) async {
    if (_loading) {
      return;
    }
    _loading = true;
    try {
      state = const AsyncValue<Session?>.loading();
      state = await AsyncValue.guard<Session?>(callback);
    } finally {
      _loading = false;
    }
  }

  /// Try to sign in anonymously.
  Future<void> signInAnonymously() => _guarded(() async {
    final AuthResponse auth = await _auth.signInAnonymously();
    return auth.session;
  });

  /// Try to sign out.
  Future<void> signOut() => _guarded(() async {
    await _auth.signOut();
    return null;
  });

  /// Try to sign in with email.
  Future<void> signInWithEmail(String email, String token) =>
      _guarded(() async {
        final AuthResponse response = await _auth.verifyOTP(
          email: email,
          token: token,
          type: OtpType.email,
        );
        return response.session;
      });

  /// Try to sign in with [GoogleSignIn].
  Future<void> signInWithGoogle() => _guarded(() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) {
      throw Exception('No ID Token found.');
    }
    final AuthResponse auth = await _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
    return auth.session;
  });

  /// Try to sign in with [SignInWithApple].
  Future<void> signInWithApple() => _guarded(() async {
    final String rawNonce = _auth.generateRawNonce();
    final String hashedNonce = sha256
        .convert(utf8.encode(rawNonce))
        .toString();

    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
          scopes: <AppleIDAuthorizationScopes>[
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashedNonce,
        );

    final String? idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }

    final AuthResponse auth = await _auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
    return auth.session;
  });
}
