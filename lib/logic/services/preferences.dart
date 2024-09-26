import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  //For saving user email and password using shared preferences
  static Future<void> saveUserDetails(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("email", email);
    await pref.setString("password", password);
  }

  //For getting user email and password from shared preferences
  static Future<Map<String, dynamic>> fetchUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? email = pref.getString("email");
    String? password = pref.getString("password");
    return {
      "email": email,
      "password": password,
    };
  }

  static Future<String?> fetchUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? email = pref.getString("email");
    return email;
  }

  //For clearing data form sharedpreferences
  static Future<void> clear() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
