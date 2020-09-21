import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../extended_text/extended_text.dart';
import 'package:provider/provider.dart';
import '../../component/job_card/jc_widget_util.dart';
import '../../model/jc_sign_model.dart';
import '../../style/size.dart';
import '../../style/font.dart';

class LySignItemContent extends StatefulWidget {
  final itemCnData;
  final itemEnData;
  final itemMixData;
  final itemWidth;
  final itemId;
  final itemNo;
  final inputWidth;
  const LySignItemContent(
      {Key key,
      this.itemId,
      this.itemNo,
      this.itemCnData,
        this.itemEnData,
      this.itemMixData,
      this.itemWidth,
      this.inputWidth})
      : super(key: key);

  @override
  _LySignItemContentState createState() => _LySignItemContentState();
}

class _LySignItemContentState extends State<LySignItemContent> {
  double _noWidth = 0.0;
  double _contentWidth;
  @override
  void initState() {
    super.initState();
    if (widget.itemNo != null) {
      _noWidth = 20.0;
      _contentWidth = widget.itemWidth - _noWidth;
    } else {
      _contentWidth = widget.itemWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JcSignModel>(builder: (context, model, child) {
//      Text("${widget.itemId}.")
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Offstage(
            offstage: widget.itemNo == null,
            child: Container(
              width: _noWidth,
              child: Text(
                "${widget.itemNo}.",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: model.fontScale * KFont.fontSizeItem,
                    height: KSize.jcSignItemTextHeight),
              ),
            ),
          ),
          Container(
            width: _contentWidth,
            child: ExtendedText.rich(
             TextSpan(children: _buildWidgets(model)),
            ),
          )
        ],
      );
    });
  }

  List<InlineSpan> _buildWidgets(provider) {
    List<InlineSpan> widgets = List<InlineSpan>();
//    widgets.addAll(_buildItems(widget.itemCnData, provider));
//    widgets.addAll(_buildItems(widget.itemEnData, provider));
//    widgets.addAll(_buildItems(widget.itemMixData, provider));
    widgets.add(WidgetSpan(child: Container(width: _contentWidth,child: RichText(text: TextSpan(children: _buildItems(widget.itemCnData, provider)),),)));
    widgets.add(WidgetSpan(child: Container(width: _contentWidth,child: RichText(text: TextSpan(children: _buildItems(widget.itemEnData, provider)),),)));
    widgets.add(WidgetSpan(child: Container(width: _contentWidth,child: RichText(text: TextSpan(children: _buildItems(widget.itemMixData, provider)),),)));
    return widgets;
  }

  List<InlineSpan> _buildItems(items, provider) {
    if (items == null) {
      return [];
    }
    List<InlineSpan> widgets = List<InlineSpan>();
    int dataLength = items.children.length;
    for (int i = 0; i < dataLength; i++) {
      widgets.add(JcWidgetUtil.createItem(
          widget.itemId,provider, _contentWidth, items.children[i], widget.inputWidth,
          textStyle: TextStyle(color: Colors.black87, fontSize: KFont.fontSizeCommon_2,height: KSize.jcSignItemTextHeight)));
    }
    return widgets;
  }
}
