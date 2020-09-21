import 'package:flutter/material.dart';
class TextWidget extends StatefulWidget {
  TextWidget(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextWidgetState();
  }
}

class TextWidgetState extends State<TextWidget> {
  bool  _isSelectAll=false;
  @override
  Widget build(BuildContext context) {
    return  Text(_isSelectAll?'取消全选':'全选',style: TextStyle(fontSize: 14,color:Colors.white), );
  }

  void onPressed(bool isSelectAll) {
    setState(() {
      _isSelectAll=isSelectAll;
    });
  }

}