import 'package:flutter/material.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/model/jobcard/jc_model.dart';
import 'package:lop/model/jobcard/jc_table_model.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:provider/provider.dart';
import 'xml_table_cell_model.dart';
import 'xml_table_cell.dart';
import 'xml_table.dart';

enum LayoutMode {
  HEADER,
  BODY,
  FOOTER
}

class XmlConvertedTable extends StatefulWidget {

  final TableModel _tableModel;
  final double tableWidth;
  final double viewPortWidth;
  ///暂时无用
//  final EdgeInsets padding;
  XmlConvertedTable(this._tableModel,{@required this.tableWidth, @required this.viewPortWidth,});

  @override
  _XmlConvertedTableState createState() => _XmlConvertedTableState();
}

class _XmlConvertedTableState extends State<XmlConvertedTable> {
//  int totalCol = 0;
//  int totalRow = 0;

  bool hasHeader = false;
  bool hasFooter = false;

  Map<LayoutMode, int> totalRowMap = {
    LayoutMode.HEADER:0,
    LayoutMode.BODY:0,
    LayoutMode.FOOTER:0
  };

  Map<LayoutMode, int> totalColMap = {
    LayoutMode.HEADER:0,
    LayoutMode.BODY:0,
    LayoutMode.FOOTER:0
  };

  List<XmlTableCellLayoutModel> _bodyCellModels = [];
  List<XmlTableCell> _bodyChildren = [];

  List<XmlTableCellLayoutModel> _headCellModels = [];
  List<XmlTableCell> _headChildren = [];

  List<XmlTableCellLayoutModel> _footCellModels = [];
  List<XmlTableCell> _footChildren = [];

  @override
  void initState() {
    DateTime last = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_){
      DateTime now = DateTime.now();
      print('duration: ${now.millisecondsSinceEpoch - last.millisecondsSinceEpoch} millsecond');
    });

    hasHeader = widget._tableModel.tableHeaderModel != null;
    hasFooter = widget._tableModel.tableFooterModel != null;

    if(hasHeader){
      _xmlModelToLayoutModel(widget._tableModel.tableHeaderModel.children, _headCellModels,LayoutMode.HEADER);
      _addCellsAndMakeChildren(_headCellModels, _headChildren);
    }

    _xmlModelToLayoutModel(widget._tableModel.tableBodyModel.children, _bodyCellModels,LayoutMode.BODY);
    _addCellsAndMakeChildren(_bodyCellModels, _bodyChildren);

    if(hasFooter){
      _xmlModelToLayoutModel(widget._tableModel.tableFooterModel.children, _footCellModels,LayoutMode.FOOTER);
      _addCellsAndMakeChildren(_footCellModels, _footChildren);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double tableFinedWidth = widget.tableWidth * (widget.viewPortWidth / widget.tableWidth);

    return Container(
      width: widget.viewPortWidth,
      padding: EdgeInsets.only(top: KSize.commonPadding3),
      child: Column(
        children: <Widget>[
          widget._tableModel.name!=null?
          Container(
            alignment: Alignment.center,
            child: Text(widget._tableModel.name, style: TextStyle(fontSize: KFont.fontSizeCommon_4 * Provider.of<JcSignModel>(context).fontScale),
            textAlign: TextAlign.center,),
          ):Container(),

          _headChildren.length != 0 ?
          XmlTable(
            children: _headChildren,
            cellModels: _headCellModels,
            fixWidth: tableFinedWidth,
            totalRow: totalRowMap[LayoutMode.HEADER],
            totalCol: totalColMap[LayoutMode.HEADER],
          ):Container(),

          XmlTable(
            children: _bodyChildren,
            cellModels: _bodyCellModels,
            fixWidth: tableFinedWidth,
            totalRow: totalRowMap[LayoutMode.BODY],
            totalCol: totalColMap[LayoutMode.BODY],
          ),

          _footChildren.length != 0 ?
          XmlTable(
            children: _footChildren,
            cellModels: _footCellModels,
            fixWidth: tableFinedWidth,
            totalRow: totalRowMap[LayoutMode.FOOTER],
            totalCol: totalColMap[LayoutMode.FOOTER],
          ):Container(),
        ],
      ),
    );
  }

  void _addCellsAndMakeChildren(List<XmlTableCellLayoutModel> layoutModels, List<XmlTableCell> cells) {
    for (XmlTableCellLayoutModel cellModel in layoutModels) {

      Widget child = XmlTableCell(
        id: cellModel.id,
        cellModel: cellModel,
        fixWidth: cellModel.tdWidth,
      );
      cells.add(child);
    }
  }
