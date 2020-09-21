import 'package:flutter/material.dart';
import 'package:lop/config/enum_config.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/config/global.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//新增/转办等通用操作按钮
typedef ButtonClickCallback = void Function();
class OperationButton{
  static BuildContext context=  Global.navigatorKey.currentState.context;
  static Widget createButton(String name,ButtonClickCallback btnClick,{DDOperateButtonState state,Size size=const Size(240, 100)}){
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
//        color: Colors.red,
        width:ScreenUtil().setWidth(size.width),
        height:ScreenUtil().setHeight(size.height),
//        padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
        child:RaisedButton(
          disabledColor: Colors.grey,
          padding: EdgeInsets.all(0),
          child: Text(Translations.of(context).text(name),style: TextStyle(fontSize: 16,color: Colors.white ,wordSpacing: 0,letterSpacing: 0),),
          splashColor: Colors.transparent,
          highlightColor:Colors.transparent,
          elevation: 0,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          onPressed:(state==DDOperateButtonState.enable)?null:(){
            btnClick();
          },
        ) ,

    );
  }
}