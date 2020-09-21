import 'package:flutter/material.dart';
import 'package:lop/style/size.dart';

class JcHideArea extends StatefulWidget {
  final widgets;

  const JcHideArea({Key key, this.widgets}) : super(key: key);

  @override
  _JcHideAreaState createState() => _JcHideAreaState();
}

class _JcHideAreaState extends State<JcHideArea> {
  bool _showArea = false;

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Offstage(
            offstage: !_showArea,
            child: Container(
              color: Colors.grey[300],
              child: RichText(
                text: TextSpan(children: [widget.widgets]),
              ),
            ),
          ),
          Container(
            height: 24,
            width: 24,
            child: IconButton(
              icon: _showArea
                  ? Transform(
                transform: Matrix4.identity()..rotateZ(KSize.pi),
                alignment: Alignment.center,
                child: Icon(Icons.keyboard_arrow_down,size: 24,),
              )
                  : Icon(Icons.keyboard_arrow_down,size: 24,),
              padding: EdgeInsets.zero,
//            iconSize: 30,
              onPressed: () {
                setState(() {
                  _showArea = !_showArea;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
