import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/currency_format.dart';

enum CurrencyDisplayMode {
  both,
  usd,
  iqd;

  static CurrencyDisplayMode fromStorage(String? value) {
    return switch (value) {
      'usd' => CurrencyDisplayMode.usd,
      'iqd' => CurrencyDisplayMode.iqd,
      _ => CurrencyDisplayMode.both,
    };
  }

  String get storageValue => name;
}

class CurrencyPreferenceService extends ChangeNotifier {
  CurrencyPreferenceService._();

  static final CurrencyPreferenceService instance = CurrencyPreferenceService._();

  static const _storageKey = 'currency_display_mode';

  CurrencyDisplayMode _mode = CurrencyDisplayMode.both;

  CurrencyDisplayMode get mode => _mode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _mode = CurrencyDisplayMode.fromStorage(prefs.getString(_storageKey));
    CurrencyFormat.displayMode = _mode;
  }

  Future<void> setMode(CurrencyDisplayMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    CurrencyFormat.displayMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, mode.storageValue);
  }
}
