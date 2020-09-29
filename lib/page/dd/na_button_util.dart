import 'package:flutter/material.dart';
import 'package:lop/style/color.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
import 'package:lop/style/size.dart';
typedef NAButtonClickCallback = void Function();
class NAButton{
  static Widget createNaButton(TextEditingController controller,{String tag,bool multiline=false,NAButtonClickCallback naBtnClick}){
    return Container(
      height: KSize.textFieldHeight-4,
      child:RaisedButton(
            padding: EdgeInsets.all(0),
            child: Text('N/A',style:(multiline!=null&&multiline==true)?TextStyle(fontSize: 12,color: Colors.orange):TextStyle(fontSize: 16,color: Colors.orange),),
            splashColor: Colors.transparent,
            highlightColor:Colors.transparent,
            color:Colors.transparent ,
            elevation: 0,
            shape: Border(
              left: BorderSide(color: KColor.textColor_66,width:0.5),
              right: BorderSide(color: KColor.textColor_66,width:multiline?0.5:0.00001),
              top: BorderSide(color: KColor.textColor_66,width:multiline?0.5:0.00001),
              bottom:BorderSide(color:KColor.textColor_66,width:multiline?0.5:0.00001),
            ),
            textColor: Colors.orange,
            onPressed: () {
              controller.text='N/A';
              //缓存
              DDCacheUtil.cacheData(tag, 'N/A');
              naBtnClick();
            },
          ) ,
        width: 10
    );
  }
}