import 'package:flutter/material.dart';
class WidthAndHeightUtil{
  double getTextWidth(text,textStyle){
    TextSpan span = new TextSpan(style: textStyle, text: text);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    return tp.size.width;
  }
}