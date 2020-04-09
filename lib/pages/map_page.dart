import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:sanium_app/pages/job_offer_page.dart';
import 'package:sanium_app/routes/fancy_page_route.dart';
import 'package:sanium_app/tools/JobOffer.dart';


class MapPage extends StatefulWidget{
  final List<JobOffer> offerList;
  MapPage({this.offerList});

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
          return JobDetailPage(id: tempData.id, img: tempData.logo, data: tempData);
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
          builder: (ctx) =>
          Hero(
            tag: o.id.toString(),
            child: Material(
              elevation: 20.0,
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(50.0),
              clipBehavior: Clip.hardEdge,                  
              child: new InkWell(
                onTap: ()=>showDatail(o),
                child: o.logo.length>1?FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: o.logo,
                ):Container(),
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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

      body: new FlutterMap(
        options: new MapOptions(
          center: markerlist.length==1?LatLng(markerlist[0].point.latitude,markerlist[0].point.longitude):LatLng(52.4, 16.9),
          zoom: 6.0,
          minZoom: 5.0,
          maxZoom: 19.0,
          plugins: [
            MarkerClusterPlugin(),
          ],
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
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
