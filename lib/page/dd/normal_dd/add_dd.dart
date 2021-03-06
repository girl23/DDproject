import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:provider/provider.dart';
import '../dd_textfield_util.dart';
import '../operation_button_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../dd_date_time_picker_util.dart';
import 'package:lop/utils/date_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/config/enum_config.dart';
import '../component/dd_component.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/page/dd/dd_calculate_date_provide.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_end_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_text_and_texfield_with_calender.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_space_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_start_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_mbcode_drop.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_faultcategory_drop.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_influence_drop.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_evidence_drop.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_use_limit_check.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_keep_reason_check.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_need_check.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_num_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_chapter_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_describe_tf.dart';
import 'package:lop/database/normal_dd_model.dart';
import 'package:lop/database/normal_dd_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
import 'package:lop/page/dd/dd_card_decoration.dart';
import 'package:provider/provider.dart';
import 'package:lop/viewmodel/dd/add_dd_viewmodel.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:lop/viewmodel/dd/dd_detail_viewmodel.dart';
import 'package:lop/viewmodel/dd/transfer_dd_viewmodel.dart';
import 'package:lop/viewmodel/dd/deal_result_viewmodel.dart';
import 'package:lop/viewmodel/dd/delay_dd_viewmodel.dart';
import 'package:lop/viewmodel/dd/transfer_viewmodel.dart';
import 'package:lop/router/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:lop/model/dd/dd_public_model.dart';

class AddDD extends StatefulWidget {
  final comeFromPage fromPage;
  AddDD(this.fromPage);
  @override
  _AddDDState createState() => _AddDDState();
}
class _AddDDState extends State<AddDD> {
  //存储焦点
  //下拉
  String _dropValueForFaultCategory;
  String _dropValueForInfluence;
  String _dropValueForEvidence;
  String _dropValueForMBCode;
  //复选框
  bool _checkValueOOption=false;
  bool _checkValueOtherOption=false;
  bool _checkValueOIOption=false;
  bool _checkValueLSOption=false;
  bool _checkValueSGOption=false;
  bool _checkValueSPOption=false;

  bool _checkValueMOption=false;
  bool _checkValueRunOption=false;
  bool _checkValueAMCOption=false;
  //dd
  bool _checkValueKeepFoldOption=false;
  bool _checkValueRepeatInspectionOption=false;
  //焦点
  //DD
  FocusNode _workNoNode = new FocusNode();
  FocusNode _engNode = new FocusNode();
  FocusNode _fromNode = new FocusNode();
  FocusNode _startDateNode = new FocusNode();
  FocusNode _totalHourNode = new FocusNode();
  FocusNode _totalCycleNode = new FocusNode();
  FocusNode _endDateNode = new FocusNode();
  FocusNode _endHourNode = new FocusNode();
  FocusNode _endCycleNode = new FocusNode();
  FocusNode _applyDateNode = new FocusNode();
  //共用
  FocusNode _numberFocusNode = new FocusNode();
  FocusNode _planeNoFocusNode = new FocusNode();
  FocusNode _reportDateFocusNode = new FocusNode();
  FocusNode _reportPlaceFocusNode = new FocusNode();
  FocusNode _keepMeasureNode = new FocusNode();
  FocusNode _nameNode = new FocusNode();
  FocusNode _jnoNode = new FocusNode();//件号
  FocusNode _faultNumNode = new FocusNode();
  FocusNode _installNumNode = new FocusNode();
  FocusNode _releaseNumNode = new FocusNode();
  FocusNode _chapter1Node = new FocusNode();
  FocusNode _chapter2Node = new FocusNode();
  FocusNode _chapter3Node = new FocusNode();
  FocusNode _otherNode = new FocusNode();
  FocusNode _dayNode = new FocusNode();
  FocusNode _hourNode = new FocusNode();
  FocusNode _cycleNode = new FocusNode();
  FocusNode _describeNode = new FocusNode();
  FocusNode _needParkingTimeNode = new FocusNode();
  FocusNode _needWorkHourNode = new FocusNode();
  FocusNode _planOperatorNode = new FocusNode();
  FocusNode _chapterNo1Node = new FocusNode();
  FocusNode _chapterNo2Node = new FocusNode();
  FocusNode _chapterNo3Node = new FocusNode();
  FocusNode _chapterNo4Node = new FocusNode();
  FocusNode _chapterNo5Node = new FocusNode();

  FocusNode _dealResultNode = new FocusNode();


  //控制器
  TextEditingController _workNoController = new TextEditingController();
  TextEditingController _engController = new TextEditingController();
  TextEditingController _fromController = new TextEditingController();
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _totalHourController = new TextEditingController();
  TextEditingController _totalCycleController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  TextEditingController _endHourController = new TextEditingController();
  TextEditingController _endCycleController = new TextEditingController();
  TextEditingController _applyDateController = new TextEditingController();

  TextEditingController _numberController = new TextEditingController();
  TextEditingController _planeNoController = new TextEditingController();
  TextEditingController _reportDateController = new TextEditingController();
  TextEditingController _reportPlaceController = new TextEditingController();
  TextEditingController _keepMeasureController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _jnoController = new TextEditingController();
  TextEditingController _faultNumController = new TextEditingController();
  TextEditingController _installNumController = new TextEditingController();
  TextEditingController _releaseNumController = new TextEditingController();
  TextEditingController _chapter1Controller = new TextEditingController();
  TextEditingController _chapter2Controller = new TextEditingController();
  TextEditingController _chapter3Controller = new TextEditingController();
   TextEditingController _otherController = new TextEditingController();
   TextEditingController _dayController = new TextEditingController();
   TextEditingController _hourController = new TextEditingController();
   TextEditingController _cycleController = new TextEditingController();
   TextEditingController _describeController = new TextEditingController();
   TextEditingController _needParkingTimeController = new TextEditingController();
   TextEditingController _needWorkHourController = new TextEditingController();
   TextEditingController _chapterNo1Controller = new TextEditingController();
   TextEditingController _chapterNo2Controller = new TextEditingController();
   TextEditingController _chapterNo3Controller = new TextEditingController();
   TextEditingController _chapterNo4Controller = new TextEditingController();
   TextEditingController _chapterNo5Controller = new TextEditingController();
  TextEditingController _dealResultController = new TextEditingController();

 //时间选择器
 DateTimePicker _ddTimePicker=new DateTimePicker();
 List _textFieldNodes;

