import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sanium_app/pages/map_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';
import 'package:sanium_app/themes/theme_options.dart';
import 'package:sanium_app/tools/JobOffer.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:theme_provider/theme_provider.dart';
  

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
            return ThemeConsumer(child: MapPage(offerList: [widget.data], isFromDetail: true,));
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
            "O F E R T A",
            style: TextStyle(
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Container(
          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
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
                      onPanUpdate: (details) {
                        if (details.delta.dx > 1) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                          border: Border(
                            bottom: BorderSide(width: 3.5, color: Colors.transparent),
                            top: BorderSide(width: 3.5, color: Colors.transparent),
                            left: BorderSide(width: 3.5, color: Colors.transparent),
                            right: BorderSide(width: 3.5, color: Colors.transparent),
                          )
                        ),
                        child: AspectRatio(
                          aspectRatio: 3.0/1.0,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Material(
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17.0)),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.transparent,
                                    child:Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Material(
                                          borderRadius: BorderRadius.circular(200.0),
                                          clipBehavior: Clip.hardEdge,
                                          child: widget.data.logo.length>1?FadeInImage.assetNetwork(
                                          placeholder: 'assets/placeholder.png',
                                          image: widget.data.logo,
                                        ):Container(child:Image.asset('assets/placeholder.png')),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.65,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent
                                          ),
                                          child:AutoSizeText(
                                            widget.data.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              fontSize: 80,
                                            ),
                                            maxFontSize: 80,
                                            minFontSize: 25,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ],
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
                        JobMainInfo(
                          tech: widget.data.mainTechnology,
                          level: widget.data.experience,
                          salary: "${widget.data.salary.salaryMin} - ${widget.data.salary.salaryMax}  ${widget.data.salary.currency} / miesiąc", 
                          employment: widget.data.employment,
                          employer: widget.data.company.name,
                          city: widget.data.company.local.city
                        ),
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
  final String employment;
  final String employer;
  final String city;
  final String level;

  JobMainInfo({this.tech:"Developer",this.level:"Mid", this.salary:"3000 PLN", this.employment:"Normal", this.employer:"Google", this.city:"Warszawa"});

  @override
  Widget build(BuildContext context) {
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    return Card(
      elevation: 0.0,
      color: Theme.of(context).primaryColor,
      child: Container(
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
                              color: textColor,
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
                      child: Icon(Icons.domain, size: 30.0, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.blue,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                        child: Text(
                          '$employer $city',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            color: textColor,
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
                      child: Icon(
                        Icons.signal_cellular_null,size: 30.0, 
                        color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.redAccent,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                        child: Text(
                          level,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            color: textColor,
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
                      child: Icon(Icons.computer,size: 30.0, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.lightGreenAccent,),
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
                            color: textColor,
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
                      child: Icon(Icons.insert_drive_file, size: 30.0, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.grey[600],),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                        child: Text(
                          employment,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            color: textColor,
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
                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor,
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
  final String jobName = "Umiejętności";
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

  Widget createReqList(BuildContext context, List requirements, Color textColor){
    bool isVertical = MediaQuery.of(context).orientation == Orientation.portrait?true:false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        height: (requirements.length/(isVertical==true?3:5)).ceil()*(isVertical==true?MediaQuery.of(context).size.height*0.095:MediaQuery.of(context).size.height*0.18),// 75:95
        child: Center(
          child: GridView.builder(
            itemCount: requirements.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isVertical==true?3:5, childAspectRatio: 2.0),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 0.0,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: AutoSizeText(
                      requirements[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Open Sans',
                        fontSize: 25,
                        color: textColor,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }
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
    return Card(
      elevation: 0.0,
      color: Theme.of(context).primaryColor,
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
                        child: Icon(Icons.tune,size: 30.0,color: iconColor,),
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
                              color: titleColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            createReqList(context, data, textColor),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              height: 3.0,
              decoration: BoxDecoration(
                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor,
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
  final String jobDetails = "Custom description";

  JobDetailInfo({this.description});

  @override
  Widget build(BuildContext context) {
    Color titleColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    return Card(
      elevation: 0.0,
      color:  Theme.of(context).primaryColor,
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
                        child: Icon(Icons.info_outline, size: 30.0, color: iconColor),
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
                              color: titleColor,
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
                          child: description!='defult'?HtmlWidget(description,textStyle: TextStyle(color: textColor,),):
                          Text(
                            jobDetails,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 14,
                              color: textColor,
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
              height: 3.0,
              decoration: BoxDecoration(
                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor,
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
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color titleColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    return Padding(
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
                child: AutoSizeText(
                  '$title:   ',
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Open Sans',
                    fontSize: 18,
                  ),
                  maxLines: 1,
                ),
              ),
              Expanded(
                child: SelectableText(
                  '$value',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                    fontSize: 18,
                  ),
                  cursorColor: Colors.amberAccent,
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
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    return Card(
      elevation: 0.0,
      color:  Theme.of(context).primaryColor,
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
                        child: Icon(Icons.mail_outline, size: 30.0, color: iconColor,),
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
                              color: titleColor,
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

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 0.0,
                decoration: BoxDecoration(
                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Container(height: 0.0,),
              ),
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
    print('$latitude $longnitude');
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
    Color titleColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    return Card(
      elevation: 0.0,
      color:  Theme.of(context).primaryColor,
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
                        child: Icon(Icons.map, size: 30.0, color: iconColor,),
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
                              color: titleColor,
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
          ],
        ),
      ),
    );
  }
}