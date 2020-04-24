import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:sanium_app/tools/bookmark.dart';
import 'package:sanium_app/tools/sort_controller.dart';

class Requirement{
  String name;
  int level;//1-5
  Requirement(String name, String level){
    this.name = name;
    this.level = int.parse(level);
  }
  String toString(){
    return '{"tag":"$name"}';
  }
}

class Salary{
  double salaryMin;
  double salaryMax;
  String currency;//PLN
  Salary({String salaryFrom:'0.0', String salaryTo:'0.0', String currency:"PLN"}){
    this.salaryMin = double.parse(salaryFrom);
    this.salaryMax = double.parse(salaryTo);
    this.currency = currency;
    // print('${this.salaryMin} - ${this.salaryMax} ${this.currency}');
  }
}

class Company{
  int id;
  String name;
  String size;
  Localization local;
  String email;
  String website;
  String logo;
  Company({this.id, this.name, this.logo, this.size, this.local,this.email,this.website,});
  String toJson(){
    return '''{
    "id": ${this.id},
    "name": "${this.name}",
    "size": "${this.size}",
    "website": "${this.website}",
    "logo": "${this.logo}"
    }
    ''';
  }
}

class Localization{
  String city;
  String street;
  double latitude;
  double longnitude;
  Localization({this.city, this.street}){
    this.latitude = null;
    this.longnitude = null;
    setLocation();
  }
  void setLocation() async{
    try{
      if(this.city!=null && this.street==null){
        var addresses = await Geocoder.local.findAddressesFromQuery(this.city);
        var first = addresses.first;
        this.latitude = first.coordinates.latitude;
        this.longnitude = first.coordinates.longitude;
        print("${first.featureName} : ${first.coordinates}");
      }
      else if (this.city!=null && this.street!=null){
        var addresses = await Geocoder.local.findAddressesFromQuery("${this.city}  ${this.street}");
        var first = addresses.first;
        this.latitude = first.coordinates.latitude;
        this.longnitude = first.coordinates.longitude;
        print("${first.featureName} : ${first.coordinates}");
      }
    }
    on PlatformException{
      print('[!] PlatformException ${this.city}  ${this.street}');
      this.latitude = null;
      this.longnitude = null;
    }
  }
}

class JobOffer{
  int id;
  String title;
  Salary salary;
  Company company;
  String mainTechnology;
  List<Requirement> requirements;
  String description;
  String logo;
  String employment;
  String experience;
  bool isRemote;
  bool isBookmark;

  JobOffer({int id, String title, Salary salary, Company company, String mainTechnology, List<Requirement> requirements, String description:'', String logo:'', String employment:'', String experience:'', String remote:'0'}){
    this.id = id;
    this.title = title;
    this.salary = salary;
    this.company = company;
    this.mainTechnology = mainTechnology;
    this.requirements = requirements;
    this.description = description;
    this.logo = logo;
    this.employment = employment;
    this.experience = experience;
    this.isRemote = remote=='0'?false:true;
    this.isBookmark = false;
  }

  String toJson(){
    return '''{"id": ${this.id},\
    "name": "${this.title}",\
    "description": "${escapeDescription(this.description)}",\
    "experience": "${this.experience}",\
    "employment": "${this.employment}",\
    "technology": "${this.mainTechnology}",\
    "city": "${this.company.local.city}",\
    "street": "${this.company.local.street}",\
    "contact": "${this.company.email}",\
    "website": "${this.company.website}",\
    "salary_from": ${this.salary.salaryMin},\
    "salary_to": ${this.salary.salaryMax},\
    "currency": "${this.salary.currency}",\
    "employer": ${this.company.toJson()},\
    "tech_stack": ${requirementsToJson(this.requirements)}\
    }''';
  }
}

class JobOfferList{
  List<JobOffer> list;
  SortController sortController;
  BookmarkController bookmarkController;
  JobOfferList({List<JobOffer> list}){
    this.list = list;
    this.sortController = SortController();
    this.bookmarkController = BookmarkController();
  }

  List<JobOffer> get(){
    return this.list;
  }

  void reload() async{
    this.bookmarkController.setBookmarks(this.list);
    
  }

  void replace(List<JobOffer> newList)async{
    this.list = newList;
    await this.bookmarkController.setBookmarks(this.list);
  }

