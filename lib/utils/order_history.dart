import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../screens/orders_screen.dart';

/// Opens order history on the root navigator (full-screen, above bottom nav).
abstract final class OrderHistory {
  static Future<void> open(BuildContext context, ApiClient api) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (_) => OrdersScreen(api: api),
      ),
    );
  }
}
