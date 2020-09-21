import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../component/sheet_widget.dart';
import '../../../component/sheet_widget_item.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/model/task_assign_jc_other.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/alert_dialog_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:provider/provider.dart';
import '../../../utils/translations.dart';
import 'package:lop/model/base_response_model.dart';

class OtherJobItem extends StatelessWidget {
  final TaskAssignJcOther _itemData;
  final String _personalState;
  final String _taskID;
  OtherJobItem(this._itemData, this._personalState,this._taskID);
  @override
  Widget build(BuildContext context) {
    return
      Material(
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
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _itemData.description ?? " ",
                        style:  TextThemeStore.textStyleCard_1,
                      ),
                      SizedBox(
                        height: KSize.taskItemColumnTextSplitHeight,
                      ),
                      Text(
                        _itemData.jcNumber ?? " ",
                        style:  TextThemeStore.textStyleCard_2,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              _itemData.jcType == '安全检查工作'?"安全检查单":_itemData.workType ?? " ",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: KFont.fontSizeItem_2),
                            ),
                            _itemData.workType != "TD航线" ?
                            Text(
                              "非电签",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: KFont.fontSizeItem_2),
                            ) : Container()
                          ]),
                      Icon(
                        Icons.chevron_right,
                        color: KColor.textColor_99,
                        size: KSize.messageCardRightArrowSize,
                      ),
                    ],
                  )
                )
              ],
            ),
          )),
    )));
  }

  void _onTap(BuildContext context) {
     _taskItemClick(context);

  }

  void _menuItemClick(BuildContext context, String type){
    if (null == type) {
      return;
    }
    switch (type) {
      case "preview1":
        if (_itemData.layoverJcId == null || _itemData.layoverJcId == 0) {
          AlertDialogUtil.openOkAlertDialog(
              context, "任务还没确认！", (){});
        } else {
          if (_itemData.layoverJcId != null && _itemData.layoverJcId != 0) {
            print("jcId:${_itemData.layoverJcId}");
            Provider.of<JcSignModel>(context, listen: false).jcId =
                int.parse(_itemData.layoverJcId.toString());
            Provider.of<JcSignModel>(context, listen: false).isJobType = _itemData.jcType == '安全检查工作';
            Provider.of<JcSignModel>(context, listen: false).isSign = 0;
            Provider.of<JcSignModel>(context, listen: false).signTitle = '${_itemData.jcNumber}:${_itemData.description}';

            Application.router.navigateTo(context, Routes.jobCardSignPage,
                transition: TransitionType.fadeIn);
          }
        }
        break;
      case "receive":
        if (_itemData.layoverJcId == null || _itemData.layoverJcId == 0) {
          AlertDialogUtil.openOkAlertDialog(
              context, "任务还没确认！", (){});
        } else {
          AlertDialogUtil.openOkCancelAlertDialog(
              context, Translations.of(context).text('tast_detail_page_receive_tip'), (){
            itemOperation(context, 'accept');
          });
        }
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }

  void _taskItemClick(context) {
    List<SheetWidgetItem> _items = _initWidgets(context);
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

  List<SheetWidgetItem> _initWidgets(context) {
    List<SheetWidgetItem> _items = [];
    if ((_personalState == "nothing" && _itemData.jcType != '特殊工作' && _itemData.jcType != '安全检查工作') || _itemData.workType != "TD航线") {
      return _items;
    } else if(_itemData.workType == "TD航线" && (_itemData.jcType == '特殊工作' || _itemData.jcType == '安全检查工作')){
      _items.add(_itemWidget('receive', Translations.of(context).text('tast_detail_page_receive'), context));
      _items.add(_itemWidget("preview1", Translations.of(context).text('tast_detail_page_preview'), context));
    }
    return _items;
  }

  Widget _itemWidget(key, title, context) {
    return SheetWidgetItem(title, () {
      ///点击
      _menuItemClick(context,key);
    }, textColor: KColor.sheetItemColor);
  }

  void itemOperation(BuildContext context, String state) {
    DioManager().request<BaseResponseModel>(
        httpMethod.GET, NetServicePath.itemOperation, context,
        params: {
          'taskid': _taskID,
          'tasktype': 'jc',
          'currentid': _itemData.id,
          'state': state,
        }, success: (data) async {
      if (data.result == 'success') {
        //获取数据成功
        ToastUtil.makeToast(Translations.of(context).text('tast_detail_page_operation_success'));
        Provider.of<TaskDetailStateProvide>(context, listen: false).updateTaskDetail(context);
      } else {
        ToastUtil.makeToast(Translations.of(context).text('tast_detail_page_operation_failed'));
      }
    }, error: (error) {
      ToastUtil.makeToast(error.message,toastType:ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    }).whenComplete(() {});
  }
}
