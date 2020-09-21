import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/enum_config.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import '../../style/color.dart';
import '../../style/font.dart';
import '../../component/custom_switch.dart';
import '../../component/job_card/ly_sign_item.dart';
import '../../model/jc_sign_model.dart';
import '../../model/jobcard/jc_body_model.dart';
import '../../model/jobcard/job_card_model.dart';
import '../../style/size.dart';
import '../../component/drawer/ly_slide_drawer.dart';
import '../../component/top_sheet.dart';
import 'package:provider/provider.dart';
import '../../component/sectionlist/list_view_delegate.dart';
import '../../component/sectionlist/section_list_view.dart';
import '../../component/listflodexpand/fold_and_expand_list.dart';
import '../../component/sectionlist/section_scroll_controller.dart';
import './table_header/table_header.dart';
import '../../component/complete_circle/circle_progress.dart';
import '../../component/listflodexpand/index_controller.dart';
import '../../component/loading_view/loading_view.dart';
import '../../component/loading_view/loading_view_controller.dart';
import '../../utils/device_info_util.dart';

///
/// 模块化工卡展示住页面
///

class JobCardModulePage extends StatefulWidget {
  JobCardModulePage({Key key}) : super(key: key);

  @override
  _JobCardModulePageState createState() => _JobCardModulePageState();
}

