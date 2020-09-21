import 'dart:convert';

import 'entity_factory.dart';

class BaseListEntity<T> {
  String errorId;
  String errorMsg;
  List<T> data;

  BaseListEntity({this.errorId, this.errorMsg, this.data});

  factory BaseListEntity.fromJson(data) {
    var json = jsonDecode(data);
    List<T> mData = new List<T>();
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      });
    }



    return BaseListEntity(
      errorId: json['errorid'],
      errorMsg: json['errormsg'],
      data: mData,
    );
  }
}