 String _navTitle;
 String _sureButtonTitle;
 String _titleForDateSelect;
 String _titleForSignPerson;
 List _controllers;
 List _textFieldTagNames;
 int lastIndex;
 FocusNode lastNode;
 NormalDDDbModel normalDDDbModel;
 AddDDViewModel addModel;
 TransferDDViewModel transferDDVM;//临保转DD
  TransferViewModel transferVM;//DD转DD
 DDDetailViewModel detailVM;
 DealResultViewModel dealResultVM;
 DelayDDViewModel delayVM;
 ProgressDialog _loadingDialog;
 Widget createUI(BuildContext context){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15,),
        DDCardDecoration(
            title:'base_info' ,
            childWidget: Column(
              children: <Widget>[
                //临保转DD，增加转自临保单号
                Offstage(
                  offstage:!(widget.fromPage==comeFromPage.fromTemporaryTransfer),
                  child:DDComponent.tagAndTextHorizon('dd_comeFromTemporaryTransfer', detailVM.detailModel?.zzblno,width:330,notBoldTitle:true,color: KColor.textColor_66),),
                //DD转办，增加首办号，即第一份DD编号
                Offstage(
                  offstage:!(widget.fromPage==comeFromPage.fromDDTransfer||(widget.fromPage==comeFromPage.fromDDDelay)),
                  child:DDComponent.tagAndTextHorizon('dd_comeFromDDTransfer', detailVM.detailModel?.zzfstnm,width:330,notBoldTitle:true,color: KColor.textColor_66),),
                //维修单位代码
                MBCode(widget.fromPage,valueChanged: (val){
                  _dropValueForMBCode=val;
                },defaultValue: _dropValueForMBCode,times:detailVM.detailModel?.zztimes,),
                //保留故障编号
                DDComponent.tagImageAndTextFieldWithNa('dd_number1', _numberFocusNode,_numberController,_textFieldNodes,imgStr: 'assets/images/gz.png'),
                //工作指令号
                DDComponent.tagImageAndTextFieldWithNa('dd_WorkNO',  _workNoNode,_workNoController,_textFieldNodes,imgStr: 'assets/images/zl.png'),
                //转录自何文件
                DDComponent.tagImageAndTextField('dd_from',_fromNode,_fromController,_textFieldNodes,imgStr: 'assets/images/no.png'),
              ],
            )),
        DDCardDecoration(
            title: 'plane_info',
            childWidget: Column(
              children: <Widget>[
                //飞机号
                Offstage(
                  ////临保转DD|DD转办|延期
                  offstage:!(widget.fromPage==comeFromPage.fromDDTransfer||widget.fromPage==comeFromPage.fromTemporaryTransfer||widget.fromPage==comeFromPage.fromDDDelay),
                  child:DDComponent.tagAndTextHorizon('dd_planeNo',  detailVM.detailModel?.zzmsgrp,width:330,notBoldTitle:true,color: KColor.textColor_66),
                ),
                Offstage(
                  offstage:!(widget.fromPage==comeFromPage.fromNewAdd),
                  child:DDComponent.tagImageAndTextField('dd_planeNo', _planeNoFocusNode,_planeNoController,_textFieldNodes,imgStr: 'assets/images/ss2.png'),
                ),
                //发动机/APU序号
                DDComponent.tagImageAndTextFieldWithNa('dd_ENG',_engNode,_engController,_textFieldNodes,imgStr: 'assets/images/fdj.png'),
              ],
            )),
        DDCardDecoration(
        title: 'first_report_info',
        childWidget: Column(
          children: <Widget>[
            //首次报告日期
            (widget.fromPage==comeFromPage.fromDDDelay)?DDComponent.tagAndTextHorizon('dd_firstReportDate',detailVM.detailModel.zzbgdt,width:330,notBoldTitle: true,color: KColor.textColor_66):
            TextAndTextFieldWithCalender('dd_firstReportDate',this._textFieldNodes, this._reportDateFocusNode, this._reportDateController,(val){
              _reportDateController.text=val;
            },firstReportTime:true, ),
            //首次报告地点(如果是转办或延期，代第一份DD的首办日期，不可编辑)
            (widget.fromPage==comeFromPage.fromDDDelay||widget.fromPage==comeFromPage.fromDDTransfer)?DDComponent.tagAndTextHorizon('dd_firstReportPlace','成都基地' ,width:330,notBoldTitle: true,color: KColor.textColor_66):DDComponent.tagImageAndTextField('dd_firstReportPlace', _reportPlaceFocusNode,_reportPlaceController,_textFieldNodes,imgStr: 'assets/images/dd.png'),

          ],
        )),
        DDCardDecoration(
        title: 'plan_info',
         childWidget: Column(
         children: <Widget>[
           //起始日期/飞机总飞行小时/循环
           DDStart((val){
             _startDateController.text=val;
           }, _textFieldNodes, _startDateNode, _totalHourNode, _totalCycleNode, _startDateController, _totalHourController, _totalCycleController,fromTempDD: false,),
           //计划保留天数/小时/循环
           DDSpace(
             textFieldNodes: _textFieldNodes,
             dayNode: _dayNode,
             hourNode: _hourNode,
             cycleNode: _cycleNode,
             dayController: _dayController,
             hourController: _hourController,
             cycleController: _cycleController,
             fromTempDD: false,
           ),
           DDEnd((val){
             _endDateController.text=val;
           }, _textFieldNodes, _endDateNode, _endHourNode, _endCycleNode, _endDateController, _endHourController, _endCycleController,fromTempDD: false,),
           //计划保留间隔描述
           DescribeTextField(tagName:'dd_plan_keep_describe',node:_describeNode ,controller: _describeController,textFieldNodes: this._textFieldNodes,),

           //保留报告及临时措施
           DescribeTextField(tagName:'dd_keepMeasure',node:_keepMeasureNode ,controller: _keepMeasureController,textFieldNodes: this._textFieldNodes,),


         ],
         )),
        DDCardDecoration(
                title: 'Maintenance_info',
                childWidget: Column(
                  children: <Widget>[
                    //名称
                    DDComponent.tagAndTextFieldWithNa('dd_name', 220, _nameNode,_nameController,_textFieldNodes),
                    //件号
                    DDComponent.tagAndTextFieldWithNa('dd_jno', 220, _jnoNode,_jnoController,_textFieldNodes),
                    //数量
                    Num(textFieldNodes: _textFieldNodes,faultNumNode: _faultNumNode,releaseNumNode: _releaseNumNode,installNumNode: _installNumNode,
                      faultNumController: _faultNumController,releaseNumController: _releaseNumController,installNumController: _installNumController,
                    ),
                    //章节
                    Chapter(textFieldNodes: _textFieldNodes,chapter1Node: _chapter1Node,chapter2Node: _chapter2Node,chapter3Node: _chapter3Node,
                      chapter1Controller: _chapter1Controller,chapter2Controller: _chapter2Controller,chapter3Controller: _chapter3Controller,
                    ),

                    //保留故障分类
                    FaultCategoryDrop(valueChanged: (val){
                      _dropValueForFaultCategory=val;
                    },defaultValue: _dropValueForFaultCategory,),
                    //影响服务程度
                    InfluenceDrop(valueChanged: (val){
                      _dropValueForInfluence=val;
                    },defaultValue: _dropValueForInfluence,),

                    //所需停场时间
                    DDComponent.tagAndTextFieldVertical('dd_need_parking_time',_needParkingTimeNode,_needParkingTimeController,_textFieldNodes),
                    //所需工时
                    DDComponent.tagAndTextFieldVertical('dd_need_work_time',_needWorkHourNode,_needWorkHourController,_textFieldNodes),

                  ],
                )),
        DDCardDecoration(
            title: 'operation_limitation',
            childWidget: Column(
              children: <Widget>[
                //使用限制
                UseLimit(
                  valueChangedForO: (val){_checkValueOOption=val;},
                  valueChangedForOther: (val){_checkValueOtherOption=val;},
                  checkValueOOption: _checkValueOOption,
                  checkValueOtherOption: _checkValueOtherOption,
                  otherNode: _otherNode,
                  otherController: _otherController,
                  textFieldNodes: this._textFieldNodes,),
              ],
            )),
        DDCardDecoration(
            title: 'other_limitation',
            childWidget: Column(
              children: <Widget>[
            //标识（是否复选框）
                Need(
                  valueChangedForM:(val){_checkValueMOption=val;} ,
                  valueChangedForAMC: (val){_checkValueAMCOption=val;} ,
                  valueChangedForRun: (val){_checkValueRunOption=val;} ,
                  valueChangedForKeepFold: (val){_checkValueKeepFoldOption=val;} ,
                  valueChangedForRepeatInspection:(val){_checkValueRepeatInspectionOption=val;} ,
                  checkValueAMCOption: _checkValueAMCOption,
                  checkValueKeepFoldOption: _checkValueKeepFoldOption,
                  checkValueMOption: _checkValueMOption,
                  checkValueRunOption: _checkValueRunOption,
                  checkValueRepeatInspectionOption: _checkValueRepeatInspectionOption,
                ),
              ],
            )),
        DDCardDecoration(
            title: 'reason_code',
            childWidget: Column(
              children: <Widget>[
                //保留原因代码
                KeepReason(
                  valueChangedForOI: (val){_checkValueOIOption=val;},
                  valueChangedForLS: (val){_checkValueLSOption=val;},
                  valueChangedForSG: (val){_checkValueSGOption=val;},
                  valueChangedForSP: (val){_checkValueSPOption=val;},
                  checkValueOIOption: _checkValueOIOption,
                  checkValueLSOption: _checkValueLSOption,
                  checkValueSGOption: _checkValueSGOption,
                  checkValueSPOption: _checkValueSPOption,
                ),
              ],
            )),
        DDCardDecoration(
            title: 'evidence_type',
            childWidget: Column(
              children: <Widget>[
//依据类型
                EvidenceDrop(defaultValue:_dropValueForEvidence,valueChanged: (val){
                  _dropValueForEvidence=val;
                },),
                //章节号1
                DDComponent.tagAndTextFieldVertical('dd_chapter_no1',_chapterNo1Node, _chapterNo1Controller,_textFieldNodes),
                //章节号2
                DDComponent.tagAndTextFieldVertical('dd_chapter_no2',_chapterNo2Node, _chapterNo2Controller,_textFieldNodes),
                //章节号3
                DDComponent.tagAndTextFieldVertical('dd_chapter_no3', _chapterNo3Node, _chapterNo3Controller,_textFieldNodes),
                //章节号4
                DDComponent.tagAndTextFieldVertical('dd_chapter_no4', _chapterNo4Node, _chapterNo4Controller,_textFieldNodes),
                //章节号5
                DDComponent.tagAndTextFieldVertical('dd_chapter_no5', _chapterNo5Node, _chapterNo5Controller,_textFieldNodes),

              ],
            )),
        DDCardDecoration(
            title: 'operation_info',
            childWidget: Column(
              children: <Widget>[
                //新增——申请日期、申请人，转办-转办日期、操作人，延期-延期日期、操作人
                TextAndTextFieldWithCalender(_titleForDateSelect,this._textFieldNodes, this._applyDateNode, this._applyDateController,(val){
                  _applyDateController.text=val;
                } ),
                //申请人
                DDComponent.tagAndButtonHorizon(_titleForSignPerson, 'temporary_dd_signButton',width: 260),
              ],
            )),
        SizedBox(height: 20,),
        Container(
          alignment: Alignment.centerRight,
          child: OperationButton.createButton(_sureButtonTitle,
              ()async{
                FocusScope.of(context).requestFocus(FocusNode());
                //校验
//                _checkInput();
//                NormalDDTools().deleteNormalDD('2222', widget.fromPage.toString());
                if (_loadingDialog == null) {
                  _loadingDialog = LoadingDialogUtil.createProgressDialog(context);
                }
                await _loadingDialog.show();
                if(widget.fromPage==comeFromPage.fromTemporaryTransfer){
                  //临保转dd
                 bool transferSuccess= await transferDDVM.transferDD(detailVM.detailModel.ddid,
                    mbCode: _dropValueForMBCode,
                    number:_numberController.text,
                    workON: _workNoController.text,
                    comeFrom: _fromController.text,
                    planeNo: _planeNoController.text,
                    eng: _engController.text,
                    reportDate: _reportDateController.text,
                    reportPlace: _reportPlaceController.text,
                    startDate: _startDateController.text,
                    totalHour: _totalHourController.text,
                    totalCycle: _totalCycleController.text,
//                    spaceDay:int.parse(_dayController.text),
                    spaceHour:_hourController.text,
                    spaceCycle: _cycleController.text,
                    endDate: _endDateController.text,
                    endHour: _endHourController.text,
                    endCycle: _endCycleController.text,
                    describe: _describeController.text,
                    keepMeasure:_keepMeasureController.text,
                    name: _nameController.text,
                    jno: _jnoController.text,
                    faultNum: _faultNumController.text,
                    releaseNum: _releaseNumController.text,
                    inStallNum: _installNumController.text,
                    chapter1: _chapter1Controller.text,
                    chapter2: _chapter2Controller.text,
                    chapter3: _chapter3Controller.text,
                    faultCategory: _dropValueForFaultCategory,
                    influence:_dropValueForInfluence,
                    parkingTime: _needParkingTimeController.text,
                    workHour:_needWorkHourController.text ,
                    o:_checkValueOOption?'1':'0',
                    other: _checkValueOtherOption?'1':'0',
                    otherDescribe: _otherController.text,
                    keepFold: _checkValueKeepFoldOption?'1':'0',
                    repeatInspection: _checkValueRepeatInspectionOption?'1':'0',
                    m: _checkValueMOption?'1':'0',
                    aMC: _checkValueAMCOption?'1':'0',
                    runLimit: _checkValueRunOption?'1':'0',
                    keepReason:keepReason(),
                    evidenceType:_dropValueForEvidence,
                    chapterNo1: _chapterNo1Controller.text,
                    chapterNo2: _chapterNo2Controller.text,
                    chapterNo3: _chapterNo3Controller.text,
                    chapterNo4: _chapterNo4Controller.text,
                    chapterNo5: _chapterNo5Controller.text,
                    applyDate: _applyDateController.text,
                    applicant: Provider.of<UserViewModel>(context, listen: false).info.username,);
                 //访问接口拿取流水号，填写处理结果
                 if(transferSuccess){

                   ddDialog(context,title:'流水号:${transferDDVM.serialNumber}',buttonText: Translations.of(context).text('confirm'),tagName: 'dd_dealResult',node: _dealResultNode,controller: _dealResultController,onTap:()async{
                     //提交处理结果
                    bool success=await dealResultVM.result(detailVM.detailModel.ddid,_dealResultController.text);
                    if(success){
                    _loadingDialog.hide().whenComplete((){
                      for(int i=0; i<2; i++){
                        Navigator.pop(context);
                      }
                    });
                    }
                    else{
                      _loadingDialog.hide();
                    }
                     //已转未审批，临保界面显示处理结果，并禁用按钮
                   });
                 }else{
                   _loadingDialog.hide();
                 }
                }
                else if(widget.fromPage==comeFromPage.fromDDTransfer){
               //访问接口拿取流水号，填写处理结果
                  bool transferSuccess= await transferVM.transfer(detailVM.detailModel.ddid,
                    mbCode: _dropValueForMBCode,
                    number:_numberController.text,
                    workON: _workNoController.text,
                    comeFrom: _fromController.text,
                    planeNo: _planeNoController.text,
                    eng: _engController.text,
                    reportDate: _reportDateController.text,
                    reportPlace: _reportPlaceController.text,
                    startDate: _startDateController.text,
                    totalHour: _totalHourController.text,
                    totalCycle: _totalCycleController.text,
//                    spaceDay:int.parse(_dayController.text),
                    spaceHour:_hourController.text,
                    spaceCycle: _cycleController.text,
                    endDate: _endDateController.text,
                    endHour: _endHourController.text,
                    endCycle: _endCycleController.text,
                    describe: _describeController.text,
                    keepMeasure:_keepMeasureController.text,
                    name: _nameController.text,
                    jno: _jnoController.text,
                    faultNum: _faultNumController.text,
                    releaseNum: _releaseNumController.text,
                    inStallNum: _installNumController.text,
                    chapter1: _chapter1Controller.text,
                    chapter2: _chapter2Controller.text,
                    chapter3: _chapter3Controller.text,
                    faultCategory: _dropValueForFaultCategory,
                    influence:_dropValueForInfluence,
                    parkingTime: _needParkingTimeController.text,
                    workHour:_needWorkHourController.text ,
                    o:_checkValueOOption?'1':'0',
                    other: _checkValueOtherOption?'1':'0',
                    otherDescribe: _otherController.text,
                    keepFold: _checkValueKeepFoldOption?'1':'0',
                    repeatInspection: _checkValueRepeatInspectionOption?'1':'0',
                    m: _checkValueMOption?'1':'0',
                    aMC: _checkValueAMCOption?'1':'0',
                    runLimit: _checkValueRunOption?'1':'0',
                    keepReason:keepReason(),
                    evidenceType:_dropValueForEvidence,
                    chapterNo1: _chapterNo1Controller.text,
                    chapterNo2: _chapterNo2Controller.text,
                    chapterNo3: _chapterNo3Controller.text,
                    chapterNo4: _chapterNo4Controller.text,
                    chapterNo5: _chapterNo5Controller.text,
                    applyDate: _applyDateController.text,
                    applicant: Provider.of<UserViewModel>(context, listen: false).info.username,);
                  //访问接口拿取流水号，填写处理结果
                  if(transferSuccess){
                    ddDialog(context,title: '流水号:${transferVM.serialNumber}',buttonText: Translations.of(context).text('confirm'),tagName: 'dd_dealResult',node: _dealResultNode,controller: _dealResultController,onTap:()async{
                      //提交处理结果
                      bool success=await dealResultVM.result(detailVM.detailModel.ddid,_dealResultController.text);
                      if(success){
//                      Navigator.pop(context,'1');

//                      Navigator.popUntil(context, ModalRoute.withName(Routes.dDListPage));
                        _loadingDialog.hide().whenComplete((){
                          for(int i=0; i<2; i++){
                            Navigator.pop(context);
                          }
                        });

                      }
                      else{
                        _loadingDialog.hide();
                      }
                      //已转未审批，临保界面显示处理结果，并禁用按钮
                    });
                  }else{
                    _loadingDialog.hide();
                  }
                }
                else if(widget.fromPage==comeFromPage.fromDDDelay){
                  bool success= await delayVM.delay(detailVM.detailModel.ddid,
                    mbCode: _dropValueForMBCode,
                    number:_numberController.text,
                    workON: _workNoController.text,
                    comeFrom: _fromController.text,
                    planeNo: _planeNoController.text,
                    eng: _engController.text,
                    reportDate: _reportDateController.text,
                    reportPlace: _reportPlaceController.text,
                    startDate: _startDateController.text,
                    totalHour: _totalHourController.text,
                    totalCycle: _totalCycleController.text,
//                    spaceDay:int.parse(_dayController.text),
                    spaceHour:_hourController.text,
                    spaceCycle: _cycleController.text,
                    endDate: _endDateController.text,
                    endHour: _endHourController.text,
                    endCycle: _endCycleController.text,
                    describe: _describeController.text,
                    keepMeasure:_keepMeasureController.text,
                    name: _nameController.text,
                    jno: _jnoController.text,
                    faultNum: _faultNumController.text,
                    releaseNum: _releaseNumController.text,
                    inStallNum: _installNumController.text,
                    chapter1: _chapter1Controller.text,
                    chapter2: _chapter2Controller.text,
                    chapter3: _chapter3Controller.text,
                    faultCategory: _dropValueForFaultCategory,
                    influence:_dropValueForInfluence,
                    parkingTime: _needParkingTimeController.text,
                    workHour:_needWorkHourController.text ,
                    o:_checkValueOOption?'1':'0',
                    other: _checkValueOtherOption?'1':'0',
                    otherDescribe: _otherController.text,
                    keepFold: _checkValueKeepFoldOption?'1':'0',
                    repeatInspection: _checkValueRepeatInspectionOption?'1':'0',
                    m: _checkValueMOption?'1':'0',
                    aMC: _checkValueAMCOption?'1':'0',
                    runLimit: _checkValueRunOption?'1':'0',
                    keepReason:keepReason(),
                    evidenceType:_dropValueForEvidence,
                    chapterNo1: _chapterNo1Controller.text,
                    chapterNo2: _chapterNo2Controller.text,
                    chapterNo3: _chapterNo3Controller.text,
                    chapterNo4: _chapterNo4Controller.text,
                    chapterNo5: _chapterNo5Controller.text,
                    applyDate: _applyDateController.text,
                    applicant: Provider.of<UserViewModel>(context, listen: false).info.username,);
                  //访问接口拿取流水号，填写处理结果
                  if(success){
                    ddDialog(context,title:'流水号:${delayVM.serialNumber}',buttonText: Translations.of(context).text('confirm'),tagName: 'dd_dealResult',node: _dealResultNode,controller: _dealResultController,onTap:()async{
                      //提交处理结果
                      bool success=await dealResultVM.result(detailVM.detailModel.ddid,_dealResultController.text);
                      if(success){
//                      Navigator.pop(context,'1');

//                      Navigator.popUntil(context, ModalRoute.withName(Routes.dDListPage));
                        _loadingDialog.hide().whenComplete((){
                          for(int i=0; i<2; i++){
                            Navigator.pop(context);
                          }
                        });

                      }
                      else{
                        _loadingDialog.hide();
                      }
                      //已转未审批，临保界面显示处理结果，并禁用按钮
                    });
                  }else{
                    _loadingDialog.hide();
                  }

                }
                else if(widget.fromPage==comeFromPage.fromNewAdd){
                  //新增提交数据到后台；

                  bool success= await  addModel.addDD('DD',
                      mbCode: _dropValueForMBCode,
                      number:_numberController.text,
                      workON: _workNoController.text,
                      comeFrom: _fromController.text,
                      planeNo: _planeNoController.text,
                      eng: _engController.text,
                      reportDate: _reportDateController.text,
                      reportPlace: _reportPlaceController.text,
                      startDate: _startDateController.text,
                      totalHour: _totalHourController.text,
                      totalCycle: _totalCycleController.text,
//                      spaceDay:int.parse(_dayController.text),
                      spaceHour:_hourController.text,
                      spaceCycle: _cycleController.text,
                      endDate: _endDateController.text,
                      endHour: _endHourController.text,
                      endCycle: _endCycleController.text,
                      describe: _describeController.text,
                      keepMeasure:_keepMeasureController.text,
                      name: _nameController.text,
                      jno: _jnoController.text,
                      faultNum: _faultNumController.text,
                      releaseNum: _releaseNumController.text,
                      inStallNum: _installNumController.text,
                      chapter1: _chapter1Controller.text,
                      chapter2: _chapter2Controller.text,
                      chapter3: _chapter3Controller.text,
                      faultCategory: _dropValueForFaultCategory,
                      influence:_dropValueForInfluence,
                      parkingTime: _needParkingTimeController.text,
                      workHour:_needWorkHourController.text ,
                      o:_checkValueOOption?'1':'0',
                      other: _checkValueOtherOption?'1':'0',
                      otherDescribe: _otherController.text,
                      keepFold: _checkValueKeepFoldOption?'1':'0',
                      repeatInspection: _checkValueRepeatInspectionOption?'1':'0',
                      m: _checkValueMOption?'1':'0',
                      aMC: _checkValueAMCOption?'1':'0',
                      runLimit: _checkValueRunOption?'1':'0',
                      keepReason:keepReason(),
                      evidenceType:_dropValueForEvidence,
                      chapterNo1: _chapterNo1Controller.text,
                      chapterNo2: _chapterNo2Controller.text,
                      chapterNo3: _chapterNo3Controller.text,
                      chapterNo4: _chapterNo4Controller.text,
                      chapterNo5: _chapterNo5Controller.text,
                      applyDate: _applyDateController.text,
                      applicant: Provider.of<UserViewModel>(context, listen: false).info.username,
                  );
                  if(success){
                    _loadingDialog.hide().whenComplete((){
                        Navigator.pop(context);
                    });

                  }else{
                    _loadingDialog.hide();
                  }
                }else if(widget.fromPage==comeFromPage.fromTaskListAdd){
                }
              }, size: Size(double.infinity,120),),
        )
      ],
    );
  }
  String keepReason(){
    String reason='';
    if(_checkValueOIOption)reason+='OI';
    if(_checkValueLSOption)reason+='LS';
    if(_checkValueSGOption)reason+='SG';
    if(_checkValueSPOption)reason+='SP';
    return reason;
  }
  void _checkInput(){
//为空校验
    if((_dropValueForMBCode.length<=0)||_numberController.text.length<=0||_workNoController.text.length<=0||_planeNoController.text.length<=0
        ||_engController.text.length<=0 ||_fromController.text.length<=0||_reportDateController.text.length<=0||_reportPlaceController.text.length<=0
        ||(_startDateController.text.length<=0&&_totalHourController.text.length<=0&&_totalCycleController.text.length<=0)
        ||(_dayController.text.length<=0&&_hourController.text.length<=0&&_cycleController.text.length<=0)
        ||(_endDateController.text.length<=0&&_endHourController.text.length<=0&&_endCycleController.text.length<=0)||
        _describeController.text.length<=0||_keepMeasureController.text.length<=0||_nameController.text.length<=0||
        _jnoController.text.length<=0||_faultNumController.text.length<=0||_releaseNumController.text.length<=0||_installNumController.text.length<=0||
        _chapter1Controller.text.length<=0||_chapter2Controller.text.length<=0||_chapter3Controller.text.length<=0||
        (_dropValueForFaultCategory.length<=0)||(_dropValueForInfluence.length<=0)
        ||(_checkValueOOption==false&&_checkValueOtherOption==false)||(_checkValueOtherOption==true&&_otherController.text.length<=0)
        ||(_checkValueOIOption==false&&_checkValueLSOption==false&&_checkValueSGOption==false&&_checkValueSPOption==false)||_needParkingTimeController.text.length<=0
        ||_needWorkHourController.text.length<=0||(_dropValueForEvidence.length<=0)||_applyDateController.text.length<=0
    )
    {
      ToastUtil.makeToast(Translations.of(context).text('dd_null'));
    }
    //少于1000字
    if(_keepMeasureController.text.length<1000){

      ToastUtil.makeToast(Translations.of(context).text('dd_keepMeasure_error'));
      return;
    }
    //名称sap长度限制
    if(_nameController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_name_error'));
      return;
    }
    if(_jnoController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_jno_error'));
      return;
    }
    //使用限制如果选择了其它，判断复选框长度；
    if(_checkValueRunOption){
      if(_otherController.text.length<=0){
        ToastUtil.makeToast(Translations.of(context).text('dd_other_error'));
        return;
      }
    }
    //计划保留间隔描述
    if(_describeController.text.length<=100){
      ToastUtil.makeToast(Translations.of(context).text('dd_plan_keep_describe_error'));
      return;
    }
    //如保留故障分类选择了A/B/C/D中的一个，则计划保留小时/循环/天数中至少要输入一个
    if((_dropValueForFaultCategory=='A'||_dropValueForFaultCategory=='B'||_dropValueForFaultCategory=='C'||_dropValueForFaultCategory=='D')&&
        _dayController.text.length<=0&&_hourController.text.length<=0&&_hourController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_day_hour_cycle_null'));
      return;
    }
    if((_dropValueForEvidence=="MEL"||_dropValueForEvidence=="CDL")&&_chapterNo1Controller.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_chapterNo1_null'));
      return;
    }
  }
  void dataForNewAdd(){
   //新增：获取系统当前日期
    DateTime date=new DateTime.now();
    Provider.of<DDCalculateProvide>(context,listen: false).setFirstReportTime(DateUtil.formateYMD(date));
    //有首次报告日期自动计算起始日期+1天；
    Future.delayed(Duration(seconds: 1), (){
      Provider.of<DDCalculateProvide>(context,listen: false).calculateStartAndFirstDate(addOneDay: true);
      print('延时1s执行');
    });

  }
  void dataForTemporaryTransfer(){
   //临保转DD
    _planeNoController.text=detailVM.detailModel?.zzmsgrp;//'B-1234';
    _describeController.text=detailVM.detailModel?.zzgzms;//'三角函数公式,三角函数是一个重要的知识点,尤其在生活应用中具有举足轻重的作用!三角函数包括ico,ta,cot,以及arcta,arcco,等等。他们之间是如何换算的';
  }
  void dataForDDTransfer(){
   //DD转办
    _planeNoController.text='B-1234';
    _fromController.text=detailVM.detailModel?.zzblno;
  }
  void dataForDDDelay(){
    //DD延期
   //影响程度
    String tempStr;
    if(detailVM.detailModel.zzyxfwcd=='严重'){
      tempStr="0";
    }else if(detailVM.detailModel.zzyxfwcd=='一般'){
      tempStr="1";
    }else if(detailVM.detailModel.zzyxfwcd=='不影响'){
      tempStr="2";
    }
    //依据类型
    String tempStr2;
   if(detailVM.detailModel.zzrectype=='MEL'){
     tempStr2='0';
   }else if(detailVM.detailModel.zzrectype=='CDL'){
     tempStr2='1';
   }else if(detailVM.detailModel.zzrectype=='其它'){
     tempStr2='2';
   }
//   查看本地是否有数据，有不再存储，没有先本地缓存
    DDCacheUtil.cacheData('dd_influence',tempStr);
    DDCacheUtil.cacheData('dd_evidence_type',tempStr2);
    DDCacheUtil.cacheData('dd_keep_faultCategory',detailVM.detailModel.zzblclf);
    if(detailVM.detailModel.zzrescode.contains('OI')){
      DDCacheUtil.cacheData('dd_oi','1');
      _checkValueOIOption=true;
    }else if(detailVM.detailModel.zzrescode.contains('LS')){
      DDCacheUtil.cacheData('dd_ls','1');
      _checkValueLSOption=true;
    }else if(detailVM.detailModel.zzrescode.contains('SG')){
      DDCacheUtil.cacheData('dd_sg','1');
      _checkValueSGOption=true;
    }else if(detailVM.detailModel.zzrescode.contains('SP')){
      DDCacheUtil.cacheData('dd_sp','1');
      _checkValueSPOption=true;
    }
//    if(normalDDDbModel.ddInfluence==null){
//      DDCacheUtil.cacheData('dd_influence',tempStr);
//    }
//    if(normalDDDbModel.ddEvidence==null){
//      DDCacheUtil.cacheData('dd_evidence_type',tempStr2);
//    }
//    if(normalDDDbModel.ddFaultCategory==null){
//      DDCacheUtil.cacheData('dd_keep_faultCategory',detailVM.detailModel.zzblclf);
//    }
//    if(detailVM.detailModel.zzrescode.contains('OI')){
//      if(normalDDDbModel.ddOI==null){
//        DDCacheUtil.cacheData('dd_oi','1');
//      }
//
//      _checkValueOIOption=true;
//    }else if(detailVM.detailModel.zzrescode.contains('LS')){
//      if(normalDDDbModel.ddLS==null){
//        DDCacheUtil.cacheData('dd_ls','1');
//      }
//      _checkValueLSOption=true;
//    }else if(detailVM.detailModel.zzrescode.contains('SG')){
//      if(normalDDDbModel.ddSG==null){
//        DDCacheUtil.cacheData('dd_sg','1');
//      }
//      _checkValueSGOption=true;
//    }else if(detailVM.detailModel.zzrescode.contains('SP')){
//      if(normalDDDbModel.ddSP==null){
//        DDCacheUtil.cacheData('dd_sp','1');
//      }
//      _checkValueSPOption=true;
//    }
    //     _dropValueForEvidence=tempStr2;//'DEL';
//    _dropValueForFaultCategory=detailVM.detailModel.zzblclf;
//    _dropValueForInfluence="1";//tempStr;
    _planeNoController.text=detailVM.detailModel.zzmsgrp;
    _workNoController.text=detailVM.detailModel.zzwo;//
    _needParkingTimeController.text=detailVM.detailModel.zzytsj;//'2h';
    _needWorkHourController.text=detailVM.detailModel.zzsxgs;//'2h';
    _keepMeasureController.text=detailVM.detailModel.ddreport;//'三角函数公式,三角函数是一个重要的知识点,尤其在生活应用中具有举足轻重的作用!三角函数包括ic';
    _fromController.text=detailVM.detailModel.zzzzhwj;//'转录自DD转办';
    _chapter1Controller.text=detailVM.detailModel.zzatazj;//'22';
    _chapter2Controller.text=detailVM.detailModel.zzatazj2;//'22';
    _chapter3Controller.text=detailVM.detailModel.zztatzj3;//'234';
    _faultNumController.text=detailVM.detailModel.falqty;//'2';
    _releaseNumController.text=detailVM.detailModel.relqty;//'2';
    _installNumController.text=detailVM.detailModel.instqty;//'3';
    fetchNormalDDModel();

  }
  setUIFor() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uiFor","DD");
    prefs.setString("fromPage",widget.fromPage.toString());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUIFor();//告诉缓存是临保还是DD
    detailVM=Provider.of<DDDetailViewModel>(context,listen: false);
    transferDDVM=new TransferDDViewModel();//临保转DD
    transferVM=new TransferViewModel();//DD转办
    delayVM=new DelayDDViewModel();//DD延期
    addModel= new AddDDViewModel();//新增DD
    dealResultVM=new DealResultViewModel();//处理结果，用于临保转办延期
    //查看是否有缓存数据
    fetchNormalDDModel();
    if(widget.fromPage==comeFromPage.fromTemporaryTransfer){
      //临保转办
      dataForTemporaryTransfer();
      //获取临保的详细信息
      _navTitle= 'temporary_dd_transfer_page';
      _sureButtonTitle='dd_ensure_transfer';
      _titleForDateSelect='dd_transfer_date_title';
      _titleForSignPerson='dd_operator';
    }else if(widget.fromPage==comeFromPage.fromDDTransfer){
      //DD转办
      dataForDDTransfer();
      _navTitle= 'dd_transfer_page';
      _sureButtonTitle='dd_ensure_transfer';
      _titleForDateSelect='dd_transfer_date_title';
      _titleForSignPerson='dd_operator';
    }else if(widget.fromPage==comeFromPage.fromDDDelay){
      //延期
      dataForDDDelay();
      _navTitle= 'dd_delay_page';
      _sureButtonTitle='dd_ensure_delay';
      _titleForDateSelect='dd_delay_date_title';
      _titleForSignPerson='dd_operator';
    }else if(widget.fromPage==comeFromPage.fromNewAdd){
      //新增
      dataForNewAdd();
      _navTitle= 'dd_add_page';
      _sureButtonTitle='dd_add';
      _titleForDateSelect='dd_applicationDate';
      _titleForSignPerson='dd_applicant';
    }else if(widget.fromPage==comeFromPage.fromTaskListAdd){
      //任务新增
      _navTitle= 'dd_add_page';
      _sureButtonTitle='dd_add';
      _titleForDateSelect='dd_applicationDate';
      _titleForSignPerson='dd_applicant';
    }

    _textFieldNodes=[_numberFocusNode,_workNoNode,_fromNode,_planeNoFocusNode,_engNode,_reportDateFocusNode,_reportPlaceFocusNode,
      _startDateNode,_dayNode,_endDateNode,_totalHourNode,_hourNode,_endHourNode,_totalCycleNode,_cycleNode,_endCycleNode,_describeNode,
      _keepMeasureNode,_nameNode,_jnoNode,_faultNumNode,_releaseNumNode,_installNumNode,_chapter1Node,_chapter2Node,_chapter3Node,null,
      _needParkingTimeNode,_needWorkHourNode,
      null,_otherNode,null,_chapterNo1Node,_chapterNo2Node,_chapterNo3Node,_chapterNo4Node,_chapterNo5Node,_applyDateNode,null
    ];

    _controllers=[_numberController,_workNoController,_fromController,_planeNoController,_engController,_reportDateController,_reportPlaceController,
      _startDateController,_dayController,_endDateController,_totalHourController,_hourController,_endHourController,_totalCycleController,_cycleController,_endCycleController,_describeController,
      _keepMeasureController,_nameController,_jnoController,_faultNumController,_releaseNumController,_installNumController,_chapter1Controller,_chapter2Controller,_chapter3Controller,null,
      _needParkingTimeController,_needWorkHourController,
      null,_otherController,null,_chapterNo1Controller,_chapterNo2Controller,_chapterNo3Controller,_chapterNo4Controller,_chapterNo5Controller,_applyDateController,null
    ];

    _textFieldTagNames=['dd_number1','dd_WorkNo','dd_from','dd_planeNo','dd_ENG','dd_firstReportDate','dd_firstReportPlace',
      'dd_startDate','dd_plan_keep_time1','dd_end_time1','dd_start_time2','dd_plan_keep_time2','dd_end_time2','dd_start_time3','dd_plan_keep_time3','dd_end_time3','dd_plan_keep_describe',
      'dd_keepMeasure','dd_name','dd_jno','dd_faultNum','dd_releaseNum','dd_installNum','dd_chapter1','dd_chapter2','dd_chapter3',null,
      'dd_need_parking_time','dd_need_work_time',
      null,'dd_other_describe',null,'dd_chapter_no1','dd_chapter_no2','dd_chapter_no3','dd_chapter_no4','dd_chapter_no5',_titleForDateSelect,null
    ];
    addListener();

}
  void addListener(){
   this._textFieldNodes.forEach((node){

     FocusNode tempNode=node;
     if(tempNode!=null){
       tempNode.addListener(_focusNodeListener);
     }
   });
  }
  // 监听焦点
  Future<Null> _focusNodeListener() async {

    for(int i=0;i<_textFieldNodes.length;i++) {

      FocusNode tempNode = _textFieldNodes[i];

      if (tempNode!=null&&tempNode.hasFocus) {

        if (lastNode != null) {
          // 保存上一个node的数据
          TextEditingController tempController = _controllers[lastIndex];
          String tempTagName=this._textFieldTagNames[lastIndex];
          DDCacheUtil.cacheData(tempTagName, tempController.text);
          //处理动态计算时间
          if(lastNode==_startDateNode){
            //起始时间
            Provider.of<DDCalculateProvide>(context,listen: false).setStartTime(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateStartAndFirstDate(addOneDay: false);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'start');
          }
          if(lastNode==_dayNode){
            //计划保留天数
            Provider.of<DDCalculateProvide>(context,listen: false).setSpace(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'space');
          }
          if(lastNode==_endDateNode){
            //保留至日期
            Provider.of<DDCalculateProvide>(context,listen: false).setEndTime(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'end');
          }
          if(lastNode==_totalHourNode){
            //飞机总飞行时间
            Provider.of<DDCalculateProvide>(context,listen: false).setTotalHour(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateHour(trigger: 'start');
          }
          if(lastNode==_hourNode){
            //计划保留小时
            Provider.of<DDCalculateProvide>(context,listen: false).setSpaceHour(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateHour(trigger: 'space');
          }
          if(lastNode==_endHourNode){
            //保留至小时
            Provider.of<DDCalculateProvide>(context,listen: false).setEndHour(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateHour(trigger: 'end');
          }
          if(lastNode==_totalCycleNode){
            //飞机总飞行循环
            Provider.of<DDCalculateProvide>(context,listen: false).setTotalCycle(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateCycle(trigger: 'start');
          }
          if(lastNode==_cycleNode){
            //计划保留循环
            Provider.of<DDCalculateProvide>(context,listen: false).setSpaceCycle(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateCycle(trigger: 'space');
          }
          if(lastNode==_endCycleNode){
            //保留至循环
            Provider.of<DDCalculateProvide>(context,listen: false).setEndCycle(tempController.text);
            Provider.of<DDCalculateProvide>(context,listen: false).calculateCycle(trigger: 'end');
          }
          //飞机号处理
          if(lastNode==_planeNoFocusNode){
            String tempStr=tempController.text;
            bool hasB= tempStr.startsWith('B-');
            if(!hasB&&tempController.text.length>0){
              tempController.text='B-${tempController.text}';
            }
          }
        }

        if(lastNode!=tempNode){
          this.lastNode = tempNode;
          this.lastIndex=i;
        }


      }
    }
  }
  //获取本地缓存数据
  Future<void> fetchNormalDDModel() async {
    String userId=Provider.of<UserViewModel>(context, listen: false).info.userId;
    normalDDDbModel = await NormalDDTools().queryNormalDD(userId,widget.fromPage.toString());
    if (normalDDDbModel != null) {
      _dropValueForMBCode=normalDDDbModel.ddMBCode;
      _numberController.text = normalDDDbModel.ddNumber1??"";
      _workNoController.text=normalDDDbModel.ddWorkNo;
      _planeNoController.text = normalDDDbModel.ddPlaneNo;
      _engController.text=normalDDDbModel.ddEng;
      _fromController.text=normalDDDbModel.ddFrom;
      DateTime dateNow=new DateTime.now();
      Provider.of<DDCalculateProvide>(context,listen: false).setFirstReportTime((normalDDDbModel.ddReportDate==''||normalDDDbModel.ddReportDate==null)?DateUtil.formateYMD(dateNow):normalDDDbModel.ddReportDate??'');
      _reportPlaceController.text =normalDDDbModel.ddReportPlace;
      Provider.of<DDCalculateProvide>(context,listen: false).setStartTime(normalDDDbModel.ddStartDate??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setTotalHour(normalDDDbModel.ddStartTime2??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setTotalCycle(normalDDDbModel.ddStartTime3??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setSpace(normalDDDbModel.ddDay??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setSpaceHour(normalDDDbModel.ddHour??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setSpaceCycle(normalDDDbModel.ddCycle??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setEndTime(normalDDDbModel.ddEndTime1??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setEndHour(normalDDDbModel.ddStartTime2??'');
      Provider.of<DDCalculateProvide>(context,listen: false).setEndCycle(normalDDDbModel.ddEndTime3??'');
      _describeController.text =(normalDDDbModel.ddKeepDescribe!=null||normalDDDbModel.ddKeepDescribe!='')?normalDDDbModel.ddKeepDescribe:detailVM.detailModel?.zzgzms;
      _keepMeasureController.text =normalDDDbModel.ddKeepMeasure;
      _nameController.text =normalDDDbModel.ddName;
      _jnoController.text =normalDDDbModel.ddJno;
      _faultNumController.text =normalDDDbModel.ddFaultNum;
      _installNumController.text =normalDDDbModel.ddInstallNum;
      _releaseNumController.text =normalDDDbModel.ddReleaseNum;
      _chapter1Controller.text =normalDDDbModel.ddChapter1;
      _chapter2Controller.text =normalDDDbModel.ddChapter2;
      _chapter3Controller.text =normalDDDbModel.ddChapter3;
      _dropValueForFaultCategory=normalDDDbModel.ddFaultCategory;
      _dropValueForInfluence=normalDDDbModel.ddInfluence;
      _checkValueOOption=normalDDDbModel.ddo==1?true:false;
      _checkValueOtherOption=normalDDDbModel.ddOther==1?true:false;
      _otherController.text =normalDDDbModel.ddOtherDescribe;
      _checkValueOIOption=normalDDDbModel.ddOI==1?true:false;
      _checkValueLSOption=normalDDDbModel.ddLS==1?true:false;
      _checkValueSGOption=normalDDDbModel.ddSG==1?true:false;
      _checkValueSPOption=normalDDDbModel.ddSP==1?true:false;
      _needParkingTimeController.text =normalDDDbModel.ddParkingTime;
      _needWorkHourController.text =normalDDDbModel.ddWorkHour;
      _checkValueMOption=normalDDDbModel.ddNeedM==1?true:false;
      _checkValueRunOption=normalDDDbModel.ddNeedRun==1?true:false;
      _checkValueAMCOption=normalDDDbModel.ddNeedAmc==1?true:false;
      _checkValueKeepFoldOption=normalDDDbModel.ddNeedKeepToFold==1?true:false;
      _checkValueRepeatInspectionOption=normalDDDbModel.ddNeedKeepRepeatInspection==1?true:false;
      //延期不从本地获取的数据
      _dropValueForEvidence=normalDDDbModel.ddEvidence;
      _chapterNo1Controller.text =normalDDDbModel.ddChapterNo1;
      _chapterNo2Controller.text =normalDDDbModel.ddChapterNo2;
      _chapterNo3Controller.text =normalDDDbModel.ddChapterNo3;
      _chapterNo4Controller.text =normalDDDbModel.ddChapterNo4;
      _chapterNo5Controller.text =normalDDDbModel.ddChapterNo5;
      String date;
      if(widget.fromPage==comeFromPage.fromNewAdd||widget.fromPage==comeFromPage.fromTaskListAdd){
        date=normalDDDbModel.ddApplicationDate;
      }else if(widget.fromPage==comeFromPage.fromDDTransfer||widget.fromPage==comeFromPage.fromTemporaryTransfer){
        date=normalDDDbModel.ddTransferDate;
      }else{
        date=normalDDDbModel.ddDelayDate;
      }
      _applyDateController.text=date;
      setState(() {

      });
    }
  }

@override void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    //    清空计算的数据
//    Provider.of<DDCalculateProvide>(context,listen: false).clearData();
  }
@override
void dispose() {
    // TODO: implement dispose
    super.dispose();
    for(int i=0;i<_textFieldNodes.length;i++) {
      FocusNode tempNode = _textFieldNodes[i];
      if (tempNode!=null&&tempNode.hasFocus) {
        tempNode.removeListener(_focusNodeListener);
        TextEditingController tempController = _controllers[i];
        tempController.dispose();
      }
    }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leading: IconButton(
            onPressed: (){
            //失去焦点
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.pop(context);
            },
            icon:Icon(Icons.arrow_back_ios) ),
            title:Text(Translations.of(context).text(_navTitle), style: TextThemeStore.textStyleAppBar,),
        ),
        body:SingleChildScrollView(
          child:InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child:createUI(context) ,
          ),
        )
    );
  }
}

