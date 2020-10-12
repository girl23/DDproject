import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lop/style/size.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'na_button_util.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
typedef ButtonClickCallback = void Function();
typedef CompleteCallback = void Function();
class DDTextFieldUtil  {
  static Widget ddTextField(BuildContext context,{String tag,double height, List textFieldNodes, FocusNode node,TextEditingController controller,bool hasSuffix,Widget suffix,bool suffixIsIcon=false,bool multiline=false,CompleteCallback completeCallback})
 {
   bool readOnly=false;
   int lengthLimit;
   double lineHeight;
   TextInputType inputType;
   //文本长度限制
   void limit(){
     if(tag=='dd_number'||tag=='dd_number1'){
       //LB编号/DD编号
       lengthLimit=12;
     } else if(tag=='dd_planeNo'){
       //飞机号
       lengthLimit=6;//B-自动加入占两位
     } else if(tag=='dd_keepPerson'){
       //保留人员
       lengthLimit=10000;
     } else if(tag=='dd_phoneNumber'||tag=='dd_fax'){
       //电话｜传真
       lengthLimit=15;
     } else if(tag=='dd_WorkNO'){
       //电话｜传真
       lengthLimit=20;
     }
     else if(tag=='dd_ENG'){
       lengthLimit=18;
     }
     else if(tag=='dd_faultNum'||tag=='dd_releaseNum'||tag=='dd_installNum'){
       //数量
       lengthLimit=13;
     } else if(tag=='dd_chapter1'||tag=='dd_chapter2'){
       //章节前两数据长度限制
       lengthLimit=2;
     } else if(tag=='dd_chapter3'){
       //章节最后一个字符数据长度限制
       lengthLimit=4;
     }else if(tag=='dd_reportPlace'||tag=='dd_firstReportPlace'){
       //临保/dd首次报告地点
       lengthLimit=3;
     }else if(tag=='dd_other_describe'){
       lengthLimit=255;
     }
     else if(tag=='dd_plan_keep_time1'||tag=='dd_plan_keep_time3'){
       //天数/循环
       lengthLimit=6;
     }else if(tag=='dd_plan_keep_time2'||tag=='dd_start_time2'||tag=='dd_start_time3'){
       //（）（总飞行小时/循环）
       lengthLimit=13;
     }else if(tag=='dd_need_parking_time'||tag=='dd_need_work_time'){
      //所需停场/所需工时
       lengthLimit=5;
     }
     else if(tag=='dd_chapter_no1'||tag=='dd_chapter_no2'||tag=='dd_chapter_no3'||tag=='dd_chapter_no4'||tag=='dd_chapter_no5'){
       //章节号1/2/3/4/5
       lengthLimit=20;
     }else if(tag=='dd_number1'||tag=='dd_WorkNO'||tag=='dd_ENG'||tag=='dd_from'){
        // DD编号/工作指令号/APU序号/转录文件
       lengthLimit=15;
     } else{
       //无限制情况
       lengthLimit=0;
     }
   }
   //处理文本框高度
   void dealLineHeight(){
     if(multiline){
       if(tag=='dd_name'||tag=='dd_jno'){
         //名称｜件号
         lineHeight=ScreenUtil().setHeight(200);
       }else{
         lineHeight=ScreenUtil().setHeight(350);
       }
     }else{
       lineHeight=KSize.textFieldHeight;
     }
   }
   //键盘限制
   void limitKeyboard(){
     if(multiline){
       inputType=TextInputType.multiline;
     }else if(tag=='dd_start_time2'||tag=='dd_start_time3'
         ||tag=='dd_plan_keep_time1'||tag=='dd_plan_keep_time2'||tag=='dd_plan_keep_time3'
         ||tag=='dd_end_time2'||tag=='dd_end_time3'
          ){
       inputType=TextInputType.number;
     }else{
       inputType=TextInputType.text;
     }

   }
   //文本框只读
   void limitReadOnly(){
     if(tag=='dd_reportDate'){
       readOnly=true;
     }else{
       readOnly=false;
     }
   }
   limitReadOnly();
   limit();

   dealLineHeight();
   limitKeyboard();
   return Container(
    height:lineHeight,
    child:Stack(
      children: <Widget>[
        //文本框和操作按钮
        Align(
            child: TextField(
                readOnly: readOnly,
                focusNode: node,
                autofocus: false,
                controller: controller,
                keyboardType:inputType,
                maxLines:(multiline)?10000000:1,
                textInputAction:  TextInputAction.next,
                decoration: InputDecoration(
//                  isDense: true,
                  contentPadding:EdgeInsets.only(left:10,top:18),//EdgeInsets.only(left:((tag=='dd_faultNum'||tag=='dd_releaseNum'||tag=='dd_installNum')&&ScreenUtil.screenWidthDp<500)?1:10, top: (multiline==true)?12:1,bottom: (multiline==true)?12:1,right: ((tag=='dd_faultNum'||tag=='dd_releaseNum'||tag=='dd_installNum')&&ScreenUtil.screenWidthDp<500)?1:10),
                  enabledBorder: OutlineInputBorder(
//                      /*边角*/
                  borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角
                  ),
                  borderSide: BorderSide(
                  color: KColor.textColor_66, //边线颜色
                  width: 0.5, //边线宽度
                  ),
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                  Radius.circular(2), //边角
                  ),
                  borderSide: BorderSide(
                  color: KColor.textColor_66, //边框颜色

                  width: 0.5, //宽度
                  )
                  ),

                ),
                style: TextStyle(fontSize: KFont.formContent,color: KColor.textColor_66,),

                inputFormatters:(lengthLimit!=0)?[LengthLimitingTextInputFormatter(lengthLimit)]:[],
                onEditingComplete: ()async{
                  int index= textFieldNodes.indexOf(node);
                  FocusNode currentNode= textFieldNodes[index];
                  FocusNode nextNode= textFieldNodes[index+1];
                  //飞机号处理
                  if(tag=='dd_planeNo'){
                    String tempStr=controller.text;
                   bool hasB= tempStr.startsWith('B-');
                   if(!hasB&&controller.text.length>0){
                     controller.text='B-${controller.text}';
                   }
                  }
                  //添加单位
                  if(controller.text.length>0&&(tag=='dd_need_parking_time'||tag=='dd_need_work_time')){
                    //所需停场/工时
                    controller.text='${controller.text}H';
                  }
                  //验证是否为三字吗
  //                ^[a-zA-Z]$
                  if(tag=='dd_reportPlace'||tag=='dd_firstReportPlace'){
                    RegExp exp1 = RegExp(r"^[A-Za-z]+$");
                    bool matched1 = exp1.hasMatch(controller.text);
                    if(!matched1){
                      ToastUtil.makeToast(Translations.of(context).text('dd_report_place_error'));
                      controller.text='';
                    }
                  }
                  //焦点控制
                  currentNode.unfocus();
                  print(controller.text);
                  print('++++$nextNode');
                  if(nextNode!=null){
                    FocusScope.of(context).requestFocus(nextNode);
                  }
                  if(tag=='search_dd_number'||tag=='search_dd_planeNo'){}else{
                    DDCacheUtil.cacheData(tag, controller.text);
                  }
                  //存数据
                  if(completeCallback!=null){
                    completeCallback();
                  }
                },
          ) ,
        ),
        ((hasSuffix??false==true))?Align(
          alignment: FractionalOffset.centerRight,
          child:Container(
            color: Colors.transparent,
            width:suffixIsIcon==true?32: 42,
          child:suffix  ,)
          ,
        ):Container(),
        (multiline)?Align(
            alignment: FractionalOffset.bottomRight,
            child: Container(
//              color: Colors.red,
                width: 60,
                height: 30,
                child:Row(
                mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //即有换行又有N/A按钮
                  (hasSuffix==true)? Container(
                    width: 30,
                    height:20,
                    child:
                    NAButton.createNaButton(controller,tag:tag,multiline: true),
                  ):Container(),
                //换行
                  Container(
                      width: 30,
                      height:30,
                      child:RaisedButton(
                      padding: EdgeInsets.all(0),
                      child: Text('↩︎',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800,color: Colors.orange ),),
                      splashColor: Colors.transparent,
                      highlightColor:Colors.transparent,
                      color:Colors.transparent ,
                      elevation: 0,
                      textColor: Colors.orange,
                      onPressed: () {
                        if(node.hasFocus){
                          controller.text='${controller.text}${'\n'}';
                        }
                      },
                    )),
                ],
              ),
            ),
        ):Container(),
      ],
    )
  );
 }
}
