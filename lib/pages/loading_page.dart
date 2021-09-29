import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_restaurants/helpers/helpers.dart';
import 'package:nearby_restaurants/pages/find_page.dart';
import 'package:nearby_restaurants/pages/gps_page.dart';
import 'package:nearby_restaurants/pages/login_page.dart';
import 'package:nearby_restaurants/providers/session_provider.dart';
import 'package:nearby_restaurants/settings/user_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(context, navegarFadeIn(context, FindPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context, sessionProvider),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            return Center(child: Text(snapshot.data));
          } else {
            return Center(child: CircularProgressIndicator(strokeWidth: 2));
          }
        },
      ),
    );
  }

  /// Comprobar permiso de gps y ubicacion
  Future checkGpsYLocation(
      BuildContext context, SessionProvider sessionProvider) async {
    // PermisoGPS
    final permisoGPS = await Permission.location.isGranted;
    // GPS está activo
    final gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (permisoGPS && gpsActivo) {
      sessionProvider.determinePosition();
      final _prefs = UserPreferences();

      if (!_prefs.isLogin) {
        //Navigator.pushReplacementNamed(context, 'login');
        Navigator.pushReplacement(context, navegarFadeIn(context, LoginPage()));
        return '';
      }
      Navigator.pushReplacement(context, navegarFadeIn(context, FindPage()));
      return '';
    } else if (!permisoGPS) {
      Navigator.pushReplacement(context, navegarFadeIn(context, GpsPage()));
      return 'Es necesario el permiso de GPS';
    } else {
      return 'Active el GPS';
    }
  }
}
