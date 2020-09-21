import 'package:flutter/material.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
class DescribeTextField extends StatefulWidget {
  final String tagName;
  final List textFieldNodes;
  final FocusNode node;
  final TextEditingController controller;

  DescribeTextField({this.tagName, this.textFieldNodes, this.node,
    this.controller});

  @override
  _DescribeTextFieldState createState() => _DescribeTextFieldState();
}

class _DescribeTextFieldState extends State<DescribeTextField> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child:Text(Translations.of(context).text(widget.tagName),style: TextStyle(fontSize: KFont.formTitle,color: KColor.textColor_66)),
          ),
          SizedBox(height: 10,),
          DDTextFieldUtil.ddTextField(context,tag:widget.tagName,textFieldNodes: widget.textFieldNodes,
              node: widget.node,
              controller:widget.controller,
              multiline: true

          ) ,
        ],
      ),
    );
  }
}
