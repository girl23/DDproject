
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loading_view_controller.dart';
import '../../style/font.dart';

class LoadingViewError extends StatelessWidget{
  final GestureTapCallback errorRetryListener;
  final LoadingState errorState;

  const LoadingViewError(this.errorState, this.errorRetryListener):
  assert(errorState == LoadingState.error || errorState == LoadingState.errorNetwork);

  @override
  Widget build(BuildContext context) {
    return _buildErrorWidget();
  }

  Widget _buildErrorWidget(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
        ),
        GestureDetector(
          onTap: errorRetryListener,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
                (errorState==LoadingState.error)?'加载错误\n点击重新加载':'网络错误\n点击重新加载',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black26,fontSize: KFont.fontSizeCommon_1)),
          ),
        )

      ],

    );
  }

}