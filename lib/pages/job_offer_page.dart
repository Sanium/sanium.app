

import 'package:flutter/material.dart';

class JobDetailPage extends StatefulWidget{
  // final JobOffer data;
  final int id;
  final Map data;
  final Widget img;
  JobDetailPage({@required this.id, this.img, this.data});

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> with SingleTickerProviderStateMixin{
  final controller = ScrollController();
  double appBarHeight = 120.0;
  double appBarMinHeight = 60.0;

   @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          // automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor
          ),
          title: Text(
            // widget.data,
            "Sanium:  ${widget.data['firma']}",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
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
                    elevation: 20.0,
                    pinned: true,
                    expandedHeight: appBarHeight,
                    floating: false,
                    flexibleSpace: GestureDetector(
                      onTap: () {
                         Navigator.of(context).pop(true);
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
                      Container(color: Theme.of(context).primaryColor, height: 250.0, child: Text("Główne info"),),
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