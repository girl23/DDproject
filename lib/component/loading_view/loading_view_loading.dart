import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../style/font.dart';

class LoadingViewLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildLoadingWidget();
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: CircularProgressIndicator(
            strokeWidth: 5.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "加载中...",
            style: TextStyle(
                color: Colors.black26, fontSize: KFont.fontSizeCommon_2),
          ),
        ),
      ],
    );
  }
}
