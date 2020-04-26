import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:sanium_app/pages/info_page.dart';
import 'package:sanium_app/pages/map_page.dart';
import 'package:sanium_app/themes/theme_options.dart';
import 'package:sanium_app/tools/JobOffer.dart';
import 'package:sanium_app/pages/job_offer_page.dart';
import 'package:sanium_app/pages/filter_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';
import 'package:sanium_app/tools/drawer.dart';
import 'package:sanium_app/tools/rotate_trans.dart';
import 'package:theme_provider/theme_provider.dart';

import 'bookmark_page.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<_CustomSliverListState> listKey = GlobalKey<_CustomSliverListState>();

  Map<String,dynamic> filters = new Map(); //? lista filtrów
  JobOfferList jobOfferList = new JobOfferList();

  AnimationController _animationController;
  AnimationController _refreshController;
  Animation<double> _refreshAnimation;
  bool returnFromDetailPage = false;
  ValueNotifier<bool> stateNotifier;

  // bool isDarkMode;

  String nextPage ='';

  String extremeData = '''{
    "1" : {"title":"Python Backend Dev", "salaryMin":"1000.0", "salaryMax":"5000.0", "currency":"PLN", "company" : "Google", "city" : "Warszawa", "email" : "abc@gmail.com", "phone" : "www.praca.pl", "technology" : "Python",
    "requirements":{"1":{"name":"Python 3", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "2" : {"title":"Frontend Dev", "salaryMin":"1000.0", "salaryMax":"5100.0", "currency":"PLN", "company" : "Facebook", "city" : "Łódź", "email" : "fb@gmail.com", "phone" : "www.praca.pl", "technology" : "HTML",
    "requirements":{"1":{"name":"HTML5", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"},
    "3" : {"title":"C++ Backend Dev", "salaryMin":"1000.0", "salaryMax":"7000.0", "currency":"PLN", "company" : "LinkedIN", "city" : "Poznań", "email" : "dc@gmail.com", "phone" : "www.praca.pl", "technology" : "C++",
    "requirements":{"1":{"name":"C++", "level":"4"}, "2":{"name":"Unit tests", "level":"3"}, "3":{"name":"GIT", "level":"3"}},"description":"defult"}
  }''';

  Future<dynamic> getJSON(String httpLink) async {
    final response = await http.get(httpLink);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load JSON');
    }
  }

  Future<String> getData() async {
    var data;
    try {
      data = await getJSON('http://sanium.olszanowski.it/api/offers');
    } catch (e) {
      return "Fail!";
    }
    print("Page: ${json.decode(data)['meta']['current_page']} loading complete");
    jobOfferList = JobOfferList(list:createJobList2(json.decode(data)));
    await jobOfferList.bookmarkController.setBookmarks(jobOfferList.list);
    this.setState((){
      jobOfferList.sortController.resetStates();
      nextPage = json.decode(data)['links']['next'];
      filters = json.decode(data)['filters'];
    });
    return "Success!";
  }

  Future<String> getNextData() async {
    var data;
    try {
      data = await getJSON(nextPage);
    } catch (e) {
      return "Fail!";
    }
    print("Page: ${json.decode(data)['meta']['current_page']} loading complete");
    jobOfferList.append(createJobList2(json.decode(data)));
    await jobOfferList.bookmarkController.setBookmarks(jobOfferList.list);
    this.setState(() {
      nextPage = json.decode(data)['links']['next'];
      filters = json.decode(data)['filters'];  
    });
    return "Success!";
  }


  Future<String> placeholderData() async {
    filters = {
      'cities':["Poznań","Warszawa","Wrocław"],
      'exp':["Junior","Mid","Senior"],
      'tech':["Python","Java"],
      'min_salary':0,
      'max_salary':10000
    };
    jobOfferList = JobOfferList(list: createPlaceholderList(json.decode(extremeData)));
    return "Success!";
  }

  Future<String> sortData(String by, int id) async {
    this.setState(() {
      jobOfferList.sortController.setState(id);
      jobOfferList.sort(by: by);
    });
    return "Success!";
  }

  @override
  void initState(){
    this.placeholderData(); // wczytanie placeholdera
    this.getData(); // wszytanie danych z bazy danych
    super.initState();
    _initAnimationControllers();
    _initAnimations();
    sleep(Duration(seconds: 5));
  }
  
  void _initAnimationControllers() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
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

    _refreshController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  void _initAnimations(){
    _refreshAnimation = Tween<double>(begin: 0, end: pi + pi).animate(_refreshController);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _animationController.dispose();
    stateNotifier.dispose();
    super.dispose();
  }

  void onSelected(JobOffer tempData) async {
    dynamic tempList;
    _animationController.forward(from: 0.0);
     tempList= await Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return ThemeConsumer(child: JobDetailPage(id: tempData.id, img: tempData.logo, data: tempData));
        },
      ),
    );
    if(tempList != null){
      stateNotifier.value = tempList;
    }
    else{
      stateNotifier.value = true;
    }    
  }

  void manageBookmark({JobOffer o, int operation}) async{
    if(operation==0){jobOfferList.bookmarkController.removeBookmark(o.id);}
    else if(operation==1){jobOfferList.bookmarkController.addBookmark(o);}
  }

  void onMap() async {
    _animationController.forward(from: 0.0);
    stateNotifier.value = await Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return ThemeConsumer(child: MapPage(offerList: jobOfferList.list));
        },
      ),
    )??true;
  }

  void onInfo() async {
    _animationController.forward(from: 0.0);
    stateNotifier.value = await Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return ThemeConsumer(child: InfoPage());
        },
      ),
    )??true;
  }

  void onBookmark() async {
    _animationController.forward(from: 0.0);
    stateNotifier.value = await Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return ThemeConsumer(child: BookmarkPage());
        },
      ),
    )??true;
    await this.jobOfferList.bookmarkController.setBookmarks(jobOfferList.list);
    this.setState((){});
  }

  void onFilter() async {
    dynamic tempList;
    _animationController.forward(from: 0.0);
    tempList = await Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return ThemeConsumer(child: FilterPage.fromMap(filters));
        },
      ),
    );
    if(tempList != null){
      
      stateNotifier.value = tempList[0];
      if(tempList[1].length>0){
        this.setState(() {
          jobOfferList.sortController.resetStates();
          jobOfferList.replace(tempList[1]);
        });
      }
      nextPage = tempList[2];
    }
    else{
      tempList =[false,[],''];
      stateNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color detailColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor;
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          actions: <Widget>[
            FlatButton(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: (){
                _refreshController.forward(from: 0);
                getData();
              },
              child: RotateTrans(
                Icon(
                  Icons.autorenew,
                  color: Colors.grey[400],
                ),
                _refreshAnimation
              ),
            )
          ],
          leading: IconButton(
            hoverColor: Colors.black38,
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress: _animationController,
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
            ),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
            ),
          ),
        ),
      ),
      floatingActionButton: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: detailColor, width: 3.0),
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
            onTap: () => onFilter(),
            child: Padding(
              padding:EdgeInsets.all(15.0),
              child: Icon(Icons.filter_list,size:30, color: Theme.of(context).accentColor,)
            ),
          ),
        )
      ),

      drawer: new MainDrawer(onMap: onMap, onBookmark: onBookmark, onInfo: onInfo),

      body: CustomSliverList(
        key: listKey,
        title: widget.title,
        list: jobOfferList,
        onSelected: onSelected,
        customSort: sortData,
        loadNextData: getNextData,
        manageBookmark: manageBookmark,
      ),
    );
  }
}

