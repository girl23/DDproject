import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/model/material_ameco_model.dart';
import 'package:lop/model/material_ca_model.dart';
import 'package:lop/model/material_list_model.dart';
import 'package:lop/page/base/base_stful_page.dart';
import 'package:lop/page/search/search_widget.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/viewmodel/material_search_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' as refresh;

class MaterialSearchPage extends BaseStfulPage<MaterialSearchViewModel> {

  final controller = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget buildWidget(BuildContext context) {
    // TODO: implement buildWidget
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                  getTranslationsText('task_home_page_material_Search'),
                  style: TextThemeStore.textStyleAppBar
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
          ),
          body: myBody()
      ),
    );
  }

  @override
  MaterialSearchViewModel getViewModel() {
    // TODO: implement getViewModel
    return Provider.of<MaterialSearchViewModel>(context, listen: false);
  }

  @override
  void initData() {
    // TODO: implement initData
  }

  Widget myBody() {
    return new Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setSp(10), right: ScreenUtil().setSp(10)),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: SearchField(
            hintText: getTranslationsText("search_hint_material"),
            controller: controller,
            onSubmitted: (v) {
              searchMaterial();
            },
            onClear: () {
              viewModel.clear();
            },
          ),
        ),
        NotificationListener(
            onNotification: (Notification notification) {
              if (notification is ScrollStartNotification) {
                FocusScope.of(context).unfocus();
              }
              return true;
            },
            child: Selector<MaterialSearchViewModel, MaterialListModel>(
              //materialList(),
              selector: (context, selector) {
                return selector.materialListModel;
              },
              builder: (context, materialListModel, _) {
                return Expanded(
                  child: refresh.EasyRefresh(
                    footer: refresh.ClassicalFooter(
                      enableInfiniteLoad: false,
                      completeDuration: const Duration(milliseconds: 1000),
                      loadText: Translations.of(context).text("pull_to_load"),
                      loadReadyText: Translations.of(context).text("release_to_load"),
                      loadingText: Translations.of(context).text("refresh_loading"),
                      loadedText: Translations.of(context).text("load_complected"),
                      noMoreText: Translations.of(context).text("no_more_text"),
                      infoText: Translations.of(context).text("update_at"),
                    ),
                    header:  refresh.ClassicalHeader(
                      refreshText: Translations.of(context).text("pull_to_refresh"),
                      refreshReadyText: Translations.of(context).text("release_to_refresh"),
                      refreshingText: Translations.of(context).text("refresh_refreshing"),
                      refreshedText: Translations.of(context).text("refresh_complected"),
                      infoText: Translations.of(context).text("update_at"),
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: materialListModel.data.length,
                              itemBuilder: (context, index) =>
                                  _buildGHItem(materialListModel.data[index],
                                      materialListModel.isHana),
                              physics: NeverScrollableScrollPhysics(),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: materialListModel.amecoData.length,
                              itemBuilder: (context, index) =>
                                  _buildAmeItem(
                                      materialListModel.amecoData[index]),
                              physics: NeverScrollableScrollPhysics(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      this.searchMaterial();
                    },
                    onLoad: null,
                    scrollController: _scrollController,
                  ),
                );
              },
            )

        ),
      ],
    );
  }

  Widget separaterBuilder(BuildContext context, int index) {
    return Divider(height: ScreenUtil().setSp(2),
      thickness: ScreenUtil().setSp(2),
      indent: ScreenUtil().setSp(25),);
  }

  Widget _buildGHItem(MaterialCaModel material, String isHana) {
    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(minHeight: ScreenUtil().setHeight(180)),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
              child: Image.asset(
                "assets/images/caaclog.png",
                fit: BoxFit.scaleDown,
              ),
            ),
            title: new Text(
              '${isHana == null ? material.matnr : material.material_no}',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: TextThemeStore.textStyleCard_1.fontSize),
            ),
            subtitle: new Column(children: <Widget>[
              Offstage(
                offstage: !((material.werks == null &&
                    material.lgort == null) ||
                    (material.plant == null && material.location == null)),
                // 基地 库存地都为 null 时才隐藏
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(
                          '${isHana == null ? material.werks : material.plant}',
                          style: TextStyle(
                              fontSize: TextThemeStore.textStyleCard_1
                                  .fontSize)),
                      new Text('${isHana == null ? material.lgort : material
                          .location}',
                          style: TextStyle(
                              fontSize: TextThemeStore.textStyleCard_1
                                  .fontSize)),
                    ]),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                new Text(
                    '${isHana == null ? material.maktx : material
                        .material_desc_cn}',
                    style: TextStyle(
                        fontSize: TextThemeStore.textStyleCard_1.fontSize)),
                new Text(
                    '${isHana == null ? material.charg : material.batch_no}',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: TextThemeStore.textStyleCard_1.fontSize)),
              ]),
//            SizedBox(
//              height: ScreenUtil().setHeight(10.0),
//            ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAmeItem(MaterialAmecoModel material) {
    return Column(
      children: <Widget>[
        Container(
//          margin: EdgeInsets.only(top: ScreenUtil().setHeight(15), bottom: ScreenUtil().setHeight(15)),
          constraints: BoxConstraints(minHeight: ScreenUtil().setHeight(180)),
          child: ListTile(
            leading: Image.asset(
                "assets/images/amecolog.png",
                fit: BoxFit.scaleDown),
            title: new Text('${material.plant}',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: TextThemeStore.textStyleCard_1.fontSize)),
            subtitle: new Column(children: <Widget>[
//            SizedBox(
//              height: ScreenUtil().setHeight(10.0),
//            ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                new Text(
                    '${material.materialNo}${material.materialNo.isNotEmpty
                        ? '  '
                        : ''}',
                    style: TextStyle(
                        fontSize: TextThemeStore.textStyleCard_1.fontSize)),
                new Text('${material.location}',
                    style: TextStyle(
                        fontSize: TextThemeStore.textStyleCard_1.fontSize)),
              ]),
            ]),
          ),
        ),
      ],
    );
  }

  void searchMaterial({showProgressDialog = false}) async {
    String text = controller.text.trim();
    if (text == null || text.isEmpty) {
      //ToastUtil.makeToast(Translations.of(context).text('input_hint_material'));
      return;
    }
    if (showProgressDialog) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: Image.asset('assets/double_ring_loading_io.gif', scale: 2),
            );
          });
    }
    await viewModel.searchMaterial(text);
    if (showProgressDialog) Navigator.of(context).pop();

  }

  @override
  void initListener() {
    // TODO: implement initListener
    _scrollController.addListener(() {
      int offset = _scrollController.position.pixels.toInt();
      if (offset != 0) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void removeListener() {
    // TODO: implement removeListener
    controller.dispose();
    _scrollController.dispose();
  }

}