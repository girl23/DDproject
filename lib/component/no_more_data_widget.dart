import 'package:flutter/material.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/translations.dart';

class NoMoreDataWidget extends StatefulWidget {
  @override
  _NoMoreDataWidgetState createState() => _NoMoreDataWidgetState();
}

class _NoMoreDataWidgetState extends State<NoMoreDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: KSize.tableViewNoDataHeight,
      child: Text(
        Translations.of(context).text('nodata'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: KFont.fontSizeItem_1,
        ),
      ),
    );
  }
}
