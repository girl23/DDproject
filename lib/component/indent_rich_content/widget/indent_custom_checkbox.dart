import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///自定义控件的绘制方式
class IndentCustomCheckBoxWidget extends MultiChildRenderObjectWidget{

  IndentCustomCheckBoxWidget(
      {
        Key key,
        @required List<IndentCheckBoxItem> children
      }):super(key:key, children:children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _IndentCustomCheckBoxRenderBox();
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class _IndentCustomCheckBoxRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _IndentCustomCheckBoxParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _IndentCustomCheckBoxParentData>{

  @override
  void performLayout() {

    if(childCount == 0){
      size = constraints.smallest;
      return;
    }

    RenderBox child = firstChild;
    double offsetY = 0;
    while(child != null){

      _IndentCustomCheckBoxParentData childParentData = child.parentData;
      child.layout(constraints,parentUsesSize: true);
      Size childSize = child.size;
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;
      childParentData.offset = Offset(0,offsetY);
      offsetY += childSize.height;

      child = childParentData.nextSibling;
    }

    size = constraints.tighten(height: offsetY).smallest;
  }

  @override
  void setupParentData(RenderObject child) {
    if(child.parentData is! _IndentCustomCheckBoxParentData){
      child.parentData = _IndentCustomCheckBoxParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

///额外的记录一些数据时使用
class _IndentCustomCheckBoxParentData extends ContainerBoxParentData<RenderBox>{
  double width;
  double height;

  Rect get content => Rect.fromLTWH(offset.dx, offset.dy, width, height);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class IndentCheckBoxItem extends StatelessWidget {

  final String text;
  IndentCheckBoxItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
            child: Checkbox(
              value: false,
              onChanged: (v){

              },
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(text, style: TextStyle(fontSize: 20, color: Colors.black),),
          )
        ],
      ),
    );
  }
}

