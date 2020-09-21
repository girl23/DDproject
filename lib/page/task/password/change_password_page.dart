import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/style/index.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/utils/translations.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/viewmodel/change_password_viewmodel.dart';

class ChangePasswordPage extends StatefulWidget {
  final String comeFromLogin;
  ChangePasswordPage(this.comeFromLogin);
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  GlobalKey _formKey = new GlobalKey<FormState>();
  String oldPwd;
  String newPwd;
  String ensurePwd;

  FocusNode _oldPwdFocusNode = new FocusNode();
  FocusNode _newPwdFocusNode = new FocusNode();
  FocusNode _ensureNewPwdFocusNode = new FocusNode();

  TextEditingController _oldPwdController = new TextEditingController();
  TextEditingController _newPwdController = new TextEditingController();
  TextEditingController _ensureNewPwdController = new TextEditingController();

  bool _isShowPassWord=false;
  bool _isShowPassWord1=false;
  bool _isShowPassWord2=false;

  bool _isShowClear = false;
  bool _isShowClear1 = false;
  bool _isShowClear2 = false;

  ChangePasswordViewModel _changePasswordViewModel;

  @override
  void initState() {
    //设置焦点监听
    _oldPwdFocusNode.addListener(_focusNodeListener);
    _newPwdFocusNode.addListener(_focusNodeListener);
    _ensureNewPwdFocusNode.addListener(_focusNodeListener);

    _oldPwdController.addListener(() {
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_oldPwdController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
    _newPwdController.addListener((){
      if (_newPwdController.text.length > 0) {
        _isShowClear1 = true;
      } else {
        _isShowClear1 = false;
      }
      setState(() {});
    });

    _ensureNewPwdController.addListener((){
      if (_ensureNewPwdController.text.length > 0) {
        _isShowClear2 = true;
      } else {
        _isShowClear2 = false;
      }
      setState(() {});
    });
    _changePasswordViewModel=Provider.of<ChangePasswordViewModel>(context,listen: false);

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _oldPwdFocusNode.removeListener(_focusNodeListener);
    _newPwdFocusNode.removeListener(_focusNodeListener);
    _ensureNewPwdFocusNode.removeListener(_focusNodeListener);

    _oldPwdController.dispose();
    _newPwdController.dispose();
    _ensureNewPwdController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_oldPwdFocusNode.hasFocus) {
      _newPwdFocusNode.unfocus();
      _ensureNewPwdFocusNode.unfocus();
    }
    if (_newPwdFocusNode.hasFocus) {
      _oldPwdFocusNode.unfocus();
      _ensureNewPwdFocusNode.unfocus();
    }
    if (_ensureNewPwdFocusNode.hasFocus) {
      _newPwdFocusNode.unfocus();
      _oldPwdFocusNode.unfocus();
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
//              leading: IconButton(onPressed: (){
//
//                if(widget.comeFromLogin=='1'){
//                  Navigator.of(context).pop();
//                  Application.router.navigateTo(context, "/task", transition: TransitionType.fadeIn);
//                }else{
//                  Navigator.of(context).pop();
//                }
//              }, icon:Icon(Icons.arrow_back_ios) ),
              title: new Text(
                Translations.of(context).text('change_password_page_title'),
//          '修改密码',
                style: TextThemeStore.textStyleAppBar,
              ),
              centerTitle: true,
            ),
            preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _form(context,_formKey),
              ],
            ),
          )),
    );
  }

  //网络请求
  void change(String oldPwd, String newPwd) async {
    //初始化进度条
    ProgressDialog _loadingDialog =
        LoadingDialogUtil.createProgressDialog(context);
    //显示hud
    await _loadingDialog.show();
   bool isSuccess= await _changePasswordViewModel.change(oldPwd, newPwd);
   if(isSuccess){
     //返回登录界面
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop();
      //退出登录,情况登录状态
      Provider.of<UserViewModel>(context, listen: false).clear();
      Application.router.navigateTo(context, Routes.root,
            clearStack: true, transition: TransitionType.fadeIn);
     _loadingDialog.hide();
   }else{
     _loadingDialog.hide();
   }
  }

  //修改按钮
  Widget _changeButton(GlobalKey key, BuildContext context) {
    return Container(
//      color:  Colors.green,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
      width: MediaQuery.of(context).size.width,
      height: KSize.changePasswordBtnHeight,

      child: FlatButton(
        child: Text(
          Translations.of(context).text('change_password_page_changeButton'),
          style: TextThemeStore.textStylePrimaryButton_long,
        ),
        onPressed: () {
         validationCommit(key);
        },
        color: Theme.of(context).buttonColor,
        highlightColor: Theme.of(context).highlightColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
  void validationCommit(GlobalKey key){
    //在这里不能通过此方式获取FormState，context不对
    //print(Form.of(context));
    oldPwd=_oldPwdController.text;
    newPwd=_newPwdController.text;
    ensurePwd=_ensureNewPwdController.text;
    // 通过_formKey.currentState 获取FormState后，
    // 调用validate()方法校验用户名密码是否合法，校验
    // 通过后再提交数据。
    if ((key.currentState as FormState).validate()) {
      //验证通过提交数据
      _oldPwdFocusNode.unfocus();
      _newPwdFocusNode.unfocus();
      _ensureNewPwdFocusNode.unfocus();
      //检测密码格式 -正则表达式
      if(oldPwd.length<0){
        ToastUtil.makeToast(Translations.of(context)
            .text('change_password_page_alertMsg0'));
        return;
      }
      if(newPwd.length<0){
        ToastUtil.makeToast(Translations.of(context)
            .text('change_password_page_alertMsg1'));
        return;
      }
      if(ensurePwd.length<0){
        ToastUtil.makeToast(Translations.of(context)
            .text('change_password_page_alertMsg2'));
        return;
      }
      if(newPwd!=ensurePwd){
        ToastUtil.makeToast(Translations.of(context)
            .text('change_password_page_alertMsg3'));
        return;
      }
      RegExp exp1 = RegExp(
          r"^(?=.*\d)(?=.*[a-zA-Z])(?=.*[`·+=⟪⟫«»‘’‛‟,‚„′″´˝❛❜'｜\\\/\[\]\{\}<《》>。¡¿⸘‽“”‘’‛‟.„′″´˝^°¸˛¨`˙˚ªº…:;&_¯­–‑—§#⁊†¶‡@‰‱¦|/\ˉˆ❛❜❝❞€¥¢£₽₩₹฿₵₤₺₮₱₭₴₦₹₲₪₡₫៛₢₸₤₳₥₣₰₧₯₶₷~,!@#\$%\^&\.\?\*\(\)`-]).{8,}$");
      bool matched1 = exp1.hasMatch(newPwd);
      //判断密码强度
      RegExp exp = RegExp(
          r'^(?=.*\d)(?=.*[a-zA-Z])(?=.*[`·+=⟪⟫«»‘’‛‟,‚„′″´˝❛❜｜\\\/\[\]\{\}<　《》>。¡¿⸘‽“”‘’‛‟.„"′″´˝^°¸˛¨`˙˚ªº…:;&_¯­–‑—§#⁊†¶‡@‰‱¦|/\ˉˆ❛❜❝❞€¥¢£₽₩₹฿₵₤₺₮₱₭₴₦₹₲₪₡₫៛₢₸₤₳₥₣₰₧₯₶₷~,!@#\$%\^&\.\?\*\(\)`-]).{8,}$');
      bool matched = exp.hasMatch(newPwd);
      //跳转登录成功页面
      if(matched||matched1){
//              change(context, oldPwd, newPwd);
        change(oldPwd, newPwd);
      } else {
        ToastUtil.makeToast(Translations.of(context)
            .text('change_password_page_requireMsg1') +
            Translations.of(context)
                .text('change_password_page_requireMsg2'));
        return;
      }
    }
  }
  //表单
  Widget _form(BuildContext context,GlobalKey key) {

    return Container(
      padding: MediaQuery.of(context).size.width > 700
          ? EdgeInsets.only(top:ScreenUtil().setHeight(60), left:ScreenUtil().setWidth(100),right:ScreenUtil().setWidth(100))
          : EdgeInsets.only(top:ScreenUtil().setHeight(20),left:ScreenUtil().setWidth(60),right:ScreenUtil().setWidth(60)),
      child: Form(
        key: _formKey, //设置globalKey，用于后面获取FormState
        autovalidate: true,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            titleWidget(Translations.of(context)
                .text('change_password_page_oldPwd'),KFont.fontSizeItem_2,Colors.grey),
            _textField(_oldPwdFocusNode, _oldPwdController, _isShowPassWord,_isShowClear,key),
            SizedBox(
              height: 20,
            ),
            titleWidget(Translations.of(context)
                .text('change_password_page_newPwd'),KFont.fontSizeItem_2,Colors.grey),
            _textField(_newPwdFocusNode, _newPwdController, _isShowPassWord1,_isShowClear1,key),

            SizedBox(
              height: 10,
            ),
            titleWidget(Translations.of(context)
                .text('change_password_page_requireMsg'),KFont.fontSizeItem_3,Colors.grey),
            SizedBox(
              height: 15,
            ),
            titleWidget(Translations.of(context)
                .text('change_password_page_ensurePwd'),KFont.fontSizeItem_2,Colors.grey),
            _textField(_ensureNewPwdFocusNode, _ensureNewPwdController, _isShowPassWord2,_isShowClear2,key),
            _changeButton(_formKey, context)
          ],
        ),
      ),
    );
  }

  Widget _textField(FocusNode node,TextEditingController controller,bool isShow,bool isShowClear,GlobalKey key){
    return  Stack(
      children: <Widget>[
            Positioned(child:
            TextFormField(
              focusNode: node,
              autofocus: false,
              controller: controller,
              obscureText: !isShow,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                filled:true,
                fillColor: KColor.textColor_f5,
                  contentPadding:EdgeInsets.only(left: 12, top: 0,bottom: 0,right: 20),
                enabledBorder: OutlineInputBorder(
                  /*边角*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(4), //边角
                  ),
                  borderSide: BorderSide(
                    color: KColor.borderColor, //边线颜色
                    width: 0.5, //边线宽度
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4), //边角
                    ),
                    borderSide: BorderSide(
                      color: KColor.borderColor, //边框颜色
                      width: 0.5, //宽度
                    )),

                suffixIcon: new IconButton(
                    icon: new Icon(
                      (isShow)
                          ? Icons.visibility
                          : Icons.visibility_off,
                      //                          color: Theme.of(context).primaryColor,
                      size: KSize.loginFormTextFieldPreSubIconSize,
                    ),
                    onPressed:(){
                      if(controller==_oldPwdController){
                        _isShowPassWord=!_isShowPassWord;
                      }else if(controller==_newPwdController){
                        _isShowPassWord1=!_isShowPassWord1;
                      }else{
                        _isShowPassWord2=!_isShowPassWord2;
                      }
                      setState(() {

                      });

                    }
                ),


              ),
              inputFormatters:controller==_newPwdController? [LengthLimitingTextInputFormatter(20)]:[],
              onEditingComplete: (){
                if(controller==_oldPwdController){
                  _oldPwdFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_newPwdFocusNode);
                  _ensureNewPwdFocusNode.unfocus();
                }else if(controller==_newPwdController){
                  _oldPwdFocusNode.unfocus();
                  _newPwdFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_ensureNewPwdFocusNode);
                }else{
                  _oldPwdFocusNode.unfocus();
                  _newPwdFocusNode.unfocus();
                  _ensureNewPwdFocusNode.unfocus();
                  validationCommit(key);
                }
              },
            )
            ),
            Positioned(right:ScreenUtil().setWidth(80),top:ScreenUtil().setWidth(0),child:(isShowClear)? IconButton(
                icon: Icon(
                  Icons.clear,
                  size: KSize.loginFormTextFieldPreSubIconSize,
                  color:Colors.grey,
                ),
                onPressed: () {
                  //清空输入框
                controller.clear();
                if(controller==_oldPwdController){
                  _isShowClear=false;
                }else if(controller==_newPwdController){
                  _isShowClear1=false;
                }else{
                  _isShowClear2=false;
                }
                }

            ):Text(''),),

      ],
    );

  }
}

Widget titleWidget(String title,double fontSize,Color color){
  return Container(
//    color: Colors.red,
    padding: EdgeInsets.only(bottom: 5),
    alignment: Alignment.centerLeft,
      child:  Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          color: color
        ),
      ),
    );
}


