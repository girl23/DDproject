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
import 'package:lop/router/application.dart';
import 'package:lop/viewmodel/dd/dd_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lop/viewmodel/dd/delete_dd_viewmodel.dart';

// ignore: must_be_immutable
class TemporaryDDDetail extends StatefulWidget {
  String trans;
  TemporaryDDState state;
  String ddId;
  String stateStr;

  TemporaryDDDetail({this.trans,this.state,this.ddId});

  @override
  _TemporaryDDDetailState createState() => _TemporaryDDDetailState();
}

class _TemporaryDDDetailState extends State<TemporaryDDDetail> {


  bool transfer=false;
  DDDetailViewModel detailVM;
  DeleteDDViewModel deleteVM;
  Widget createUI(BuildContext context){
    String eviType;
    if(detailVM.detailModel?.zzrectype=='0'){
      eviType='MEL';
    }else if(detailVM.detailModel?.zzrectype=='1'){
      eviType='CDL';
    }else{
      eviType=Translations.of(context).text('dd_other');
    }
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
                  child:Text(detailVM.detailModel?.zzblno,style: TextStyle(fontSize: KFont.bigTitle,color: KColor.zebraColor1)),
                ),
                Container(
                  alignment: Alignment.centerRight,//Alignment.centerLeft,
                  child:Text( Translations.of(context).text(widget.stateStr)??'',style: TextStyle(fontSize: KFont.bigTitle,color: Colors.blue)),
                ),
              ],
            ) ,
          ),
          DDComponent.zebraTitle('base_info'),
          //编号
          DDComponent.tagAndTextHorizon('dd_number', detailVM.detailModel?.zzblno,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //飞机号
          DDComponent.tagAndTextHorizon('dd_planeNo', detailVM.detailModel?.zzmsgrp,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //保留人员
          DDComponent.tagAndTextHorizon('dd_keepPerson', detailVM.detailModel?.zzblry,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //联系电话
          DDComponent.tagAndTextHorizon('dd_phoneNumber', detailVM.detailModel?.zzbltel,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //传真
          DDComponent.tagAndTextHorizon('dd_fax', detailVM.detailModel?.zzblfax,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('report_info'),
          //报告日期
          DDComponent.tagAndTextHorizon('dd_reportDate', detailVM.detailModel?.zzbgdt,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //报告地点
          DDComponent.tagAndTextHorizon('dd_reportPlace', detailVM.detailModel?.zzddscbgdd, textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),

          DDComponent.zebraTitle('plan_info'),
          //计划保留天数/小时/循环
          DDComponent.tagAndTextHorizon('dd_plan_keep_time', '${detailVM.detailModel?.zzdefdy}/${detailVM.detailModel?.zzblfxxs}/${detailVM.detailModel?.zzblfxxh}', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //计划保留间隔描述
          DDComponent.tagAndTextVertical('dd_plan_keep_describe', detailVM.detailModel?.zzgzms,bgColor: KColor.zebraColor3),

          //保留报告及临时措施
          DDComponent.tagAndTextVertical('dd_keepMeasure', detailVM.detailModel?.ddreport,bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('Maintenance_info'),
          //名称
          DDComponent.tagAndTextVertical('dd_name', detailVM.detailModel?.toolname,bgColor: KColor.zebraColor2),
          //件号
          DDComponent.tagAndTextVertical('dd_jno', detailVM.detailModel?.partno,bgColor: KColor.zebraColor3),
          //数量
          DDComponent.tagAndTextHorizon('dd_Num', '${detailVM.detailModel?.falqty}/${detailVM.detailModel?.relqty}/${detailVM.detailModel?.instqty}',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          //ATA章节
          DDComponent.tagAndTextHorizon('dd_chapter', '${detailVM.detailModel?.zzatazj}-${detailVM.detailModel?.zzatazj2}-${detailVM.detailModel?.zztatzj3}',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //保留故障分类
          DDComponent.tagAndTextHorizon('dd_keep_faultCategory', detailVM.detailModel?.zzblclf,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //影响服务程度
          DDComponent.tagAndTextHorizon('dd_influence', detailVM.detailModel?.zzyxfwcd,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //所需停场时间
          DDComponent.tagAndTextHorizon('dd_need_parking_time', detailVM.detailModel?.zzytsj,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //所需工时
          DDComponent.tagAndTextHorizon('dd_need_work_time', detailVM.detailModel?.zzsxgs,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //执管单位DD计划员zzddplanner
          DDComponent.tagAndTextHorizon('dd_plan_operator', detailVM.detailModel?.zzddplanner,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('restrictions'),
          //使用限制
          DDComponent.tagAndTextHorizon('dd_use_limit', '${detailVM.detailModel?.zzflgo=='1'?'O项':''} ${detailVM.detailModel?.zzflgoth=='1'?'其它':''}',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //其它限制描述
          Offstage(
            offstage: detailVM.detailModel?.zzflgo!='1',
            child:DDComponent.tagAndTextVertical('dd_use_limit_describe', detailVM.detailModel.zzgzms,bgColor: KColor.zebraColor3),
          ),
          //是否有M项要求
          DDComponent.tagAndTextHorizon('dd_need_m',(detailVM.detailModel?.zzmind=='1')?'是':'否',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //是否有运行限制
          DDComponent.tagAndTextHorizon('dd_need_run_limit', (detailVM.detailModel?.operatingLimits=='1')?'是':'否',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //需AMC处理标识
          DDComponent.tagAndTextHorizon('dd_need_amc', (detailVM.detailModel?.zzamcfg=='1')?'是':'否',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('reason_code'),
          DDComponent.tagAndTextVertical('',detailVM.detailModel?.zzrescode ,bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('evidence_type'),
          //依据类型
          DDComponent.tagAndTextHorizon('dd_evidence_type', eviType,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号1"
          DDComponent.tagAndTextVertical('dd_chapter_no1', detailVM.detailModel?.zzmel,bgColor: KColor.zebraColor3),
          //MEL/CDL章节号2"
          DDComponent.tagAndTextVertical('dd_chapter_no2', detailVM.detailModel?.zzmel2,bgColor: KColor.zebraColor2),
          //MEL/CDL章节号3"
          DDComponent.tagAndTextVertical('dd_chapter_no3', detailVM.detailModel?.zzmel3,bgColor: KColor.zebraColor3),
          //MEL/CDL章节号4"
          DDComponent.tagAndTextVertical('dd_chapter_no4', detailVM.detailModel?.zzmel4,bgColor: KColor.zebraColor2),
          //MEL/CDL章节号5
          DDComponent.tagAndTextVertical('dd_chapter_no5', detailVM.detailModel?.zzmel,bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('analysis_results'),
          //性能分析结果
          DDComponent.tagAndTextVertical('', '这是性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果一种用于高速计算的电子计算机',bgColor: KColor.zebraColor2),

        ]
    );
  }
  Widget uiForUnClose(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('operation_info'),
      //申请
//      DDComponent.tagAndTextHorizon('dd_applicant', detailVM.detailModel?.applyBy,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
//      DDComponent.tagAndTextHorizon('dd_applicationDate', detailVM.detailModel?.applyDate,textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      Offstage(
        offstage: !transfer,
        child:Column(children: <Widget>[
          DDComponent.tagAndTextVertical('dd_dealResult', '是以角度（数学上最常用弧度制，下同）为自变量，角度对应任意角终边与单位圆交点坐标或其比值为因变量的函数。',color: Colors.red,bgColor: KColor.zebraColor2) ,
          DDComponent.tagAndTextHorizon('dd_dealDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.tagAndTextHorizon('dd_dealPerson', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
        ],
        )
      ),
//      Offstage(
//        offstage: transfer,
//        child: DDComponent.tagAndButtonHorizon('dd_dealPerson', 'temporary_dd_signButton',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
//      ),
      SizedBox(height: 20,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child:  OperationButton.createButton('temporary_dd_deleteButton',
                    ()async{
                  //删除临保（是否发送omis）
                  bool deleteSuccess=  await deleteVM.delete(detailVM.detailModel.ddid);
                  if(deleteSuccess){
                    Navigator.of(context);
                  }
                },state:transfer? DDOperateButtonState.enable:DDOperateButtonState.able,size: Size(ScreenUtil.screenWidth,120)),
          ),Expanded(
            child:  OperationButton.createButton('temporary_dd_transferButton',
                    (){
                  //转DD
                  Application.router.navigateTo(
                      context,
                      "/addDDPage/"+'fromTemporaryTransfer',
                      transition: TransitionType.fadeIn).then((val){
                    widget.trans=val;
                  });
                  //跳转到转DD界面
                },state:transfer? DDOperateButtonState.enable:DDOperateButtonState.able,size: Size(ScreenUtil.screenWidth,120)),
          )

      ],)
    ],);
  }
  Widget uiForClose(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('operation_info'),
      //申请
      DDComponent.tagAndTextHorizon('dd_applicant', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      //处理结果
      DDComponent.tagAndTextVertical('dd_dealResult', '是以角度（数学上最常用弧度制，下同）为自变量，角度对应任意角终边与单位圆交点坐标或其比值为因变量的函数。',color: Colors.red,bgColor: KColor.zebraColor2) ,
      DDComponent.tagAndTextHorizon('dd_dealDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
      DDComponent.tagAndTextHorizon('dd_dealPerson', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
    ],);
  }
  Widget bottomWidget(){
    if(widget.state==TemporaryDDState.unClose){
      //未关闭
//      widget.stateStr='未关闭';
      return uiForUnClose();
    }else if(widget.state==TemporaryDDState.closed){
      //已关闭
//      widget.stateStr='已关闭';
      return uiForClose();
    }else{
      //已删除
//      widget.stateStr='已删除';
      return Container();
    }
  }
  void stateStr(){
    if(widget.state==TemporaryDDState.unClose){
      //未关闭
      widget.stateStr='un_close';
    }else if(widget.state==TemporaryDDState.closed){
      //已关闭
      widget.stateStr='closed';
    }else{
      //已删除
      widget.stateStr='deleted';
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
    deleteVM=new DeleteDDViewModel();
    detailVM=Provider.of<DDDetailViewModel>(context,listen: false);
    detailVM.fetchDetail(widget.ddId);

  }
  @override
  Widget build(BuildContext context) {
    dealTransfer();
    stateStr();
    return Scaffold(
      appBar: AppBar(
        title:Text(Translations.of(context).text('temporary_dd_detail_page'), style: TextThemeStore.textStyleAppBar,),
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
//            Align(
//              alignment: FractionalOffset.topRight,
//              child:Container(padding: EdgeInsets.fromLTRB(0,10,15,0),child:Text(widget.stateStr,style: TextStyle(fontSize: KFont.formTitle,color: Colors.blue)),),
//            ),
          ],
        )
      ), //autoListView(),//manuallyListView(),
    ) ;

  }
}
class UserInfoModel{
  String name;   //item是否打开
  int age;
  UserInfoModel(this.name, this.age); //item中的索引
}