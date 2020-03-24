class Requirement{
  String name;
  int level;//1-5
  Requirement(String name, String level){
    this.name = name;
    this.level = int.parse(level);
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
  String name;
  String city;
  String email;
  String website;
  Company(String companyName, String city, String email, String website){
    this.name = companyName;
    this.city = city;
    this.email = email;
    this.website = website;
    // print('${this.name} - ${this.city} ${this.email} ${this.website}');
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

  JobOffer(int id, String title, Salary salary, Company company, String mainTechnology, List<Requirement> requirements, String description, String logo){
    this.id = id;
    this.title = title;
    this.salary = salary;
    this.company = company;
    this.mainTechnology = mainTechnology;
    this.requirements = requirements;
    this.description = description;
    this.logo = logo;
  }
}

List<Requirement> createRequirementList1(dynamic requirements){
  List<Requirement> tempRequirementList = new List();
  requirements.forEach((k,v)=>tempRequirementList.add(Requirement(requirements[k]['name'].toString(), requirements[k]['level'].toString())));
  return tempRequirementList;
}

List<Requirement> createRequirementList2(dynamic requirements){
  List<Requirement> tempRequirementList = new List();
  if(requirements != null){
    for(dynamic v in requirements){
      tempRequirementList.add(Requirement(v['name'].toString(), v['level'].toString()));
    }
  }
  return tempRequirementList;
}

List<JobOffer> createJobList1(Map<String, dynamic> offers){
  List<JobOffer> tempJobOfferList = new List();
  offers.forEach((k,v)=>tempJobOfferList.add(
    new JobOffer(
      int.parse(k),
      v['title'], 
      new Salary(salaryFrom: v['salaryMin'], salaryTo: v['salaryMax'], currency: v['currency']),
      new Company(v['company'], v['city'], v['email'], v['phone'].toString()), 
      v['technology'],
      createRequirementList1(v['requirements']),
      v['description'],
      ''
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
        v['id'],
        v['name'], 
        new Salary(salaryFrom: v['salary_from'] == null ? '0.0': v['salary_from'].toString(), salaryTo: v['salary_to'] == null ? '0.0' : v['salary_to'].toString(), currency: v['currency'] == null ? 'PLN' : v['currency'].toString()),
        new Company(v['employer']['name'], v['city'], v['contact'], v['employer']['website']), 
        v['technology'],
        createRequirementList2(v['tech_stack']),
        v['description'],
        v['employer']['logo']
      )
    );
  }
  return tempJobOfferList;
}