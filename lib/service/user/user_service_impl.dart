
import 'package:lop/config/configure.dart';
import 'package:lop/model/user_model.dart';
import 'package:lop/model/version_model.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/user/user_service.dart';

class UserServiceImpl extends BaseService implements UserService{


  @override
  Future<NetworkResponse> login(String username, String password, String macAddress) async{
    Map<String,dynamic> params = new Map();
    params.addAll({Element.USERNAME:username});
    params.addAll({Element.PASSWORD:password});
    params.addAll({Element.MAC:macAddress});

    NetworkResponse networkResponse = await networkRequest.request<UserModel>(NetworkRequest.networkMethod_POST, NetServicePath.loginRequest,params: params);
    return networkResponse;
  }

  @override
  Future<NetworkResponse> checkVersion(String platform, String version) async{
    Map<String,dynamic> params = new Map();
    params.addAll({Element.PLAT_FORM:platform});
    params.addAll({Element.VERSION:version});

    NetworkResponse networkResponse = await networkRequest.request<VersionModel>(NetworkRequest.networkMethod_GET, NetServicePath.checkVersion,params: params);
    return networkResponse;
  }

}