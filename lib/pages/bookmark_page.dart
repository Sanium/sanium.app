import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:auto_animated/auto_animated.dart';
import 'package:sanium_app/pages/job_offer_page.dart';
import 'package:sanium_app/pages/main_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';
import 'package:sanium_app/tools/JobOffer.dart';
import 'package:sanium_app/tools/bookmark.dart';

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
    this.setState((){
      if(data!=null && data!=""){
        bookmarkList = JobOfferList(list:createJobList2(json.decode(data)));
      }
      else{
        print('brak danych');
      }
    });
    return "Success!";
  }

  void onSelected(JobOffer tempData) async {
    Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return JobDetailPage(id: tempData.id, img: tempData.logo, data: tempData);
        },
      ),
    ); 
  }

  @override
  void initState(){
    this.getData(); // wszytanie danych z urządzenia
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
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
          title: Text(
            'Sanium',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 2.0, color: Theme.of(context).dividerColor))
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(Icons.bookmark_border, color: Theme.of(context).primaryColorDark),
                      ),
                      AutoSizeText(
                        'Zakładki',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Open Sans',
                          color: Theme.of(context).primaryColorDark,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: bookmarkList.list.length>0?CustomSliverList(
        title: widget.title,
        list: bookmarkList,
        onSelected: onSelected,
        isBookmarkPage: true,
      ):Column(
        mainAxisSize:  MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child:Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AutoSizeText(
                    "Brak zapisanych ofert",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Open Sans',
                      color: Theme.of(context).primaryColorDark,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}