class CustomSliverList extends StatefulWidget{
  CustomSliverList({Key key, this.title, this.list, this.onSelected, this.manageBookmark, this.customSort, this.loadNextData, this.isBookmarkPage:false}) : super(key: key);
  final Function(JobOffer) onSelected;
  final Function manageBookmark;
  final Function(String, int) customSort;
  final Function loadNextData;
  final String title;
  final bool isBookmarkPage;
  final JobOfferList list;

  @override
  _CustomSliverListState createState() => _CustomSliverListState();
}

class _CustomSliverListState extends State<CustomSliverList>{
  final controller = ScrollController();
  double appBarHeight = 45.0;
  double appBarMinHeight = 2.0;

  @override
  void initState(){
    super.initState();
    controller.addListener((){
      if(controller.position.pixels==controller.position.maxScrollExtent){
        widget.loadNextData();
      }
    });
  }

  Widget customIcon(int button, double size){
    Color color = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    if(widget.list.sortController.getState(button)==0){
      if(button==0){return Icon(Icons.computer, size: size, color: color,);}
      else if(button==1){return Icon(Icons.place, size: size, color: color);}
      else if(button==2){return Icon(Icons.attach_money, size: size, color: color);}
    }
    else if(widget.list.sortController.getState(button)==1){return Icon(Icons.arrow_downward, size: size, color: color);}
    else if(widget.list.sortController.getState(button)==2){return Icon(Icons.arrow_upward, size: size, color: color);}
    return Icon(Icons.attach_file, size: size, color: color);
  }

