/// OAuth client IDs for native sign-in (from Firebase / GoogleService-Info.plist).
abstract final class AuthConfig {
  /// iOS client — `CLIENT_ID` in GoogleService-Info.plist
  static const iosGoogleClientId =
      '302196387275-kpe81f607lqjt2agniorr74atfi0shfs.apps.googleusercontent.com';

  /// Web client — Firebase Console → Authentication → Google → Web client ID
  static const googleWebClientId =
      '302196387275-05a341ht581he101ntdtgq443ambldpl.apps.googleusercontent.com';
}
