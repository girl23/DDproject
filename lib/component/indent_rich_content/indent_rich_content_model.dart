import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

double fontSize = 20;

class IndentRichContentModel {
  final dynamic id;
  final int level;
  final Widget content;
  final List<IndentRichContentModel> children;

  Rect layoutRect = Rect.zero;
  bool didCacheLayout = false;
  //一个表格项的给定宽度
  double tdContentWidth;

  IndentRichContentModel({
    @required this.content,
    @required this.id,
    @required this.level,
    @required this.children
});

  @override
  String toString() {
    return 'id:$id, level:$level, content:$content';
  }
}