///搜索我的消息
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/mymessage/search_my_message_service.dart';
import 'package:lop/service/mymessage/search_my_message_service_impl.dart';
import 'package:lop/model/message_list_model.dart';
import 'package:lop/model/message_model.dart';
class SearchMessageModel extends BaseViewModel with ChangeNotifier{

  SearchMyMessage _service = SearchMyMessageImpl();
  MessageListModel _messageList = new MessageListModel();

  MessageListModel get messageList => _messageList ?? null;
  Future<bool> searchMessage(String title) async{
    NetworkResponse response =  await _service.searchMessage(title);

    if(response.isSuccess){
      if (response.data.result == 'success') {
        _messageList=response.data;
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
