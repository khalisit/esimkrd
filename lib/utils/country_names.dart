import 'package:flutter/material.dart';

abstract final class CountryNames {
  static String localized(BuildContext context, String code, String fallback) {
    final locale = Localizations.localeOf(context).languageCode;
    return _names[locale]?[code] ?? _names['en']?[code] ?? fallback;
  }

  static const _names = <String, Map<String, String>>{
    'en': {
      'KRD': 'Kurdistan',
      'IQ': 'Iraq',
      'TR': 'Turkey',
      'IR': 'Iran',
      'SY': 'Syria',
      'DE': 'Germany',
      'GB': 'United Kingdom',
      'SE': 'Sweden',
      'NL': 'Netherlands',
      'AE': 'UAE',
      'SA': 'Saudi Arabia',
      'US': 'United States',
      'FR': 'France',
    },
    'ku': {
      'KRD': 'کوردستان',
      'IQ': 'عێراق',
      'TR': 'تورکیا',
      'IR': 'ئێران',
      'SY': 'سوریا',
      'DE': 'ئەڵمانیا',
      'GB': 'شانشینی یەکگرتوو',
      'SE': 'سوید',
      'NL': 'هۆڵەندا',
      'AE': 'میرنشینە یەکگرتووە عەرەبییەکان',
      'SA': 'سعودیە',
      'US': 'ئەمریکا',
      'FR': 'فەڕەنسا',
    },
    'ar': {
      'KRD': 'كردستان',
      'IQ': 'العراق',
      'TR': 'تركيا',
      'IR': 'إيران',
      'SY': 'سوريا',
      'DE': 'ألمانيا',
      'GB': 'المملكة المتحدة',
      'SE': 'السويد',
      'NL': 'هولندا',
      'AE': 'الإمارات',
      'SA': 'السعودية',
      'US': 'الولايات المتحدة',
      'FR': 'فرنسا',
    },
  };
}
