import 'package:flutter/material.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/models/medicine.dart';
import 'package:med_tracker/services/session_manager.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedFrequencyType;
  List<String> _frequencyTypes = ['day', 'week', 'month', 'year'];

  String? _selectedCurrency;
  List<String> _currencies = ['idr', 'usd', 'myr'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: 'Dosage'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _frequencyController,
                    decoration: InputDecoration(labelText: 'Frequency'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.0),
                Text(
                  '/',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 16.0),
                DropdownButton<String>(
                    value: _selectedFrequencyType ?? _frequencyTypes.first,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedFrequencyType = value;
                      });
                    },
                    items: _frequencyTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _additionalInfoController,
              decoration: InputDecoration(labelText: 'Additional Info'),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.0),
                Text(
                  '/',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 16.0),
                DropdownButton<String>(
                    value: _selectedCurrency ?? _currencies.first,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCurrency = value;
                      });
                    },
                    items: _currencies
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addMedicine();
              },
              child: Text('Add Medicine'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMedicine() async {
    String? userId = await SessionManager.getUserId();
    String name = _nameController.text.trim();
    String dosage = _dosageController.text.trim();
    int? frequency = int.tryParse(_frequencyController.text.trim());
    String? frequencyType = _selectedFrequencyType;
    double? price = double.tryParse(_frequencyController.text.trim());
    String? currency = _selectedCurrency;
    String additionalInfo = _additionalInfoController.text.trim();

    if (userId != null) {
      Medicine newMedicine = Medicine(
        user: userId,
        name: name,
        dosage: dosage,
        frequency: frequency,
        frequencyType: frequencyType,
        additionalInfo: additionalInfo,
        price: price,
        currency: currency,
      );

      MedTrackerDataSource.instance
          .createMedicine(newMedicine.toJson())
          .then((response) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Medicine added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add medicine!'),
            backgroundColor: Colors.red,
          ),
        );
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User information not found!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
