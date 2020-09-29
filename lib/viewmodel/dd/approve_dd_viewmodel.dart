import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/approve/approve_dd_service.dart';
import 'package:lop/service/dd/approve/approve_dd_service_impl.dart';

class ApproveDDViewModel extends BaseViewModel with ChangeNotifier {

  ApproveDDService _service = ApproveDDServiceImpl();

  Future<bool> approve(String ddId) async {
    NetworkResponse response = await _service.approve(ddId);

    if (response.isSuccess) {
      return true;
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}