import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:sanium_app/pages/job_offer_page.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),

        child: new AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
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
      body: CustomSliverList(
        title: widget.title,
        data: data,
      ),
    );
  }
}

class CustomSliverList extends StatefulWidget{
  CustomSliverList({Key key, this.title, this.data}) : super(key: key);

  final String title;
  final Map data;

  @override
  _CustomSliverListState createState() => _CustomSliverListState();
}

class _CustomSliverListState extends State<CustomSliverList>{
  final controller = ScrollController();
  double appBarHeight = 30.0;
  double appBarMinHeight = 2.0;

  Widget _buildCard(int index) => Builder(
    builder: (context) => Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Material(
          child: Center(
            child: MenuListTile(
              id: index,
              description: widget.data[index.toString()],
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.red[100],
          showLeading: false,
          showTrailing: false,
          child: CustomScrollView(
            controller: controller,
            slivers: <Widget>[
              SliverAppBar(
                leading: new Container(),
                backgroundColor: Colors.grey[400],
                elevation: 10.0,
                pinned: true,
                expandedHeight: appBarHeight,
                bottom: PreferredSize(                  
                  preferredSize: Size.fromHeight(appBarMinHeight),      
                  child: Container(),                           
                ),
                floating: true,
                flexibleSpace: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.4,
                          0.7,
                          0.8
                        ],
                        colors: <Color>[
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.38),
                          Theme.of(context).primaryColor.withOpacity(0.24),
                        ]
                      )          
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 0.0, 1.0, 1.0),
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.grey[200],
                              child: Text(
                                'Lokalizacja',
                                // style: TextStyle(
                                //   color: Colors.grey[700],
                                // ),
                              ),
                              onPressed: (){print('Lokalizacja');},
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 1.0),
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.grey[200],
                              child: Text(
                                'Tech',
                                style: Theme.of(context).textTheme.button.copyWith(),
                                // style: TextStyle(
                                //   color: Theme.of(context).primaryColorDark,
                                //   // color: Colors.grey[700],
                                // ),
                              ),
                              onPressed: (){print('Tech');},
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(1.0, 0.0, 2.0, 1.0),
                            child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.grey[200],
                              child: Text(
                                'Płaca',
                                // style: TextStyle(
                                //   color: Colors.grey[700],
                                // ),
                              ),
                              onPressed: (){print('Płaca');},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),

              LiveSliverList(
                // reAnimateOnVisibility: true,
                controller: controller,
                showItemInterval: Duration(milliseconds: 200),
                showItemDuration: Duration(milliseconds: 1000),
                itemCount: widget.data.length.toInt(),
                itemBuilder: _buildAnimatedItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//custom look of list tile
class MenuListTile extends StatelessWidget{
  const MenuListTile({
    this.id,
    this.thumbnail,
    this.description,
    this.salary,
    this.viewCount,
  });

  final int id;
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
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) {
                  return JobDatail(id: id, img:thumbnail, data: description);
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: Hero(
                      tag: id.toString(),
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