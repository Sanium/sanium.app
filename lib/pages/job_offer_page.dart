import 'package:flutter/material.dart';
import 'package:sanium_app/data/JobOffer.dart';

class JobDetailPage extends StatefulWidget{
  final int id;
  final JobOffer data; 
  final String img;
  JobDetailPage({@required this.id, this.img, this.data});

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> with SingleTickerProviderStateMixin{
  final controller = ScrollController();
  double appBarHeight = 120.0;
  double appBarMinHeight = 60.0;

   @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

      body: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.transparent,
              showLeading: false,
              showTrailing: false,
              child: CustomScrollView(
                controller: controller,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: new Container(),
                    backgroundColor: Colors.transparent,
                    elevation: 20.0,
                    pinned: true,
                    expandedHeight: appBarHeight,
                    floating: false,
                    flexibleSpace: GestureDetector(
                      onTap: () {
                         Navigator.of(context).pop(true);
                      },
                      child: Hero(
                        tag: widget.id.toString(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                            border: Border.all(width: 1.5, color: Theme.of(context).accentColor,)
                          ),
                          child: AspectRatio(
                            aspectRatio: 3.0/1.0,
                            child: Icon(Icons.android),
                          ),
                        ),
                      ),
                    ),
                  ),

                  
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        JobMainInfo(name: widget.data.title, salary: "${widget.data.salary.salaryMin} - ${widget.data.salary.salaryMax}  ${widget.data.salary.currency} / miesiąc", city:widget.data.company.city),
                        JobAdditionalInfo(),
                        JobDetailInfo(),
                        JobContactInfo(email:widget.data.company.email, phone:widget.data.company.phone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class JobMainInfo extends StatelessWidget{
  String jobName;
  String jobSalary;
  String jobCity;

  JobMainInfo({String name:"Developer",String salary:"3000 PLN", String city:"Warszawa"}){
    this.jobName = name;
    this.jobSalary = salary;
    this.jobCity = city;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.work, size: 30.0, color: Colors.brown[800],),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            jobName,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.attach_money,size: 30.0, color: Colors.amber,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            jobSalary,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Open Sans',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      child: Icon(Icons.home,size: 30.0,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                        child: Text(
                          jobCity,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              height: 3.0,
              decoration: BoxDecoration(
                color: Colors.grey, //!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}

class JobAdditionalInfo extends StatelessWidget{
  final String jobName = "Requirements";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.tune,size: 30.0,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            jobName,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0,),
                              Icon(Icons.star,size: 25.0,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Text(
                            'Python 3',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.star,size: 25.0,color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0,color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0,color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Text(
                            'Unit Testing',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0,),
                              Icon(Icons.star,size: 25.0,),
                              Icon(Icons.star,size: 25.0,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Text(
                            'GIT',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0, color: Theme.of(context).accentColor,),
                              Icon(Icons.star,size: 25.0,),
                              Icon(Icons.star,size: 25.0,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              // height: 1.0,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,//!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}

class JobDetailInfo extends StatelessWidget{
  final String cardTitle = "Detail info";
  final String jobDetails = '''At Grape Up our mission is to help companies become cloud-native.
Our current projects are based on cooperation with international clients from various industries such as automotive, telecommunication or finance from the United States, Europe, and Asia.

Responsibilities:

Designing and building Cloud-Native Applications using Python/Flask and AWS services
Migrating applications to modern microservices-based architectures
Integrating various services (databases, storage, APIs) into cloud applications
Creating pipelines and script for CI/CD using e.g. Jenkins and Terraform

Requirements:

Understanding of web applications design principles (twelve-factor applications) and microservice-based architectures
Knowledge of relational databases (PostgreSQL)
Knowledge of unit testing and mocking libraries
Experience with modern development tools (ideally pip, Git, pycharm, CI servers, Confluence (or other wikis), JIRA (or other trackers), code review tools, SCA tools)
Bash basics
Very good command of English
Good communication skills
Open for new technologies''';


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.info_outline, size: 30.0,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            cardTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 0.0),
                          child: Text(
                            jobDetails,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              // height: 1.0,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,//!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}

class JobContactInfo extends StatelessWidget{
  final String cardTitle = "Contact info";
  String companyEmail;
  int companyPhone;

  JobContactInfo({String email:'getjob@gmail.com', int phone:900900900}){
    this.companyEmail = email;
    this.companyPhone = phone;
  }

  Widget createField(String title, String value, BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: RichText(
                    text: TextSpan(
                      text: '$title:   ',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Open Sans',
                        fontSize: 22,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: '$value', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
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
    return Card(
      elevation: 5.0,
      child: Container(
        height: 140,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Icon(Icons.mail_outline, size: 30.0,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                          child: Text(
                            cardTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Open Sans',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            createField("Email", "$companyEmail", context),

            createField("Phone", "$companyPhone", context),

            Container(
              height: 5.0,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,//!  create accentColorLight
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(height: 0.0,),
            ),
          ],
        ),
      ),
    );
  }
}