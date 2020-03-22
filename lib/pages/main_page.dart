import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'dart:html';
import 'package:flutter/foundation.dart';
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
  final GlobalKey<_CustomSliverListState> listKey = GlobalKey<_CustomSliverListState>();

  List<JobOffer> jobOfferList;

  String extremeData = '''{
    "1" : {"title":"python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Google", "city" : "Warszawa", "email" : "abc@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "2" : {"title":"Frontend Dev", "salaryMin":"1000.0", "salaryMax":"5100.0", "currency":"PLN", "company" : "Facebook", "city" : "Łódź", "email" : "fb@gmail.com", "phone" : "974637826", "technology" : "HTML",
    "requirements":{"1":{"name":"HTML5", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "3" : {"title":"C++ Backend Dev", "salaryMin":"1000.0", "salaryMax":"7000.0", "currency":"PLN", "company" : "LinkedIN", "city" : "Poznań", "email" : "dc@gmail.com", "phone" : "974637226", "technology" : "C++",
    "requirements":{"1":{"name":"C++", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "4" : {"title":"Python Frontend Dev", "salaryMin":"1000.0", "salaryMax":"5500.0", "currency":"PLN", "company" : "Microsoft", "city" : "Kraków", "email" : "mcsoft@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "5" : {"title":"Java Backend Dev", "salaryMin":"1000.0", "salaryMax":"6000.0", "currency":"PLN", "company" : "Google", "city" : "Wrocław", "email" : "abc@gmail.com", "phone" : "974637826", "technology" : "Java",
    "requirements":{"1":{"name":"Java", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "6" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"15000.0", "currency":"PLN", "company" : "Facebook", "city" : "Legnica", "email" : "fb@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "7" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"4500.0", "currency":"PLN", "company" : "LinkedIN", "city" : "Poznań", "email" : "dc@gmail.com", "phone" : "974637226", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "8" : {"title":"Angular Dev", "salaryMin":"1000.0", "salaryMax":"7000.0", "currency":"PLN", "company" : "Microsoft", "city" : "Gdańsk", "email" : "mcsoft@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Angular", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "9" : {"title":"JavaScript Dev", "salaryMin":"1000.0", "salaryMax":"8000.0", "currency":"PLN", "company" : "Google", "city" : "Warszawa", "email" : "abc@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"JavaScript", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "10" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"9000.0", "currency":"PLN", "company" : "Facebook", "city" : "Warszawa", "email" : "fb@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "11" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"3900.0", "currency":"PLN", "company" : "LinkedIN", "city" : "Katowice", "email" : "dc@gmail.com", "phone" : "974637226", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "12" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5800.0", "currency":"PLN", "company" : "Microsoft", "city" : "Kraków", "email" : "mcsoft@gmail.com", "phone" : "974637826", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"}
  }''';

  AnimationController _animationController;
  bool returnFromDetailPage = false;
  ValueNotifier<bool> stateNotifier;

  Future<String> getData() async {
    this.setState(() {
      jobOfferList = createJobList(json.decode(extremeData));
    });
    return "Success!";
  }

  void customSort({String by:"title"}){
    String normalize(String input){
      return input.toLowerCase()
      .replaceAll('ą', 'a')
      .replaceAll('ć', 'c')
      .replaceAll('ę', 'e')
      .replaceAll('ł', 'l')
      .replaceAll('ń', 'n')
      .replaceAll('ó', 'o')
      .replaceAll('ś', 's')
      .replaceAll('ź', 'z')
      .replaceAll('ż', 'z');}

    if(by == "title"){
    jobOfferList.sort((a,b)=>normalize(a.title).compareTo(normalize(b.title)));
    if(listKey.currentState.buttonsStates[0]==2){
        jobOfferList = new List.from(jobOfferList.reversed);
      }
    }
    else if(by == "salaryMin"){
      jobOfferList.sort((a,b)=>a.salary.salaryMin.compareTo(b.salary.salaryMin));
      if(listKey.currentState.buttonsStates[2]==1){
        jobOfferList = new List.from(jobOfferList.reversed);
      }
    }
    else if(by == "salaryMax"){
      jobOfferList.sort((a,b)=>a.salary.salaryMax.compareTo(b.salary.salaryMax));
      if(listKey.currentState.buttonsStates[2]==1){
        jobOfferList = new List.from(jobOfferList.reversed);
      }
    }
    else if(by == "city"){
      jobOfferList.sort((a,b)=>normalize(a.company.city).compareTo(normalize(b.company.city)));
      if(listKey.currentState.buttonsStates[1]==2){
        jobOfferList = new List.from(jobOfferList.reversed);
      }
    }
  }

  Future<String> sortData(String by) async {
    this.setState(() {
      customSort(by:by);
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: CustomSliverList(
        key: listKey,
        title: widget.title,
        data: jobOfferList,
        onSelected: onSelected,
        customSort: sortData,
      ),
    );
  }
}

