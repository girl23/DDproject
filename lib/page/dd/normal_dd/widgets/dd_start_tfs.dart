import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/page/dd/dd_date_time_picker_util.dart';
import 'package:lop/page/dd/na_button_util.dart';
import 'package:lop/page/dd/dd_calculate_date_provide.dart';
import 'package:lop/utils/date_util.dart';
import 'package:provider/provider.dart';
import 'package:lop/page/dd/dd_cache_util.dart';
typedef CalendarClick = void Function(String result);
class DDStart extends StatefulWidget {
  final CalendarClick calendarClick;
  final List textFieldNodes;
  final FocusNode startDateNode;
  final FocusNode totalHourNode;
  final FocusNode totalCycleNode;

  final TextEditingController startDateController;
  final TextEditingController totalHourController;
  final TextEditingController totalCycleController;
  final bool fromTempDD;

  DDStart(this.calendarClick, this.textFieldNodes, this.startDateNode,
      this.totalHourNode, this.totalCycleNode, this.startDateController,
      this.totalHourController, this.totalCycleController,{this.fromTempDD});

  @override
  _DDStartState createState() => _DDStartState();
}

class _DDStartState extends State<DDStart> {
  //时间选择器
  DateTimePicker _ddTimePicker=new DateTimePicker();
  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child:Consumer<DDCalculateProvide>(builder: (context,calculate,_){
          widget.startDateController.text=calculate.startTime;
          widget.totalHourController.text=calculate.totalHour;
          widget.totalCycleController.text=calculate.totalCycle;
          return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text(Translations.of(context).text('dd_startDate'),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Expanded(child:DDTextFieldUtil.ddTextField(context,tag:'dd_startDate',textFieldNodes: widget.textFieldNodes,node: widget.startDateNode,controller: widget.startDateController,hasSuffix: true,suffixIsIcon:true,suffix: new IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: new Icon(
                          Icons.event,
                          size: 20,
                          color: KColor.textColor_99,
                        ),
                        onPressed:(){
                          //弹出日历
                          _ddTimePicker.ddSelectDate(context).then((val)async{
                            widget.calendarClick(DateUtil.formateYMD(val));
                            if(widget.fromTempDD==false){
                              Provider.of<DDCalculateProvide>(context,listen: false).setStartTime(DateUtil.formateYMD(val));
                              Provider.of<DDCalculateProvide>(context,listen: false).calculateStartAndFirstDate(addOneDay: false);
                              Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'start');
                            }
                            DDCacheUtil.cacheData('dd_startDate', DateUtil.formateYMD(val));

                          });
                        }
                    ),completeCallback: (){
                      Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'start');
                    }) ,flex:ScreenUtil.screenWidthDp<500?10: 7),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:Text('/',style: TextStyle(fontSize: KFont.formTitle,color:KColor.textColor_66) ,
                        ),),
                      flex: 1,),
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_start_time2',textFieldNodes: widget.textFieldNodes,node: widget.totalHourNode,controller: widget.totalHourController,completeCallback: (){
                      if(widget.fromTempDD==false){
                        Provider.of<DDCalculateProvide>(context,listen: false).setTotalHour(widget.totalHourController.text);
                        Provider.of<DDCalculateProvide>(context,listen: false).calculateHour(trigger: 'start');
                      }

                    }),flex: ScreenUtil.screenWidthDp<500?4:7,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:Text('/',style: TextStyle(fontSize: KFont.formTitle,color:KColor.textColor_66) ,
                        ),),
                      flex: 1,),
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_start_time3',textFieldNodes: widget.textFieldNodes,node: widget.totalCycleNode,controller: widget.totalCycleController,hasSuffix:true,suffix: NAButton.createNaButton(widget.totalCycleController,tag:'dd_start_time3',naBtnClick: (){
//                      Provider.of<DDCalculateProvide>(context,listen: false).setCanCalculate(false);
                    }),completeCallback: (){
                      if(widget.fromTempDD==false){
                        Provider.of<DDCalculateProvide>(context,listen: false).setTotalCycle(widget.totalCycleController.text);
                        Provider.of<DDCalculateProvide>(context,listen: false).calculateCycle(trigger: 'start');
                      }
                    }),flex: 7,)
                  ],
                )
              ]
          );
        },),
    );
  }
}
