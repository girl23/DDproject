import 'package:lop/config/configure.dart';
import 'package:lop/model/material_list_model.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/materialsearch/material_search_service.dart';

class MaterialSearchSearchImpl extends BaseService implements MaterialSearchService{

  @override
  Future<NetworkResponse> searchMatList(String matpn) async{
    Map<String,dynamic> params = new Map();
    params.addAll({Element.MATPN:matpn});

    NetworkResponse networkResponse = await networkRequest.request<MaterialListModel>(NetworkRequest.networkMethod_GET, NetServicePath.searchMatList,params: params);
    return networkResponse;
  }

}