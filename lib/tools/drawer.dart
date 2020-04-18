import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


Widget mainDrawer(BuildContext context, Function onMap) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/sanium.png'),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 3.0, color: Theme.of(context).dividerColor)),
              ),
            ),
            ListTile(
              title: AutoSizeText(
                'Mapa',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Open Sans',
                  color: Theme.of(context).primaryColorDark,
                ),
                maxLines: 1,
              ),
              trailing: Icon(Icons.map, color: Theme.of(context).accentColor),
              onTap: () {
                Navigator.pop(context);
                onMap();
              }
                
            ),
            ListTile(
              title: AutoSizeText(
                'Informacje',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Open Sans',
                  color: Theme.of(context).primaryColorDark,
                ),
                maxLines: 1,
              ),
              trailing: Icon(Icons.info_outline),
              onTap: () {
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }