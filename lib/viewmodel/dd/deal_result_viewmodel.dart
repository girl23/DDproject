import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/result/deal_result_service.dart';
import 'package:lop/service/dd/result/deal_result_service_impl.dart';

class DealResultViewModel extends BaseViewModel with ChangeNotifier {

  DealResultService _service = DealResultServiceImpl();

  Future<bool> result(String ddId,String dealRes) async {
    NetworkResponse response = await _service.result(ddId,dealRes);
    if (response.isSuccess) {
      return true;
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}