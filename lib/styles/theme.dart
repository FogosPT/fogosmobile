import 'package:flutter/material.dart';

class FogosTheme {
  static Color _primaryColor = Color(0xffff512f);
  static Color _accentColor = Color(0xfff09819);

  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;
  ThemeData get themeData => _themeData;

  static final ThemeData _themeData = ThemeData(
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      indicatorColor: Colors.white,
      primaryColor: _primaryColor, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor));
}
