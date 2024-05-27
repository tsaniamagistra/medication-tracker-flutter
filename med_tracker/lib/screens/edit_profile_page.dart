import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_tracker/api/data_source.dart';
import 'package:med_tracker/screens/profile_page.dart';
import 'package:med_tracker/services/encryption.dart';
import 'package:email_validator/email_validator.dart';


class EditProfilePage extends StatefulWidget {
  final String userId;

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _newProfilePicture;
  String? _profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await MedTrackerDataSource.instance.getUserById(widget.userId);
      setState(() {
        _nameController.text = user['name'];
        _emailController.text = user['email'];
        _profilePicture = user['profilePicture'];
      });
    } catch (e) {
      print('Failed to load user data: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newProfilePicture = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      Map<String, dynamic> requestBody = {};

      if (password.isNotEmpty) {
        requestBody['password'] = Encryption.hashPassword(password);
      }

      if (_newProfilePicture != null) {
        final bytes = await _newProfilePicture!.readAsBytes();
        requestBody['profilePicture'] = base64Encode(bytes);
      }

      if (name.isNotEmpty) {
        requestBody['name'] = name;
      }

      if (email.isNotEmpty) {
        requestBody['email'] = email;
      }

      print('Request Payload: $requestBody');

      try {
        final response = await MedTrackerDataSource.instance.updateUserById(widget.userId, requestBody);

        if (response['error'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: ${response['message']}')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: _newProfilePicture != null
                        ? Image.file(_newProfilePicture!, width: 100, height: 100, fit: BoxFit.cover)
                        : (_profilePicture != null
                        ? Image.network(_profilePicture!, width: 100, height: 100, fit: BoxFit.cover)
                        : Icon(Icons.account_circle, size: 100)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