  Widget _buildCard(int index) => Builder(
    builder: (context) => Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: MenuListTile(
              id: index,
              data: widget.list.get()[index-1],
              thumbnail: Icon(Icons.android),
              onSelected: widget.onSelected,
              manageBookmark: widget.manageBookmark,
              isBookmarkPage: widget.isBookmarkPage,
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
          color: Colors.black,
          showLeading: false,
          showTrailing: false,
          child: Container(
            color: Theme.of(context).brightness == Brightness.light?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor: Theme.of(context).primaryColor,
            child: CustomScrollView(
              controller: controller,
              slivers:  widget.isBookmarkPage==false?<Widget>[
                SliverAppBar(
                  leading: new Container(),
                  backgroundColor: Theme.of(context).primaryColor,
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
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.30,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.22,
                                                child: AutoSizeText(
                                                  'Technologia',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Open Sans',
                                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              customIcon(0,18),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 4.0,
                                      width: 500,
                                      decoration: BoxDecoration(
                                        color: widget.list.sortController.getState(0)==0 ? ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor : Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      child: Container(height: 10.0,),
                                    ),
                                  ],
                                ),
                                onPressed: (){
                                  // print('Technologia'); 
                                  widget.customSort("technology",0);
                                },
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
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.30,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.22,
                                                child: AutoSizeText(
                                                  'Lokalizacja',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Open Sans',
                                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              customIcon(1,18),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 4.0,
                                      width: 500,
                                      decoration: BoxDecoration(
                                        color: widget.list.sortController.getState(1)==0 ? ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor : Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      child: Container(height: 10.0,),
                                    ),
                                  ],
                                ),
                                onPressed: (){
                                  // print('Lokalizacja'); 
                                  widget.customSort("city",1);
                                },
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
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.30,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.22,
                                                child: AutoSizeText(
                                                  'Płaca',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Open Sans',
                                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              customIcon(2,18),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 4.0,
                                      width: 500,
                                      decoration: BoxDecoration(
                                        color: widget.list.sortController.getState(2)==0 ? ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor : Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      child: Container(height: 10.0,),
                                    ),
                                  ],
                                ),
                                onPressed: (){
                                  // print('Płaca'); 
                                  widget.customSort("salaryMax",2);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
                //TODO: reformat
                LiveSliverList(
                  reAnimateOnVisibility: true,
                  controller: controller,
                  showItemInterval: Duration(milliseconds: 100),
                  showItemDuration: Duration(milliseconds: 400),
                  itemCount: widget.list.get().length.toInt(),
                  itemBuilder: _buildAnimatedItem,
                ),
              ]:<Widget>[
                LiveSliverList(
                  reAnimateOnVisibility: true,
                  controller: controller,
                  showItemInterval: Duration(milliseconds: 100),
                  showItemDuration: Duration(milliseconds: 400),
                  itemCount: widget.list.get().length.toInt(),
                  itemBuilder: _buildAnimatedItem,
                ),
              ],
            ),
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
    this.onSelected,
    this.manageBookmark,
    this.isBookmarkPage
  }) : super(key: key);

  final Function(JobOffer) onSelected;
  final Function manageBookmark;
  final int id;
  final Widget thumbnail;
  final JobOffer data;
  final bool isBookmarkPage;

  @override
  _MenuListTileState createState() => _MenuListTileState();
}

