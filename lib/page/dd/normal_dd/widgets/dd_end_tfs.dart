import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/page/dd/dd_date_time_picker_util.dart';
import 'package:lop/page/dd/dd_calculate_date_provide.dart';
import 'package:lop/utils/date_util.dart';
import 'package:provider/provider.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
typedef CalendarClick = void Function(String result);
class DDEnd extends StatefulWidget {
  final CalendarClick calendarClick;
  final List textFieldNodes;
  final FocusNode endDateNode;
  final FocusNode endHourNode;
  final FocusNode endCycleNode;

  final TextEditingController endDateController;
  final TextEditingController endHourController;
  final TextEditingController endCycleController;
  final bool fromTempDD;
  DDEnd(
      this.calendarClick,
      this.textFieldNodes,
      this.endDateNode,
      this.endHourNode,
      this.endCycleNode,
      this.endDateController,
      this.endHourController,
      this.endCycleController,
      {this.fromTempDD});

  @override
  _DDEndState createState() => _DDEndState();
}

class _DDEndState extends State<DDEnd> {

  //时间选择器
  DateTimePicker _ddTimePicker=new DateTimePicker();
  @override
  Widget build(BuildContext context) {
    return Consumer<DDCalculateProvide>(builder: (context,calculate,_){
      widget.endDateController.text=calculate.endTime;
      widget.endHourController.text=calculate.endHour;
      widget.endCycleController.text=calculate.endCycle;

      return Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text(Translations.of(context).text('dd_endDate'),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_end_time1',textFieldNodes: widget.textFieldNodes,node: widget.endDateNode,controller: widget.endDateController,hasSuffix: true,
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
                          _ddTimePicker.ddSelectDate(context).then((val) async{
                            widget.calendarClick(DateUtil.formateYMD(val));
                            if(widget.fromTempDD==false){
                              Provider.of<DDCalculateProvide>(context,listen: false).setEndTime(widget.endDateController.text);
                              Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'end');
                            }
                            DDCacheUtil.cacheData('dd_end_time', DateUtil.formateYMD(val));
                          });
                        }
                    ),suffixIsIcon:true,completeCallback: (){
                      if(widget.fromTempDD==false){
                        Provider.of<DDCalculateProvide>(context,listen: false).setEndTime(widget.endDateController.text);
                        Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'end');
                      }

                    }),flex: ScreenUtil.screenWidthDp<500?10: 7,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:Text('/',style: TextStyle(fontSize: KFont.formTitle,color:KColor.textColor_66) ,
                        ),),
                      flex: 1,),
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_end_time2',textFieldNodes: widget.textFieldNodes,node: widget.endHourNode,controller:widget.endHourController,completeCallback: (){
                      if(widget.fromTempDD==false){
                        Provider.of<DDCalculateProvide>(context,listen: false).setEndHour(widget.endHourController.text);
                        Provider.of<DDCalculateProvide>(context,listen: false).calculateHour(trigger: 'end');
                      }

                    }),flex: ScreenUtil.screenWidthDp<500?4:7,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:Text('/',style: TextStyle(fontSize: KFont.formTitle,color:KColor.textColor_66) ,
                        ),),
                      flex: 1,),
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_end_time3',textFieldNodes: widget.textFieldNodes,node: widget.endCycleNode,controller: widget.endCycleController,completeCallback: (){
                      if(widget.fromTempDD==false){
                        Provider.of<DDCalculateProvide>(context,listen: false).setEndCycle(widget.endCycleController.text);
                        Provider.of<DDCalculateProvide>(context,listen: false).calculateCycle(trigger: 'end');
                      }
                    }),flex: 7,)
                  ],
                )
              ]
          )
      );
    });

  }
}
