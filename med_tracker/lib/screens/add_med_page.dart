import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/models/medicine.dart';
import 'package:med_tracker/screens/home_page.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:med_tracker/models/currency_list.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedFrequencyType;
  List<String> _frequencyTypes = ['Day', 'Week', 'Month', 'Year'];
  String? _selectedCurrency;
  List<String> _currencies = currencyList.map((currency) => currency.toLowerCase()).toList();
  String? _selectedTimezone;
  List<String> _timezones = [];
  List<TimeOfDay> _doseTimes = [];

  @override
  void initState() {
    super.initState();
    _loadTimezones();
  }

  Future<void> _loadTimezones() async {
    try {
      List<String> timezones = await TimeAPIDataSource.instance.loadTimezones();
      setState(() {
        _timezones = timezones;
        _selectedTimezone = timezones.isNotEmpty ? timezones.first : null;
      });
    } catch (e) {
      print('Failed to load timezones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Medicine Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Medicine name cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(labelText: 'Dosage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dosage cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _frequencyController,
                      decoration: InputDecoration(labelText: 'Frequency'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Frequency cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '/',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(width: 16.0),
                  DropdownButton<String>(
                      menuMaxHeight: 250,
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
              Row(
                children: [
                  Text('Timezone: '),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      menuMaxHeight: 400,
                      value: _selectedTimezone ?? (_timezones.isNotEmpty ? _timezones.first : null),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedTimezone = value;
                        });
                      },
                      items: _timezones.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // mengubah setiap elemen dalam daftar _doseTimes menjadi sebuah widget ListTile
              ..._doseTimes.map((time) => ListTile(
                title: Text('Dose Time: ${time.format(context)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _doseTimes.remove(time);
                    });
                  },
                ),
              )),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickTime,
                child: Text('+ Add Dose Time'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _additionalInfoController,
                decoration: InputDecoration(labelText: 'Additional Info'),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '/',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(width: 16.0),
                  DropdownButton<String>(
                      menuMaxHeight: 250,
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
                          child: Text(value.toUpperCase()),
                        );
                      }).toList()),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addMedicine();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
                child: Text('Add Medicine'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _doseTimes.add(pickedTime);
      });
    }
  }

  Future<void> _addMedicine() async {
    String? userId = await SessionManager.getUserId();
    String name = _nameController.text.trim();
    String dosage = _dosageController.text.trim();
    int? frequency = int.tryParse(_frequencyController.text.trim());
    String? frequencyType = _selectedFrequencyType ?? _frequencyTypes.first;
    double? price = _priceController.text.trim().isNotEmpty ? double.tryParse(_priceController.text.trim()) : null;
    String? currency = _priceController.text.trim().isNotEmpty ? _selectedCurrency : null;
    String additionalInfo = _additionalInfoController.text.trim();

    List<DoseSchedules> doseSchedules = _doseTimes.map((time) {
      String formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      return DoseSchedules(time: formattedTime);
    }).toList();

    String? timezone = _doseTimes.isNotEmpty ? _selectedTimezone : null;

    if (userId != null) {
      Medicine newMedicine = Medicine(
        user: userId,
        name: name,
        dosage: dosage,
        frequency: frequency,
        frequencyType: frequencyType,
        additionalInfo: additionalInfo,
        price: price,
        currency: currency?.toLowerCase(),
        timezone: timezone,
        doseSchedules: doseSchedules.isNotEmpty ? doseSchedules : null,
      );

      MedTrackerDataSource.instance.createMedicine(newMedicine.toJson()).then((response) {
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
