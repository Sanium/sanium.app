import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:auto_animated/auto_animated.dart';
import 'package:sanium_app/pages/job_offer_page.dart';
import 'package:sanium_app/pages/main_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';
import 'package:sanium_app/themes/theme_options.dart';
import 'package:sanium_app/tools/JobOffer.dart';
import 'package:sanium_app/tools/bookmark.dart';
import 'package:theme_provider/theme_provider.dart';

class BookmarkPage extends StatefulWidget {
  BookmarkPage({Key key, this.title}) : super(key: key);
  final String title;
 
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> with TickerProviderStateMixin{
  BookmarkController controller = new BookmarkController();
  JobOfferList bookmarkList = new JobOfferList(list: []);


  Future<String> getData() async {
    var data;
    data = await controller.loadData();
    if(data!=null && data!=""){
      bookmarkList = JobOfferList(list:createJobList2(json.decode(data)));
      await bookmarkList.bookmarkController.setBookmarks(bookmarkList.list);
    }
    else{
      bookmarkList.list = [];
      print('brak danych');
    }
    this.setState((){});
    return "Success!";
  }

  void onSelected(JobOffer tempData) async {
    Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return ThemeConsumer(child: JobDetailPage(id: tempData.id, img: tempData.logo, data: tempData));
        },
      ),
    ); 
  }

  void manageBookmark({JobOffer o, int operation}) async{
    if(operation==0){await bookmarkList.bookmarkController.removeBookmark(o.id);}
    else if(operation==1){await bookmarkList.bookmarkController.addBookmark(o);}
    else if(operation==2){await bookmarkList.bookmarkController.wipeData();}
    getData();
  }

  @override
  void initState(){
    this.getData(); // wszytanie danych z urządzenia
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    Color titleColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          leading: IconButton(
            hoverColor: Colors.black38,
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor
          ),
          title: Row(
            children: <Widget>[
              Text(
                'Z A K Ł A D K I',
                style: TextStyle(
                  color: titleColor,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Icon(Icons.delete_outline, color: Colors.red,), 
              onPressed: () => manageBookmark(operation: 2),
            )
          ],
        ),
      ),

      body: Container(
        color: Theme.of(context).primaryColor,
        child: bookmarkList.list.length>0?CustomSliverList(
          title: widget.title,
          list: bookmarkList,
          onSelected: onSelected,
          isBookmarkPage: true,
          manageBookmark: manageBookmark,
        ):Container(
          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
          child: Column(
            mainAxisSize:  MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: AutoSizeText(
                        "Brak zapisanych ofert",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Open Sans',
                          color: titleColor,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}