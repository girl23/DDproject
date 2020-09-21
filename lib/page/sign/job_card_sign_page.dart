import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/config/global.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/model/user_model.dart';
import 'package:lop/network/network_config.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class JobCardSignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JobCardSignPageState();
}

class _JobCardSignPageState extends State<JobCardSignPage> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  static UserModel _userModel;
  static JcSignModel _jcSignModel;
  @override
  void initState() {
    _userModel = Provider.of<UserViewModel>(context, listen: false).info;
    _jcSignModel = Provider.of<JcSignModel>(context, listen: false);
    print("job-card-sign-page jcId:${_jcSignModel.jcId}");
//    _jcSignModel = new JcSignModel();
//    _jcSignModel.jcId = 90007183;

    super.initState();

    //调用原生初始化签名API
    _invokeNativeMethod('initApi',
        '${_userModel.userId}:${_userModel.realName}:${_jcSignModel.jcId}');

    Global.signMessageChannel.setMessageHandler(_receiveHandler);

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      //页面加载完成
      if (state.type == WebViewState.finishLoad) {
        //通知webview这是来自flutter的调用，为了兼容react
        flutterWebViewPlugin.evalJavascript('fromFlutter=true;');
        /*var givenJS = rootBundle.loadString('assets/fonts/TIMES.TTF');
            givenJS.then((String js) {
              flutterWebViewPlugin.evalJavascript(js);
            });*/
      }
    });
  }

  @override
  void dispose() {
    _onStateChanged.cancel();
    flutterWebViewPlugin?.dispose();
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return new Text('ss');
    return _showWebViewPlugin();
  }

  Widget _showWebViewPlugin() {
    //获取登录状态
    String url =
        '${NetworkConfig.getServerUrl()}${_jcSignModel.isJobType?NetServicePath.keyJobGetJcHtmlPage:NetServicePath.getJcHtmlPage}?jcid=${_jcSignModel.jcId}&esign=${_jcSignModel.isSign}&userid=${_userModel.userId}&token=${_userModel.token}&udfuserid=${_userModel.userId}';
    //url = 'https://www.baidu.com/';
    print(url);
    return WebviewScaffold(
      url: url,
      javascriptChannels: _jsChannels,
      appBar: PreferredSize(
        child: new AppBar(
          title: new Center(
            child: new Text(_jcSignModel.signTitle,
                style: TextThemeStore.textStyleAppBar),
          ),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  flutterWebViewPlugin.reload();
                }),
          ],
        ),
        preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
      ),
      useWideViewPort: _jcSignModel.isJobType,
      displayZoomControls: false,
      withOverviewMode: true,
      withZoom: true,
      clearCache: true,
      hidden: true,
      withJavascript: true
    );
  }

  ///调用原生方法
  ///method 原生方法名
  ///args 发送原生的参数
  static void _invokeNativeMethod(String methodName, dynamic args) async {
//    if (Platform.isIOS) {
//      //IOS未实现
//      return;
//    }
    try {
      var result =
          await Global.signMethodChannel.invokeMethod(methodName, args);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  final Set<JavascriptChannel> _jsChannels = [
    JavascriptChannel(
        name: 'flutterSign',
        onMessageReceived: (JavascriptMessage message) {
          _signOperation(message.message);
        }),
    JavascriptChannel(
        name: 'flutterDialog',
        onMessageReceived: (JavascriptMessage message) {
          ToastUtil.makeToast(message.message,toastType: ToastType.ERROR,gravity: ToastGravity.CENTER);
        })
  ].toSet();
   static void _signOperation(String message) {
    print(message);

    var dataArr = message.toString().split(':');

    if (dataArr[0] == 'esign' || dataArr[0] == 'modifyesign') {
      //电签或修改签署
      if (dataArr[1] == 'jcid') {
        //完工签署
        _jcSignModel.signType = 'jc';

        _invokeNativeMethod('show', 'jcid:${dataArr[2]}');

        return;
      }
      _jcSignModel.signType = 'pos';
      _jcSignModel.posId = dataArr[1];
      _jcSignModel.signId = dataArr[2];
      _jcSignModel.location = dataArr[3];
      //工序签署
      //posid:jcid:posid:signid
      int now = new DateTime.now().millisecondsSinceEpoch;
      print("时间输出，点击进行签名功能Flutter——>Native: ${now}");
      _invokeNativeMethod(
          'show', 'posid:${_jcSignModel.jcId}:${dataArr[1]}:${dataArr[2]}');

      return;
    }

    //删除签署
    if (dataArr[0] == 'deleteesign') {
      _deleteSign('delpossign', dataArr[2], dataArr[3]);
    }
  }

  ///接收原生消息
  ///message 为json格式{'eventName':'','eventData':''}
  Future<dynamic> _receiveHandler(dynamic message) async {
    print(message);
    var json = jsonDecode(message);
    String eventName = json['eventName'];
    String eventData = json['eventData'];

    switch (eventName) {
      case 'AndroidToRNMessage':
      case 'iOSToRNMessage':
        _successSign(eventData);
        break;
      case 'ErrorToRNMessage':
        _errorSign(eventData);
        break;
      case 'AndroidToRNMessageLog':
      case 'iOSToRNMessageLog':
        print(message);
        break;
      case 'AndroidDeleteSign':
      case 'iOSDeleteSign':
        flutterWebViewPlugin
            .evalJavascript("receiveFlutterMsg('${eventData}')");
        break;
    }
    ;
    return 'Receive Success';
  }

  void _successSign(String eventData) {
    //完工签署
    if(_jcSignModel.signType == "jc"){
      //调用js方法
      flutterWebViewPlugin.evalJavascript(
          "receiveFlutterMsg('base64:jcid:$eventData')");
      Provider.of<TaskDetailStateProvide>(context, listen: false)
          .updateTaskDetail(context);
      return;
    }

    //工序签署
    if (_jcSignModel.location.indexOf(',') > 0) {
      //批签。有位置顺序
      var locationArr = _jcSignModel.location.split(',');
      var signIdArr = _jcSignModel.signId.split(',');
      for (var i = 0; i < locationArr.length; i++) {
        //调用js方法
        flutterWebViewPlugin.evalJavascript(
            "receiveFlutterMsg('base64:${signIdArr[i]}:${eventData}:${locationArr[i]}')");
      }
    } else {
      //单签
      //调用js方法
      flutterWebViewPlugin.evalJavascript(
          "receiveFlutterMsg('base64:${_jcSignModel.signId}:${eventData}:${_jcSignModel.location}')");
    }
  }

  void _errorSign(String eventData) {
     print("_errorSign :${_jcSignModel.signType}");
    if (_jcSignModel.signType == 'jc') {
      flutterWebViewPlugin.evalJavascript("receiveFlutterMsg('error:jcid')");

      //'error:jcid'
    } else if (_jcSignModel.signType == 'pos') {
      flutterWebViewPlugin.evalJavascript(
          "receiveFlutterMsg('error:${_jcSignModel.location}')");

      //'error:${_jcSignModel.location}'
    }
  }

  static void _deleteSign(
      String delType, String signId, String location) async {
    DioManager()
        .request(httpMethod.GET, NetServicePath.delSignData, null, params: {
      "jcid": _jcSignModel.jcId,
      'signid': signId,
      'userid': _userModel.userId,
      'signtype': delType,
      "udfuserid": _userModel.userId,
      "token": _userModel.token
    }, success: (data) {
      print(data);
      if (data['result'] == 'success') {
        _invokeNativeMethod('deleteSign', 'deleteesign:${signId}:${location}');
        //deleteesign:${signId}:${location}
      } else {
        _invokeNativeMethod('deleteSign', 'error:${location}');
        //error:${location}
        _invokeNativeMethod('toastShow', data['info']);
      }
    });
  }
}
