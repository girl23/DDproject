import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/model/task_detail_model.dart';
import 'package:lop/page/task/detail/my_job_item.dart';
import 'package:lop/page/task/detail/task_detail_category_widget.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:provider/provider.dart';

import '../../../provide/task_detail_state_provide.dart';

class MyJobCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetMyJobCardTitle(context),
        _widgetDivider(),
        _jobCardWidget(),
      ],
    );
  }

  //"我的工作条目"标题行
  Widget _widgetMyJobCardTitle(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: KSize.taskDetailInfoPaddingLR,
            right: KSize.taskDetailInfoPaddingLR,
            top: KSize.taskDetailInfoPaddingTB,
            bottom: KSize.taskDetailInfoPaddingTB),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Translations.of(context).text('task_detail_page_my_job_cart'),
              style: TextThemeStore.textStyleDetailTitle(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobCardWidget() {
    return Selector<TaskDetailStateProvide, TaskDetailModel>(
      selector: (context, selector) {
        return selector.taskDetail;
      },
      builder: (context, taskDetail, _) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: taskDetail.jcData.length,
          itemBuilder: (context, index) => MyJobItem(
              taskDetail.jcData[index], taskDetail.data.mdLayoverTaskId),
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
                color: KColor.dividerColor, height: KSize.dividerSize);
          },
          physics: NeverScrollableScrollPhysics(),
        );
      },
    );
  }

  Widget _widgetDivider() {
    return Divider(color: KColor.dividerColor, height: KSize.dividerSize);
  }
}
