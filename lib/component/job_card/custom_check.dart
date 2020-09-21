import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
typedef void CustomCheckedChange(String dbId,bool value);
class CustomCheck extends StatefulWidget {

  final dbId;
  final checkWidth;
  final checkValue;
  final CustomCheckedChange checkedChange;
  CustomCheck({Key key,@required this.checkedChange, this.dbId,this.checkWidth,this.checkValue = false}) : super(key: key);

  @override
  _CustomCheckState createState() => _CustomCheckState();
}

class _CustomCheckState extends State<CustomCheck> {
  bool _isCheck = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isCheck = widget.checkValue;
  }
  @override
  void didUpdateWidget(CustomCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isCheck = widget.checkValue;
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isCheck = widget.checkValue;
  }
  @override
  Widget build(BuildContext context) {
    return
        Container(
          width: widget.checkWidth,
          height: widget.checkWidth,
          child: Checkbox(
            value: _isCheck,
            //选中框的背景颜色
            activeColor: Theme.of(context).primaryColor,
            //选中勾的颜色
            checkColor: Colors.white,
            tristate: false,
            onChanged: (v){
              setState(() {
                _isCheck = v;
                widget.checkedChange(widget.dbId,v);
              });
            },
          ),
    );
  }
}
