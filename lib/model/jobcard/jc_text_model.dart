import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'jc_model.dart';

class TextModel extends JcModel {
  String tag = 'text';
  int style = 0; //默认是普通
  String text;
  Color color;
  Color bgColor; //背景色

  bool isBold = false;
  bool isItalics = false;
  bool hasUnderline = false;
  bool isSuber = false; //是否是下标
  bool isSuper = false; //是不是上标
  String fontName; //对于Wingdings的处理
  String href=""; //引用时的路径
  String revise=""; //改版
  int rotateDegree = 0; //旋转，默认不旋转为0
  String isLineStartType; //预留字段1
  String lineStartSign; //预留字段2

  TextModel parseAttributes(List<XmlAttribute> attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      for (XmlAttribute attribute in attributes) {
        String name = attribute.name.toString();
        String value = attribute.value;
        _setValue(name, value);
      }
    }
    return this;
  }

  void _setValue(String key, String value) {
    switch (key) {
      case 'style':
        _translateStyle(int.parse(value));
        break;
      case 'color':
        color = _strToColor(value);
        break;
      case 'bgcolor':
        bgColor = _strToColor(value);
        break;
      case 'issuber': //下标
        isSuber = (value == 'True') ? true : false;
        break;
      case 'issuper': //上标
        isSuper = (value == 'True') ? true : false;
        break;
      case 'fontname': //Wingdings
        fontName = value;
        break;
      case 'href':
        href = value;
        break;
      case 'revise':
        revise = value;
        break;
      case 'rotatedegree':
        rotateDegree = int.parse(value);
        break;
      case 'islinestarttype':
        isLineStartType = value;
        break;
      case 'linestartsign':
        lineStartSign = value;
        break;
    }
  }

  void _translateStyle(int style) {
    this.style = style;
    switch (style) {
      case 0: //正常
        _setStyle(false, false, false);
        break;
      case 1: //粗体
        _setStyle(true, false, false);
        break;
      case 2: //斜体
        _setStyle(false, true, false);
        break;
      case 3: //粗体+斜体
        _setStyle(true, true, false);
        break;
      case 4: //下划线
        _setStyle(false, false, true);
        break;
      case 5: //粗体+下划线
        _setStyle(true, false, true);
        break;
      case 6: //斜体+下划线
        _setStyle(false, true, true);
        break;
      case 7: //粗体+斜体+下划线
        _setStyle(true, true, true);
        break;
    }
  }

  void _setStyle(bool isBold, bool isItalics, bool hasUnderline) {
    this.isBold = isBold;
    this.isItalics = isItalics;
    this.hasUnderline = hasUnderline;
  }

  bool get isBreak => '\r\n'==text;

  Color _strToColor(String str) {
    if (str == null) {
      return Colors.black;
    }
    int colorValue;
    if (str.startsWith('0x')) {
      colorValue = int.parse(str);
    } else {
      if (str.length == 6) {
        colorValue = int.parse('0xFF' + str);
      } else {
        colorValue = int.parse('0x' + str);
      }
    }
    return Color(colorValue);
  }

  @override
  String toString() {
    return "<text style='$style'" +
        (color != null ? " colorStr='${color.toString()}'" : "") +
        ">" +
        (text != null ? "$text" : "") +
        "</text>";
  }
}
