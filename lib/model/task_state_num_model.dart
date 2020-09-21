class TaskStateNumModel{
  String _unAccept;
  String _unFinish;
  String _finished;
  String _unRelease;
  String _released;

  String _result;
  String _info;

  String get unAccept =>_unAccept;
  String get unFinish => _unFinish;
  String get finished => _finished;
  String get unRelease => _unRelease;
  String get released => _released;
  String get result => _result;
  String get info => _info;

  TaskStateNumModel.fromJson(Map<String,dynamic> json){
    print('Numjson${json}');
    _unAccept = json['unaccept'];
    _unFinish = json['unfinish'];
    _finished =  json['finished'];
    _unRelease = json['unrelease'];
    _released = json['released'];

    _result = json['result'];
    _info = json['info'];

  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['unaccept'] = this._unAccept;
    data['unfinish'] = this._unFinish;
    data['finished'] = this._finished;
    data['unrelease'] = this._unRelease;
    data['released'] = this._released;
    data['result'] = this._result;
    data['info'] = this._info;

    return data;
  }
}