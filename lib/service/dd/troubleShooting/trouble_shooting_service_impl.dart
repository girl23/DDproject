import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/dd/troubleShooting/trouble_shooting_service.dart';
import 'package:lop/model/dd/dd_public_model.dart';

class TroubleShootingServiceImpl extends BaseService implements TroubleShootingService{
  @override
  Future<NetworkResponse> shooting(String ddId) async{
    // TODO: implement delete
    Map<String,dynamic> params = new Map();
    params.addAll({Element.DD_ID:ddId});
    NetworkResponse networkResponse = await networkRequest.request<DDPublicModel>(NetworkRequest.networkMethod_GET, NetServicePath.troubleShootingRequest,params: params);
    return networkResponse;
  }
}