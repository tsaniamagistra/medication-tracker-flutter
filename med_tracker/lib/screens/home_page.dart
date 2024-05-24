import 'package:flutter/material.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/models/medicine.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:med_tracker/widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Medicine>> _medicinesList;
  late String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _medicinesList = _fetchMedicines();
  }

  void _loadUserName() async {
    String? userName = await SessionManager.getUserName();
    setState(() {
      _userName = userName ?? '';
    });
  }

  Future<List<Medicine>> _fetchMedicines() async {
    try {
      String? userId = await SessionManager.getUserId();
      final List<dynamic> medicinesJson = await MedTrackerDataSource.instance.loadMedicines(userId!);
      return medicinesJson.map((json) => Medicine.fromJson(json)).toList();
    } catch (error) {
      print("Error fetching medicines: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $_userName!'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _medicinesList = _fetchMedicines();
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: _buildMedicinesBody(),
      ),
    );
  }

  Widget _buildMedicinesBody() {
    return FutureBuilder<List<Medicine>>(
      future: _medicinesList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading medicines'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No medicines found'));
        } else {
          final medicines = snapshot.data!;
          return _buildMedicinesList(medicines);
        }
      },
    );
  }

  Widget _buildMedicinesList(List<Medicine> medicines) {
    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicines[index];
        return InkWell(
          onTap: () {
            // Handle medicine item tap
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        medicine.name ?? 'No name',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${medicine.frequency}x${medicine.dosage}/${medicine.frequencyType}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (medicine.doseSchedules?.map((drinkTime) => drinkTime.time) ?? ['No time']).join(' '),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Text(
                        medicine.timezone ?? 'No timezone',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    medicine.additionalInfo ?? 'No additional info',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Price: ${medicine.price ?? 'No price'} ${medicine.currency ?? 'No currency'}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
