///修改密码
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/changepassword/change_password_service.dart';
import 'package:lop/service/changepassword/change_password_service_impl.dart';
class ChangePasswordViewModel extends BaseViewModel with ChangeNotifier{
  ChangePasswordService _service = ChangePasswordServiceImpl();

  Future<bool> change(String oldPwd,String newPwd) async{
    NetworkResponse response =  await _service.change(oldPwd, newPwd);

    if(response.isSuccess){
      if (response.data.result == 'success') {

        notifyListeners();
        return true;
      }else{
        return false;
      }
    }else{
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }

  }

}
