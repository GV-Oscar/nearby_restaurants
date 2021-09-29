import 'package:nearby_restaurants/settings/user_preferences.dart';

class LoginController {
  UserPreferences? _prefs;

  LoginController() {
    _prefs = UserPreferences();
  }

  bool checkSession() => (_prefs?.email != '') ? true : false;

  bool checkLogin(String email, String password) {
    bool check =
        (email == _prefs?.email && password == _prefs?.password) ? true : false;
    if (check) {
      _prefs?.isLogin = check;
    }
    return check;
  }

  void logout() {
    _prefs?.isLogin = false;
  }
}
