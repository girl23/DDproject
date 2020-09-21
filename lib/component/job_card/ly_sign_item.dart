import 'package:flutter/material.dart';
import 'package:lop/config/enum_config.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/model/jobcard/jc_body_model.dart';
import 'package:lop/style/size.dart';
import 'package:provider/provider.dart';
import 'ly_sign_item_content.dart';
import 'ly_sign_item_header.dart';


class LySignItem extends StatefulWidget {
  final ProItemModel itemData;
  final itemWidth;

  LySignItem(this.itemData, this.itemWidth);

  @override
  _LySignItemState createState() => _LySignItemState();
}

class _LySignItemState extends State<LySignItem> {
  double _lrPadding = KSize.commonPadding2;
  double _tbPadding = KSize.commonPadding2;

  @override
  Widget build(BuildContext context) {
    Provider.of<JcSignModel>(context).contentImageWidth = widget.itemWidth - 2 * _lrPadding;
    return Container(
      color: widget.itemData.available?Colors.white:Colors.grey[300],
      padding:
          EdgeInsets.only(left: _lrPadding, right: _lrPadding, top: _tbPadding),
      child: Container(
        width: widget.itemWidth - 2 * _lrPadding,
        child: Column(
          children: <Widget>[
            LySignItemContent(
              key: ValueKey<String>("${widget.itemData.path}"),
              itemId: widget.itemData.path,
              itemNo: widget.itemData.no,
              itemCnData: (Provider.of<JcSignModel>(context).jcLanguage == JobCardLanguage.cn || Provider.of<JcSignModel>(context).jcLanguage == JobCardLanguage.mix)
                  ? widget.itemData.cnLanguageModel:null,
              itemEnData: (Provider.of<JcSignModel>(context).jcLanguage == JobCardLanguage.en || Provider.of<JcSignModel>(context).jcLanguage == JobCardLanguage.mix)
                  ? widget.itemData.enLanguageModel:null,
              itemMixData: widget.itemData.mixLanguageModel,
              itemWidth: widget.itemWidth - 2 * _lrPadding,
              inputWidth: 120.0,
            ),
            LySignItemHeader(
                itemData: widget.itemData, width: widget.itemWidth),
            Divider(
              height: 1,
              color: Colors.black26,
            ),
          ],
        ),
      )
    );
  }
}
