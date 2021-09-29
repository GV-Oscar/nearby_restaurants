import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = new UserPreferences._();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._();

  /// Preferencias compartidas.
  SharedPreferences? _preferences;

  initUserPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  set isLogin(bool isLogin) => _preferences?.setBool('isLogin', isLogin);
  bool get isLogin => _preferences?.getBool('isLogin') ?? false;

  /// Establecer correo
  set email(String email) => _preferences!.setString('email', email);

  /// Obtener correo
  String get email => _preferences?.getString('email') ?? '';

  /// Establecer clave
  set password(String password) =>
      _preferences?.setString('password', password);

  /// Obtener clave
  String get password => _preferences?.getString('password') ?? '';

  /// Establecer clave
  set name(String name) => _preferences?.setString('name', name);

  /// Obtener clave
  String get name => _preferences?.getString('name') ?? '';

  // set sites(List<String> sites) => _preferences?.setStringList('sites', sites);

  void addSite(String site) async {
    final misSites = sites;
    misSites.add(site);
    await _preferences!.setStringList('sites', misSites);
  }

  // List<String> get sites =>      _preferences?.getStringList('sites')?.toList() ?? [];

  List<String> get sites => _preferences?.getStringList('sites') ?? [];
}
