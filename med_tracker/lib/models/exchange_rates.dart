class ExchangeRates {
  final String date;
  final String baseCurrency;
  final Map<String, double> rates;

  ExchangeRates({required this.date, required this.baseCurrency, required this.rates});

  factory ExchangeRates.fromJson(Map<String, dynamic> json) {
    // ambil date
    String date = json['date'];
    // memanfaatkan bahwa key base currency adalah key pertama setelah date
    String baseCurrency = json.keys.firstWhere((key) => key != 'date');
    // ambil nilai tukar (rates)
    Map<String, dynamic> rates = json[baseCurrency];
    // convert rates ke double
    Map<String, double> convertedRates = rates.map((key, value) => MapEntry(key, (value as num).toDouble()));

    return ExchangeRates(
      date: date,
      baseCurrency: baseCurrency,
      rates: convertedRates,
    );
  }
}