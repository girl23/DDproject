class UserModel{
  String _username;
  String _realName;
  String _userId;

  //登录信息是否成功
  String _result;
  String _token;
  String _locked;
  String _passCheckRtn;

  String get username => _username;
  String get realName => _realName;
  String get userId => _userId;
  String get token => _token;
  String get result => _result;
  String get locked => _locked;
  String get passCheckRtn => _passCheckRtn;

  UserModel(this._username,this._realName,this._token,this._userId,this._result,this._locked,this._passCheckRtn);

  UserModel.fromJson(Map<String,dynamic> json){
    _username = json['username'];
    _realName = json['realname'];
    _userId =  json['userid'];
    _token = json['token'];
    _result = json['result'];
    _locked = json['locked'];
    _passCheckRtn = json['passcheckrtn'];

  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['username'] = this._username;
    data['realname'] = this._realName;
    data['userid'] = this._userId;
    data['token'] = this._token;
    data['result'] = this._result;
    data['locked'] = this._locked;
    data['passcheckrtn'] = this._passCheckRtn;

    return data;
  }
}