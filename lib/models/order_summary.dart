class OrderSummary {
  const OrderSummary({
    required this.id,
    required this.status,
    required this.amountUsd,
    required this.amountIqd,
    required this.createdAt,
    required this.packageTitle,
    required this.countryCode,
    required this.countryName,
    this.dataAmount,
    this.validityDays = 0,
    this.paymentGateway,
    this.paymentUrl,
    this.paymentStatus,
    this.canResumePayment = false,
  });

  final int id;
  final String status;
  final double amountUsd;
  final int amountIqd;
  final DateTime? createdAt;
  final String packageTitle;
  final String countryCode;
  final String countryName;
  final String? dataAmount;
  final int validityDays;
  final String? paymentGateway;
  final String? paymentUrl;
  final String? paymentStatus;
  final bool canResumePayment;

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    final package = _readMap(json['package']);
    final payment = _readMap(json['payment']);
    final gateway = _readString(payment['gateway']);
    final paymentUrl = _readString(payment['payment_url']);
    final paymentStatus = _readString(payment['status']);
    final status = _readString(json['status']) ?? 'pending';

    final canResume = status == 'pending' &&
        gateway != null &&
        gateway != 'fib_manual' &&
        (gateway == 'fib' || (paymentUrl != null && paymentUrl.isNotEmpty));

    return OrderSummary(
      id: _asInt(json['id']),
      status: status,
      amountUsd: _asDouble(json['amount_usd']),
      amountIqd: _asInt(json['amount_iqd']),
      createdAt: DateTime.tryParse(_readString(json['created_at']) ?? ''),
      packageTitle: _readString(package['title']) ?? '',
      countryCode: _readString(package['country_code']) ?? '',
      countryName: _readString(package['country_name']) ?? '',
      dataAmount: _readString(package['data_amount']),
      validityDays: _asInt(package['validity_days']),
      paymentGateway: gateway,
      paymentUrl: paymentUrl,
      paymentStatus: paymentStatus,
      canResumePayment: canResume,
    );
  }

  static Map<String, dynamic> _readMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static String? _readString(Object? value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static int _asInt(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _asDouble(Object? value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
