class EsimPackage {
  EsimPackage({
    required this.id,
    required this.countryCode,
    required this.countryName,
    required this.title,
    required this.dataAmount,
    required this.validityDays,
    required this.retailPriceUsd,
  });

  final int id;
  final String countryCode;
  final String countryName;
  final String title;
  final String? dataAmount;
  final int validityDays;
  final double retailPriceUsd;

  factory EsimPackage.fromJson(Map<String, dynamic> json) {
    return EsimPackage(
      id: json['id'] as int,
      countryCode: json['country_code'] as String,
      countryName: json['country_name'] as String,
      title: json['title'] as String,
      dataAmount: json['data_amount'] as String?,
      validityDays: json['validity_days'] as int,
      retailPriceUsd: double.parse(json['retail_price_usd'].toString()),
    );
  }
}
