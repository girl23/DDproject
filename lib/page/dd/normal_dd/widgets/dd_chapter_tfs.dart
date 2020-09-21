import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
class Chapter extends StatefulWidget {
  final List textFieldNodes;
  final FocusNode chapter1Node;
  final FocusNode chapter2Node;
  final FocusNode chapter3Node;

  final TextEditingController chapter1Controller;
  final TextEditingController chapter2Controller;
  final TextEditingController chapter3Controller;

  Chapter({this.textFieldNodes, this.chapter1Node, this.chapter2Node,
    this.chapter3Node, this.chapter1Controller, this.chapter2Controller,
    this.chapter3Controller});

  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child:Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child:Text(Translations.of(context).text('dd_chapter'),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
        ),
        SizedBox(height: 10,),
        Row(
          children: <Widget>[

            Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_chapter1',textFieldNodes: widget.textFieldNodes,node: widget.chapter1Node,controller: widget.chapter1Controller),flex: 7,),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child:Text('-',style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66) ,
                ),),
              flex: 1,),
            Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_chapter2',textFieldNodes: widget.textFieldNodes,node: widget.chapter2Node,controller: widget.chapter2Controller),flex: 7,),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child:Text('-',style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66) ,
                ),),
              flex: 1,),
            Expanded(child: DDTextFieldUtil.ddTextField(context,tag:'dd_chapter3',textFieldNodes: widget.textFieldNodes,node: widget.chapter3Node,controller: widget.chapter3Controller),flex: 7,)
          ],
        ) ,
      ],),

    );
  }
}
