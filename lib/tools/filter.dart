
//city, exp, tech, from, to
class Filter{
  String city;
  String exp;
  String tech;
  String from;
  String to;

  Filter({String city, String exp, String tech,String salaryFrom, String salaryTo}){
    this.city = normalize(city);
    this.exp = normalize(exp);
    this.tech = normalize(tech);
    this.from = normalize(salaryFrom);
    this.to = normalize(salaryTo);
  }

  String normalize(String input){
      return input!=null?input.toLowerCase()
      .replaceAll('ą', 'a')
      .replaceAll('ć', 'c')
      .replaceAll('ę', 'e')
      .replaceAll('ł', 'l')
      .replaceAll('ń', 'n')
      .replaceAll('ó', 'o')
      .replaceAll('ś', 's')
      .replaceAll('ź', 'z')
      .replaceAll('ż', 'z'):'';}

  String createQuery(){
    String query = "?";
    if(this.city.length > 0){
      query = query +  "city=$city";
    }
    if(this.exp.length > 0){
      query = query +  "${query.length>1?'&':''}exp=$exp";
    }
    if(this.tech.length > 0){
      query = query +  "${query.length>1?'&':''}tech=$tech";
    }
    if(this.from.length > 0){
      query = query +  "${query.length>1?'&':''}from=$from";
    }
    if(this.to.length > 0){
      query = query +  "${query.length>1?'&':''}to=$to";
    }
    print(query);
    return query;
  }
}