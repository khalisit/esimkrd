import 'package:flutter/material.dart';

import '../models/checkout_order.dart';
import '../screens/fib_qr_screen.dart';
import '../screens/payment_result_screen.dart';
import '../screens/payment_webview_screen.dart';
import '../services/api_client.dart';
import '../utils/page_transitions.dart';

String paymentLanguageForLocale(String languageCode) {
  return languageCode == 'en' ? 'en' : 'ar';
}

/// Routes a created order to the right payment experience (FIB QR or card WebView).
Future<void> startCheckoutFlow({
  required BuildContext context,
  required ApiClient api,
  required Map<String, dynamic> orderResponse,
}) async {
  final checkout = CheckoutOrder.fromCreateResponse(orderResponse);
  await startCheckoutFromOrder(context: context, api: api, checkout: checkout);
}

/// Resumes payment for a pending order from order history.
Future<void> resumeCheckoutFlow({
  required BuildContext context,
  required ApiClient api,
  required int orderId,
}) async {
  final response = await api.get('/orders/$orderId', auth: true);
  final order = response['data'] as Map<String, dynamic>;
  final checkout = CheckoutOrder.fromOrderDetail(order);
  if (!context.mounted) return;
  await startCheckoutFromOrder(context: context, api: api, checkout: checkout);
}

Future<void> startCheckoutFromOrder({
  required BuildContext context,
  required ApiClient api,
  required CheckoutOrder checkout,
}) async {
  if (checkout.isFib) {
    await Navigator.of(context).push(
      AppPageRoute(page: FibQrScreen(api: api, checkout: checkout)),
    );
    return;
  }

  if (checkout.isMockPayment) {
    final uri = Uri.parse(checkout.paymentUrl);
    final apiPath = uri.path.startsWith('/api') ? uri.path.substring(4) : uri.path;
    await api.post(apiPath, auth: true);
    if (!context.mounted) return;
    await Navigator.of(context).push(
      AppPageRoute(page: PaymentResultScreen(api: api, orderId: checkout.orderId)),
    );
    return;
  }

  if (checkout.paymentUrl.isEmpty) return;

  final completed = await Navigator.of(context).push<bool>(
    AppPageRoute(
      page: PaymentWebViewScreen(
        paymentUrl: checkout.paymentUrl,
        orderId: checkout.orderId,
      ),
    ),
  );

  if (!context.mounted) return;

  await Navigator.of(context).push(
    AppPageRoute(
      page: PaymentResultScreen(
        api: api,
        orderId: checkout.orderId,
        paymentReturned: completed == true,
      ),
    ),
  );
}
