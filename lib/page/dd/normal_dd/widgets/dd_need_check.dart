import 'package:flutter/material.dart';
import 'package:lop/page/dd/component/dd_component.dart';
typedef ValueChanged<T> = void Function(T value);
class Need extends StatefulWidget {
  final ValueChanged valueChangedForM;
  final ValueChanged valueChangedForRun;
  final ValueChanged valueChangedForAMC;
  final ValueChanged valueChangedForKeepFold;
  final ValueChanged valueChangedForRepeatInspection;
  final bool checkValueMOption;
  final bool checkValueRunOption;
  final bool checkValueAMCOption;
  final bool checkValueKeepFoldOption;
  final bool checkValueRepeatInspectionOption;
  final bool fromTempDD;

  Need({this.valueChangedForM, this.valueChangedForRun, this.valueChangedForAMC,
    this.valueChangedForKeepFold, this.valueChangedForRepeatInspection,
    this.checkValueMOption, this.checkValueRunOption,
    this.checkValueAMCOption, this.checkValueKeepFoldOption,
    this.checkValueRepeatInspectionOption,this.fromTempDD=false});

  @override
  _NeedState createState() => _NeedState();
}

class _NeedState extends State<Need> {
   bool mOption;
   bool runOption;
   bool aMCOption;
   bool keepFoldOption;
   bool repeatInspectionOption;
   bool mUpdate=false;
   bool runUpdate=false;
   bool aMCUpdate=false;
   bool keepFoldUpdate=false;
   bool repeatInspectionUpdate=false;

  @override
  Widget build(BuildContext context) {

    return  Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child:Wrap(
        alignment:WrapAlignment.start ,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          DDComponent.tagAndCheckBoxLeft('dd_need_m',100,mUpdate?mOption:widget.checkValueMOption,valueChanged: (value){
            mUpdate=true;
            mOption=value;
            widget.valueChangedForM(value);
            setState(() {
            });
          }),
          DDComponent.tagAndCheckBoxLeft('dd_need_run_limit', 100,runUpdate?runOption:widget.checkValueRunOption,valueChanged: (value){
            runUpdate=true;
            runOption=value;
            widget.valueChangedForRun(value);
            setState(() {
            });
          }),
          DDComponent.tagAndCheckBoxLeft('dd_need_amc', 100,aMCUpdate?aMCOption:widget.checkValueAMCOption,valueChanged: (value){
            aMCUpdate=true;
            aMCOption=value;
            widget.valueChangedForAMC(value);
            setState(() {
            });
          }),

          (widget.fromTempDD!=true)? DDComponent.tagAndCheckBoxLeft('dd_needKeepToFold',100,keepFoldUpdate?keepFoldOption:widget.checkValueKeepFoldOption,valueChanged: (value){
            keepFoldUpdate=true;
            keepFoldOption=value;
            widget.valueChangedForKeepFold(value);
            setState(() {
            });
          }):Container(),

          (widget.fromTempDD!=true)? DDComponent.tagAndCheckBoxLeft('dd_needRepeatInspection', 100,repeatInspectionUpdate?repeatInspectionOption:widget.checkValueRepeatInspectionOption,valueChanged: (value){
            repeatInspectionUpdate=true;
            repeatInspectionOption=value;
            widget.valueChangedForRepeatInspection(value);
            setState(() {
            });
          }):Container(),

        ],
      ),
    );
//      Container(
//      width: double.infinity,
//      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
//      child:Wrap(
//        alignment:WrapAlignment.start ,
//        crossAxisAlignment: WrapCrossAlignment.start,
//        children: <Widget>[
//          DDComponent.tagAndCheckBoxRight('dd_need_m', 510,mUpdate?mOption:widget.checkValueMOption,valueChanged: (value){
//            mUpdate=true;
//            mOption=value;
//            widget.valueChangedForM(value);
//            setState(() {
//            });
//          }),
//          DDComponent.tagAndCheckBoxRight('dd_need_run_limit', 510,runUpdate?runOption:widget.checkValueRunOption,valueChanged: (value){
//            runUpdate=true;
//            runOption=value;
//            widget.valueChangedForRun(value);
//            setState(() {
//            });
//          }),
//          DDComponent.tagAndCheckBoxRight('dd_need_amc', 510,aMCUpdate?aMCOption:widget.checkValueAMCOption,valueChanged: (value){
//            aMCUpdate=true;
//            aMCOption=value;
//            widget.valueChangedForAMC(value);
//            setState(() {
//            });
//          }),
//
//          (widget.fromTempDD!=true)? DDComponent.tagAndCheckBoxRight('dd_needKeepToFold',800,keepFoldUpdate?keepFoldOption:widget.checkValueKeepFoldOption,valueChanged: (value){
//            keepFoldUpdate=true;
//            keepFoldOption=value;
//            widget.valueChangedForKeepFold(value);
//            setState(() {
//            });
//          }):Container(),
//
//          (widget.fromTempDD!=true)? DDComponent.tagAndCheckBoxRight('dd_needRepeatInspection', 510,repeatInspectionUpdate?repeatInspectionOption:widget.checkValueRepeatInspectionOption,valueChanged: (value){
//               repeatInspectionUpdate=true;
//                repeatInspectionOption=value;
//                widget.valueChangedForRepeatInspection(value);
//                setState(() {
//                });
//              }):Container(),
//
//        ],
//      ),
//    );
  }
}
