class TaskAssignTask {
  int taskAssignId;
  String taskNo;
  String taskState;
  String taskType;
  String workType;
  int itemId;
  String dataType;
  String jcType;
  String description;
  String jcId;
  String layoverJcId;
  String isCancel;
  String jcState;
  int isShiftTo;
  String taskAcReg;
  String jcAcReg;
  String isOfflineProcessing;

  TaskAssignTask() {
  }

  TaskAssignTask.fromJson(Map<String, dynamic> json) {
    taskAssignId = json['taskAssignId'];
    taskNo = json['taskNo'];
    taskState = json['taskState'];
    taskType = json['taskType'];
    workType = json['workType'];
    itemId = json['itemId'];
    dataType = json['dataType'];
    jcType = json['jcType'];
    description = json['description'];
    jcId = json['jcId'];
    layoverJcId = json['layoverJcId'];
    isCancel = json['isCancel'];
    jcState = json['jcState'];
    isShiftTo = json['isShiftTo'];
    taskAcReg = json['taskAcReg'];
    jcAcReg = json['jcAcReg'];
    isOfflineProcessing = json['isOfflineProcessing'];
  }
}
