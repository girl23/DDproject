import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lop/model/get_sms_code_model.dart';
import 'package:lop/model/reset_password_model.dart';
import 'package:lop/style/index.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/reset_theme.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/utils/translations.dart';
import 'package:fluro/fluro.dart';
import 'package:lop/utils/toast_util.dart';

class ResetPasswordPage extends StatefulWidget {
  final String username;

  ResetPasswordPage({this.username = ''});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  String _username;
  String _code;
  String _phoneNumber;
  String _randomNumber;
  FocusNode _usernameFocusNode = new FocusNode();
  FocusNode _codeFocusNode = new FocusNode();

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();

  ProgressDialog _loadingDialog;

  bool _showTip = false;

  @override
  void initState() {
    _usernameFocusNode.addListener(_focusNodeListener);
    _codeFocusNode.addListener(_focusNodeListener);
    if (widget.username != null && widget.username.isNotEmpty) {
      _usernameController.text = widget.username;
    }
    super.initState();
  }

  @override
  void dispose() {
    // 移除焦点监听
    _usernameFocusNode.removeListener(_focusNodeListener);
    _codeFocusNode.removeListener(_focusNodeListener);
    _usernameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_usernameFocusNode.hasFocus) {
      _codeFocusNode.unfocus();
    }
    if (_codeFocusNode.hasFocus) {
      _usernameFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      //点击空白处收回虚拟键盘
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          //虚拟键盘不遮挡TextFormField
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            child: AppBar(
              title: new Text(
                Translations.of(context).text('reset_password'),
                style: TextThemeStore.textStyleAppBar,
              ),
              centerTitle: true,
            ),
            preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
          ),
          body: SingleChildScrollView(
            child: _form(context, _formKey),
          )),
    );
  }

  showDialog() async {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialogUtil.createProgressDialog(context);
    }
    await _loadingDialog.show();
  }

  //表单
  Widget _form(BuildContext context, GlobalKey key) {
    return Container(
      padding: MediaQuery.of(context).size.width > 700
          ? EdgeInsets.only(
              top: KSize.loginContentMarginTop / 4,
              left: ScreenUtil().setWidth(100),
              right: ScreenUtil().setWidth(100))
          : EdgeInsets.only(
              top: KSize.loginContentMarginTop / 4,
              left: ScreenUtil().setWidth(60),
              right: ScreenUtil().setWidth(60)),
      child: Column(
        children: <Widget>[
          Form(
              key: key,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                    height: KSize.resetFormColumnHeight,
                    child: TextFormField(
                      controller: _usernameController,
                      //关联焦点
                      focusNode: _usernameFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      //提示文本
                      decoration: InputDecoration(
                        border: ResetTheme.textFieldBorder,
                        enabledBorder: ResetTheme.textFieldEnableBorder,
                        focusedBorder: ResetTheme.textFieldFocusBorder(context),
                        hintText: Translations.of(context)
                            .text('login_page_username_label'),
                        hintStyle: ResetTheme.textFieldTextStyleHint,
                        contentPadding:
                            EdgeInsets.only(left: KSize.commonPadding3),
                      ),
                      style: ResetTheme.textFieldTextStyle,
                      //接收值
                      onSaved: (value) => _username = value,
                      onEditingComplete: _onUserNameKeyboardDoneClick,
                    )),
                Container(
                    margin: EdgeInsets.only(top: KSize.loginFormPaddingTB),
                    height: KSize.resetFormColumnHeight,
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: KSize.resetFormColumnHeight,
                            child: TextFormField(
                              key: Key('codeForm'),
                              //密码框
                              controller: _codeController,
                              focusNode: _codeFocusNode,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.go,
                              maxLength: 6,
                              //提示文本
                              decoration: InputDecoration(
                                border: ResetTheme.textFieldEnableBorder,
                                enabledBorder: ResetTheme.textFieldEnableBorder,
                                focusedBorder:
                                    ResetTheme.textFieldFocusBorder(context),
                                hintStyle: ResetTheme.textFieldTextStyleHint,
                                counterText: '',
                                hintText: Translations.of(context)
                                    .text('reset_password_code'),
                                contentPadding:
                                    EdgeInsets.only(left: KSize.commonPadding3),
                              ),
                              onEditingComplete: _onCodeKeyboardDoneClick,
                              style: ResetTheme.textFieldTextStyle,
                              //接收值
                              onSaved: (value) => _code = value,
                            ),
                          ),
//
                          flex: 4,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: KSize.resetFormColumnHeight,
                            child: FlatButton(
                              child: Text(
                                Translations.of(context)
                                    .text('reset_password_get_code'),
                                style:
                                    TextThemeStore.textStylePrimaryButton_long,
                              ),
                              onPressed: () {
                                _getCodePress();
                              },
                              color: Theme.of(context).buttonColor,
                              highlightColor: Theme.of(context).highlightColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                        ),
                      ],
                    )),
                Offstage(
                  offstage: !_showTip,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: KSize.loginFormPaddingTB * 2),
                    alignment: Alignment.center,
                    child: Text(
                      '${Translations.of(context).text('reset_password_get_code_tip')}${_phoneNumber}',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: KFont.fontSizeTextFieldHint_1,
                          height: 1.3),
                    ),
                  ),
                ),
                _resetButtonSection(),
              ])),
        ],
      ),
    );
  }

  Widget _resetButtonSection() {
    return Container(
        margin: EdgeInsets.only(top: KSize.loginFormPaddingTB * 2),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: SizedBox(
                  height: KSize.resetFormColumnHeight,
                  child: FlatButton(
                      key: Key('resetBtn'),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      onPressed: () {
                        _onResetPress();
                      },
                      color: Theme.of(context).buttonColor,
                      highlightColor: Theme.of(context).highlightColor,
                      child:
                          Text(Translations.of(context).text('reset_password'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: KFont.fontSizeBtn_1,
                              )))))
        ]));
  }

  /// 登录按钮或者密码输入框点击输入完毕操作
  _onCodeKeyboardDoneClick() async {
    FocusScope.of(context).unfocus();
    _onResetPress();
  }

  _onResetPress() async {
    FocusScope.of(context).unfocus();
    if (!_verification(true)) return;
    await showDialog();
    DioManager().request<ResetPasswordModel>(
        httpMethod.GET, NetServicePath.resetPassword, context,
        params: {
          "username": _usernameController.text,
          "randomnum": _randomNumber,
        }, success: (data) async {
      _loadingDialog.hide();
      if (data.result == 'success') {
        //返回登录界面
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.of(context).pop();
        Application.router.navigateTo(context, Routes.root,
            clearStack: true, transition: TransitionType.fadeIn);
        ToastUtil.makeToast('${Translations.of(context).text('reset_password_get_code_tip1')}ameco',gravity: ToastGravity.CENTER);
      } else if (data.result == 'error') {
        ToastUtil.makeToast(data.message);
      }
    }, error: (error) {
      _loadingDialog.hide();
      ToastUtil.makeToast(error.message);
    }).whenComplete(() {
      _loadingDialog.hide();
    });
  }

  _getCodePress() async {
    FocusScope.of(context).unfocus();
    if (!_verification(false)) return;
    setState(() {
      _showTip = false;
    });
    await showDialog();
    DioManager().request<GetSmsCodeModel>(
        httpMethod.GET, NetServicePath.getSMSCode, context,
        params: {
          "username": _usernameController.text,
        }, success: (data) async {
      _loadingDialog.hide();
      if (data.result == 'success') {
        setState(() {
          _phoneNumber = data.phonenum;
          _randomNumber = data.randomnum;
          setState(() {
            _showTip = true;
          });
        });
      } else if (data.result == 'error') {
        ToastUtil.makeToast(data.message);
      }
    }, error: (error) {
      _loadingDialog.hide();
      ToastUtil.makeToast(error.message);
    }).whenComplete(() {
      _loadingDialog.hide();
    });
  }

  bool _verification(bool isCommit) {
    //1、验空
    String account = _usernameController.text;
    if (account.trim().length == 0) {
      ToastUtil.makeToast(
          Translations.of(context).text('login_page_username_validator_fail'));
      return false;
    }
    if (isCommit) {
      String code = _codeController.text;
      if (code.trim().length != 6) {
        ToastUtil.makeToast(
            Translations.of(context).text('reset_password_code_fail'));
        return false;
      }
    }
    return true;
  }

  /// 用户名输入框点击输入完毕操作
  void _onUserNameKeyboardDoneClick() {
    _usernameFocusNode.unfocus();
  }
}