class CustomSliverList extends StatefulWidget{
  CustomSliverList({Key key, this.title, this.data, this.onSelected, this.customSort}) : super(key: key);
  final Function(JobOffer) onSelected;
  final Function(String) customSort;
  final String title;
  final List data;

  @override
  _CustomSliverListState createState() => _CustomSliverListState();
}

class _CustomSliverListState extends State<CustomSliverList>{
  final controller = ScrollController();
  double appBarHeight = 45.0;
  double appBarMinHeight = 2.0;
  List<int> buttonsStates = [0,0,0];

  Future<String> setButtonState(int button) async {
    this.setState(() {
      for(int i=0;i<buttonsStates.length;i++){
        if (i==button){
          if (buttonsStates[i]==0){ buttonsStates[i] = 1;}
          else if (buttonsStates[i]==1){ buttonsStates[i] = 2;}
          else if (buttonsStates[i]==2){ buttonsStates[i] = 1;}
        }
        else{ buttonsStates[i] = 0;
      }}});
    return "Success!";
  }

  Widget customIcon(int button){
    if(buttonsStates[button]==0){
      if(button==0){return Icon(Icons.title);}
      else if(button==1){return Icon(Icons.place);}
      else if(button==2){return Icon(Icons.attach_money);}
    }
    else if(buttonsStates[button]==1){return Icon(Icons.arrow_downward);}
    else if(buttonsStates[button]==2){return Icon(Icons.arrow_upward);}
    return Icon(Icons.attach_file);
  }

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
                backgroundColor: Colors.white,
                elevation: 0.0,
                pinned: false,
                expandedHeight: appBarHeight,
                floating: true,
                flexibleSpace: Center(
                  child: Container(
                    height: appBarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 4.0, 2.0),
                            child: FlatButton(  
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              color: Theme.of(context).primaryColor,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.grey[200],
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Tytuł',
                                            // style: Theme.of(context).textTheme.button.copyWith(),
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Open Sans',
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                          ),
                                          customIcon(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 4.0,
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: buttonsStates[0]==0 ? Colors.grey[500] : Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                    child: Container(height: 10.0,),
                                  ),
                                ],
                              ),
                              onPressed: (){setButtonState(0); print('Tytuł'); widget.customSort("title");},
                            ),
                          ),
                        ),
                        
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 2.0),
                            child: FlatButton(  
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              color: Theme.of(context).primaryColor,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.grey[200],
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Lokalizacja',
                                            // style: Theme.of(context).textTheme.button.copyWith(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                          ),
                                          customIcon(1),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 4.0,
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: buttonsStates[1]==0 ? Colors.grey[500] : Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                    child: Container(height: 10.0,),
                                  ),
                                ],
                              ),
                              onPressed: (){setButtonState(1); print('Lokalizacja'); widget.customSort("city");},
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 8.0, 2.0),
                            child: FlatButton(  
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              color: Theme.of(context).primaryColor,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.grey[200],
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Płaca',
                                            // style: Theme.of(context).textTheme.button.copyWith(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                          ),
                                          customIcon(2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 4.0,
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: buttonsStates[2]==0 ? Colors.grey[500] : Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                    child: Container(height: 10.0,),
                                  ),
                                ],
                              ),
                              onPressed: (){setButtonState(2); print('Płaca'); widget.customSort("salaryMax");},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),

              LiveSliverList(
                reAnimateOnVisibility: true,
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
              height: 100,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Job:  ${widget.data.title}"),
                                  Text("City: ${widget.data.company.city}"),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).dividerColor))
                              ),
                            ),
                            Container(
                              child: new Text("Salary: ${widget.data.salary.salaryMin} - ${widget.data.salary.salaryMax}  ${widget.data.salary.currency}"),
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