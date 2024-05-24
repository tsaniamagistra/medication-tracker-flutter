import 'package:flutter/material.dart';
import 'package:med_tracker/screens/home_page.dart';
import 'package:med_tracker/screens/login_page.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:med_tracker/widgets/bottom_navbar.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(selectedIndex: 3),
      body: AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await SessionManager.logout(); // Panggil fungsi logout dari session_manager.dart
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Pindah ke halaman login dan hapus semua halaman di belakangnya
                    (route) => false,
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}