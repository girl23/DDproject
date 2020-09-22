import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lop/style/font.dart';
import '../dd_textfield_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../operation_button_util.dart';
import '../dd_date_time_picker_util.dart';
import 'package:lop/utils/date_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/translations.dart';
import '../component/dd_component.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_faultcategory_drop.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_influence_drop.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_evidence_drop.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_use_limit_check.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_keep_reason_check.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_space_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_num_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_need_check.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_chapter_tfs.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_calender_tf.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_describe_tf.dart';
import 'package:lop/database/temp_dd_tools.dart';
import 'package:lop/database/temp_dd_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
import 'package:lop/page/dd/dd_card_decoration.dart';
import 'package:lop/page/dd/dd_calculate_date_provide.dart';
import 'package:provider/provider.dart';

class AddTemporaryDD extends StatefulWidget {
  @override
  _AddTemporaryDDState createState() => _AddTemporaryDDState();
}
class _AddTemporaryDDState extends State<AddTemporaryDD> {
  //存储焦点
  //下拉
  String _dropValueForFaultCategory;
  String _dropValueForInfluence;
  String _dropValueForEvidence;
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
  //焦点
  FocusNode _numberFocusNode = new FocusNode();
  FocusNode _planeNoFocusNode = new FocusNode();
  FocusNode _reportDateFocusNode = new FocusNode();
  FocusNode _reportPlaceFocusNode = new FocusNode();
  FocusNode _keepPersonFocusNode = new FocusNode();
  FocusNode _phoneNumberFocusNode = new FocusNode();
  FocusNode _faxFocusNode = new FocusNode();
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

  //控制器
  TextEditingController _numberController = new TextEditingController();
  TextEditingController _planeNoController = new TextEditingController();
  TextEditingController _reportDateController = new TextEditingController();
  TextEditingController _reportPlaceController = new TextEditingController();
  TextEditingController _keepPersonController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _faxController = new TextEditingController();
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
 TextEditingController _planOperatorController = new TextEditingController();
 TextEditingController _chapterNo1Controller = new TextEditingController();
 TextEditingController _chapterNo2Controller = new TextEditingController();
 TextEditingController _chapterNo3Controller = new TextEditingController();
 TextEditingController _chapterNo4Controller = new TextEditingController();
 TextEditingController _chapterNo5Controller = new TextEditingController();
 //时间选择器
 DateTimePicker _ddTimePicker=new DateTimePicker();
 List _textFieldNodes;
  List _controllers;
  List _textFieldTagNames;
  int lastIndex;
  FocusNode lastNode;

  TempDDDbModel tempDDDbModel;

