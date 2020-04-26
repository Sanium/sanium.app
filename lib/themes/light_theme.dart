import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:sanium_app/themes/theme_options.dart';


AppTheme customLightTheme() {
  return AppTheme(
    id: "light_theme",
    description: "Light Color Scheme",
    data: ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      accentColor: Colors.amber,
      textSelectionColor: Colors.blue[200],
      appBarTheme: AppBarTheme(elevation: 0),
    ),
    options: CustomThemeOptions(
      surfaceColor: Colors.grey[350],
      mainTextColor: Colors.black,
      secondaryTextColor: Colors.grey[800],
      backgroundColor: Colors.blueGrey[50],
      defaultIconColor: Colors.grey[800],
      accentIconColor: Colors.amber[700],
      defaultDetailColor: Colors.grey[300]
    ),
  );
}