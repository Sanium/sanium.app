import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:sanium_app/tools/JobOffer.dart';


class BookmarkController{
  Map<int,JobOffer> bookmarks;
  List<int> keys;

  BookmarkController(){
    keys = new List();
    bookmarks = new Map();
    initData();
  }

  void initData() async {
    this.keys = await readKeys(); // read keys
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localKeysFile async {
    final path = await _localPath;
    return File('$path/bookmarks_keys.txt');
  }

  Future<File> get _localDataFile async {
    final path = await _localPath;
    return File('$path/bookmarks.txt');
  }


  //! Obsługa zakładek dla MainPage

  Future<File> writeKeys(String keys) async {
    final file = await _localKeysFile;
    if (await file.exists()) {
    }
    return file.writeAsString(keys);
  }

  Future<List<int>> readKeys() async {
    var contents;
    List<int> output = new List();
    final file = await _localKeysFile;

    if (await file.exists()) {
      contents = await file.readAsString();
      Iterable<Match> a = RegExp(r'(\d+)').allMatches(contents);
      for(Match m in a){
        output.add(int.parse(m.group(0).toString()));
      }
      // print("odczyt $output");
    }
    return output;
  }

  //ustawienie zakładek
  void setBookmarks(List<JobOffer>list)async{
    dynamic keys = await readKeys();
    List<JobOffer>output = new List();
    if(bookmarks.keys.length != null){
      for(JobOffer o in list){
        if(keys.contains(o.id)){
          o.isBookmark = true;
          this.bookmarks[o.id] = o;
        }
      }
    }
    this.keys = keys;
    list = output;
  }


  void addBookmark(JobOffer offer)async{
    bookmarks[offer.id.toInt()]=offer;
    print(bookmarks.keys.toString());
    this.keys = await readKeys();  // read keys
    keys.add(offer.id.toInt());   // add new key
    writeKeys(keys.toString());  // save keys
    writeData();
  }

  void removeBookmark(int id)async{
    bookmarks.remove(id);
    this.keys = await readKeys();  // read keys
    this.keys.remove(id);         // remove key
    writeKeys(keys.toString());  // save keys
    writeData();
  }

   //! Obsługa zakładek dla BookmarkPage

   Future<String> loadData()async{
     var data;
     final file = await _localDataFile;
     if (await file.exists()) {
        data = await file.readAsString();
     }
     return data;
   }

  void writeData() async {
    final file = await _localDataFile;
    if (await file.exists()) {
    }
    String data = '{"data":[';
    bookmarks.forEach((k,v) => data+=v.toJson()+',');
    data=data.substring(0,data.length-1);
    data+=']}';
    data = bookmarks.length>0?data:"";
    file.writeAsString(data);
  }

}