class _JobCardModulePageState extends State<JobCardModulePage>
    with SingleTickerProviderStateMixin {
  SectionScrollController _listViewController = SectionScrollController();
  PanelController _panelController = PanelController();
  LoadingViewController _loadingViewController = LoadingViewController();
  AnimationController _animationcontroller;
  Animation<double> _arrowIconTurns; //顶部三角的选择动画

  double _panelWidthOpen;
  double _panelWidthClosed = 0.0;
  double _headerHeight = 242;
  static JcSignModel _jcSignModel;
  Duration scrollToIndexDuration = Duration(milliseconds: 500);
  SectionListView _sectionListView;

  ///左侧工序、条目的显示内容区域

  final GlobalKey<ZLExpansionPanelListState> key =
      GlobalKey<ZLExpansionPanelListState>();
  final GlobalKey<TextWidgetState> textKey = GlobalKey();

  bool _isImage = false;
  bool _isSelectAll = false; //标记是否全选
  IndexController _indexController;

  //监听是否全选
//  ValueNotifier<int> _valueNotifier = new ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _jcSignModel = Provider.of<JcSignModel>(context, listen: false);
    print("job-card-sign-page jcId:${_jcSignModel.jcId}");
    _jcSignModel.initApi(context);
    _jcSignModel.loadingViewController = _loadingViewController;
    _jcSignModel.startJcPageData(context);

    _indexController = IndexController.create(this);
    _animationcontroller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _arrowIconTurns = _animationcontroller.drive(
        Tween<double>(begin: 0.0, end: 0.5)
            .chain(CurveTween(curve: Curves.easeIn)));
  }

  @override
  Widget build(BuildContext context) {
    print('JobCardModulePage build');
    _panelWidthOpen = MediaQuery.of(context).size.width * .80;
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.zero,
      ),
      body: Consumer<JcSignModel>(builder: (context, model, _) {
        return _holeView(model);
      }),
    );
  }

  Widget _holeView(JcSignModel model) {
    return LoadingView(
      controller: _loadingViewController,
      contentWidget: _slideDrawerView(model),
    );
  }

  Widget _slideDrawerView(JcSignModel model) {
    return LySlideDrawer(
        controller: _panelController,
        maxWidth: _panelWidthOpen,
        minWidth: _panelWidthClosed,
        panelSnapping: true,
        backdropTapClosesPanel: true,
        padding: EdgeInsets.zero,
        backdropEnabled: true,
        parallaxEnabled: true,
        headHeight: _headerHeight,
        footerHeight:
            (KSize.jcSignPanelSettingItemHeight + KSize.dividerSize) * 2,
        isDraggable: model.drawerisDragable,
        footer: _buildPanelFooter(context),
        defaultPadding: false,
        color: Theme.of(context).primaryColor,
        parallaxOffset: 1,
        header: _buildHeader(context),
        body: _buildBody(context, model),
        panelBuilder: (sc) => _buildPanel(context));
  }

  Widget _buildBody(BuildContext context, JcSignModel model) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
            child: AppBar(
                centerTitle: true,
                title: _titleWidget(model),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      _panelController.isPanelOpen
                          ? _panelController.close()
                          : _panelController.show();
                    },
                    icon: Icon(Icons.list),
                  )
                ])),
        floatingActionButton: Container(
          padding: EdgeInsets.all(KSize.commonPadding3),
          margin: EdgeInsets.only(bottom: KSize.commonMargin2),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(.5)),
          child: FloatingActionButton(
            onPressed: () async {
              print("点击签署");
              model.signType = "pos";
              _jcSignModel.posId = "97222993,97222993,97222993,97222993";
              _jcSignModel.signId = "102901206,102901207,102901208,102901209";
              _jcSignModel.location = "28006,28009,28010,28007";
              _jcSignModel.show();
            },
            tooltip: "点击签署",
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              "签署",
              style:
                  TextStyle(color: Colors.white, fontSize: KFont.fontSizeBtn_2),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: _builderContentListWidget(model));
  }

  ///
  /// 标题控件
  ///
  Widget _titleWidget(JcSignModel model) {
    return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Positioned(
              bottom: -3,
              child: AnimatedBuilder(
                  animation: _animationcontroller.view,
                  builder: (BuildContext context, Widget child) {
                    return RotationTransition(
                        turns: _arrowIconTurns,
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ));
                  })),
          FlatButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                _titlePress();
              },
              child: Container(
                child: Text('${model.signTitle}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: KFont.fontSizeAppBarTitle)),
              ))
        ]);
  }

  void _titlePress() {
    showModalTopSheet(
        context: context,
        builder: (BuildContext context) {
          return TableHeaderWidget(
              headerModel: _jcSignModel.jobCardModel.headerModel,
              cardLanguage: _jcSignModel.jcLanguage);
        },
        offset: Offset(
            0.0,
            DeviceInfoUtil.appBarHeight +
                MediaQueryData.fromWindow(window).padding.top),
        dismissCallBack: () {
          _animationcontroller.forward();
        },
        openCallBack: () {
          _animationcontroller.reverse();
        });
  }

  ///
  /// 左侧列表内容区域
  ///
  Widget _builderContentListWidget(JcSignModel model) {
    return Column(
      children: <Widget>[
        _signCountWidget(model),
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height -
              KSize.appBarHeight -
              MediaQueryData.fromWindow(window).padding.top -
              KSize.jcSignCountHeight,
          child: _getSectionListView(),
        )
      ],
    );
  }

  ///
  /// 列表顶部显示电签个数的数据控件区域
  ///
  Widget _signCountWidget(JcSignModel model) {
    return ValueListenableBuilder(
        valueListenable: model.signChooseListener,
        builder: (BuildContext context, bool value, Widget child) {
          return Container(
              height: KSize.jcSignCountHeight,
              padding: EdgeInsets.only(
                  left: KSize.commonPadding3, right: KSize.commonPadding3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          width: KSize.dividerSize,
                          color: KColor.dividerColor))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _signCountTextWidget(
                        '确认数：', '${model.normalSignChoose.length}'),
                    _signCountTextWidget(
                        'N/A数：', '${model.naSignChoose.length}'),
                    _signCountTextWidget('签署：',
                        '${model.normalSignChoose.length + model.naSignChoose.length}/${_getProItemTotalCount()}')
                  ]));
        });
  }

  Widget _signCountTextWidget(String title, String value) {
    return RichText(
        text: TextSpan(
            text: title,
            style: TextStyle(color: KColor.textColor_33),
            children: [
          TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: KFont.fontSizeCommon_2,
                  color: Theme.of(context).primaryColor))
        ]));
  }

  ///
  /// 总条目数(需要签署的总数)
  ///
  int _getProItemTotalCount() {
    int length = 0;
    for (ProcedureModel procedureModel in _jcSignModel.procedureList) {
      length += procedureModel.children.length;
    }
    return length;
  }

  Widget _getSectionListView() {
    if (_jcSignModel.procedureList.length == 0) return Container();
    if (_sectionListView == null || Provider.of<JcSignModel>(context).moduleSelectDidChange) {
    _sectionListView = SectionListView(
      sectionHover: true,
      listViewDelegate: ListViewDelegate(sectionCount: () {
        return _jcSignModel.procedureList.isEmpty
            ? 1
            : _jcSignModel.procedureList.length;
      }, rowCountOfSection: (index) {
        ProcedureModel procedureModel = _jcSignModel.procedureList[index];
        return procedureModel.children == null
            ? 0
            : procedureModel.children.length;
      }),
      listViewDataSourceDelegate: ListViewDataSourceDelegate(
          sectionWidgetBuilder: _sectionHeaderBuilder,
          cellWidgetBuilder: _cellItemBuilder),
      controller: _listViewController,
      footer: Container(
        height: KSize.jcSignListViewFooterHeight,
      ),
    );

    Provider.of<JcSignModel>(context).moduleSelectDidChange = false;
    }
    return _sectionListView;
  }

  ///
  /// 列表数据中：sectionHeader创建器
  ///
  Widget _sectionHeaderBuilder(
      BuildContext context, IndexPath indexPath, int index) {
//    print('_sectionHeaderBuilder: $indexPath');
    int section = indexPath.section;
    ProcedureModel procedureModel = _jcSignModel.procedureList[section];
    String text = '${procedureModel.titleCn} ${procedureModel.titleEn}';
    TextStyle textStyle = TextStyle(
        color: KColor.textColor_19,
        fontSize: KFont.fontSizePos * _jcSignModel.fontScale,
        fontWeight: FontWeight.bold,
        height: 1);
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(KSize.commonPadding3, KSize.commonPadding2,
            KSize.commonPadding3, KSize.commonPadding2),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: KSize.dividerSize * 4,
                    color: Theme.of(context).primaryColor))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Text(
//              '${procedureModel.no}. ',
//              style: textStyle,
//            ),
            Expanded(
                child: Text(
              text,
              style: textStyle,
            ))
          ],
        ));
  }

  ///
  ///列表数据中：列表cell的创建器
  ///
  Widget _cellItemBuilder(
      BuildContext context, IndexPath indexPath, int index) {
    int section = indexPath.section;
    int row = indexPath.row;
    ProcedureModel procedureModel = _jcSignModel.procedureList[section];
    ProItemModel itemModel = procedureModel.children[row];
    return LySignItem(
      itemModel,
      MediaQuery.of(context).size.width,
    );
  }

  Widget _buildHeader(BuildContext context) {
    _isSelectAll = true;
    Provider.of<JcSignModel>(context).moduleSelectStatus.forEach((status) {
      if (!(true & status.isSelect)) {
        _isSelectAll = false;
      }
    });

    return Container(
      width: _panelWidthOpen,
      height: _headerHeight,
      padding: EdgeInsets.only(left: KSize.commonPadding3),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        children: <Widget>[
          Container(
//            color: Colors.redAccent,
            width: double.infinity,
            height: 200,
            child: Center(
              child: CircleProgress(
                [Colors.yellow, Colors.greenAccent, Colors.white],
                [23, 75, 2],
                Size(275, 200),
                filled: false,
                strokeWidth: 8,
                radius: 54,
                cardLanguage: _jcSignModel.jcLanguage ,
              ),
            ),
          ),
          Divider(
            height: KSize.dividerSize,
            color: KColor.dividerColorWhite,
          ),
          Container(
//            color: Colors.redAccent,
            alignment: Alignment.bottomRight,
            height: 30,
            child: FlatButton(
              padding: EdgeInsets.only(left: 50, top: 10),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: TextWidget(textKey, _isSelectAll, _jcSignModel.jcLanguage,),
              onPressed: () {
                _isSelectAll = !_isSelectAll;
                print('$_isSelectAll ----------- ');
                if (_isSelectAll) {
                  key.currentState.selectAll();
                } else {
                  key.currentState.cancelSelectAll();
                }
              },
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPanelFooter(BuildContext context) {
    TextStyle textStyle =
        TextStyle(color: Colors.white, fontSize: KFont.fontSizeCommon_5);
    return Container(
        width: _panelWidthOpen,
        padding: EdgeInsets.only(left: KSize.commonPadding3),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Divider(
                height: KSize.dividerSize,
                color: KColor.dividerColorWhite,
              ),
              Container(
                  height: KSize.jcSignPanelSettingItemHeight,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "图片模式",
                          style: textStyle,
                        ),
                        CustomSwitch(
                          value: _isImage,
                          onChanged: (value) {
                            _isImage = value;
                            _sectionListView.reloadData();
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.white60,
                        )
                      ])),
              Divider(
                height: KSize.dividerSize,
                color: KColor.dividerColorWhite,
              ),
              InkWell(
                  onTap: () {
                    //跳转到设置页
                    _panelController.close();
                    Application.router.navigateTo(
                        context, Routes.jobCardSettingPage,
                        transition: TransitionType.native);
                  },
                  child: Container(
                      height: KSize.jcSignPanelSettingItemHeight,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "设置",
                              style: textStyle,
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            )
                          ])))
            ]));
  }

  Widget _buildPanel(BuildContext context) {
    return ZLExpansionPanelList(
      _indexController,
      _buildPanelModuleWidgets(context),
      _buildPanelModuleProcedureWidgets(context),
      [20,40,50,60,70],
      hasDividers: false,
      canTapOnHeader: true,
      headerClickCallback: (index, expand) {},
      subItemClickCallback: (parentIndex, subIndex) {
        if (!Provider.of<JcSignModel>(context,listen: false).moduleSelectStatus[parentIndex].isSelect){
          return;
        }
        IndexPath selIndexPath = IndexPath(subIndex, 0);
        _listViewController.scrollToIndex(selIndexPath,
            duration: scrollToIndexDuration);
        _panelController.close();
      },
      moduleSelectChangeCallback: () {
        Provider.of<JcSignModel>(context, listen: false)
            .moduleSelectStatusDidChange();
//        _sectionListView.reloadData();
        setState(() {
        });
      },
      key: key,
    );
  }

  ///
  /// 抽屉里：模块名称一级列表
  ///
  List<Widget> _buildPanelModuleWidgets(BuildContext context) {
    JobCardModel jobCardModel = _jcSignModel.jobCardModel;
    TextStyle textStyle = TextStyle(
        color: Colors.white, fontSize: KFont.fontSizeCommon_1, height: 1.2);
    List<Widget> headers = jobCardModel.bodyModel.children.map((jcModel) {
      ModuleModel moduleModel = jcModel;
      String text = (_jcSignModel.jcLanguage == JobCardLanguage.cn)
          ? moduleModel.titleCn
          : (_jcSignModel.jcLanguage == JobCardLanguage.en)
              ? moduleModel.titleEn
              : '${moduleModel.titleCn} ${moduleModel.titleEn}';
      return Container(
        child: Text(text, style: textStyle),
      );
    }).toList();
    return headers;
  }

  ///
  /// 抽屉里：工序名称二级列表
  ///
  List<List<Widget>> _buildPanelModuleProcedureWidgets(BuildContext context) {
    JobCardModel jobCardModel = _jcSignModel.jobCardModel;
    TextStyle textStyle = TextStyle(
        color: Colors.white, fontSize: KFont.fontSizeCommon_2, height: 1.2);
    Iterable<List<Widget>> items =
        jobCardModel.bodyModel.children.map((jcModel) {
      ModuleModel moduleModel = jcModel;
      List children = moduleModel.children;
      if (children == null || children.isEmpty) {
        return [];
      } else {
        return children.map((subJcModel) {
          ProcedureModel procedureModel = subJcModel;
          String text = (_jcSignModel.jcLanguage == JobCardLanguage.cn)
              ? procedureModel.titleCn
              : (_jcSignModel.jcLanguage == JobCardLanguage.en)
                  ? procedureModel.titleEn
                  : '${procedureModel.titleCn} ${procedureModel.titleEn}';

          return Text(text, style: textStyle);
        }).toList();
      }
    });
    return items.toList();
  }

//
//  Future _scrollToIndex(parentIndex) async {
//    await controller.scrollToIndex(IndexPath(parentIndex, 1),
//        duration: Duration(milliseconds: 500));
//  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }
}

class TextWidget extends StatefulWidget {
  final bool isSelectAll;
  final JobCardLanguage cardLanguage;
  TextWidget(Key key, this.isSelectAll,this.cardLanguage): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextWidgetState();
  }
}

class TextWidgetState extends State<TextWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: Text(
        widget.isSelectAll ?  ((widget.cardLanguage==JobCardLanguage.en)?"Cancel":'取消全选' ):( (widget.cardLanguage==JobCardLanguage.en)?"Select ALL":'全选'),
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