 Widget createUI(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15,),
        DDCardDecoration(title:'base_info',childWidget: Column(
          children: <Widget>[
            //编号
            DDComponent.tagImageAndTextField('dd_number',_numberFocusNode,_numberController,_textFieldNodes,imgStr: 'assets/images/ss1.png'),
            //飞机号
            DDComponent.tagImageAndTextField('dd_planeNo', _planeNoFocusNode,_planeNoController,_textFieldNodes,imgStr: 'assets/images/ss2.png'),
            //保留人员
            DDComponent.tagImageAndTextField('dd_keepPerson',_keepPersonFocusNode,_keepPersonController,_textFieldNodes,imgStr: 'assets/images/yh.png'),
            //联系电话
            DDComponent.tagImageAndTextFieldWithNa('dd_phoneNumber', _phoneNumberFocusNode,_phoneNumberController,_textFieldNodes,imgStr: 'assets/images/dh.png'),
            //传真
            DDComponent.tagImageAndTextFieldWithNa('dd_fax', _faxFocusNode,_faxController,_textFieldNodes,imgStr: 'assets/images/cz.png'),

          ],)),
        DDCardDecoration(title:'report_info',childWidget: Column(children: <Widget>[
          //报告日期
          CalendarTextField(
            tagName:'dd_reportDate',
            width: 220,
            textFieldNodes: this._textFieldNodes,
            node:  _reportDateFocusNode,
            controller: _reportDateController,
            valueChanged: (val){
              _reportDateController.text=DateUtil.formateYMD(val);
            },
          ),
          //报告地点
          DDComponent.tagImageAndTextField('dd_reportPlace', _reportPlaceFocusNode,_reportPlaceController,_textFieldNodes,imgStr: 'assets/images/dd.png'), SizedBox(height: 15,),

        ],)),
        DDCardDecoration(title: 'plan_info',childWidget:
          Column(children: <Widget>[
            //计划保留天数/小时/循环
            DDSpace(
              textFieldNodes: _textFieldNodes,
              dayNode: _dayNode,
              hourNode: _hourNode,
              cycleNode: _cycleNode,
              dayController: _dayController,
              hourController: _hourController,
              cycleController: _cycleController,
              fromTempDD: true,
            ),
            //计划保留间隔描述
            DescribeTextField(tagName:'dd_plan_keep_describe',node:_describeNode ,controller: _describeController,textFieldNodes: this._textFieldNodes,),
            //保留报告及临时措施
            DescribeTextField(tagName:'dd_keepMeasure',node:_keepMeasureNode ,controller: _keepMeasureController,textFieldNodes: this._textFieldNodes,),

          ],),),
        DDCardDecoration(title:'Maintenance_info',childWidget:
           Column(
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

               },defaultValue:_dropValueForFaultCategory,),
               //影响服务程度
               InfluenceDrop(valueChanged: (val){
                 _dropValueForInfluence=val;
               },defaultValue: _dropValueForInfluence,),
               //所需停场时间
               DDComponent.tagAndTextFieldVertical('dd_need_parking_time',_needParkingTimeNode,_needParkingTimeController,_textFieldNodes),
               //所需工时
               DDComponent.tagAndTextFieldVertical('dd_need_work_time',_needWorkHourNode,_needWorkHourController,_textFieldNodes),
               //执管单位DD计划员
               DDComponent.tagAndTextFieldWithNa('dd_plan_operator', 450, _planOperatorNode,_planOperatorController,_textFieldNodes),

             ],
           ),),
        DDCardDecoration(
          title: 'operation_limitation',
          //使用限制
          childWidget:
          UseLimit(
            valueChangedForO: (val){_checkValueOOption=val;},
            valueChangedForOther: (val){_checkValueOtherOption=val;},
            checkValueOOption: _checkValueOOption,
            checkValueOtherOption: _checkValueOtherOption,
            otherNode: _otherNode,
            otherController: _otherController,),

        ),
        DDCardDecoration(
          title: 'other_limitation',
          childWidget:Need(
            //标识（是否复选框）
            valueChangedForM:(val){_checkValueMOption=val;} ,
            valueChangedForAMC: (val){_checkValueAMCOption=val;} ,
            valueChangedForRun: (val){_checkValueRunOption=val;} ,
            checkValueAMCOption: _checkValueAMCOption,
            checkValueMOption: _checkValueMOption,
            checkValueRunOption: _checkValueRunOption,
            fromTempDD: true,
          ),
        ),
        DDCardDecoration(
            title: 'reason_code',
            childWidget: KeepReason(
              //保留原因代码
              valueChangedForOI: (val){_checkValueOIOption=val;},
              valueChangedForLS: (val){_checkValueLSOption=val;},
              valueChangedForSG: (val){_checkValueSGOption=val;},
              valueChangedForSP: (val){_checkValueSPOption=val;},
              checkValueOIOption: _checkValueOIOption,
              checkValueLSOption: _checkValueLSOption,
              checkValueSGOption: _checkValueSGOption,
              checkValueSPOption: _checkValueSPOption,
            ),),
        DDCardDecoration(
          //依据类型
            title: 'evidence_type',
            childWidget: Column(
              children: <Widget>[
                EvidenceDrop(valueChanged: (val){
                  _dropValueForEvidence=val;
                },defaultValue: _dropValueForEvidence,),
                //章节号1
                DDComponent.tagAndTextFieldVertical('dd_chapter_no1', _chapterNo1Node, _chapterNo1Controller,_textFieldNodes),
                //章节号2
                DDComponent.tagAndTextFieldVertical('dd_chapter_no2', _chapterNo2Node, _chapterNo2Controller,_textFieldNodes),
                //章节号3
                DDComponent.tagAndTextFieldVertical('dd_chapter_no3', _chapterNo3Node, _chapterNo3Controller,_textFieldNodes),
                //章节号4
                DDComponent.tagAndTextFieldVertical('dd_chapter_no4', _chapterNo4Node, _chapterNo4Controller,_textFieldNodes),
                //章节号5
                DDComponent.tagAndTextFieldVertical('dd_chapter_no5', _chapterNo5Node, _chapterNo5Controller,_textFieldNodes),
              ],
            )),
        SizedBox(height:5,),
        Container(
          alignment: Alignment.centerRight,
          child: OperationButton.createButton('dd_add',
              ()async{
                FocusScope.of(context).requestFocus(FocusNode());
                //校验
//                _checkInput();
                //清除本地数据库
                bool success= await TempDDTools().deleteTempDD('2222');
                //清除Provider
                Provider.of<DDCalculateProvide>(context,listen: false).clearTempData();
              }, size: Size(double.infinity,120),),
        )
      ],
    );
  }

  void _checkInput(){
//为空校验
    if(_numberController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_number_null'));
      return;
    }
    if(_planeNoController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_planeNo_null'));
      return;
    }
    if(_reportDateController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_reportDate_null'));
      return;
    }
    if(_reportPlaceController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_reportPlace_null'));
      return;
    }
    if(_keepPersonController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_keepPerson_null'));
      return;
    }
    if(_faultNumController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_faultNum_null'));
      return;
    }
    if(_installNumController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_installNum_null'));
      return;
    }
    if(_releaseNumController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_releaseNum_null'));
      return;
    }
    if(_dropValueForFaultCategory.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_faultCategory_null'));
      return;
    }
    if(_dropValueForInfluence.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_influence_null'));
      return;
    }
    if(_checkValueOOption==false&&_checkValueOtherOption==false){
      ToastUtil.makeToast(Translations.of(context).text('dd_useLimit_null'));
      return;
    }
    if((_dropValueForFaultCategory=='A'||_dropValueForFaultCategory=='B'||_dropValueForFaultCategory=='C'||_dropValueForFaultCategory=='D')&&
        _dayController.text.length<=0&&_hourController.text.length<=0&&_hourController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_day_hour_cycle_null'));
      return;
    }
    //错误校验
    if(_keepPersonController.text.length<18){
      ToastUtil.makeToast(Translations.of(context).text('dd_keepPerson_error'));
      return;
    }
    if(_phoneNumberController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_phoneNumber_error'));
      return;
    }
    if(_faxController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_fax_error'));
      return;
    }
    if(_keepMeasureController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_keepMeasure_error'));
      return;
    }
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
    if(_describeController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_plan_keep_describe_error'));
      return;
    }
    if(_describeController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_plan_keep_describe_error'));
      return;
    }
    if(_planOperatorController.text.length<=0){
      ToastUtil.makeToast(Translations.of(context).text('dd_plan_operator_error'));
      return;
    }

  }
  setUIFor() async{
   //用于标记控件属于临保还是属于DD，来调用缓存的方法
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uiFor","Temp");
  }
  @override
  void initState() {
   setUIFor();
    // TODO: implement initState
    super.initState();
    setUIFor();
    //用于控制textField相关约束的
    _textFieldNodes=[_numberFocusNode,_planeNoFocusNode,_keepPersonFocusNode,_phoneNumberFocusNode,_faxFocusNode,_reportDateFocusNode,_reportPlaceFocusNode,
      _dayNode,_hourNode,_cycleNode,_describeNode,_keepMeasureNode,_nameNode,_jnoNode,_faultNumNode,_releaseNumNode,_installNumNode,
      _chapter1Node,_chapter2Node,_chapter3Node,null, _needParkingTimeNode,_needWorkHourNode,
      _planOperatorNode,null,_otherNode,null,_chapterNo1Node,_chapterNo2Node,_chapterNo3Node,_chapterNo4Node,_chapterNo5Node,null];

   _controllers=[_numberController,_planeNoController,_keepPersonController,_phoneNumberController,_faxController,_reportDateController,_reportPlaceController,
     _dayController,_hourController,_cycleController, _describeController,_keepMeasureController,_nameController,_jnoController,_faultNumController,_releaseNumController,_installNumController,
     _chapter1Controller,_chapter2Controller,_chapter3Controller,null, _needParkingTimeController,_needWorkHourController,
     _planOperatorController,null,_otherController,null,_chapterNo1Controller,_chapterNo2Controller,_chapterNo3Controller,_chapterNo4Controller,_chapterNo5Controller,null
   ];

   _textFieldTagNames=['dd_number','dd_planeNo','dd_keepPerson','dd_phoneNumber','dd_fax','dd_reportDate','dd_reportPlace',
     'dd_plan_keep_time1','dd_plan_keep_time2','dd_plan_keep_time3','dd_plan_keep_describe','dd_keepMeasure','dd_name','dd_jno','dd_faultNum','dd_releaseNum','dd_installNum',
     'dd_chapter1','dd_chapter2','dd_chapter3',null, 'dd_need_parking_time','dd_need_work_time',
     'dd_plan_operator',null,'dd_other_describe',null,'dd_chapter_no1','dd_chapter_no2','dd_chapter_no3','dd_chapter_no4','dd_chapter_no5',null
   ];
   addListener();
      DateTime defaultDate = DateTime.now();
    _reportDateController.text=DateUtil.formateYMD(defaultDate);
    //先查表看是否有数据
    fetchTempDDModel();

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
          //更新provider数据
          if(lastNode==_dayNode){
            Provider.of<DDCalculateProvide>(context,listen: false).setDay(_dayController.text);
          }
          if(lastNode==_hourNode){
            Provider.of<DDCalculateProvide>(context,listen: false).setHour(_hourController.text);
          }
          if(lastNode==_cycleNode){
            Provider.of<DDCalculateProvide>(context,listen: false).setCycle(_cycleController.text);
          }
          //数据存储在数据库中
          DDCacheUtil.cacheData(tempTagName, tempController.text);
        }
        if (this.lastNode != tempNode) {
          this.lastNode = tempNode;
          lastIndex=i;
        }
      }

    }

  }
  Future<void> fetchTempDDModel() async {
     tempDDDbModel = await TempDDTools().queryTempDD('2222');

    if (tempDDDbModel != null) {
        _numberController.text = tempDDDbModel.ddNumber??"";
        _planeNoController.text = tempDDDbModel.ddPlaneNo;
        _reportDateController.text =tempDDDbModel.ddReportDate;
        _reportPlaceController.text =tempDDDbModel.ddReportPlace;
        _keepPersonController.text =tempDDDbModel.ddKeepPerson;
        _phoneNumberController.text =tempDDDbModel.ddPhoneNumber;
        _faxController.text =tempDDDbModel.ddFax;
        _keepMeasureController.text =tempDDDbModel.ddKeepMeasure;
        _nameController.text =tempDDDbModel.ddName;
        _jnoController.text =tempDDDbModel.ddJno;
        _faultNumController.text =tempDDDbModel.ddFaultNum;
        _installNumController.text =tempDDDbModel.ddInstallNum;
        _releaseNumController.text =tempDDDbModel.ddReleaseNum;
        _chapter1Controller.text =tempDDDbModel.ddChapter1;
        _chapter2Controller.text =tempDDDbModel.ddChapter2;
        _chapter3Controller.text =tempDDDbModel.ddChapter3;
        _dropValueForFaultCategory=tempDDDbModel.ddFaultCategory;
        _dropValueForInfluence=tempDDDbModel.ddInfluence;
        _checkValueOOption=tempDDDbModel.ddo==1?true:false;
        _checkValueOtherOption=tempDDDbModel.ddOther==1?true:false;
        _otherController.text =tempDDDbModel.ddOtherDescribe;
        _checkValueOIOption=tempDDDbModel.ddOI==1?true:false;
        _checkValueLSOption=tempDDDbModel.ddLS==1?true:false;
        _checkValueSGOption=tempDDDbModel.ddSG==1?true:false;
        _checkValueSPOption=tempDDDbModel.ddSP==1?true:false;
        _dayController.text =tempDDDbModel.ddDay;
        _hourController.text =tempDDDbModel.ddHour;
        _cycleController.text =tempDDDbModel.ddCycle;
        _describeController.text =tempDDDbModel.ddKeepDescribe;
        _needParkingTimeController.text =tempDDDbModel.ddParkingTime;
        _needWorkHourController.text =tempDDDbModel.ddWorkHour;
        _planOperatorController.text =tempDDDbModel.ddPlanOperator;
        _checkValueMOption=tempDDDbModel.ddNeedM==1?true:false;
        _checkValueRunOption=tempDDDbModel.ddNeedRun==1?true:false;
        _checkValueAMCOption=tempDDDbModel.ddNeedAmc==1?true:false;
         _dropValueForEvidence=tempDDDbModel.ddEvidence;
        _chapterNo1Controller.text =tempDDDbModel.ddChapterNo1;
        _chapterNo2Controller.text =tempDDDbModel.ddChapterNo2;
        _chapterNo3Controller.text =tempDDDbModel.ddChapterNo3;
        _chapterNo4Controller.text =tempDDDbModel.ddChapterNo4;
        _chapterNo5Controller.text =tempDDDbModel.ddChapterNo5;
        setState(() {

        });
    }
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
            icon:Icon(Icons.arrow_back_ios) ), title:Text(Translations.of(context).text('temporary_dd_add_page'), style: TextThemeStore.textStyleAppBar,),
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

