import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sanium_app/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';


class InfoPage extends StatefulWidget{
  @override
  _InfoPageState createState() => _InfoPageState();
}


class _InfoPageState extends State<InfoPage>{
  @override
  Widget build(BuildContext context) {
    Color titleColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor;
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color iconColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor;
    Color surfaceColor = Theme.of(context).brightness == Brightness.dark?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor;
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
            "I N F O R M A C J E",
            style: TextStyle(
              color: titleColor,
            ),
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).brightness== Brightness.light? ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView(
            children: <Widget>[
              Card(
                color:surfaceColor,
                child: Row(
                  children: <Widget>[
                    Container(
                      width:  MediaQuery.of(context).size.width * 0.25,
                      child: Theme.of(context).brightness == Brightness.light?Image.asset('assets/sanium.png'):Image.asset('assets/sanium_dark.png'),
                    ),
                    Container(
                      width:  MediaQuery.of(context).size.width * 0.65,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: AutoSizeText(
                          'Aplikacja internetowa z ogłoszeniami o pracę w branży IT',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: titleColor,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      decoration: BoxDecoration(
                        // color: Theme.of(context).primaryColor,
                        border: Border(bottom: BorderSide(width: 3.0, color: Theme.of(context).accentColor)),
                      ),
                    ),
                  ],
                ),
              ),

              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(                    
                                'WWW :',
                                style: TextStyle( 
                                  fontSize: 18.0,     
                                  fontWeight: FontWeight.w400,     
                                  fontFamily: 'Open Sans',    
                                  color: titleColor,
                                ),
                                maxLines: 1,     
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                'GitHub :',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Open Sans',
                                  color: titleColor,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: AutoSizeText(
                                  'http://sanium.olszanowski.it/',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Open Sans',
                                    color: textColor,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: AutoSizeText(
                                  'https://github.com/Sanium',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Open Sans',
                                    color: textColor,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),

              Card(
                color: surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                          child: AutoSizeText(
                            'Team:',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Open Sans',
                              color: titleColor,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 3.0, color: Theme.of(context).accentColor)),
                        ),
                      ),
                      ListTile(
                        title: AutoSizeText(
                          'Michał Popiel',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: textColor,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.phone_android, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.amberAccent),
                      ),
                      ListTile(
                        title: AutoSizeText(
                          'Maciej Owsianny',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: textColor,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.web, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.redAccent),
                      ),
                      ListTile(
                        title: AutoSizeText(
                          'Bartłomiej Olszanowski',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: textColor,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.cloud_queue, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.blue),
                      ),
                      ListTile(
                        title: AutoSizeText(
                          'Błażej Darul',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: textColor,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.web, color: Theme.of(context).brightness == Brightness.light?iconColor:Colors.lightGreenAccent),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}