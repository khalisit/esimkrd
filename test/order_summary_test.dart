import 'package:esimkrd/models/order_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OrderSummary parses Laravel order JSON', () {
    final order = OrderSummary.fromJson({
      'id': 12,
      'status': 'completed',
      'amount_usd': '4.50',
      'amount_iqd': 6750,
      'created_at': '2026-08-30T08:00:00.000000Z',
      'package': {
        'title': 'Iraq 1GB',
        'country_code': 'IQ',
        'country_name': 'Iraq',
        'data_amount': '1 GB',
        'validity_days': 7,
      },
      'payment': {
        'gateway': 'stripe',
        'payment_url': 'https://example.com/pay',
        'status': 'paid',
      },
    });

    expect(order.id, 12);
    expect(order.status, 'completed');
    expect(order.amountUsd, 4.5);
    expect(order.amountIqd, 6750);
    expect(order.packageTitle, 'Iraq 1GB');
    expect(order.countryCode, 'IQ');
    expect(order.canResumePayment, false);
  });

  test('OrderSummary tolerates missing relations', () {
    final order = OrderSummary.fromJson({
      'id': '3',
      'status': 'pending',
      'amount_usd': 2,
      'amount_iqd': '3000',
      'created_at': null,
      'package': null,
      'payment': null,
    });

    expect(order.id, 3);
    expect(order.packageTitle, '');
    expect(order.countryCode, '');
    expect(order.canResumePayment, false);
  });

  test('OrderSummary parses Map from generic JSON decode', () {
    final raw = <String, dynamic>{
      'id': 1,
      'status': 'paid',
      'amount_usd': 1.0,
      'amount_iqd': 1500,
      'created_at': '2026-01-15T12:00:00.000000Z',
      'package': <String, Object?>{
        'title': 'Test',
        'country_code': 'KRD',
        'country_name': 'Kurdistan',
        'validity_days': '14',
      },
    };

    final order = OrderSummary.fromJson(Map<String, dynamic>.from(raw));
    expect(order.countryCode, 'KRD');
    expect(order.validityDays, 14);
  });
}
