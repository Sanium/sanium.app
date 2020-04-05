import 'JobOffer.dart';


class SortController{
  List<JobOffer> dataList;
  List<int> sortButtonsStates;

  SortController(){
    this.sortButtonsStates = [0,0,0];
  }


  List<int> getStates(){
    return this.sortButtonsStates;
  }

  int getState(int id){
    return this.sortButtonsStates[id];
  }

  void resetStates(){
    for(int i=0; i<this.sortButtonsStates.length; i++){
      this.sortButtonsStates[i] = 0;
    }
  }

  void setState(int button){
    for(int i=0;i<this.sortButtonsStates.length;i++){
      if (i==button){
        if (this.sortButtonsStates[i]==0){ this.sortButtonsStates[i] = 1;}
        else if (this.sortButtonsStates[i]==1){ this.sortButtonsStates[i] = 2;}
        else if (this.sortButtonsStates[i]==2){ this.sortButtonsStates[i] = 1;}
      }
      else{ this.sortButtonsStates[i] = 0;}
    }
  }
}