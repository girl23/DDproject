import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/style/size.dart';
import 'package:provider/provider.dart';
import 'expand_state_bean.dart';
import 'expansion_panel_list.dart' as fold;
//import 'fold_expand_event_bust.dart';
import 'index_controller.dart';
import 'select_data.dart';

//头部点击回调
typedef HeaderClickCallback = void Function(int panelzIndex, bool isExpanded);
//子项点击回调
typedef SubItemClickCallback = void Function(int parentIndex, int childIndex);

typedef CheckBoxClickCallback = void Function();

class ZLExpansionPanelList extends StatefulWidget {
  IndexController indexController;
  SelectDataModel _selectDataModel;
  final bool hasDividers; //分割线
  final bool canTapOnHeader; //是否可以点击头部
  final List<Widget> headerWidgets;
  final List<List<Widget>> subWidgets; //子项视图
  final HeaderClickCallback headerClickCallback; //头部点击回调
  final SubItemClickCallback subItemClickCallback; //子项点击回调
  final CheckBoxClickCallback moduleSelectChangeCallback; //复选框点击回调
  final List processCompleteList;
  ZLExpansionPanelList(
      this.indexController, this.headerWidgets, this.subWidgets,this.processCompleteList,
      {Key key,
      this.hasDividers = false,
      this.canTapOnHeader = false,
      this.headerClickCallback,
      this.subItemClickCallback,
      this.moduleSelectChangeCallback})
      : super(key: key);
  ZLExpansionPanelListState createState() => ZLExpansionPanelListState();
}

class ZLExpansionPanelListState extends State<ZLExpansionPanelList> {
  //记录headerIndex;
  List<int> _mList = [];
  //记录headerIndex对应的折叠状态
  List<ExpandStateBean> _expandStateList;

  //控制复选框状态
  List<ModuleSelectStateBean> _isSelectList;
  int selectHeaderIndex;
  int selectSubIndex;

  loadData() {
    print('取消全选/加载新数据');
    _mList = new List();
    _expandStateList = new List();
//    _isSelectList = new List();
    for (int i = 0; i < widget.headerWidgets.length; i++) {
      _mList.add(i);
      _expandStateList.add(ExpandStateBean(i, false)); //默认全部折叠
//      _isSelectList.add(SelectStateBean(i, false));
    }
  }

  //全选
  selectAll() {
    print('全选--');
//    _mList=new List();
//    _expandStateList=new List();
//    for(int i=0;i<widget.headerWidgets.length;i++){
//      _mList.add(i);
//      _expandStateList.add(ExpandStateBean(i,true));
//    }

    setState(() {
      //遍历可展开状态列表
      _isSelectList.forEach((item) {
        item.isSelect = true;
      });
    });

    if(widget.moduleSelectChangeCallback != null){
      widget.moduleSelectChangeCallback();
    }
  }

  cancelSelectAll() {
    setState(() {
      //遍历可展开状态列表
      _isSelectList.forEach((item) {
        item.isSelect = false;
      });
    });

    if(widget.moduleSelectChangeCallback != null){
      widget.moduleSelectChangeCallback();
    }
  }

  void changeModuleSelectStatus(int index, bool status){
    _isSelectList[index].isSelect = status;
  }

  //修改展开与闭合的内部方法
  _setCurrentIndex(int index, isExpand) {
    setState(() {
      //遍历可展开状态列表
      _expandStateList.forEach((item) {
        if (item.index == index) {
          item.isOpen = isExpand;
        }
      });
    });
  }

  //设置内部复选框
  _setCheckBoxForCurrentIndex(int index, isSelect) {
    setState(() {
      //遍历可展开状态列表
      _isSelectList.forEach((item) {
        if (item.index == index) {
          item.isSelect = isSelect;
        }
      });
    });
  }

