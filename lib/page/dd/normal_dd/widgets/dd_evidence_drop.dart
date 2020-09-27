import 'package:flutter/material.dart';
import 'package:lop/page/dd/component/dd_component.dart';
import 'package:lop/utils/translations.dart';
typedef ValueChanged<T> = void Function(T value);
class EvidenceDrop extends StatefulWidget {
  final ValueChanged valueChanged;
  String defaultValue;
  EvidenceDrop({this.valueChanged,this.defaultValue});
  @override
  _EvidenceDropState createState() => _EvidenceDropState();
}
class _EvidenceDropState extends State<EvidenceDrop> {
  @override
  Widget build(BuildContext context) {
    return  DDComponent.tagAndDropButton('dd_evidence_type', 410,[
      DropdownMenuItem(child: Text('MEL'),value: '0',),
      DropdownMenuItem(child: Text('CDL'),value: '1'),
      DropdownMenuItem(child: Text(Translations.of(context).text('dd_other')),value: '2'),
    ],widget.defaultValue,valueChanged: (val){
      widget.defaultValue=val;
      widget.valueChanged(val);
      setState(() {
      });
    });
  }
}
