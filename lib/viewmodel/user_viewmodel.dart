import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/global.dart';
import 'package:lop/config/locale_storage.dart';
import 'package:lop/model/user_model.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/user/user_service.dart';
import 'package:lop/service/user/user_service_impl.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/update_version.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';

class UserViewModel extends BaseViewModel with ChangeNotifier {
  UserService _service = UserServiceImpl();

  UserModel _info;

  UserModel get info => _info ?? null;

  Future<bool> login(
      String username, String password, String macAddress) async {
    NetworkResponse response =
        await _service.login(username, password, macAddress);
    if (response.isSuccess) {
      if (response.data.locked != null && response.data.locked == '1') {
        ToastUtil.makeToast('密码输入错误次数过多，帐号已被锁定！');
        return false;
      }

      ///登录成功，但是密码强度不够，需跳转到密码修改页面强制修改密码
      if (response.data.passCheckRtn != null &&
          response.data.passCheckRtn.length > 0) {}

      if (response.data.result == 'success' && response.data.userId != null) {
        //记录登录状态并通知监听组件刷新
        _info = response.data;
        //保存登录用户名到本地
        LocaleStorage.set("username", username);
        Global.userId = _info.userId;
        Global.token = _info.token;
        notifyListeners();
        return true;
      }
      //密码错误
      if (response.data.userId == null || response.data.userId.length == 0) {
        ToastUtil.makeToast('用户名或密码错误！');
        return false;
      }
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }

  Future<bool> checkVersion(String platform, String version) async {
    NetworkResponse response = await _service.checkVersion(platform, version);
    if (response.isSuccess) {
      if ("success" == response.data.result) {
        bool isUpdate = response.data.isUpdate; //是否升级
        bool isForce = response.data.isForce; //是否强制升级
        String content = response.data.content; //升级内容
        String newVersion = response.data.version; //版本号
        String url = response.data.url; //下载地址
        if (isUpdate) {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              final data = UpdateVersion(
                  isForce: isForce,
                  versionName: newVersion,
                  appUrl: url,
                  content: content);
              return WillPopScope(
                onWillPop: () async {
                  return Future.value(false);
                },
                child: UpdateVersionDialog(data: data),
              );
            },
          );
          return true;
        }else{
          return false;
        }
      } else {
        //检查更新失败，不做操作
        return false;
      }
    } else {
      ToastUtil.makeToast(response.errorEntity.message);
      return false;
    }
  }

  void clear() {
    _info = null;
  }
}
