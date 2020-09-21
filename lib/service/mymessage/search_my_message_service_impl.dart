import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/mymessage/search_my_message_service.dart';
import 'package:lop/model/message_list_model.dart';

class SearchMyMessageImpl extends BaseService implements SearchMyMessage{
  @override
  Future<NetworkResponse> searchMessage(String title) async{
    Map<String,dynamic> params = new Map();
    params.addAll({Element.TITLE:title});

    NetworkResponse networkResponse = await networkRequest.request<MessageListModel>(NetworkRequest.networkMethod_GET,NetServicePath.searchMessageList,params: params);
    return networkResponse;
  }

}