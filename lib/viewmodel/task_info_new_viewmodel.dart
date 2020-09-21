///获取我的任务tab相关数据
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';

import 'package:lop/model/task_state_num_model.dart';

import 'package:lop/service/mytask/task_info_new_service.dart';
import 'package:lop/service/mytask/task_info_new_service_impl.dart';

import 'package:lop/config/enum_config.dart';
import 'package:lop/viewmodel/task_list_viewmodel.dart';
import 'package:provider/provider.dart';

//国际化字段
final Map<TaskState,String> taskStateTitle ={
  TaskState.forGet:'for_get',
  TaskState.forFinish:'for_finish',
  TaskState.finished:'finished',
  TaskState.forPass:'for_pass',
  TaskState.passed:'passed',
};
class TaskInfoNewViewModel extends BaseViewModel with ChangeNotifier{
  int tabIndex = 0;
  TaskInfoNewService _service = TaskInfoNewServiceImpl();
  //定义储存状态对应对数据量
  Map<TaskState,String> stateNum = {
    TaskState.forGet:'0',
    TaskState.forFinish:'0',
    TaskState.finished:'0',
    TaskState.forPass:'0',
    TaskState.passed:'0',
  };
  //获取数据
  Future<bool> fetchTaskInfoNew() async{
    NetworkResponse response =  await _service.fetchTaskInfoNew();
    if(response.isSuccess){
      //存储对应数据
      if (response.data.result == 'success') {
        TaskStateNumModel data=response.data;
        print('@@@@@Num${data.unAccept}==${data.unFinish}==${data.finished}==${data.unRelease}====${data.released}');

        _changeStateNum(TaskState.forGet,data.unAccept);
        _changeStateNum(TaskState.forFinish, data.unFinish);
        _changeStateNum(TaskState.finished, data.finished);
        _changeStateNum(TaskState.forPass, data.unRelease);
        _changeStateNum(TaskState.passed, data.released);
        return true;
      }else{
        return false;
      }
    }else{
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }

  }

  //更改数量
  _changeStateNum(TaskState taskState,String newNum){
    stateNum[taskState] = newNum;
//    print('设置后${data.unAccept}==${data.unFinish}==${data.finished}==${data.unRelease}====${data.released}');

    notifyListeners();
  }
  Future<dynamic> refreshData(bool isMore,BuildContext context) async {
    print("refreshData start");
    await fetchTaskInfoNew();
    //获取任务列表

    int page = isMore
        ? (Provider.of<TaskListViewModel>(context, listen: false)
        .itemCount(tabIndex) /
        10)
        .floor() +
        1
        : 1;
    String state = taskStateParams[tabIndex];
    await Provider.of<TaskListViewModel>(context, listen: false).fetchTaskList(
        state, tabIndex, page, 10, isMore);
    print("refreshData finish");
  }
}
