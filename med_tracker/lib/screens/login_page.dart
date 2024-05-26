import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:med_tracker/models/user.dart';
import 'package:med_tracker/screens/home_page.dart';
import 'package:med_tracker/screens/signup_page.dart';
import 'package:med_tracker/services/encryption.dart';
import 'package:med_tracker/services/session_manager.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:email_validator/email_validator.dart';

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
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/pharmacy.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),
                    Text(
                      'Welcome to Med Tracker!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    _emailField(),
                    _passwordField(),
                    SizedBox(height: 10),
                    _signupOption(context),
                    SizedBox(height: 10),
                    _loginButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
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
        if (email.isEmpty || password.isEmpty) {
          setState(() {
            text = "Please fill in all fields";
            isLoginSuccess = false;
          });
        } else if (!EmailValidator.validate(email)) {
          setState(() {
            text = "Invalid email format";
            isLoginSuccess = false;
          });
        } else {
          // hash password sebelum membandingkan dengan yang tersimpan di database
          String hashedPassword = Encryption.hashPassword(password);

          if (await checkCredentials(email, hashedPassword)) {
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
              text = "Invalid email or password";
              isLoginSuccess = false;
            });
          }
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

  Widget _signupOption(context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      },
      child: Text(
        'Don\'t have an account? Sign Up',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
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
