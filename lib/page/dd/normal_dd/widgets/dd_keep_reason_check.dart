import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:lop/page/dd/component/dd_component.dart';
typedef ValueChanged<T> = void Function(T value);
class KeepReason extends StatefulWidget {
  final ValueChanged valueChangedForOI;
  final ValueChanged valueChangedForLS;
  final ValueChanged valueChangedForSG;
  final ValueChanged valueChangedForSP;
  final bool checkValueOIOption;
  final bool checkValueLSOption;
  final bool checkValueSGOption;
  final bool checkValueSPOption;

  KeepReason({this.valueChangedForOI, this.valueChangedForLS,
    this.valueChangedForSG, this.valueChangedForSP, this.checkValueOIOption,
    this.checkValueLSOption, this.checkValueSGOption,
    this.checkValueSPOption});

  @override
  _KeepReasonState createState() => _KeepReasonState();
}

class _KeepReasonState extends State<KeepReason> {
   bool oIOption;
   bool lSOption;
   bool sGOption;
   bool sPOption;
   bool oiUpdate=false;
   bool lsUpdate=false;
   bool sgUpdate=false;
   bool spUpdate=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Container(
//              padding: EdgeInsets.only(left: 15),
//              alignment: Alignment.centerLeft,
//              child:Text(Translations.of(context).text('dd_keep_reason'),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
//            ),
            DDComponent.tagAndCheckBoxLeft('dd_oi', 100, oiUpdate?oIOption:widget.checkValueOIOption,valueChanged: (value){
              oiUpdate=true;
              oIOption=value;
              widget.valueChangedForOI(value);
              setState(() {
              });
            }),
            DDComponent.tagAndCheckBoxLeft('dd_ls', 100, lsUpdate?lSOption:widget.checkValueLSOption,valueChanged: (value){
              lsUpdate=true;
              lSOption=value;
              widget.valueChangedForLS(value);
              setState(() {
              });
            }),
            DDComponent.tagAndCheckBoxLeft('dd_sg', 100,sgUpdate?sGOption:widget.checkValueSGOption,valueChanged: (value){
              sgUpdate=true;
              sGOption=value;
              widget.valueChangedForSG(value);
              setState(() {
              });
            }),
            DDComponent.tagAndCheckBoxLeft('dd_sp', 100, spUpdate?sPOption:widget.checkValueSPOption,valueChanged: (value){
             spUpdate=true;
              sPOption=value;
              widget.valueChangedForSP(value);
              setState(() {
              });
            }),
          ]
      ),
    );
  }
}
