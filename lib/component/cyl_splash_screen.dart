import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnLoadingCallBack = void Function();
typedef OnComplete = void Function();

class CYLSplashScreen extends StatefulWidget {
  ///过场后下一页的 widget
  final Widget nextPage;

  ///过场的持续时间(秒)
  final int second;

  ///过场中的回调
  final OnLoadingCallBack onLoading;

  ///过场结束时的回调
  final OnComplete onComplete;

  CYLSplashScreen(
      {@required this.nextPage,
      this.onLoading,
      this.onComplete,
      this.second = 2});

  @override
  _CYLSplashScreenState createState() => _CYLSplashScreenState();
}

class _CYLSplashScreenState extends State<CYLSplashScreen> {
  @override
  void initState() {
    if (widget.onLoading != null) {
      widget.onLoading();
    }

    Future.delayed(Duration(seconds: widget.second), () {
      if (widget.nextPage != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return widget.nextPage;
        }));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onComplete != null) {
      widget.onComplete();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initScreenUtil();
    return Container(
      child: Image(
        image: AssetImage("assets/images/bg_login.jpg"),
        fit: BoxFit.fill,
      ),
    );
  }

  void _initScreenUtil() {
//适配器初始化,全局只需要初始化一次，必须在有UI Tree的情况下才可以初始化。
    if (window.physicalSize.width > 1080) {
      ScreenUtil.init(context,
          width: window.physicalSize.width,
          height: window.physicalSize.height,
          allowFontScaling: true);
    } else {
      ScreenUtil.init(context,
          width: 1080, height: 1920, allowFontScaling: true);
    }
  }
}
