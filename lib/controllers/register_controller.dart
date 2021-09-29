import 'package:nearby_restaurants/settings/user_preferences.dart';

class RegisterController {
  UserPreferences? _prefs;

  RegisterController() {
    _prefs = UserPreferences();
  }

  bool checkSession() => (_prefs?.email != '') ? true : false;

  Future<bool> registerUser(String name, String email, String password) async {
    bool result = false;
    _prefs?.name = name;
    _prefs?.email = email;
    _prefs?.password = password;
    _prefs?.isLogin = true;
    return result;
  }
}
