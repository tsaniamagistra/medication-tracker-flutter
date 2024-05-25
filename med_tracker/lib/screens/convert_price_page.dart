import 'package:flutter/material.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/models/medicine.dart';
import 'package:med_tracker/models/exchange_rates.dart';

class ConvertPricePage extends StatefulWidget {
  final String medicineId;

  ConvertPricePage({required this.medicineId});

  @override
  _ConvertPricePageState createState() => _ConvertPricePageState();
}

class _ConvertPricePageState extends State<ConvertPricePage> {
  late Future<Map<String, dynamic>> _medicineFuture;
  Map<String, double> _exchangeRates = {};
  String _destinationCurrency = 'idr';
  Medicine? _medicine;
  double? _convertedPrice;

  @override
  void initState() {
    super.initState();
    _medicineFuture = _loadMedicineDetails();
  }

  Future<Map<String, dynamic>> _loadMedicineDetails() async {
    Map<String, dynamic> medicine =
    await MedTrackerDataSource.instance.getMedicineById(widget.medicineId);
    await _loadExchangeRates(medicine['currency'] ?? 'idr');
    return medicine;
  }

  Future<void> _loadExchangeRates(String baseCurrency) async {
    try {
      final exchangeRates = await ExchangeDataSource.instance.getExchangeRate(baseCurrency);
      setState(() {
        _exchangeRates = {};
        exchangeRates[baseCurrency].forEach((key, value) {
          if (value is int) {
            _exchangeRates[key] = value.toDouble();
          } else if (value is double) {
            _exchangeRates[key] = value;
          }
        });
      });
    } catch (e) {
      print('Error loading exchange rates: $e');
    }
  }

  double _convertPrice(double price) {
    final exchangeRate = _exchangeRates[_destinationCurrency];
    print(
        'Price: $price, Exchange Rate: $exchangeRate, Destination Currency: $_destinationCurrency');
    if (exchangeRate != null) {
      final convertedPrice = price * exchangeRate;
      print('Converted Price: $convertedPrice');
      return convertedPrice;
    } else {
      print('Exchange rate not available, returning original price.');
      return price.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert Price of Medicine'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _medicineFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final medicine = snapshot.data!;
              _medicine = Medicine.fromJson(medicine);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Price: ${medicine['price']} ${medicine['currency']}'),
                  DropdownButton<String>(
                    value: _destinationCurrency,
                    items: ['idr', 'usd', 'myr']
                        .map((currency) => DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency.toUpperCase()),
                    ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _destinationCurrency = newValue!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (medicine['price'] != null) {
                        final convertedPrice =
                        _convertPrice(medicine['price'].toDouble());
                        setState(() {
                          _convertedPrice = convertedPrice;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Price information not available')),
                        );
                      }
                    },
                    child: Text('Convert Price'),
                  ),
                  if (_convertedPrice != null)
                    Text(
                        '$_convertedPrice $_destinationCurrency'),
                ],
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
