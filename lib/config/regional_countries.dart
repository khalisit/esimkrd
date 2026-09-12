import '../models/country.dart';

/// Country codes prioritized for Kurdish users (Kurdistan & diaspora).
abstract final class RegionalCountries {
  /// App-only code — packages are loaded from Iraq (`IQ`) on the API.
  static const kurdistanCode = 'KRD';

  static const kurdishRegionCodes = [
    kurdistanCode,
    'IQ', // Iraq
    'TR', // Turkey
    'IR', // Iran
    'SY', // Syria
    'DE', // Germany (diaspora)
    'GB', // UK
    'SE', // Sweden
    'NL', // Netherlands
    'AE', // UAE
    'SA', // Saudi Arabia
    'US', // USA
    'FR', // France
  ];

  static const popularCodes = ['IQ', 'TR', 'AE', 'DE', 'US', 'GB', 'FR', 'SA'];

  /// Maps display codes to API country codes for package queries.
  static String packageCountryCode(String code) {
    if (code == kurdistanCode) return 'IQ';
    return code;
  }

  static bool isKurdistan(String code) => code == kurdistanCode;

  static Country? syntheticCountry(String code) {
    if (code == kurdistanCode) {
      return Country(code: kurdistanCode, name: 'Kurdistan');
    }
    return null;
  }
}
