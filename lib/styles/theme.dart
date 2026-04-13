import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FogosTheme {
  static Color _primaryColor = Color(0xffF25C54);
  static Color _accentColor = Color(0xffF7B267);

  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;
  ThemeData get themeData => _themeData;

  static final ThemeData _themeData = ThemeData(
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      indicatorColor: Colors.white,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        secondary: _accentColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.unboundedTextTheme(),
      primaryTextTheme: GoogleFonts.unboundedTextTheme());
}
