//import 'package:flutter/material.dart';
//
//class DDCalculateHourProvide with ChangeNotifier{
//  String _totalCycle;//总飞行循环
//  String _spaceCycle;//间隔循环
//  String _endCycle;
//  String fetchEndCycle(String startStr,String spaceStr){
//    int start=int.parse(startStr);
//    int space=int.parse(spaceStr);
//    int end=start+space;
//    return end.toString();
//  }
//  String fetchSpaceCycle(String startStr,String endStr){
//    int start=int.parse(startStr);
//    int end=int.parse(endStr);
//    int space=end-start;
//    return space.toString();
//
//  }
//  String fetchStartCycle(String endStr,String spaceStr){
//    int space=int.parse(spaceStr);
//    int end=int.parse(endStr);
//    int start=end-space;
//    return start.toString();
//  }
//  void calculateCycle({String trigger}){
//
//    //起始+间隔
//    if(_totalCycle.length>0&&_spaceCycle.length>0&&_endCycle==null){
//      print('起始+间隔');
//      _endCycle=this.fetchEndCycle(_totalCycle,_spaceCycle);
//      notifyListeners();
//      return;
//    }
//    //起始+到期
//    if(_totalCycle.length>0&&_spaceCycle==null&&_endCycle.length>0){
//      print('起始+到期');
//      _spaceCycle=this.fetchSpaceCycle(_totalCycle,_endCycle);
//      notifyListeners();
//
//      return;
//    }
//    //间隔+到期
//    if(_totalCycle==null&&_spaceCycle.length>0&&_endCycle.length>0){
//      print('间隔+到期');
//      _totalCycle=this.fetchStartCycle(_endCycle, _spaceCycle);
//      notifyListeners();
//      return;
//    }
//    //更改
//    if((_totalCycle.length>0&&_spaceCycle.length>0&&_endCycle.length>0)&&trigger=='start'){
//      print('==start');
//      //起始更改，间隔不变，自动计算到期
//      _endCycle=this.fetchEndCycle(_totalCycle,_spaceCycle);
//      notifyListeners();
//      return;
//    }
//    if((_totalCycle.length>0&&_spaceCycle.length>0&&_endCycle.length>0)&&trigger=='space'){
//      print('==space');
//      //间隔更改，起始不变，自动计算到期
//      _endCycle=this.fetchEndCycle(_totalCycle,_spaceCycle);
//      notifyListeners();
//
//      return;
//    }
//    if((_totalCycle.length>0&&_spaceCycle.length>0&&_endCycle.length>0)&&trigger=='end'){
//      print('==end');
//      //到期更改，起始不变，自动计算间隔
//      _spaceCycle=this.fetchSpaceCycle(_totalCycle, _endCycle);
//      notifyListeners();
//
//      return;
//    }
//  }
//}