import 'dart:core';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' as refresh;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/component/ly_custom_appbar.dart';
import 'package:lop/component/no_more_data_widget.dart';
import 'package:lop/component/popmenu/zlenumconfig.dart';
import 'package:lop/component/popmenu/zlpopmenubutton.dart';
import 'package:lop/config/enum_config.dart';
import 'package:lop/model/task_model.dart';
import 'package:lop/page/task/task_card.dart';
import 'package:lop/provide/my_task_tab_click_provide.dart';
import 'package:lop/provide/theme_provider.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/style/theme/theme_config.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/viewmodel/task_info_new_viewmodel.dart';
import 'package:lop/viewmodel/task_list_viewmodel.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class MyTaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<MyTaskPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  // 切换Tab导航栏保持页面状态
  bool get wantKeepAlive => true;
  refresh.EasyRefreshController _refreshController =
      refresh.EasyRefreshController();
  TabController _tabController;

//  TaskInfoNewViewModel _taskInfoNewViewModel;
//  TaskListViewModel _taskListViewModel;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(length: taskStateTitle.length, vsync: this);
    _tabController.index = 1;
    Provider.of<TaskInfoNewViewModel>(context, listen: false).tabIndex = _tabController.index;
    _tabController.addListener(_tabControllerListener);
    getForGetFirst();
    Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(false, context);
  }

  Future<Null> _tabControllerListener() async {
    if (_tabController.index == _tabController.animation.value) {
      _refreshController.callRefresh();
      Provider.of<MyTaskTabClickProvide>(context, listen: false)
          .setTabIndex(_tabController.index);
      Provider.of<TaskInfoNewViewModel>(context, listen: false).tabIndex = _tabController.index;
      Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(false, context);
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _tabController.removeListener(_tabControllerListener);
    _tabController.dispose();
    super.dispose();
  }

  Future<dynamic> getForGetFirst() async {
    String state = taskStateParams[0];
    Provider.of<TaskListViewModel>(context, listen: false).fetchTaskList(state, 0, 1, 10, false);
  }



  ///无用暂时保留
//  void _showBottomSheet(BuildContext context) {
//    SheetWidget sw = SheetWidget(
//      context,
//      KFont.fontSizeSheetItem,
//      itemHeight: KSize.sheetItemHeight,
//      children: <SheetWidgetItem>[
//        SheetWidgetItem(
//            Translations.of(context).text('change_password_page_title'), () {
//          Application.router.navigateTo(context, Routes.changePasswordPage,
//              transition: TransitionType.fadeIn);
//        }, textColor: KColor.sheetItemColor),
//        SheetWidgetItem(Translations.of(context).text('theme'), () {
//          Application.router.navigateTo(context, Routes.changeTheme,
//              transition: TransitionType.fadeIn);
//        }, textColor: KColor.sheetItemColor),
//      ],
//    );
//    sw.showSheet();
//  }

  @override
  Widget build(BuildContext context) {
    List<Widget> taskTabs = [
      taskStateTab(TaskState.forGet),
      taskStateTab(TaskState.forFinish),
      taskStateTab(TaskState.finished),
      taskStateTab(TaskState.forPass),
      taskStateTab(TaskState.passed),
    ];
    return taskStateSection(taskTabs);
  }

  double _getTextWidth(text, textStyle) {
    TextSpan span = new TextSpan(style: textStyle, text: text);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    return tp.size.width;
  }

  double _getCircleRight(text, textStyle) {
    double textWidth = _getTextWidth(text, textStyle);
    if (textWidth >= MediaQuery.of(context).size.width / 5.0 ||
        (textWidth + ScreenUtil().setWidth(30)) >=
            MediaQuery.of(context).size.width / 5.0 ||
        ((MediaQuery.of(context).size.width / 5.0 - textWidth) / 2) <=
            ScreenUtil().setWidth(30)) {
      return 1.0;
    } else {
      return (MediaQuery.of(context).size.width / 5.0 - textWidth) / 2 -
          ScreenUtil().setWidth(30);
    }
  }

  //Tab项，包含数字，标题，圆形图标
  Widget taskStateTab(TaskState taskState) {
    return Container(
        width: MediaQuery.of(context).size.width / 5.0,
        height: DeviceInfoUtil.appBarHeight,
        child: Tab(
          child: new Container(
            padding: EdgeInsets.only(top: KSize.commonPadding2),
            child: new Center(
                child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                        child: Center(
                      child: Text(
                        Translations.of(context).text(
                            'task_home_page_task_state_${taskStateTitle[taskState]}'),
                        style: new TextStyle(fontSize: KFont.fontSizeCommon_2),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    Expanded(
                      child: new Consumer<TaskInfoNewViewModel>(
                        builder: (context, data, child) {
                          return Center(
                              child: Text(
                            data.stateNum[taskState],
                            style: new TextStyle(
                                //color: Colors.white,
                                fontSize: KFont.fontSizeCommon_2),
                            textAlign: TextAlign.center,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: _getCircleRight(
                      Translations.of(context).text(
                          'task_home_page_task_state_${taskStateTitle[taskState]}'),
                      TextStyle(fontSize: KFont.fontSizeCommon_2)),
                  child: Consumer<TaskListViewModel>(
                    builder: (context, data, child) {
                      return Offstage(
                        offstage: taskState != TaskState.forGet ||
                            data.getUdf5Count() == 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "${data.getUdf5Count()}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
          ),
        ));
  }

  //任务状态切换tab
  Widget taskStateSection(List<Widget> taskTabs) {
    return DefaultTabController(
        length: taskTabs.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(DeviceInfoUtil.taskHomeHeaderHoldHeight),
            child: AppBarControlHight(
              elevation: 0.0,
              title: new Consumer<UserViewModel>(
                builder: (context, UserViewModel user, _) {
                  return new Text(
                    Translations.of(context).text('task_home_page_welcome') +
                        ': ${user.info == null ? '' : user.info.realName}',
                    style: TextThemeStore.textStyleAppBar,
                    textAlign: TextAlign.start,
                  );
                },
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Transform(
                  transform: Matrix4.identity()..rotateZ(KSize.pi),
                  alignment: Alignment.center,
                  child: Icon(Icons.exit_to_app),
                ),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
              actions: <Widget>[
                new Container(
                  child: ZlPopMenuButton(
                    [
                      Translations.of(context)
                          .text('change_password_page_title'),
                      Translations.of(context).text('theme_blue'),
                      Translations.of(context).text('theme_orange')
                    ],
                    ScreenUtil().setHeight(100),
                    Theme.of(context).primaryColor,
                    BubbleArrowDirection.top,
                    buttonWidget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.menu,
                        size: 24,
                      ),
                    ),
                    onTap: (index) {
                      if (index == 0) {
                        Application.router.navigateTo(
                            context, Routes.changePasswordPage,
                            transition: TransitionType.fadeIn);
                      } else if (index == 1) {
                        ThemeProvider themeProvider =
                        Provider.of<ThemeProvider>(context, listen: false);
                        themeProvider.setTheme(AppTheme.themeValue_default);
                      } else if (index == 2) {
                        ThemeProvider themeProvider =
                        Provider.of<ThemeProvider>(context, listen: false);
                        themeProvider.setTheme(AppTheme.themeValue_orange);
                      }
                    },
                    txtStyle: TextStyle(
                      color: Colors.white,
                      fontSize: KFont.fontSizeCommon_2,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                ///下方tab的高度
                preferredSize: Size.fromHeight(DeviceInfoUtil.taskHomeHeaderHoldHeight-DeviceInfoUtil.appBarHeight),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                      Border(bottom: BorderSide(color: Colors.black12))),
                  child: TabBar(
                    controller: _tabController,
                    tabs: taskTabs,
                    labelColor: Colors.blueAccent,
                    isScrollable: true,
                    indicatorColor: Colors.blueAccent,
                    indicatorWeight: KSize.myTaskIndicatorHeight,
                    unselectedLabelColor: Colors.black54,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),

          body: taskTabView(),
        ));
  }

  //单个列表视图
  Widget taskView(int taskIndex) {
    return Container(
      margin: EdgeInsets.only(top: KSize.splitLineHeight),
      child: Consumer<TaskListViewModel>(
        builder: (context, TaskListViewModel taskData, _) {
          return refresh.EasyRefresh(
              footer: refresh.ClassicalFooter(
                enableInfiniteLoad: false,
                completeDuration: const Duration(milliseconds: 1000),
                loadText: Translations.of(context).text("pull_to_load"),
                loadReadyText: Translations.of(context).text("release_to_load"),
                loadingText: Translations.of(context).text("refresh_loading"),
                loadedText: Translations.of(context).text("load_complected"),
                noMoreText: Translations.of(context).text("no_more_text"),
                infoText: Translations.of(context).text("update_at"),
              ),
              header:  refresh.ClassicalHeader(
                refreshText: Translations.of(context).text("pull_to_refresh"),
                refreshReadyText: Translations.of(context).text("release_to_refresh"),
                refreshingText: Translations.of(context).text("refresh_refreshing"),
                refreshedText: Translations.of(context).text("refresh_complected"),
                infoText: Translations.of(context).text("update_at"),
              ),
              controller: _refreshController,
              child: taskData.itemCount(taskIndex) != 0
                  ? ListView.separated(
                      itemCount: taskData.itemCount(taskIndex),
                      itemBuilder: (context, index) {
                        return taskItemView(
                            taskData.taskList(taskIndex), index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: KColor.dividerColor,
                          height: KSize.dividerSize,
                        );
                      },
                    )
                  : NoMoreDataWidget(),
              onRefresh: () async {
                await  Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(false, context);;
              },
              onLoad: () async {
                //....
                await  Provider.of<TaskInfoNewViewModel>(context, listen: false).refreshData(true, context);;
              });
        },
      ),
    );
  }

  //列表视图五个视图
  Widget taskTabView() {
    return Stack(
      children: <Widget>[
        TabBarView(
          controller: _tabController,
          children: <Widget>[
            taskView(0),
            taskView(1),
            taskView(2),
            taskView(3),
            taskView(4),
          ],
        )
      ],
    );
  }

  Widget taskItemView(List<TaskModel> taskList, int index) {
    TaskModel task = taskList[index];
    return TaskCard(task);
  }
}
