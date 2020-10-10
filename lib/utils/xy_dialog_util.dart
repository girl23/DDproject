import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/component/xy_dialog_widget.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/button_theme.dart';

XYDialog horizontalDoubleButtonDialog(@required BuildContext ctx,
    {title,
    info,
    leftText,
    rightText,
    gravity = Gravity.center,
    onTapLeft,
    onTapRight,
    isClickAutoDismiss = true}) {
  return XYDialog().build(ctx:ctx)
    ..width = (ScreenUtil.screenWidthDp * 0.8)
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravity = Gravity.center
    ..animatedFunc = (child, animation) {
      return FadeTransition(
        child: child,
        opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..text(
      title: title,
      titleColor: KColor.color_191919,
      titlePadding: EdgeInsets.all(KSize.dialogPadding3),
      padding: EdgeInsets.only(
          bottom: KSize.dialogPadding4,
          left: KSize.dialogPadding4,
          right: KSize.dialogPadding4),
      titleFontSize: KFont.fontSizeCommon_1,
      titleFontWeight: FontWeight.normal,
      alignment: Alignment.center,
      text: info,
      color: Colors.black54,
      fontSize: KFont.fontSizeCommon_2,
      fontWeight: FontWeight.w500,
    )
    //..divider()
    ..doubleButton(
      dividerWidth: ScreenUtil().setWidth(48),
      dividerColor: KColor.color_fafafa,
      gravity: gravity,
      padding: EdgeInsets.only(bottom: KSize.dialogPadding3),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(380),
      shapeRadius: ScreenUtil().setWidth(ButtonThemeStore.shapeRadius),
      withDivider: true,
      leftBgColor: ButtonThemeStore.buttonThemeLight["buttonColor"],
      leftBgColorH: ButtonThemeStore.buttonThemeLight["highlightColor"].withOpacity(0.05),
      borderColor: ButtonThemeStore.buttonThemeLight["borderColor"],
      rightBgColor: Theme.of(ctx).buttonColor,
      rightBgColorH: Theme.of(ctx).highlightColor,
      isClickAutoDismiss: isClickAutoDismiss,
      text1: leftText,
      color1: KColor.color_333333,
      fontSize1: KFont.fontSizeDialogAlert,
      fontWeight1: FontWeight.normal,
      onTap1: onTapLeft,
      text2: rightText,
      color2: Colors.white,
      fontSize2: KFont.fontSizeDialogAlert,
      fontWeight2: FontWeight.normal,
      onTap2: onTapRight,
    )
    ..show();
}

XYDialog doubleButtonInputDialog(@required BuildContext ctx,
    {title,
    info,
    buttonLeftText,
    buttonRightText,
    gravity = Gravity.center,
    onTapLeft,
    onTapRight,
    isClickAutoDismiss = true,
    disable = false}) {
  return XYDialog().build(ctx:ctx)
    ..width = double.infinity
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravityAnimationEnable = true
    ..gravity = gravity
    ..inputText(
        title: title,
        titleColor: KColor.color_191919,
        titlePadding: EdgeInsets.all(KSize.dialogPadding3),
        padding: EdgeInsets.only(
            bottom: KSize.dialogPadding4,
            left: KSize.dialogPadding4,
            right: KSize.dialogPadding4),
        titleFontSize: KFont.fontSizeCommon_3,
        titleFontWeight: FontWeight.normal,
        alignment: Alignment.center,
        text: info,
        color: Colors.black54,
        minTextHeight: KSize.dialogPadding6,
        fontSize: KFont.fontSizeCommon_2,
        fontWeight: FontWeight.w500,
        borderColor: KColor.borderColor,
        borderRaduis: ScreenUtil().setWidth(9),
        borderSize: ScreenUtil().setWidth(1),
        disable: disable)
    //..divider()
    ..doubleInputButton(
        dividerWidth: 2*ScreenUtil().setWidth(48)/3,
        dividerColor: KColor.dividerColor,
        gravity: Gravity.center,
        padding: EdgeInsets.only(bottom: KSize.dialogPadding5),
        height: ScreenUtil().setHeight(120),
        width: MediaQuery.of(ctx).size.width / 2-ScreenUtil().setWidth(80),
        shapeRadius: ScreenUtil().setWidth(ButtonThemeStore.shapeRadius),
        withDivider: true,
        leftBgColor: ButtonThemeStore.buttonThemeLight["buttonColor"],
        leftBgColorH: ButtonThemeStore.buttonThemeLight["highlightColor"].withOpacity(0.05),
        borderColor: ButtonThemeStore.buttonThemeLight["borderColor"],
        rightBgColor: Theme.of(ctx).buttonColor,
        rightBgColorH: Theme.of(ctx).highlightColor,
        isClickAutoDismiss: isClickAutoDismiss,
        text1: buttonLeftText,
        color1: KColor.color_333333,
        fontSize1: KFont.fontSizeBtn_2,
        fontWeight1: FontWeight.normal,
        onTap1: onTapLeft,
        text2: buttonRightText,
        color2: Colors.white,
        fontSize2: KFont.fontSizeBtn_2,
        fontWeight2: FontWeight.normal,
        onTap2: onTapRight,
        disable: disable)
    ..show();
}

XYDialog verticalTakePhotoDialog(@required BuildContext ctx,
    {firstText,
    secondText,
    thirdText,
    gravity = Gravity.center,
    onTapOne,
    onTapTwo,
    onTapThree,
    isClickAutoDismiss = true}) {
  return XYDialog().build(ctx:ctx)
    ..width = double.infinity
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravityAnimationEnable = true
    ..gravity = gravity
    //..divider()
    ..listViewOfListTile(
        items: [
          ListTileItem(
              padding: EdgeInsets.all(ScreenUtil().setHeight(16)),
              text: firstText,
              color: KColor.color_333333,
              fontSize: KFont.fontSizeBtn_2,
              key: "takePhoto"),
          ListTileItem(
              padding: EdgeInsets.all(ScreenUtil().setHeight(16)),
              text: secondText,
              color: KColor.color_333333,
              fontSize: KFont.fontSizeBtn_2,
              key: "chooseIamge"),
          ListTileItem(
              padding: EdgeInsets.all(ScreenUtil().setHeight(16)),
              text: thirdText,
              color: KColor.color_333333,
              fontSize: KFont.fontSizeBtn_2,
              key: "cancel")
        ],
        highlightColor: Theme.of(ctx).highlightColor,
        isClickAutoDismiss: isClickAutoDismiss,
        onClickItemListener: (key) {
          if (key == "takePhoto") {
            onTapOne();
          } else if (key == "chooseIamge") {
            onTapTwo();
          } else if (key == "cancel") {
            onTapThree();
          }
        })
    ..show();
}

XYDialog horizontalSingleButtonDialog(@required BuildContext ctx,
    {title,
    info,
    buttonText,
    gravity = Gravity.center,
    onTap,
    isClickAutoDismiss = true}) {
  return XYDialog().build(ctx:ctx)
    ..width = ScreenUtil().setWidth(890)
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravity = Gravity.center
    ..animatedFunc = (child, animation) {
      return FadeTransition(
        child: child,
        opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..text(
      title: title,
      titleColor: KColor.color_191919,
      titlePadding: EdgeInsets.all(KSize.dialogPadding3),
      padding: EdgeInsets.only(
          bottom: KSize.dialogPadding4,
          left: KSize.dialogPadding4,
          right: KSize.dialogPadding4),
      titleFontSize: KFont.fontSizeCommon_1,
      titleFontWeight: FontWeight.normal,
      alignment: Alignment.center,
      text: info,
      color: Colors.black54,
      fontSize: KFont.fontSizeCommon_2,
      fontWeight: FontWeight.w500,
    )
    //..divider()
    ..singleButton(
      gravity: gravity,
      padding: EdgeInsets.only(bottom: KSize.dialogPadding3),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(400),
      shapeRadius: ScreenUtil().setWidth(ButtonThemeStore.shapeRadius),
      withDivider: true,
      bgColor: Theme.of(ctx).buttonColor,
      bgColorH: Theme.of(ctx).highlightColor,
      isClickAutoDismiss: isClickAutoDismiss,
      text: buttonText,
      color: Colors.white,
      fontSize: KFont.fontSizeDialogAlert,
      fontWeight: FontWeight.normal,
      onTap: onTap,
    )
    ..show();
}
XYDialog richTextDoubleButtonDialog(@required BuildContext ctx,
    {title,
      infoLeft,
      richText,
      infoRight,
      leftText,
      rightText,
      gravity = Gravity.center,
      onTapLeft,
      onTapRight,
      isClickAutoDismiss = true}) {
  return XYDialog().build(ctx: ctx)
    ..width = (ScreenUtil.screenWidthDp * 0.8)
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravity = Gravity.center
    ..animatedFunc = (child, animation) {
      return FadeTransition(
        child: child,
        opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..richText(
      title: title,
      titleColor: KColor.color_191919,
      titlePadding: EdgeInsets.all(KSize.dialogPadding3),
      padding: EdgeInsets.only(
          bottom: KSize.dialogPadding4,
          left: KSize.dialogPadding4,
          right: KSize.dialogPadding4),
      titleFontSize: KFont.fontSizeCommon_1,
      titleFontWeight: FontWeight.normal,
      alignment: Alignment.center,
      infoLeft: infoLeft,
      infoRight: infoRight,
      richText: richText,
      richColor: KColor.color_f34d32,
      color: Colors.black54,
      fontSize: KFont.fontSizeCommon_2,
      fontWeight: FontWeight.w500,
    )
  //..divider()
    ..doubleButton(
      dividerWidth: ScreenUtil().setWidth(48),
      dividerColor: KColor.color_fafafa,
      gravity: gravity,
      padding: EdgeInsets.only(bottom: KSize.dialogPadding3),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(380),
      shapeRadius: ScreenUtil().setWidth(ButtonThemeStore.shapeRadius),
      withDivider: true,
      leftBgColor: ButtonThemeStore.buttonThemeLight["buttonColor"],
      leftBgColorH: ButtonThemeStore.buttonThemeLight["highlightColor"].withOpacity(0.05),
      borderColor: ButtonThemeStore.buttonThemeLight["borderColor"],
      rightBgColor: Theme.of(ctx).buttonColor,
      rightBgColorH: Theme.of(ctx).highlightColor,
      isClickAutoDismiss: isClickAutoDismiss,
      text1: leftText,
      color1: KColor.color_333333,
      fontSize1: KFont.fontSizeDialogAlert,
      fontWeight1: FontWeight.normal,
      onTap1: onTapLeft,
      text2: rightText,
      color2: Colors.white,
      fontSize2: KFont.fontSizeDialogAlert,
      fontWeight2: FontWeight.normal,
      onTap2: onTapRight,
    )
    ..show();
}
XYDialog richTextSingleButtonDialog(@required BuildContext ctx,
    {title,
      infoLeft,
      richText,
      infoRight,
      buttonText,
      gravity = Gravity.center,
      onTap,
      isClickAutoDismiss = true}) {
  return XYDialog().build(ctx:ctx)
    ..width = ScreenUtil().setWidth(890)
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravity = Gravity.center
    ..animatedFunc = (child, animation) {
      return FadeTransition(
        child: child,
        opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..richText(
      title: title,
      titleColor: KColor.color_191919,
      titlePadding: EdgeInsets.all(KSize.dialogPadding3),
      padding: EdgeInsets.only(
          bottom: KSize.dialogPadding4,
          left: KSize.dialogPadding4,
          right: KSize.dialogPadding4),
      titleFontSize: KFont.fontSizeCommon_1,
      titleFontWeight: FontWeight.normal,
      alignment: Alignment.center,
      infoRight: infoRight,
      infoLeft: infoLeft,
      richText: richText,
      richColor: KColor.color_f34d32,
      color: Colors.black54,
      fontSize: KFont.fontSizeCommon_2,
      fontWeight: FontWeight.w500,
    )
  //..divider()
    ..singleButton(
      gravity: gravity,
      padding: EdgeInsets.only(bottom: KSize.dialogPadding3),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(400),
      shapeRadius: ScreenUtil().setWidth(ButtonThemeStore.shapeRadius),
      withDivider: true,
      bgColor: Theme.of(ctx).buttonColor,
      bgColorH: Theme.of(ctx).highlightColor,
      isClickAutoDismiss: isClickAutoDismiss,
      text: buttonText,
      color: Colors.white,
      fontSize: KFont.fontSizeDialogAlert,
      fontWeight: FontWeight.normal,
      onTap: onTap,
    )
    ..show();
}
XYDialog singleButtonListDialog(@required BuildContext ctx,
    {@required items,
      height = 100.0,
      padding,
      onClickItemListener,
      buttonText,
      gravity = Gravity.center,
      onTap,
      isClickAutoDismiss = true}) {
  return XYDialog().build(ctx:ctx)
    ..width = ScreenUtil().setWidth(890)
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravity = Gravity.center
    ..animatedFunc = (child, animation) {
      return FadeTransition(
        child: child,
        opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..listViewOfListTile(
      items: items,
      height: height,
      padding:EdgeInsets.only(bottom: KSize.dialogPadding4),
      dividerColor: Colors.grey[400],
      highlightColor: Colors.grey,
      onClickItemListener: onClickItemListener
    )
  //..divider()
    ..singleButton(
      gravity: gravity,
      padding: EdgeInsets.only(bottom: KSize.dialogPadding3),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(400),
      shapeRadius: ScreenUtil().setWidth(ButtonThemeStore.shapeRadius),
      withDivider: true,
      bgColor: Theme.of(ctx).buttonColor,
      bgColorH: Theme.of(ctx).highlightColor,
      isClickAutoDismiss: isClickAutoDismiss,
      text: buttonText,
      color: Colors.white,
      fontSize: KFont.fontSizeDialogAlert,
      fontWeight: FontWeight.normal,
      onTap: onTap,
    )
    ..show();
}
XYDialog ddDialog(@required BuildContext ctx,
    {
      title,
      info,
      tagName,
      textFieldNodes,
      node,
      controller,
      buttonText,
      gravity = Gravity.center,
      onTap,
      isClickAutoDismiss = true}) {
  return XYDialog().build(ctx:ctx)
    ..width = ScreenUtil.screenWidthDp * 0.8
    ..borderRadius = ScreenUtil().setWidth(16)
    ..barrierColor = KColor.color_191919.withOpacity(0.6)
    ..backgroundColor = KColor.color_fafafa
    ..gravity = Gravity.center
    ..barrierDismissible=false
    ..animatedFunc = (child, animation) {
      return FadeTransition(
        child: child,
        opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..text(
      title: title,
      titleColor: KColor.textColor_33,
      titlePadding: EdgeInsets.only(top:KSize.dialogPadding3,right:KSize.dialogPadding3,left: KSize.dialogPadding3 ),
      padding: EdgeInsets.only(
          bottom: KSize.dialogPadding4,
          left: KSize.dialogPadding4,
          right: KSize.dialogPadding4),
      titleFontSize: KFont.fontSizeCommon_1,
      titleFontWeight: FontWeight.normal,
      alignment: Alignment.centerLeft,
      text: info,
      color: KColor.textColor_66,
      fontSize: KFont.fontSizeCommon_2,
      fontWeight: FontWeight.w500,
    )
    ..textFieldArea(
      padding: EdgeInsets.only(right:KSize.dialogPadding3,left: KSize.dialogPadding3 ),
      node: node,
      controller: controller,
      tagName: tagName,
    )
    ..singleButton(
      gravity: Gravity.right,
      padding: EdgeInsets.only(top:KSize.commonPadding3,bottom: ScreenUtil().setWidth(30),right: KSize.dialogPadding3),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(200),
      shapeRadius: ScreenUtil().setWidth(ButtonThemeStore.shapeRadius),
      withDivider: true,
      bgColor: Theme.of(ctx).buttonColor,
      bgColorH: Theme.of(ctx).highlightColor,
      isClickAutoDismiss: isClickAutoDismiss,
      text: buttonText,
      color: Colors.white,
      fontSize: KFont.fontSizeDialogAlert,
      fontWeight: FontWeight.normal,
      onTap: onTap,
    )
    ..show();
}