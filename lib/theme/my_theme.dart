import 'package:flutter/material.dart';

class MyTheme {
  /// Tema oscuro
  static ThemeData dark(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      visualDensity: VisualDensity.compact,
      primaryColorBrightness: Brightness.dark,
      primarySwatch: Colors.lime,
      primaryColor: Color(0xff27292d),
      primaryColorLight: Colors.lime,
      primaryColorDark: Colors.lime,
      accentColor: Color(0xffcddc39),
      canvasColor: Color(0xff27292d),
      scaffoldBackgroundColor: Color(0xff27292d),
      hoverColor: Colors.lime,
      unselectedWidgetColor: Color(0xffffffff),
      disabledColor: Colors.grey,
      errorColor: Colors.pink,
      toggleableActiveColor: Colors.lime,
    );
  }
}
