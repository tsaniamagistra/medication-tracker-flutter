import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final String _isLoggedInKey = 'isLoggedIn';
  static final String _userIdKey = 'userId';
  static final String _userNameKey = 'name';
  static final String _userEmailKey = 'email';
  static final String _profilePictureKey = 'profilePicture';

  // Set login status
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Get login status
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Set user info
  static Future<void> setUserInfo(String userId, String name, String email, String profilePicture) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_profilePictureKey, profilePicture);
  }

  // Get user id
  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Get user name
  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Get profile picture
  static Future<String?> getProfilePicture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilePictureKey);
  }

  // Clear all session data
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
