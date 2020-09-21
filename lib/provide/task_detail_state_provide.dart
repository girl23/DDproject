import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lop/model/task_detail_model.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/viewmodel/task_info_new_viewmodel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../utils/loading_dialog_util.dart';

class TaskDetailStateProvide with ChangeNotifier{
  TaskDetailModel _taskDetail;
  String taskId;
  String udf1;
  String acReg;
  EasyRefreshController refreshController;
  ProgressDialog _progressDialog;

  TaskDetailStateProvide(){
    _taskDetail = new TaskDetailModel();
    refreshController = new EasyRefreshController();
  }
  TaskDetailModel get taskDetail => _taskDetail;


  void updateArgs(String taskId,String udf1,String acReg){
    this.taskId = taskId;
    this.udf1 = udf1;
    this.acReg = acReg;
  }

  updateTaskDetail(BuildContext context,{openDetail=false, showProgressDialog=false})async {
    print('------------------- task_detail_page_updateTaskDetail ----------------------------');
    Set<Future> futures = Set<Future>();
    if(openDetail){
      futures.add(_openDetail(context));
    }
    futures.add(_updataData(context, showProgressDialog));
    await Future.wait(futures);
  }
  Future<void> _openDetail(BuildContext context) async{
    await Application.router.navigateTo(context, Routes.taskDetailsPage,transition: TransitionType.fadeIn);
//    print("_openDetail result");
    Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(false, context);
  }
  Future<void> _updataData(BuildContext context,showProgressDialog) async{
    _progressDialog = LoadingDialogUtil.createProgressDialog(context);
    if(showProgressDialog) await _progressDialog.show();
    await DioManager().request(
        httpMethod.GET, NetServicePath.getTaskAssignInfo, context,
        params: {'taskid': taskId, 'udf1': udf1, 'acid': acReg},
        success: (data) async {
          String json = data.toString();
          if (data['result'] == 'success') {
            _taskDetail = TaskDetailModel();
            //获取数据成功
            _taskDetail.updateFormJson(data);
          }
        }, error: (error) {
      ToastUtil.makeToast(error.message,toastType: ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    }).whenComplete(() {
      notifyListeners();
      if(showProgressDialog) _progressDialog.hide();
    });
  }
}