import 'package:flutter/material.dart';
import 'package:lop/model/task_model.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/date_util.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final TaskModel _task;
  final FocusNode outSideFocusNode;
  TaskCard(this._task, {this.outSideFocusNode});
  @override
  Widget build(BuildContext context) {
    //处理时间显示和状态显示
    String timeStr = '';
    String arrivetime = "";
    String leaveTime = "";
    if (_task.arriveTimeReal != null && _task.arriveTimeReal != 0) {
      arrivetime = DateUtil.formateMDHM_seconds(_task.arriveTimeReal);
    } else if (_task.arriveTimePre != null && _task.arriveTimePre != 0) {
      arrivetime = DateUtil.formateMDHM_seconds(_task.arriveTimePre);
    } else {
      arrivetime = DateUtil.formateMDHM_seconds(_task.arriveTimePlan);
    }
    if (_task.leaveTimeReal != null && _task.leaveTimeReal != 0) {
      leaveTime = DateUtil.formateMDHM_seconds(_task.leaveTimeReal);
    } else if (_task.leaveTimePre != null && _task.leaveTimePre != 0) {
      leaveTime = DateUtil.formateMDHM_seconds(_task.leaveTimePre);
    } else {
      leaveTime = DateUtil.formateMDHM_seconds(_task.leaveTimePlan);
    }
    if (null != arrivetime &&
        arrivetime != "" &&
        null != leaveTime &&
        leaveTime != "") {
      timeStr = arrivetime + ' -- ' + leaveTime;
    } else if (null != arrivetime && arrivetime != "") {
      timeStr = arrivetime;
    } else {
      timeStr = leaveTime;
    }
//    print(_task.toJson().toString());
    return Material(
        child: Ink(
            color:
                _task.udf5 == 'true' ? KColor.myTaskUdf5_1 : KColor.myTaskUdf5_0,
            child: InkWell(
                onTap: () async {
                  if (outSideFocusNode != null && outSideFocusNode.hasFocus) {
                    FocusScope.of(context).unfocus();
                    return;
                  }
                  Provider.of<TaskDetailStateProvide>(context, listen: false)
                      .updateArgs(_task.mdLayoverTaskId.toString(),
                          null != _task.udf1 ? _task.udf1 : '', _task.acReg);
                  Provider.of<TaskDetailStateProvide>(context, listen: false)
                      .updateTaskDetail(context,
                          openDetail: true, showProgressDialog: true);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).unfocus();
                  });
                },
                child: Card(
                  borderOnForeground: false,
                  elevation: 0.0,
                  color: Colors.transparent,

                  ///elevation: KSize.tableItemCardElevation,
                  child: Container(
                    margin: EdgeInsets.only(left: KSize.commonPadding2),
                    padding: EdgeInsets.all(KSize.commonPadding2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: <Widget>[
                              new Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      null != _task.acReg
                                          ? !_task.acReg.contains("B-")
                                              ? _task.acReg
                                                      .replaceAll("B", "B-") +
                                                  ' '
                                              : _task.acReg + ' '
                                          : 'N/A ',
                                      style: TextStyle(
                                        fontSize: KFont.fontSizeItem_1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: KSize.taskItemRowTextSplitWidth,
                                    ),
                                    Text(
                                      null != _task.taskType
                                          ? _task.taskType.trim()
                                          : "",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: KFont.fontSizeItem_1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: null != _task.taskType
                                          ? KSize.taskItemRowTextSplitWidth
                                          : 0,
                                    ),
                                    Text(
                                      null != getAcPlace(_task)
                                          ? getAcPlace(_task).trim()
                                          : '',
                                      style: TextStyle(
                                        fontSize: KFont.fontSizeItem_1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: null != getAcPlace(_task) &&
                                              getAcPlace(_task).trim().length !=
                                                  0
                                          ? KSize.taskItemRowTextSplitWidth
                                          : 0,
                                    ),
                                    Text(
                                      null != _task.arrApt
                                          ? _task.arrApt.trim()
                                          : "",
                                      style: TextStyle(
                                        fontSize: KFont.fontSizeItem_1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: null != _task.arrApt
                                          ? KSize.taskItemRowTextSplitWidth
                                          : 0,
                                    ),
                                    Text(
                                      '${null != _task.arriveFlightNo && _task.arriveFlightNo != "" ? _task.arriveFlightNo + ' ' : _task.leaveFlightNo ?? ""}',
                                      style: TextStyle(
                                        fontSize: KFont.fontSizeItem_1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: KSize.taskItemColumnTextSplitHeight,
                              ),
                              new Container(
                                decoration: BoxDecoration(border: Border()),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(timeStr,
                                        style: TextThemeStore.textStyleCard_2),
                                    SizedBox(
                                      width: KSize.taskItemRowTextSplitWidth,
                                    ),
                                    _task.handShiftInfo != null &&
                                            _task.handShiftInfo != "" &&
                                            _task.recieveShiftInfo != null &&
                                            !_task.recieveShiftInfo
                                                .contains("'-recieved-")
                                        ? Text(
                                            Translations.of(context)
                                                .text('handover'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: TextThemeStore.textStyleCard_1.fontSize))
                                        : Container(),
//                            SizedBox(
//                              width: KSize.taskItemRowTextSplitWidth,
//                            ),
                                    _task.delFlag != null && _task.delFlag == 1
                                        ? Text(
                                            Translations.of(context)
                                                .text('canceled'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: TextThemeStore.textStyleCard_1.fontSize))
                                        : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: KColor.textColor_99,
                          size: KSize.messageCardRightArrowSize,
                        )
                      ],
                    ),
                  ),
                ))));
  }

  String getAcPlace(TaskModel taskModel) {
    if (taskModel.acPlace != null &&
        taskModel.acPlace != "" &&
        taskModel.acPlacePf != null &&
        taskModel.acPlacePf != "" ) {

      if(taskModel.acPlace != taskModel.acPlacePf) {
        return taskModel.acPlace + '/' + taskModel.acPlacePf; //不一样时才展示
      }else{
        return taskModel.acPlace;
      }

    } else if (taskModel.acPlace != null && taskModel.acPlace != "") {
      return taskModel.acPlace;
    } else if (taskModel.acPlacePf != null && taskModel.acPlacePf != "") {
      return taskModel.acPlacePf;
    } else {
      return " ";
    }
  }
}
