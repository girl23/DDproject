class MessageModel {
  String content;
  String messageRecieveId;
  String read;
  String sendTime;
  String title;

  MessageModel(){

  }

  MessageModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    messageRecieveId = json['messagerecieveid'];
    read = json['read'];
    sendTime = json['sendtime'];
    title = json['title'];
  }

}
