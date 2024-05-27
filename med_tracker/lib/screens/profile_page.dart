import 'package:flutter/material.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/screens/edit_profile_page.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:med_tracker/widgets/bottom_navbar.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  String? userName;
  String? userEmail;
  String? profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final id = await SessionManager.getUserId();
    Map<String, dynamic>? userData =
        await MedTrackerDataSource.instance.getUserById(id!);
    setState(() {
      userId = id;
      userName = userData['name'] ?? '';
      userEmail = userData['email'] ?? '';
      profilePicture = userData['profilePicture'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(userId: userId!),
            ),
          );
        },
        tooltip: 'Edit Profile',
        child: Icon(Icons.edit),
      ),
      body: Center(
        child: userId == null || userName == null || userEmail == null
            ? CircularProgressIndicator()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    profilePicture != null
                        ? CircleAvatar(
                            radius: 50,
                            // parameter acak pada URL utk menghindari caching gambar
                            // object bucket google cloud public URL caching, authenticated URL tdk
                            backgroundImage: NetworkImage(
                                '$profilePicture?timestamp=${Random().nextInt(10000)}'),
                          )
                        : CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 50),
                          ),
                    SizedBox(height: 16),
                    Text(
                      '$userName',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$userEmail',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
