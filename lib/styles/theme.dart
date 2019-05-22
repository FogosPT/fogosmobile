import 'package:flutter/material.dart';

class FogosTheme {
  static Color _primaryColor = Color(0xff512f);
  static Color _accentColor = Color(0xf09819);

  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;
  ThemeData get themeData => _themeData;

  static final ThemeData _themeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      primaryColorBrightness: Brightness.dark,
      accentColor: _accentColor,
      accentColorBrightness: Brightness.dark);
}
