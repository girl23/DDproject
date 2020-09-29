
///删除dd
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/delete/delete_dd_service_impl.dart';
import 'package:lop/service/dd/delete/delete_dd_service.dart';

class DeleteDDViewModel extends BaseViewModel with ChangeNotifier {

  DeleteDDService _service = DeleteDDServiceImpl();

  Future<bool> delete(String ddId) async {
    NetworkResponse response = await _service.delete(ddId);
    if (response.isSuccess) {
      return true;
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}