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
// ignore: must_be_immutable
class TemporaryDDDetail extends StatefulWidget {
  String trans;
  String stateStr;
  TemporaryDDState state;
  TemporaryDDDetail(this.trans,this.state);

  @override
  _TemporaryDDDetailState createState() => _TemporaryDDDetailState();
}

class _TemporaryDDDetailState extends State<TemporaryDDDetail> {
  bool transfer=false;
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
                  child:Text('FLNO2324',style: TextStyle(fontSize: KFont.bigTitle,color: KColor.zebraColor1)),
                ),
                Container(
                  alignment: Alignment.centerRight,//Alignment.centerLeft,
                  child:Text(widget.stateStr??'',style: TextStyle(fontSize: KFont.bigTitle,color: Colors.blue)),
                ),
              ],
            ) ,
          ),
          DDComponent.zebraTitle('基本信息'),
          //编号
          DDComponent.tagAndTextHorizon('dd_number', '1002',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //飞机号
          DDComponent.tagAndTextHorizon('dd_planeNo', '1002',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //保留人员
          DDComponent.tagAndTextHorizon('dd_keepPerson', '1002',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //联系电话
          DDComponent.tagAndTextHorizon('dd_phoneNumber', '1002',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //传真
          DDComponent.tagAndTextHorizon('dd_fax', '1002',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('报告信息'),
          //报告日期
          DDComponent.tagAndTextHorizon('dd_reportDate', '1002',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //报告地点
          DDComponent.tagAndTextHorizon('dd_reportPlace', '1002', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),

          DDComponent.zebraTitle('计划保留信息'),
          //计划保留天数/小时/循环
          DDComponent.tagAndTextHorizon('dd_plan_keep_time', '20233/34/44', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //计划保留间隔描述
          DDComponent.tagAndTextVertical('dd_plan_keep_describe', '其它-——现代一种用于高速计算的电子计算机器，可以进行数值计算，其它-——现代一种用于高速计算的电子计算机器，可以进行数值计算，其它-——现代一种用于高速计算的电子计算机器，可以进行数值计算，',bgColor: KColor.zebraColor3),

          //保留报告及临时措施
          DDComponent.tagAndTextVertical('dd_keepMeasure', '三角函数一般用于计算三角形中未知长度的边和未知的角度，在导航、工程学以及物理学方面都有广泛的用途。另外，以三角函数为模版，可以定义一类相似的函数，叫做双曲函数。',bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('维修信息'),
          //名称
          DDComponent.tagAndTextVertical('dd_name', '是现代一种用于高速计算的电子计算机器，可以进行数值计算，子设',bgColor: KColor.zebraColor2),
          //件号
          DDComponent.tagAndTextVertical('dd_jno', '是现代一种用于高速计算的电子计算机器，可以进行数值计算',bgColor: KColor.zebraColor3),
          //数量
          DDComponent.tagAndTextHorizon('dd_Num', '15/22/2234',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          //ATA章节
          DDComponent.tagAndTextHorizon('dd_chapter', '10-22-234',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //保留故障分类
          DDComponent.tagAndTextHorizon('dd_keep_faultCategory', 'CBS_F',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //影响服务程度
          DDComponent.tagAndTextHorizon('dd_influence', '一般',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //所需停场时间
          DDComponent.tagAndTextHorizon('dd_need_parking_time', '2h',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //所需工时
          DDComponent.tagAndTextHorizon('dd_need_work_time', '3h',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //执管单位DD计划员
          DDComponent.tagAndTextHorizon('dd_plan_operator', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('相关限制'),
          //使用限制
          DDComponent.tagAndTextHorizon('dd_use_limit', '其它',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //其它限制描述

          DDComponent.tagAndTextVertical('dd_use_limit_describe', '现代一种用于高速计算的电子计算机器，可以进行数值计算，子',bgColor: KColor.zebraColor3),

          //是否有M项要求
          DDComponent.tagAndTextHorizon('dd_need_m', '是',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //是否有运行限制
          DDComponent.tagAndTextHorizon('dd_need_run_limit', '是',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //需AMC处理标识
          DDComponent.tagAndTextHorizon('dd_need_amc', '是',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('保留原因代码'),
          DDComponent.tagAndTextVertical('', 'OI：观察项目，LS：缺航材',bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('依据类型'),
          //依据类型
          DDComponent.tagAndTextHorizon('dd_evidence_type', 'MEL',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号1"
          DDComponent.tagAndTextVertical('dd_chapter_no1', '一种用于高速计算的电子计算机用于高速计算的电子计算机用于高速计算的电子计算机',bgColor: KColor.zebraColor3),
          //MEL/CDL章节号2"
          DDComponent.tagAndTextVertical('dd_chapter_no2', '一种用于高速计算的电子计算机',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号3"
          DDComponent.tagAndTextVertical('dd_chapter_no3', '一种用于高速计算的电子计算机',bgColor: KColor.zebraColor3),
          //MEL/CDL章节号4"
          DDComponent.tagAndTextVertical('dd_chapter_no4', '一种用于高速计算的电子计算机',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号5
          DDComponent.tagAndTextVertical('dd_chapter_no5', '一种用于高速计算的电子计算机',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('性能分析结果'),
          //性能分析结果
          DDComponent.tagAndTextVertical('', '这是性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果一种用于高速计算的电子计算机',bgColor: KColor.zebraColor2),

        ]
    );
  }
  Widget uiForUnClose(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('操作信息'),
      //申请
      DDComponent.tagAndTextHorizon('dd_applicant', '周周',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', '2020-12-03',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
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
                    (){
                  //删除临保（是否发送omis）
                  Navigator.of(context);
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
      DDComponent.zebraTitle('操作信息'),
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
      widget.stateStr='未关闭';
    }else if(widget.state==TemporaryDDState.closed){
      //已关闭
      widget.stateStr='已关闭';
    }else{
      //已删除
      widget.stateStr='已删除';
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