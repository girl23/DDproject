import '../dd_textfield_util.dart';
import '../na_button_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/config/global.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/size.dart';
import '../operation_button_util.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
typedef ValueChanged<T> = void Function(T value);
class DDComponent{

  static BuildContext context=  Global.navigatorKey.currentState.context;
  //文本+文本框(上下排列)
  static Widget tagAndTextFieldVertical(String tagName,FocusNode node,TextEditingController controller,List textFieldNodes){
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child:Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child:Text(Translations.of(context).text(tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
          ),
          SizedBox(height: 10,),
          DDTextFieldUtil.ddTextField(context,tag:tagName,textFieldNodes: textFieldNodes, node: node,controller: controller)
        ],
      ) ,
    );
  }
  //文本+文本框(左右排列)
  static Widget tagAndTextField(String tagName,double width,FocusNode node,TextEditingController controller,List textFieldNodes){
    return Container(
      padding: EdgeInsets.fromLTRB(15,(width==0)?0: 10, (width==0)?0:15, 0),
      child:Row(
        children: <Widget>[
          width!=0?Container(child:Text(Translations.of(context).text(tagName),style: TextStyle(fontSize: KFont.formTitle),),width: ScreenUtil().setWidth(width),):Container(),
          Expanded(child: DDTextFieldUtil.ddTextField(context,tag:tagName,textFieldNodes: textFieldNodes, node: node,controller: controller))
        ],
      ) ,
    );
  }
  //文本+文本框(上下排列)（内嵌N/A按钮｜换行按钮）
  static Widget tagAndTextFieldWithNa(String tagName,double width,FocusNode node,TextEditingController controller,List textFieldNodes){
     bool isMultiline;
     if(tagName=='dd_name'||tagName=='dd_jno'){
       isMultiline=true;
     }else{
       isMultiline=false;
     }
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child:Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child:Text(Translations.of(context).text(tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
          ),
          SizedBox(height: 10,),
           DDTextFieldUtil.ddTextField(context,tag:tagName,textFieldNodes:textFieldNodes,
              node: node,
              controller: controller,
              hasSuffix: true,
              suffix:(isMultiline==true)?null:NAButton.createNaButton(controller,tag:tagName),//多行编写，NA按钮不内置
              multiline: isMultiline,
            ),
        ],
      ) ,
    );
  }
  //文本+下拉框
  static Widget tagAndDropButton(String tagName,double width, List <DropdownMenuItem>items, String defaultValue,{ValueChanged valueChanged,String placeHolder}){
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        children: <Widget>[
         (tagName=='dd_evidence_type')?Container():Container(
            alignment: Alignment.centerLeft,
            child:Text(Translations.of(context).text(tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
          ),
          SizedBox(height: 10,),

          Container(
              height: KSize.textFieldHeight,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: KColor.textColor_66,
                  width: 0.5,
                ),
              ),
              child: DropdownButton(
                itemHeight: KSize.textFieldHeight,
                style: TextStyle(fontSize: KFont.formContent,color:KColor.textColor_66),
                hint:(placeHolder!=null)? Text(placeHolder,style: TextStyle(fontSize: KFont.formTitle,color:KColor.textColor_66)):Container(),
                value:defaultValue,//_dropList[index],
                isExpanded: true,
                underline: Container(),
                items:items,
                onChanged: (value)async{
                  FocusScope.of(context).requestFocus(FocusNode());
                  valueChanged(value);
                  DDCacheUtil.cacheData(tagName, value);

                },
              ) ,
            ),

        ],
      ),
    );
  }
  //复选框+文本
  static Widget tagAndCheckBoxLeft(String tagName,double width,bool defaultValue, {ValueChanged valueChanged}){
    return Container(
//        color: Colors.red,
//        height: KSize.textFieldHeight,
        child:
        Row(
          children: <Widget>[
            Checkbox(
              value: defaultValue,
              onChanged: (value)async{
                FocusScope.of(context).requestFocus(FocusNode());
                valueChanged(value);
                DDCacheUtil.cacheData(tagName, value);
              },

            ),
            Text(
                Translations.of(context).text(tagName),
                style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)
            ),

          ],
        )
    );
  }
  //文本+复选框
  static Widget tagAndCheckBoxRight(String tagName,double width,bool defaultValue, {ValueChanged valueChanged}){
    return Container(
      width: ScreenUtil().setWidth(width),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(
              Translations.of(context).text(tagName),
              style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)
          ),),
          Checkbox(
            value: defaultValue,
            onChanged: (value)async{
              FocusScope.of(context).requestFocus(FocusNode());
              valueChanged(value);
              DDCacheUtil.cacheData(tagName, value);
            },
          ),

        ],
      ),
    );
  }
  //斑马Title
  static Widget zebraTitle(String titleName){
    return Container(
      width: double.infinity,
      color: KColor.zebraColor1,
      alignment: Alignment.centerLeft,
      padding: KSize.insets1,//EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Text(Translations.of(context).text(titleName),//titleName,
        style: TextStyle(fontSize: KFont.formTitle,color: Colors.white),
      ),
    );
  }
  //文本+文本，左右排列
  static Widget tagAndTextHorizon(String tagName,String value,{double width,Color color= KColor.textColor_33,Color bgColor=Colors.white,bool notBoldTitle,String textAlignment=''}){
    return Container(
      padding:  KSize.insets1,
      color: bgColor,
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:textAlignment=='spaceBetween'?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child:Text(tagName!=''?Translations.of(context).text(tagName):'',style: TextStyle(fontSize: KFont.formTitle,color: color)),
          ),
          textAlignment=='spaceBetween'?Container(): SizedBox(width: 15,),
          Container(
            alignment: Alignment.centerRight,//Alignment.centerLeft,
            child:Text((value!=null)?value:'',style: TextStyle(fontSize: KFont.formTitle,color: color)),
          ),

        ],
      ) ,
    );
  }
  //文本+文本，上下排列
  static Widget tagAndTextVertical(String tagName,String value,{Color color= KColor.textColor_33,Color bgColor=Colors.white,}){
      return Container(
        width: double.infinity,
        padding:KSize.insets1, //EdgeInsets.fromLTRB(15, 10, 15, 10),
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           tagName!=''? Text('${Translations.of(context).text(tagName)}',
                style: TextStyle(fontSize: KFont.formTitle,color: color),
            ):Container(),
            tagName!=''?SizedBox(height: 10,):Container(),
            Text(value,style: TextStyle(fontSize: KFont.formContent,color: color))

          ]
        ),
      );
  }
  //文本+按钮
  static Widget tagAndButtonHorizon(String tagName,String value,{double width,Color color= KColor.textColor_33,Color bgColor=Colors.white,String textAlignment=''}){
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
      color: bgColor,
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:textAlignment=='spaceBetween'?MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
        children: <Widget>[
          Container(child:Text('${Translations.of(context).text(tagName)}',style: TextStyle(fontSize: KFont.formTitle,color: color))),
          OperationButton.createButton(value,
                  (){
                //签字
              }),
        ],
      ) ,
    );
  }
  //文本+图片+文本框
  static Widget tagImageAndTextField(String tagName,FocusNode node,TextEditingController controller,List textFieldNodes,{String imgStr,Size size=const Size(25,25)}){
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child:Text(Translations.of(context).text(tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ImageIcon(
                  AssetImage(imgStr),
                  size: size.width,
                  color: KColor.textColor_99,
                ),
                SizedBox(width: (size.width<25)?15+25-(size.width):15,),
                Expanded(child: DDTextFieldUtil.ddTextField(context,tag:tagName,textFieldNodes: textFieldNodes, node: node,controller: controller))
            ],
          ) ,
        ],
      )
    );
  }
  //文本+图片+文本框+Na
  static Widget tagImageAndTextFieldWithNa(String tagName,FocusNode node,TextEditingController controller,List textFieldNodes,{String imgStr,Size size=const Size(25,25)}){
    bool isMultiline;
    if(tagName=='dd_name'||tagName=='dd_jno'){
      isMultiline=true;
    }else{
      isMultiline=false;
    }
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),

        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child:Text(Translations.of(context).text(tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ImageIcon(
                  AssetImage(imgStr),
                  size: size.width,
                  color: KColor.textColor_99,
                ),
                SizedBox(width: (size.width<25)?15+25-(size.width):15,),
                Expanded(
                  child: DDTextFieldUtil.ddTextField(context,tag:tagName,textFieldNodes:textFieldNodes,
                    node: node,
                    controller: controller,
                    hasSuffix: true,
                    suffix:(isMultiline==true)?null:NAButton.createNaButton(controller,tag:tagName),//多行编写，NA按钮不内置
                    multiline: isMultiline,
                  ),)
              ],
            ) ,
          ],
        )
    );
  }
  //文本+图片+下拉框
  static Widget tagImageAndDropButton(String tagName,double width, List <DropdownMenuItem>items, String defaultValue,{String imgStr,Size size=const Size(25,25),ValueChanged valueChanged,String placeHolder}){
   return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child:Text(Translations.of(context).text(tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ImageIcon(
                  AssetImage(imgStr),
                  size: size.width,
                  color: KColor.textColor_99,
                ),
                SizedBox(width: 15,),
                Expanded(child: Container(
                  height: KSize.textFieldHeight,
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: KColor.textColor_66,
                      width: 0.5,
                    ),
                  ),
                  child: DropdownButton(
                    itemHeight: KSize.textFieldHeight,
                    style: TextStyle(fontSize: KFont.formContent,color:KColor.textColor_66),
                    hint:(placeHolder!=null)? Text(placeHolder,style: TextStyle(fontSize: KFont.formTitle,color:KColor.textColor_66)):Container(),
                    value:defaultValue,//_dropList[index],
                    isExpanded: true,
                    underline: Container(),
                    items:items,
                    onChanged: (value)async{
                      FocusScope.of(context).requestFocus(FocusNode());
                      valueChanged(value);
                      if(tagName=='search_dd_state'){}else{
                        DDCacheUtil.cacheData(tagName, value);
                      }
                    },
                  ) ,
                ),)
              ],
            ) ,
          ],
        )
    );
  }
}

