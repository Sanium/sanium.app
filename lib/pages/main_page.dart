import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:sanium_app/data/JobOffer.dart';
import 'package:sanium_app/pages/job_offer_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';

class Data{
  int id;
  Widget img;
  Map data;

  Data(int id, Widget thumbnail, Map description){
    this.id = id;
    this.img = thumbnail;
    this.data = description;
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<JobOffer> jobOfferList;
  Map<String, dynamic> data;

  String extremeData = '''{
    "1" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Google", "city" : "Warsaw", "email" : "abc@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "2" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Facebook", "city" : "Warsaw", "email" : "fb@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "3" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "LinkedIN", "city" : "Poznan", "email" : "dc@gmail.com", "phone" : "974637226", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "4" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Microsoft", "city" : "Krakow", "email" : "mcsoft@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "5" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Google", "city" : "Warsaw", "email" : "abc@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "6" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Facebook", "city" : "Warsaw", "email" : "fb@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "7" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "LinkedIN", "city" : "Poznan", "email" : "dc@gmail.com", "phone" : "974637226", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "8" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Microsoft", "city" : "Krakow", "email" : "mcsoft@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "9" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Google", "city" : "Warsaw", "email" : "abc@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "10" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Facebook", "city" : "Warsaw", "email" : "fb@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "11" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "LinkedIN", "city" : "Poznan", "email" : "dc@gmail.com", "phone" : "974637226", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "12" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Microsoft", "city" : "Krakow", "email" : "mcsoft@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"}
  }''';


  AnimationController _animationController;
  bool returnFromDetailPage = false;
  ValueNotifier<bool> stateNotifier;

  // Future<String> getData() async {
  //   this.setState(() {
  //     data = json.decode(
  //       '''{
  //       "1" : {"company" : "Google"},
  //       "2" : {"company" : "Facebook"},
  //       "3" : {"company" : "Twitter"},
  //       "4" : {"company" : "Google"},
  //       "5" : {"company" : "Facebook"}, 
  //       "6": {"company" : "Twitter"}, 
  //       "7" : {"company" : "Google"}, 
  //       "8": {"company" : "Facebook"}, 
  //       "9" : {"company" : "Twitter"},  
  //       "10": {"company" : "Facebook"}, 
  //       "11" : {"company" : "Twitter"} }''');
  //   });
  //   return "Success!";
  // }

    Future<String> getData() async {
    this.setState(() {
      data = json.decode(extremeData);
      jobOfferList = createJobList(data);
    });
    return "Success!";
  }

  @override
  void initState(){
    this.getData();
    super.initState();
    _initAnimationController();

  }
  
  void _initAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 550),
    )..addListener(() {
        setState(() {});
      });

    stateNotifier = ValueNotifier(returnFromDetailPage)
      ..addListener(() {
        if (stateNotifier.value) {
          _animationController.reverse(from: 1.0);
          stateNotifier.value = false;
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    stateNotifier.dispose();
    super.dispose();
  }

 void onSelected(JobOffer tempData) async {
    _animationController.forward(from: 0.0);
    stateNotifier.value = await Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return JobDetailPage(id: tempData.id, img: tempData.img, data: tempData);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          leading: IconButton(
            hoverColor: Colors.black38,
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress: _animationController,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
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
        data: jobOfferList,
        onSelected: onSelected,
      ),
    );
  }
}

class CustomSliverList extends StatefulWidget{
  CustomSliverList({Key key, this.title, this.data, this.onSelected}) : super(key: key);
  final Function(JobOffer) onSelected;
  final String title;
  final List data;

  @override
  _CustomSliverListState createState() => _CustomSliverListState();
}

class _CustomSliverListState extends State<CustomSliverList>{
  final controller = ScrollController();
  double appBarHeight = 50.0;
  double appBarMinHeight = 2.0;

  Widget _buildCard(int index) => Builder(
    builder: (context) => Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Material(
          child: Center(
            child: MenuListTile(
              id: index,
              data: widget.data[index-1],
              thumbnail: Icon(Icons.android),
              onSelected: widget.onSelected,
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
                backgroundColor: Colors.grey[300],
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
                            padding: const EdgeInsets.fromLTRB(2.0, 0.0, 1.0, 0.0),
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
                            padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
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
                            padding: const EdgeInsets.fromLTRB(1.0, 0.0, 2.0, 0.0),
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
                showItemDuration: Duration(milliseconds: 800),
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
class MenuListTile extends StatefulWidget{
  const MenuListTile({
    Key key,
    this.id,
    this.thumbnail,
    this.data,
    this.onSelected
  }) : super(key: key);

  final Function(JobOffer) onSelected;
  final int id;
  final Widget thumbnail;
  final JobOffer data;

  @override
  _MenuListTileState createState() => _MenuListTileState();
}

class _MenuListTileState extends State<MenuListTile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell (
          onTap: () => widget.onSelected(widget.data),
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
                      tag: widget.id.toString(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(width: 1.5, color: Theme.of(context).accentColor)
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: widget.thumbnail,
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
                              child: new Text("Job:  ${widget.data.company.name}"),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).dividerColor))
                              ),
                            ),
                            Container(
                              child: new Text("Salary: ${widget.data.salary.salaryMin} - ${widget.data.salary.salaryMax}"),
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