import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///存放控件的尺寸

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class KSize {
  //tabBar
  static final double pi = 3.14159;

  //通用Margin1/Margin2;
  static final double commonMargin1 = ScreenUtil().setWidth(10.0);
  static final double commonMargin2 = ScreenUtil().setWidth(20.0);
  static final double commonPadding1 = ScreenUtil().setWidth(10.0);
  static final double commonPadding2 = ScreenUtil().setWidth(20.0);
  static final double commonPadding3 = ScreenUtil().setWidth(30.0);
  static final double commonSplitHeight1 =
      ScreenUtil().setHeight(20.0); //默认的高度分割线

  static final double dialogPadding1 = ScreenUtil().setWidth(82.0);
  static final double dialogButtonHeight = ScreenUtil().setWidth(100.0);
  static final double dialogButtonWidget = ScreenUtil().setWidth(380.0);
  static final double dialogPadding2 = ScreenUtil().setWidth(10.0);
  static final double dialogDividerWidth = ScreenUtil().setWidth(48.0);
  static final double commonShapeRadius = ScreenUtil().setWidth(9.0);
  static final double dialogPadding3 = ScreenUtil().setWidth(52.0);
  static final double dialogPadding4 = ScreenUtil().setWidth(62.0);
  static final double dialogPadding5 = ScreenUtil().setWidth(32.0);
  static final double dialogPadding6 = ScreenUtil().setWidth(400.0);

  static final double commonWordSpacing =
      ScreenUtil().setWidth(10.0); //通用的字/单词间的间距
  static final double splitLineHeight = ScreenUtil().setHeight(1.0); //通用的分割线的高度

  static final double bottomSheetSingleHeight =
      ScreenUtil().setHeight(140.0); //通用的：下方滑出的操作按钮的高度

  static final double tabBarIconSize =
      ScreenUtil().setWidth(70.0); //tabBar的图片大小
  ///登录页面
  ///
  static final double loginContentMarginTop = ScreenUtil.screenHeightDp * 0.26;
  static final double loginContentMarginBottom = ScreenUtil.screenHeightDp*0.02;
  static final double loginContentMarginLR = ScreenUtil.screenWidthDp / 16.0;
  static final double loginTitleMarginBottom = ScreenUtil.screenHeightDp * 0.06;
  static final double loginTextFieldPrefixWidth = ScreenUtil().setWidth(130);

  static final double loginLogoWidth = ScreenUtil().setWidth(1080);
  static final double loginLogoHeight = ScreenUtil().setHeight(750);
  static final double loginContainerBottom =
      ScreenUtil().setHeight(40.0); //登录页面 输入框整体区域距离底部的高度
  static final double loginFormWidth = ScreenUtil().setWidth(900.0);
  static final double loginFormHeight = ScreenUtil().setHeight(450.0);
  static final double loginFormClumnHeight = ScreenUtil().setHeight(160.0);
  static final double loginFormPaddingLR = ScreenUtil().setHeight(40.0);
  static final double loginFormPaddingTB = ScreenUtil().setHeight(30.0);
  static final double loginFormTextFieldPreSubIconSize =
      ScreenUtil().setWidth(70.0);
  static final double loginFormSplitLineWidth = ScreenUtil().setWidth(800.0);
  static final double loginButtonPaddingLR = ScreenUtil().setWidth(222.0);
  static final double loginButtonPaddingTB = ScreenUtil().setHeight(24.0);
  static final double loginButtonPositionTop = ScreenUtil().setHeight(400.0);
  static final double loginSizeBoxHeight = ScreenUtil().setHeight(40.0);
  static final double loginSettingWidth = ScreenUtil().setWidth(1000.0);
  static final double loginFormOuterPaddingLeft = ScreenUtil().setWidth(20);
  static final double loginFormOuterPaddingRight = ScreenUtil().setWidth(20);

  //120px
  static final double appBarHeight = 120.0 / ScreenUtil.pixelRatio ;//ScreenUtil().setHeight(140.0);

  ///all task page
  static final EdgeInsets navigationBarTailIconInsets =
      EdgeInsets.only(right: 20, top: 10);
  static final double allTaskPageItemsMargin = 0;
  static final double tableViewNoDataHeight =
      ScreenUtil().setHeight(400); //tableView无数据时的提示内容高度
  static final double tableItemCardElevation =
      ScreenUtil().setHeight(20.0); //tableView的Item的cardView的阴影高度

  static final double taskItemPadding = ScreenUtil().setWidth(30);
  static final double taskItemIconSize = ScreenUtil().setWidth(120);
  static final double taskItemRowTextSplitWidth =
      ScreenUtil().setWidth(20.0); //任务列表中，文字块之间的横向间距
  static final double taskItemColumnTextSplitHeight =
      ScreenUtil().setHeight(10.0); //任务列表中，文字块之间的纵向间距

  //我的任务
  //导航+Tab构成的头部，导航栏120px
  static final double myTaskHeaderHeight = 248.0 / ScreenUtil.pixelRatio;//ScreenUtil().setHeight(296.0);
  static final double myTaskIndicatorHeight =
      ScreenUtil().setHeight(5.0); //指示器高度
  static final double myTaskNavTabHeight =
      ScreenUtil().setHeight(150.0); //Tab高度
  static final double myTaskNavTabHorizontalPadding =
      ScreenUtil().setHeight(20.0); //tab距离两边间距

  //修改密码
  static final double changePasswordBtnHeight = ScreenUtil().setHeight(128);

  //任务详情
  static final double taskDetailInfoItemPaddingTB = ScreenUtil().setHeight(28);
  static final double taskDetailInfoPaddingLR = ScreenUtil().setWidth(40);
  static final double taskDetailOperatorAreaHeight =
      ScreenUtil().setHeight(120);
  static final double taskDetailTaskCategaryHeight =
      ScreenUtil().setHeight(120);

  //消息部分
  static final double messageCardStateSizeBoxWidth =
      ScreenUtil().setHeight(120);
  static final double messageCardRightArrowSize = ScreenUtil().setWidth(70);

  //升级
  static final double updateVersionDialogWidth = ScreenUtil().setWidth(1022);
  static final double updateVersionDialogHeightMax =
      ScreenUtil().setHeight(600);
  static final double updateVersionDialogButtonWidth =
      ScreenUtil().setHeight(500);
  static final double updateVersionDialogButtonHeight =
      ScreenUtil().setHeight(120);

  static double sheetItemHeight = ScreenUtil().setSp(140);
  static double dividerSize = ScreenUtil().setHeight(2);

  static EdgeInsetsGeometry taskDetailContentPadding = EdgeInsets.only(
      right: KSize.taskDetailInfoPaddingLR,
    top: KSize.taskDetailInfoPaddingTB,
    bottom: KSize.taskDetailInfoPaddingTB,
  );
  static double taskDetailInfoItemButtonHeight = ScreenUtil().setHeight(80);
  static double taskDetailInfoPaddingTB = ScreenUtil().setHeight(26);
  static double loginTextFieldSuffixPaddingRight = ScreenUtil().setWidth(70);


  ///模块化工卡页面
  static double jcSignCountHeight = ScreenUtil().setHeight(110);
  static double jcSignFlightHeadHeight = ScreenUtil().setHeight(300);
  static double jcSignPanelSettingItemHeight = ScreenUtil().setHeight(120);
  static double jcSignItemTextHeight = 1.3;
  static double jcSignListViewFooterHeight = ScreenUtil().setHeight(240);
  static double jcSignItemIconSize = ScreenUtil().setWidth(70);
  static double jcSignItemSubscriptSize = ScreenUtil().setWidth(35);
  static double jcSignItemSubscriptPadding = ScreenUtil().setWidth(20);
  static double jcSignItemButtonHeight = ScreenUtil().setHeight(90);
  static double jcSignItemButtonWidth = ScreenUtil().setWidth(220);
  static double jcSignItemCheckWidth = ScreenUtil().setWidth(50);
  static final double resetFormColumnHeight = ScreenUtil().setHeight(128.0);
  static final double resetCodeWidth = ScreenUtil().setHeight(450.0);

  ///dd
  static final double textFieldHeight = ScreenUtil().setHeight(100.0);
  static final EdgeInsets insets1=EdgeInsets.fromLTRB(15, 5, 15,5);//斑马线/文本
  static final EdgeInsets insets2=EdgeInsets.fromLTRB(15, 5, 15,5);

}
