import 'package:flutter/material.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/color.dart';
import 'package:lop/utils/translations.dart';
typedef ItemClickCallback = void Function();
////列表项
class DDListItem extends StatefulWidget {
  final String createDate;
  final ItemClickCallback itemClick;
  final String temporaryDDNumber;
  final String planeNumber;
  final String temporaryDDState;
  DDListItem({this.temporaryDDNumber, this.planeNumber, this.temporaryDDState,this.itemClick,this.createDate});
  @override
  _DDListItemState createState() => _DDListItemState();
}

class _DDListItemState extends State<DDListItem> {




  Color fontColor(){
    if(widget.temporaryDDState=='un_close'||widget.temporaryDDState=='to_Audit'||widget.temporaryDDState=='forTroubleShooting'||widget.temporaryDDState=='for_inspection'){
      return Colors.blue;
    }else{
      return KColor.textColor_66;
    }

  }
  @override
  Widget build(BuildContext context) {

    var day1  = DateTime.parse(widget.createDate);
    var day2 = DateTime.now();
    var second=day2.difference(day1).inSeconds;

    return
//      Container(color: Colors.red,height: 30,padding: EdgeInsets.all(5),);
      Container(
        //cell间隙
         padding: EdgeInsets.fromLTRB(10, 0, 10, 5),

          child:Container(
            //cell蓝色条
            decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow:[
                BoxShadow(
                    color:Color.fromRGBO(0, 0, 0, 0.35),// Colors.black.opacity,
                    offset: Offset(5.0, 5.0),
                    blurRadius: 10.0 /*,spreadRadius:2.0*/)
              ],
            ),
          padding: EdgeInsets.only(left: 5),
          child: Container(
            //cell到期颜色控制，及内容间隙
            color:(second>24*3600)?Color(0xFFFACD91): Colors.white,
            padding: EdgeInsets.only(left: 10,top: 0,right: 10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                    color:Colors.transparent,
                    child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (){
                          //列表项别点击了
                          widget.itemClick();
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.planeNumber,
                                        style:TextStyle(fontSize: KFont.fontSizeItem_1,color:KColor.textColor_33 ),
                                      ),
                                      Text(
                                        widget.temporaryDDNumber,
                                        style:TextStyle(fontSize: KFont.fontSizeItem_2,color:KColor.textColor_66),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                     Translations.of(context).text(widget.temporaryDDState),
                                     // widget.temporaryDDState,
                                      style: TextStyle(fontSize: KFont.fontSizeItem_2,color:fontColor() ),
                                    ),
                                    Icon(Icons.arrow_forward_ios,size: 14,color:Colors.grey,),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
//
                          ],
                        )
                    )
                )
            ),

          ),)
        );
  }
}

