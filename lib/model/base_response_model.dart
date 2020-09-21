class BaseResponseModel{
  String result;
  String info;
  String proline;

  BaseResponseModel(){

  }

  BaseResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    info = json['info'];
    proline = json['proline'];
  }
}