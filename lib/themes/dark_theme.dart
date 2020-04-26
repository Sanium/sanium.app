import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:sanium_app/themes/theme_options.dart';


AppTheme customDarkTheme() {
  return AppTheme(
    id: "dark_theme",
    description: "dark",
    data: ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      accentColor: Colors.amber,
      textSelectionColor: Colors.blue[400],
      appBarTheme: AppBarTheme(elevation: 0),
      textTheme: TextTheme(title: TextStyle(color: Colors.white), body1:TextStyle(color: Colors.grey)),
    ),
    options: CustomThemeOptions(
      surfaceColor: Color(0xFF222222),
      mainTextColor: Colors.white,
      secondaryTextColor: Colors.grey,
      defaultIconColor: Colors.white60,
      accentIconColor: Colors.amber,
      backgroundColor: Color(0xFF181613),
      defaultDetailColor: Colors.grey[900]
    ),
  );
}