
import 'package:flutter/material.dart';
class TemporaryDDTransferProvide with ChangeNotifier{
  //已转未审批，临保界面显示处理结果，并禁用按钮
  bool _transfer=false;
  bool get transfer=>_transfer;

  void setTransfer(bool transfer){
    _transfer=transfer;
    notifyListeners();
  }

}