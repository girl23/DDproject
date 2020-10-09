import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/config/global.dart';
import 'package:lop/service/dd/approve/approve_dd_service.dart';
import 'package:lop/service/dd/approve/approve_dd_service_impl.dart';
import 'package:lop/viewmodel/dd/ddlist_viewmodel.dart';
import 'package:provider/provider.dart';

class ApproveDDViewModel extends BaseViewModel with ChangeNotifier {
  DDListViewModel ddListVM=Provider.of<DDListViewModel>(BaseViewModel.appContext,listen: false);
  ApproveDDService _service = ApproveDDServiceImpl();

  Future<bool> approve(String ddId,String approvedDate) async {
    NetworkResponse response = await _service.approve(ddId,approvedDate);

    if (response.isSuccess) {
      ddListVM.getList('DD',page:'1');
      return true;
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }
}