class GetSmsCodeModel{
  String result;
  String phonenum;
  String message;
  String randomnum;

  GetSmsCodeModel.fromJson(Map<String, dynamic> json) {
    result = json['code'];
    phonenum = json['phonenum'];
    message = json['message'];
    randomnum = json['randomnum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['phonenum'] = this.phonenum;
    data['message'] = this.message;
    data['randomnum'] = this.randomnum;
    return data;
  }
}