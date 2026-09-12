class CheckoutSelection {
  const CheckoutSelection({
    required this.paymentMethod,
    this.promoCode,
  });

  final String paymentMethod;
  final String? promoCode;
}
