import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


Widget mainDrawer(BuildContext context, Function onMap, Function onInfo, Function onBookmark) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/sanium.png'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(bottom: BorderSide(width: 3.0, color: Theme.of(context).dividerColor)),
              ),
            ),
            Card(
              child: ListTile(
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
                leading: Icon(Icons.map, color: Theme.of(context).primaryColorDark),
                onTap: () {
                  Navigator.pop(context);
                  onMap();
                }
                  
              ),
            ),

            Card(
              child: ListTile(
                title: AutoSizeText(
                  'Zakładki',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Open Sans',
                    color: Theme.of(context).primaryColorDark,
                  ),
                  maxLines: 1,
                ),
                leading: Icon(Icons.bookmark_border, color: Theme.of(context).primaryColorDark),
                onTap: () {
                  Navigator.pop(context);
                  onBookmark();
                }
                  
              ),
            ),

            Card(
              child: ListTile(
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
                leading: Icon(Icons.info_outline, color: Theme.of(context).primaryColorDark),
                onTap: () {
                  Navigator.pop(context);
                  onInfo();
                },
              ),
            ),

          ],
        ),
      ),
    );
  }