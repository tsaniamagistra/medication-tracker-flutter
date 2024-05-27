import 'package:flutter/material.dart';
import 'package:med_tracker/screens/feedback_page.dart';
import 'package:med_tracker/screens/home_page.dart';
import 'package:med_tracker/screens/login_page.dart';
import 'package:med_tracker/screens/logout_page.dart';
import 'package:med_tracker/screens/profile_page.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    'resource://drawable/med_tracker',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic',
        defaultColor: Colors.deepPurple,
        ledColor: Colors.white,
      )
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: SessionManager.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? HomePage() : LoginPage();
          }
        },
      ),
      routes: {
        '/profile': (context) => ProfilePage(),
        '/home': (context) => HomePage(),
        '/feedback': (context) => FeedbackPage(),
        '/logout': (context) => LogoutPage(),
      },
    );
  }
}
