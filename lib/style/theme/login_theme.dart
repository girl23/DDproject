import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/style/color.dart';

import '../font.dart';
import '../size.dart';

class LoginTheme {
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
    borderSide: BorderSide(color: Color(0x70ffffff)),
    borderRadius: BorderRadius.circular(KSize.loginFormClumnHeight * 0.5),
  );
  //默认输入框border
  static InputBorder textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(KSize.loginFormClumnHeight * 0.5),
  );
  //选中
  static InputBorder textFieldFocusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(KSize.loginFormClumnHeight * 0.5),
    borderSide: BorderSide(color: Color(0xffffffff), width: 1.0),
  );
  //输入框字体样式
  static TextStyle textFieldTextStyle = TextStyle(
      fontSize: KFont.fontSizeTextField_1,
      color: Colors.white,
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
