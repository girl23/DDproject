import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/close/close_dd_service.dart';
import 'package:lop/service/dd/close/close_dd_service_impl.dart';

class CloseDDViewModel extends BaseViewModel with ChangeNotifier {

  CloseDDService _service = CloseDDServiceImpl();

  Future<bool> close(String ddId) async {
    NetworkResponse response = await _service.close(ddId);
    if (response.isSuccess) {
      return true;
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}