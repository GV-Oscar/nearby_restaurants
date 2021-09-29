import 'package:flutter/material.dart';

import 'package:nearby_restaurants/pages/loading_page.dart';
import 'package:nearby_restaurants/providers/session_provider.dart';
import 'package:nearby_restaurants/routes/routes.dart';
import 'package:nearby_restaurants/settings/user_preferences.dart';
import 'package:nearby_restaurants/theme/my_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = new UserPreferences();
  await preferences.initUserPreferences();

  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider(),)
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurantes',
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
      // initialRoute: 'find',
      routes: appRoutes,
      theme: MyTheme.dark(context),
    );
  }
}
