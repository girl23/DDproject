class ResetPasswordModel{
  String result;
  String message;
  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    result = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    return data;
  }
}