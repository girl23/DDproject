import 'package:flutter/material.dart';
import 'package:lop/model/jobcard/jc_table_model.dart';

class XmlTableCellLayoutModel extends Object{

  final Object id;
  final int column;
  final int row;
  final int columnSpan;
  final int rowSpan;
  final double tdWidth;
  final TableDataModel tdModel;
  //最小高度
  final double minHeight;

  RenderBox cellRenderBox;
  double preCalculatedHeight = 0;
  Rect layoutRect = Rect.zero;

  bool isTopFirst = false;
  bool isLeftFirst = false;

  bool leftHasBorder = false;
  bool topHasBorder = false;
  bool rightHasBorder = false;
  bool bottomHasBorder = false;
  double borderWidth = 1;

  XmlTableCellLayoutModel(
      { @required this.id,
        @required this.column,
        @required this.row,
        @required this.tdModel,
        this.columnSpan = 1,
        this.rowSpan = 1,
        this.tdWidth = 100,
        this.minHeight = 0
      });

  @override
  String toString() {
    // TODO: implement toString
    return 'cell model: {col:$column, row:$row, colspan:$columnSpan, rowspan:$rowSpan, rect: ${layoutRect.toString()}';
  }
}