  var result;
//监听Bus events
//  void _listen(){
//    eventBus.on<ChangeIndexEventBus>().listen((event){
//      print('===${event.changeSubIndex}====${event.changeHeaderIndex}');
//      selectHeaderIndex=event.changeHeaderIndex;
//      selectSubIndex=event.changeSubIndex;
//      setState(() {
//
//      });
//    });
//  }
  //
  @override
  void initState() {
    super.initState();
//    _listen();
    widget._selectDataModel = new SelectDataModel(0, 0);
    widget.indexController.setSelectedDataModel(widget._selectDataModel);
    widget.indexController?.indexPosition?.addListener(_indexChanged);
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isSelectList = Provider.of<JcSignModel>(context).moduleSelectStatus;
  }

  void _indexChanged() {
    SelectDataModel oldModel = widget.indexController.indexPosition.value[0];
    SelectDataModel newModel = widget.indexController.indexPosition.value[1];
    selectHeaderIndex = newModel.selectedHeaderIndex;
    selectSubIndex = newModel.selectedSubIndex;
    print('我要刷新了${selectHeaderIndex}===${selectSubIndex}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ///构造 section 时,计算此前所有 section 的 row 的总和
    int sectionRowOffset = 0;
    return Container(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: fold.ExpansionPanelList(
          processCompleteList: widget.processCompleteList,
          hasDividers: widget.hasDividers,
          //交互回调属性，里面是个匿名函数
          expansionCallback: (index, bol) {
            //调用内部方法
            _setCurrentIndex(index, !bol);
            widget.headerClickCallback(index, !bol);
          },
          checkBoxCallback: (index, bol) {
            //复选框
            _setCheckBoxForCurrentIndex(index, !bol);
            if(widget.moduleSelectChangeCallback != null){
              widget.moduleSelectChangeCallback();
            }
          },
          //进行map操作，然后用toList再次组成List
          children: _mList.map((index) {
            int indexExpectZero = index - 1;
            if(indexExpectZero >= 0) {
              ModuleSelectStateBean selStatus = Provider.of<JcSignModel>(context).moduleSelectStatus[indexExpectZero];
              if(selStatus.isSelect){
                sectionRowOffset += widget.subWidgets[indexExpectZero].length;
              }
            }

            //返回一个组成的ExpansionPanel
            return fold.ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  child: widget.headerWidgets[index],
                );
              },
              body: Container(
                  child: Column(
                children: <Widget>[
                  Container(
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          subWidget(widget.subWidgets[index], index, sectionRowOffset),
                        ],
                      ))
                ],
              )),
              isExpanded: _expandStateList[index].isOpen,
              isSelect: _isSelectList[index].isSelect, //闭合状态
              canTapOnHeader: widget.canTapOnHeader,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget subWidget(List subWidget, int index, int sectionRowOffset) {
    List<int> smList = [];
    for (int i = 0; i < subWidget.length; i++) {
      smList.add(i);
    }
    //点击后背景发生变化
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: smList.map((subIndex) {
        return Row(children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
              flex: 13,
              child: Material(
                color: selectHeaderIndex == index && selectSubIndex == subIndex
                    ? Colors.grey
                    : Colors
                        .transparent, // index==selectHeaderIndex&&subIndex==selectSubIndex?Colors.red:Colors.transparent,
                child: Ink(
                    width: double.infinity,
                    child: InkWell(
                        onTap: () {
                          int realProcedureIndex = subIndex + sectionRowOffset;
                          widget.subItemClickCallback(index, realProcedureIndex);
                          selectHeaderIndex = index;
                          selectSubIndex = subIndex;
                          setState(() {});
                        },
                        child: Container(
                            padding: EdgeInsets.only(
                                top: KSize.commonPadding1,
                                bottom: KSize.commonPadding1,
                                left: KSize.commonPadding1),
                            child: Row(children: <Widget>[
                              Container(
                                child: Icon(
                                  Icons.fiber_manual_record,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(
                                    left: KSize.commonMargin2,
                                    right: KSize.commonMargin2),
                                child: subWidget[subIndex],
                              ))
                            ])))),
                elevation: 0,
              ))
        ]);
      }).toList(),
    );
  }
}
