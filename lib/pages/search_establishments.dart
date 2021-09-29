import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nearby_restaurants/controllers/history_controller.dart';
import 'package:nearby_restaurants/controllers/login_controller.dart';
import 'package:nearby_restaurants/models/site.dart';
import 'package:nearby_restaurants/providers/session_provider.dart';
import 'package:nearby_restaurants/theme/my_color.dart';

import 'package:nearby_restaurants/widgets/flut_place_autocomplete.dart';
import 'package:nearby_restaurants/widgets/logo.dart';
import 'package:provider/provider.dart';

class SearchEstablishmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginCtrl = LoginController();
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primary,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, 'history'),
              icon: Icon(Icons.history)),
          SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                loginCtrl.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(bottom: 200),
          child: Column(
            children: [
              Logo(
                assetName: 'assets/logo.png',
                isSubtitle: true,
                subtitle: 'Estas en ${sessionProvider.currentSite?.address}',
              ),
              _Form()
            ],
          ),
        ),
      )),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final cityCtrl = TextEditingController();
  TextEditingController autoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          _placesAutoCompleteTextField(sessionProvider),
        ],
      ),
    );
  }

  _placesAutoCompleteTextField(SessionProvider sessionProvider) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: MyColor.primaryLight,
          borderRadius: BorderRadius.circular(30),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 5)
          ]),
      child: FlutPlaceAutocomplete(
          isCity: false,
          textEditingController: autoController,
          inputDecoration: InputDecoration(
              prefixIcon: Icon(Icons.location_city_outlined),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: 'Busca establecimientos'),
          // debounceTime: 8000,
          debounceTime: 1000,
          onItemClickListener: (Site prediction) {
            print('SITIO:: $prediction');
            sessionProvider.addHistory(prediction.address);
            Navigator.pushNamed(context, 'history');
            // profile.location = prediction;
            // controller.text = prediction.address;
            // autoController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.address.length));
          }
          // default 600 ms ,
          ),
    );
  }
}
