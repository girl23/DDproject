import 'package:lop/config/configure.dart';
import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';

import 'package:lop/service/changepassword/change_password_service.dart';
import 'package:lop/model/change_password_model.dart';

class ChangePasswordServiceImpl extends BaseService implements ChangePasswordService{
  @override
  Future<NetworkResponse> change(String oldPwd, String newPwd) async{
    Map<String,dynamic> params = new Map();
    params.addAll({Element.ROLE:'Admin'});
    params.addAll({Element.PASSWORD:oldPwd});
    params.addAll({Element.NEW_PASSWORD:newPwd});

    NetworkResponse networkResponse = await networkRequest.request<ChangePwdModel>(NetworkRequest.networkMethod_GET, NetServicePath.changePwdRequest,params: params);
    return networkResponse;
  }

}