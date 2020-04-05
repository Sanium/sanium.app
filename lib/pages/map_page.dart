import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';


class MapPage extends StatefulWidget{

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>{
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
          center: new LatLng(52.4, 16.9),
          zoom: 6.0,
          minZoom: 5.0,
          maxZoom: 19.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 60.0,
                height: 60.0,
                point: new LatLng(52.4081017, 16.9337332),
                builder: (ctx) =>
                Material(
                    borderRadius: BorderRadius.circular(50.0),
                    clipBehavior: Clip.hardEdge,                  
                    child: new Container(
                    color: Colors.lightGreen,
                    child: new FlutterLogo(),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
