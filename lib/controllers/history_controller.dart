import 'package:nearby_restaurants/settings/user_preferences.dart';

class HistoryController {
  UserPreferences? _prefs;

  LoginController() {
    _prefs = UserPreferences();
  }

  addSearch(String query){
    print('SITES:: ${_prefs?.sites.toString()}');
    _prefs?.addSite(query);
  }
}
