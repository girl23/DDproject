import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CYLCustomSlider extends StatefulWidget {

  final Size size;
  final List<double> values;
  final double min;
  final double max;
  final double dotRadius;
  final bool canIndicatorDrag;
  final double initialValue;
  final void Function(double) onChange;
  final Color indicatorColor;
  final List<Text> labels;
  CYLCustomSlider(this.size, this.values,this.initialValue,
      { this.min = 0,
        this.max = 100,
        this.dotRadius = 80,
        this.canIndicatorDrag = false,
        this.onChange,
        this.indicatorColor = Colors.deepOrange,
        this.labels
      });

  @override
  _CYLCustomSliderState createState() => _CYLCustomSliderState();
}


const Duration animationDuration = Duration(seconds: 2);

class _CYLCustomSliderState extends State<CYLCustomSlider> with SingleTickerProviderStateMixin{

  AnimationController indicatorMoveToAnimationController;
  List<double> mappedValues = [];
  double mappedInitialValue = 0;

  @override
  void initState() {
    super.initState();
    indicatorMoveToAnimationController = AnimationController(duration: animationDuration,vsync: this);
    int divideCount = widget.values.length - 1;
    double divideLength = widget.max / divideCount;
    int index = 0;
    mappedValues = widget.values.map((rawValue){
      double modifiedValue = divideLength * index;
      index += 1;
      if(rawValue == widget.initialValue) mappedInitialValue = modifiedValue;
      return modifiedValue;
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    indicatorMoveToAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
//        margin: EdgeInsets.only(left: ScreenUtil().setWidth(60), right:ScreenUtil().setWidth(60)),
        color: Colors.white,
        width: widget.size.width,
        height: widget.size.height,
        child: _CYLCustomSliderWidget(this),
      ),
    );
  }
}

class _CYLCustomSliderWidget extends LeafRenderObjectWidget {

  final _CYLCustomSliderState state;
  _CYLCustomSliderWidget(this.state);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCustomSlider(state);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
  }
}

class _RenderCustomSlider extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, _CustomSliderParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, _CustomSliderParentData>{

  final _CYLCustomSliderState _state;
  double lineWidth;
  HorizontalDragGestureRecognizer _drag;
  TapGestureRecognizer _tap;
  Animation _indicatorMoveAnimation;
  ///响应点击的区域
  Rect _trackRect;
  Rect dotRect;
  Paint dotPaint;
  Paint linePaint;

  Offset tapPoint;
  bool isFirstPaint = true;
  bool isDragging = false;
  Offset dragFinalPoint = Offset.zero;
  Offset dragStartPoint = Offset.zero;
  double lineEndPaddingLength = ScreenUtil().setWidth(60);

  _RenderCustomSlider(this._state){
    dotPaint = Paint()..color = _state.widget.indicatorColor..style = PaintingStyle.fill..strokeCap = StrokeCap.round;
    linePaint = Paint()..color = Colors.black54..strokeWidth = 2..strokeCap = StrokeCap.round;

    GestureArenaTeam team = GestureArenaTeam();
    if(_state.widget.canIndicatorDrag){
      _drag = HorizontalDragGestureRecognizer()
        ..team = team
        ..onStart = _handleDragStart
        ..onUpdate = _handleDragUpdate
        ..onEnd = _handleDragEnd
        ..onCancel = _endInteraction;
    }

    _tap = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _handleTapDown
      ..onTapUp = _handleTapUp
      ..onTapCancel = _endInteraction;

    _indicatorMoveAnimation = CurvedAnimation(parent: _state.indicatorMoveToAnimationController, curve: Curves.easeInOut);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _indicatorMoveAnimation.addListener(markNeedsPaint);
    _indicatorMoveAnimation.addStatusListener((status){
      print(status.toString());
    });
  }

  @override
  void detach() {
    super.detach();
    _indicatorMoveAnimation.removeListener(markNeedsPaint);
  }


  @override
  bool get sizedByParent => true;

@override
  void performResize() {
  size = Size(
    constraints.maxWidth,
    constraints.maxHeight,
  );
}

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
    ///draw slider bar
    Offset lineStart = Offset(offset.dx + lineEndPaddingLength, offset.dy + size.height / 2);
    Offset lineEnd = Offset(offset.dx + size.width - lineEndPaddingLength, offset.dy + size.height / 2);
    lineWidth = lineEnd.dx - lineStart.dx;
    _trackRect = Rect.fromLTWH(lineStart.dx - lineEndPaddingLength, lineStart.dy - _state.widget.dotRadius/4, lineWidth + 2 * lineEndPaddingLength, _state.widget.dotRadius/2);
    context.canvas.drawLine(lineStart, lineEnd, linePaint);

