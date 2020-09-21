import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lop/component/xy_dialog_widget.dart';
import 'package:lop/router/application.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';

abstract class BaseStlessPage<T extends BaseViewModel> extends StatelessWidget {
  T viewModel;
  BuildContext context;
  //跳转到页面
  void navigateToPageFadeIn(String path) {
    Application.router
        .navigateTo(context, path, transition: TransitionType.fadeIn);
  }
  //带取消按钮的文本提示框
  void showDoubleButtonDialog(@required BuildContext ctx,
      {title,
        info,
        leftText,
        rightText,
        gravity = Gravity.center,
        onTapLeft,
        onTapRight,
        isClickAutoDismiss = true}) {
    horizontalDoubleButtonDialog(ctx,
        title: title,
        info: info,
        leftText: leftText,
        rightText: rightText,
        gravity: gravity,
        onTapLeft: onTapLeft,
        onTapRight: onTapRight,
        isClickAutoDismiss: isClickAutoDismiss);
  }
//带输入框的文本提示框
  void showDoubleButtonInputDialog(@required BuildContext ctx,
      {title,
        info,
        buttonLeftText,
        buttonRightText,
        gravity = Gravity.center,
        onTapLeft,
        onTapRight,
        isClickAutoDismiss = true,
        disable = false}) {
    doubleButtonInputDialog(ctx,
        title: title,
        info: info,
        buttonLeftText: buttonLeftText,
        buttonRightText: buttonRightText,
        gravity: gravity,
        onTapLeft: onTapLeft,
        onTapRight: onTapRight,
        isClickAutoDismiss: isClickAutoDismiss,
        disable: disable);
  }
//上传选择图片的弹出框
  void showTakePhotoDialog(@required BuildContext ctx,
      {firstText,
        secondText,
        thirdText,
        gravity = Gravity.center,
        onTapOne,
        onTapTwo,
        onTapThree,
        isClickAutoDismiss = true}) {
    verticalTakePhotoDialog(ctx,
        firstText: firstText,
        secondText: secondText,
        thirdText: thirdText,
        gravity: gravity,
        onTapOne: onTapOne,
        onTapTwo: onTapTwo,
        onTapThree: onTapThree,
        isClickAutoDismiss: isClickAutoDismiss);
  }
//不带取消按钮的文本提示框
  void showSingleButtonDialog(@required BuildContext ctx,
      {title,
        info,
        buttonText,
        gravity = Gravity.center,
        onTap,
        isClickAutoDismiss = true}) {
    horizontalSingleButtonDialog(ctx,
        title: title,
        info: info,
        buttonText: buttonText,
        gravity: gravity,
        onTap: onTap,
        isClickAutoDismiss: isClickAutoDismiss);
  }
//带取消按钮的富文本提示框
  void showRichTextDoubleButtonDialog(@required BuildContext ctx,
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
    richTextDoubleButtonDialog(ctx,
        title: title,
        infoLeft: infoLeft,
        richText: richText,
        infoRight: infoRight,
        leftText: leftText,
        rightText: rightText,
        gravity: gravity,
        onTapLeft: onTapLeft,
        onTapRight: onTapRight,
        isClickAutoDismiss: isClickAutoDismiss);
  }
//不带取消按钮的富文本提示框
  void showRichTextSingleButtonDialog(@required BuildContext ctx,
      {title,
        infoLeft,
        richText,
        infoRight,
        buttonText,
        gravity = Gravity.center,
        onTap,
        isClickAutoDismiss = true}) {
    richTextSingleButtonDialog(ctx,
        title: title,
        infoLeft: infoLeft,
        richText: richText,
        infoRight: infoRight,
        buttonText: buttonText,
        gravity: gravity,
        onTap: onTap,
        isClickAutoDismiss: isClickAutoDismiss);
  }
  //显示吐司
  void showToast(String msg, {ToastType toastType = ToastType.INFO}) {
    ToastUtil.makeToast(msg, toastType: toastType);
  }
  //显示pupwindow
  void showPupWindow(List<String> items) {}
  //获取本地化文字
  String getTranslationsText(String key) {
    return Translations.of(context).text(key);
  }
  @override
  Widget build(BuildContext context) {
    viewModel = getViewModel();
    this.context = context;
    initListener();
    initData();
    return buildWidget(context);
  }
  T getViewModel();//初始化ViewModel
  Widget buildWidget(BuildContext context);//初始化显示内容
  void initData();//初始化数据
  void initListener();//初始化控件事件
}
