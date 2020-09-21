import 'package:flutter/material.dart';
///控制底部tabBar显示隐藏
class BottomBarStateProvide extends ChangeNotifier {
  bool _shouldShowBottomBar=true;

  bool get shouldShowBottomBar=>_shouldShowBottomBar;


  void showBottomBar(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      _shouldShowBottomBar = true;
      notifyListeners();
    });
  }

  void hideBottomBar(){
    _shouldShowBottomBar = false;
    notifyListeners();
  }

}