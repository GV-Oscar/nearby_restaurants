import 'package:flutter/material.dart';
import 'package:nearby_restaurants/helpers/helpers.dart';

class Labels extends StatelessWidget {
  final Widget page;
  final String titulo;
  final String subTitulo;

  const Labels({
    Key? key,
    required this.page,
    required this.titulo,
    required this.subTitulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(this.titulo,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300)),
          SizedBox(height: 10),
          GestureDetector(
            child: Text(this.subTitulo,
                style: TextStyle(
                    color: Colors.lime,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushReplacement(context, navegarFadeIn(context, page));
            },
          )
        ],
      ),
    );
  }
}
