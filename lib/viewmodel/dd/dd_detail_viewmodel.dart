
///删除dd
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/service/dd/detail/dd_detail_service.dart';
import 'package:lop/service/dd/detail/dd_detail_service_impl.dart';
import 'package:lop/model/dd/dd_detail_model.dart';

class DDDetailViewModel extends BaseViewModel with ChangeNotifier {
    DDDetailModel _detailModel;
    DDDetailService _service = DDDetailServiceImpl();

    DDDetailModel get detailModel => _detailModel;

  Future<bool> fetchDetail(String ddId) async {
    NetworkResponse response = await _service.fetchDetail(ddId);

    if (response.isSuccess) {
      _detailModel=response.data;
      notifyListeners();
      return true;
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}