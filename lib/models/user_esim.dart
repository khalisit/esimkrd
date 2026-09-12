class EsimUsage {
  const EsimUsage({
    required this.remainingMb,
    required this.totalMb,
    required this.usedMb,
    required this.percentUsed,
    required this.isUnlimited,
    this.status,
    this.expiredAt,
    this.remainingVoice = 0,
    this.totalVoice = 0,
    this.remainingText = 0,
    this.totalText = 0,
  });

  final int remainingMb;
  final int totalMb;
  final int usedMb;
  final double percentUsed;
  final bool isUnlimited;
  final String? status;
  final DateTime? expiredAt;
  final int remainingVoice;
  final int totalVoice;
  final int remainingText;
  final int totalText;

  double get remainingFraction {
    if (isUnlimited || totalMb <= 0) return 1;
    return (remainingMb / totalMb).clamp(0.0, 1.0);
  }

  factory EsimUsage.fromJson(Map<String, dynamic> json) {
    return EsimUsage(
      remainingMb: (json['remaining_mb'] as num?)?.toInt() ?? 0,
      totalMb: (json['total_mb'] as num?)?.toInt() ?? 0,
      usedMb: (json['used_mb'] as num?)?.toInt() ?? 0,
      percentUsed: (json['percent_used'] as num?)?.toDouble() ?? 0,
      isUnlimited: json['is_unlimited'] as bool? ?? false,
      status: json['status'] as String?,
      expiredAt: json['expired_at'] != null
          ? DateTime.tryParse(json['expired_at'] as String)
          : null,
      remainingVoice: (json['remaining_voice'] as num?)?.toInt() ?? 0,
      totalVoice: (json['total_voice'] as num?)?.toInt() ?? 0,
      remainingText: (json['remaining_text'] as num?)?.toInt() ?? 0,
      totalText: (json['total_text'] as num?)?.toInt() ?? 0,
    );
  }
}

class UserEsim {
  UserEsim({
    required this.id,
    required this.iccid,
    required this.packageName,
    required this.status,
    this.dataTotal,
    this.dataUsed,
    this.expiresAt,
    this.smdpAddress,
    this.activationCode,
    this.confirmationCode,
    this.lpaString,
    this.qrcodeUrl,
    this.appleInstallUrl,
    this.apnValue,
    this.shareLink,
    this.shareCode,
    this.countryName,
    this.countryCode,
    this.usage,
  });

  final int id;
  final String iccid;
  final String packageName;
  final String status;
  final String? dataTotal;
  final String? dataUsed;
  final DateTime? expiresAt;
  final String? smdpAddress;
  final String? activationCode;
  final String? confirmationCode;
  final String? lpaString;
  final String? qrcodeUrl;
  final String? appleInstallUrl;
  final String? apnValue;
  final String? shareLink;
  final String? shareCode;
  final String? countryName;
  final String? countryCode;
  final EsimUsage? usage;

  bool get hasInstallDetails =>
      (smdpAddress != null && smdpAddress!.isNotEmpty) ||
      (activationCode != null && activationCode!.isNotEmpty) ||
      (qrcodeUrl != null && qrcodeUrl!.isNotEmpty) ||
      (lpaString != null && lpaString!.isNotEmpty);

  factory UserEsim.fromJson(Map<String, dynamic> json) {
    final order = json['order'] as Map<String, dynamic>?;
    final package = order?['package'] as Map<String, dynamic>?;
    final usageJson = json['usage'] as Map<String, dynamic>?;

    return UserEsim(
      id: json['id'] as int,
      iccid: json['iccid'] as String? ?? '',
      packageName: json['package_name'] as String? ?? 'eSIM',
      status: json['status'] as String? ?? 'active',
      dataTotal: json['data_total'] as String?,
      dataUsed: json['data_used'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
      smdpAddress: json['smdp_address'] as String?,
      activationCode: json['activation_code'] as String?,
      confirmationCode: json['confirmation_code'] as String?,
      lpaString: json['lpa_string'] as String?,
      qrcodeUrl: json['qrcode_url'] as String? ?? order?['qr_code'] as String?,
      appleInstallUrl: json['apple_install_url'] as String?,
      apnValue: json['apn_value'] as String?,
      shareLink: json['share_link'] as String?,
      shareCode: json['share_code'] as String?,
      countryName: package?['country_name'] as String?,
      countryCode: package?['country_code'] as String?,
      usage: usageJson != null ? EsimUsage.fromJson(usageJson) : null,
    );
  }
}

String formatDataMb(int mb) {
  if (mb >= 1024) {
    final gb = mb / 1024;
    final text = gb >= 10 ? gb.toStringAsFixed(0) : gb.toStringAsFixed(1);
    return '$text GB';
  }
  return '$mb MB';
}
