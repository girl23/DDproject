import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../component/dd_component.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/config/enum_config.dart';
import '../operation_button_util.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/page/dd/dd_date_time_picker_util.dart';
import 'package:lop/utils/date_util.dart';
import 'package:lop/router/application.dart';
import 'package:lop/viewmodel/dd/dd_detail_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:lop/viewmodel/dd/approve_dd_viewmodel.dart';
import 'package:lop/viewmodel/dd/trouble_shooting_viewmodel.dart';
import 'package:lop/viewmodel/dd/close_dd_viewmodel.dart';
import 'package:lop/viewmodel/dd/delete_dd_viewmodel.dart';

// ignore: must_be_immutable
class DDDetail extends StatefulWidget {
  String trans;//记录DD准办，DD延期来控制按钮禁用
  DDState state;
  String ddId;

  DDDetail({this.trans,this.state,this.ddId});
  @override
  _DDDetailState createState() => _DDDetailState();
}
class _DDDetailState extends State<DDDetail> {
  //时间选择器
  DateTimePicker _ddTimePicker=new DateTimePicker();
  bool transfer=false;
  List _textFieldNodes;
  FocusNode _dateNode=new FocusNode();
  TextEditingController _dateTextField=new TextEditingController();
  FocusNode _resultNode=new FocusNode();
  TextEditingController _resultTextField=new TextEditingController();
  String stateStr;
  DDDetailViewModel detailVM;
  DeleteDDViewModel deleteVM;
  ApproveDDViewModel approveVM;
  TroubleShootingViewModel shootingVM;
  CloseDDViewModel closeVM;


