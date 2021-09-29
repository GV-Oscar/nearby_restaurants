import 'package:flutter/material.dart';

import 'package:nearby_restaurants/pages/find_page.dart';
import 'package:nearby_restaurants/pages/history_page.dart';
import 'package:nearby_restaurants/pages/home_page.dart';
import 'package:nearby_restaurants/pages/loading_page.dart';
import 'package:nearby_restaurants/pages/login_page.dart';
import 'package:nearby_restaurants/pages/register_page.dart';
import 'package:nearby_restaurants/pages/search_establishments.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'find'      : ( _ ) => FindPage(),
  'history'   : ( _ ) => HistoryPage(),
  'home'      : ( _ ) => HomePage(),
  'loading'   : ( _ ) => LoadingPage(),
  'login'     : ( _ ) => LoginPage(),
  'register'  : ( _ ) => RegisterPage(),
  'search'    : ( _ ) => SearchEstablishmentsPage(),

};