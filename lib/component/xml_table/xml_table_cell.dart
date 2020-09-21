
import 'package:flutter/material.dart';
import 'package:lop/component/job_card/ly_sign_item_content.dart';
import 'package:lop/component/xml_table/xml_table_content.dart';
import 'package:lop/model/jobcard/jc_model.dart';
import 'package:lop/model/jobcard/jc_table_model.dart';
import '../xml_table/xml_table.dart';

typedef DidCreateTextSpan = void Function(TextSpan textSpan, int id);
typedef DidLayoutCallBack = void Function(double height, XmlTableCellLayoutModel layoutModel);

class XmlTableCell extends StatefulWidget {

  final int id;
  final double fixWidth;
  final XmlTableCellLayoutModel cellModel;
  final EdgeInsets padding;

  XmlTableCell({
    @required this.id,
    @required this.cellModel,
    @required this.fixWidth,
    this.padding,
  });
  @override
  _XmlTableCellState createState() => _XmlTableCellState();
}

class _XmlTableCellState extends State<XmlTableCell> {

  Border border;
  Map<VerticalAlignment, Alignment> alignmentMap = {
    VerticalAlignment.center : Alignment.center,
    VerticalAlignment.top : Alignment.topCenter,
    VerticalAlignment.bottom : Alignment.bottomCenter
};
  double pixelOffset = 2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(widget.cellModel.borderWidth == 0){
      border = Border();
    }else {
      border = Border(
        left: widget.cellModel.leftHasBorder ? BorderSide(width: widget.cellModel.borderWidth) : BorderSide.none,
        top: widget.cellModel.topHasBorder ? BorderSide(width: widget.cellModel.borderWidth): BorderSide.none,
        right: BorderSide(width: widget.cellModel.borderWidth),
        bottom: BorderSide(width: widget.cellModel.borderWidth),
      );
    }

//    border = Border(
//      left: widget.cellModel.leftHasBorder ? BorderSide.none : BorderSide(width: widget.cellModel.borderWidth),
//      top: widget.cellModel.topHasBorder ? BorderSide.none : BorderSide(width: widget.cellModel.borderWidth),
//      right:widget.cellModel.rightHasBorder ? BorderSide.none : BorderSide(width: widget.cellModel.borderWidth),
//      bottom: widget.cellModel.bottomHasBorder ? BorderSide.none : BorderSide(width: widget.cellModel.borderWidth),
//    );
  }

  @override
  Widget build(BuildContext context) {

    EdgeInsets padding =  widget.padding ?? EdgeInsets.all(5);

    TableDataModel tdModel = widget.cellModel.tdModel;
    return Container(
      alignment: alignmentMap[tdModel.vAlignment],
      padding: padding,
      width: widget.fixWidth,
      decoration: BoxDecoration(
        border: border,
      ),
//      child: XMLTableContent(tdModel, widget.fixWidth - padding.horizontal - pixelOffset,)
      child: LySignItemContent(itemCnData: tdModel,itemWidth: widget.fixWidth - padding.horizontal - pixelOffset,inputWidth: widget.fixWidth - padding.horizontal - pixelOffset,),
    );
  }
}
