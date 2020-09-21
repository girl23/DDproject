import 'package:lop/style/font.dart';

///通用的Loading的弹出框

import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/translations.dart';

class LoadingDialogUtil {
  static ProgressDialog createProgressDialog(BuildContext context) {
    ProgressDialog progressD = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressD.style(
        message: Translations.of(context).text("loading"),
        messageTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: KFont.fontSizeDialogLoading,
            fontWeight: FontWeight.w600));
    return progressD;
  }
}
