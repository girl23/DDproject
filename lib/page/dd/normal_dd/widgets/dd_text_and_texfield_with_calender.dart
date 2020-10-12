import 'package:flutter/material.dart';
import 'package:lop/config/enum_config.dart';
import 'package:lop/page/dd/dd_date_time_picker_util.dart';
import 'package:lop/page/dd/dd_calculate_date_provide.dart';
import 'package:lop/utils/date_util.dart';
import 'package:provider/provider.dart';
import 'package:lop/page/dd/normal_dd/widgets/dd_calender_tf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lop/database/temp_dd_tools.dart';
import 'package:lop/database/temp_dd_model.dart';
import 'package:lop/database/normal_dd_tools.dart';
import 'package:lop/database/normal_dd_model.dart';
import 'dart:async';
import 'package:lop/viewmodel/user_viewmodel.dart';

typedef CalendarClick = void Function(String result);
class TextAndTextFieldWithCalender extends StatefulWidget {
  final CalendarClick calendarClick;
  final String tagName;
  final List textFieldNodes;
  final FocusNode reportDateFocusNode;
  final TextEditingController reportDateController;
  final bool firstReportTime;
  TextAndTextFieldWithCalender(this.tagName,this.textFieldNodes,this.reportDateFocusNode,this.reportDateController,this.calendarClick,{this.firstReportTime});

  @override
  _TextAndTextFieldWithCalenderState createState() => _TextAndTextFieldWithCalenderState();
}

class _TextAndTextFieldWithCalenderState extends State<TextAndTextFieldWithCalender> {
  static Future<TempDDDbModel>  fetchTempDDModel() async {
    TempDDDbModel tempDDDbModel = await TempDDTools().queryTempDD('2222');
    return tempDDDbModel;
  }
  static Future<NormalDDDbModel>  fetchNormalDDModel(String fromPage ) async {

    NormalDDDbModel normalDDDbModel = await NormalDDTools().queryNormalDD('2222',fromPage);
    return normalDDDbModel;
  }
  //时间选择器
  DateTimePicker _ddTimePicker=new DateTimePicker();
  @override
  Widget build(BuildContext context) {
    String userId=Provider.of<UserViewModel>(context, listen: false).info.userId;
    return  Consumer<DDCalculateProvide>(builder: (context,calculate,_){

      if(widget.firstReportTime??false){
        widget.reportDateController.text=calculate.firstReportTime;
      }
      return CalendarTextField(
        tagName:widget.tagName,
        width: 330,
        textFieldNodes: widget.textFieldNodes,
        node: widget.reportDateFocusNode,
        controller: widget.reportDateController,
        valueChanged: (val)async{
          widget.calendarClick(DateUtil.formateYMD(val));
          if(widget.tagName=='dd_firstReportDate'){
            Provider.of<DDCalculateProvide>(context,listen: false).setFirstReportTime(DateUtil.formateYMD(val));
            Provider.of<DDCalculateProvide>(context,listen: false).calculateStartAndFirstDate(addOneDay: true);
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String uiFor= prefs.getString("uiFor");
          if(uiFor=='temp'){
            TempDDDbModel model=await fetchTempDDModel();
            if (model == null) {
              //添加一条数据

              await TempDDTools().addTempDD(userId,widget.tagName,DateUtil.formateYMD(val));
            }else{
              //更新数据
              bool success= await TempDDTools().updateTempDD(widget.tagName,DateUtil.formateYMD(val),userId);
            }
          }else{
            //DD
            String fromPage= prefs.getString("fromPage");
            NormalDDDbModel model=await fetchNormalDDModel(fromPage);
            if (model == null) {
              //添加一条数据
              await NormalDDTools().addNormalDD(userId,widget.tagName,DateUtil.formateYMD(val),fromPage);
            }else{
              //更新数据
              bool success= await NormalDDTools().updateNormalDD(widget.tagName,DateUtil.formateYMD(val),userId,fromPage);
            }
          }
        },
      );
    });

  }
}
