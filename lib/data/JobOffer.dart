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
  Salary(double salaryMin, double salaryMax, String currency){
    this.salaryMin = salaryMin;
    this.salaryMax = salaryMax;
    this.currency = currency;
  }
}

class Company{
  String name;
  String city;
  String email;
  int phone;
  Company(String companyName, String city, String email, int phone){
    this.name = companyName;
    this.city = city;
    this.email = email;
    this.phone = phone;
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
  String img;

  JobOffer(int id, String title, Salary salary, Company company, String mainTechnology, List<Requirement> requirements, String description){
    this.id = id;
    this.title = title;
    this.salary = salary;
    this.company = company;
    this.mainTechnology = mainTechnology;
    this.requirements = requirements;
    this.description = description;
  }
}

List<Requirement> createRequirementList(dynamic requirements){
  List<Requirement> tempRequirementList = new List();
  // requirements.forEach((k,v)=>print("${requirements['$k']['name']} ${requirements['$k']['level']}"));
  requirements.forEach((k,v)=>tempRequirementList.add(Requirement(requirements[k]['name'], requirements[k]['level'])));
  return tempRequirementList;
}

List<JobOffer> createJobList(Map<String, dynamic> offers){
  List<JobOffer> tempJobOfferList = new List();
  offers.forEach((k,v)=>tempJobOfferList.add(
    new JobOffer(
      int.parse(k),
      v['title'], 
      new Salary(double.parse(v['salaryMin']), double.parse(v['salaryMax']), v['currency']),
      new Company(v['company'], v['city'], v['email'], int.parse(v['phone'])), 
      v['technology'],
      createRequirementList(v['requirements']),
      v['description']
    )
  ));
  return tempJobOfferList;
}