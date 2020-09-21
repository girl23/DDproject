import 'package:flutter/material.dart';
import 'package:lop/style/size.dart';

class JcEffArea extends StatefulWidget {
  final widgets;
  final isSwitch;
  const JcEffArea({Key key, this.widgets,this.isSwitch = true}) : super(key: key);

  @override
  _JcEffAreaState createState() => _JcEffAreaState();
}

class _JcEffAreaState extends State<JcEffArea> {
  bool _showArea = false;

  @override
  void initState() {
    super.initState();
    if(widget.isSwitch){
      _showArea = false;
    }else{
      _showArea = true;
    }
  }
  @override
  void didUpdateWidget(JcEffArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isSwitch){
      _showArea = false;
    }else{
      _showArea = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isSwitch?Colors.grey[300]:Colors.white,
      child: Center(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Offstage(
              offstage: !_showArea,
              child: RichText(
                text: TextSpan(children: [widget.widgets]),
              )
            ),
            Offstage(
              offstage: !widget.isSwitch,
              child: Container(
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
              ),
            )

          ],
        ),
      ),
    );
  }
}
