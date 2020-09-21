import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/utils/toast_util.dart';

import 'package:lop/model/task_state_list_model.dart';
import 'package:lop/service/mytask/task_list_service.dart';
import 'package:lop/service/mytask/task_list_service_impl.dart';
import 'package:lop/config/enum_config.dart';
import 'dart:collection';
import 'package:lop/model/task_model.dart';

final Map<int,String> taskStateParams = {
  0:'unaccept',
  1:'unfinish',
  2:'finished',
  3:'unrelease',
  4:'released',
};
class TaskListViewModel extends BaseViewModel with ChangeNotifier{

  TaskListService _service = TaskListServiceImpl();
  //分别处理不同状态下的数据
  Map<int,TaskListProvide> taskListProvides ={
      0:new TaskListProvide(),
      1:new TaskListProvide(),
      2:new TaskListProvide(),
      3:new TaskListProvide(),
      4:new TaskListProvide(),
    };

  //获取列表数据
  Future<bool> fetchTaskList(String state , int tabIndex,int page, int row, bool isMore) async{
    NetworkResponse response =  await _service.fetchTaskList(state, page,row);

    if(response.isSuccess){
      TaskStateListModel _taskStateListModel=response.data;
        if(isMore){
          _addTaskList(tabIndex, _taskStateListModel.data);
        }else{
          _getTaskList(tabIndex,_taskStateListModel.data);
        }
        notifyListeners();
        return true;

    }else{
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }

  }

  _getTaskList(int taskIndex,List<TaskModel> list){
//    print('_)))))))${this.hashCode}');
    taskListProvides[taskIndex].getTaskList(list);
    notifyListeners();
  }

  _addTaskList(int taskIndex,List<TaskModel> list){
    if(list != null && list.length > 0){
      taskListProvides[taskIndex].addTaskList(list);
      notifyListeners();
    }

  }
  int getUdf5Count(){
    List<TaskModel> unAccepts = taskList(0);
    int udf5Count = 0;
    if(unAccepts != null && unAccepts.isNotEmpty){
      unAccepts.forEach((model){
        if(model.udf5 == "true"){
          udf5Count++;
        }
      });
    }
    return udf5Count;
  }
  int itemCount(int index) {

    return  taskListProvides[index].itemCount!=null?taskListProvides[index].itemCount:0;
  }

  List<TaskModel> taskList(int index) {
    return taskListProvides[index].taskMap.values.toList();
  }
}

class TaskListProvide{

  LinkedHashMap<int,TaskModel> taskMap = new LinkedHashMap();

  int get itemCount => taskMap.length>0?taskMap.length:0;
  //获取任务列表
  getTaskList(List<TaskModel> list){
    print('list.length${list.length}');
    taskMap.clear();
    list.forEach((taskModel){
      taskMap.putIfAbsent(taskModel.mdLayoverTaskId,()=>taskModel);
    });
  }
  //上拉加载列表，追加列表
  addTaskList(List<TaskModel> list){
    list.forEach((taskModel){
      taskMap.update(taskModel.mdLayoverTaskId,(value)=> taskModel, ifAbsent: ()=>taskModel);
    });
  }

}