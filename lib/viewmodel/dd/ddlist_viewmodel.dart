///dd列表
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/model/dd/dd_list_model.dart';
import 'package:lop/service/dd/ddlist/get_ddlist_service_impl.dart';
import 'package:lop/service/dd/ddlist/get_ddlist_service.dart';

class DDListViewModel extends BaseViewModel with ChangeNotifier{

  //获取列表数据
  GetDDListService _service = GetDDListServiceImpl();
  DDListModel _ddList = new DDListModel();

//  MessageListModel get messageList => _messageList ?? null;
  Future<bool> getList(String ddLB,{bool all,String ddNo, String acReg, String state}) async{
    NetworkResponse response =  await _service.getList(ddLB);
    if(response.isSuccess){
      if (response.data.result == 'success') {
//        _messageList=response.data;
//        notifyListeners();
        return true;
      }else{
        return false;
      }
    }else{
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}
