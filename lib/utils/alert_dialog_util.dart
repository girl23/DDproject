import 'package:flutter/material.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/xy_dialog_util.dart';

class AlertDialogUtil {
  static void openOkAlertDialog(
      BuildContext context, String content, Function function,{clickAutoDismiss = true}) {
//    final action = await showDialog(
//      context: context,
//      barrierDismissible: false, //// user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text(Translations.of(context).text("tip")),
//          content: Text(content),
//          actions: <Widget>[
//            FlatButton(
//              child: Text(Translations.of(context).text("confirm")),
//              onPressed: () {
//                function();
//              },
//            ),
//          ],
//        );
//      },
//    );
    horizontalSingleButtonDialog(context,
        title: Translations.of(context).text("tip"),
        info: content,
        buttonText: Translations.of(context).text("confirm"),
        onTap: () {
          function();
        });
  }

  static void openOkCancelAlertDialog(
      BuildContext context, String content, Function function) {
//    final action = await showDialog(
//      context: context,
//      barrierDismissible: false, //// user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text(Translations.of(context).text("tip")),
//          content: Text(content),
//          actions: <Widget>[
//            FlatButton(
//              child: Text(Translations.of(context).text("cancel")),
//              onPressed: () {
//                Navigator.pop(context);
//              },
//            ),
//            FlatButton(
//              child: Text(Translations.of(context).text("confirm")),
//              onPressed: () {
////                assignTaskOperation(context, isRelease);
//                function();
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        );
//      },
//    );
    horizontalDoubleButtonDialog(
        context,
        title: Translations.of(context).text("tip"),
        info: content,
        leftText: Translations.of(context).text('cancel'),
        onTapLeft: (){
        },
        rightText: Translations.of(context).text('confirm'),
        onTapRight: (){
          //assignTaskOperation(context, isRelease);
          function();
        },
    );
  }
  static void openOkRichTextAlertDialog(BuildContext context, String contentLeft,
      String richContent, String contentRight, Function function,
      {clickAutoDismiss = true}) {

    richTextSingleButtonDialog(context,
        title: Translations.of(context).text("tip"),
        infoLeft: contentLeft,
        infoRight: contentRight,
        richText: richContent,
        buttonText: Translations.of(context).text("confirm"), onTap: () {
          function();
        });
  }

  static void openOkCancelRichTextAlertDialog(BuildContext context, String contentLeft,
      String richContent, String contentRight, Function function) {

    richTextDoubleButtonDialog(
      context,
      title: Translations.of(context).text("tip"),
      infoLeft: contentLeft,
      infoRight: contentRight,
      richText: richContent,
      leftText: Translations.of(context).text('cancel'),
      onTapLeft: () {},
      rightText: Translations.of(context).text('confirm'),
      onTapRight: () {
        //assignTaskOperation(context, isRelease);
        function();
      },
    );
  }
}
