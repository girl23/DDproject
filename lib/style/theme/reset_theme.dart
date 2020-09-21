import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/style/color.dart';

import '../font.dart';
import '../size.dart';
class ResetTheme{
  /*
   * 登录界面，定义渐变的颜色
   */
  static const Color loginGradientStart = Colors.amberAccent;
  static const Color loginGradientEnd = KColor.primaryColor;

  static const LinearGradient primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  //无效时的border
  static InputBorder textFieldEnableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[400],width: 1.0),
    borderRadius: BorderRadius.circular(KSize.commonShapeRadius),
  );
  //默认输入框border
  static InputBorder textFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[700],width: 1.0),
    borderRadius: BorderRadius.circular(KSize.commonShapeRadius),
  );
  //选中
  static InputBorder textFieldFocusBorder(context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(KSize.commonShapeRadius),
    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
  );
  //输入框字体样式
  static TextStyle textFieldTextStyle = TextStyle(
    fontSize: KFont.fontSizeTextField_1,
    color: Colors.black87,
//      textBaseline: TextBaseline.alphabetic
  );
  //hint框字体样式
  static TextStyle textFieldTextStyleHint = TextStyle(
      fontSize: KFont.fontSizeTextField_1,
      color: KColor.textColor_99,
      textBaseline: TextBaseline.alphabetic);


  static EdgeInsetsGeometry textFieldPrefixIconPadding = EdgeInsets.only(
      top: ScreenUtil().setHeight(50),
      bottom: ScreenUtil().setHeight(50),
      left: ScreenUtil().setWidth(40),
      right: ScreenUtil().setHeight(20));
}