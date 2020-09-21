class DDListItemModel {
  String title;
  String content;


  DDListItemModel(){

  }

  DDListItemModel.fromJson(Map<String, dynamic> json) {
    title = json['content'];
    content = json['content'];
  }
}