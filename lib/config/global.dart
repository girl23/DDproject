import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lop/database/database_util.dart';
import 'package:lop/model/device_info_model.dart';
import 'package:lop/config/package_config.dart';
import 'package:lop/network/network_client.dart';
import 'package:package_info/package_info.dart';
import 'package:lop/network/network_config.dart';
import 'package:lop/utils/device_info_util.dart';

import 'locale_storage.dart';

class Global{
  static String userId;
  static String token;
  static String channel;//渠道名称，loptest lop guiyang
  static String version;

  static String userName;
  static String macAddress;
  static String deviceModel;

  static final signMethodChannel = const MethodChannel('com.ameco.lop.sign/method');
  static final channelMethodChannel = const MethodChannel('plugins.com.ameco.lop/get_channel');
  static final signMessageChannel = const BasicMessageChannel('com.ameco.lop.sign/message',JSONMessageCodec());
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  ///获取版本号
  static Future<String> getCurrentVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version??"";

  }

  static Future init() async{
    // 强制竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    ///获取渠道 loptest lop guiyang
    channel = await channelMethodChannel.invokeMethod('getChannel');
    ///获取版本号
    version = await getCurrentVersion();
    ///读取本地存储信息、设备信息
    readLocaleStorageInfo();
    //初始化数据库
    DatabaseUtil.instance.initDatabase();
  }

  static void changeBaseUrl(urlKey) async{

    Global.channel = "lop1";
    String defaultUrlKey;
    Map<String,String> urlMap;

    switch(Global.channel){
      case "loptest1":
        defaultUrlKey = 'testServer';
        urlMap = NetworkConfig.debugUrl;
        break;
      case "loptest2":
        defaultUrlKey = 'testServer2';
        urlMap = NetworkConfig.debugUrl;
        break;
      case "lop1":
        defaultUrlKey = "releaseServer01";
        urlMap = NetworkConfig.releaseUrl;
        break;
      case "lop2":
        defaultUrlKey = "releaseServer02";
        urlMap = NetworkConfig.releaseUrl;
        break;
      case "guiyang":
        defaultUrlKey = "guiyangServer";
        urlMap = NetworkConfig.releaseUrl;
        break;
      default:
        defaultUrlKey = 'testServer';
        urlMap = NetworkConfig.debugUrl;
    }
    String url;
    if(urlKey != null && urlMap.containsKey(urlKey)){
      url = urlMap[urlKey];
    }else{
      urlKey = defaultUrlKey;
      url = urlMap[defaultUrlKey];
    }
    LocaleStorage.set('baseurl', urlKey);
    //重置网络地址
    if(PackageConfig.isProduction){//release版本
      NetworkConfig.productionServerUrl = url;
    }else{
      NetworkConfig.testServerUrl = url;
    }
    NetWorkClient.instance.resetUrl();
    try{
        await Global.signMethodChannel.invokeMethod('initUrl',url);
    } on PlatformException catch(e){
      print(e);
    }
  }

  ///读取本地存储的信息（中间涉及到设备信息）
  static void readLocaleStorageInfo() async{
    var userName = await LocaleStorage.get('username');
    var saveBaseUrl  = await LocaleStorage.get('baseurl');
    var macAddress = await LocaleStorage.get('macAddress');
    var deviceModel = await LocaleStorage.get("deviceModel");

    print("username = ${userName}");
    Global.userName = userName;
    Global.changeBaseUrl(saveBaseUrl);
    if(macAddress == null || deviceModel == null){
      DeviceInfoModel deviceInfoModel =
      await DeviceInfoUtil.loadDeviceInfoModel();
      Global.macAddress = deviceInfoModel.macAddress;
      Global.deviceModel = deviceInfoModel.model;
    }else{
      Global.macAddress = macAddress;
      Global.deviceModel = deviceModel;
    }
  }
}