import 'package:flutter/material.dart';
import 'package:lop/style/font.dart';
class DDCardDecoration extends StatefulWidget {
  final Widget childWidget;
  final String title;
  DDCardDecoration({@required this.childWidget,this.title=''});
  @override
  _DDCardDecorationState createState() => _DDCardDecorationState();
}

class _DDCardDecorationState extends State<DDCardDecoration> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //阴影
        margin:EdgeInsets.fromLTRB(15, 0, 15,15),
        decoration: BoxDecoration(
          boxShadow:[
            BoxShadow(
                color:Color.fromRGBO(0, 0, 0, 0.35),// Colors.black.opacity,
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0 /*,spreadRadius:2.0*/)
          ],
        ),
        child:ClipRRect(
          //圆角
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            child:Container(
              //数据内容白色北京
                color: Colors.white,
                child: Column(children: <Widget>[
                  //编号
                  Container(
                    width:double.infinity,
                    height: 40,
                    color: Colors.blue,
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child:Text(
                      widget.title,style: TextStyle(fontSize: KFont.formTitle,color: Colors.white),
                    ),
                    ),

                  ),
                  widget.childWidget,
                  SizedBox(height: 15,),
                ],)

            ), //Text('data'),
          ),
        )
    );
  }
}
