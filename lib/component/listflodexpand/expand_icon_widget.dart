//图标为复选框保留
//图标为复选框保留
//图标为复选框保留

//import 'package:flutter/material.dart';
//class ExpandIcon extends StatefulWidget {
//  const ExpandIcon({
//    Key key,
//    this.isExpanded = false,
//    @required this.valueChanged,
//  }) : assert(isExpanded != null),
//        super(key: key);
//
//  final bool isExpanded;
//
//  final ValueChanged<bool> valueChanged;
//
//  @override
//  _ExpandIconState createState() => _ExpandIconState();
//}
//
//class _ExpandIconState extends State<ExpandIcon> with SingleTickerProviderStateMixin {
//
//  void _handlePressed() {
//    if (widget.valueChanged != null)
//      widget.valueChanged(widget.isExpanded);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Checkbox(
//      value: widget.isExpanded,
//      onChanged: (bool value) {
//        setState(() {
//          _handlePressed();
//        });
//      },
//    );
//  }
//}



import 'package:flutter/material.dart';
import 'dart:math' ;
class ExpandIcon extends StatefulWidget {
  const ExpandIcon({
    Key key,
    this.isExpanded = false,
    this.size = 12.0,
    @required this.onPressed,
    this.padding=const EdgeInsets.fromLTRB(0, 10.0, 24, 8.0),
    this.color,
    this.disabledColor,
    this.expandedColor,
    this.icon,
  }) : assert(isExpanded != null),
        assert(size != null),
        assert(padding != null),
        super(key: key);

  final bool isExpanded;

  final double size;

  final ValueChanged<bool> onPressed;

  final EdgeInsetsGeometry padding;

  final Color color;

  final Color disabledColor;

  final Color expandedColor;

  final Icon icon;

  @override
  _ExpandIconState createState() => _ExpandIconState();
}

class _ExpandIconState extends State<ExpandIcon> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    double angle = widget.isExpanded ? pi/2 : 0;
    return IconButton(
      padding: widget.padding,
      disabledColor: widget.disabledColor,
      icon:Transform(
        transform: Matrix4.identity()..rotateZ(angle),// 旋转的角度
        origin: Offset(6,6),// 旋转的中心点
        child: Icon(Icons.arrow_forward_ios, color: Colors.white,size: 12.0,),
      ),
    );

  }
}

class CheckIcon extends StatefulWidget {
  const CheckIcon({
    Key key,
    this.isSelect = false,
    @required this.valueChanged,
  }) : assert(isSelect != null),
        super(key: key);

  final bool isSelect;

  final ValueChanged<bool> valueChanged;

  @override
  _CheckIconState createState() => _CheckIconState();
}

class _CheckIconState extends State<CheckIcon> with SingleTickerProviderStateMixin {

  void _handlePressed() {

    if (widget.valueChanged != null)
      widget.valueChanged(widget.isSelect);

  }

  @override
  Widget build(BuildContext context) {
    return
      IconButton(
        icon:widget.isSelect? Icon(Icons.check_circle,color: Colors.orange,size: 22,):Icon(Icons.lens,color: Colors.white,size: 22,),
        onPressed: () {
            setState(() {
            _handlePressed();
          });
        },
      );

    //      Checkbox(
//      value: widget.isExpanded,
//      onChanged: (bool value) {
//        setState(() {
//          _handlePressed();
//        });
//      },
//    );
  }
}