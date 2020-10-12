import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/dd/close/close_dd_service.dart';
import 'package:lop/model/dd/dd_public_model.dart';

class CloseDDServiceImpl extends BaseService implements CloseDDService{
  @override
  Future<NetworkResponse> close(String ddId) async{
    // TODO: implement delete
    Map<String,dynamic> params = new Map();
    params.addAll({Element.DD_ID:ddId});
    NetworkResponse networkResponse = await networkRequest.request<DDPublicModel>(NetworkRequest.networkMethod_GET, NetServicePath.closeDDRequest,params: params);
    return networkResponse;
  }
}
