import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sanium_app/pages/map_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';
import 'package:sanium_app/tools/JobOffer.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
  

class JobDetailPage extends StatefulWidget{
  final int id;
  final JobOffer data; 
  final String img;
  final bool isFromMap;
  JobDetailPage({@required this.id, this.img, this.data,this.isFromMap:false});

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

  void showMap() async {
    if(widget.isFromMap==false){
      await Navigator.of(context).push(
        FancyPageRoute(
          builder: (_) {
            return MapPage(offerList: [widget.data], isFromDetail: true,);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor
          ),
          title: Text(
            "Sanium",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Container(
          color: Colors.blueGrey[50],
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
                      // onPanUpdate: (details) {
                      //   if (details.delta.dx > 1) {
                      //     Navigator.of(context).pop(true);
                      //   }
                      // },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                          border: Border.all(width: 1.5, color: Colors.grey)
                        ),
                        child: AspectRatio(
                          aspectRatio: 3.0/1.0,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Hero(
                                  tag: widget.data.id.toString(),
                                  child: Material(
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(19.0)),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.transparent,
                                    child:widget.data.logo.length>1?FadeInImage.assetNetwork(
                                      placeholder: 'assets/placeholder.png',
                                      image: widget.data.logo,
                                    ):Container(child:Image.asset('assets/placeholder.png')),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent
                                      ),
                                      child:AutoSizeText(
                                        widget.data.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Open Sans',
                                          fontSize: 30,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                  ),

                  
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        JobMainInfo(tech: widget.data.mainTechnology,salary: "${widget.data.salary.salaryMin} - ${widget.data.salary.salaryMax}  ${widget.data.salary.currency} / miesiąc", city:widget.data.company.local.city),
                        widget.data.requirements.length>0?JobRequirements(data: widget.data.requirements,):Container(),
                        JobDetailInfo(description: widget.data.description,),
                        widget.data.company.local.latitude!=null && widget.data.company.local.longnitude!=null? JobLocalization(
                          id:widget.data.id, 
                          logo: widget.data.logo,
                          latitude: widget.data.company.local.latitude,
                          longnitude: widget.data.company.local.longnitude,
                          show:showMap
                        ):Container(),
                        JobContactInfo(companyEmail:widget.data.company.email, companyWebsite:widget.data.company.website),
                      ],
                    ),
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


class JobMainInfo extends StatelessWidget{
  final String tech;
  final String salary;
  final String city;

  JobMainInfo({this.tech:"Developer",this.salary:"3000 PLN", this.city:"Warszawa"});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        color:  Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.attach_money,size: 30.0, color: Colors.amber,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            salary,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Open Sans',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      child: Icon(Icons.home,size: 30.0,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                        child: Text(
                          city,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      child: Icon(Icons.bug_report,size: 30.0,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                        child: Text(
                          tech,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              height: 3.0,
              decoration: BoxDecoration(
                color: Colors.grey, //!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}

class JobRequirements extends StatelessWidget{
  final String jobName = "Wymagania";
  final List<Requirement> data;
  JobRequirements({this.data});

  Widget createLevelWidget({BuildContext context, int level, IconData tempIcon}){
    if(level == 0){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
        ],
      );
    }
    if(level == 1){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
        ],
      );
    }
    else if(level == 2){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[ 
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
        ],
      );
    }
    else if(level == 3){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0,),
          Icon(tempIcon, size: 25.0,),
        ],
      );
    }
    else if(level == 4){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0,),
        ],
      );
    }

    else if(level == 5){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
          Icon(tempIcon, size: 25.0, color: Theme.of(context).accentColor,),
        ],
      );
    } 
    else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(tempIcon, size: 25.0, color: Colors.transparent,),
          Icon(tempIcon, size: 25.0, color: Colors.transparent,),
          Icon(tempIcon, size: 25.0, color: Colors.transparent,),
          Icon(tempIcon, size: 25.0, color: Colors.transparent,),
          Icon(tempIcon, size: 25.0, color: Colors.transparent,),
        ],
      );
    } 
  }

  Widget createReqList(List requirements){
    return Container(
      height: 200,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: requirements.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Text(
                          requirements[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Open Sans',
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: createLevelWidget(context: context, level:requirements[index].level,tempIcon: Icons.stars)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.tune,size: 30.0,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            jobName,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            createReqList(data),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,//!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}

class JobDetailInfo extends StatelessWidget{
  final String cardTitle = "Opis";
  final String description;
  final String jobDetails = '''At Grape Up our mission is to help companies become cloud-native.
    Our current projects are based on cooperation with international clients from various industries such as automotive, telecommunication or finance from the United States, Europe, and Asia.

    Responsibilities:

    Designing and building Cloud-Native Applications using Python/Flask and AWS services
    Migrating applications to modern microservices-based architectures
    Integrating various services (databases, storage, APIs) into cloud applications
    Creating pipelines and script for CI/CD using e.g. Jenkins and Terraform

    Requirements:

    Understanding of web applications design principles (twelve-factor applications) and microservice-based architectures
    Knowledge of relational databases (PostgreSQL)
    Knowledge of unit testing and mocking libraries
    Experience with modern development tools (ideally pip, Git, pycharm, CI servers, Confluence (or other wikis), JIRA (or other trackers), code review tools, SCA tools)
    Bash basics
    Very good command of English
    Good communication skills
    Open for new technologies''';

  JobDetailInfo({this.description});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        color:  Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.info_outline, size: 30.0,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            cardTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 0.0),
                          child: description!='defult'?HtmlWidget(description):
                          Text(
                            jobDetails,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              // height: 1.0,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,//!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}

class JobContactInfo extends StatelessWidget{
  final String cardTitle = "Dane kontaktowe";
  final String companyEmail;
  final String companyWebsite;

  JobContactInfo({this.companyEmail:'getjob@gmail.com', this.companyWebsite:'www.pracaXD.it'});

  Widget createField(String title, String value, BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: RichText(
                    text: TextSpan(
                      text: '$title:   ',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Open Sans',
                        fontSize: 18,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '$value', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
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
    return Card(
      elevation: 5.0,
      child: Container(
        color:  Theme.of(context).primaryColor,
        height: 140,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.mail_outline, size: 30.0,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            cardTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            createField("Email", "$companyEmail", context),

            createField("WWW", "$companyWebsite", context),

            Container(
              height: 5.0,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,//!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}

class JobLocalization extends StatelessWidget{
  final String cardTitle = "Lokalizacja";
  final int id;
  final double latitude;
  final double longnitude;
  final String logo;
  final Function show;

  JobLocalization({this.id,this.latitude,this.longnitude,this.logo, this.show});

  Widget createMap(String logo, double latitude, double longnitude){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
      child: Container(
        height: 400,
        child: Stack( children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(150.0)),
            ),
            child: FlutterMap(
              options: new MapOptions(
                center: new LatLng(latitude, longnitude),
                zoom: 16.0,
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b']

                ),
                new MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: new LatLng(latitude, longnitude),
                      builder: (ctx) =>Hero(     
                        tag: "map_$id",  
                        child:Material(
                          elevation: 20.0,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50.0),
                          clipBehavior: Clip.hardEdge,  
                          child:logo.length>1?FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: logo,
                          ):Container(child:Image.asset('assets/placeholder.png')),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
          onTap: () {
            show();
          },
            child: Container(height: 400, color: Colors.transparent,)
          )

        ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Container(
        color:  Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.map, size: 30.0),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            cardTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            createMap(logo, latitude, longnitude),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              height: 4.0,
              decoration: BoxDecoration(
                // color: Theme.of(context).primaryColorDark, //!  create accentColorLight
                color: Colors.grey[600],
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0),
            ),
          ],
        ),
      ),
    );
  }
}