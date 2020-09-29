

//定义路径及跳转页面
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:lop/router/router_handler.dart';

import 'router_handler.dart';
import 'router_handler.dart';

class Routes{
  //根路径
  static String root = "/";

  //航线任务页面
  static String taskPage = "/task";

  //航线任务详情页面
  static String taskDetailsPage = "/task/detail";

  static String jobCardSignPage = "/jobcard/sign";

  static String imageGridViewPage = 'image/grid';
  static String imageSingleViewPage = 'image/single';
  static String imageViewPage = 'image/:taskid/:acrjcid';

  //修改密码
  static String changePasswordPage="/task/password/:comeFromLogin";
  //系统设置
  static String settingPage="/setting";

  //消息详情页面
  static String msgDetailsPage = "/msg/detail/:msgid/:read/:title/:content/:searchTitle";

  //修改主题
  static String changeTheme = "/changeTheme";

  //登录页面
  static String loginPage = '/login';

  //工卡
  static String jobCardModulePage ='/jobCard/modulesign';
  static String jobCardSettingPage = '/jobCard/modulesign/setting';

  //pdf阅读
  static String pdfScreenPage = "/jobCard/modulesign/pdfscreen/:pdfurl";
  //重置密码
  static String resetPasswordPage="/reset/:username";

  //临保列表
  static String temporaryDDListPage = '/temporaryDDListPage';
  //新增临保
  static String addTemporaryDDPage = '/addTemporaryDDPage/:transfer/:temporaryDDState';
  //临保详情
  static String temporaryDDDetailPage = '/temporaryDDDetailPage/:temporaryDDState/:ddID';
  //DD列表
  static String dDListPage = '/dDListPage';
  //新增DD
  static String addDDPage = '/addDDPage/:comeFrom';
  //DD详情
  static String dDDetailPage = '/dDDDetailPage/:transfer/:ddState';
  //路由配置

   static void configureRoutes(Router router){

     //路由定义
     router.define(root, handler: rootHandler);
     router.define(taskPage, handler: taskPageHandler);
     router.define(jobCardSignPage, handler: jobCardSignPageHandler);
     router.define(imageGridViewPage, handler: imageGridViewHandler);
     router.define(imageSingleViewPage, handler: imageSingleViewHandler);
     router.define(imageViewPage, handler: imageViewPageHandler);
     router.define(msgDetailsPage, handler: msgDetailsPageHandler);
     router.define(taskDetailsPage, handler: taskDetailPageHandler);
     router.define(changePasswordPage, handler: changePasswordPageHandler);
     router.define(settingPage, handler: settingPageHandler);
     router.define(changeTheme, handler: changeThemeHandler);
     router.define(loginPage, handler: loginPageHandler);
     router.define(jobCardModulePage, handler: jobCardModulePageHandler);
     router.define(jobCardSettingPage, handler: jobCardModulePageSettingHandler);
     router.define(pdfScreenPage, handler: pafScreenHandler);
     router.define(resetPasswordPage, handler: resetPasswordPageHandler);
     router.define(temporaryDDListPage, handler: temporaryDDListPageHandler);
     router.define(addTemporaryDDPage, handler:addTemporaryDDPageHandler);
     router.define(temporaryDDDetailPage, handler:temporaryDDDetailPageHandler);
     router.define(dDListPage, handler: dDListPageHandler);
     router.define(addDDPage, handler:addDDPageHandler);
     router.define(dDDetailPage, handler:dDDetailPageHandler);
   }

}