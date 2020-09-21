

import 'package:flutter/material.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/translations.dart';

class TaskDetailCategory extends StatelessWidget{


  final String categoryName;

  TaskDetailCategory({
    @required this.categoryName
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            height: KSize.taskDetailTaskCategaryHeight,
            alignment: Alignment.bottomLeft,
            child: Text(
              this.categoryName,
              style: TextStyle(
                color: Colors.red,
                fontSize: KFont.fontSizeCommon_1,
                fontWeight: FontWeight.bold,
                wordSpacing: KSize.commonWordSpacing,
              ),
            ),
          ),
          Divider(color: Colors.black45),
        ]);
  }

}