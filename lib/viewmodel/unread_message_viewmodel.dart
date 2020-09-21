import 'package:flutter/material.dart';
import 'package:lop/model/message_unread_model.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/model/message_unread_model.dart';
import 'package:lop/service/unreadmessage/unread_message_service.dart';
import 'package:lop/service/unreadmessage/unread_message_service_impl.dart';
class UnreadMessageViewModel extends BaseViewModel with ChangeNotifier{
  UnreadMessageService _service = UnreadMessageServiceImpl();
  String _count;
  String  get count => _count ?? '';
  Future<bool> unreadMessage() async{
    NetworkResponse response =  await _service.unreadMessage();

    if(response.isSuccess){
      if (response.data.result == 'success') {
        print('unreadmsg success data = ${response.data.toJson()}');
        MessageUnreadModel m=response.data;
        _count=m.count;
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
