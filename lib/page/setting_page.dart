import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/config/global.dart';
import 'package:lop/config/locale_storage.dart';
import '../config/package_config.dart';
import 'package:lop/network/network_config.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/device_info_util.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _baseUrl;
  List<Widget> _listRadio = List();

  @override
  void initState() {
    super.initState();
    _loadBaseUrl();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadBaseUrl() async {
    _baseUrl = await LocaleStorage.get('baseurl');
    if (!(Global.channel == null || Global.channel.isEmpty || Global.channel == "loptest1" || Global.channel == "loptest2")) {
      if (_baseUrl == null) {
        _baseUrl = NetworkConfig.releaseUrl.keys.first;
        LocaleStorage.set('baseurl', _baseUrl);
      }
    } else {
      if (_baseUrl == null) {
        _baseUrl = NetworkConfig.debugUrl.keys.first;
        LocaleStorage.set('baseurl', _baseUrl);
      }
    }
    setState(() {
      // ignore: unnecessary_statements
      _baseUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    _listRadio.clear();
    if (PackageConfig.isProduction) {
      NetworkConfig.releaseUrl.forEach((key, value) {
        _listRadio.add(_radioListTile(key));
        _listRadio.add(Divider());
      });
    } else {
      NetworkConfig.debugUrl.forEach((key, value) {
        _listRadio.add(_radioListTile(key));
        _listRadio.add(Divider());
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(
            Translations.of(context).text('login_page_system_setting'),
            style: TextThemeStore.textStyleAppBar,
          ),
          centerTitle: true,
        ),
        preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
      ),
      body: Column(
        children: _listRadio,
      ),
    );
  }

  Widget _radioListTile(String key) {
    return RadioListTile<String>(
        dense: false,
        value: key,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(Translations.of(context).text('setting_page_$key'),
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(50),
                  color: Theme.of(context).primaryColor)),
        ),
        activeColor: Theme.of(context).primaryColor,
        secondary: Icon(Icons.router,
            color: Theme.of(context).primaryColor,
            size: ScreenUtil().setSp(60)),
        groupValue: _baseUrl,
        onChanged: (v) {
          setState(() {
            _baseUrl = v;
          });
          Global.changeBaseUrl(v);
        });
  }
}
