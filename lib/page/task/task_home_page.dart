import 'dart:async';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/config/global.dart';
import 'package:lop/page/task/all_task_page.dart';
import 'package:lop/page/task/material_search_page.dart';
import 'package:lop/page/task/my_message_page.dart';
import 'package:lop/page/task/my_task_page.dart';
import 'package:lop/provide/bottom_bar_state_provide.dart';
import 'package:lop/provide/task_index_provide.dart';
import 'package:lop/provide/task_state_index_provide.dart';
import 'package:lop/router/application.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/viewmodel/search_my_message_viewmodel.dart';
import 'package:lop/viewmodel/task_info_new_viewmodel.dart';
import 'package:lop/viewmodel/unread_message_viewmodel.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../style/font.dart';
import '../../utils/translations.dart';




class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  JPush jPush;
  BuildContext _providerContext;
  Timer _timer;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if(_timer!=null){
      print("调用了dispose");
      _timer.cancel();
      _timer=null;
    }
  }
  final List<Widget> tabBodies =[
    MyTaskPage(),
    AllTaskPage(),
    MaterialSearchPage(),
    MyMessagePage()
  ];
  UnreadMessageViewModel _messageViewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const period=const Duration(seconds: 30);
    _timer = Timer.periodic(period, (timer){
      print('30秒执行一次');
      _getUnreadMessage();
    });
    jPush = new JPush();
    jPush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        this._getUnreadMessage();
        Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(false, context);
        Provider.of<SearchMessageModel>(context, listen: false).searchMessage(TextEditingValue.empty.text);
        //Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(false, context);
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        Navigator.popUntil(context, ModalRoute.withName('/task'));
        Provider.of<TaskIndexProvide>(_providerContext,listen: false).changeIndex(3);
        //Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(false, context);
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
      },
    );
    jPush.setup(
      appKey: "9f41eb18b40563635c7d1152", //你自己应用的 AppKey
      channel: "developer-default",
      production: false,
      debug: Global.channel.isEmpty ||
          Global.channel == "lo1ptest1" ||
          Global.channel == "loptest2",
    );

    jPush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    //绑定极光推送
    _bindPush(Provider.of<UserViewModel>(context, listen: false).info.userId);
    _messageViewModel= Provider.of<UnreadMessageViewModel>(context,listen: false);
    this._getUnreadMessage();
  }
  _bindPush(String userId) async {
    try {
      await jPush.getRegistrationID().then((rid) async {
        print("flutter get registration id : $rid");
        var dio = new Dio();
        Response response = await dio.request(
          jPush_url,
          queryParameters: {'userId': userId, 'registrationId': rid},
          options: Options(
              method: 'post', contentType: Headers.formUrlEncodedContentType),
        );
        if (response != null) {
          //绑定成功
          //print(jsonDecode(response.data));
        }
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  _getUnreadMessage() async{

    bool success = await _messageViewModel.unreadMessage();
    print("_getUnreadMessage finish");
  }
  @override
  Widget build(BuildContext context) {

    //监听是否要退出到登录页面
    Future<bool> _onWillPop(){
      horizontalDoubleButtonDialog(
          context,
          title: Translations.of(context).text("task_home_page_logout_title"),
          info: Translations.of(context).text('task_home_page_logout_confirm'),
          leftText: Translations.of(context).text('cancel'),
          isClickAutoDismiss: false,
          onTapLeft: (){
          },
          rightText: Translations.of(context).text('logout'),
          onTapRight: (){
            //退出登录,情况登录状态
            Provider.of<UserViewModel>(context,listen: false).clear();
            Application.router.navigateTo(context, "/", clearStack: true,transition: TransitionType.fadeIn);
          }
      );
      return Future.value(false);
    }
    //网络请求
//    BaseSingleton singleton = BaseSingleton();
//    singleton.add(() => NetWork());
//    NetWork n = singleton.get<NetWork>();
//    n.unreadMessage(context);

    final List<BottomNavigationBarItem> bottomTabs = [
      BottomNavigationBarItem(
          icon: new Icon(Icons.person),
          title: new Text(
            Translations.of(context).text('task_home_page_my_task'))
      ),
      BottomNavigationBarItem(
          icon: new Icon(Icons.people),
          title: new Text(
              Translations.of(context).text('task_home_page_all_task'))
      ),
      BottomNavigationBarItem(
          icon: new Icon(Icons.search),
          title: new Text(Translations.of(context).text('task_home_page_material_Search'))
      ),
      BottomNavigationBarItem(
          icon: new  Icon(Icons.message),
          title: new Text(Translations.of(context).text('task_home_page_my_message'))
      ),

    ];


    return MultiProvider(
        providers: [
          //底部导航页面切换共享
          ChangeNotifierProvider<TaskIndexProvide>(create: (_) => TaskIndexProvide()),
          //任务状态页面数据共享
          ChangeNotifierProvider<TaskStateDataProvide>(create: (_) =>TaskStateDataProvide()),
          //监听我的任务Tab改变
          ChangeNotifierProvider<TaskStateTabClickProvide>(create: (_) => TaskStateTabClickProvide()),

        ],

        child: new Consumer<TaskIndexProvide>(
            builder:(context, TaskIndexProvide taskIndex,_){
              _providerContext = context;
              return  new WillPopScope(
                  onWillPop: _onWillPop,
                  child:  new Scaffold(
                    bottomNavigationBar: Offstage(
                      offstage: !Provider.of<BottomBarStateProvide>(context).shouldShowBottomBar,//false,//!shouldShowBottomBar,
                      child: Stack(children: <Widget>[
                        new BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          currentIndex:taskIndex.currentIndex,
                          iconSize:KSize.tabBarIconSize,
                          selectedLabelStyle: TextStyle(
                            color: Theme.of(context).tabBarTheme.labelColor,
                            fontSize: KFont.fontSizeTabBar
                          ),
                          unselectedLabelStyle: TextStyle(
                              color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                              fontSize: KFont.fontSizeTabBar
                          ),
                          items: bottomTabs,
                          onTap: (index){
                              taskIndex.changeIndex(index);
                              _getUnreadMessage();
                              if(index==3){
                                SearchMessageModel _searchMessageModel = Provider.of<SearchMessageModel>(context,listen: false);
                                _searchMessageModel.searchMessage('');
                              }
                            },
                        ),
                        Positioned(
                            right: (MediaQuery.of(context).size.width/4.0-35)/2.0-4,
                            top: 0,
                            child: (Provider.of<UnreadMessageViewModel>(context).count=='0'||Provider.of<UnreadMessageViewModel>(context).count==null)?Container():
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration:new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                  //圆角角度
                                    Radius.circular(10)
                                )
                            ),
                            child:Text(
                              '${Provider.of<UnreadMessageViewModel>(context).count}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ) ,
                          ),
                        )
                      ],

                      ),
                    ),

                    body: IndexedStack(
                      index: taskIndex.currentIndex,
                      children: tabBodies,
                    ),

                  )
              );
            }
        )

    );
  }
}
