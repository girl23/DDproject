///同TaskModel，josn中key值不同
class TaskModelOther {
  String mdLayoverTaskId;
  String acReg="";
  String taskType;
  String acPlace;
  String acPlacePf;
  String arriveFlightNo;
  String arriveTimeReal;
  String arriveTimePre;
  String arriveTimePlan;
  String udf1;
  String acType;
  String leaveFlightNo;
  String leaveTimeReal;
  String leaveTimePre;
  String leaveTimePlan;

  TaskModelOther();

  TaskModelOther.fromJson(Map<String, dynamic> json) {
    updateFormJson(json);
  }

  void updateFormJson(Map<String, dynamic> json) {
    mdLayoverTaskId = json['mdlayovertaskid'];
    acReg = json['acreg'];
    taskType = json['tasktype'];
    acPlace = json['acplace'];
    acPlacePf = json['acplacepf'];
    arriveFlightNo = json['arriveflightno'];
    arriveTimeReal = json['arrivetimereal'];
    arriveTimePre = json['arrivetimepre'];
    arriveTimePlan = json['arrivetimeplan'];
    acType = json['actype'];
    leaveFlightNo = json['leaveflghtno'];
    leaveTimeReal = json['leavetimereal'];
    leaveTimePre = json['leavetimepre'];
    leaveTimePlan = json['leavetimeplan'];
  }
}
