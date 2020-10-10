import 'package:flutter/material.dart';
import 'package:lop/page/dd/component/dd_component.dart';
import 'package:lop/style/color.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/config/enum_config.dart';
typedef ValueChanged<T> = void Function(T value);
class MBCode extends StatefulWidget {
  final comeFromPage fromPage;
  final ValueChanged valueChanged;
  final String times;
  String defaultValue;
  MBCode(this.fromPage,{this.valueChanged,this.defaultValue,this.times});

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
          child:DDComponent.tagAndTextHorizon('dd_delay_times', '${(widget.times!=null&&widget.times!="")?widget.times:'0'}次',width: 330,color: KColor.textColor_66),),
        DDComponent.tagImageAndDropButton('dd_MBCode', 330,[
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB1')),value: '1'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB2')),value: '2'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB3')),value: '3'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB4')),value: '4'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB5')),value: '5'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB6')),value: '6'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB7')),value: '7'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB8')),value: '8'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB9')),value: '9'),
          DropdownMenuItem(child: Text(Translations.of(context).text('dd_MB10')),value: '10'),
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
