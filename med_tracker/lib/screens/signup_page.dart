import 'package:flutter/material.dart';
import 'package:med_tracker/models/user.dart';
import 'package:med_tracker/screens/login_page.dart';
import 'package:med_tracker/api/data_source.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _nameField(),
            SizedBox(height: 20),
            _emailField(),
            SizedBox(height: 20),
            _passwordField(),
            SizedBox(height: 20),
            _signupButton(context),
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      onChanged: (value) => name = value,
      decoration: InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      onChanged: (value) => email = value,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      onChanged: (value) => password = value,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _signupButton(context) {
    return ElevatedButton(
      onPressed: () async {
        String text = "";
        if (await signupNewUser(email, password, name)) {
          setState(() {
            text = "Signup is successful. Please login";
            isSignupSuccess = true;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          setState(() {
            text = "Signup failed";
            isSignupSuccess = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            backgroundColor: (isSignupSuccess) ? Colors.green : Colors.red,
          ),
        );
      },
      child: Text(
        'Signup',
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

  User user = User.fromJson(
      await MedTrackerDataSource.instance.createUser(requestBody));

  return (user.email != null && user.password != null);
}
