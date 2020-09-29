import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/dd/detail/dd_detail_service.dart';
import 'package:lop/model/dd/dd_detail_model.dart';

class DDDetailServiceImpl extends BaseService implements DDDetailService{
  @override
  Future<NetworkResponse> fetchDetail(String ddId) async{
    // TODO: implement delete
    Map<String,dynamic> params = new Map();
    params.addAll({Element.DD_ID:ddId});

    NetworkResponse networkResponse = await networkRequest.request<DDDetailModel>(NetworkRequest.networkMethod_GET, NetServicePath.ddDetailRequest,params: params);
    return networkResponse;
  }
}
