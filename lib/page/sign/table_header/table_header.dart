import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../config/enum_config.dart';
import '../../../component/job_card/jc_widget_para.dart';
import '../../../model/jobcard/jc_header_model.dart';
import '../../../model/jobcard/jc_model.dart';
import '../../../model/jc_sign_model.dart';
import '../../../style/color.dart';
import '../../../style/font.dart';
import '../../../style/size.dart';

enum noteCategory {
  note,
  caution,
  explain,
  taiWan,
}

///
/// 工卡顶部的header内容
///
// ignore: must_be_immutable
class TableHeaderWidget extends StatefulWidget {
  HeaderModel headerModel;
  JobCardLanguage cardLanguage;

  TableHeaderWidget(
      {Key key, HeaderModel headerModel, JobCardLanguage cardLanguage})
      : assert(headerModel != null),
        super(key: key) {
    this.headerModel = headerModel;
    this.cardLanguage = cardLanguage;
  }

  @override
  _TableHeaderWidgetState createState() => _TableHeaderWidgetState();
}

class _TableHeaderWidgetState extends State<TableHeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return builderListView();
  }

//构建表头视图
  Widget builderListView() {
    return Consumer<JcSignModel>(builder: (context, model, _) {
      return Container(
          padding: EdgeInsets.only(
              left: KSize.commonPadding3, right: KSize.commonPadding3),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      width: KSize.dividerSize, color: KColor.textColor_b2)),
              boxShadow: [
                BoxShadow(
                    color: KColor.dividerColor,
                    offset: Offset(0, 1),
                    blurRadius: 2.0)
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _headerPartWidget(model),
                _notePartWidget(model),
              ]));
    });
  }

  ///
  /// 航班等固定信息
  ///
  Widget _headerPartWidget(provider) {
    return Container(
      padding: EdgeInsets.only(
          top: KSize.commonPadding2, bottom: KSize.commonPadding2),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: KSize.dividerSize, color: KColor.dividerColor)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: _headerTextWidgetFlight(provider),
                ),
                Padding(
                  padding: EdgeInsets.only(top: KSize.commonPadding2),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: _headerTextWidgetVersion(provider),
                )
              ]))),
          Image.network(
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
//                  color: Colors.yellow,
            width: ScreenUtil().setWidth(300),
            height: ScreenUtil().setWidth(200),
//                  fit: BoxFit.contain,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  //机号，航班号
  List<Widget> _headerTextWidgetFlight(provider) {
    return [
      Expanded(
          child: _headTextWidget(
              _getHeadName(1), widget.headerModel.acReg ?? '', provider)),
      SizedBox(
        width: ScreenUtil().setWidth(60),
      ),
      Expanded(
        child: _headTextWidget(
            _getHeadName(2), widget.headerModel.flightNo ?? '', provider),
      )
    ];
  }

//出版日期，版次
  List<Widget> _headerTextWidgetVersion(provider) {
    return [
      Expanded(
          child: _headTextWidget(
              _getHeadName(3), widget.headerModel.issueDate ?? '', provider)),
      SizedBox(
        width: ScreenUtil().setWidth(60),
      ),
      Expanded(
          child: _headTextWidget(
              _getHeadName(4), widget.headerModel.version ?? '', provider))
    ];
  }

  Widget _headTextWidget(String name, String value, provider) {
    TextStyle textStyle = TextStyle(
        color: KColor.textColor_66,
        fontSize: KFont.fontSizeTableHeader * provider.fontScale,
        height: 1.1);
    return Container(
      child: Text('$name:$value', style: textStyle),
    );
  }

  ///
  /// 获取固定的工卡头属性名称
  ///
  /// 1-机号，2-航班号，3-出版日期，4-版次
  ///
  String _getHeadName(int type) {
    String name;
    switch (type) {
      case 1:
        name = (widget.cardLanguage == JobCardLanguage.cn)
            ? '机号'
            : (widget.cardLanguage == JobCardLanguage.en)
                ? 'A/C REG'
                : '机号\nA/C REG';
        break;
      case 2:
        name = (widget.cardLanguage == JobCardLanguage.cn)
            ? '航班号'
            : (widget.cardLanguage == JobCardLanguage.en)
                ? 'FLIGHT NO'
                : '航班号\nFLIGHT NO';
        break;
      case 3:
        name = (widget.cardLanguage == JobCardLanguage.cn)
            ? '出版日期'
            : (widget.cardLanguage == JobCardLanguage.en)
                ? 'ISS DATE'
                : '出版日期\nISS DATE';
        break;
      case 4:
        name = (widget.cardLanguage == JobCardLanguage.cn)
            ? '版次'
            : (widget.cardLanguage == JobCardLanguage.en) ? 'REV' : '版次\nREV';
        break;
    }
    return name;
  }

  ///
  ///注释等其他信息
  ///
  Widget _notePartWidget(provider) {
    List<int> markDataList = [];
    for (int i = 0; i < widget.headerModel.children.length; i++) {
      JcModel jcModel = widget.headerModel.children[i];
      if (jcModel is JcLanguageModel) {
        JcLanguageModel languageModel = jcModel;
        if (languageModel.cnLanguageModel == null &&
            languageModel.enLanguageModel == null &&
            languageModel.mixLanguageModel == null) {
          continue;
        }
      }
      markDataList.add(i);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: markDataList.map((index) {
        JcModel jcModel = widget.headerModel.children[index];
        String tag = jcModel.tag;
        bool isLast = false;
        if (index == markDataList.length - 1) {
          isLast = true;
        }
        if (tag == 'taiwan') {
          TaiWanModel taiWan = jcModel;
          print('${taiWan.tag}');
          return Container(
              padding: EdgeInsets.only(
                  top: KSize.commonPadding2, bottom: KSize.commonPadding2),
              decoration: isLast
                  ? null
                  : BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: KSize.dividerSize,
                              color: KColor.dividerColor)),
                    ),
              child: _paragraphWidget(
                taiWan.children,
                TextStyle(
                    fontSize: KFont.fontSizeCommon_6 * provider.fontScale,
                    color: KColor.color_f34d32),
              ));
        } else if (tag == "explain") {
          ExplainModel explainModel = jcModel;
          return _explainWidget(explainModel, provider);
        } else {
          JcLanguageModel languageModel = jcModel;
          return _aboutNoteWidget(languageModel, isLast, provider);
        }
      }).toList(),
    );
  }

  ///添加explain组件
  Widget _explainWidget(ExplainModel explainModel, provider) {
    return Column(
      children: explainModel.children.map((model) {
        return _aboutNoteWidget(model, false, provider);
      }).toList(),
    );
  }

  ///
  ///添加Note、explain控件
  ///
  Widget _aboutNoteWidget(JcLanguageModel model, bool isLast, provider) {
    TextStyle textStyle = TextStyle(
        fontSize: KFont.fontSizeCommon_6 * provider.fontScale,
        color: KColor.textColor_66);

    List<Widget> children = List();
    if(widget.cardLanguage == JobCardLanguage.cn && model.cnLanguageModel != null){
      //中文
      children.add(_customWidget(model.cnLanguageModel, textStyle));
    }else if(widget.cardLanguage == JobCardLanguage.en && model.enLanguageModel != null){
      //英文
      children.add(_customWidget(model.enLanguageModel, textStyle));
    }else if(JobCardLanguage.mix == JobCardLanguage.mix){
      if(model.cnLanguageModel != null){
        children.add(_customWidget(model.cnLanguageModel, textStyle));
      }
      if(model.enLanguageModel != null){
        children.add(_customWidget(model.enLanguageModel, textStyle));
      }
    }
    if(model.mixLanguageModel!= null){
      children.add(_customWidget(model.mixLanguageModel, textStyle));
    }
    return children.isNotEmpty
        ? Container(
            padding: EdgeInsets.only(
                top: KSize.commonPadding2, bottom: KSize.commonPadding2),
            decoration: isLast
                ? null
                : BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: KSize.dividerSize,
                            color: KColor.dividerColor)),
                  ),
            child: Column(
              children: children,
            ))
        : Container();
  }

  Widget _customWidget(JcListModel model, TextStyle style) {
    if (model == null) {
      return Container(
        color: Colors.white,
      );
    } else {
      List tempList = model.children; //paragraph
      return _paragraphWidget(tempList, style);
    }
  }

  Widget _paragraphWidget(List data, TextStyle style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: data.map((noteModel) {
        //文本内容居左；

        return Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: JcWidgetParagraph(
              data: noteModel,
              textStyle: style,
            ));
      }).toList(),
    );
  }
}
