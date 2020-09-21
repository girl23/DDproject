import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/global.dart';
import '../../../component/sheet_widget.dart';
import '../../../component/sheet_widget_item.dart';
import 'package:lop/model/task_assign_task.dart';
import 'package:lop/provide/image_list_state_dart.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/model/base_response_model.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/alert_dialog_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:provider/provider.dart';

import '../../../utils/translations.dart';
import 'package:lop/config/configure.dart';

// ignore: must_be_immutable
class MyTaskItem extends StatelessWidget {
  final TaskAssignTask _itemData;
  final String _isThird;
  MyTaskItem(this._itemData, this._isThird);
  String _currentMenuKey; //点击的菜单
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: Colors.white,
        child: InkWell(
          child: Card(
              elevation: 0.0,
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(
                  left: KSize.taskDetailInfoPaddingLR,
                  right: KSize.commonPadding2,
                  top: KSize.taskDetailInfoPaddingLR * 0.5,
                  bottom: KSize.taskDetailInfoPaddingLR * 0.5,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _itemData.taskNo ?? " ",
                            style: TextThemeStore.textStyleCard_1,
                          ),
                          SizedBox(
                            height: KSize.taskItemColumnTextSplitHeight,
                          ),
                          Text(
                            _itemData.workType != ""
                                ? Translations.of(context)
                                    .text(_itemData.workType)
                                : " ",
                            style: TextThemeStore.textStyleCard_2,
                          )
                        ],
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              _itemData.isShiftTo == 1
                                  ? Translations.of(context).text("handover")
                                  : _itemData.taskState != ""
                                      ? Translations.of(context)
                                          .text(_itemData.taskState)
                                      : " ",
                              style: TextStyle(
                                  color: _getStateColor(context,
                                      _itemData.isShiftTo, _itemData.taskState),
                                  fontSize: KFont.fontSizeCommon_2),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: KColor.textColor_99,
                              size: KSize.messageCardRightArrowSize,
                            )
                          ],
                        ),
                      ),
                    ]),
              )),
          onTap: () {
            _onTap(context);
          },
        ),
      ),
    );
  }

  Color _getStateColor(BuildContext context, int isShiftTo, String state) {
    if (isShiftTo == 1) {
      //已交班
      return KColor.textColor_b2;
    } else if (state == "unaccept") {
      return Theme.of(context).primaryColor;
    } else {
      return KColor.textColor_b2;
    }
  }

  ///item点击事件
  void _onTap(BuildContext context) {
    _taskItemClick(context);
  }



  /// card点击的操作
  void _taskItemClick(context) {
    List<SheetWidgetItem> _items = _initMenu(context);
    if (_items.length == 0) {
      return null;
    }
    SheetWidget sw = SheetWidget(
      context,
      KFont.fontSizeSheetItem,
      itemHeight: KSize.sheetItemHeight,
//      title: Translations.of(context).text(title),
      titleFontSize: KFont.fontSizeCommon_2,
      children: _items,
      cancelTitle: Translations.of(context).text('cancel'),
    );
    sw.showSheet();
  }

  /// 滑出来的功能区菜单
  List<SheetWidgetItem> _initMenu(BuildContext context) {
    List<SheetWidgetItem> _items = [];
    // 三方增加上传查看图片
    if (this._isThird == '1') {
//      _items.add(_menuItemWidget(context, "uploadPhoto",
//          Translations.of(context).text("uploadPhoto")));
//      _items.add(_menuItemWidget(context, "downloadPhoto",
//          Translations.of(context).text("downloadPhoto")));
    }
    // 根据任务状态处理
    if (_itemData.taskState == 'finished') {
      return _items;
    }
    if (_itemData.taskState == 'unaccept') {
      _items.add(_menuItemWidget(context, "accept",
          Translations.of(context).text("task_detail_page_receive")));
      return _items;
    }
    if (_itemData.taskState == 'apply') {
      return _items;
    }

    if ((_itemData.workType == 'pickup' || _itemData.workType == 'technic') &&
        _itemData.taskState != 'on-spot' &&
        _itemData.taskState != 'unaccept') {
      // 接机、维修人员菜单
      _items.add(_menuItemWidget(context, "onspot",
          Translations.of(context).text("task_detail_page_spot")));
    } else if (_itemData.workType == 'release' &&
        _itemData.taskState != 'unaccept' &&
        _itemData.taskState != 'released' &&
        Global.channel != 'loptest1' &&
        Global.channel != 'loptest2') {
      // 放行人员菜单
      _items.add(_menuItemWidget(context, "release",
          Translations.of(context).text("task_detail_page_task_release")));
    } else if (_itemData.workType == 'transfers' &&
        (_itemData.taskState == 'released' ||
            _itemData.taskState == 'accept')) {
      // 送机人员菜单
      _items.add(_menuItemWidget(context, "transfers",
          Translations.of(context).text("task_detail_page_transfers")));
    } else if ((_itemData.workType == 'service' ||
            _itemData.workType == 'technic') &&
        _itemData.taskState != 'finished') {
      // 勤务、维修人员菜单
      _items.add(_menuItemWidget(context, "finished",
          Translations.of(context).text("task_detail_page_finish")));
    }
    return _items;
  }

  /// 菜单item
  SheetWidgetItem _menuItemWidget(BuildContext context, key, title) {
    return SheetWidgetItem(title, () {
      ///点击
      _menuItemClick(context,key);
    }, textColor: KColor.sheetItemColor);
  }

  void _menuItemClick(BuildContext context, String type){
    _currentMenuKey = type;
    switch (type) {
//      case "uploadPhoto":
//        ImageListStateProvide.uploadPhoto(
//            context,
//            Provider.of<TaskDetailStateProvide>(context, listen: false).taskId,
//            "0");
//        break;
//      case "downloadPhoto":
//        ImageListStateProvide.downloadPhoto(
//            context,
//            Provider.of<TaskDetailStateProvide>(context, listen: false).taskId,
//            "0");
//        break;
      case "release":
        getReleaseInfo(context);
        break;
      default:
        AlertDialogUtil.openOkCancelAlertDialog(
            context, "确定执行此操作吗？", () => assignTaskOperation(context, false));
        break;
    }
  }

  void assignTaskOperation(BuildContext context, bool isRelease) {
    DioManager().request<BaseResponseModel>(
        httpMethod.GET, NetServicePath.assignTaskOperation, context,
        params: {
          'assignid': _itemData.taskAssignId,
          "state": _currentMenuKey,
          "isrelease": isRelease
        }, success: (data) async {
      if (data.result == 'success') {
        AlertDialogUtil.openOkAlertDialog(
            context, "任务操作成功！", (){});
        Provider.of<TaskDetailStateProvide>(context, listen: false)
            .updateTaskDetail(context);
      } else {
        AlertDialogUtil.openOkAlertDialog(
            context, "任务操作失败：" + data.info, (){});
      }
    }, error: (error) {
      ToastUtil.makeToast(error.message, toastType: ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    }).whenComplete(() {});
  }

  void getReleaseInfo(BuildContext context) {
    DioManager().request<BaseResponseModel>(
        httpMethod.GET, NetServicePath.getUnfinishInfo, context,
        params: {'assignid': _itemData.taskAssignId}, success: (data) async {
      if (data.result == 'success') {
        AlertDialogUtil.openOkCancelRichTextAlertDialog(
            context,
            data.info + " 确定执行\"","放行","\"操作吗？",
            () => assignTaskOperation(context, true));
      } else if (data.result == 'fail' && null == data.info) {
        AlertDialogUtil.openOkCancelRichTextAlertDialog(context, "所有维修工作已完成 确定执行\"","放行","\"操作吗？",
            () => assignTaskOperation(context, true));
      } else {
        AlertDialogUtil.openOkAlertDialog(
            context, "任务操作失败：" + data.info, (){});
      }
    }, error: (error) {
      ToastUtil.makeToast(error.message, toastType: ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    }).whenComplete(() {});
  }
}
