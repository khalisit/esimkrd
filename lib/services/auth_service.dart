import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../config/auth_config.dart';
import '../config/app_config.dart';
import 'api_client.dart';
import 'deep_link_service.dart';

class AuthService {
  AuthService(this._api);

  final ApiClient _api;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static bool _googleReady = false;

  /// Call before Google sign-in (after [AppConfig.load]).
  static Future<void> ensureGoogleSignInReady() async {
    if (kIsWeb || _googleReady) return;

    final serverClientId = _resolveServerClientId();
    if (serverClientId == null) {
      debugPrint(
        'Google Sign-In: missing web client ID. Set GOOGLE_WEB_CLIENT_ID on API.',
      );
      return;
    }

    await GoogleSignIn.instance.initialize(
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? AuthConfig.iosGoogleClientId
          : null,
      serverClientId: serverClientId,
    );
    _googleReady = true;
  }

  static String? _resolveServerClientId() {
    final fromApi = AppConfig.googleWebClientId;
    if (fromApi != null && fromApi.isNotEmpty) return fromApi;

    final fallback = AuthConfig.googleWebClientId;
    if (fallback.isNotEmpty) return fallback;

    return null;
  }

  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        '/auth/login',
        body: {
          'email': email.trim(),
          'password': password,
        },
      );
      await _saveApiToken(response);
      return true;
    } on ApiException catch (e) {
      throw AuthServiceException(e.message);
    } on NetworkException {
      throw AuthServiceException('Network error. Check your connection.');
    }
  }

  Future<bool> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        '/auth/register',
        body: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'password_confirmation': password,
        },
      );
      await _saveApiToken(response);
      return true;
    } on ApiException catch (e) {
      throw AuthServiceException(e.message);
    } on NetworkException {
      throw AuthServiceException('Network error. Check your connection.');
    }
  }

  /// Returns `true` when login finished; `false` if the user canceled.
  Future<bool> signInWithGoogle() async {
    if (kIsWeb) {
      return _signInWithGoogleWeb();
    }

    await AppConfig.load(_api);
    await ensureGoogleSignInReady();

    if (_resolveServerClientId() == null) {
      throw AuthServiceException(
        'Google Sign-In is not configured. Add Web client ID in Firebase Console.',
      );
    }

    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw AuthServiceException('Google did not return a sign-in token.');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _firebaseAuth.signInWithCredential(credential);
      await _completeLogin();
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return false;
      throw AuthServiceException(_googleErrorMessage(e));
    } on FirebaseAuthException catch (e) {
      if (_isCanceled(e)) return false;
      throw AuthServiceException(_friendlyMessage(e));
    }
  }

  Future<bool> _signInWithGoogleWeb() async {
    try {
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..addScope('profile');
      await _firebaseAuth.signInWithProvider(provider);
      await _completeLogin();
      return true;
    } on FirebaseAuthException catch (e) {
      if (_isCanceled(e)) return false;
      throw AuthServiceException(_friendlyMessage(e));
    }
  }

  /// Returns `true` when login finished; `false` if the user canceled.
  Future<bool> signInWithApple() async {
    if (!appleSignInAvailable) {
      throw AuthServiceException('Sign in with Apple is not available on this device.');
    }

    try {
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        return await _signInWithAppleNative();
      }

      final provider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      await _firebaseAuth.signInWithProvider(provider);
      await _completeLogin();
      return true;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return false;
      throw AuthServiceException(_appleErrorMessage(e));
    } on FirebaseAuthException catch (e) {
      if (_isCanceled(e)) return false;
      throw AuthServiceException(_friendlyMessage(e));
    }
  }

  Future<bool> _signInWithAppleNative() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final identityToken = appleCredential.identityToken;
    if (identityToken == null || identityToken.isEmpty) {
      throw AuthServiceException('Apple did not return a sign-in token.');
    }

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: identityToken,
      rawNonce: rawNonce,
    );

    await _firebaseAuth.signInWithCredential(oauthCredential);
    await _completeLogin();
    return true;
  }

  Future<void> _completeLogin() async {
    final referral = await DeepLinkService.getPendingReferralCode();
    await _exchangeFirebaseToken(referralCode: referral);
  }

  Future<void> _saveApiToken(Map<String, dynamic> response) async {
    final token = response['token'] as String?;
    if (token == null || token.isEmpty) {
      throw AuthServiceException('Backend did not return an API token.');
    }
    await _api.saveToken(token);
  }

  Future<void> _exchangeFirebaseToken({String? referralCode}) async {
    final idToken = await _firebaseAuth.currentUser?.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      throw AuthServiceException('Missing Firebase ID token.');
    }

    final response = await _api.post(
      '/auth/firebase',
      body: {
        'id_token': idToken,
        if (referralCode != null && referralCode.isNotEmpty) 'referral_code': referralCode,
      },
    );

    await _saveApiToken(response);
  }

  Future<void> signOut() async {
    try {
      await _api.post('/auth/logout', auth: true);
    } catch (_) {}

    await _api.clearToken();

    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }

    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }

  Future<void> deleteAccount() async {
    await _api.delete('/auth/account', auth: true);
    await _api.clearToken();

    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }

    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (_) {
      try {
        await _firebaseAuth.signOut();
      } catch (_) {}
    }
  }

  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool _isCanceled(FirebaseAuthException e) {
    final code = e.code.toLowerCase();
    return code.contains('cancel') ||
        code.contains('canceled') ||
        code.contains('cancelled');
  }

  static String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'This sign-in method is disabled in Firebase Console.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'unauthorized-domain':
        return 'App SHA-1 is missing in Firebase Android settings.';
      default:
        return e.message ?? e.code;
    }
  }

  static String _googleErrorMessage(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'Google Sign-In is not configured. Add Web client ID in Firebase (Authentication → Google) and set GOOGLE_WEB_CLIENT_ID on the API server.';
      case GoogleSignInExceptionCode.interrupted:
      case GoogleSignInExceptionCode.uiUnavailable:
        return 'Google Sign-In could not be shown. Try again.';
      default:
        return e.description ?? 'Google Sign-In failed.';
    }
  }

  static String _appleErrorMessage(SignInWithAppleAuthorizationException e) {
    switch (e.code) {
      case AuthorizationErrorCode.canceled:
        return 'Sign in was canceled.';
      case AuthorizationErrorCode.failed:
        return 'Apple Sign-In failed. Try again.';
      case AuthorizationErrorCode.invalidResponse:
        return 'Apple returned an invalid response.';
      case AuthorizationErrorCode.notHandled:
        return 'Apple Sign-In is not available right now.';
      case AuthorizationErrorCode.unknown:
        return 'Apple Sign-In is not configured. Enable Sign in with Apple in Xcode and Apple Developer.';
      default:
        return 'Apple Sign-In failed (${e.code.name}).';
    }
  }
}

class AuthServiceException implements Exception {
  AuthServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

bool get appleSignInAvailable {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}
