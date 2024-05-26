import 'package:flutter/material.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/services/currency_list.dart';

class ConvertPricePage extends StatefulWidget {
  final String medicineId;
  final String medicineName;

  ConvertPricePage({required this.medicineId, required this.medicineName});

  @override
  _ConvertPricePageState createState() => _ConvertPricePageState();
}

class _ConvertPricePageState extends State<ConvertPricePage> {
  late Future<Map<String, dynamic>> _medicineFuture;
  Map<String, double> _exchangeRates = {};
  String _destinationCurrency = 'IDR';
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
      final exchangeRates =
          await ExchangeDataSource.instance.getExchangeRate(baseCurrency);
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
    final exchangeRate = _exchangeRates[_destinationCurrency.toLowerCase()];
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
        title: Text('Convert Price of ${widget.medicineName}'),
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
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Price: ${medicine['price']} ${medicine['currency'].toUpperCase()}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 14.0),
                    DropdownButton<String>(
                      menuMaxHeight: 250,
                      value: _destinationCurrency,
                      items: currencyList.map((currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _destinationCurrency = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
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
                              content: Text('Price information not available'),
                            ),
                          );
                        }
                      },
                      child: Text('Convert Price'),
                    ),
                    SizedBox(height: 20.0),
                    if (_convertedPrice != null)
                      Text(
                        '$_convertedPrice',
                        style: TextStyle(fontSize: 20.0),
                      ),
                  ],
                ),
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
