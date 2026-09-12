import '../services/api_client.dart';

/// Runtime app settings loaded from `/config` on startup.
abstract final class AppConfig {
  static const double defaultUsdToIqd = 1500;

  static double usdToIqd = defaultUsdToIqd;
  static String supportEmail = 'support@esim-krd.xyz';
  static String supportWhatsapp = '';
  static const String privacyPolicyUrl = 'https://esim-krd.xyz/privacy';
  static String? googleWebClientId;

  static Future<void> load(ApiClient api) async {
    try {
      final response = await api.get('/config');
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) return;

      usdToIqd = (data['usd_to_iqd'] as num?)?.toDouble() ?? defaultUsdToIqd;
      supportEmail = data['support_email'] as String? ?? supportEmail;
      supportWhatsapp = data['support_whatsapp'] as String? ?? '';
      final webClientId = data['google_web_client_id'] as String?;
      if (webClientId != null && webClientId.isNotEmpty) {
        googleWebClientId = webClientId;
      }
    } catch (_) {
      usdToIqd = defaultUsdToIqd;
    }
  }
}
