class Country {
  Country({required this.code, required this.name});

  final String code;
  final String name;

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['country_code'] as String,
      name: json['country_name'] as String,
    );
  }
}
