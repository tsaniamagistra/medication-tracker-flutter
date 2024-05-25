import 'package:flutter/material.dart';
import 'package:med_tracker/models/user.dart';
import 'package:med_tracker/screens/home_page.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:med_tracker/api/data_source.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  bool isLoginSuccess = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emailField(),
                _passwordField(),
                _loginButton(context),
              ],
            ),
          )
      ),
    );
  }

  Widget _emailField() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          onChanged: (value) => email = value,
          decoration: InputDecoration(
            labelText: 'Email',
          ),
        ));
  }

  Widget _passwordField() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          onChanged: (value) => password = value,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
        ));
  }

  Widget _loginButton(context) {
    return ElevatedButton(
      onPressed: () async {
        String text = "";
        if (await checkCredentials(email, password)) {
          await SessionManager.setLoggedIn(true);
          setState(() {
            text = "Login Success";
            isLoginSuccess = true;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          setState(() {
            text = "Login Failed";
            isLoginSuccess = false;
          });
        }

        SnackBar snackBar = SnackBar(
          content: Text(text),
          backgroundColor: (isLoginSuccess) ? Colors.green : Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Text(
        'Login',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}

Future<bool> checkCredentials(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    return false;
  }

  User user = User.fromJson(await MedTrackerDataSource.instance.getUserByEmail(email));

  if (user.password == password) {
    await SessionManager.setUserId(user.id!);
    return true;
  } else {
    return false;
  }
}
