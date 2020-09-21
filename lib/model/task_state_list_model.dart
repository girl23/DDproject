
import 'package:lop/model/task_model.dart';
import 'package:lop/provide/task_state_index_provide.dart';


class TaskStateListModel{

  int total;
  int page;
  int pageCount;
  String result;
  String info;
  List<TaskModel> data;

  TaskStateListModel(this.data);

  TaskStateListModel.fromJson(Map<String,dynamic> json){
    print('listjson${json}');
    total = json['total'];
    page = json['page'];
    pageCount = json['pageCount'];
    result = json['result'];
    info = json['info'];
    if(json['data']!=null){
      data = List<TaskModel>();
      json['data'].forEach((v){
        data.add(TaskModel.fromJson(v));
      });
    }
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = Map();
    data['total'] = total;
    data['page'] = page;
    data['pageCount'] = pageCount;
    data['result'] = result;
    data['info'] = info;

    if(data != null){
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool isEmpty(){
    return data.length == 0;
  }

}