import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:lop/model/task_model.dart';

enum TaskState {
  forGet,
  forFinish,
  finished,
  forPass,
  passed
}

final Map<int,String> taskStateParams = {
  0:'unaccept',
  1:'unfinish',
  2:'finished',
  3:'unrelease',
  4:'released',
};

final Map<TaskState,String> taskStateTitle ={
  TaskState.forGet:'for_get',
  TaskState.forFinish:'for_finish',
  TaskState.finished:'finished',
  TaskState.forPass:'for_pass',
  TaskState.passed:'passed',
};

class TaskStateDataProvide with ChangeNotifier{
  //每个状态的数量
  Map<TaskState,String> stateNum = {
    TaskState.forGet:'0',
    TaskState.forFinish:'0',
    TaskState.finished:'0',
    TaskState.forPass:'0',
    TaskState.passed:'0',
  };

  Map<int,TaskListProvide> taskListProvide = {
    0:new TaskListProvide(),
    1:new TaskListProvide(),
    2:new TaskListProvide(),
    3:new TaskListProvide(),
    4:new TaskListProvide(),
  };

  changeStateNum(TaskState taskState,String newNum){
    stateNum[taskState] = newNum;
    notifyListeners();
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
  getTaskList(int taskIndex,List<TaskModel> list){
    taskListProvide[taskIndex].getTaskList(list);
    notifyListeners();
  }

  addTaskList(int taskIndex,List<TaskModel> list){
    if(list != null && list.length > 0){
      taskListProvide[taskIndex].addTaskList(list);
      notifyListeners();
    }

  }

  int itemCount(int index) {
    return taskListProvide[index].itemCount;
  }

  List<TaskModel> taskList(int index) {
    return taskListProvide[index].taskMap.values.toList();
  }

}
class TaskStateTabClickProvide with ChangeNotifier{
  int _tabClickIndex=0;

  int get currentTabIndex=>_tabClickIndex;
  String tabCurrentState(){
    switch (currentTabIndex){
      case 0:
        return'for_get';
        break;
      case 1:
        return'for_finish';
        break;
      case 2:
        return'finished';
        break;
      case 3:
        return'for_pass';
        break;
      case 4:
        return'passed';
        break;
    }
     return'for_get';
  }
  void setTabIndex(int index){
    _tabClickIndex=index;
    notifyListeners();
  }

}

class TaskListProvide{
  LinkedHashMap<int,TaskModel> taskMap = new LinkedHashMap();

  int get itemCount => taskMap.length;

  //获取任务列表
  getTaskList(List<TaskModel> list){
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