
import 'package:flutter/material.dart';
import '../layout_helper.dart';

abstract class IndentRichWidget extends StatefulWidget {
  ///初始值为父控件时给定宽度,此处也是固定宽,高为 0, 后续计算布局时再赋值高度
  final NonFinalSize size;
  IndentRichWidget({this.size});
}
