

import 'package:flutter/material.dart';

class JobDatail extends StatefulWidget{
  // final JobOffer data;
  final int id;
  final Map data;
  final Widget img;
  JobDatail({@required this.id, this.img, this.data});

  @override
  _JobDatailState createState() {
    return _JobDatailState();
  }
}

class _JobDatailState extends State<JobDatail>{
  final controller = ScrollController();
  double appBarHeight = 120.0;
  double appBarMinHeight = 60.0;

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
            widget.data['firma'],
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Container(
          color: Colors.red,
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.transparent,
              showLeading: false,
              showTrailing: false,
              child: CustomScrollView(
                controller: controller,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: new Container(),
                    backgroundColor: Colors.transparent,
                    elevation: 10.0,
                    pinned: true,
                    expandedHeight: appBarHeight,
                    bottom: PreferredSize(                  
                      preferredSize: Size.fromHeight(appBarMinHeight),      
                      child: Container(),                           
                    ),
                    floating: true,
                    flexibleSpace: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Hero(
                        tag: widget.id.toString(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                          ),
                          child: AspectRatio(
                            aspectRatio: 3.0/1.0,
                            child: widget.img,
                          ),
                        ),
                      ),
                    ),
                  ),

                  
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(color: Colors.red, height: 250.0, child: Text("Główne info"),),
                      Container(color: Colors.purple, height: 250.0, child: Text("Dodatkowe info"),),
                      Container(color: Colors.green, height: 250.0, child: Text("Główne wymagania"),),
                      Container(color: Colors.yellow, height: 250.0, child: Text("Opis szczegółowy"),),
                      Container(color: Colors.blueAccent, height: 250.0, child: Text("Kontakt"),),
                    ],
                  ),
                  // reAnimateOnVisibility: true,
                  // controller: controller,
                  // showItemInterval: Duration(milliseconds: 200),
                  // showItemDuration: Duration(milliseconds: 1000),
                  
                  // itemCount: widget.data.length.toInt(),
                  // itemBuilder: _buildAnimatedItem,
                ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}