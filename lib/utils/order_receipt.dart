import '../utils/currency_format.dart';

abstract final class OrderReceipt {
  static String format({
    required int orderId,
    required String packageTitle,
    required String countryName,
    required double amountUsd,
    required int amountIqd,
    String? dataAmount,
    int? validityDays,
    DateTime? createdAt,
    String status = 'paid',
  }) {
    final lines = <String>[
      'eSIM KRD — Receipt',
      '─────────────────────',
      'Order #$orderId',
      if (createdAt != null) 'Date: ${_formatDate(createdAt)}',
      '',
      'Plan: $packageTitle',
      if (countryName.isNotEmpty) 'Destination: $countryName',
      if (dataAmount != null && dataAmount.isNotEmpty) 'Data: $dataAmount',
      if (validityDays != null && validityDays > 0) 'Validity: $validityDays days',
      '',
      'Total: ${CurrencyFormat.usd(amountUsd)}',
      '       ${CurrencyFormat.iqd(amountIqd)}',
      'Status: ${_formatStatus(status)}',
      '',
      'Your eSIM is available in the app under My eSIMs.',
      'Support: support@esim-krd.xyz',
    ];
    return lines.join('\n');
  }

  static String fromOrderJson(Map<String, dynamic> order) {
    final package = order['package'] as Map<String, dynamic>? ?? {};
    return format(
      orderId: order['id'] as int,
      packageTitle: package['title'] as String? ?? 'eSIM',
      countryName: package['country_name'] as String? ?? '',
      amountUsd: double.parse(order['amount_usd'].toString()),
      amountIqd: int.parse(order['amount_iqd'].toString()),
      dataAmount: package['data_amount'] as String?,
      validityDays: package['validity_days'] as int?,
      createdAt: DateTime.tryParse(order['created_at'] as String? ?? ''),
      status: order['status'] as String? ?? 'paid',
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String _formatStatus(String status) {
    return switch (status) {
      'completed' || 'paid' || 'delivered' => 'Paid',
      'pending' => 'Pending',
      'failed' => 'Failed',
      _ => status,
    };
  }
}