    /// draw dot and label
    double dotHeight = ScreenUtil().setHeight(10);
    Offset center = Offset.zero;
    int index = 0;
    for(double value in _state.mappedValues){
      double widthPercent = value / _state.widget.max;
      Offset startP = Offset(lineStart.dx + lineWidth * widthPercent, lineStart.dy + dotHeight);
      Offset endP = Offset(startP.dx, startP.dy - dotHeight*2);
      context.canvas.drawLine(startP, endP, linePaint);

      Text label = _state.widget.labels[index];
      TextSpan ts = TextSpan(text: label.data,style: label.style);
      TextPainter tp = TextPainter(text: ts,textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(context.canvas, Offset(endP.dx - tp.size.width/2, endP.dy - ScreenUtil().setWidth(_state.widget.dotRadius) - tp.height/4));


      //TODO 根据选中选定中心
      if(value == _state.mappedInitialValue){
        center = Offset(startP.dx, startP.dy-dotHeight);
      }

      index += 1;
    }

    if(isFirstPaint){
      isFirstPaint = false;
      tapPoint = center;
    }

    ///draw indicator
    double dotR = ScreenUtil().setWidth(_state.widget.dotRadius);
    Path circlePath;
    circlePath = Path()..addArc(Rect.fromCenter(center: Offset(tapPoint.dx, center.dy),height: dotR, width: dotR), 0, 2*pi);
    context.canvas.drawShadow(circlePath, Colors.black, 3, true);
    context.canvas.drawPath(circlePath, dotPaint);
  }

  @override
  bool hitTestSelf(Offset position) => true;

@override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    print(position.toString());
    return super.hitTest(result, position:position);
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent) {
      if(_trackRect.contains(event.position)){
        if(_state.widget.canIndicatorDrag) _drag.addPointer(event);
        _tap.addPointer(event);
      }
    }
  }

  void _handleDragStart(DragStartDetails details) => _startInteraction(details.globalPosition,details.localPosition);
  void _handleDragUpdate(DragUpdateDetails details) {
    if(_trackRect.contains(details.globalPosition)){
      if(isDragging == false) isDragging = true;
      tapPoint = details.globalPosition;
      dragFinalPoint = tapPoint;
      markNeedsPaint();
    }
  }
  void _handleDragEnd(DragEndDetails details) => _endInteraction();
  void _handleTapDown(TapDownDetails details) => _startInteraction(details.globalPosition, details.localPosition);

  void _handleTapUp(TapUpDetails details) => _endInteraction();

  void _endInteraction(){
    if(isDragging) {
      isDragging = false;
      ///没拖动到位,则回到原始点
      if(!isValidateOffset(dragFinalPoint)){
        tapPoint = dragStartPoint;
      }
      markNeedsPaint();
    }
  }

  void _startInteraction(Offset globalPosition, Offset localPosition) {
    if(isValidateOffset(globalPosition)){
      dragStartPoint = globalPosition;
      markNeedsPaint();
    }
  }

  bool isValidateOffset(Offset globalPosition){
    double dotR = ScreenUtil().setWidth(_state.widget.dotRadius) * 2;
    Offset localPosition = globalToLocal(globalPosition);
    double delta = localPosition.dx - globalPosition.dx;

    List<Rect> validateRects = _state.mappedValues.map((rawValue){
      double percent = rawValue / _state.widget.max;
      double dx =  lineWidth * percent;
      Rect validateRect = Rect.fromLTWH(dx - dotR/2 - delta + lineEndPaddingLength, globalPosition.dy - dotR/2, dotR, dotR);
      return validateRect;
    }).toList();


    bool isValidate = false;
    for(int i = 0; i < validateRects.length; i++){
      Rect rect = validateRects[i];
      if(rect.contains(globalPosition)) {
        isValidate = true;
        tapPoint = Offset(rect.left + dotR/2, rect.center.dy);
        if(_state.widget.onChange != null) _state.widget.onChange(_state.widget.values[i]);
      }
    }

    return isValidate;
  }
}

class _CustomSliderParentData extends ContainerBoxParentData<RenderBox>{

}
