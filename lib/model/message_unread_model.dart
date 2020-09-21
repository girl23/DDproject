class MessageUnreadModel {
  String result;
  String count;

  MessageUnreadModel({this.result, this.count});

  MessageUnreadModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['count'] = this.count;
    return data;
  }
}