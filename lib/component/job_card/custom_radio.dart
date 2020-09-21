import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
typedef void CustomRadioChange(String group,String dbid);
class CustomRadio extends StatefulWidget {

  final dbId;
  final group;
  final radioWidth;
  final radioValue;
  final CustomRadioChange radioChange;
  CustomRadio({Key key,@required this.radioChange, this.dbId,this.group, this.radioWidth,this.radioValue}) : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: widget.radioWidth,
        height: widget.radioWidth,
        child: Checkbox(
          value: widget.dbId == widget.radioValue,
          //选中框的背景颜色
          activeColor: Theme.of(context).primaryColor,
          //选中勾的颜色
          checkColor: Colors.white,
          tristate: false,
          onChanged: (v){
            setState(() {
              widget.radioChange(widget.group,widget.dbId);
            });
          },
        ),
      );
  }
}
