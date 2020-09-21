import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/utils/device_info_util.dart';
import 'zlpopwindow.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/size.dart';
import 'dart:ui';
import 'package:lop/utils/width_height_util.dart';
import 'zlbubblewidget.dart';
import 'package:lop/utils/device_info_util.dart';
//注意 typedef 需要放在class外面
typedef IndexCallback<int> = void Function(int index);
class ZlPopMenuButton extends StatefulWidget {
  IndexCallback<int> onTap;
  //列表数据
  List items;

  // 尖角位置
  final position;

  // 尖角高度
  var arrHeight;

  // 尖角角度
  var arrAngle;

  // 圆角半径
  var radius;

  // 颜色
  Color color;

  // 边框颜色
  Color borderColor;

  // 边框宽度
  final strokeWidth;

  // 填充样式
  final style;

  // 子 Widget
  final child;

  // 子 Widget 与起泡间距
  var innerPadding;
  //文本样式
  TextStyle txtStyle;

  double cellHeight;
  //按钮视图
  Widget buttonWidget;

  ZlPopMenuButton(

      this.items,
      this.cellHeight,
      this.color,

      this.position, {
        Key key,
        @required this.onTap,
        this.arrHeight = 12.0,
        this.arrAngle = 60.0,
        this.radius = 10.0,
        this.strokeWidth = 4.0,
        this.style = PaintingStyle.fill,
        this.borderColor,
        this.child,
        this.innerPadding = 6.0,
        this.txtStyle,
        @required this.buttonWidget,
      }) : super(key: key);
  @override
  _ZlPopMenuButtonState createState() => _ZlPopMenuButtonState();
}

class _ZlPopMenuButtonState extends State<ZlPopMenuButton> {

  double realWidth=0;

  List<double> _widthList=new List();
  double _getRealWidth(){
    _widthList.clear();
    for(int i=0;i<widget.items.length;i++){

       _widthList.add(WidthAndHeightUtil().getTextWidth(widget.items[i],widget.txtStyle));
    }
//    print(_widthList);
    for(var j=0;j<_widthList.length;j++){
          if(_widthList[j]>realWidth){
            realWidth=_widthList[j];
          }
        }
    return realWidth;
  }

  @override
  Widget build(BuildContext context) {
//    print('oooooo====${DeviceInfoUtil.appBarHeight}');
    _getRealWidth();
    double appBarHeight = MediaQueryData.fromWindow(window).padding.top+DeviceInfoUtil.appBarHeight;
    double dropMenuHeight=widget.items.length>0?widget.items.length*widget.cellHeight+widget.arrHeight+22:0;//+60:0;
//    print('dropmenuheight${dropMenuHeight}');
    return new  PopupWindowButton(
        color: Colors.transparent,
//        color: Colors.green,

//        offset: Offset(0,ScreenUtil().setWidth(appBarHeight)+MediaQueryData.fromWindow(window).padding.top),

        offset: Offset(0, DeviceInfoUtil.appBarHeight+MediaQueryData.fromWindow(window).padding.top),
        child: widget.buttonWidget,
        elevation: 0.0,
        window: Container(
//        color: Colors.red,
          width: realWidth+30,
          height: dropMenuHeight+45,
          margin: EdgeInsets.only(right: 15),
          child: BubbleWidget(realWidth+30,dropMenuHeight,widget.color,
            widget.position,
            child:ListView.separated(
              physics: const NeverScrollableScrollPhysics(),//禁止滚动
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  Material(
                    color: Colors.transparent,
                    child:Ink(
                      child: InkWell(

                        onTap: (){
                          Navigator.of(context).pop();
                          widget.onTap(index);
                        },
                        child: Container(
                            height: widget.cellHeight,
//                            color: Colors.yellow,
                            alignment: Alignment.centerLeft,
                            child:new Center(
                              child: Text(
                                widget.items[index].toString(),
                                style: widget.txtStyle,
                              ),
                            )
                        ),
                      ),
                    ),
                  );
              },
              separatorBuilder: (BuildContext context,int index){
                return Divider(color: KColor.dividerColor,height: KSize.dividerSize,);
              },
            ),
            arrHeight:widget.arrHeight,
            arrAngle: widget.arrAngle,
            radius: widget.radius,
            innerPadding: widget.innerPadding,
            strokeWidth: widget.strokeWidth,
            borderColor: widget.borderColor,
            style: widget.style,
          ),

//          new DropMenu(realWidth+30,dropMenuHeight, widget.color,widget.position,//MenuArrowDirection.top,
//            child:
//            ListView.separated(
//              physics: const NeverScrollableScrollPhysics(),//禁止滚动
//              itemCount: widget.items.length,
//              itemBuilder: (BuildContext context, int index) {
//                return
//                  Material(
//                    color: Colors.transparent,
//                  child:Ink(
//                    child: InkWell(
//
//                        onTap: (){
//                          Navigator.of(context).pop();
//                          widget.onTap(index);
//                        },
//                        child: Container(
//                        height: widget.cellHeight,
//                        color: Colors.yellow,
//                        alignment: Alignment.centerLeft,
//                        child:new Center(
//                          child: Text(
//                              widget.items[index].toString(),
//                              style: widget.txtStyle,
//                          ),
//                    )
//                    ),
//                  ),
//                  ),
//                );
//              },
//              separatorBuilder: (BuildContext context,int index){
//                return Divider(color: KColor.dividerColor,height: KSize.dividerSize,);
//              },
//            ),
//          ),
        )
    );


  }
}

