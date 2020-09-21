import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../component/sheet_widget.dart';
import '../../../component/sheet_widget_item.dart';
import 'package:lop/component/xy_dialog_widget.dart';
import 'package:lop/model/task_detail_model.dart';
import 'package:lop/provide/image_list_state_dart.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/model/base_response_model.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/alert_dialog_util.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:lop/config/configure.dart';

//任务详情——功能操作区
class TaskOperator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskOperatorState();
}

class _TaskOperatorState extends State<TaskOperator> {
  ProgressDialog _loadingDialog;
  var _taskItem = {
    'service': 'service',
    'technic': 'technic',
    'release': 'release',
    'pickup': 'pickup',
    'transfers': 'transfers'
  };
  var _buttonItem = [];
  var _prolineItem = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: initButton(),
      ),
    );
  }

  List<Widget> initButton() {
    TaskDetailModel taskModel =
        Provider.of<TaskDetailStateProvide>(context).taskDetail;
    List<Widget> widgetList = new List();
    _buttonItem = ['receive', 'receive_task','upload_photo',
      'download_photo', 'hand_over', 'remark'];
    if (taskModel.personalState != null) {
      if (taskModel.personalState != 'unaccept') {
        _buttonItem.remove('receive');
      }
      if (taskModel.personalState == "nothing") {
        _buttonItem.remove('hand_over');
      }
    }
    for (String btn in _buttonItem) {
      if (btn == 'receive_task') {//领取任务
        widgetList.add(_widgetReceiveTask());
      }

      //上传图片
      if (btn == 'upload_photo') {
        if (widgetList.length >= 1) {
          widgetList.add(_widgetDivider());
        }
        widgetList
            .add(_widgetPhoto(1, Translations.of(context).text("uploadPhoto")));
      }
      //预览图片
      if (btn == 'download_photo') {
        if (widgetList.length >= 1) {
          widgetList.add(_widgetDivider());
        }
        widgetList.add(
            _widgetPhoto(2, Translations.of(context).text("downloadPhoto")));
      }
      //交班
      if (btn == 'hand_over') {
        if (widgetList.length >= 1) {
          widgetList.add(_widgetDivider());
        }
        widgetList.add(_widgetHandOverOrRemark(
            1, Translations.of(context).text("task_detail_page_hand_over")));
      }
      //备注
      if (btn == 'remark') {
        if (widgetList.length >= 1) {
          widgetList.add(_widgetDivider());
        }
        widgetList.add(_widgetHandOverOrRemark(
            2, Translations.of(context).text("task_detail_page_remark")));
      }
    }
    return widgetList;
  }

  //"领取"任务的行
  Widget _widgetReceiveTask() {
    return Container(
      padding: EdgeInsets.only(left: KSize.taskDetailInfoPaddingLR),
      child: Padding(
        padding: KSize.taskDetailContentPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Translations.of(context).text('task_detail_page_task'),
              style: TextThemeStore.textStyleDetailItemTitle,
            ),
            Container(
              height: KSize.taskDetailInfoItemButtonHeight,
              child: FlatButton(
                child: Text(
                  Translations.of(context).text('tast_detail_page_receive'),
                  style: TextThemeStore.textStylePrimaryButton_item,
                ),
                color: Theme.of(context).buttonColor,
                highlightColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {
                  _showModalBottomSheet(_taskItem, '');
                },
              ),
            )
          ],
        ),
      ),
    );
  }


  //"上传图片"、"下载图片"
  Widget _widgetPhoto(int type, String textName) {
    return Material(
        child: Ink(
            color: Colors.white,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(
                    left: KSize.taskDetailInfoPaddingLR,
                    top: KSize.taskDetailInfoPaddingTB,
                    bottom: KSize.taskDetailInfoPaddingTB),
                child: Padding(
                  padding: EdgeInsets.only(right: KSize.commonPadding2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        textName,
                        style: TextThemeStore.textStyleDetailItemTitle,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: KColor.textColor_99,
                        size: KSize.messageCardRightArrowSize,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                _photoAction(type);
              },
            )));
  }

  //"交班"、"备注"行
  Widget _widgetHandOverOrRemark(int type, String textName) {
    return Material(
        child: Ink(
            color: Colors.white,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(
                    left: KSize.taskDetailInfoPaddingLR,
                    top: KSize.taskDetailInfoPaddingTB,
                    bottom: KSize.taskDetailInfoPaddingTB),
                child: Padding(
                  padding: EdgeInsets.only(right: KSize.commonPadding2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        textName,
                        style: TextThemeStore.textStyleDetailItemTitle,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: KColor.textColor_99,
                        size: KSize.messageCardRightArrowSize,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                if (type == 1) {
                  //交班
                  _shiftWork();
                } else if (type == 2) {
                  //备注
                  String remark = Provider.of<TaskDetailStateProvide>(context,
                              listen: false)
                          .taskDetail
                          .remark
                          .isNotEmpty
                      ? Provider.of<TaskDetailStateProvide>(context,
                              listen: false)
                          .taskDetail
                          .remark
                      : Translations.of(context)
                          .text('task_detail_page_no_remark');
                  remark = remark.replaceAll("\r\n", ";");
                  if(remark.length > 0&& remark.endsWith(";")){
                    remark = remark.substring(0,remark.length-1);
                  }

                  doubleButtonInputDialog(context,
                      title: Translations.of(context).text('remark'),
                      info: remark,
                      gravity: Gravity.bottom,
                      buttonRightText: Translations.of(context).text('confirm'),
                      onTapRight: (value) {
                    print("doubleButtonInputDialog:$value");
                  },
                      buttonLeftText: Translations.of(context).text('cancel'),
                      onTapLeft: () {},
                      disable: true);
                }
              },
            )));
  }

  Widget _widgetDivider() {
    return Divider(
      color: KColor.dividerColor,
      height: KSize.dividerSize,
      indent: 0,
    );
  }

  /// 交班
  void _shiftWork() async {
    TaskDetailModel taskModel =
        Provider.of<TaskDetailStateProvide>(context, listen: false).taskDetail;
    print("交班操作：state = ${taskModel.state}");
    if (taskModel.state == 'finished') {
      AlertDialogUtil.openOkAlertDialog(context, "任务已经完成，不能再做其他操作！", () {});
    } else if (taskModel.personalState == 'unaccept') {
      AlertDialogUtil.openOkAlertDialog(context, "任务未接收！", () {});
    } else {
//      await Navigator.push(context, PopRoute(child: BottomInputDialog()))
//          .then((data) {
//        print(data);
//        if (null != data) {
//          shiftWork(context, data);
//        }
//      });
      doubleButtonInputDialog(context,
          title: Translations.of(context).text('task_detail_page_hand_over_dialog_title'),
          info: "",
          gravity: Gravity.bottom,
          buttonRightText: Translations.of(context).text('task_detail_page_hand_over_commit'),
          onTapRight: (value) {
//            print("doubleButtonInputDialog:$value");
        shiftWork(context, value);
      },
          buttonLeftText: Translations.of(context).text('cancel'),
          onTapLeft: () {},
          disable: false);
    }
  }

  void shiftWork(BuildContext context, String shiftInfo) {
    TaskDetailModel taskModel =
        Provider.of<TaskDetailStateProvide>(context, listen: false).taskDetail;
    if (taskModel.isFirstShift == 'true') {
      //第一次交班
      if (null != taskModel.jcData && taskModel.jcData.length > 0) {
        //有工卡任务，需判断所有工卡任务是否上次图片
        String jcIdStr = '';
        taskModel.jcData.forEach((taskAssignTask) {
          if (jcIdStr != '') {
            jcIdStr += ',' + taskAssignTask.itemId.toString();
          } else {
            jcIdStr = taskAssignTask.itemId.toString();
          }
        });
        DioManager().request<BaseResponseModel>(
            httpMethod.GET, NetServicePath.getPhotoInfo, context,
            params: {
              'taskid': taskModel.data.mdLayoverTaskId,
              'jcid': jcIdStr,
              'userid':
                  Provider.of<UserViewModel>(context, listen: false).info.userId
            }, success: (data) async {
          if (data.result == 'success') {
            //获取数据成功
            shiftWorkFunc(taskModel, context, shiftInfo);
          } else {
            ToastUtil.makeToast(data.info);
          }
        }, error: (error) {
          ToastUtil.makeToast(error.message, toastType: ToastType.ERROR);
          print('error code = ${error.code} message = ${error.message}');
        }).whenComplete(() {});
      } else {
        shiftWorkFunc(taskModel, context, shiftInfo);
      }
    } else {
      shiftWorkFunc(taskModel, context, shiftInfo);
    }
  }

  void shiftWorkFunc(
      TaskDetailModel taskModel, BuildContext context, String data) {
    DioManager().request<BaseResponseModel>(
        httpMethod.POST, NetServicePath.shiftWork, context,
        params: {
          'taskid': taskModel.data.mdLayoverTaskId,
          'shiftinfo': data,
          'shifttype': 'team',
          'editshift': (taskModel.isFirstShift == 'true' ? 'false' : 'true')
        }, success: (data) async {
      if (data.result == 'success') {
        //获取数据成功
        AlertDialogUtil.openOkAlertDialog(context, "交班成功！", () {});
        Provider.of<TaskDetailStateProvide>(context, listen: false)
            .updateTaskDetail(context);
      } else {
        AlertDialogUtil.openOkAlertDialog(context, "交班失败：" + data.info, () {});
      }
    }, error: (error) {
      ToastUtil.makeToast(error.message, toastType: ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    }).whenComplete(() {
      print('shift work fun complete');
    });
  }

  /// 查询任务子列表/接受任务
  /// proline为''时表示查询子列表
  void _acceptOrReceiveTask(String state, String proline) {
    if (proline != '') {
      //查询子列表时不显示loading
      if (_loadingDialog == null) {
        _loadingDialog = LoadingDialogUtil.createProgressDialog(context);
      }
      _loadingDialog.show();
    }

    TaskDetailModel taskModel =
        Provider.of<TaskDetailStateProvide>(context, listen: false).taskDetail;
    DioManager().request<BaseResponseModel>(
        httpMethod.GET, NetServicePath.taskOperation, context, params: {
      'taskid': taskModel.data.mdLayoverTaskId,
      'state': state,
      'proline': proline
    }, success: (data) async {
      if (_loadingDialog != null) {
        _loadingDialog.hide();
      }
      if (data.proline != null && data.proline != '') {
        _prolineItem.clear();
        var prolineArr = data.proline.split(';');
        for (var i = 0; i < prolineArr.length; i++) {
          var prolineStr = prolineArr[i];
          var prolineObj = prolineStr.split(',');
          var proline = {};
          proline[prolineObj[0]] = prolineObj[1];
          _prolineItem.addAll(proline);
        }
        _showModalBottomSheet(_prolineItem, state); //打开生产线选择菜单
      } else if (data.result == 'success') {
        //获取数据成功
        AlertDialogUtil.openOkAlertDialog(context, "任务操作成功！", () {});
        Provider.of<TaskDetailStateProvide>(context, listen: false)
            .updateTaskDetail(context);
      } else {
        AlertDialogUtil.openOkAlertDialog(
            context, "任务操作失败：" + data.info, () {});
      }
    }, error: (error) {
      ToastUtil.makeToast(error.message, toastType: ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    }).whenComplete(() {
      if (_loadingDialog != null) {
        _loadingDialog.hide();
      }
    });
  }


  ///图片操作处理
  void _photoAction(int type) {
    if (type == 1) {
      //上传图片
//      TaskDetailModel taskModel =
//          Provider.of<TaskDetailStateProvide>(context, listen: false).taskDetail;
//      print("交班操作：state = ${taskModel.state}");
//      if (taskModel.state == 'finished') {
//        AlertDialogUtil.openOkAlertDialog(context, "任务已经完成，不能再做其他操作！", () {});
//      } else if (taskModel.personalState == 'unaccept') {
//        AlertDialogUtil.openOkAlertDialog(context, "任务未接收！", () {});
//      }else{
      ImageListStateProvide.uploadPhoto(
          context,
          Provider.of<TaskDetailStateProvide>(context, listen: false).taskId,
          '0');
//      }
    } else if (type == 2) {
      //预览图片
      ImageListStateProvide.downloadPhoto(
          context,
          Provider.of<TaskDetailStateProvide>(context, listen: false).taskId,
          '0',true);
    }
  }


  /// 显示底部的操作内容
  void _showModalBottomSheet(Map itemMap, String state) {
    List<SheetWidgetItem> _itemList = [];
    String title = 'task_detail_page_receive_task_title'; //默认标题：选择领取任务类型
    if (state != '') {
      //选择生产线
      title = 'task_detail_page_receive_task_proline_title';
    }
    //添加项
    itemMap.forEach((key, value) {
      SheetWidgetItem item = SheetWidgetItem(
        (state != '')?value:Translations.of(context).text('task_detail_page_task_$value'), () {
        if (state == '') {
          //选择领取任务类型
          AlertDialogUtil.openOkCancelRichTextAlertDialog(
              context,
              "确定领取\"",
                  Translations.of(context)
                      .text('task_detail_page_task_$value'),
                  "\"工作吗？",
              () => _acceptOrReceiveTask(key, ''));
        } else {
          //选择生产线
          _acceptOrReceiveTask(state, key);
        }
      }, textColor: KColor.sheetItemColor);
      _itemList.add(item);
    });

    SheetWidget sw = SheetWidget(
      context,
      KFont.fontSizeSheetItem,
      itemHeight: KSize.sheetItemHeight,
      title: Translations.of(context).text(title),
      titleFontSize: KFont.fontSizeCommon_2,
      children: _itemList,
      cancelTitle: Translations.of(context).text('cancel'),
    );
    sw.showSheet();
  }
}

/// 交班的输入框
class BottomInputDialog extends StatelessWidget {
  final TextEditingController _contentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TaskDetailModel taskModel =
        Provider.of<TaskDetailStateProvide>(context, listen: false).taskDetail;
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Column(
        children: <Widget>[
          Expanded(
              child: new GestureDetector(
            child: new Container(
              color: Colors.black54,
            ),
            onTap: () {
              //Navigator.of(context).pop();
            },
          )),
          new Container(
              height: ScreenUtil().setHeight(650),
              color: Colors.white,
              padding: EdgeInsets.all(
                  KSize.commonPadding2), //margin: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(KSize.commonPadding2 * 2),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(KSize.commonPadding2 * 2),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              style: BorderStyle.solid,
                              width: ScreenUtil().setWidth(2))),
                      labelText: Translations.of(context)
                          .text('task_detail_page_input_pickup'),
                      labelStyle: TextStyle(
                          fontSize: KFont.fontSizeCommon_1,
                          wordSpacing: KSize.commonWordSpacing,
                          textBaseline: TextBaseline.alphabetic,
                          fontWeight: FontWeight.bold),
                    ),
                    style: TextStyle(
                      fontSize: KFont.fontSizeCommon_2,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                    autofocus: true,
                    maxLines: 5,
                    maxLength: 2000,
                    textAlign: TextAlign.justify,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: KSize.taskDetailOperatorAreaHeight,
                          child: RaisedButton(
                            color: Colors.green,
                            child: Text(
                              taskModel.isFirstShift == 'true'
                                  ? Translations.of(context)
                                      .text('task_detail_page_hand_over')
                                  : Translations.of(context)
                                      .text('task_detail_page_input_button'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: KFont.fontSizeCommon_2,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(_contentController.text);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: KSize.taskDetailOperatorAreaHeight,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                Translations.of(context).text('cancel'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: KFont.fontSizeCommon_2,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ))
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
