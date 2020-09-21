///设置已读消息
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/mymessagedetail/set_message_read_service.dart';
import 'package:lop/service/mymessagedetail/set_message_read_service_impl.dart';

import 'package:lop/viewmodel/unread_message_viewmodel.dart';
import 'package:lop/viewmodel/search_my_message_viewmodel.dart';
import 'package:provider/provider.dart';
class SetMessageReadViewModel extends BaseViewModel with ChangeNotifier{
  SetMessageRead _service = SetMessageReadImpl();
  String  searchTitle;
  UnreadMessageViewModel _unreadMessageViewModel= Provider.of<UnreadMessageViewModel>(BaseViewModel.appContext,listen: false);
  SearchMessageModel _searchMessageModel=Provider.of<SearchMessageModel>(BaseViewModel.appContext,listen: false);
  Future<bool> setMessageRead(String msgId) async{
    NetworkResponse response =  await _service.setMessageRead(msgId);

    if(response.isSuccess){
      if (response.data.result == 'success') {
        //访问未读消息接口
        _unreadMessageViewModel.unreadMessage();
        //调用我的消息接口刷新数据
        _searchMessageModel.searchMessage(searchTitle);
        notifyListeners();
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