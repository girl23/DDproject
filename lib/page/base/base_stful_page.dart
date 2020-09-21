import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lop/component/xy_dialog_widget.dart';
import 'package:lop/router/application.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';
import 'package:progress_dialog/progress_dialog.dart';

abstract class BaseStfulPage<T extends BaseViewModel> extends StatefulWidget {
  T viewModel;
  BuildContext context;
  ProgressDialog loadingDialog;

  @override
  _BaseStfulPageState createState() => _BaseStfulPageState();

  //跳转到页面
  void navigateToPageFadeIn(String path) {
    Application.router
        .navigateTo(context, path, transition: TransitionType.fadeIn);
  }

  //显示pupwindow
  void showPupWindow(List<String> items) {}

  //显示loading
  void showLoadingDialog() async{
    if (loadingDialog == null) {
      loadingDialog = LoadingDialogUtil.createProgressDialog(context);
    }
    await loadingDialog.show();
  }

  //隐藏loading
  void hideLoadingDialog({whenComplete}){
    if(loadingDialog!=null && loadingDialog.isShowing()){
      loadingDialog.hide().whenComplete(whenComplete);
    }
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

  //获取本地化文字
  String getTranslationsText(String key) {
    return Translations.of(context).text(key);
  }

  T getViewModel(); //初始化ViewModel
  Widget buildWidget(BuildContext context); //初始化显示内容
  void initData(); //初始化数据
  void initListener(); //初始化控件事件
  void removeListener(); //移除控件事件
  Function setState; //
}

class _BaseStfulPageState extends State<BaseStfulPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.removeListener();
  }

  @override
  void didUpdateWidget(BaseStfulPage<BaseViewModel> oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    init();
  }
  void init() {
    widget.context = context;
    widget.viewModel = widget.getViewModel();
    widget.viewModel.context = context;
    widget.setState = (fn) {
      setState(fn);
    };
    widget.initListener();
    widget.initData();
  }

  @override
  Widget build(BuildContext context) {
    //widget.loadingDialog = LoadingDialogUtil.createProgressDialog(context);
    return widget.buildWidget(context);
  }
}
