import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/dd/result/deal_result_service.dart';
import 'package:lop/model/dd/dd_public_model.dart';

class DealResultServiceImpl extends BaseService implements DealResultService{
  @override
  Future<NetworkResponse> result(String ddId,String dealRes)async{
    // TODO: implement result
    Map<String,dynamic> params = new Map();

    params.addAll({Element.DD_ID:ddId});
    params.addAll({Element.PROCESSING_RESULT:dealRes});
    NetworkResponse networkResponse = await networkRequest.request<DDPublicModel>(NetworkRequest.networkMethod_GET, NetServicePath.dealResultRequest,params: params);
    return networkResponse;
  }

}