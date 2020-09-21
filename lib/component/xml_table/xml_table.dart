import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'xml_table_cell.dart';
import 'xml_table_cell_model.dart';
export 'xml_table_cell_model.dart';


class XmlTable extends MultiChildRenderObjectWidget{

  final double fixWidth;
  final int totalCol;
  final int totalRow;
  final List<XmlTableCellLayoutModel> cellModels;

  XmlTable({
    @required List<XmlTableCell> children,
    @required this.cellModels,
    @required this.fixWidth,
    this.totalCol,
    this.totalRow
}):super(children:children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _XmlTableRenderBox(cellModels,fixWidth,totalRow,totalCol);
  }

  @override
  void updateRenderObject(BuildContext context, _XmlTableRenderBox renderObject) {
    print('update renderobject');
  }

}

class _XmlTableRenderBox extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, _XmlTableParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, _XmlTableParentData>{

  final List<XmlTableCellLayoutModel> cellModels;
  final double fixWidth;
  final int totalCol;
  final int totalRow;
  ///记录表格 model 的矩阵
  List<List<XmlTableCellLayoutModel>> layoutHelpMatrix;
  ///每行最大高度的记录
  List<double> rowHeightRecord = [];

  ///记录导致 rowSpan 的model, 在需要的时候重新布局导致 rowSpan的 cell 的高度(如: <col:1,row:1,rowSpan:2> cell 会在第 row+rowSpan 行进行重新调整高度)
  Map<int,List<XmlTableCellLayoutModel>> rowSpanModelWaitToAdjust = {};

  _XmlTableRenderBox(this.cellModels,this.fixWidth,this.totalRow, this.totalCol){
    prepareMatrix();
  }

  void prepareMatrix(){
    layoutHelpMatrix = List(totalRow).map((_)=> List<XmlTableCellLayoutModel>()).toList();
  }

  XmlTableCellLayoutModel getTopModel(int curRow, XmlTableCellLayoutModel curModel,{bool preTop = false}){
    XmlTableCellLayoutModel topModel;
    if(curRow != 0){
      List<XmlTableCellLayoutModel> topRow = layoutHelpMatrix[curRow - 1];
      int delta = curModel.column;
      for(int i = 0; i < topRow.length; i++){
        XmlTableCellLayoutModel cellModel = topRow[i];
        delta -= cellModel.columnSpan;
        if(!preTop){
          //返回头顶上的那个 model
          if(delta < 0){
            topModel = cellModel;
            break;
          }
        }else{
          //返回头顶上那个 model 的前一个 model
          if(delta == 0){
            topModel = cellModel;
            break;
          }
        }
      }
    }

    return topModel;
  }

