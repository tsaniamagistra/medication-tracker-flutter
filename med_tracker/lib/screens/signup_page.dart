import 'package:flutter/material.dart';
import 'package:med_tracker/models/user.dart';
import 'package:med_tracker/screens/login_page.dart';
import 'package:med_tracker/api/data_source.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String email = "";
  String password = "";
  String name = "";
  bool isSignupSuccess = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _nameField(),
                _emailField(),
                _passwordField(),
                _signupButton(context),
              ],
            ),
          )
      ),
    );
  }

  Widget _nameField() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          onChanged: (value) => name = value,
          decoration: InputDecoration(
            labelText: 'Email',
          ),
        ));
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
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
        ));
  }

  Widget _signupButton(context) {
    return ElevatedButton(
      onPressed: () async {
        String text = "";
        if (await checkCredentials(email, password)) {
          setState(() {
            text = "Login Berhasil. Silakan Login";
            isSignupSuccess = true;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          setState(() {
            text = "Login Gagal";
            isSignupSuccess = false;
          });
        }

        SnackBar snackBar = SnackBar(
          content: Text(text),
          backgroundColor: (isSignupSuccess) ? Colors.green : Colors.red,
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

Future<bool> signupNewUser(String email, String password, String name) async {
  if (email.isEmpty || password.isEmpty || name.isEmpty) {
    return false;
  }

  Map<String, dynamic> requestBody = {
    'email': email,
    'password': password,
    'name': name,
  };

  User user = User.fromJson(await MedTrackerDataSource.instance.createUser(requestBody));

  if (user.email != null && user.password != null) {
    return true;
  } else {
    return false;
  }
}

