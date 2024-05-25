import 'package:flutter/material.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/models/medicine.dart';
import 'package:med_tracker/screens/add_med_page.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:med_tracker/widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Medicine>> _medicinesList;
  late String _userName = '';
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _medicinesList = _fetchMedicines();
  }

  void _loadUserName() async {
    final userId = await SessionManager.getUserId();
    Map<String, dynamic>? userData = await MedTrackerDataSource.instance.getUserById(userId!);
    setState(() {
      _userName = userData['name'] ?? '';
    });
  }

  Future<List<Medicine>> _fetchMedicines() async {
    try {
      final userId = await SessionManager.getUserId();
      if (_isSearching && _searchQuery.isNotEmpty) {
        final List<dynamic> medicinesJson = await MedTrackerDataSource.instance.getMedicineByName(userId!, _searchQuery);
        return medicinesJson.map((json) => Medicine.fromJson(json)).toList();
      } else {
        final List<dynamic> medicinesJson = await MedTrackerDataSource.instance.loadMedicines(userId!);
        return medicinesJson.map((json) => Medicine.fromJson(json)).toList();
      }
    } catch (error) {
      print("Error fetching medicines: $error");
      return [];
    }
  }

  Future<void> _deleteMedicine(String medicineId) async {
    try {
      await MedTrackerDataSource.instance.deleteMedicineById(medicineId);
      setState(() {
        _medicinesList = _fetchMedicines();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicine deleted successfully!'), backgroundColor: Colors.green,),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete medicine!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $_userName!'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
      body: Column(
        children: [
          _buildActionsBody(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: _buildMedicinesBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                    _isSearching = query.isNotEmpty;
                    _medicinesList = _fetchMedicines();
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _isSearching = false;
                _medicinesList = _fetchMedicines();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMedicinePage()),
              ).then((_) {
                setState(() {
                  _medicinesList = _fetchMedicines();
                });
              });
            },
          ),
        ],
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
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Column(
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
                        if (medicine.doseSchedules != null)
                          Expanded(
                            child: Text(
                              medicine.doseSchedules!.map((drinkTime) => drinkTime.time).join(' '),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        if (medicine.timezone != null)
                          Text(
                            medicine.timezone!,
                            style: TextStyle(fontSize: 14.0),
                          ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    if (medicine.additionalInfo != null)
                      Text(
                        medicine.additionalInfo!,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    SizedBox(height: 5.0),
                    if (medicine.price != null)
                      Text(
                        'Price: ${medicine.price}${medicine.currency != null ? ' ${medicine.currency}' : ''}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      _deleteMedicine(medicine.id!);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
