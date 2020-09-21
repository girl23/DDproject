import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/page/dd/dd_calculate_date_provide.dart';
import 'package:provider/provider.dart';
class DDSpace extends StatefulWidget {
  final List textFieldNodes;
  final FocusNode dayNode;
  final FocusNode hourNode;
  final FocusNode cycleNode;

  final TextEditingController dayController;
  final TextEditingController hourController;
  final TextEditingController cycleController;
  final bool fromTempDD;

  DDSpace({this.textFieldNodes, this.dayNode, this.hourNode, this.cycleNode,
    this.dayController, this.hourController, this.cycleController,this.fromTempDD});

  @override
  _DDSpaceState createState() => _DDSpaceState();
}

class _DDSpaceState extends State<DDSpace> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child:Consumer<DDCalculateProvide>(builder: (context,calculate,_){

            widget.dayController.text=(widget.fromTempDD)?calculate.day:calculate.space;
            widget.hourController.text=(widget.fromTempDD)?calculate.hour:calculate.spaceHour;
            widget.cycleController.text=(widget.fromTempDD)?calculate.cycle:calculate.spaceCycle;
          return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text(Translations.of(context).text('dd_plan_keep_time'),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_plan_keep_time1',textFieldNodes: widget.textFieldNodes,node: widget.dayNode,controller: widget.dayController,completeCallback: (){
                     if(widget.
                     fromTempDD==false){
                       Provider.of<DDCalculateProvide>(context,listen: false).setSpace(widget.dayController.text);
                       Provider.of<DDCalculateProvide>(context,listen: false).calculateDate(trigger: 'space');
                     }
                     if(widget.fromTempDD==true){
                       Provider.of<DDCalculateProvide>(context,listen: false).setDay(widget.dayController.text);
                     }

                    }),flex: 7,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:Text('/',style: TextStyle(fontSize: KFont.formTitle) ,
                        ),),
                      flex: 1,),
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_plan_keep_time2',textFieldNodes: widget.textFieldNodes,node: widget.hourNode,controller: widget.hourController,completeCallback: (){
                      if(widget.fromTempDD==false){
                        Provider.of<DDCalculateProvide>(context,listen: false).setSpaceHour(widget.hourController.text);
                        Provider.of<DDCalculateProvide>(context,listen: false).calculateHour(trigger: 'space');
                      }
                      if(widget.fromTempDD==true){
                        Provider.of<DDCalculateProvide>(context,listen: false).setHour(widget.hourController.text);
                      }

                    }),flex: 7,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:Text('/',style: TextStyle(fontSize: KFont.formTitle) ,
                        ),),
                      flex: 1,),
                    Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_plan_keep_time3',textFieldNodes: widget.textFieldNodes,node: widget.cycleNode,controller: widget.cycleController,completeCallback: (){
                      if(widget.fromTempDD==false){
                        Provider.of<DDCalculateProvide>(context,listen: false).setSpaceCycle(widget.cycleController.text);
                        Provider.of<DDCalculateProvide>(context,listen: false).calculateCycle(trigger: 'space');
                      }
                      if(widget.fromTempDD==true){
                        Provider.of<DDCalculateProvide>(context,listen: false).setCycle(widget.cycleController.text);
                      }

                    }),flex: 7,)
                  ],
                )
              ]
          );
        }),

    );
  }
}
