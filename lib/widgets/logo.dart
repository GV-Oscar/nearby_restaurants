
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final bool isSubtitle;
  final String subtitle;
  final String assetName;

  const Logo(
      {Key? key,
        required this.assetName,
        this.isSubtitle = false,
        this.subtitle = ''
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Image(image: AssetImage(assetName)),
            _showSubtitle(),
          ],
        ),
      ),
    );
  }

  Widget _showSubtitle() {
    if (isSubtitle && subtitle.isNotEmpty) {
      return Column(
        children: [
          SizedBox(height: 10),
          Text(subtitle,
              style: TextStyle(
                fontSize: 30,
              ))
        ],
      );
    }

    return Container();
  }
}
