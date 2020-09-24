import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/model/jobcard/xml_parse.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../config/global.dart';
import '../page/base/base_stful_page.dart';
import '../router/routes.dart';
import '../style/index.dart';
import '../style/size.dart';
import '../style/theme/login_theme.dart';
import '../utils/loading_dialog_util.dart';
import '../utils/toast_util.dart';
import '../utils/translations.dart';
import '../viewmodel/user_viewmodel.dart';
import 'package:lop/model/jc_sign_model.dart';
import '../router/application.dart';
import 'package:fluro/fluro.dart';


// ignore: must_be_immutable
class LoginPage extends BaseStfulPage<UserViewModel> {
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  ProgressDialog _loadingDialog;
  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isShowPassWord = false;
  bool _isShowClear = false;

  String _userName;//用户名
  String _password;//密码
  String _version;
  var _subscription;
  bool _showingUpdate = false;
  bool _isUpdateing = false;
  @override
  Widget buildWidget(BuildContext context) {

    return new GestureDetector(
        //点击空白处收回虚拟键盘
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            //虚拟键盘不遮挡TextFormField
            resizeToAvoidBottomInset: true,
            //SafeArea让内容在安全的可见区域，避免屏幕有刘海或凹槽
            body:
                //SingleChildScrollView,避免弹出按钮时，出现overFlow现象
                SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.only(top: KSize.commonSplitHeight1 * 2),
                        //背景图
                        decoration: new BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/bg_login.jpg"),
                          fit: BoxFit.cover,
                        )),
                        //内容区域
                        child: _contentHoleWidget()))));
  }

  @override
  UserViewModel getViewModel() {
    return Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  void initData() {
    _userNameController.text = Global.userName??"";
    _loadVersionInfo();
  }

  @override
  void initListener() {
    _usernameFocusNode.addListener(_focusNodeListener);
    _passwordFocusNode.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
    //监测网络变化
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
//mobile
        if (_isUpdateing == false && _showingUpdate == false) {
          _checkVersion();
        }
      } else if (result == ConnectivityResult.wifi) {
//wifi
        if (_isUpdateing == false && _showingUpdate == false) {
          _checkVersion();
        }
      } else {
        //无网络
      }
    });
  }

  Future<Null> _focusNodeListener() async {
    // 取消密码框的焦点状态
    _usernameFocusNode.hasFocus?_passwordFocusNode.unfocus():null;
    // 取消用户名框焦点状态
    _passwordFocusNode.hasFocus?_usernameFocusNode.unfocus():null;
  }

  @override
  void removeListener() {
    _usernameFocusNode.removeListener(_focusNodeListener);
    _passwordFocusNode.removeListener(_focusNodeListener);
    _userNameController.dispose();
    _passwordController.dispose();
  }

  void _loadVersionInfo() {
    if (Global.version != null) {
      if(Global.channel == 'loptest1' || Global.channel == 'loptest2'){
        _version = 'Version ${Global.version} 测试';
      }else{
        _version = 'Version ' + Global.version;
      }

      if (_isUpdateing == false && _showingUpdate == false) {
        _checkVersion();
      }
    }
  }

  // 检查版本
  Future<void> _checkVersion() async {
    _isUpdateing = true;
    String platform = Platform.isIOS?"ios":Platform.isAndroid?"android":"unknown";
    _showingUpdate = await viewModel.checkVersion(platform, Global.version);
    _isUpdateing = false;
  }

  ///点击控制密码是否显示
  void _showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  /// 用户名输入框点击输入完毕操作
  void _onUserNameKeyboardDoneClick() {
    _usernameFocusNode.unfocus();
    _passwordFocusNode.requestFocus();
  }

  /// 登录按钮或者密码输入框点击输入完毕操作
  void _onLoginButtonOrPasswordKeyboardDoneClick() {
    FocusScope.of(context).unfocus();
    _login(context);
  }

  Widget _contentHoleWidget() {
    return Container(
        margin: EdgeInsets.only(
            top: KSize.loginContentMarginTop,
            bottom: KSize.loginContentMarginBottom,
            left: KSize.loginContentMarginLR,
            right: KSize.loginContentMarginLR),
        child: Column(children: <Widget>[
          ///标题
          _appNameWidget(),
          ///账号、密码输入框
          loginFormSection(),
          //登录按钮框
          loginButtonSection(),
          //设置
          settingSection(),
          //空白：占位，将版本号强制推到底部
          Expanded(child: Container()),
          Text("$_version",
              style: TextStyle(
                color: Colors.white,
                fontSize: KFont.fontSizeCommon_2,
              ))
        ]));
  }

  void _login(BuildContext context) async {
    //用户名密码校验 暂时关闭
    if (!_verification()) return;
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialogUtil.createProgressDialog(context);
    }
    await _loadingDialog.show();
    //验证Form的状态
    _loginKey.currentState.save();

    //请求登录
    Global.userId = null;
    Global.token = null;
    bool success =
        await viewModel.login(_userName, _password, Global.macAddress);
    if (success) {
      _loadingDialog.hide().whenComplete(() {
        _passwordController.clear();
        //跳转登录成功页面
//        navigateToPageFadeIn("/task");
        //判断密码强度
        RegExp exp1 = RegExp(
            r"^(?=.*\d)(?=.*[a-zA-Z])(?=.*[`·+=⟪⟫«»‘’‛‟,‚„′″´˝❛❜'｜\\\/\[\]\{\}<《》>。¡¿⸘‽“”‘’‛‟.„′″´˝^°¸˛¨`˙˚ªº…:;&_¯­–‑—§#⁊†¶‡@‰‱¦|/\ˉˆ❛❜❝❞€¥¢£₽₩₹฿₵₤₺₮₱₭₴₦₹₲₪₡₫៛₢₸₤₳₥₣₰₧₯₶₷~,!@#\$%\^&\.\?\*\(\)`-]).{8,}$");
        bool matched1 = exp1.hasMatch(_password);
        //判断密码强度
        RegExp exp = RegExp(
            r'^(?=.*\d)(?=.*[a-zA-Z])(?=.*[`·+=⟪⟫«»‘’‛‟,‚„′″´˝❛❜｜\\\/\[\]\{\}<　《》>。¡¿⸘‽“”‘’‛‟.„"′″´˝^°¸˛¨`˙˚ªº…:;&_¯­–‑—§#⁊†¶‡@‰‱¦|/\ˉˆ❛❜❝❞€¥¢£₽₩₹฿₵₤₺₮₱₭₴₦₹₲₪₡₫៛₢₸₤₳₥₣₰₧₯₶₷~,!@#\$%\^&\.\?\*\(\)`-]).{8,}$');
        bool matched = exp.hasMatch(_password);
        //跳转登录成功页面
//        if(matched||matched1|| Global.channel == 'loptest1' || Global.channel == 'loptest2'){
          //强度够跳转首页
          Application.router
              .navigateTo(context, "/task", transition: TransitionType.fadeIn);
//        }else{
////            强度不够跳转到密码修改界面
//          showDialog(
//            context: context,
//            barrierDismissible: true, // user must tap button!
//            builder: (BuildContext context) {
//              return
//                AlertDialog(
//                  titlePadding:EdgeInsets.all(20) ,
//                  contentPadding: EdgeInsets.only(right: 20,left: 20),
//                  title: Text(
//                      Translations.of(context).text('force_alert'),
//                      textAlign: TextAlign.center,
//                      style: TextStyle(fontSize: 18,color: Colors.black54)),
//                  content: Text(
//                    Translations.of(context).text('force_content'),
//                    textAlign: TextAlign.center,
//                    style: TextStyle(fontSize: 16,color: Colors.black38),
//                  ),
//                  actions:<Widget>[
//                    FlatButton(
//                      child: Text(Translations.of(context).text('force_sure')),
//                      onPressed: (){
//                        Navigator.of(context).pop();
//                        Application.router
//                            .navigateTo(context, "/task/password/"+"1", transition: TransitionType.fadeIn);
//                      },
//                    ),
//                  ],
//                  // 设置成 圆角
//                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                );
//            },
//          );
//
//        }
      });
    } else {
      _loadingDialog.hide();
    }
  }

  bool _verification() {
    //1、验空
    String account = _userNameController.text;
    if (account.trim().length == 0) {
      ToastUtil.makeToast(
          getTranslationsText('login_page_username_validator_fail'));
      return false;
    }
    String pwd = _passwordController.text;
    if (pwd.trim().length == 0) {
      ToastUtil.makeToast(
          getTranslationsText('login_page_password_validator_fail_empty'));
      return false;
    }
//    if (pwd.trim().length < 6) {
//      ToastUtil.makeToast(
//          Translations.of(context).text('login_page_password_validator_fail'));
//      return false;
//    }

//    2、验证密码格式,登录不验证密码格式
//     RegExp reg = RegExp(r'^[\d\w]{8}$');
//     if(!reg.hasMatch(pwd.trim())){
//       toastShow(Translations.of(context).text('change_password_page_requireMsg2'));
//       return false;
//     }
    return true;
  }
  //主标题
  Widget _appNameWidget() {
    return Container(
        margin: EdgeInsets.only(bottom: KSize.loginTitleMarginBottom),
        child: Center(
          child: _appNameImage(),
        ));
  }

  Widget _appNameImage() {
    Locale locale = Translations.of(context).locale;
    if ("en" == locale.languageCode) {
      //英文
      return Image.asset("assets/images/app_name_en.png",
          width: ScreenUtil().setWidth(925), fit: BoxFit.fitWidth);
    }
    return Image.asset("assets/images/app_name_cn.png",
        width: ScreenUtil().setWidth(651), fit: BoxFit.fitWidth);
  }

  //登陆表单
  Widget loginFormSection() {
    return new Container(
        child: Form(
            key: _loginKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  height: KSize.loginFormClumnHeight,
                  child:
                      Consumer<UserViewModel>(builder: (context, user, child) {
                    return TextFormField(
                      controller: _userNameController,
                      //关联焦点
                      focusNode: _usernameFocusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      //提示文本
                      decoration: InputDecoration(
                        border: LoginTheme.textFieldEnableBorder,
                        enabledBorder: LoginTheme.textFieldEnableBorder,
                        focusedBorder: LoginTheme.textFieldFocusBorder,
                        hintText:
                            getTranslationsText('login_page_username_label'),
                        hintStyle: LoginTheme.textFieldTextStyleHint,
                        prefixIcon:
                            _textFieldPrefixIcon("assets/images/account.png"),
                        suffixIcon: (_isShowClear)
                            ? _textFieldSuffixIconUserName()
                            : null,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      style: LoginTheme.textFieldTextStyle,

                      //接收值
                      onSaved: (value) => _userName = value,
                      onEditingComplete: _onUserNameKeyboardDoneClick,
                    );
                  })),
              Container(
                  margin: EdgeInsets.only(top: KSize.loginFormPaddingTB),
                  height: KSize.loginFormClumnHeight,
                  child: TextFormField(
                    //密码框
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.go,
                    //提示文本
                    decoration: InputDecoration(
                        border: LoginTheme.textFieldEnableBorder,
                        enabledBorder: LoginTheme.textFieldEnableBorder,
                        focusedBorder: LoginTheme.textFieldFocusBorder,
                        hintStyle: LoginTheme.textFieldTextStyleHint,
                        hintText:
                            getTranslationsText('login_page_password_label'),
                        prefixIcon:
                            _textFieldPrefixIcon("assets/images/password.png"),
                        contentPadding: EdgeInsets.all(0),
                        suffixIcon: _textFieldSuffixIconPassword()),
                    onEditingComplete:
                        _onLoginButtonOrPasswordKeyboardDoneClick,

                    style: LoginTheme.textFieldTextStyle,
                    obscureText: !_isShowPassWord,
                    //接收值
                    onSaved: (value) => _password = value,
                  ))
            ])));
  }

  /// 输入框前面的图标
  Widget _textFieldPrefixIcon(String imageName) {
    return Container(
        padding: LoginTheme.textFieldPrefixIconPadding,
        child: ImageIcon(AssetImage(imageName), color: Colors.white));
  }

  Widget _textFieldSuffixIconUserName() {
    return IconButton(
        padding: EdgeInsets.only(right: KSize.loginTextFieldSuffixPaddingRight),
        icon: Icon(Icons.clear,
            size: KSize.loginFormTextFieldPreSubIconSize, color: Colors.white),
        onPressed: () {
          //清空输入框
          _userNameController.clear();
        });
  }

  Widget _textFieldSuffixIconPassword() {
    return IconButton(
        padding: EdgeInsets.only(right: KSize.loginTextFieldSuffixPaddingRight),
        icon: Icon(
          (_isShowPassWord) ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
          size: KSize.loginFormTextFieldPreSubIconSize,
        ),
        onPressed: _showPassWord);
  }

  //登录按钮
  Widget loginButtonSection() {
    return Container(
        margin: EdgeInsets.only(top: KSize.loginFormPaddingTB * 3),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: SizedBox(
                  height: KSize.loginFormClumnHeight,
                  child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            KSize.loginFormClumnHeight * 0.5),
                      ),
                      onPressed: () {
                        _onLoginButtonOrPasswordKeyboardDoneClick();
                      },
                      color: KColor.buttonLoginColor,
                      highlightColor: KColor.buttonLoginHighlight,
                      child:
                          Text(getTranslationsText('login_page_login_button'),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: KFont.fontSizeBtn_1,
                              )))))
        ]));
  }

  //系统设置和忘记密码
  Widget settingSection() {
    return new Container(
        margin: EdgeInsets.only(top: KSize.loginFormPaddingTB * 2),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: GestureDetector(
                      onTap: () async{
////                        navigateToPageFadeIn(Routes.settingPage);
////                      navigateToPageFadeIn('/jobCard/'+'工卡模块化页面');
////                        navigateToPageFadeIn('jobCard/modulesign'+'工卡模块化页面');
//                        Provider.of<JcSignModel>(context, listen: false).jcId =
//                           22;
//                        Provider.of<JcSignModel>(context, listen: false).isJobType =false;
//                        Provider.of<JcSignModel>(context, listen: false).isSign = 1;
//                        Provider.of<JcSignModel>(context, listen: false).signTitle = '签名';
////                        var model = await XMLParse().parseXmlFile("assets/testxml/protocol_v1_3.xml");
////                       Provider.of<JcSignModel>(context, listen: false).jobCardModel = model;
//
//                      navigateToPageFadeIn(Routes.jobCardModulePage);

                        navigateToPageFadeIn(Routes.temporaryDDListPage);
                      },
                      child:
                          Text(getTranslationsText("login_page_system_setting"),
                              style: new TextStyle(
                                fontSize: KFont.fontSizeBtn_3,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              )))),
              Container(
                child: GestureDetector(
                    onTap: () {
//                      Application.router.navigateTo(
//                          context, '/reset/${_userNameController.text??''}',
//                          transition: TransitionType.fadeIn);

                      navigateToPageFadeIn(Routes.dDListPage);
                    },
                    child: Text(
                        Translations.of(context).text('login_page_forget_password'),
                        style: new TextStyle(
                          fontSize: KFont.fontSizeBtn_3,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ))),
              ),
            ]));
  }


}
