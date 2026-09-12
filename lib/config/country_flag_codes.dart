/// Maps Airalo / API country codes (and regional names) to flag assets.
abstract final class CountryFlagCodes {
  static const _overrides = <String, String>{
    // Puerto Rico (Airalo uses USPR).
    'USPR': 'PR',
  };

  /// Airalo placeholder for multi-country / regional packages.
  static const _invalidCodes = <String>{
    'XX',
    'ZZ',
  };

  /// Regional package titles → ISO / EU flag when a sensible flag exists.
  /// Continents without a real flag return null and use a region badge icon.
  static const _regionNameToFlag = <String, String>{
    'europe': 'EU',
    'european union and united kingdom': 'EU',
    'european union': 'EU',
    'oceania': 'AU',
    'north america': 'US',
    'latin america': 'BR',
    'caribbean islands': 'JM',
    'caribbean': 'JM',
    'middle east and north africa': 'AE',
    'middle east': 'AE',
  };

  /// Returns a 2-letter ISO (or EU) code for flag rendering, or null if unknown.
  static String? resolve(String countryCode, {String? countryName}) {
    final raw = countryCode.trim().toUpperCase();
    if (raw.isEmpty) return null;

    final override = _overrides[raw];
    if (override != null) return override;

    // Regional packages share "XX" — never treat as a real ISO flag.
    if (_invalidCodes.contains(raw) || raw == 'XX') {
      return resolveRegionName(countryName);
    }

    if (_isIsoAlpha2(raw)) return raw;

    final hyphen = raw.indexOf('-');
    if (hyphen == 2) {
      final prefix = raw.substring(0, 2);
      if (_isIsoAlpha2(prefix) && prefix != 'XX') return prefix;
    }

    return resolveRegionName(countryName);
  }

  static String? resolveRegionName(String? countryName) {
    if (countryName == null) return null;
    final key = countryName.trim().toLowerCase();
    if (key.isEmpty) return null;
    return _regionNameToFlag[key];
  }

  static bool isRegionalCode(String countryCode) {
    final raw = countryCode.trim().toUpperCase();
    return raw == 'XX' || _invalidCodes.contains(raw);
  }

  static bool _isIsoAlpha2(String code) {
    return code.length == 2 && RegExp(r'^[A-Z]{2}$').hasMatch(code);
  }
}