  @override
  void performLayout() {

    DateTime now = DateTime.now();

    RenderBox child = firstChild;
    int index = 0;
    XmlTableCellLayoutModel model = cellModels[index];
    double offsetY = 0;
    double maxHeight = 0;
    bool isMaxHeightChange = false;
    double dx = 0;
    int curRow = -1;
    RenderBox lastChild;
    rowHeightRecord.clear();

    while(child != null && model != null){

      _XmlTableParentData childParentData = child.parentData;
      childParentData.model = model;
      childParentData.model.cellRenderBox = child;

      //记录跨行 cell model
      if(model.rowSpan != 1) {
        int key = model.row + model.rowSpan;
        if(!rowSpanModelWaitToAdjust.containsKey(key)){
          List<XmlTableCellLayoutModel> list = [model];
          rowSpanModelWaitToAdjust[key] = list;
        }else{
          rowSpanModelWaitToAdjust[key].add(model);
        }
      }

      if(model.row == curRow){
        ///仍在此行
        lastChild = childParentData.previousSibling;
      }else{
        ///换行:新的一行开始,要对上一行的布局进行一些校验与更改
        curRow = model.row;
        offsetY += maxHeight;

        //上一行的 td高度大小不一 最大高度有改变,需要重新布局
        if(isMaxHeightChange){
          adjustLastRowHeight(curRow,maxHeight);
          isMaxHeightChange = false;
        }

        //记录上一行最大高度
        if(curRow != 0) rowHeightRecord.add(maxHeight);

        //若是有 rowSpan 的 cell,在此重新布局高度
        if(rowSpanModelWaitToAdjust.containsKey(curRow)){
          adjustRowSpanTdAt(curRow);
        }

        maxHeight = 0;
        //换行时第一个 child认为没有前一个 sibling
        lastChild = null;
      }

//      if(curRow < layoutHelpMatrix.length){
        layoutHelpMatrix[curRow].add(model);
//      }

      //根据 model 内容 布局 cell
      BoxConstraints childConstraints = BoxConstraints(minWidth: model.tdWidth, maxWidth: model.tdWidth, minHeight: max(maxHeight, model.minHeight), maxHeight: double.infinity);

      ///跨行影响此 cell 的 offset
      ///跨列影响此 cell 的 size
      if(lastChild == null){
        //换行的第一个 td
        if(model.column != 0){
          //跨行
          XmlTableCellLayoutModel rowSpanModel = getTopModel(curRow, model, preTop: true);
          //跨多行时 需要继续向上走
          rowSpanModel = adjustRowSpanModel(rowSpanModel,curRow,model);
          dx = rowSpanModel.layoutRect.left + rowSpanModel.layoutRect.width;
        }else{
          //普通的第一个td
          dx = 0;
        }
      }else{
        //此行的非第一个 td
        _XmlTableParentData lastChildParentData = lastChild.parentData;
        int lastPlaceCol = lastChildParentData.model.column + lastChildParentData.model.columnSpan;
        bool isColSpan = false;
        bool isRowSpan = false;
        if(lastChildParentData.model.columnSpan > 1){
          //跨列
          isColSpan = true;
        }else if(lastPlaceCol != model.column){
          //跨行
          isRowSpan = true;
        }

        if(isColSpan){
          dx = lastChildParentData.model.layoutRect.left + lastChildParentData.model.layoutRect.width;
        }

        if(isRowSpan){
          XmlTableCellLayoutModel rowSpanModel = getTopModel(curRow, model, preTop: true);
          //跨多行时 需要继续向上走
          rowSpanModel = adjustRowSpanModel(rowSpanModel,curRow,model);
          dx = rowSpanModel.layoutRect.left + rowSpanModel.layoutRect.width;
        }

        if(!isColSpan && !isRowSpan){
          //没有被跨行跨列
          dx = lastChildParentData.model.layoutRect.left + lastChildParentData.model.layoutRect.width;
        }
      }

      //布局
      child.layout(childConstraints,parentUsesSize: true);
      childParentData.offset = Offset(dx, offsetY);
      if(lastChild == null){
        //记录每行第一个td的高度为基值
        maxHeight = child.size.height;
      }

      //记录本行的最大高度值,值有变化时.下一行layout前,重新 layout 这一行
      if(maxHeight < child.size.height) {
        maxHeight = child.size.height;
        isMaxHeightChange = true;
      }

      child = childParentData.nextSibling;
      model.layoutRect = Rect.fromLTWH(dx, offsetY, childConstraints.smallest.width, childConstraints.smallest.height);
      index += 1;
      model = index >= cellModels.length ? null : cellModels[index];
    }

    //对最后一行进行处理 记录高度/布局跨行到追后一行的情况
    rowHeightRecord.add(maxHeight);
    if(isMaxHeightChange){
      adjustLastRowHeight(curRow+1, maxHeight);
    }

    if(rowSpanModelWaitToAdjust.containsKey(curRow+1)){
      adjustRowSpanTdAt(curRow+1);
    }

    offsetY += maxHeight;
    size = constraints.tighten(width: fixWidth,height: offsetY).smallest;
    rowSpanModelWaitToAdjust.clear();

    print('xmlTable${this.hashCode} PerformLayout Use Time: ${DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch}');
  }

  void adjustLastRowHeight(int curRow, double maxHeight){
    int lastRow = curRow-1;
    print('重新布局了$lastRow行的 cell, ${layoutHelpMatrix.length}');
    lastRow = lastRow < layoutHelpMatrix.length ? lastRow : layoutHelpMatrix.length - 1;
    layoutHelpMatrix[lastRow].forEach((model){
      BoxConstraints childConstraints = BoxConstraints(minWidth: model.tdWidth, maxWidth: model.tdWidth, minHeight: maxHeight, maxHeight: double.infinity);
      model.cellRenderBox.layout(childConstraints,parentUsesSize: true);
    });
  }

  void adjustRowSpanTdAt(int rowSpanEndRow){

    List<XmlTableCellLayoutModel> rowSpans = rowSpanModelWaitToAdjust[rowSpanEndRow];
    rowSpans.forEach((rowSpanModel){
      double height = 0;
      for(int i = rowSpanModel.row; i < rowSpanModel.row + rowSpanModel.rowSpan; i++){
        height += rowHeightRecord[i];
      }
      BoxConstraints childConstraints = BoxConstraints(
          minWidth:rowSpanModel.cellRenderBox.constraints.smallest.width,
          maxWidth: rowSpanModel.cellRenderBox.constraints.smallest.width,
          minHeight: height,
          maxHeight: height);
      rowSpanModel.cellRenderBox.layout(childConstraints, parentUsesSize: true);
    });
  }

   XmlTableCellLayoutModel adjustRowSpanModel(XmlTableCellLayoutModel rowSpanModel, int curRow, XmlTableCellLayoutModel curModel){
     int index = 0;
     //跨行情况下,找到真正导致跨行占位的那一个td
     while(rowSpanModel.rowSpan == 1){
       index += 1;
       rowSpanModel = getTopModel(curRow - index, curModel, preTop: true);
     }
     return rowSpanModel;
   }

  @override
  void paint(PaintingContext context, Offset offset) {
//    DateTime now = DateTime.now();
    defaultPaint(context, offset);
//    print('xmlTable${this.hashCode} paint Use Time: ${DateTime.now().millisecondsSinceEpoch - now.millisecondsSinceEpoch}');
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result,position: position);
  }

  @override
  void setupParentData(RenderObject child) {
    if(child.parentData is! _XmlTableParentData){
      child.parentData = _XmlTableParentData();
    }
  }

}

class _XmlTableParentData extends ContainerBoxParentData<RenderBox>{
  XmlTableCellLayoutModel model;
}