import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/button_theme.dart';
import 'package:lop/utils/toast_util.dart';
//import 'package:lop/utils/toast_util.dart';
//import 'package:ota_update/ota_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateVersion {
  final String appUrl;
  final String versionName;
  final String content;
  final bool isForce;

  UpdateVersion(
      {this.appUrl, this.versionName, this.content,this.isForce = true});
}

class UpdateVersionDialog extends StatefulWidget {
  final UpdateVersion data;

  UpdateVersionDialog({Key key, this.data}) : super(key: key);

  @override
  _UpdateVersionDialogState createState() => _UpdateVersionDialogState();
}

class _UpdateVersionDialogState extends State<UpdateVersionDialog> with WidgetsBindingObserver{
  static const channelName = 'plugins.com.ameco.lop/update_version';
  static const stream = const EventChannel(channelName);
  // 进度订阅
  StreamSubscription downloadSubscription;
  bool _isUpdating = false;
  int percent = 0;
  String buttonText = "立即升级";
  _updateButtonTap(BuildContext context) async {
    if (Platform.isIOS) {
      final url = widget.data.appUrl;
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false);
      } else {
        throw 'Could not launch $url';
      }
    } else if (Platform.isAndroid) {
      androidDownloadHandle();
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      //print('应用程序可见并响应用户输入 resumed');
        if(percent >= 100){
          _isUpdating = false;
          setState(() {
            percent = 0;
          });
        }
        break;
      case AppLifecycleState.inactive:
      //print('应用程序处于非活动状态，并且未接收用户输入 处于这种状态的组件假设它们随时都会暂停 inactive');
        break;
      case AppLifecycleState.paused:
      //print('应用程序不可见，后台 paused');
        break;
      case AppLifecycleState.detached:
      //print('这个状态是444...可能是断网了 detached。');
        break;
      default:
    }
  }
