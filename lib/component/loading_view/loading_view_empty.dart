
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../style/font.dart';

class LoadingViewEmpty extends StatelessWidget{
  final GestureTapCallback emptyRetryListener;

  const LoadingViewEmpty(this.emptyRetryListener);

  @override
  Widget build(BuildContext context) {
    return _buildEmptyWidget();
  }

  Widget _buildEmptyWidget(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
        ),
        GestureDetector(
          onTap: emptyRetryListener,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text('暂无数据\n点击重新加载',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black26,fontSize: KFont.fontSizeCommon_1)),
          ),
        )

      ],

    );
  }

}