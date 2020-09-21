import 'package:flutter_screenutil/flutter_screenutil.dart';
class KFont{


  static double fontSizeCommon_1 =  ScreenUtil().setSp(50);
  static double fontSizeCommon_2 =  ScreenUtil().setSp(40);
  static double fontSizeCommon_3 =  ScreenUtil().setSp(60);
  static double fontSizeCommon_4 =  ScreenUtil().setSp(35);
  static double fontSizeCommon_5 =  ScreenUtil().setSp(45);
  static double fontSizeCommon_6 =  ScreenUtil().setSp(30);

  //按钮的字体
  static double fontSizeBtn_1 = ScreenUtil().setSp(60.0);
  static double fontSizeBtn_2 = ScreenUtil().setSp(50.0);
  static double fontSizeBtn_3 = ScreenUtil().setSp(40.0);

  //输入框字体
  static double fontSizeTextFieldHint_1 = ScreenUtil().setSp(40.0);
  static double fontSizeTextFieldHint_2 = ScreenUtil().setSp(30.0);

  static double fontSizeTextField_1 = ScreenUtil().setSp(50.0);
  static double fontSizeTextField_2 = ScreenUtil().setSp(40.0);


  //列表数据
  static double fontSizeItem_1 = ScreenUtil().setSp(50); //列表项上一级 title 的大小
  static double fontSizeItem_2 = ScreenUtil().setSp(40); //列表项上二级 title 的大小
  static double fontSizeItem_3 = ScreenUtil().setSp(35);


  //弹出框
  static double fontSizeDialogLoading = ScreenUtil().setSp(40.0);//loading弹出框的字体大小
  static double fontSizeDialogAlert = ScreenUtil().setSp(50);//alert弹出框字体大小



  ///其他类型，根据场合单独列出

  //页面顶部Title
  static double fontSizeAppBarTitle = ScreenUtil().setSp(48.0);
  static double fontSizeAppBarAction = ScreenUtil().setSp(44.0);

  //TabBar上的字体大小
  static double fontSizeTabBar = ScreenUtil().setSp(36);


  //登录页面title
  static double fontSizeLoginTitle = ScreenUtil().setSp(80.0);

  static double fontSizeSheetItem = ScreenUtil().setSp(40);

  //工卡
  //左侧内容=================
  //左侧内容模块
  static double fontSizeModel = ScreenUtil().setSp(40);
  //左侧内容工序
  static double fontSizePos = ScreenUtil().setSp(42);
  //左侧内容条目
  static double fontSizeItem = ScreenUtil().setSp(40);
  static double fontSizeItemButton = ScreenUtil().setSp(36);
  static double fontSizeItemSubscript = ScreenUtil().setSp(25);

  //右侧抽屉=================

  //抽屉模块
  static double fontSizeDrawerModel= ScreenUtil().setSp(35);
  //抽屉工序
  static double fontSizeDrawerPos = ScreenUtil().setSp(25);

  //表头=================
  static double fontSizeTableHeader = ScreenUtil().setSp(40);

  static double fontSizeNote = ScreenUtil().setSp(50);

  static double fontSizeCaution = ScreenUtil().setSp(40);

  static double fontSizeExplain = ScreenUtil().setSp(30);

  //dd=================
  static double bigTitle = ScreenUtil().setSp(50);
  static double formTitle = ScreenUtil().setSp(40);
  static double formContent = ScreenUtil().setSp(35);
}