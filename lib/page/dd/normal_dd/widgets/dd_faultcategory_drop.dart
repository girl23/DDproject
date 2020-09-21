import 'package:flutter/material.dart';
import 'package:lop/page/dd/component/dd_component.dart';

typedef ValueChanged<T> = void Function(T value);
class FaultCategoryDrop extends StatefulWidget {
  final ValueChanged valueChanged;
  final String defaultValue;
  FaultCategoryDrop({this.valueChanged,this.defaultValue});
  @override
  _FaultCategoryDropState createState() => _FaultCategoryDropState();
}
class _FaultCategoryDropState extends State<FaultCategoryDrop> {

  String dropValue;
  @override
  Widget build(BuildContext context) {

    return  DDComponent.tagAndDropButton('dd_keep_faultCategory', 330,[
      DropdownMenuItem(child: Text('A'),value: 'A'),
      DropdownMenuItem(child: Text('B'),value: 'B'),
      DropdownMenuItem(child: Text('C'),value: 'C'),
      DropdownMenuItem(child: Text('D'),value: 'D'),
      DropdownMenuItem(child: Text('I'),value: 'I'),
      DropdownMenuItem(child: Text('M'),value: 'M'),
      DropdownMenuItem(child: Text('S'),value: 'S'),
      DropdownMenuItem(child: Text('CBS-F'),value: 'CBS-F'),
      DropdownMenuItem(child: Text('CBS-C'),value: 'CBS-C'),
      DropdownMenuItem(child: Text('CBS-Y'),value: 'CBS-Y'),
      DropdownMenuItem(child: Text('CBS-A'),value: 'CBS-A'),
      DropdownMenuItem(child: Text('CBG'),value: 'CBG'),
      DropdownMenuItem(child: Text('CBL'),value: 'CBL'),
      DropdownMenuItem(child: Text('CBO'),value: 'CBO'),
    ],dropValue,valueChanged: (val){
      dropValue=val;
      widget.valueChanged(val);
      setState(() {
      });

    },placeHolder:widget.defaultValue);
  return Container();
  }
}
