import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> data;

  Future<String> getData() async {
    this.setState(() {
      data = json.decode('''{"1" : {"firma" : "Google"}, "2" : {"firma" : "Facebook"}, "3" : {"firma" : "Twitter"}, "4" : {"firma" : "Google"}, "5" : {"firma" : "Facebook"}, "6": {"firma" : "Twitter"}, "7" : {"firma" : "Google"}, "8": {"firma" : "Facebook"}, "9" : {"firma" : "Twitter"},  "10": {"firma" : "Facebook"}, "11" : {"firma" : "Twitter"} }''');
    });
    return "Success!";
  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildCard(int index) => Builder(
      builder: (context) => Container(
        width: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Material(
            // color: Colors.lime,
            child: Center(
              child: MenuListTile(
                description: data[index.toString()],
                salary: index.toString(),
                thumbnail: Icon(Icons.android),
              ),
            ),
          ),
        ),
      ),
    );

    Widget _buildAnimatedItem(
      BuildContext context,
      int index,
      Animation<double> animation, 
    ) => FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -0.1),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: _buildCard(index+1),
        ),
      ),
    );

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
    body: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        child: LiveList(
          reAnimateOnVisibility: true,
          showItemInterval: Duration(milliseconds: 200),
          showItemDuration: Duration(milliseconds: 1000),
          scrollDirection: Axis.vertical,
          itemCount: data.length.toInt(),
          itemBuilder: _buildAnimatedItem,
        ),
      ),
    ),

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