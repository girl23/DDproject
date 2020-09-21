
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/model/task_detail_model.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/date_util.dart';
import 'package:provider/provider.dart';

/// 任务信息 ——> 航班信息
class TaskDetailInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskDetailInfoState();
}

class _TaskDetailInfoState extends State<TaskDetailInfo> {

  @override
  Widget build(BuildContext context) {
    return Selector<TaskDetailStateProvide, TaskDetailModel>(
      selector: (context, selector) =>  selector.taskDetail,
      builder: (context, taskDetail, _) {
        return Column(
          children: _noDividerWidgetList(context),
        );
      },
    );

  }


  List<Widget> _noDividerWidgetList(BuildContext context) {
    TaskDetailModel taskDetailModel = Provider.of<TaskDetailStateProvide>(context,listen: false).taskDetail;
    List<Widget> listWidget = [];
    //航班号
    listWidget.add(_acReg());
    //机型
    listWidget.add(_otherRow(
        Translations.of(context).text('task_detail_page_actype'),
        null == taskDetailModel.data.acType ? ' ' : taskDetailModel.data.acType));
    //任务类型
    String taskType = taskDetailModel.data.taskType;
    listWidget.add(_otherRow(
        Translations.of(context).text('task_detail_page_tasktype'),
        null == taskType ? ' ' : taskType));
    //停机位
    listWidget.add(_otherRow(
        Translations.of(context).text('task_detail_page_ac_place'),
        getAcPlace(taskDetailModel)));
    //进港航班号
    listWidget.add(_otherRow(
        Translations.of(context)
            .text('task_detail_page_arrive_flight_no'),
        null == taskDetailModel.data.arriveFlightNo ? ' ' : taskDetailModel.data.arriveFlightNo));
    //出港航班号
    listWidget.add(_otherRow(
        Translations.of(context).text('task_detail_page_leave_flight_no'),
        null == taskDetailModel.data.leaveFlightNo ? ' ' : taskDetailModel.data.leaveFlightNo));

    //动态数据部分
    bool arriveW = true;//进港时间
    bool leaveW = true;//出港时间
    if(taskType == 'AF'){
      leaveW = false;
    }else if(taskType == 'PF'){
      arriveW = false;
    }
    if(arriveW){//进港时间
      listWidget.add(_otherRow(
          Translations.of(context)
              .text('task_detail_page_arrive_flight_time'),
          getAfTime(taskDetailModel)));//进港时间
    }
    if(leaveW){//出港时间
      listWidget.add(_otherRow(
          Translations.of(context)
              .text('task_detail_page_leave_flight_time'),
          getPfTime(taskDetailModel)));//出港时间
    }


    //交班信息
    String shiftInfo = taskDetailModel.shiftInfo;
    if(shiftInfo != null && shiftInfo.trim().length != 0){
      String content = shiftInfo == null?' ':shiftInfo;
      if(content.endsWith('\r\n')){
        content = content.substring(0,shiftInfo.length-2);
      }
      listWidget.add(_otherRow(
          Translations.of(context).text('task_detail_page_shift_info'), content));
    }
    //相关人员
    String partners = taskDetailModel.partners;
    if(partners != null && partners.trim().length != 0){
      print("partners : ${partners}");
      listWidget.add(_otherRow(
          Translations.of(context).text('task_detail_page_partners'),
          null == partners ? ' ' : partners));
    }

    //追加分割线
    List<Widget> newListWiget = [];
    int length = listWidget.length;
    for(int i = 0; i < length; i++){
      newListWiget.add(listWidget[i]);
      if(i != (length - 1)){
        newListWiget.add(divider());
      }
    }
    return newListWiget;
  }



  String getAcPlace(TaskDetailModel taskDetail) {
    if (null == taskDetail.data) {
      return ' ';
    }
    if (taskDetail.data.acPlace != null &&
        taskDetail.data.acPlace != "" &&
        taskDetail.data.acPlacePf != null &&
        taskDetail.data.acPlacePf != "") {
      if (taskDetail.data.acPlace != taskDetail.data.acPlacePf) {
        return taskDetail.data.acPlace + '/' + taskDetail.data.acPlacePf;
      } else {
        return taskDetail.data.acPlace;
      }
    } else if (taskDetail.data.acPlace != null &&
        taskDetail.data.acPlace != "") {
      return taskDetail.data.acPlace;
    } else if (taskDetail.data.acPlacePf != null &&
        taskDetail.data.acPlacePf != "") {
      return taskDetail.data.acPlacePf;
    } else {
      return ' ';
    }
  }

  String getAfTime(TaskDetailModel taskDetail) {
    if (null == taskDetail.data) {
      return ' ';
    }
    if (taskDetail.data.arriveTimeReal != '') {
      return DateUtil.formateMDHM_string(taskDetail.data.arriveTimeReal);
    } else if (taskDetail.data.arriveTimePre != '') {
      return DateUtil.formateMDHM_string(taskDetail.data.arriveTimePre);
    } else {
      return DateUtil.formateMDHM_string(taskDetail.data.arriveTimePlan);
    }
  }

  String getPfTime(TaskDetailModel taskDetail) {
    if (null == taskDetail.data) {
      return ' ';
    }
    if (taskDetail.data.leaveTimeReal != '') {
      return DateUtil.formateMDHM_string(taskDetail.data.leaveTimeReal);
    } else if (taskDetail.data.leaveTimePre != '') {
      return DateUtil.formateMDHM_string(taskDetail.data.leaveTimePre);
    } else {
      return DateUtil.formateMDHM_string(taskDetail.data.leaveTimePlan);
    }
  }

  Widget _acReg() {
    return Container(
      child: Padding(
        padding: KSize.taskDetailContentPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Translations.of(context).text('task_detail_page_acreg'),
              style: TextThemeStore.textStyleDetailItemTitle,
            ),
            Consumer<TaskDetailStateProvide>(
              builder: (context, state, _) {
                return Text(
                  null != state.taskDetail.data.acReg
                      ? !state.taskDetail.data.acReg.contains("B-")
                          ? state.taskDetail.data.acReg.replaceAll("B", "B-")
                          : state.taskDetail.data.acReg
                      : 'N/A',
                  style: TextThemeStore.textStyleDetailItemTitle,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(color: KColor.dividerColor, height: KSize.dividerSize);
  }

  Widget _otherRow(String key, String value) {
    return Container(
//        height: KSize.taskDetailInfoItemHeight,
        child: Padding(
            padding: KSize.taskDetailContentPadding,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    key,
                    style: TextThemeStore.textStyleDetailItemTitle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    value ?? ' ',
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: TextThemeStore.textStyleDetailItemContent,
                  ),
                )
              ],
            )));
  }
}