  Widget createUI(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text(Provider.of<DDDetailViewModel>(context).detailModel?.zzblno??'',style: TextStyle(fontSize: KFont.bigTitle,color: KColor.zebraColor1)),
                ),
                Container(
                  alignment: Alignment.centerRight,//Alignment.centerLeft,
                  child:Text( Translations.of(context).text(stateStr)??'',style: TextStyle(fontSize: KFont.bigTitle,color: Colors.blue)),
                ),
              ],
            ) ,
          ),
          DDComponent.zebraTitle('base_info'),
          //维修单位代码
          DDComponent.tagAndTextHorizon('dd_MBCode', Provider.of<DDDetailViewModel>(context).detailModel?.maintenanceunit??'',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //保留故障编号
          DDComponent.tagAndTextHorizon('dd_number1', Provider.of<DDDetailViewModel>(context).detailModel?.zzblno??'',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //工作指令号
          DDComponent.tagAndTextHorizon('dd_WorkNO',Provider.of<DDDetailViewModel>(context).detailModel?.zzwo??'',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //转录自何文件
          DDComponent.tagAndTextHorizon('dd_from',Provider.of<DDDetailViewModel>(context).detailModel?.zzzzhwj??'',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('plane_info'),
          //飞机号
          DDComponent.tagAndTextHorizon('dd_planeNo',Provider.of<DDDetailViewModel>(context).detailModel?.zzmsgrp??'', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //发动机/APU序号
          DDComponent.tagAndTextHorizon('dd_ENG',Provider.of<DDDetailViewModel>(context).detailModel?.sernr??'',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('report_info'),
          //首次报告日期
          DDComponent.tagAndTextHorizon('dd_firstReportDate', Provider.of<DDDetailViewModel>(context).detailModel?.zzbgdt??'', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //首次报告地点
          DDComponent.tagAndTextHorizon('dd_firstReportPlace', Provider.of<DDDetailViewModel>(context).detailModel?.zzddscbgdd??'',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('plan_info'),
          //起始日期/飞机总飞行小时/循环
          DDComponent.tagAndTextHorizon('dd_startDate',  '${Provider.of<DDDetailViewModel>(context).detailModel?.zzstart??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.zzfjzfxxs??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.zzfizfxxh??''}',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //计划保留天数/小时/循环
          DDComponent.tagAndTextHorizon('dd_plan_keep_time',  '${Provider.of<DDDetailViewModel>(context).detailModel?.zzdefdy??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.zzblfxxs??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.zzblfxxh??''}',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //折算到期期限/保留至飞行小时/飞行循环
          DDComponent.tagAndTextHorizon('dd_endDate',  '${Provider.of<DDDetailViewModel>(context).detailModel?.zzzzsqx??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.zzfjblzfh??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.zzfiblzfc??''}',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //计划保留间隔描述
          DDComponent.tagAndTextVertical('dd_plan_keep_describe', Provider.of<DDDetailViewModel>(context).detailModel?.zzgzms??'',bgColor: KColor.zebraColor3),
          //保留报告及临时措施
          DDComponent.tagAndTextVertical('dd_keepMeasure', Provider.of<DDDetailViewModel>(context).detailModel?.ddreport??'',bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('Maintenance_info'),
          //名称
          DDComponent.tagAndTextVertical('dd_name', Provider.of<DDDetailViewModel>(context).detailModel?.toolname??'',bgColor: KColor.zebraColor2),
          //件号
          DDComponent.tagAndTextVertical('dd_jno',  Provider.of<DDDetailViewModel>(context).detailModel?.partno??'',bgColor: KColor.zebraColor3),
          //数量
          DDComponent.tagAndTextHorizon('dd_Num', '${Provider.of<DDDetailViewModel>(context).detailModel?.falqty??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.relqty??''}/${Provider.of<DDDetailViewModel>(context).detailModel?.instqty??''}',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //ATA章节
          DDComponent.tagAndTextHorizon('dd_chapter', '${Provider.of<DDDetailViewModel>(context).detailModel?.zzatazj??''}-${Provider.of<DDDetailViewModel>(context).detailModel?.zzatazj2??''}-${Provider.of<DDDetailViewModel>(context).detailModel?.zztatzj3??''}', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //保留故障分类
          DDComponent.tagAndTextHorizon('dd_keep_faultCategory', Provider.of<DDDetailViewModel>(context).detailModel?.zzblclf??'', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //影响服务程度
          DDComponent.tagAndTextHorizon('dd_influence', Provider.of<DDDetailViewModel>(context).detailModel?.zzyxfwcd??'', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //所需停场时间
          DDComponent.tagAndTextHorizon('dd_need_parking_time', Provider.of<DDDetailViewModel>(context).detailModel?.zzytsj??'',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //所需工时
          DDComponent.tagAndTextHorizon('dd_need_work_time',  Provider.of<DDDetailViewModel>(context).detailModel?.zzsxgs??'', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('restrictions'),
          //使用限制
//          DDComponent.tagAndTextHorizon('dd_use_limit', '${Provider.of<DDDetailViewModel>(context).detailModel?.zzflgo??''=='1'?'O项':''} ${Provider.of<DDDetailViewModel>(context).detailModel?.zzflgoth=='1'?'其它':''}',  textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //其它限制描述
          Offstage(
            offstage: Provider.of<DDDetailViewModel>(context).detailModel?.zzflgo!='1',
            child:DDComponent.tagAndTextVertical('dd_use_limit_describe', detailVM.detailModel.zzgzms??'gag',bgColor: KColor.zebraColor3),
          ),
         //是否有M项要求
          DDComponent.tagAndTextHorizon('dd_need_m', (Provider.of<DDDetailViewModel>(context).detailModel?.zzmind=='1')?'是':'否',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //是否有运行限制
          DDComponent.tagAndTextHorizon('dd_need_run_limit', (Provider.of<DDDetailViewModel>(context).detailModel?.operatingLimits??''=='1')?'是':'否',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //需AMC处理标识
          DDComponent.tagAndTextHorizon('dd_need_amc', (Provider.of<DDDetailViewModel>(context).detailModel?.zzamcfg=='1')?'是':'否', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //是否放入机上"保留故障单夹"
          DDComponent.tagAndTextHorizon('dd_needKeepToFold',  (Provider.of<DDDetailViewModel>(context).detailModel?.zzsffris=='1')?'是':'否', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //是否有重检要求
          DDComponent.tagAndTextHorizon('dd_needRepeatInspection',  (Provider.of<DDDetailViewModel>(context).detailModel?.zzifrchk=='1')?'是':'否', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('reason_code'),
          //保留原因代码
          DDComponent.tagAndTextVertical('', Provider.of<DDDetailViewModel>(context).detailModel?.zzrescode??'',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('evidence_type'),
          //依据类型
          DDComponent.tagAndTextHorizon('dd_evidence_type', 'MEL',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号1"
          DDComponent.tagAndTextVertical('dd_chapter_no1', Provider.of<DDDetailViewModel>(context).detailModel?.zzmel??'',bgColor: KColor.zebraColor3),
          //MEL/CDL章节号2"
          DDComponent.tagAndTextVertical('dd_chapter_no2', Provider.of<DDDetailViewModel>(context).detailModel?.zzmel2??'',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号3"
          DDComponent.tagAndTextVertical('dd_chapter_no3', Provider.of<DDDetailViewModel>(context).detailModel?.zzmel3??'',bgColor: KColor.zebraColor3),
          //MEL/CDL章节号4"
          DDComponent.tagAndTextVertical('dd_chapter_no4', Provider.of<DDDetailViewModel>(context).detailModel?.zzmel4??'',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号5
          DDComponent.tagAndTextVertical('dd_chapter_no5', Provider.of<DDDetailViewModel>(context).detailModel?.zzmel??'',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('analysis_results'),
          //性能分析结果
          DDComponent.tagAndTextVertical('', '这是性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果一种用于高速计算的电子计算机',bgColor: KColor.zebraColor2),

        ]
    );
  }
  //待批准
  Widget uiForAudit(){

    return Column(children: <Widget>[
      DDComponent.zebraTitle('operation_info'),
      DDComponent.tagAndTextHorizon('dd_applicant', Provider.of<DDDetailViewModel>(context).detailModel?.applyBy??'', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', Provider.of<DDDetailViewModel>(context).detailModel?.applyDate??'', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //批准日期
      Container(
        padding: EdgeInsets.fromLTRB(15,5, 15, 5),
        color: KColor.zebraColor2,
        child:Row(
          children: <Widget>[
            Container(child:Text(Translations.of(context).text('dd_dealDate'),style: TextStyle(fontSize: KFont.formTitle)),width: ScreenUtil().setWidth(220)),
            Expanded(child:

            DDTextFieldUtil.ddTextField(
              context,
              tag:'dd_dealDate',
              textFieldNodes: _textFieldNodes,
              node: _dateNode,
              controller: _dateTextField,
              hasSuffix: true,
              suffixIsIcon: true,
              suffix: new IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: new Icon(
                    Icons.event,
                    size: 20,
                    color: KColor.textColor_99,
                  ),
                  onPressed:(){
                    //弹出日历
                    _ddTimePicker.ddSelectDate(context).then((val){
                      _dateTextField.text=DateUtil.formateYMD(val);
                    });
                  }),
            )
            ),
          ],
        ) ,
      ),
      DDComponent.tagAndButtonHorizon('dd_dealPerson', 'temporary_dd_signButton',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      SizedBox(height: 10,),
      OperationButton.createButton('dd_audit_btn',
                ()async{
                bool success= await approveVM.approve(detailVM.detailModel.ddid);
                if(success){
                  Navigator.of(context).pop();
                }

            },size: Size(double.infinity, 120)),

    ],);
  }
  //未关闭
  Widget uiForUnClose(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('operation_info'),
      //申请，
      DDComponent.tagAndTextHorizon('dd_applicant', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //批准
      DDComponent.tagAndTextHorizon('dd_auditPerson', '周周', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_auditDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //已转办未审批
      Offstage(
          offstage: !transfer,
          child:Column(children: <Widget>[
            DDComponent.tagAndTextVertical('dd_dealResult', '是以角度（数学上最常用弧度制，下同）为自变量，角度对应任意角终边与单位圆交点坐标或其比值为因变量的函数。',color: Colors.red,bgColor: KColor.zebraColor2) ,
            DDComponent.tagAndTextHorizon('dd_dealDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
            DDComponent.tagAndTextHorizon('dd_dealPerson', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          ],
          )
      ),
      Offstage(
        offstage: transfer,
        child: DDComponent.tagAndButtonHorizon('dd_dealPerson', 'temporary_dd_signButton',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          Expanded(child: OperationButton.createButton('temporary_dd_deleteButton',
                  ()async{
                //删除DD（是否发送omis）
                  bool deleteSuccess=  await deleteVM.delete(detailVM.detailModel.ddid);
                  if(deleteSuccess){
                    Navigator.of(context);
                  }
              },state:transfer? DDOperateButtonState.enable:DDOperateButtonState.able,size: Size(ScreenUtil.screenWidth/3.0-10,120)),),
          Expanded(child: OperationButton.createButton('dd_delay_btn',
                  (){
                //DD延期
                Application.router.navigateTo(
                    context,
                    "/addDDPage/"+'fromDDDelay',
                    transition: TransitionType.fadeIn).then((val){
                  setState(() {
                    widget.trans=val;
                  });
                });
              },state:transfer? DDOperateButtonState.enable:DDOperateButtonState.able,size: Size(ScreenUtil.screenWidth/3.0-10,120)),),
          Expanded(child: OperationButton.createButton('temporary_dd_transferButton',
                  (){
                //DD转办
                Application.router.navigateTo(
                    context,
                    "/addDDPage/"+'fromDDTransfer',
                    transition: TransitionType.fadeIn).then((val){
                  setState(() {
                    widget.trans=val;
                  });
                });
                //跳转到转DD界面
              },state:transfer? DDOperateButtonState.enable:DDOperateButtonState.able,size: Size(ScreenUtil.screenWidth/3.0-10,120)),),



        ],)
    ],);
  }
  //待排故
  Widget uiForTroubleshooting(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('operation_info'),
      //申请，
      DDComponent.tagAndTextHorizon('dd_applicant', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //批准
      DDComponent.tagAndTextHorizon('dd_auditPerson', '周周', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_auditDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //处理结果
      Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        color: KColor.zebraColor2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                Translations.of(context).text('dd_dealResult'),
                style: TextStyle(fontSize: KFont.formTitle)
            ),
            SizedBox(height: 10,),
            DDTextFieldUtil.ddTextField(context,tag:'dd_dealResult',textFieldNodes: this._textFieldNodes,
                node: _resultNode,
                controller: _resultTextField,
                multiline: true

            ) ,
          ],
        ),
      ),
      //处理
      Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        color: KColor.zebraColor3,
        child:Row(
          children: <Widget>[
            Container(child:Text(Translations.of(context).text('dd_dealDate'),style: TextStyle(fontSize: KFont.formTitle)),width: ScreenUtil().setWidth(220)),
            Expanded(child:
              DDTextFieldUtil.ddTextField(
                context,
                tag:'dd_dealDate',
                textFieldNodes: _textFieldNodes,
                node: _dateNode,
                controller: _dateTextField,
                hasSuffix: true,
                suffixIsIcon: true,
                suffix: new IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: new Icon(
                  Icons.event,
                  size: 20,
                  color: KColor.textColor_99,
                  ),
                  onPressed:(){
                  //弹出日历
                  _ddTimePicker.ddSelectDate(context).then((val){
                  _dateTextField.text=DateUtil.formateYMD(val);
                  });
                  }
                  ),
              )
            )
          ],
        ) ,
      ),
      DDComponent.tagAndButtonHorizon('dd_shootingPerson', 'temporary_dd_signButton',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      SizedBox(height: 10,),
      OperationButton.createButton('dd_ensure_shooting',
                  ()async{
                //对接审批接口
//                print('确认排故');
               bool success= await shootingVM.shooting(detailVM.detailModel.ddid);
               if(success){
                 Navigator.of(context).pop();
               }
              },size:Size (double.infinity,120)),

    ],);
  }
  //待检验
  Widget uiForInspection(){
    return  Column(children: <Widget>[
      DDComponent.zebraTitle('operation_info'),
      //申请
      DDComponent.tagAndTextHorizon('dd_applicant', '周周', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', '2020-12-03', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //批准
      DDComponent.tagAndTextHorizon('dd_auditPerson', '周周', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_auditDate', '2020-12-03', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //排故
      DDComponent.tagAndTextHorizon('dd_shootingPerson', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_shootingDate', '2020-12-03', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //处理结果
      Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        color: KColor.zebraColor2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                Translations.of(context).text('dd_dealResult'),
                style: TextStyle(fontSize: KFont.formTitle)
            ),
            SizedBox(height: 10,),
            DDTextFieldUtil.ddTextField(context,tag:'dd_dealResult',textFieldNodes: this._textFieldNodes,
                node: _resultNode,
                controller: _resultTextField,
                multiline: true

            ) ,
          ],
        ),
      ),
      //处理日期
      Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        color: KColor.zebraColor3,
        child:Row(
          children: <Widget>[
            Container(child:Text(Translations.of(context).text('dd_dealDate'),style: TextStyle(fontSize: KFont.formTitle)),width: ScreenUtil().setWidth(220)),
            Expanded(child:
              DDTextFieldUtil.ddTextField(
              context,
              tag:'dd_dealDate',
              textFieldNodes: _textFieldNodes,
              node: _dateNode,
              controller: _dateTextField,
              hasSuffix: true,
              suffixIsIcon: true,
              suffix: new IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: new Icon(
              Icons.event,
              size: 20,
              color: KColor.textColor_99,
              ),
              onPressed:(){
              //弹出日历
              _ddTimePicker.ddSelectDate(context).then((val){
              _dateTextField.text=DateUtil.formateYMD(val);
              });
              }
              ),
              ))
           ],
        ) ,
      ),
      DDComponent.tagAndButtonHorizon('dd_inspectionPerson', 'temporary_dd_signButton',  textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      SizedBox(height: 10,),
      OperationButton.createButton('dd_ensure_inspection',
                  ()async{
                //对接审批接口
                print('确认检验');
                bool success= await closeVM.close(detailVM.detailModel.ddid);
                if(success){
                  Navigator.of(context).pop();
                }

              },size:Size (double.infinity,120)),
    ],);
  }
  //已转办
  Widget uiForDDTransfer(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('operation_info'),
      //申请，
      DDComponent.tagAndTextHorizon('dd_applicant', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //批准
      DDComponent.tagAndTextHorizon('dd_auditPerson', '周周', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_auditDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //处理结果
      DDComponent.tagAndTextVertical('dd_dealResult', '是以角度（数学上最常用弧度制，下同）为自变量，角度对应任意角终边与单位圆交点坐标或其比值为因变量的函数。',color: Colors.red,bgColor: KColor.zebraColor2) ,
      DDComponent.tagAndTextHorizon('dd_dealDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      DDComponent.tagAndTextHorizon('dd_dealPerson', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
    ],);
  }
  //
  Widget bottomWidget(){

    if(widget.state==DDState.toAudit){
      //待批准
      stateStr='to_Audit';
      return uiForAudit();

    }else if(widget.state==DDState.unClose){
      //未关闭
      stateStr='un_close';
      return uiForUnClose();

    }else if(widget.state==DDState.forTroubleshooting){
      //待排故
      stateStr='forTroubleShooting';
      return uiForTroubleshooting();
    } else if(widget.state==DDState.forInspection){
      //待检验
      stateStr='for_inspection';
      return uiForInspection();
    }else if(widget.state==DDState.haveTransfer){
      //已转办
      stateStr='have_transfer';
      return uiForDDTransfer();
    }else if(widget.state==DDState.hasDelay){
    //已延期
      stateStr='has_delay';
    return uiForDDTransfer();
    }else if(widget.state==DDState.closed){
    //已关闭
      stateStr='closed';
    return uiForDDTransfer();
    }else if(widget.state==DDState.deleted){
    //已删除
      stateStr='deleted';
    return uiForDDTransfer();
    }else if(widget.state==DDState.delayClose){
    //延期关闭
      stateStr='delay_close';
    return uiForDDTransfer();
    }
    else{
      return Container();
    }
  }
  void stateString(){

    if(widget.state==DDState.toAudit){
      //待批准
      stateStr='to_Audit';

    }else if(widget.state==DDState.unClose){
      //未关闭
      stateStr='un_close';


    }else if(widget.state==DDState.forTroubleshooting){
      //待排故
      stateStr='forTroubleShooting';

    } else if(widget.state==DDState.forInspection){
      //待检验
      stateStr='for_inspection';

    }else if(widget.state==DDState.haveTransfer){
      //已转办
      stateStr='have_transfer';

    }else if(widget.state==DDState.hasDelay){
      //已延期
      stateStr='has_delay';

    }else if(widget.state==DDState.closed){
      //已关闭
      stateStr='closed';

    }else if(widget.state==DDState.deleted){
      //已删除
      stateStr='deleted';

    }else if(widget.state==DDState.delayClose){
      //延期关闭
      stateStr='delay_close';

    }
  }
  void dealTransfer(){
    if (widget.trans=='1'){
      this.transfer=true;
    }else{
      this.transfer=false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textFieldNodes=[_resultNode,_dateNode];
    deleteVM=new DeleteDDViewModel();
    approveVM=new ApproveDDViewModel();
    shootingVM=new TroubleShootingViewModel();
    closeVM=new CloseDDViewModel();

    detailVM=Provider.of<DDDetailViewModel>(context,listen: false);
    detailVM.fetchDetail(widget.ddId);
  }
  @override
  Widget build(BuildContext context) {
    dealTransfer();
    stateString();
    return Scaffold(
      appBar: AppBar(
        title:Text(Translations.of(context).text('dd_detail_page'), style: TextThemeStore.textStyleAppBar,),
      ),
      body:SingleChildScrollView(
        child:Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                createUI(context) ,
                bottomWidget(),
              ],
            ),

          ],
        )
      ), //autoListView(),//manuallyListView(),
    ) ;

  }
}
