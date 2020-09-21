import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/model/task_detail_model.dart';
import 'package:lop/page/task/detail/other_job_item.dart';
import 'package:lop/page/task/detail/task_detail_category_widget.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:provider/provider.dart';

import '../../../provide/task_detail_state_provide.dart';

class OtherJobCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _widgetOtherJobCardTitle(context),
        _widgetDivider(),
        _otherCardWidget(),
      ],
    );
  }

  //"我的工作条目"标题行
  Widget _widgetOtherJobCardTitle(BuildContext context) {
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
              Translations.of(context).text('task_detail_page_other_job_cart'),
              style: TextThemeStore.textStyleDetailTitle(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherCardWidget() {
    return Selector<TaskDetailStateProvide, TaskDetailModel>(
      selector: (context, selector) {
        return selector.taskDetail;
      },
      builder: (context, taskDetail, _) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: taskDetail.jcOtherData.length,
          itemBuilder: (context, index) => OtherJobItem(
              taskDetail.jcOtherData[index],
              taskDetail.personalState,
              taskDetail.data.mdLayoverTaskId),
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
