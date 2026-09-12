/// API base URL — override at build time:
/// `flutter run --dart-define=API_BASE_URL=https://api.esim-krd.xyz/api`
/// `flutter build apk --dart-define=API_BASE_URL=https://api.esim-krd.xyz/api`
abstract final class ApiConfig {
  static const String _defaultBaseUrl = 'https://api.esim-krd.xyz/api';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );
}
