import 'package:lop/config/configure.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/model/message_unread_model.dart';
import 'unread_message_service.dart';
class UnreadMessageServiceImpl extends BaseService implements UnreadMessageService{

  @override
  Future<NetworkResponse> unreadMessage()async{
    NetworkResponse networkResponse = await networkRequest.request<MessageUnreadModel>(NetworkRequest.networkMethod_GET, NetServicePath.getUnreadMsgCount);
    return networkResponse;
  }
}