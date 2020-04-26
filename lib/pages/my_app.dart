import 'package:flutter/material.dart';
import 'package:sanium_app/themes/dark_theme.dart';
import 'package:sanium_app/themes/light_theme.dart';
import 'package:sanium_app/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

import 'main_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      defaultThemeId: 'dark_theme', 
      themes: [
        customLightTheme(),
        customDarkTheme(),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SANIUM',
        color: Colors.black,
        home: ThemeConsumer(
          child: HomePage(title: 'S A N I U M'),
        ),
      ),
    );
  }
}
