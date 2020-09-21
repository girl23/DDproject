class TaskAssignJcOther {
  int id;
  String jcType;
  String workType;
  int layoverJcId;
  String jcNumber;
  String description;

  TaskAssignJcOther() {
  }

  TaskAssignJcOther.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jcType = json['jcType'];
    layoverJcId = json['layoverJcId'];
    workType = json['worktype'];
    jcNumber = json['jcNumber'];
    description = json['description'];
  }
}