//  Future<void> tryOtaUpdate() async {
//    try {
//      OtaUpdate()
//          .execute(widget.data.appUrl, destinationFilename: 'lop_release_${widget.data.versionName}.apk')
//          .listen(
//            (OtaEvent event) {
//          setState((){
//            if(event.status == OtaStatus.DOWNLOADING){
//              print("value:${event.value}");
//              percent = (double.tryParse(event.value) / 100).round();
//              buttonText = "正在升级:${event.value}%";
//            }else if(event.status == OtaStatus.INSTALLING){
//              percent = 100;
//              buttonText = "安装中";
//            }else if(event.status == OtaStatus.DOWNLOAD_ERROR){
//              percent = 0;
//              ToastUtil.makeToast("下载失败!",toastType: ToastType.ERROR,gravity: ToastGravity.CENTER);
//              buttonText = "立即升级";
//            }else{
//              percent = 0;
//              buttonText = "立即升级";
//            }
//          });
//        },
//      );
//    } catch (e) {
//      print('Failed to make OTA update. Details: $e');
//    }
//  }
  // android 下载
  androidDownloadHandle() async {
    // 权限检查
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    print(permissions);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      // 开始下载
      _startDownload();
    } else {
      showSettingDialog();
    }
  }

  // 打开应用设置
  showSettingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("需要打开存储权限"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
              new FlatButton(
                onPressed: () {
                  PermissionHandler().openAppSettings();
                  Navigator.of(context).pop();
                },
                child: new Text("确认"),
              ),
            ],
          );
        });
  }

  // 开始下载
  void _startDownload() {
    _stopDownload();
    if (downloadSubscription == null) {
      downloadSubscription = stream.receiveBroadcastStream(widget.data.appUrl).listen(_updateDownload);
    }
    _isUpdating = true;
  }

  // 停止监听进度
  void _stopDownload() {
    if (downloadSubscription != null) {
      downloadSubscription.cancel();
      downloadSubscription = null;
      percent = 0;
    }
    _isUpdating = false;
  }

  // 进度下载
  void _updateDownload(data) {
    if((data as Map).containsKey("error") && (data as Map)["error"] == true){
      ToastUtil.makeToast("下载失败，点击重新下载！",toastType: ToastType.ERROR,gravity: ToastGravity.CENTER);
      setState(() {
        percent = 0;
        _isUpdating = false;
      });
    }else if((data as Map).containsKey("cancel") && (data as Map)["cancel"] == true){
      ToastUtil.makeToast("下载取消，点击重新下载！",toastType: ToastType.ERROR,gravity: ToastGravity.CENTER);
      setState(() {
        percent = 0;
        _isUpdating = false;
      });
    }else{
      int progress = data["percent"];
      if (progress != null) {
        setState(() {
          percent = progress;
        });
      }
    }

  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _stopDownload();
  }

  @override
  Widget build(BuildContext context) {
//    final screenSize = MediaQuery.of(context).size;
    var _maxContentHeight = KSize.updateVersionDialogHeightMax; // min(screenSize.height - 300, 180.0);

    return Material(
        type: MaterialType.transparency,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width:(ScreenUtil.screenWidthDp * 0.8),
                  decoration: ShapeDecoration(
                      color: KColor.color_fafafa,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                  child: Column(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: KSize.dialogPadding3,bottom: KSize.dialogPadding2),
                        child: Center(
                            child: new Text('升级到新版本',
                                style: new TextStyle(
                                  fontSize: KFont.fontSizeCommon_1,
                                  color: KColor.color_191919,
                                  fontWeight: FontWeight.w600,
                                )))),
                    Padding(
                      padding: EdgeInsets.only(bottom: KSize.dialogPadding4),
                      child: Text(
                        widget.data.versionName,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: KFont.fontSizeCommon_2),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: _maxContentHeight),
                      child: Container(
                        padding: EdgeInsets.only(bottom: KSize.dialogPadding4,left: KSize.dialogPadding4,right: KSize.dialogPadding4),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.data.content,
                            style: TextStyle(color: Colors.black54,fontSize: KFont.fontSizeCommon_2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: KSize.dialogPadding3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Offstage(
                              offstage: widget.data.isForce,
                              child: Container(
                                  height: KSize.dialogButtonHeight,
                                  width: KSize.dialogButtonWidget,
                                  child: FlatButton(
                                    color: ButtonThemeStore.buttonThemeLight["buttonColor"],
                                    highlightColor: ButtonThemeStore.buttonThemeLight["highlightColor"].withOpacity(0.05),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(ButtonThemeStore.shapeRadius)),
                                        side: BorderSide(color: ButtonThemeStore.buttonThemeLight["borderColor"])),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      "暂不升级",
                                      style: TextStyle(
                                        color: KColor.color_333333,
                                        fontSize: KFont.fontSizeDialogAlert,
                                        fontWeight: FontWeight.normal,
                                        //fontFamily: fontFamily1,
                                      ),
                                    ),
                                  )),
                            ),
                            Offstage(
                              offstage: widget.data.isForce,
                              child: Visibility(
                                visible: true,
                                child: VerticalDivider(
                                  width: KSize.dialogDividerWidth,
                                  color: KColor.color_fafafa,
                                ),
                              ),
                            ),

                            Container(
                                height: KSize.dialogButtonHeight,
                                width: KSize.dialogButtonWidget,
                                child: FlatButton(
                                  color: Theme.of(context).buttonColor,
                                  highlightColor: Theme.of(context).highlightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(ButtonThemeStore.shapeRadius)),
                                  ),
                                  onPressed: () {
//                                    tryOtaUpdate();
                                    if(!_isUpdating){
                                      _updateButtonTap(context);
                                    }
                                  },
                                  padding: EdgeInsets.all(0.0),
                                  child: Text(
//                                    buttonText,
                                    _getButtonText(),
                                    style: TextStyle(
                                      color:  Colors.white,
                                      fontSize: KFont.fontSizeDialogAlert,
                                      fontWeight: FontWeight.normal,
//                                      fontFamily: fontFamily2,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ]))
            ]));
  }

  _getButtonText() {
    if (percent == 100) {
      return "安装中";
    }
    if (percent > 0) {
      return "升级中$percent%";
    }
    return "立即升级";
  }
}
