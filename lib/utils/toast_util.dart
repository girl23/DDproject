import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lop/style/index.dart';

enum ToastType { INFO, WARN, ERROR }

class ToastUtil {
  static Future<bool> makeToast(@required String msg,
      {ToastType toastType = ToastType.INFO,gravity = ToastGravity.BOTTOM}) {
    Color bgColor;
    switch (toastType) {
      case ToastType.INFO:
        bgColor = KColor.toastBgColor_info;
        break;
      case ToastType.WARN:
        bgColor = KColor.toastBgColor_warn;
        break;
      case ToastType.ERROR:
        bgColor = KColor.toastBgColor_error;
        break;
    }
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor,
        textColor: Colors.white,
        fontSize: KFont.fontSizeCommon_2);
  }
}
