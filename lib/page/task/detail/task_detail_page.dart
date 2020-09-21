import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/page/task/detail/my_job_card_list.dart';
import 'package:lop/page/task/detail/task_detail_info.dart';
import 'package:lop/page/task/detail/task_operator.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:provider/provider.dart';

import 'my_task_list.dart';
import 'other_job_card_list.dart';

class TaskDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      Provider.of<TaskDetailStateProvide>(context, listen: false)
          .updateTaskDetail(context);
    });
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              centerTitle: true,
              title: Text(
                  Translations.of(context).text('task_detail_page_title'),
                  style: TextThemeStore.textStyleAppBar),
            ),
            preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight)),
        body: EasyRefresh(
          controller:
              Provider.of<TaskDetailStateProvide>(context, listen: false)
                  .refreshController,
          footer: ClassicalFooter(
            enableInfiniteLoad: false,
            completeDuration: const Duration(milliseconds: 1000),
            loadText: Translations.of(context).text("pull_to_load"),
            loadReadyText: Translations.of(context).text("release_to_load"),
            loadingText: Translations.of(context).text("refresh_loading"),
            loadedText: Translations.of(context).text("load_complected"),
            noMoreText: Translations.of(context).text("no_more_text"),
            infoText: Translations.of(context).text("update_at"),
          ),
          header:  ClassicalHeader(
            refreshText: Translations.of(context).text("pull_to_refresh"),
            refreshReadyText: Translations.of(context).text("release_to_refresh"),
            refreshingText: Translations.of(context).text("refresh_refreshing"),
            refreshedText: Translations.of(context).text("refresh_complected"),
            infoText: Translations.of(context).text("update_at"),
          ),
          child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: KColor.categoryColor,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //任务详情
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              left: KSize.taskDetailInfoPaddingLR),
                          child: TaskDetailInfo(),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(30),
                        ),
                        //操作栏
                        TaskOperator(),
                        Container(
                          height: ScreenUtil().setHeight(30),
                        ),
                        //我的任务
                        Consumer<TaskDetailStateProvide>(
                            builder: (context, state, _) {
                          return state.taskDetail.taskData.length == 0
                              ? Container()
                              : MyTask();
                        }),

                        //我的工作条目
                        Container(
                          height: ScreenUtil().setHeight(30),
                        ),
                        Consumer<TaskDetailStateProvide>(
                            builder: (context, state, _) {
                          return state.taskDetail.jcData.length == 0
                              ? Container()
                              : MyJobCardList();
                        }),
                        //其他工作条目
                        Container(
                          height: ScreenUtil().setHeight(30),
                        ),
                        Consumer<TaskDetailStateProvide>(
                          builder: (context, state, _) {
                            return state.taskDetail.jcOtherData.length == 0
                                ? Container()
                                : OtherJobCardList();
                          },
                        ),
                        Container(height: ScreenUtil().setHeight(80)),
                      ]))),
          onRefresh: () async {
            await Provider.of<TaskDetailStateProvide>(context, listen: false)
                .updateTaskDetail(context);
          },
        ));
  }
}
