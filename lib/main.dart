import 'dart:ui';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/component/cyl_splash_screen.dart';
import 'package:lop/page/login_page.dart';
import 'package:lop/page/task/change_theme_page.dart';
import 'package:lop/page/task/my_task_page.dart';
import 'package:lop/provide/image_list_state_dart.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/router/application.dart';
import 'package:lop/style/theme/theme_config.dart';
import 'package:lop/provide/theme_provider.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/locale_util.dart';
import 'package:lop/viewmodel/material_search_viewmodel.dart';
import 'package:lop/viewmodel/unread_message_viewmodel.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'config/global.dart';
import 'model/jc_sign_model.dart';
import 'package:lop/provide/bottom_bar_state_provide.dart';
import 'package:lop/utils/width_height_util.dart';
import 'package:lop/viewmodel/search_my_message_viewmodel.dart';
import 'package:lop/viewmodel/set_message_read_viewmodel.dart';
import 'package:lop/viewmodel/change_password_viewmodel.dart';
import 'package:lop/provide/my_task_tab_click_provide.dart';
import 'package:lop/viewmodel/task_list_viewmodel.dart';
import 'package:lop/viewmodel/task_info_new_viewmodel.dart';
import 'package:lop/provide/dd/temporary_dd_transfer_provide.dart';
import 'package:lop/page/dd/dd_calculate_date_provide.dart';

void main() {
  //APP初始化全局变量
//  print('widget.items.length${WidthAndHeightUtil().getTextWidth('kkkk',TextStyle(
//    fontSize: 18,
//  ))}');
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //实例化路由
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    precacheImage(AssetImage("assets/images/bg_login.jpg"), context);
    //管理多个共享数据
    return MultiProvider(
        providers: <SingleChildWidget>[
          //用户信息
          ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
          ChangeNotifierProvider<ImageListStateProvide>(
              create: (_) => ImageListStateProvide()),
          ChangeNotifierProvider<TaskDetailStateProvide>(
              create: (_) => TaskDetailStateProvide()),
          ChangeNotifierProvider<JcSignModel>(create: (_) => JcSignModel()),
          //未读消息共享数据
          ChangeNotifierProvider<UnreadMessageViewModel>(
              create: (_) => UnreadMessageViewModel()),
          //我的消息数据
          ChangeNotifierProvider<SearchMessageModel>(
              create: (_) => SearchMessageModel()),
          //设置消息已读
          ChangeNotifierProvider<SetMessageReadViewModel>(create: (_) => SetMessageReadViewModel()),
          //修改密码
          ChangeNotifierProvider<ChangePasswordViewModel>(create: (_) => ChangePasswordViewModel()),
          //我的任务tab切换
          ChangeNotifierProvider<MyTaskTabClickProvide>(create: (_) => MyTaskTabClickProvide()),
          //我的任务tab数据
          ChangeNotifierProvider<TaskInfoNewViewModel>(create: (_) => TaskInfoNewViewModel()),
          //我的任务列表
          ChangeNotifierProvider<TaskListViewModel>(create: (_) => TaskListViewModel()),

          ChangeNotifierProvider<MaterialSearchViewModel>(create: (_) => MaterialSearchViewModel()),

          //是否显示底部工具栏数据
          ChangeNotifierProvider<BottomBarStateProvide>(
              create: (_) => BottomBarStateProvide()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          //dd日期动态计算
          ChangeNotifierProvider<DDCalculateProvide>(create: (_) => DDCalculateProvide()),
        ],
        child: Consumer<ThemeProvider>(
            builder: (BuildContext context, themeProvider, Widget child) {
          return MaterialApp(
            title: 'Ameco Lop Application',
            //debugShowCheckedModeBanner: false,
            //主题
            theme: themeProvider.themeData,

            //多语言配置
            localizationsDelegates: [
              const TranslationsDelegate(), //自定义语言配置
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalEasyRefreshLocalizations.delegate
            ],
            supportedLocales: localeUtil.supportedLocales(),
            localeResolutionCallback: localeUtil.localeResolutionCallback,
            //生成路由的回调函数，当导航到目标路由的时候，会使用这个来生成界面
            onGenerateRoute: Application.router.generator,
            navigatorKey: Global.navigatorKey,

//              home: LoginPage(),
            home: CYLSplashScreen(
              nextPage: LoginPage(),
              onLoading: (){
                Global.init();
                AppTheme.init();
              },
              onComplete: (){

              },
              second: 2,
            ),
          );
        }));
  }

}
