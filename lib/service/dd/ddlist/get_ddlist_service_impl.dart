import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/dd/ddlist/get_ddlist_service.dart';
import 'package:lop/model/dd/dd_list_model.dart';

class GetDDListServiceImpl extends BaseService implements GetDDListService{
  @override
  Future<NetworkResponse> getList(String ddLB,{bool all,String ddNo, String acReg, String state,String page,}) async{
    // TODO: implement getList
    Map<String,dynamic> params = new Map();
    params.addAll({Element.DD_LB:ddLB});
    params.addAll({Element.PAGE:page});
    params.addAll({Element.ROWS:"10"});
    params.addAll({Element.SORT:''});
    params.addAll({Element.ORDER:'desc'});
    if(!all){
      params.addAll({Element.DD_NO:ddNo});
      params.addAll({Element.acReg:acReg});
      params.addAll({Element.state:state});
    }
    NetworkResponse networkResponse = await networkRequest.request<DDListModel>(NetworkRequest.networkMethod_GET, NetServicePath.ddListRequest,params: params);
    return networkResponse;
  }


}