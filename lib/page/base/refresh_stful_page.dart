import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lop/page/base/base_stful_page.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';

abstract class RefreshStfulPage<T extends BaseViewModel> extends BaseStfulPage<T>{

  EasyRefreshController refreshController = EasyRefreshController();
  ScrollController _scrollController = new ScrollController();
  Function onRefresh;
  Function onLoad;
  Function onGestureDetectorTap;
  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return  GestureDetector(
      onTap: onGestureDetectorTap,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
          child: AppBar(
            actions: appBaraction(context),
            title: title(context),
            leading: leading(context),
            centerTitle: true,
            bottom: bottom(context),
          ),
        ),
        body:  EasyRefresh(
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
          child: buildChild(context),
          onRefresh: onRefresh,
          onLoad: onLoad,
          scrollController: _scrollController,
          controller: refreshController,
        ),
      ),
    );

  }

  @override
  void initListener() {
    _scrollController.addListener(() {
      int offset = _scrollController.position.pixels.toInt();
      if (offset != 0 && context != null) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void removeListener() {
    _scrollController.dispose();
    refreshController.dispose();
  }

  Widget buildChild(BuildContext context);
  List<Widget> appBaraction(BuildContext context);
  Widget title(BuildContext context);
  Widget leading(BuildContext context);
  PreferredSizeWidget bottom(BuildContext context);

}