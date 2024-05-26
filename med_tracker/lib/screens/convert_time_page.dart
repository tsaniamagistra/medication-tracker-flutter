import 'package:flutter/material.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/screens/home_page.dart';

class ConvertTimePage extends StatefulWidget {
  final String medicineId;
  final String medicineName;

  ConvertTimePage({required this.medicineId, required this.medicineName});

  @override
  _ConvertTimePageState createState() => _ConvertTimePageState();
}

class _ConvertTimePageState extends State<ConvertTimePage> {
  late Future<Map<String, dynamic>> _medicineFuture;
  List<String> _timezones = [];
  String _selectedTimezone = 'UTC';
  List<String> _convertedTimes = [];

  @override
  void initState() {
    super.initState();
    _medicineFuture = _loadMedicineDetails();
    _loadTimezones();
  }

  Future<Map<String, dynamic>> _loadMedicineDetails() async {
    Map<String, dynamic> medicine = await MedTrackerDataSource.instance.getMedicineById(widget.medicineId);

    if (medicine['doseSchedules'] == null || medicine['doseSchedules'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected medicine doesn\'t have any time'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      throw Exception('Selected medicine doesn\'t have any time');
    }

    return medicine;
  }

  Future<void> _loadTimezones() async {
    try {
      List<String> timezones = await TimeAPIDataSource.instance.loadTimezones();
      setState(() {
        _timezones = timezones;
      });
    } catch (e) {
      print('Failed to load timezones: $e');
    }
  }

  Future<void> _convertDoseTimes(Map<String, dynamic> medicine) async {
    final List<String> convertedTimes = [];
    for (var object in medicine['doseSchedules']) {
      // ubah ke format DateTime agar bisa diterima API
      final DateTime now = DateTime.now();
      final String formattedDateTime = '${now.year}-${now.month}-${now.day} ${object['time']}';
      final requestBody = {
        'fromTimezone': medicine['timezone'],
        'fromDateTime': formattedDateTime,
        'toTimeZone': _selectedTimezone,
      };
      final response = await TimeAPIDataSource.instance.convertTimeZone(requestBody);
      if (response['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error converting time'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        final conversionResult = response['conversionResult'];
        if (conversionResult != null) {
          final convertedTime = conversionResult['time'];
          convertedTimes.add(convertedTime);
        }
      }
    }
    setState(() {
      _convertedTimes = convertedTimes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert Time of ${widget.medicineName}'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _medicineFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final medicine = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Dose Times in ${medicine['name']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  ...medicine['doseSchedules'].map<Widget>((schedule) => Text(schedule['time'])).toList(),
                  SizedBox(height: 20.0),
                  DropdownButton<String>(
                    value: _selectedTimezone,
                    items: _timezones.map((timezone) {
                      return DropdownMenuItem<String>(
                        value: timezone,
                        child: Text(timezone),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTimezone = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () => _convertDoseTimes(medicine),
                    child: Text('Convert Times'),
                  ),
                  SizedBox(height: 20.0),
                  if (_convertedTimes.isNotEmpty)
                    ..._convertedTimes.map((result) => Text(result)).toList(),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
