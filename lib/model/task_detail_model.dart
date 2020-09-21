
import 'package:lop/model/task_assign_jc_other.dart';
import 'package:lop/model/task_assign_task.dart';
import 'package:lop/model/task_model_other.dart';

class TaskDetailModel{
  String result;
  String isFirstShift;
  String isThird;
  String acPlacePf;
  String state;
  String remark;
  String notice;
  String shiftInfo;
  String partners;
  String personalState;

  TaskModelOther data =  TaskModelOther();
  List<TaskAssignTask> taskData = List<TaskAssignTask>();
  List<TaskAssignTask> jcData = List<TaskAssignTask>();
  List<TaskAssignJcOther> jcOtherData = List<TaskAssignJcOther>();

  TaskDetailModel();

  TaskDetailModel.fromJson(Map<String, dynamic> json) {
    updateFormJson(json);
  }

  updateFormJson(Map<String, dynamic> json){
    result = json['result'];
    isFirstShift = json['isfirstshift'];
    isThird = json['isthird'];
    acPlacePf = json['acplacepf'];
    state = json['state'];
    remark = json['remark'];
    notice = json['notice'];
    shiftInfo = json['shiftinfo'];
    partners = json['partners'];
    personalState = json['personalstate'];
    data.updateFormJson(json);

    taskData.clear();
    if(json['tasklist']!=null){
      json['tasklist'].forEach((v){
        taskData.add(TaskAssignTask.fromJson(v));
      });
    }

    jcData.clear();
    if(json['itemlist']!=null){
      json['itemlist'].forEach((v){
        jcData.add(TaskAssignTask.fromJson(v));
      });
    }

    jcOtherData.clear();
    if(json['jclist']!=null){
      json['jclist'].forEach((v){
        jcOtherData.add(TaskAssignJcOther.fromJson(v));
      });
    }
  }

}