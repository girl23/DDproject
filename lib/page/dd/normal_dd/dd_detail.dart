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
// ignore: must_be_immutable
class DDDetail extends StatefulWidget {
  String trans;//记录DD准办，DD延期来控制按钮禁用
  DDState state;
  DDDetail(this.trans,this.state);
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
                  child:Text('dd状态',style: TextStyle(fontSize: KFont.bigTitle,color: Colors.blue)),
                ),
              ],
            ) ,
          ),
          DDComponent.zebraTitle('基本信息'),
          //维修单位代码
          DDComponent.tagAndTextHorizon('dd_MBCode', '成都分公司',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //保留故障编号
          DDComponent.tagAndTextHorizon('dd_number1', '0241412411',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //工作指令号
          DDComponent.tagAndTextHorizon('dd_WorkNO','A+=0241412411',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //转录自何文件
          DDComponent.tagAndTextHorizon('dd_from','300005252',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('飞机信息'),
          //飞机号
          DDComponent.tagAndTextHorizon('dd_planeNo', '1002', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //发动机/APU序号
          DDComponent.tagAndTextHorizon('dd_ENG','A00030498UF',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('报告信息'),
          //首次报告日期
          DDComponent.tagAndTextHorizon('dd_firstReportDate', '1002', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //首次报告地点
          DDComponent.tagAndTextHorizon('dd_firstReportPlace', '1002',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('计划保留信息'),
          //起始日期/飞机总飞行小时/循环
          DDComponent.tagAndTextHorizon('dd_startDate', '1002/33/533',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //计划保留天数/小时/循环
          DDComponent.tagAndTextHorizon('dd_plan_keep_time', '1002/33/533',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //折算到期期限/保留至飞行小时/飞行循环
          DDComponent.tagAndTextHorizon('dd_endDate', '1002/33/533',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //计划保留间隔描述
          DDComponent.tagAndTextVertical('dd_plan_keep_describe', '其它-——现代一种用于高速计算的电子计算机器，可以进行数值计算，其它-——现代一种用于高速计算的电子计算机器，可以进行数值计算，其它-——现代一种用于高速计算的电子计算机器，可以进行数值计算，',bgColor: KColor.zebraColor3),
          //保留报告及临时措施
          DDComponent.tagAndTextVertical('dd_keepMeasure', '三角函数一般用于计算三角形中未知长度的边和未知的角度，在导航、工程学以及物理学方面都有广泛的用途。另外，以三角函数为模版，可以定义一类相似的函数，叫做双曲函数。',bgColor: KColor.zebraColor2),
          DDComponent.zebraTitle('维修信息'),
          //名称
          DDComponent.tagAndTextVertical('dd_name', '是现代一种用于高速计算的电子计算机器，可以进行数值计算，子设',bgColor: KColor.zebraColor2),
          //件号
          DDComponent.tagAndTextVertical('dd_jno', '10-02',bgColor: KColor.zebraColor3),
          //数量
          DDComponent.tagAndTextHorizon('dd_Num', '15/22/2234',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //ATA章节
          DDComponent.tagAndTextHorizon('dd_chapter', '10-22-234', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //保留故障分类
          DDComponent.tagAndTextHorizon('dd_keep_faultCategory', 'CBS_F', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //影响服务程度
          DDComponent.tagAndTextHorizon('dd_influence', '一般', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //所需停场时间
          DDComponent.tagAndTextHorizon('dd_need_parking_time', '2h',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //所需工时
          DDComponent.tagAndTextHorizon('dd_need_work_time', '3h', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('相关限制'),
          //使用限制
          DDComponent.tagAndTextHorizon('dd_use_limit', '其它',  textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //其它限制描述
          DDComponent.tagAndTextVertical('dd_use_limit_describe', '现代一种用于高速计算的电子计算机器，可以进行数值计算，子',bgColor: KColor.zebraColor3),
         //是否有M项要求
          DDComponent.tagAndTextHorizon('dd_need_m', '是',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //是否有运行限制
          DDComponent.tagAndTextHorizon('dd_need_run_limit', '是',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //需AMC处理标识
          DDComponent.tagAndTextHorizon('dd_need_amc', '是', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //是否放入机上"保留故障单夹"
          DDComponent.tagAndTextHorizon('dd_needKeepToFold', '是', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
          //是否有重检要求
          DDComponent.tagAndTextHorizon('dd_needRepeatInspection', '是', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('保留原因代码'),
          //保留原因代码
          DDComponent.tagAndTextVertical('', 'OI：观察项目，LS：缺航材',bgColor: KColor.zebraColor2),

          DDComponent.zebraTitle('依据类型'),
          //依据类型
          DDComponent.tagAndTextHorizon('dd_evidence_type', 'MEL',textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号1"
          DDComponent.tagAndTextVertical('dd_chapter_no1', '一种用于高速计算的电子计算机用于高速计算的电子计算机用于高速计算的电子计算机', bgColor: KColor.zebraColor3),
          //MEL/CDL章节号2"
          DDComponent.tagAndTextVertical('dd_chapter_no2', '一种用于高速计算的电子计算机',bgColor: KColor.zebraColor2),
          //MEL/CDL章节号3"
          DDComponent.tagAndTextVertical('dd_chapter_no3', '一种用于高速计算的电子计算机', bgColor: KColor.zebraColor3),
          //MEL/CDL章节号4"width:
          DDComponent.tagAndTextVertical('dd_chapter_no4', '一种用于高速计算的电子计算机', bgColor: KColor.zebraColor2),
          //MEL/CDL章节号
          DDComponent.tagAndTextVertical('dd_chapter_no5', '一种用于高速计算的电子计算机', bgColor: KColor.zebraColor3),
          DDComponent.zebraTitle('性能分析结果'),
          //性能分析结果
          DDComponent.tagAndTextVertical('', '这是性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果性能分析结果一种用于高速计算的电子计算机',bgColor: KColor.zebraColor2),

        ]
    );
  }
  //待批准
  Widget uiForAudit(){

    return Column(children: <Widget>[
      DDComponent.zebraTitle('操作信息'),
      DDComponent.tagAndTextHorizon('dd_applicant', '周周', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor2),
      DDComponent.tagAndTextHorizon('dd_applicationDate', '2020-12-03', textAlignment: 'spaceBetween',bgColor: KColor.zebraColor3),
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
                (){
          //对接审批接口
                  print('批准');
                  Navigator.of(context).pop();
            },size: Size(double.infinity, 120)),

    ],);
  }
  //未关闭
  Widget uiForUnClose(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('操作信息'),
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
                  (){
                //删除DD（是否发送omis）
                Navigator.of(context).pop();
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
      DDComponent.zebraTitle('操作信息'),
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
                  (){
                //对接审批接口
                print('确认排故');
                Navigator.of(context).pop();
              },size:Size (double.infinity,120)),

    ],);
  }
  //待检验
  Widget uiForInspection(){
    return  Column(children: <Widget>[
      DDComponent.zebraTitle('操作信息'),
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
                  (){
                //对接审批接口
                print('确认检验');
                Navigator.of(context).pop();
              },size:Size (double.infinity,120)),
    ],);
  }
  //已转办
  Widget uiForDDTransfer(){
    return Column(children: <Widget>[
      DDComponent.zebraTitle('操作信息'),
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
      return uiForAudit();
    }else if(widget.state==DDState.unClose){
      //未关闭
      return uiForUnClose();
    }else if(widget.state==DDState.forTroubleshooting){
      //待排故
      return uiForTroubleshooting();
    } else if(widget.state==DDState.forInspection){
      //待检验
      return uiForInspection();
    }else if(widget.state==DDState.haveTransfer){
      //已转办
      return uiForDDTransfer();
    }else if(widget.state==DDState.hasDelay){
    //已延期
    return uiForDDTransfer();
    }else if(widget.state==DDState.closed){
    //已关闭
    return uiForDDTransfer();
    }else if(widget.state==DDState.deleted){
    //已删除
    return uiForDDTransfer();
    }else if(widget.state==DDState.delayClose){
    //延期关闭
    return uiForDDTransfer();
    }
    else{
      return Container();
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
  }
  @override
  Widget build(BuildContext context) {
    dealTransfer();
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
