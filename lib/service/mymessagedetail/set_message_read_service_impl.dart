import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/mymessagedetail/set_message_read_service.dart';
import 'package:lop/model/message_list_model.dart';

class SetMessageReadImpl extends BaseService implements SetMessageRead{
  @override
  Future<NetworkResponse> setMessageRead(String msgId) async{
    Map<String,dynamic> params = new Map();
    params.addAll({Element.MSG_ID:msgId});
    NetworkResponse networkResponse = await networkRequest.request<MessageListModel>(NetworkRequest.networkMethod_GET,NetServicePath.setMsgRead,params: params);
    return networkResponse;
  }

}