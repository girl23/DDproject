import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/troubleShooting/trouble_shooting_service.dart';
import 'package:lop/service/dd/troubleShooting/trouble_shooting_service_impl.dart';

class TroubleShootingViewModel extends BaseViewModel with ChangeNotifier {

  TroubleShootingService _service = TroubleShootingServiceImpl();

  Future<bool> shooting(String ddId) async {
    NetworkResponse response = await _service.shooting(ddId);
    if (response.isSuccess) {
      return true;
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}