import 'package:flutter/material.dart';
import 'package:lop/page/dd/component/dd_component.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/config/enum_config.dart';
typedef ValueChanged<T> = void Function(T value);
class MBCode extends StatefulWidget {
  final comeFromPage fromPage;
  final ValueChanged valueChanged;
  String defaultValue;
  MBCode(this.fromPage,{this.valueChanged,this.defaultValue});

  @override
  _MBCodeState createState() => _MBCodeState();
}
class _MBCodeState extends State<MBCode> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Offstage(
          offstage:!((widget.fromPage==comeFromPage.fromDDDelay)),
          child:DDComponent.tagAndTextHorizon('dd_delay_times', '3次',width: 330,notBoldTitle:true),),
        DDComponent.tagImageAndDropButton('dd_MBCode', 330,[
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB1')),value: Translations.of(context).text('dd_MB1')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB2')),value: Translations.of(context).text('dd_MB2')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB3')),value: Translations.of(context).text('dd_MB3')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB4')),value: Translations.of(context).text('dd_MB4')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB5')),value: Translations.of(context).text('dd_MB5')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB6')),value: Translations.of(context).text('dd_MB6')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB7')),value: Translations.of(context).text('dd_MB7')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB8')),value: Translations.of(context).text('dd_MB8')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB9')),value: Translations.of(context).text('dd_MB9')),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB10')),value: Translations.of(context).text('dd_MB10')),
        ],widget.defaultValue,imgStr: 'assets/images/dw.png',valueChanged: (val){
          widget.defaultValue=val;
          widget.valueChanged(val);
          setState(() {
          },);
        }),
      ],
    );
  }
}
