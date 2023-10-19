import 'package:shared_preferences/shared_preferences.dart';

class AddData {
  SharedPreferences? _prefs;

  Future<void> initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void insertCustomer(String email, String password) async {
    if (_prefs == null) {
      // Ensure SharedPreferences is initialized before using it.
      await initializeSharedPreferences();
    }

    await _prefs!.setString('email', email);
    await _prefs!.setString('password', password);
  }
  void insertTechnician(String email, String password) async {
    if (_prefs == null) {
      // Ensure SharedPreferences is initialized before using it.
      await initializeSharedPreferences();
    }

    await _prefs!.setString('email', email);
    await _prefs!.setString('password', password);
  }
  Future<Map<String, String>> getCredentials() async {
    if (_prefs == null) {
      // Ensure SharedPreferences is initialized before using it.
      await initializeSharedPreferences();
    }

    String? email = _prefs?.getString('email') ?? '';
    String? password = _prefs?.getString('password') ?? '';

    return {'email': email ?? '', 'password': password ?? ''};
  }
void clearData() async {
  if (_prefs == null) {
    // Ensure SharedPreferences is initialized before using it.
    await initializeSharedPreferences();
  }
await _prefs?.clear();
}
}//end class
