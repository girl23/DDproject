

import 'package:flutter/material.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';

class TextThemeStore{

  //标题栏
  static TextStyle textStyleAppBar = TextStyle(
    color: KColor.textColor_white,
    fontSize: KFont.fontSizeAppBarTitle,
      fontWeight: FontWeight.w500
  );
  //标题栏上的按钮
  static TextStyle textStyleAppBarAction = TextStyle(
      color: KColor.textColor_white,
      fontSize: KFont.fontSizeAppBarAction,
  );
  //搜索框
  static TextStyle textStyleSearch = TextStyle(
    color: KColor.textColor_black,
    fontSize: KFont.fontSizeCommon_1,
  );
  //card第一行文本
  static TextStyle textStyleCard_1 = TextStyle(
    color: KColor.textColor_19,
    fontSize: KFont.fontSizeCommon_5,
  );
  //card第二行文本——颜色#808080
  static TextStyle textStyleCard_2 = TextStyle(
    color: KColor.textColor_80,
    fontSize: KFont.fontSizeCommon_2,
  );
  //card第二行文本——颜色#b2b2b2
  static TextStyle textStyleCard_3 = TextStyle(
    color: KColor.textColor_b2,
    fontSize: KFont.fontSizeCommon_2,
  );
  //card第二行文本——颜色#999999
  static TextStyle textStyleCard_4 = TextStyle(
    color: KColor.textColor_99,
    fontSize: KFont.fontSizeCommon_2,
  );


  //跟主题相关的字体样式——长按钮
  static TextStyle textStylePrimaryButton_long = TextStyle(
    color:KColor.textColor_white,
    fontSize:KFont.fontSizeCommon_1,
    fontWeight: FontWeight.normal
  );

  //跟主题相关的字体样式——card中
  static TextStyle textStylePrimaryButton_item = TextStyle(
      color:KColor.textColor_white,
      fontSize:KFont.fontSizeCommon_2,
      fontWeight: FontWeight.normal
  );





//  static
  static TextTheme textTheme_1 = TextTheme(
    //display1: "我的消息"——时间
    display1: TextStyle(
      color: KColor.color_5bbd02,
//      fontSize: KFont.fontSizeCommon_1,
    ),
  );
//我的消息根据主题变成
  static TextTheme textTheme_2 = TextTheme(
    //display1: "我的消息"——时间
    display1: TextStyle(
      color: KColor.primaryColor_1,
//      fontSize: KFont.fontSizeCommon_1,
    ),

  );


  //任务详情_item左侧标题
  static TextStyle textStyleDetailItemTitle = TextStyle(
    color: KColor.textColor_19,
    fontSize: KFont.fontSizeCommon_1,
  );
  //任务详情_item左侧标题
  static Function textStyleDetailTitle = (context){
    return TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: KFont.fontSizeCommon_1,
    );
  };
  //任务详情_item右侧标题
  static TextStyle textStyleDetailItemContent = TextStyle(
    color: KColor.textColor_66,
    fontSize: KFont.fontSizeCommon_1,
  );

}
