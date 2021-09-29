import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_restaurants/models/site.dart';
import 'package:nearby_restaurants/settings/user_preferences.dart';

class SessionProvider extends ChangeNotifier {
  Position? _currentLocation;
  bool _isLocation = false;
  Site? _currentSite;
  List<String> _sites = [];
  UserPreferences _prefs = UserPreferences();

  SessionProvider() {
    _sites = _prefs.sites;
  }

  Position get currentLocation => _currentLocation!;
  bool get isLocation => _isLocation;
  Site? get currentSite => _currentSite;

  void determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _updateIsLocation(false);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updateIsLocation(false);
        return Future.error('Se niegan los permisos de ubicación');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updateIsLocation(false);
      return Future.error(
          'Los permisos de ubicación se niegan permanentemente, no podemos solicitar permisos.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    print('POSICION :: $position');
    if (position != null) {
      _updateCurrentLocation(position);
      _updateIsLocation(true);
    }
  }

  void _updateCurrentLocation(Position position) {
    this._currentLocation = position;
    notifyListeners();
  }

  void _updateIsLocation(bool sw) {
    this._isLocation = sw;
    notifyListeners();
  }

  void updateCurrentSite(Site site) {
    this._currentSite = site;
    notifyListeners();
  }

  void addHistory(String query) {
    _prefs.addSite(query);
    _sites.add(query);
    notifyListeners();
  }

  List<String> get sites => _sites;
}
