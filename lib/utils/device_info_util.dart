import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/config/global.dart';
import 'package:lop/model/device_info_model.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/mac_address_util.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';

/// 设备信息工具类
class DeviceInfoUtil {
  static Future<DeviceInfoModel> loadDeviceInfoModel() async {

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    DeviceInfoModel deviceInfoModel;
    try {
      if (Platform.isIOS) {
        deviceInfoModel = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        MacAddressUtilProvide macAddressUtilProvide = new MacAddressUtilProvide();
        deviceInfoModel.macAddress = await macAddressUtilProvide.getMacAddress();
      } else if (Platform.isAndroid) {
        deviceInfoModel =
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        WifiInfoWrapper wifiObject = await WifiInfoPlugin.wifiDetails;
        deviceInfoModel.macAddress = wifiObject.macAddress;
      }
    } on PlatformException {
      print("获取设备信息异常。");
    }
    return deviceInfoModel;
  }

  static DeviceInfoModel _readAndroidBuildData(AndroidDeviceInfo build) {
    DeviceInfoModel deviceInfoModel = new DeviceInfoModel();
    deviceInfoModel.isAndroid = true;
    deviceInfoModel.model = build.model;
    deviceInfoModel.isPhysicalDevice = build.isPhysicalDevice;
    deviceInfoModel.androidId = build.androidId;
    //系统信息
    deviceInfoModel.system =
        "${build.version.sdkInt},${build.version.release},${build.version.incremental}";
    //设备信息
    deviceInfoModel.device = "${build.device},${build.id}";
    return deviceInfoModel;
  }

  static DeviceInfoModel _readIosDeviceInfo(IosDeviceInfo data) {
    DeviceInfoModel deviceInfoModel = new DeviceInfoModel();
    deviceInfoModel.isIOS = true;
    deviceInfoModel.model = data.model;
    deviceInfoModel.isPhysicalDevice = data.isPhysicalDevice;
    deviceInfoModel.identifierForVendor = data.identifierForVendor;

    //系统信息
    deviceInfoModel.system = "${data.systemName},${data.systemVersion}";
    //设备信息
    deviceInfoModel.device = data.utsname.machine;
    return deviceInfoModel;
  }

  static double get appBarHeight =>
      (Platform.isIOS && Global.deviceModel != null && (Global.deviceModel).contains("iPhone"))
          ? 44.0
          : KSize.appBarHeight;

  static double get taskHomeHeaderHoldHeight =>
      (Platform.isIOS && Global.deviceModel != null && (Global.deviceModel).contains("iPhone"))
          ? (44.0 + 46.7)
          : KSize.myTaskHeaderHeight;

}
