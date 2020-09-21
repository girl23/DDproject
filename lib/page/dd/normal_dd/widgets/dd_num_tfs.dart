import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/page/dd/na_button_util.dart';
import 'package:lop/style/color.dart';

class Num extends StatefulWidget {
  final List textFieldNodes;
  final FocusNode faultNumNode;
  final FocusNode releaseNumNode;
  final FocusNode installNumNode;

  final TextEditingController faultNumController;
  final TextEditingController releaseNumController;
  final TextEditingController installNumController;

  Num({this.textFieldNodes, this.faultNumNode, this.releaseNumNode,
    this.installNumNode, this.faultNumController, this.releaseNumController,
    this.installNumController});

  @override
  _NumState createState() => _NumState();
}

class _NumState extends State<Num> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child:Text(Translations.of(context).text('dd_Num'),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  flex: 7,
                  child:DDTextFieldUtil.ddTextField(context,tag:'dd_faultNum',textFieldNodes: widget.textFieldNodes,
                    node: widget.faultNumNode,
                    controller: widget.faultNumController,
                    hasSuffix: true,
                    suffix:NAButton.createNaButton(widget.faultNumController,tag:'dd_faultNum'),
                  )
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child:Text('/',style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66) ,
                  ),),
                flex: 1,),
              Expanded(
                  flex: 7,
                  child:DDTextFieldUtil.ddTextField(context,tag:'dd_releaseNum',textFieldNodes: widget.textFieldNodes,
                    node: widget.releaseNumNode,
                    controller: widget.releaseNumController,
                    hasSuffix: true,
                    suffix:NAButton.createNaButton(widget.releaseNumController,tag:'dd_releaseNum'),)
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child:Text('/',style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66) ,
                  ),),
                flex: 1,),
              Expanded(
                  flex: 7,
                  child:DDTextFieldUtil.ddTextField(context,tag:'dd_installNum', textFieldNodes: widget.textFieldNodes,
                    node: widget.installNumNode,
                    controller: widget.installNumController,
                    hasSuffix: true,
                    suffix:NAButton.createNaButton(widget.installNumController,tag:'dd_installNum'),
                  )
              ),
            ],
          ),

        ],
      ),
    );
  }
//  Widget build(BuildContext context) {
//    return  Container(
//      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text(
//              Translations.of(context).text('dd_Num'),
//              style: TextStyle(fontSize: KFont.formTitle)
//          ),
//          SizedBox(height: 10,),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              Expanded(child: Container(),flex: 1,),
//              Container(width:ScreenUtil().setWidth(220),
//                  alignment: Alignment.centerRight,
//                  child:
//                  Text(Translations.of(context).text('dd_faultNum'),style: TextStyle(fontSize: KFont.formTitle),)
//              ),
//              SizedBox(width: ScreenUtil().setWidth(30),),
//              Expanded(
//                  flex: 3,
//                  child:DDTextFieldUtil.ddTextField(context,tag:'dd_faultNum',textFieldNodes: widget.textFieldNodes,
//                    node: widget.faultNumNode,
//                    controller: widget.faultNumController,
//                    hasSuffix: true,
//                    suffix:NAButton.createNaButton(widget.faultNumController),
//                  )
//              ),
//              SizedBox(width: ScreenUtil().setWidth(60),),
//              Container(
//                  width:ScreenUtil().setWidth(220),
//                  alignment: Alignment.centerRight,
//                  child:
//                  Text(Translations.of(context).text('dd_releaseNum'),style: TextStyle(fontSize: KFont.formTitle),)
//              ),
//              SizedBox(width: ScreenUtil().setWidth(30),),
//              Expanded(
//                  flex: 3,
//                  child:DDTextFieldUtil.ddTextField(context,tag:'dd_releaseNum',textFieldNodes: widget.textFieldNodes,
//                    node: widget.releaseNumNode,
//                    controller: widget.releaseNumController,
//                    hasSuffix: true,
//                    suffix:NAButton.createNaButton(widget.releaseNumController),)
//              ),
//            ],
//          ),
//          SizedBox(height: 10,),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              Expanded(child: Container(),flex: 1,),
//              Container(
//                  width: ScreenUtil().setWidth(220),
////                     color: Colors.redAccent,
//                  alignment: Alignment.centerRight,
//                  child:
//                  Text(Translations.of(context).text('dd_installNum'),style: TextStyle(fontSize: KFont.formTitle),)
//              ),
//              SizedBox(width: ScreenUtil().setWidth(30),),
//              Expanded(
//                  flex: 3,
//                  child:DDTextFieldUtil.ddTextField(context,tag:'dd_installNum', textFieldNodes: widget.textFieldNodes,
//                    node: widget.installNumNode,
//                    controller: widget.installNumController,
//                    hasSuffix: true,
//                    suffix:NAButton.createNaButton(widget.installNumController),
//                  )
//              ),
//              SizedBox(width: ScreenUtil().setWidth(310),),
//              Expanded(
//                flex: 3,
//                child: Container(),
//              ),
//
//            ],
//          ),
//        ],
//      ),
//    );
//  }
}
