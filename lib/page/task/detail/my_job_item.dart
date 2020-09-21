import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/model/jobcard/xml_parse.dart';
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
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../model/jc_sign_model.dart';
import '../../../router/application.dart';
import '../../../router/routes.dart';
import '../../../utils/translations.dart';
import 'package:lop/config/configure.dart';

// ignore: must_be_immutable
class MyJobItem extends StatelessWidget {
  final TaskAssignTask _itemData;
  final String _taskId;
  MyJobItem(this._itemData, this._taskId);
//  String _currentMenuKey; //点击的菜单
  int isSign = 0; //签署还是预览
  @override
  Widget build(BuildContext context) {
    var notSignFile = _itemData.dataType != "TD航线"
        ? "非电签"
        : _itemData.isOfflineProcessing == "1" ? "非电子维修记录" : null;

    return Material(
        child: Ink(
            color: Colors.white,
            child: InkWell(
                onTap: () {
                  _onTap(context);
                },
                child: Card(
                    borderOnForeground: false,
                    elevation: 0.0,
                    color: Colors.transparent,
                    child: Padding(
                        padding: EdgeInsets.only(
                          left: KSize.taskDetailInfoPaddingLR,
                          right: KSize.commonPadding2,
                          top: KSize.commonPadding2,
                          bottom: KSize.commonPadding2,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width - KSize.taskDetailInfoPaddingLR- KSize.commonPadding2-ScreenUtil().setWidth(350),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _itemData.description ?? " ",
                                      style: TextThemeStore.textStyleCard_1,
                                    ),
                                    SizedBox(
                                      height: KSize.taskItemColumnTextSplitHeight,
                                    ),
                                    Text(
                                      _itemData.taskNo ?? " ",
                                      style: TextThemeStore.textStyleCard_2,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  child: Row(children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      _itemData.isShiftTo == 1
                                          ? Translations.of(context)
                                              .text("handover")
                                          : _itemData.isCancel == "1"
                                              ? Translations.of(context)
                                                  .text("canceled")
                                              : _itemData.taskState != ""
                                                  ? Translations.of(context)
                                                      .text(_itemData.taskState)
                                                  : " ",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: KFont.fontSizeItem_2),
                                    ),
                                    notSignFile != null
                                        ? Text(
                                            notSignFile,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: KFont.fontSizeItem_2),
                                          )
                                        : Container()
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: KColor.textColor_99,
                                  size: KSize.messageCardRightArrowSize,
                                )
                              ]))
                            ]))))));
  }

  void _onTap(BuildContext context) {
    _taskItemClick(context);
  }

  void _menuClick(BuildContext context, String type) {
    if (null == type) {
      return;
    }
//    _currentMenuKey = type;
    switch (type) {
      case "preview":
        if (_itemData.layoverJcId == null || _itemData.layoverJcId == 0) {
          AlertDialogUtil.openOkAlertDialog(context, "任务还没确认！", () {});
        } else {
          if (_itemData.taskAcReg != _itemData.jcAcReg) {
            AlertDialogUtil.openOkAlertDialog(
                context,
                "飞机任务机号：" + _itemData.taskAcReg + "/工卡机号：" + _itemData.jcAcReg,
                () => previewSign(context, true),
                clickAutoDismiss: false);
          } else {
            previewSign(context, false);
          }
        }
        break;
      case "finished":
        AlertDialogUtil.openOkCancelRichTextAlertDialog(context, "确定执行\"", "完成",
            "\"操作吗？", () => jcOptAction(context, "finished"));
        break;
//      case "uploadPhoto":
//        ImageListStateProvide.uploadPhoto(
//            context,
//            Provider.of<TaskDetailStateProvide>(context, listen: false).taskId,
//            _itemData.itemId.toString());
//        break;
//      case "downloadPhoto":
//        ImageListStateProvide.downloadPhoto(
//            context,
//            Provider.of<TaskDetailStateProvide>(context, listen: false).taskId,
//            _itemData.itemId.toString());
//        break;
      case "delayWork":
        break;
      default:
        jcOptAction(context, type);
        break;
    }
  }

  void previewSign(BuildContext context, bool isReturn) async{
    if (isReturn) {
      Navigator.of(context).pop();
    }
    if (_itemData.layoverJcId != null && _itemData.layoverJcId != "") {
      print("jcId:${_itemData.layoverJcId}");
      Provider.of<JcSignModel>(context, listen: false).jcId =
          int.parse(_itemData.layoverJcId);
      Provider.of<JcSignModel>(context, listen: false).isJobType =
          _itemData.jcType == '安全检查工作';
      Provider.of<JcSignModel>(context, listen: false).isSign = isSign;
      Provider.of<JcSignModel>(context, listen: false).signTitle = '${_itemData.taskNo}:${_itemData.description}';
      Application.router.navigateTo(context, Routes.jobCardModulePage,
          transition: TransitionType.fadeIn);
//      Application.router.navigateTo(context, Routes.jobCardSignPage,
//          transition: TransitionType.fadeIn);
    }
  }

  void _taskItemClick(context) {
    List<Widget> _items = _menuWidgets(context);
    if (_items.length == 0) {
      return null;
    }
    SheetWidget sw = SheetWidget(
      context,
      KFont.fontSizeSheetItem,
      itemHeight: KSize.sheetItemHeight,
      titleFontSize: KFont.fontSizeCommon_2,
      children: _items,
      cancelTitle: Translations.of(context).text('cancel'),
    );
    sw.showSheet();
  }

  List<SheetWidgetItem> _menuWidgets(context) {
    List<SheetWidgetItem> _items = [];
    if (_itemData.isCancel == "1" ||
        _itemData.isCancel == "2" ||
        _itemData.isCancel == "3") {
      return _items;
    }
//    if (_itemData.jcType != '安全检查工作') {
//      _items.add(_menuItemWidget("uploadPhoto",
//          Translations.of(context).text("uploadPhoto"), context));
//      _items.add(_menuItemWidget("downloadPhoto",
//          Translations.of(context).text("downloadPhoto"), context));
//    }

//    print("jcType:${_itemData.jcType}");
//    print("jcId:${_itemData.jcId}");
//    print("jcState:${_itemData.jcState}");
//    print("taskState:${_itemData.taskState}");

    if (_itemData.dataType == 'TD航线' &&
        _itemData.jcId != null &&
        _itemData.jcId != '') {
      // if (taskState === 'on-work') {
      if (_itemData.jcState != 'finished' &&
          (_itemData.taskState == 'on-work' ||
              _itemData.taskState == 'finished')) {
        _items.add(_menuItemWidget(
            "preview", Translations.of(context).text("jcsign"), context));
        isSign = 1;
      } else {
        _items.add(_menuItemWidget(
            "preview", Translations.of(context).text("jcpreview"), context));
        isSign = 0;
      }
    }

    // 领取，待确认
    if (_itemData.taskState == 'apply') {
//      _items.remove(_menuItemWidget("uploadPhoto",
//          Translations.of(context).text("uploadPhoto"), context));
    } else if (_itemData.taskState == 'unaccept') {
      // 待接收，接收
      _items.clear();
      _items.add(_menuItemWidget("accept",
          Translations.of(context).text("task_detail_page_receive"), context));
    } else if (_itemData.taskState == 'accept') {
      // 已接收
      _items.add(_menuItemWidget("on-work",
          Translations.of(context).text("task_detail_page_work"), context));
      // Object.assign(this.menus, { finished: '完成' })
      if (_itemData.jcType == 'SAP附加') {
        _items.add(_menuItemWidget(
            "delayWork",
            Translations.of(context).text("task_detail_page_apply_cancel"),
            context));
      }
    } else if (_itemData.taskState == 'on-work') {
      // 已开工
      _items.add(_menuItemWidget("finished",
          Translations.of(context).text("task_detail_page_finish"), context));
      if (_itemData.jcType == 'SAP附加') {
        _items.add(_menuItemWidget(
            "delayWork",
            Translations.of(context).text("task_detail_page_apply_cancel"),
            context));
      }
    }
    return _items;
  }

  SheetWidgetItem _menuItemWidget(key, title, context) {
    return SheetWidgetItem(title, () {
      _menuClick(context, key);
    }, textColor: KColor.sheetItemColor);
  }

  void jcOptAction(BuildContext context, String state) {
    if (state == 'finished' && _itemData.jcType != "安全检查工作") {
      DioManager().request<BaseResponseModel>(
          httpMethod.GET, NetServicePath.getPhotoInfo, context,
          params: {
            'taskid': _taskId,
            'jcid': _itemData.itemId,
            'userid':
                Provider.of<UserViewModel>(context, listen: false).info.userId
          }, success: (data) async {
        if (data.result == 'success') {
          //获取数据成功
          itemOperation(context, state);
        } else {
          AlertDialogUtil.openOkAlertDialog(
              context, data.info + "，不能完工操作！", () {});
        }
      }, error: (error) {
        ToastUtil.makeToast(error.message, toastType: ToastType.ERROR);
        print('error code = ${error.code} message = ${error.message}');
      }).whenComplete(() {});
    } else {
      itemOperation(context, state);
    }
  }

  void itemOperation(BuildContext context, String state) {
    DioManager().request<BaseResponseModel>(
        httpMethod.GET, NetServicePath.itemOperation, context,
        params: {
          'taskid': _taskId,
          'tasktype': 'task',
          'currentid': _itemData.taskAssignId,
          'state': state,
        }, success: (data) async {
      if (data.result == 'success') {
        //获取数据成功
        AlertDialogUtil.openOkAlertDialog(context, "任务操作成功！", () {});
        Provider.of<TaskDetailStateProvide>(context, listen: false)
            .updateTaskDetail(context);
      } else {
        AlertDialogUtil.openOkAlertDialog(context, "操作失败：" + data.info, () {});
      }
    }, error: (error) {
      ToastUtil.makeToast(error.message, toastType: ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    }).whenComplete(() {});
  }
}
