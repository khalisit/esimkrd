class CheckoutOrder {
  const CheckoutOrder({
    required this.orderId,
    required this.paymentUrl,
    required this.gateway,
    required this.referenceCode,
    required this.fibAccountPhone,
    required this.fibAccountIban,
    required this.fibAccountName,
    required this.packageTitle,
    required this.dataAmount,
    required this.validityDays,
    required this.amountUsd,
    required this.amountIqd,
    required this.countryCode,
    required this.countryName,
    this.fibQrCode,
    this.fibReadableCode,
    this.fibPersonalLink,
    this.fibBusinessLink,
    this.fibCorporateLink,
  });

  final int orderId;
  final String paymentUrl;
  final String gateway;
  final String referenceCode;
  final String fibAccountPhone;
  final String fibAccountIban;
  final String fibAccountName;
  final String packageTitle;
  final String? dataAmount;
  final int validityDays;
  final double amountUsd;
  final int amountIqd;
  final String countryCode;
  final String countryName;
  final String? fibQrCode;
  final String? fibReadableCode;
  final String? fibPersonalLink;
  final String? fibBusinessLink;
  final String? fibCorporateLink;

  bool get isMockPayment =>
      paymentUrl.contains('/dev/orders/') && paymentUrl.endsWith('/pay');

  bool get isFib => gateway == 'fib';

  bool get isFibManual => gateway == 'fib_manual';

  bool get isLemonSqueezy => gateway == 'lemon_squeezy';

  bool get isStripe => gateway == 'stripe';

  bool get isCardCheckout => isLemonSqueezy || isStripe;

  factory CheckoutOrder.fromCreateResponse(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>;
    final order = data['order'] as Map<String, dynamic>;
    return CheckoutOrder.fromOrderDetail(
      order,
      paymentUrl: data['payment_url'] as String?,
      payment: data['payment'] as Map<String, dynamic>?,
      useCreatePaymentShape: true,
    );
  }

  factory CheckoutOrder.fromOrderDetail(
    Map<String, dynamic> order, {
    String? paymentUrl,
    Map<String, dynamic>? payment,
    bool useCreatePaymentShape = false,
  }) {
    final package = order['package'] as Map<String, dynamic>;
    final paymentData = payment ?? order['payment'] as Map<String, dynamic>?;
    final Map<String, dynamic>? instructions;
    final String? referenceCode;
    if (useCreatePaymentShape) {
      instructions = paymentData?['instructions'] as Map<String, dynamic>?;
      referenceCode = paymentData?['reference_code'] as String?;
    } else {
      instructions = paymentData?['gateway_response'] as Map<String, dynamic>?;
      referenceCode = paymentData?['wayl_reference_id'] as String?;
    }

    return CheckoutOrder(
      orderId: order['id'] as int,
      paymentUrl: paymentUrl ?? (paymentData?['payment_url'] as String?) ?? '',
      gateway: paymentData?['gateway'] as String? ?? 'mock',
      referenceCode: referenceCode ?? '',
      fibAccountPhone: instructions?['account_phone'] as String? ?? '',
      fibAccountIban: instructions?['account_iban'] as String? ?? '',
      fibAccountName: instructions?['account_name'] as String? ?? '',
      packageTitle: package['title'] as String? ?? '',
      dataAmount: package['data_amount'] as String?,
      validityDays: package['validity_days'] as int? ?? 0,
      amountUsd: double.parse(order['amount_usd'].toString()),
      amountIqd: int.parse(order['amount_iqd'].toString()),
      countryCode: package['country_code'] as String? ?? '',
      countryName: package['country_name'] as String? ?? '',
      fibQrCode: instructions?['qr_code'] as String?,
      fibReadableCode: instructions?['readable_code'] as String?,
      fibPersonalLink: instructions?['personal_app_link'] as String?,
      fibBusinessLink: instructions?['business_app_link'] as String?,
      fibCorporateLink: instructions?['corporate_app_link'] as String?,
    );
  }
}
