import 'package:flutter/material.dart';
import 'paint_circle.dart';
import 'dart:math';
import 'package:lop/config/enum_config.dart';
class CircleProgress extends StatelessWidget {
  final List <Color>colors;
  final List <double>percent;
  final Size canvasSize;
  final bool filled;
  final double strokeWidth;
// final double startAngle;
 final double radius;
  JobCardLanguage cardLanguage;
  CircleProgress(this.colors,this.percent,this.canvasSize,{this.cardLanguage=JobCardLanguage.cn, this.filled=false, this.strokeWidth=10.0,this.radius=80});
  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.redAccent,
      child:  CustomPaint(
        size: this.canvasSize,
        painter:
//          CharacterPainter(colors,percent,strokeWidth:this.strokeWidth),
        CirclePainter(colors, percent,canvasSize,center: Offset(this.canvasSize.width/2.0, this.canvasSize.height/2.0),filled: this.filled,strokeWidth: this.strokeWidth,startAngle: pi/2,radius:this.radius,cardLanguage: this.cardLanguage),
      ),
    );
  }
}
