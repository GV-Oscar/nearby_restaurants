import 'package:flutter/material.dart';
import 'package:nearby_restaurants/providers/session_provider.dart';
import 'package:nearby_restaurants/settings/user_preferences.dart';
import 'package:nearby_restaurants/theme/my_color.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final _pref = UserPreferences();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primary,
        elevation: 2,
        title: Text('Historial de establecimientos'),
        actions: [],
      ),
      body: ListView.builder(
          itemCount: sessionProvider.sites.length,
          itemBuilder: (_, i) {
            return _getItem(context, sessionProvider.sites[i]);
          }),
    );
  }
}

ListTile _getItem(BuildContext context, String query) {
  return ListTile(
    title: Text(
      '$query',
      style: TextStyle(color: MyColor.accent),
    ),
    //subtitle: Text('Descarga tus videos'),
    leading: Icon(
      Icons.history,
      color: MyColor.accent,
    ),
    onTap: () {},
  );
}
