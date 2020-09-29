
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lop/component/pdf_screen.dart';
import 'package:lop/page/reset_password.dart';
import 'package:lop/page/sign/job_card_setting_page.dart';
import '../page/image/image_grid_view_page.dart';
import '../page/image/image_single_view_page.dart';
import '../page/image/image_view_page.dart';
import '../page/login_page.dart';
import '../page/message/message_details_page.dart';
import '../page/setting_page.dart';
import '../page/sign/job_card_module_page.dart';
import '../page/sign/job_card_sign_page.dart';
import '../page/task/change_theme_page.dart';
import '../page/task/detail/task_detail_page.dart';
import '../page/task/password/change_password_page.dart';
import '../page/task/task_home_page.dart';
import '../page/dd/temporary_dd/temporary_dd_list_page.dart';
import '../page/dd/temporary_dd/add_temporary_dd.dart';
import '../page/dd/temporary_dd/temporary_dd_detail.dart';
import '../page/dd/normal_dd/dd_list_page.dart';
import '../page/dd/normal_dd/add_dd.dart';
import '../page/dd/normal_dd/dd_detail.dart';
import 'package:lop/config/enum_config.dart';
Handler rootHandler = Handler(
  handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
    return LoginPage();
  })
);

Handler taskPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return TaskHomePage();
    })
);

Handler jobCardSignPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return JobCardSignPage();
    })
);

Handler imageGridViewHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return ImageGridViewPage();
    })
);

Handler imageSingleViewHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return ImageSingleViewPage();
    })
);

Handler imageViewPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return ImageViewHomePage(params["taskid"][0],params["acrjcid"][0]);
    })
);

Handler msgDetailsPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return MsgDetailsPage(params["msgid"][0],params["read"][0],params["title"][0],params["content"][0],params["searchTitle"][0]);
    })
);

Handler taskDetailPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return TaskDetailPage();
    })
);


Handler changePasswordPageHandler = Handler(
handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
  return ChangePasswordPage(params["comeFromLogin"][0]);
})
);

Handler settingPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return SettingPage();
    })
);

Handler changeThemeHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return ChangeThemePage();
    })
);

Handler loginPageHandler = Handler(
  handlerFunc: ((BuildContext context, Map<String, dynamic> params){
    return LoginPage();
  })
);
Handler jobCardModulePageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params){
      return JobCardModulePage();
    })
);
Handler jobCardModulePageSettingHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params){
      return JobCardSettingPage();
    })
);
Handler pafScreenHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params){
      return PDFScreen(params["pdfurl"][0]);
    })
);
Handler resetPasswordPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return ResetPasswordPage(username:params["username"][0]);
    })
);
Handler temporaryDDListPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return TemporaryDDListPage();
    })
);
Handler addTemporaryDDPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return AddTemporaryDD();
    })
);
Handler temporaryDDDetailPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      TemporaryDDState state;
      String temporaryDDState = (params["temporaryDDState"]?.first);
      if(temporaryDDState =='un_close'){
        //未关闭
        state=TemporaryDDState.unClose;
      }else if(temporaryDDState =='closed'){
        //已关闭
        state=TemporaryDDState.closed;
      }else if(temporaryDDState =='deleted') {
        //已删除
        state=TemporaryDDState.deleted;
      } else{state=TemporaryDDState.unClose;}

      String trans=params["transfer"]?.first;

      String ddId=params["ddID"]?.first;
//      return TemporaryDDDetail(params["transfer"]?.first,state,params["ddID"]?.first);
      return TemporaryDDDetail(trans:trans,state: state,ddId:ddId,);
    })
);
Handler dDListPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
      return DDListPage();
    })
);
Handler addDDPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {
     String from = params["comeFrom"][0];
     comeFromPage comeFrom;
     if(from =='fromNewAdd'){
       //DD新增
       comeFrom=comeFromPage.fromNewAdd;
     }else if(from =='fromTaskListAdd'){
       //从任务列表新增DD
       comeFrom=comeFromPage.fromTaskListAdd;
     }else if(from =='fromTemporaryTransfer'){
       // 临保转办
       comeFrom=comeFromPage.fromTemporaryTransfer;
     }else if(from =='fromDDTransfer'){
       //DD转办
       comeFrom=comeFromPage.fromDDTransfer;
     }else if(from =='fromDDDelay'){
      //DD延期
       comeFrom=comeFromPage.fromDDDelay;
     }
     else{comeFrom=comeFromPage.fromNewAdd;}

      return AddDD(comeFrom);
    })
);
Handler dDDetailPageHandler = Handler(
    handlerFunc: ((BuildContext context, Map<String, dynamic> params) {

      DDState state;
      String dDState = (params["ddState"]?.first);

      if(dDState =='toAudit'){
        //待批准
        state=DDState.toAudit;
      }else if(dDState =='unClose'){
        //未关闭
        state=DDState.unClose;
      }else if(dDState =='forTroubleshooting') {
        //待排故
        state=DDState.forTroubleshooting;
      }else if(dDState =='forInspection') {
        //待检验
        state=DDState.forInspection;
      }else if(dDState =='haveTransfer') {
        //已转办
        state=DDState.haveTransfer;
      }else if(dDState =='hasDelay') {
        //已延期
        state=DDState.hasDelay;
      }else if(dDState =='closed') {
        //已关闭
        state=DDState.closed;
      }else if(dDState =='deleted') {
        //已删除
        state=DDState.deleted;
      }else if(dDState =='delayClose') {
        //延期关闭
        state=DDState.delayClose;
      } else{state=state=DDState.unClose;}

      return DDDetail(params["transfer"]?.first,state);
    })
);