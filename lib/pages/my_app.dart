import 'package:flutter/material.dart';

import 'main_page.dart';



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      color: Colors.black,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        primaryColorDark: Colors.black,
        accentColor: Colors.amber,
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Colors.amber,
        primaryColor: Colors.black,
        primaryColorDark: Colors.white,
        appBarTheme: AppBarTheme(elevation: 0),
        textTheme: TextTheme(title: TextStyle(color: Colors.white),),
      ),
      // themeMode: ThemeMode.dark,
       themeMode: ThemeMode.light,
      home: HomePage(title: 'Sanium'),
    );
  }
}
