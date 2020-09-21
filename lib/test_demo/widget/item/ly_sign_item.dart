import 'package:flutter/material.dart';
import 'ly_local_text.dart';
import 'ly_sign_item_content.dart';
import 'ly_sign_item_header.dart';

import 'ly_sign_item_content.dart';

class LySignItem extends StatefulWidget {
  final itemData;
  final itemWidth;
  final TextType textType;
  LySignItem(this.itemData, this.itemWidth, this.textType);
  @override
  _LySignItemState createState() => _LySignItemState();
}

class _LySignItemState extends State<LySignItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          LySignItemHeader(itemData: widget.itemData,width: widget.itemWidth),
          LySignItemContent(key:ValueKey<String>("${widget.itemData["itemId"]}"),itemId:widget.itemData["itemId"],itemData:widget.itemData["datas"],itemWidth:widget.itemWidth, textType:widget.textType),
          SizedBox(
            height: 3,
            width: widget.itemWidth,
            child: Container(),
          ),
          Divider(height: 1,color: Colors.black26,),
          SizedBox(
            height: 3,
            width: widget.itemWidth,
            child: Container(),
          )
        ],
    );
  }


}
