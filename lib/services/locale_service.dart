import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocaleService extends ChangeNotifier {
  LocaleService() {
    _syncIntlLocale();
  }

  static const _storageKey = 'app_locale';

  static const supportedLocales = [
    Locale('en'),
    Locale('ku'),
    Locale('ar'),
  ];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  bool get isRtl => _locale.languageCode == 'ar' || _locale.languageCode == 'ku';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    if (code != null) {
      _locale = Locale(code);
    }
    _syncIntlLocale();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    _syncIntlLocale();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, locale.languageCode);
  }

  /// `intl` has no Kurdish locale data — use English for formatting.
  void _syncIntlLocale() {
    final code = _locale.languageCode;
    Intl.defaultLocale = code == 'ku' ? 'en' : code;
  }
}
