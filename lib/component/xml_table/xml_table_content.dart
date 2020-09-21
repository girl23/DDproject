import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lop/model/jobcard/jc_table_model.dart';

class XMLTableContent extends StatefulWidget {
  final TableDataModel tdModel;
  final double contentWidth;

  XMLTableContent(this.tdModel, this.contentWidth);

  @override
  _XMLTableContentState createState() => _XMLTableContentState();
}

class _XMLTableContentState extends State<XMLTableContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _XMLTableContentWidget(this),
    );
  }
}

class _XMLTableContentWidget extends MultiChildRenderObjectWidget {

  final _XMLTableContentState state;
  _XMLTableContentWidget(this.state);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _XMLTableContentRenderBox(state);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
  }
}

class _XMLTableContentRenderBox extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, _XMLTableContentParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, _XMLTableContentParentData>{

  _XMLTableContentState state;
  TextPainter tp;

  _XMLTableContentRenderBox(this.state);

  @override
  void performLayout() {
    TextSpan ts = TextSpan(text: '客户端数据库恢复敬爱的是否及时对接和非金属设计费结合实际发货时间环境', style: TextStyle(fontSize: 15, color: Colors.black
    ));
    tp = TextPainter(text: ts,textDirection: TextDirection.ltr,textAlign: TextAlign.center);
    tp.layout(maxWidth: state.widget.contentWidth);
    size = Size(constraints.smallest.width, tp.size.height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
    tp.paint(context.canvas,Offset(offset.dx - tp.size.width/2, offset.dy));
  }

}

class _XMLTableContentParentData extends ContainerBoxParentData<RenderBox>{

}


