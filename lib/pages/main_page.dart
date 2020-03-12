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



//custom look of list tile
class MenuListTile extends StatelessWidget{
  const MenuListTile({
    this.thumbnail,
    this.description,
    this.salary,
    this.viewCount,
  });

  final Widget thumbnail;
  final Map description;
  final String salary;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
      child: Material(
        elevation: 4.0,
         borderRadius: BorderRadius.circular(10.0),
        child: InkWell (
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                     child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: thumbnail,
                        
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: new Text("Job:  ${description['firma']}"),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(bottom: BorderSide(width: 2.0, color: Theme.of(context).dividerColor))
                              ),
                            ),
                            Container(
                              child: new Text("Salary: ${salary*4}"),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),

                          ],
                        ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}