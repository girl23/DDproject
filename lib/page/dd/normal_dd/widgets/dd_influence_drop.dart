import 'package:flutter/material.dart';
import 'package:lop/page/dd/component/dd_component.dart';
import 'package:lop/utils/translations.dart';
typedef ValueChanged<T> = void Function(T value);
class InfluenceDrop extends StatefulWidget {
  final ValueChanged valueChanged;
  final String defaultValue;
  InfluenceDrop({this.valueChanged,this.defaultValue});
  @override
  _InfluenceDropState createState() => _InfluenceDropState();
}
class _InfluenceDropState extends State<InfluenceDrop> {
  String dropValue;
  @override
  Widget build(BuildContext context) {
    return  DDComponent.tagAndDropButton('dd_influence', 330,[
      DropdownMenuItem(child: Text(Translations.of(context).text('dd_influence_level1')),value: '严重',),
      DropdownMenuItem(child: Text(Translations.of(context).text('dd_influence_level2')),value: '一般'),
      DropdownMenuItem(child: Text(Translations.of(context).text('dd_influence_level3')),value: '不影响'),
    ],dropValue,valueChanged: (val){
      dropValue=val;
      widget.valueChanged(val);
      setState(() {
      });
    },placeHolder:widget.defaultValue);
  }
}
