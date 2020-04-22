import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sanium_app/tools/JobOffer.dart';


class BookmarkController{
  Map<int,JobOffer> bookmarks;
  List<int> keys;

  BookmarkController(){
    keys = new List();
    bookmarks = new Map();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/bookmarks.txt');
  }

  Future<File> writeBookmarks(String keys) async {
    final file = await _localFile;
    if (await file.exists()) {
    }
    return file.writeAsString(keys);
  }

  Future<List<int>> readBookmarks() async {
    var contents;
    List<int> output = new List();
    final file = await _localFile;

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


  void setBookmarks(List<JobOffer>list)async{
    dynamic keys = await readBookmarks();
    List<JobOffer>output = new List();
    if(bookmarks.keys.length != null){
      for(JobOffer o in list){
        if(keys.contains(o.id)){
          o.isBookmark = true;
        }
        output.add(o);
      }
    }
    this.keys = keys;
    list = output;
  }


  void addBookmark(JobOffer offer)async{
    // bookmarks[offer.id.toInt()]=offer;
    // print(bookmarks.keys.toString());
    this.keys = await readBookmarks(); // read keys
    keys.add(offer.id.toInt());       // add new key
    writeBookmarks(keys.toString());  // save keys
  }

  void removeBookmark(int id)async{
    // bookmarks.remove(id);
    this.keys = await readBookmarks(); // read keys
    this.keys.remove(id);              // remove key
    writeBookmarks(keys.toString());   // save keys
  }

}