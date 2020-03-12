import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(35.0),

      child: new AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.grey[800]
          ),
        ),
      ),
    ),

    drawer: Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
    body: Container(),
  );
  }
}