
///设备信息内容，这是经过筛选后的保留的信息
class DeviceInfoModel{

  ///是否是ios系统
  bool isIOS;
  ///是否是Android系统
  bool isAndroid;

  ///设备名
  ///
  /// android:HDL-AL09.
  /// ios:iPhone.
  String model;

  ///是否是物理设备，确定真机与模拟器的区别
  bool isPhysicalDevice;

  ///mac地址，标识设备唯一信息。
  ///
  ///ios和android的获取方式不一样
  String macAddress;

  ///androidId，作为标识设备唯一信息的字段(备选)
  ///
  /// 设备第一次启动时，系统会随机生成一个64位的数字，并把这个数字以16进制字符串的形式保存下来。
  //设备被恢复出厂设置或者刷机后会重置。不同的设备可能会返回相同的，也有可能某些设备返回null。
  String androidId;
  ///ios设备的uuid，作为标识设备唯一信息的字段(备选)
  ///
  /// 可以作为唯一标识设备，但是问题有：同一个应用商的值一样，全部卸载后重新安装，
  /// 值会发生变化.(解决方案是将此值存入系统钥匙串中，卸载应用也不会丢失。
  /// 区分应用可以根据应用自身内部版本等信息区分)
  String identifierForVendor;

  ///系统信息。android和ios设备的获取字段不一样
  ///
  /// android设备：version.sdkInt,version.release,version.incremental
  /// 例如: 26,8.0.0,168(OCEC00)
  /// ios设备：systemName,systemVersion
  /// 例如: iOS,13.3.1
  String system;

  ///设备信息。android和ios设备获取字段不一样
  ///
  /// android设备：device,id
  /// 例如：HWHDL,HUAWEIHDL-AL09
  /// ios设备：utsname.machine
  /// 例如：iPhone8,2
  String device;


  @override
  String toString() {
    String value = "isIOS=$isIOS,isAndroid=$isAndroid,model=$model,"
        "isPhysicalDevice=$isPhysicalDevice,macAddress=$macAddress,"
        "androidId=$androidId,identifierForVendor=$identifierForVendor,"
        "system=$system,device=$device";
    return value;
  }
}