import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class InfoPage extends StatefulWidget{
  @override
  _InfoPageState createState() => _InfoPageState();
}


class _InfoPageState extends State<InfoPage>{
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
      body: Container(
        color: Colors.blueGrey[50],
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      width:  MediaQuery.of(context).size.width * 0.25,
                      child: Image.asset('assets/sanium.png',)
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
                            color: Theme.of(context).primaryColorDark,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border(bottom: BorderSide(width: 3.0, color: Theme.of(context).accentColor)),
                      ),
                    ),
                  ],
                ),
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(                    
                              'WWW :',
                              style: TextStyle( 
                                fontSize: 20.0,     
                                fontWeight: FontWeight.w400,     
                                fontFamily: 'Open Sans',    
                                color: Theme.of(context).primaryColorDark,
                              ),
                              maxLines: 1,     
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              'GitHub :',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Open Sans',
                                color: Theme.of(context).primaryColorDark,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                'http://sanium.olszanowski.it/',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Open Sans',
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                'https://github.com/Sanium',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Open Sans',
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ),

              Card(
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
                            color: Theme.of(context).primaryColorDark,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border(bottom: BorderSide(width: 3.0, color: Theme.of(context).dividerColor)),
                      ),
                        ),
                      ListTile(
                        title: AutoSizeText(
                          'Bartłomiej Olszanowski',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: Theme.of(context).primaryColorDark,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.cloud_queue, color: Theme.of(context).accentColor),
                      ),
                      ListTile(
                        title: AutoSizeText(
                          'Maciej Owsianny',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: Theme.of(context).primaryColorDark,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.web, color: Theme.of(context).accentColor),
                      ),
                      ListTile(
                        title: AutoSizeText(
                          'Błażej Darul',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: Theme.of(context).primaryColorDark,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.web, color: Theme.of(context).accentColor),
                      ),
                      ListTile(
                        title: AutoSizeText(
                          'Michał Popiel',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            color: Theme.of(context).primaryColorDark,
                          ),
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.phone_android, color: Theme.of(context).accentColor),
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