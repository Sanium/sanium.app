import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:sanium_app/pages/job_offer_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';
import 'package:sanium_app/themes/theme_options.dart';
import 'package:sanium_app/tools/JobOffer.dart';
import 'package:theme_provider/theme_provider.dart';


class MapPage extends StatefulWidget{
  final bool isFromDetail;
  final List<JobOffer> offerList;
  MapPage({this.offerList,this.isFromDetail:false});

  @override
  _MapPageState createState() => _MapPageState();
}


class _MapPageState extends State<MapPage>{
  List<Marker> markerlist;


  @override
  void initState(){
    markerlist = createMarkerList();
    super.initState();
  }

  void showDatail(JobOffer tempData) async {
    await Navigator.of(context).push(
      FancyPageRoute(
        builder: (_) {
          return ThemeConsumer(child: JobDetailPage(id: tempData.id, img: tempData.logo, data: tempData,isFromMap: true,));
        },
      ),
    );  
  }

  List<Marker> createMarkerList(){
    List<Marker> output = new List();
    for(JobOffer o in widget.offerList){
      if(o.company.local.latitude!=null && o.company.local.longnitude!=null){
        output.add(new Marker(
          width: 50.0,
          height: 50.0,
          point: new LatLng(o.company.local.latitude, o.company.local.longnitude),
          builder: (ctx) => Hero(
            tag: "map_${o.id}",
            child: Material(
              elevation: 20.0,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50.0),
              clipBehavior: Clip.hardEdge,                  
              child: new InkWell(
                onTap: ()=>widget.isFromDetail==false?showDatail(o):null,
                child: o.logo.length>1?FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: o.logo,
                ):Container(child:Image.asset('assets/placeholder.png')),
              ),
            ),
          ),
        ));
      }
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
           actions: <Widget>[
            widget.isFromDetail==true?Container(
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
                        child: Icon(Icons.home, color: iconColor),
                      ),
                      AutoSizeText(
                        widget.offerList[0].company.local.city,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Open Sans',
                          color: textColor,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ):Container(),
          ],
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
            "M A P A",
            style: TextStyle(
              color: titleColor,
            ),
          ),
        ),
      ),

      body: new FlutterMap(
        options: new MapOptions(
          center: markerlist.length==1?LatLng(markerlist[0].point.latitude,markerlist[0].point.longitude):LatLng(52.4, 16.9),
          zoom: widget.isFromDetail==false?6.0:15.0,
          minZoom: 5.0,
          maxZoom: 19.0,
          plugins: [
            MarkerClusterPlugin(),
          ],
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
            subdomains: ['a', 'b']
          ),
          new MarkerClusterLayerOptions(
            maxClusterRadius: 80,
            size: Size(40, 40),
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(100),
            ),
            markers: markerlist,
            polygonOptions: PolygonOptions(
                borderColor: Colors.transparent,
                color: Colors.transparent,
                borderStrokeWidth: 1
            ),
            builder: (context, markers) {
              return FloatingActionButton(
                backgroundColor: Colors.amber,
                child: Text(markers.length.toString()),
                onPressed: null,
                heroTag: null,
              );
            },
          ),
        ],
      )
    );
  }
}
