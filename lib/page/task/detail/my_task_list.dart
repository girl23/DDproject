import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/model/base_response_model.dart';
import 'package:lop/model/task_detail_model.dart';
import 'package:lop/page/task/detail/my_task_item.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/alert_dialog_util.dart';
import 'package:lop/utils/loading_dialog_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../../../provide/task_detail_state_provide.dart';

/// 任务详情——我的任务
class MyTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  ProgressDialog _loadingDialog;
  var _prolineItem = {};
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        _widgetMyTask(),
        _widgetDivider(),
        _taskWidget(),
      ],
    ));
  }

  //"我的任务"标题行
  Widget _widgetMyTask() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: KSize.taskDetailInfoPaddingLR,right: KSize.taskDetailInfoPaddingLR,
        top: KSize.taskDetailInfoPaddingTB,bottom: KSize.taskDetailInfoPaddingTB),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Translations.of(context).text('task_detail_page_my_task'),
              style: TextThemeStore.textStyleDetailTitle(context),
            ),
            Offstage(
              offstage: _showAllReceiveButton(),

              child: Container(
                height:KSize.taskDetailInfoItemButtonHeight,
                child:FlatButton(
                child: Text(
                  Translations.of(context).text('task_detail_page_receive_all'),
                  style: TextThemeStore.textStylePrimaryButton_item,
                ),
                color: Theme.of(context).buttonColor,
                highlightColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {
                  _acceptOrReceiveTask('accept', '');
                },
              )),
            ),
          ],
        ),
      ),
    );
  }


  bool _showAllReceiveButton(){
    TaskDetailModel taskModel =
        Provider.of<TaskDetailStateProvide>(context).taskDetail;
    if (taskModel.personalState != null) {
      if (taskModel.personalState != 'unaccept') {
        return true;
      }
    }
    return false;
  }

  Widget _taskWidget() {
    return Selector<TaskDetailStateProvide, TaskDetailModel>(
      selector: (context, selector) {
        return selector.taskDetail;
      },
      builder: (context, taskDetail, _) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: taskDetail.taskData.length,
          itemBuilder: (context, index) =>
              MyTaskItem(taskDetail.taskData[index], taskDetail.isThird),
          separatorBuilder: (BuildContext context,int index){
              return Divider(color: KColor.dividerColor,height: KSize.dividerSize);
            },
          physics: NeverScrollableScrollPhysics(),
        );
      },
    );
  }

  Widget _widgetDivider() {
    return Divider(color: KColor.dividerColor, height: KSize.dividerSize);
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
    }).whenComplete(() {
      if (_loadingDialog != null) {
        _loadingDialog.hide();
      }
    });
  }
  /// 显示底部的操作内容
  Future<String> _showModalBottomSheet(Map itemMap, String state) {
    List<Widget> _itemList = [];
    String title = 'task_detail_page_receive_task_title'; //默认标题：选择领取任务类型
    if (state != '') {
      //选择生产线
      title = 'task_detail_page_receive_task_proline_title';
    }
    //添加标题
    _itemList.add(Container(
      height: KSize.bottomSheetSingleHeight,
      child: Center(
        child: Text(
          Translations.of(context).text(title),
          style: TextStyle(
              fontSize: KFont.fontSizeCommon_2,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
      ),
    ));

    //添加项
    itemMap.forEach((key, value) {
      _itemList.add(Divider(
        height: KSize.splitLineHeight,
      ));
      _itemList.add(InkWell(
          child: Container(
            height: KSize.bottomSheetSingleHeight,
            child: Center(
              child: Text(
                state != ''
                    ? value
                    : Translations.of(context)
                    .text('task_detail_page_task_$value'),
                style: TextStyle(
                    fontSize: KFont.fontSizeCommon_2,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
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
          }));
    });

    _itemList.add(Divider(
      height: KSize.commonSplitHeight1,
      thickness: KSize.commonSplitHeight1,
    ));
    //添加取消
    _itemList.add(InkWell(
      child: Container(
        height: KSize.bottomSheetSingleHeight,
        child: Center(
          child: Text(
            Translations.of(context).text('cancel'),
            style: TextStyle(
                fontSize: KFont.fontSizeCommon_2,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pop(),
    ));
    double height =
        KSize.bottomSheetSingleHeight * ((_itemList.length - 1) / 2 + 1) +
            KSize.commonSplitHeight1 * 2;
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _itemList),
        );
      },
    );
  }

}