//
  void _xmlModelToLayoutModel(List<JcModel> rows, List<XmlTableCellLayoutModel>results, LayoutMode mode){

    if(rows.length == 0) return;

    totalColMap[mode] = 0;
    totalRowMap[mode] = 0;
    double widthPercent = widget.viewPortWidth / widget.tableWidth;

    if (widget._tableModel != null){
      int id = 0;
      totalRowMap[mode] = rows.length;
      print('${rows.toString()}');
      List<List<int>> matrix;

      for(int rowIndex = 0; rowIndex < totalRowMap[mode]; rowIndex ++){
        TableRowModel tr =rows[rowIndex];

        for(int col = 0; col < tr.children.length; col++){
          TableDataModel td = tr.children[col];
          if(rowIndex == 0){
            totalColMap[mode] += td.colSpan;
          }
        }

        ///仅有一行的情况
        if(totalRowMap[mode] == 1){
          for(int col = 0; col < tr.children.length; col++){
            TableDataModel tableDataModel = tr.children[col];
            TableDataModel lastTd;
            tableDataModel.row = rowIndex;
            tableDataModel.col = col;
            if(col > 0){lastTd = tr.children[col - 1];}
            ///td 的样式属性也要对应转到 ui model 中体现
            id += 1;

            XmlTableCellLayoutModel cellModel = XmlTableCellLayoutModel(
              tdModel: tableDataModel,
              id: id,
              column: tableDataModel.col,
              row: rowIndex,
              columnSpan: tableDataModel.colSpan,
              rowSpan: tableDataModel.rowSpan,
              tdWidth: tableDataModel.width * widthPercent,

            );

            if(lastTd == null){
              cellModel.leftHasBorder = true;
            }

            cellModel.topHasBorder = tableDataModel.row == 0;
            if(mode == LayoutMode.BODY && hasHeader) cellModel.topHasBorder = false;
            if(mode == LayoutMode.FOOTER) cellModel.topHasBorder = false;
            cellModel.borderWidth = 1;
            cellModel.isTopFirst = tableDataModel.row == 0;
            cellModel.isLeftFirst = col == 0;
            results.add(cellModel);

          }

        }else{
          ///有多行的情况 根据 colSpan rowSpan计算出正确的col 和 row(利用之前的矩阵算法)
          if(matrix == null){
            matrix= List.generate(totalRowMap[mode], (int index)=>(List.generate(totalColMap[mode], (int index) => -1)));
          }

          ///获取当前行的矩阵
          List<int> curTrMatrix = matrix[rowIndex];
          for(int i = 0,j = 0; (i < totalColMap[mode]) & (j < tr.children.length); i++){
            //i：列号；j：td节点在当前行的编号
            int tdNo = curTrMatrix[i];
            if(tdNo >= 0){//表示这一列已经被占用
              continue;
            }else{
              TableDataModel tableDataModel = tr.children[j];
              TableDataModel lastTd;
              tableDataModel.row = rowIndex;
              tableDataModel.col = i;
              if(i > 0 && i < tr.children.length){lastTd = tr.children[i - 1];}
              ///将矩阵中此td所占的位置都标注,标记为行号+列号
              int tag = (rowIndex<<8) + i;
              ///根据这个控件的跨度，将跨度范围内的所有矩阵点都标记
              for(int m = rowIndex; m < (rowIndex+tableDataModel.rowSpan);m++){
                List<int> trMatrix = matrix[m];
                for(int n = i; n < (i+tableDataModel.colSpan);n++){
                  trMatrix[n] = tag;
                }
              }
              j++;

              ///td 的样式属性也要对应转到 ui model 中体现
              id += 1;

              XmlTableCellLayoutModel cellModel = XmlTableCellLayoutModel(
                tdModel: tableDataModel,
                id: id,
                column: tableDataModel.col,
                row: tableDataModel.row,
                columnSpan: tableDataModel.colSpan,
                rowSpan: tableDataModel.rowSpan,
                tdWidth: tableDataModel.width * widthPercent,

              );

              if(lastTd == null){
                cellModel.leftHasBorder = true;
              }

              cellModel.topHasBorder = tableDataModel.row == 0;
              if(mode == LayoutMode.BODY && hasHeader) cellModel.topHasBorder = false;
              if(mode == LayoutMode.FOOTER) cellModel.topHasBorder = false;
              cellModel.borderWidth = 1;
              cellModel.isTopFirst = tableDataModel.row == 0;
              cellModel.isLeftFirst = i == 0;
              results.add(cellModel);
            }
          }
        }
      }
    }
  }
}
