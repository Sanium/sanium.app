import 'package:flutter/material.dart';

import 'main_page.dart';


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        accentColor: Colors.amber,
      ),
      home: HomePage(title: 'Sanium'),
    );
  }
}
