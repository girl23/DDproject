class TaskModel {
  String _state;
  int _mdLayoverTaskId;
  String _acReg;
  String _taskType;
  String _acPlace;
  String _acPlacePf;
  String _arriveFlightNo;
  int _arriveTimeReal;
  int _arriveTimePre;
  int _arriveTimePlan;
  String _udf1;
  String _udf5;
  String _acType;
  String _leaveFlightNo;
  int _leaveTimeReal;
  int _leaveTimePre;
  int _leaveTimePlan;
  String _handShiftInfo;
  String _recieveShiftInfo;
  int _delFlag;
  String _arrApt;

  String get state => _state;
  int get mdLayoverTaskId => _mdLayoverTaskId;
  String get acReg => _acReg;
  String get taskType => _taskType;
  String get acPlace => _acPlace;
  String get acPlacePf => _acPlacePf;
  String get arriveFlightNo => _arriveFlightNo;
  int get arriveTimeReal => _arriveTimeReal;
  int get arriveTimePre => _arriveTimePre;
  int get arriveTimePlan => _arriveTimePlan;
  String get udf1 => _udf1;
  String get udf5 => _udf5;
  String get acType => _acType;
  String get leaveFlightNo => _leaveFlightNo;
  int get leaveTimeReal => _leaveTimeReal;
  int get leaveTimePre => _leaveTimePre;
  int get leaveTimePlan => _leaveTimePlan;
  String get handShiftInfo => _handShiftInfo;
  String get recieveShiftInfo => _recieveShiftInfo;
  int get delFlag => _delFlag;
  String get arrApt => _arrApt;
  TaskModel() {}

  @override
  TaskModel.fromJson(Map<String, dynamic> json) {
    _state = json['state'];
    _mdLayoverTaskId = json['mdLayoverTaskId'];
    _acReg = json['acReg'];
    _taskType = json['taskType'];
    _acPlace = json['acPlace'];
    _acPlacePf = json['acPlacePf'];
    _arriveFlightNo = json['arriveFlightNo'];
    _arriveTimeReal = json['arriveTimeReal'];
    _arriveTimePre = json['arriveTimePre'];
    _arriveTimePlan = json['arriveTimePlan'];
    _udf1 = json['udf1'];
    _udf5 = json['udf5'];
    _acType = json['acType'];
    _leaveFlightNo = json['leaveFlghtNo'];
    _leaveTimeReal = json['leaveTimeReal'];
    _leaveTimePre = json['leaveTimePre'];
    _leaveTimePlan = json['leaveTimePlan'];
    _handShiftInfo = json['handShiftInfo'];
    _recieveShiftInfo = json['recieveShiftInfo'];
    _delFlag = json['delFlag'];
    _arrApt = json['arrApt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['mdLayoverTaskId'] = this._mdLayoverTaskId;
    data['acReg'] = this._acReg;
    data['taskType'] = this._taskType;
    data['acPlace'] = this._acPlace;
    data['acPlacePf'] = this._acPlacePf;
    data['arriveFlightNo'] = this._arriveFlightNo;
    data['arriveTimeReal'] = this._arriveTimeReal;
    data['arriveTimePre'] = this._arriveTimePre;
    data['arriveTimePlan'] = this._arriveTimePlan;
    data['udf1'] = this._udf1;
    data['udf5'] = this._udf5;
    data['acType'] = this._acType;
    data['leaveFlightNo'] = this._leaveFlightNo;
    data['leaveTimeReal'] = this._leaveTimeReal;
    data['leaveTimePre'] = this._leaveTimePre;
    data['leaveTimePlan'] = this._leaveTimePlan;
    data['handShiftInfo'] = this._handShiftInfo;
    data['recieveShiftInfo'] = this._recieveShiftInfo;
    data['delFlag'] = this._delFlag;
    data['arrApt'] = this._arrApt;
    return data;
  }
}
