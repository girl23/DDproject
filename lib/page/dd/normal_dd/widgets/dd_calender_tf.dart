import 'package:flutter/material.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/page/dd/dd_date_time_picker_util.dart';
import 'package:lop/utils/date_util.dart';
import 'package:lop/style/color.dart';
class CalendarTextField extends StatefulWidget {
  final ValueChanged valueChanged;
  final String tagName;
  final double width;
  final List textFieldNodes;
  final FocusNode node;
  final TextEditingController controller;
  CalendarTextField({this.tagName, this.width, this.textFieldNodes, this.node,
    this.controller,this.valueChanged});

  @override
  _CalendarTextFieldState createState() => _CalendarTextFieldState();
}

class _CalendarTextFieldState extends State<CalendarTextField> {


  //时间选择器
  DateTimePicker _ddTimePicker=new DateTimePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child:Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child:Text(Translations.of(context).text(widget.tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
          ),
          SizedBox(height: 5,),
          DDTextFieldUtil.ddTextField(
                context,
                tag:widget.tagName,
                textFieldNodes: widget.textFieldNodes,
                node: widget.node,
                controller: widget.controller,
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
                    widget.controller.text=DateUtil.formateYMD(val);
                    widget.valueChanged(val);
                  });
                }),
              )

        ],
      ) ,
    );
  }
}
