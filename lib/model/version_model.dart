
class VersionModel{
  String _result;
  bool _isUpdate;
  bool _isForce;
  String _content;
  String _version;
  String _url;

  String get result => _result;
  bool get isUpdate => _isUpdate;
  bool get isForce => _isForce;
  String get content => _content;
  String get url => _url;
  String get version => _version;

  VersionModel();
  VersionModel.fromJson(Map<String,dynamic> json){
    _result = json['result'];
    _isUpdate = json['isUpdate'];
//    _isForce = json['isForce'];
    _isForce = true;
    _content = json['content'];
    _url = json['url'];
    _version = json['version'];
  }
}