import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lop/component/filter_item_collector_widget.dart';
import 'package:lop/component/no_more_data_widget.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/model/jobcard/xml_parse.dart';
import 'package:lop/model/task_model.dart';
import 'package:lop/page/search/search_widget.dart';
import 'package:lop/page/task/all_task_public_key.dart';
import 'package:lop/page/task/task_card.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/model/task_state_list_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' as refresh;
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:lop/viewmodel/all_task_viewmodel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../../model/task_model.dart';
import '../../style/size.dart';
import 'all_task_page_drawer.dart';
import 'package:lop/provide/bottom_bar_state_provide.dart';

class AllTaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  ProgressDialog _loadingDialog;
  int pages = 1; //page = 0 与 page = 1 返回相同的内容
  bool fakeDataFlag = false;
  Drawer endDrawer;
  FilterItemCollector _filterItemCollector;
  FocusNode searchFocusNode = new FocusNode();
  int rowPerPage = 10;
  AllTaskViewModel _viewModel;
  static ScrollController _scrollController = new ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey _appBarKey = new GlobalKey();

  /************************************************************ Life Circle **************************************************************************/

  ///

  @override
  void initState() {
    _viewModel = AllTaskViewModel();
    _viewModel.controller = EasyRefreshController();
    _viewModel.taskList = TaskStateListModel(null);

    _onLoadData(1, rowPerPage, true, shoudShowProgressDialog: false);
    _scrollController.addListener(() {
      int offset = _scrollController.position.pixels.toInt();
      if (offset != 0 && context != null) {
        FocusScope.of(context).unfocus();
      }
    });

    _filterItemCollector = FilterItemCollector(
      [],
      onDelete: (String deleteTitle) {},
    );

    super.initState();
  }

  /************************************************************ Widget **************************************************************************/

  ///

  @override
  Widget build(BuildContext context) {
    _loadingDialog = LoadingDialogUtil.createProgressDialog(context);

    return new GestureDetector(
      //点击空白处收回虚拟键盘
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          child: new AppBar(
            key: _appBarKey,
            title: new Text(
              Translations.of(context).text('all_task_page'),
              style: TextThemeStore.textStyleAppBar,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              //抽屉触发按钮
              Builder(builder: (context) {
//                return Consumer<TaskHomePagePublicState>(
//                  builder: (context, publicState, child) {
                return new Consumer<BottomBarStateProvide>(
                    builder: (context, state, _) {
                  return Container(
                    height: ScreenUtil().setHeight(100),
                    child: IconButton(
                        icon: Icon(Icons.search),
                        iconSize: ScreenUtil().setWidth(60),
                        padding: EdgeInsets.only(
                            bottom: ScreenUtil().setSp(20),
                            right: ScreenUtil().setWidth(20),
                            top: ScreenUtil().setWidth(20)),
                        onPressed: () {
                            ///测试测试测试测试测试测试测试测试测试测试测试测试测试测试测测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试sheet
//                            test();
                          _scaffoldKey.currentState.openEndDrawer();
                          Provider.of<BottomBarStateProvide>(context,
                                  listen: false)
                              .hideBottomBar();
                        }),
                  );
                });
//                  },
//                );
              })
            ],
          ),
          preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
        ),
        endDrawer: filterDrawerWidget(),
        body: myBody(),
      ),
    );
  }

  void test() {
//    Application.router.navigateTo(context, Routes.jobCardSettingPage, transition: TransitionType.fadeIn);
      XMLParse().parseXmlFile("assets/testxml/protocol_v1_3.xml").then((model){
        Provider.of<JcSignModel>(context, listen: false).jobCardModel = model;
        Provider.of<JcSignModel>(context, listen: false).jcId = 88776;
        Application.router.navigateTo(context, Routes.jobCardModulePage, transition: TransitionType.fadeIn);
      });
  }

  Widget myBody() {
    return new Column(children: [
      Container(
        child: searchWidget(),
        padding: EdgeInsets.only(
            left: ScreenUtil().setSp(10), right: ScreenUtil().setSp(10)),
        margin: EdgeInsets.only(top: 5, bottom: 5),
      ),
      _filterItemCollector,
      _viewModel.taskList.data == null || _viewModel.taskList.data.length == 0
          ? NoMoreDataWidget()
          : taskListWidget(),
    ]);
  }

  Widget searchWidget() {
    return SearchField(
        hintText: Translations.of(context).text('search_hint_acreg'),
        controller: _viewModel.searchBarController,
        focusNode: searchFocusNode,
        onSubmitted: (text) {
          searchMessageAction(text);
        },
        onClear: () {
          searchBarCancelAction();
        });
  }

  Widget taskListWidget() {
    if (null != _viewModel.taskList.data) {
      return Flexible(
          child: refresh.EasyRefresh(
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
        child: ListView.separated(
          itemCount: _viewModel.taskList.data.length,
          itemBuilder: taskItemBuilder,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: KColor.dividerColor,
              height: KSize.dividerSize,
            );
          },
        ),
        onRefresh: () {
          _viewModel.controller.resetLoadState();
          _viewModel.controller.finishRefresh();
          pages = 1;
          return _onLoadData(pages, rowPerPage, true,
              shoudShowProgressDialog: false);
        },
        onLoad: () {
          pages += 1;
          return _onLoadData(pages, rowPerPage, false,
              shoudShowProgressDialog: false);
        },
        controller: _viewModel.controller,
        scrollController: _scrollController,
      ));
    } else {
      return Flexible(
        child: refresh.EasyRefresh(
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
            onRefresh: () {
              pages = 1;
              return _onLoadData(pages, rowPerPage, true);
            },
            child: Center(
              child: Text('No Data'),
            )),
      );
    }
  }

  ///每一个 item 的布局
  Widget taskItemBuilder(BuildContext context, int index) {
    TaskModel task = _viewModel.taskList.data[index];

    return TaskCard(
      task,
      outSideFocusNode: searchFocusNode,
    );
  }

  Widget sep(BuildContext context, int index) {
    TaskModel task = _viewModel.taskList.data[index];
    return TaskCard(
      task,
      outSideFocusNode: searchFocusNode,
    );
  }

  Widget filterDrawerWidget() {
    endDrawer = SmartDrawer(
      widthPercent: 0.80,
      stateCallBack: (bool isOpen) {
        if (!isOpen) {
          Provider.of<BottomBarStateProvide>(context, listen: false)
              .showBottomBar();
        }
      },
      filterAction: filterAction,
      resetAction: resetAction,
      textEditingControllers: _viewModel.textEditingControllers,
      textEdtingFocusNode: _viewModel.textEditingFocusNode,
      textEdtingTitle: _viewModel.textEditingTitle,
      searchHistoryMap: _viewModel.searchHistoryMap,
    );
    return endDrawer;
  }

  /************************************************************ Action **************************************************************************/

  ///page（当前页数），rows（每页显示数量），sort（空），order（desc），acreg（机号，搜索时传参），
  ///isshiftto（0），flightno（航班号，搜索时传参），tasktype（任务类型，搜索时传参），actype（机型，搜索时传参）
  ///，acplacearrive（到港机位，搜索时传参），acplaceleave（离港机位，搜索时传参）
  ///page（当前页数），rows（每页显示数量），sort（空），order（desc），acreg（机号，搜索时传参），
  ///isshiftto（0），flightno（航班号，搜索时传参），tasktype（任务类型，搜索时传参），actype（机型，搜索时传参）
  ///，acplacearrive（到港机位，搜索时传参），acplaceleave（离港机位，搜索时传参）
  Future _onLoadData(int page, int row, bool resetList,
      {bool shoudShowProgressDialog = true}) async {
    String acType = _viewModel.acTypeController.text ?? '';
    String acReg = _viewModel.acRegController.text ?? '';
    String flightNum = _viewModel.flightNumController.text ?? '';
    String taskType = _viewModel.taskTypeController.text ?? '';
    String arrivePort = _viewModel.acArriveController.text ?? '';
    String leavePort = _viewModel.acLeaveController.text ?? '';

    if (shoudShowProgressDialog) {
      await _loadingDialog.show();
    }

    bool isSuccess = await _viewModel.loadData(page, row, resetList,
        acType: acType,
        acReg: acReg,
        flightNum: flightNum,
        taskType: taskType,
        arrivePort: arrivePort,
        leavePort: leavePort);

    setState(() {
      if (isSuccess) {
        _loadingDialog.hide();
      } else {
        _loadingDialog.hide();
        fakeDataFlag = false;
        _viewModel.controller.finishLoad(noMore: false, success: false);
      }
    });
  }

  //筛选条目项
  void filterAction() {
    clearAllSearchHistory();
    //更新搜索历史,以便下次展示
    _viewModel.textEditingControllers
        .forEach((String key, TextEditingController controller) {
      (controller.text != null && controller.text.length != 0)
          ? _viewModel.searchHistoryMap[key] = controller.text
          : null;
//      (controller.text != null && controller.text.length != 0) ? _filterItemCollector.updateItemTitles([controller.text]) : null;

      //筛选页面中清除 acreg 后,外部 searchBar 也应该清除text内容
      if (key == AllTaskFileterKey.acRegKey)
        _viewModel.searchBarController.text = controller.text;
    });

    setState(() {
      Navigator.pop(context);
    });

    pages = 1;
    clearAllCurrentContent();
    _onLoadData(pages, rowPerPage, false);
  }

  //清空筛选条目
  void resetAction() {
    _viewModel.textEditingControllers
        .forEach((String key, TextEditingController controller) {
      controller.text = '';
    });
    _viewModel.searchHistoryMap.clear();
    _viewModel.searchBarController.clear();
    pages = 1;
    clearAllCurrentContent();
    _onLoadData(pages, rowPerPage, false);
  }

  void searchMessageAction(String text) {
    //清除所有其他的筛选项的值
    _viewModel.textEditingControllers
        .forEach((String key, TextEditingController tec) {
      tec.text = '';
    });
    clearAllSearchHistory();
    clearAllCurrentContent();
    TextEditingController acregTec =
        _viewModel.textEditingControllers[AllTaskFileterKey.acRegKey];
    acregTec.text = text;
    _viewModel.searchHistoryMap[AllTaskFileterKey.acRegKey] = acregTec.text;

    pages = 1;
    _onLoadData(pages, rowPerPage, false);
  }

  //外部 searchbar cancel 时调用
  void searchBarCancelAction() {
    _viewModel.searchHistoryMap.remove(AllTaskFileterKey.acRegKey);
    _viewModel.textEditingControllers[AllTaskFileterKey.acRegKey].text = '';
    _viewModel.searchBarController.clear();
    pages = 1;
    _onLoadData(pages, rowPerPage, true);
  }

  //清除所有的搜索历史记录
  void clearAllSearchHistory() {
    _viewModel.searchHistoryMap.clear();
  }

  //清除现有的所有列表项
  void clearAllCurrentContent() {
    _viewModel.taskList.data.clear();
  }
}
