import 'package:flutter/material.dart';
import 'package:lop/page/dd/component/dd_component.dart';
import 'package:lop/utils/translations.dart';
typedef ValueChanged<T> = void Function(T value);
class EvidenceDrop extends StatefulWidget {
  final ValueChanged valueChanged;
  final String defaultValue;
  EvidenceDrop({this.valueChanged,this.defaultValue});
  @override
  _EvidenceDropState createState() => _EvidenceDropState();
}
class _EvidenceDropState extends State<EvidenceDrop> {
  String dropValue;
  @override
  Widget build(BuildContext context) {
    return  DDComponent.tagAndDropButton('dd_evidence_type', 410,[
      DropdownMenuItem(child: Text('MEL'),value: 'MEL',),
      DropdownMenuItem(child: Text('CDL'),value: 'CDL'),
      DropdownMenuItem(child: Text(Translations.of(context).text('dd_other')),value: '其它'),
    ],dropValue,valueChanged: (val){
      dropValue=val;
      widget.valueChanged(val);
      setState(() {
      });
    },placeHolder:widget.defaultValue);
  }
}
