import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sanium_app/themes/theme_options.dart';
import 'package:sanium_app/tools/CustomScrollBehavior.dart';
import 'package:theme_provider/theme_provider.dart';


class MainDrawer extends StatelessWidget{
  final Function onMap;
  final Function onInfo;
  final Function onBookmark;

  MainDrawer({this.onMap, this.onInfo, this.onBookmark});

  void changeTheme(bool value, BuildContext context)async{
    ThemeProvider.controllerOf(context).nextTheme();
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    Color cardColor = Theme.of(context).brightness == Brightness.light?Theme.of(context).primaryColor:ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor;
    // isSwitched = Theme.of(context).brightness == Brightness.light?false:true;

    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: Container(
          color: Theme.of(context).brightness == Brightness.light?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
          child: ScrollConfiguration(
            behavior: RemoveOverscrollIndicator(),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Theme.of(context).brightness == Brightness.light?Image.asset('assets/sanium.png'):Image.asset('assets/sanium_dark.png'),
                    ),
                    decoration: BoxDecoration(
                      gradient: Theme.of(context).brightness == Brightness.light?LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey[500], cardColor, cardColor, Colors.grey[400]],
                        stops: [
                          0,
                          0.4,
                          0.7,
                          1
                        ],
                      ):LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Theme.of(context).primaryColor, cardColor, cardColor, Theme.of(context).primaryColor],
                        stops: [
                          0,
                          0.4,
                          0.7,
                          1
                        ],
                      ),
                      border: Border(bottom: BorderSide(width: 0.0, color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      title: AutoSizeText(
                        'Mapa',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Open Sans',
                          color: textColor,
                        ),
                        maxLines: 1,
                      ),
                      leading: Icon(Icons.location_on, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.redAccent),
                      onTap: () {
                        Navigator.pop(context);
                        onMap();
                      }
                        
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      title: AutoSizeText(
                        'Zakładki',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Open Sans',
                          color: textColor,
                        ),
                        maxLines: 1,
                      ),
                      leading: Icon(Icons.collections_bookmark, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.lightGreenAccent),
                      onTap: () {
                        Navigator.pop(context);
                        onBookmark();
                      }
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      title: AutoSizeText(
                        'Tryb ${Theme.of(context).brightness == Brightness.light?'Jasny':'Ciemny'}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Open Sans',
                          color: textColor,
                        ),
                        maxLines: 1,
                      ),
                      onTap: ThemeProvider.controllerOf(context).nextTheme,
                      leading: Container(
                        child: Theme.of(context).brightness == Brightness.light?Icon(Icons.wb_sunny, color:iconColor):Icon(Icons.brightness_3, color:Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Card(
                    color: cardColor,
                    child: ListTile(
                      title: AutoSizeText(
                        'Informacje',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Open Sans',
                          color: textColor,
                        ),
                        maxLines: 1,
                      ),
                      leading: Icon(Icons.info_outline, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.blue),
                      onTap: () {
                        Navigator.pop(context);
                        onInfo();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}