import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/dd/approve/approve_dd_service.dart';
import 'package:lop/model/dd/dd_public_model.dart';

class ApproveDDServiceImpl extends BaseService implements ApproveDDService{
  @override
  Future<NetworkResponse> approve(String ddId,String approvedDate) async{
    // TODO: implement delete
    Map<String,dynamic> params = new Map();
    params.addAll({Element.APPROVE_DATE:approvedDate});
    params.addAll({Element.DD_ID:ddId});
    NetworkResponse networkResponse = await networkRequest.request<DDPublicModel>(NetworkRequest.networkMethod_GET, NetServicePath.ddApproveRequest,params: params);
    return networkResponse;
  }
}