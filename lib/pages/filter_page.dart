import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sanium_app/tools/filter.dart';
import 'package:sanium_app/tools/JobOffer.dart';
// import 'package:sanium_app/tools/data_search.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';


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

  Future<String> getData({String city, String exp, String tech,String salaryFrom, String salaryTo}) async {
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
      }
      return "Success!";
    }
    else {
      return "NoParams!";
    }
  }

  Widget createSearcher(String title, List<dynamic> data, double height){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        // height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(width: 1.5, color: Colors.grey[400],)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border(
                    top: BorderSide(width: 0.0, color: Theme.of(context).primaryColor,),
                    bottom: BorderSide(width: 2.0, color: Theme.of(context).accentColor),
                    left: BorderSide(width: 0.0, color: Theme.of(context).primaryColor,),
                    right: BorderSide(width: 0.0, color: Theme.of(context).primaryColor,),
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: AutoSizeText(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Open Sans',
                      color: Theme.of(context).primaryColorDark,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),

              SearchableDropdown.single(
                items: data.map((exNum) {
                  return (DropdownMenuItem(
                      child: Text(exNum), value: exNum));
                }).toList(),
                value: selectedValues[title],
                hint: "Select one",
                searchHint: "Select one",
                onChanged: (value) {
                  setState(() {
                    selectedValues[title] = value;
                  });
                },
                // underline: Container(),
                dialogBox: true,
                isExpanded: true,
              ),
            ],
          ),
        ),
      ),
    );
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
              Navigator.of(context).pop([true,resultList,'']);
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

      body: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.transparent,
              showLeading: false,
              showTrailing: false,
              child: CustomScrollView(
                controller: controller,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            createSearcher("Miasto", widget.cities, MediaQuery.of(context).size.height * 0.17),
                            createSearcher("Doświadczenie", widget.exp, MediaQuery.of(context).size.height * 0.17),
                            createSearcher("Technologia", widget.tech, MediaQuery.of(context).size.height * 0.17),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.17,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(width: 1.5, color: Colors.grey[400],)
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
                                            top: BorderSide(width: 0.0, color: Theme.of(context).primaryColor,),
                                            bottom: BorderSide(width: 2.0, color: Theme.of(context).accentColor),
                                            left: BorderSide(width: 0.0, color: Theme.of(context).primaryColor,),
                                            right: BorderSide(width: 0.0, color: Theme.of(context).primaryColor,),
                                          )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AutoSizeText(
                                            "Płaca",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Open Sans',
                                              color: Theme.of(context).primaryColorDark,
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
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(width: 1.5, color: Colors.grey[400],)
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
                                              color: Theme.of(context).primaryColorDark,
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
                ],
                ),
              ),
            ]
          )
        )
      )
    );
  }
}
