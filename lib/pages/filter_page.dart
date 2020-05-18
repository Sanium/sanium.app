import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sanium_app/themes/theme_options.dart';
import 'package:sanium_app/tools/filter.dart';
import 'package:sanium_app/tools/JobOffer.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:theme_provider/theme_provider.dart';


class FilterPage extends StatefulWidget{
  List<String> cities;
  List<String> exp;
  List<String> tech;
  double max = 1.0;
  double min = 0.0;

  FilterPage.fromMap(Map<String, dynamic> filters){
    this.cities = filters['cities'].cast<String>();
    this.exp = filters['exp'].cast<String>();
    this.tech = filters['tech'].cast<String>();
    this.min = double.parse(filters['min_salary'].toString());
    this.max = double.parse(filters['max_salary'].toString());
  }

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage>{
  final controller = ScrollController();
  Map<String,dynamic> selectedValues = new Map();
  final List<DropdownMenuItem> items = [];

  var values;
  int divisions = 100;
  List<JobOffer> resultList = new List();

  @override
  void initState(){
    this.divisions = widget.max~/100;
    this.values = RangeValues(widget.min, widget.max);
    super.initState();
  }

    Future<dynamic> getJSON(String httpLink) async {
    final response = await http.get(httpLink);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load JSON');
    }
  }

  Future<String> getData({BuildContext context, String city, String exp, String tech,String salaryFrom, String salaryTo}) async {
    String nextPage = '';
    var data;
    Filter f = Filter(city:city,exp:exp,tech:tech,salaryFrom:salaryFrom,salaryTo:salaryTo);
    String querry = f.createQuery();
    if(querry.length>1){
      try {
        data = await getJSON('http://sanium.olszanowski.it/api/offers$querry');
      } catch (e) {
        return "Fail!";
      }
      this.setState(() {
        nextPage = json.decode(data)['links']['next'];
        resultList = createJobList2(json.decode(data));
      });
      for(dynamic x in resultList){
        print("${x.salary.salaryMin} - ${x.salary.salaryMax}");
      }
      if(resultList.length>0){
        Navigator.of(context).pop([true,resultList,nextPage]);
      }
      else{
        print("BRAK WYNIKÓW");
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            titleTextStyle: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Open Sans',
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
            ),
            title: FlatButton(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Icon(Icons.warning, color:Theme.of(context).accentColor),
                    ),
                    Padding(
                      padding:  const EdgeInsets.fromLTRB(10, 40, 20, 40),
                      child: Text(
                        "BRAK WYNIKÓW",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Open Sans',
                          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor, width: 5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          barrierDismissible: false,
        );
      }
      return "Success!";
    }
    else {
      return "NoParams!";
    }
  }

  Widget createSearcher(String title, List<dynamic> data, double height){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(width: 1.5, color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: SearchableDropdown.single(
                  items: data.map((exNum) {
                    return (DropdownMenuItem(
                        child: Text(exNum), value: exNum));
                  }).toList(),
                  value: selectedValues[title],
                  hint: title,
                  searchHint: title,
                  onChanged: (value) {
                    setState(() {
                      selectedValues[title] = value;
                    });
                  },
                  dialogBox: true,
                  menuBackgroundColor: Theme.of(context).primaryColor,
                  isExpanded: true,
                  underline: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 1.0,
                    decoration: BoxDecoration(
                      // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Container(height: 0.0,),
                  ),
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
    Color textColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).secondaryTextColor;
    Color backgroundColor = ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop([true,resultList,'']);
            },
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor
          ),
          title: Text(
            "F I L T R O W A N I E",
            style: TextStyle(
              color: titleColor,
            ),
          ),
        ),
      ),

      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.transparent,
          showLeading: false,
          showTrailing: false,
          child: Container(
            color: Theme.of(context).brightness == Brightness.light?backgroundColor:Theme.of(context).primaryColor,
            child: CustomScrollView(
              controller: controller,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                  Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            createSearcher("Miasto", widget.cities, MediaQuery.of(context).size.height * 0.20),
                            createSearcher("Doświadczenie", widget.exp, MediaQuery.of(context).size.height * 0.20),
                            createSearcher("Technologia", widget.tech, MediaQuery.of(context).size.height * 0.20),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                height: MediaQuery.of(context).orientation == Orientation.portrait?MediaQuery.of(context).size.height * 0.15:MediaQuery.of(context).size.height * 0.30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(width: 1.5, color: backgroundColor,)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          border: Border(
                                            top: BorderSide(width: 0.0, color: Colors.transparent,),
                                            // bottom: BorderSide(width: 1.0, color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),
                                            bottom: BorderSide(width: 1.0, color:Theme.of(context).brightness == Brightness.light?backgroundColor:Theme.of(context).primaryColor,),
                                            left: BorderSide(width: 0.0, color: Colors.transparent,),
                                            right: BorderSide(width: 0.0, color: Colors.transparent,),
                                          )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AutoSizeText(
                                            "Płaca",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              color: textColor,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: RangeSlider(
                                          values: values,
                                          onChanged: (RangeValues value) {
                                            setState(() => values = value);
                                          },
                                          divisions: divisions,
                                          min: widget.min,
                                          max: widget.max,
                                          labels: RangeLabels('MIN: ${(values.start.toInt()~/100)*100}','MAX: ${(values.end.toInt()~/100)*100}'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(width: 1.5, color: backgroundColor,)
                              ),
                              child: Center(
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(9.0)),
                                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.amberAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        child: Center(
                                          child: AutoSizeText(
                                            "Filtruj",
                                            style: TextStyle(
                                              fontSize: 35.0,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Open Sans',
                                              color: titleColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.filter_list,
                                        size: 35,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ],
                                  ), 
                                  onPressed: () => getData(
                                    context: context,
                                    city: selectedValues['Miasto'],
                                    exp: selectedValues['Doświadczenie'],
                                    tech: selectedValues['Technologia'],
                                    salaryFrom: values.start!=widget.min?(values.start.toInt()~/100*100).toString():values.end==widget.max?'':(values.start.toInt()~/100*100).toString(),
                                    salaryTo: values.end!=widget.max?(values.end.toInt()~/100*100).toString():values.start==widget.min?'':(values.end.toInt()~/100*100).toString()
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
              ),
              ),
              ]
            ),
          )
        )
      )
    );
  }
}
