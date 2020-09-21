import 'dart:convert';

import 'package:lop/service/entity/entity_factory.dart';
import 'package:lop/utils/log_util.dart';

class BaseEntity<T>{
  String errorId;
  String errorMsg;
  T data;

  BaseEntity({this.errorId,this.errorMsg,this.data});

  factory BaseEntity.fromJson(data){
    var json = jsonDecode(data);
//    LogUtil.e('###########${json}');
    return BaseEntity(
      errorId: json['errorid'],
      errorMsg: json['errormsg'],
      data: EntityFactory.generateOBJ<T>(json),
    );
  }

}