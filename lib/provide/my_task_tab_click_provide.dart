//我的任务状态变化
import 'package:flutter/material.dart';
class MyTaskTabClickProvide with ChangeNotifier{
  //tab点击对index,对应的国际化文档;
  int _tabClickIndex=0;
  int get currentTabIndex=>_tabClickIndex;
  String tabCurrentState(){
    switch (currentTabIndex){
      case 0:
        return'for_get';
        break;
      case 1:
        return'for_finish';
        break;
      case 2:
        return'finished';
        break;
      case 3:
        return'for_pass';
        break;
      case 4:
        return'passed';
        break;
    }
    return'for_get';
  }
  void setTabIndex(int index){
    _tabClickIndex=index;
    notifyListeners();
  }

}