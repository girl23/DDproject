///我的消息未读消息和已读消息数据处理
import 'package:lop/model/message_model.dart';

class MessageListModel {
  String result;
  List<MessageModel> unReadData=[];
  List<MessageModel> readData=[];

  MessageListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['msglist'] != null) {
      unReadData = List<MessageModel>();
      readData = List<MessageModel>();
      json['msglist'].forEach((v) {
        if (v['read'] == "1") {
          readData.add(MessageModel.fromJson(v));
        } else {
          unReadData.add(MessageModel.fromJson(v));
        }
      });
    }
  }

  MessageListModel() {}
}