class _MenuListTileState extends State<MenuListTile> {
  void changeState(){
    setState(() {
      widget.data.isBookmark = widget.data.isBookmark==true?false:true;
      widget.data.isBookmark==true?widget.manageBookmark(o:widget.data, operation:1):widget.manageBookmark(o:widget.data, operation:0);
    });
  }
  Widget createBottomTag(String text, IconData icon, double width, double height, Color textColor, Color iconColor){
    return  Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                icon,
                size: 18.0,
                color: iconColor,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: AutoSizeText(
                    "$text",
                    style:TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                    ),
                    maxFontSize: 20,
                    minFontSize: 10,
                    maxLines: 1,
                    textAlign: TextAlign.start
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    Color frameColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
      child: Container(
        decoration: Theme.of(context).brightness == Brightness.light?
        BoxDecoration(
          color: frameColor,
        ):BoxDecoration(
          color: frameColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border(
            bottom: BorderSide(width: 3.5, color: frameColor),
            top: BorderSide(width: 3.5, color: frameColor),
            left: BorderSide(width: 3.5, color: frameColor),
            right: BorderSide(width: 3.5, color: frameColor),
          )
        ),
        child: Material(
          color:  Theme.of(context).primaryColor,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10.0),
          borderOnForeground: false,
          child: InkWell (
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => widget.onSelected(widget.data),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                            child: Container(
                              height: MediaQuery.of(context).orientation == Orientation.portrait? MediaQuery.of(context).size.height * 0.10:MediaQuery.of(context).size.height * 0.20,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),//! tu się zmienia ikonke w kółeczko
                                  clipBehavior: Clip.hardEdge,
                                  color: Theme.of(context).primaryColor,
                                  child: widget.data.logo.length>1?FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.png',
                                    image: widget.data.logo,
                                  ):Container(child:Image.asset('assets/placeholder.png')),
                                )
                              ),
                            ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
                                child: Container(
                                  height: MediaQuery.of(context).orientation == Orientation.portrait? MediaQuery.of(context).size.height * 0.10:MediaQuery.of(context).size.height * 0.20,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.6,
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                                                    child: AutoSizeText(
                                                      widget.data.title,
                                                      style:TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 20,
                                                        color: titleColor,
                                                      ),
                                                      maxLines: 1,
                                                      minFontSize: 16,
                                                      maxFontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // widget.isBookmarkPage==false?
                                              InkWell(
                                                autofocus: false,
                                                onTap: () => changeState(),
                                                child:Container(
                                                  width: MediaQuery.of(context).size.width * 0.08,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                      child: widget.data.isBookmark==true?Icon(Icons.bookmark, color: Theme.of(context).accentColor):Icon(Icons.bookmark_border,color: iconColor),
                                                    )
                                                  ),
                                                ),
                                                highlightColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                              ),
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).dividerColor))
                                        ),
                                      ),
                                      widget.data.salary.salaryMin != 0.0 || widget.data.salary.salaryMax != 0.0 ? Container(
                                        child: AutoSizeText.rich(
                                          TextSpan(
                                            text: "${widget.data.salary.salaryMin.toInt()} - ${widget.data.salary.salaryMax.toInt()} ",
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: " ${widget.data.salary.currency}",
                                                style: TextStyle(
                                                  color: Theme.of(context).accentColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 15,
                                                ),
                                              )
                                            ]
                                          ),
                                          style:TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Open Sans',
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          textAlign: TextAlign.justify,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                      ):Container(child:Text('')),
                                    ],
                                  ),
                                ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            createBottomTag(widget.data.company.name, Icons.domain, MediaQuery.of(context).size.width * 0.3, 25, textColor, Theme.of(context).brightness == Brightness.light?iconColor:Colors.blue),
                            createBottomTag(widget.data.company.local.city, Icons.place, MediaQuery.of(context).size.width * 0.3, 25, textColor, Theme.of(context).brightness == Brightness.light?iconColor:Colors.redAccent),
                          ],
                        ),
                        createBottomTag(widget.data.mainTechnology, Icons.computer, MediaQuery.of(context).size.width * 0.3, 25, textColor, Theme.of(context).brightness == Brightness.light?iconColor:Colors.lightGreenAccent),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}