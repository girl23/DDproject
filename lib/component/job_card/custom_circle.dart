import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:path/path.dart';

class CustomCircle extends StatefulWidget {
  final canvasSize;
  final data;
  const CustomCircle({Key key, this.canvasSize,this.data}) : super(key: key);
  @override
  _CustomCircleState createState() => _CustomCircleState();
}

class _CustomCircleState extends State<CustomCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: widget.canvasSize,
        painter: _CustomPainter(widget.canvasSize.width,widget.data,mTextHeight: 14.0),
      ),
    );
  }
}
class _CustomPainter extends CustomPainter{

  // 圆环画笔
  Paint mRingPaint;
  // 线段和文字画笔
  Paint mLinePaint;
  // 实心圆画笔
  Paint mCirclePaint;

  // 圆环半径
  double mRingRadius;
  // 圆环宽度
  double mRingWidth;
  // 实心园半径
  double mCircleRadius = 5.0;
  // 字的高度
  double mTextHeight;
  //默认文字大小
  double mTextSize;
  // 线段长度
  double mLineLength;
  // 圆心x坐标
  double mXCenter;
  // 圆心y坐标
  double mYCenter;
  List<Data> mData;// 数据集合
  int mSum;// 总数

  double mCanvasWidth;


  _CustomPainter(this.mCanvasWidth,this.mData,{this.mTextHeight = 14.0}){
    this.mRingRadius = (this.mCanvasWidth / 6);
    this.mRingWidth = this.mRingRadius / 4;
    this.mLineLength = this.mRingRadius / 4;
    this.mTextSize = 12.0;



    //圆环画笔
    this.mRingPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = this.mRingWidth;

    //线段
    this.mLinePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0;

    //实心圆
    this.mCirclePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = this.mCircleRadius;

    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontSize: this.mTextSize,
    ));
    pb.pushStyle(ui.TextStyle(color:Colors.greenAccent));
    pb.addText('${this.mData[0].title}');

    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: 100);
    //这里需要先layout, 后面才能获取到文字高度
    ui.Paragraph paragraph = pb.build()..layout(pc);
    this.mTextHeight = paragraph.height;
    print("mRingRadius:${this.mRingRadius} mRingWidth:${this.mRingWidth} mLineLength:${this.mLineLength} mTextHeight:${this.mTextHeight}");
    this.mSum = 0;
    for (Data data in this.mData) {
      mSum += data.value;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(this.mData == null || this.mData.isEmpty)
      return;
    this.mXCenter = size.width / 2.0;
    this.mYCenter = this.mRingRadius + this.mLineLength +this.mTextHeight;
    Rect rect = Rect.fromLTRB(this.mXCenter - this.mRingRadius, this.mYCenter - this.mRingRadius, this.mRingRadius * 2 + (this.mXCenter - this.mRingRadius), this.mRingRadius * 2 + (this.mYCenter - this.mRingRadius));
    double start = pi/2 ;
    for(var data in this.mData){
      this.mRingPaint.color = data.color;
      double ring = data.value / this.mSum * pi * 2;
      canvas.drawArc(rect, start, ring, false, this.mRingPaint);
      // 画线段
      Path path = new Path();
      this.mLinePaint.color = data.color;
      // 画第一个线段
      double x = this.mXCenter + sin(pi / 180.0 * (start * 180.0 / pi + 90.0 + ring * 90.0 / pi)) * this.mRingRadius;
      double y = this.mYCenter - cos(pi / 180.0 * (start * 180.0 / pi + 90.0 + ring * 90.0 / pi)) * this.mRingRadius;
      path.moveTo(x, y);
      x = this.mXCenter + sin(pi / 180.0 * (start * 180.0 / pi + 90.0 + ring * 90.0 / pi)) * (this.mRingRadius + this.mLineLength);
      y = this.mYCenter - cos(pi / 180.0 * (start * 180.0 / pi + 90.0 + ring * 90.0 / pi)) * (this.mRingRadius + this.mLineLength);
      path.lineTo(x, y);
      // 画第二条线段
      if ((x - this.mXCenter).abs() < 4) {
        x = x + this.mLineLength;
        path.lineTo(x, y);
      } else {
        x = x - this.mLineLength;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, this.mLinePaint);
      // 画圆点
      this.mCirclePaint.color = data.color;
      canvas.drawCircle(Offset(x, y), this.mCircleRadius, this.mCirclePaint);
      start += ring;
      // 画文字
      ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        fontSize: this.mTextSize,
      ));
      pb.pushStyle(ui.TextStyle(color: data.color));
      pb.addText('${data.title}');
      ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: 100);
      //这里需要先layout, 后面才能获取到文字高度
      ui.Paragraph paragraph = pb.build()..layout(pc);
      if (x >= mXCenter) {
        Offset offset = Offset(x + this.mCircleRadius, y - this.mTextHeight/2);
        canvas.drawParagraph(paragraph, offset);
      } else {
        Offset offset = Offset(x - paragraph.width - this.mCircleRadius, y - this.mTextHeight/2);
        canvas.drawParagraph(paragraph, offset);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
class Data {
  String title;// 标题
  int value;// 值
  Color color;// 颜色
  Data(this.title, this.value, this.color);
}