  void append(List<JobOffer> nextPart){
    this.list = this.list + nextPart;
  }

  void sort({String by:"title"}){
    String normalize(String input){
      return input.toLowerCase()
      .replaceAll('ą', 'a')
      .replaceAll('ć', 'c')
      .replaceAll('ę', 'e')
      .replaceAll('ł', 'l')
      .replaceAll('ń', 'n')
      .replaceAll('ó', 'o')
      .replaceAll('ś', 's')
      .replaceAll('ź', 'z')
      .replaceAll('ż', 'z');
    }

    if(by == "salaryMin"){
      list.sort((a,b)=>a.salary.salaryMin.compareTo(b.salary.salaryMin));
      if(sortController.getState(2)==1){
        list = new List.from(list.reversed);
      }
    }
    else if(by == "salaryMax"){
      list.sort((a,b)=>a.salary.salaryMax.compareTo(b.salary.salaryMax));
      if(sortController.getState(2)==1){
        list = new List.from(list.reversed);
      }
    }
    else if(by == "city"){
      list.sort((a,b)=>normalize(a.company.local.city).compareTo(normalize(b.company.local.city)));
      if(sortController.getState(1)==2){
        list = new List.from(list.reversed);
      }
    }
    else if(by == "technology"){
      list.sort((a,b)=>normalize(a.mainTechnology).compareTo(normalize(b.mainTechnology)));
      if(sortController.getState(0)==2){
        list = new List.from(list.reversed);
      }
    }
  }
}

List<Requirement> createRequirementPlaceholder(dynamic requirements){
  List<Requirement> tempRequirementList = new List();
  requirements.forEach((k,v)=>tempRequirementList.add(Requirement(requirements[k]['name'].toString(), requirements[k]['level'].toString())));
  return tempRequirementList;
}

List<Requirement> createRequirementList(dynamic requirements){
  List<Requirement> tempRequirementList = new List();
  if(requirements != null){
    for(dynamic v in requirements){
      tempRequirementList.add(Requirement(v['tag'].toString(), '0'));
    }
  }
  return tempRequirementList;
}

List<JobOffer> createPlaceholderList(Map<String, dynamic> offers){
  List<JobOffer> tempJobOfferList = new List();
  offers.forEach((k,v)=>tempJobOfferList.add(
    new JobOffer(
      id: int.parse(k),
      title: v['title'], 
      salary: new Salary(salaryFrom: v['salaryMin'], salaryTo: v['salaryMax'], currency: v['currency']),
      company: new Company(name:v['company'],
      local:Localization(city:v['city']), email:v['email'], website:v['phone'].toString()), 
      mainTechnology: v['technology'],
      requirements: createRequirementPlaceholder(v['requirements']),
      description: v['description'],
    )
  ));
  return tempJobOfferList;
}

List<JobOffer> createJobList2(Map<String, dynamic> offers){
  List<JobOffer> tempJobOfferList = new List();
  dynamic data = offers['data'];
  for(dynamic v in data){
    tempJobOfferList.add(
      new JobOffer(
        id: v['id'],
        title: v['name'],
        experience: v['experience'],
        employment: v['employment'],
        salary: new Salary(salaryFrom: v['salary_from'] == null ? '0.0': v['salary_from'].toString(), salaryTo: v['salary_to'] == null ? '0.0' : v['salary_to'].toString(), currency: v['currency'] == null ? 'PLN' : v['currency'].toString()),
        company: new Company(id:v['employer']['id'], name:v['employer']['name'],logo:v['employer']['logo']==null?'':v['employer']['logo'],size:v['employer']['size'], local:Localization(city: v['city'],street: v['street']), email:v['contact'], website:v['employer']['website']), 
        mainTechnology: v['technology'],
        requirements: createRequirementList(v['tech_stack']),
        description: v['description'],
        logo: v['employer']['logo']==null?'':v['employer']['logo'],
        remote: v['remote'].toString(),
      )
    );
  }
  return tempJobOfferList;
}

String requirementsToJson(List<Requirement> data){
  String output="[";
  for(Requirement r in data){
    output+=r.toString();
    output+=',';
  }
  output=output.substring(0,output.length-1);
  output+=']';
  return output;
}

String escapeDescription(String description){
  return description.replaceAll(new RegExp(r'"'), '\\"');
}