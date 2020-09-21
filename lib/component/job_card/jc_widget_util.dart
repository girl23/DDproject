import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lop/component/easy_rich_text/easy_rich_text.dart';
import 'package:lop/component/easy_rich_text/easy_rich_text_pattern.dart';
import 'package:lop/component/imagelib/extended_network_image_provider.dart';
import 'package:lop/model/jobcard/jc_image_model.dart';
import '../extended_text/export_extended_text.dart';
import 'package:lop/component/job_card/custom_radio.dart';
import 'package:lop/component/xml_table/xml_converted_table.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/model/jobcard/jc_checkbox_model.dart';
import 'package:lop/model/jobcard/jc_radio_model.dart';
import 'package:lop/model/jobcard/jc_table_model.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ITextField.dart';
import 'custom_check.dart';
import 'jc_eff_area.dart';
import 'jc_hide_area.dart';
import 'jc_widget_para.dart';
import 'jc_widget_text.dart';
import '../../model/jobcard/jc_para_model.dart';
import '../../model/jobcard/jc_model.dart';

class JcWidgetUtil {
  static Widget createWidget(JcModel jcModel, {TextStyle textStyle}) {
    String tag = jcModel.tag;
    switch (tag) {
      case 'para':
        ParagraphModel paragraphModel = jcModel;
        return JcWidgetParagraph(data: paragraphModel, textStyle: textStyle);
        break;
      case 'text':
        return JcWidgetText(data: jcModel, style: textStyle);
        break;
    }
    return null;
  }

  static InlineSpan createParagraph(
      itemPath, JcSignModel provider, jcModel, contentWidth, inputWidth,
      {TextStyle textStyle}) {
    if(jcModel.children == null){
      return WidgetSpan(child: Container());
    }
    List<InlineSpan> widgets = List(); //所有列组件
    double lineHeight = KSize.jcSignItemTextHeight;
    TextAlign _textAlign = TextAlign.start;
    if ((jcModel is ParagraphModel) && jcModel.hAlignment != null) {
      if (jcModel.hAlignment == HorizontalAlignment.left) {
        _textAlign = TextAlign.start;
      } else if (jcModel.hAlignment == HorizontalAlignment.center) {
        _textAlign = TextAlign.center;
      } else if (jcModel.hAlignment == HorizontalAlignment.right) {
        _textAlign = TextAlign.right;
      }
    }
    for (int i = 0; i < jcModel.children.length; i++) {
      var itemModel = jcModel.children[i];
      String tag = itemModel.tag;
      switch (tag) {
        case "text":
        case "input":
        case "image":
          List<InlineSpan> children = List<InlineSpan>();
          if (tag == "text") {
            //字体颜色
            Color color =
                itemModel.color == null ? textStyle?.color : itemModel.color;
            //粗体
            FontWeight weight =
                itemModel.isBold ? FontWeight.bold : textStyle?.fontWeight;
            //斜体
            FontStyle style =
                itemModel.isItalics ? FontStyle.italic : textStyle?.fontStyle;
            //下划线
            TextDecoration decoration = itemModel.hasUnderline
                ? TextDecoration.underline
                : textStyle?.decoration;
            //字体库
            String fontFamily = (itemModel.fontName != null)
                ? itemModel.fontName
                : textStyle?.fontFamily;
            if(fontFamily != null){
              fontFamily = fontFamily.toLowerCase();
            }
            TextStyle _textStyle = TextStyle(
                color: color,
                fontWeight: weight,
                fontStyle: style,
                fontSize: provider.fontScale * KFont.fontSizeItem,
                decoration: decoration,
                decorationColor: color,
                decorationStyle: TextDecorationStyle.solid,
                fontFamily: fontFamily,
                background: Paint()..color = itemModel.bgColor ?? Colors.white,
                height: lineHeight);
            if (itemModel.isSuper || itemModel.isSuber) {
              children.add(WidgetSpan(
                  child: EasyRichText(
                itemModel.text,
                defaultStyle: _textStyle,
                patternList: [
                  EasyRichTextPattern(
                      targetString: itemModel.text,
                      superScript: itemModel.isSuper,
                      subScript: itemModel.isSuber,
                      matchWordBoundaries: false),
                ],
              )));
            } else if (itemModel.href != null && itemModel.href.isNotEmpty) {
              children.add(TextSpan(
                  text: itemModel.text,
                  style: TextStyle(color: Colors.orangeAccent,height: lineHeight),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      print("TapGestureRecognizer onTap");
                      await launch(itemModel.href);
                    }));
            } else {
              children.add(TextSpan(
                text: itemModel.text,
                style: _textStyle,
              ));
            }
          } else if (tag == "input") {
            provider.dynamicDataModel.setInputValue(
                itemPath: itemPath,
                path: itemModel.path,
                value: provider.dynamicDataModel
                    .inputValue(itemPath: itemPath, path: itemModel.path));
            children.add(WidgetSpan(
                child: Container(
                    width: inputWidth,
                    height: 20,
                    child: ValueListenableBuilder(
                        valueListenable: provider.inputChangeListener,
                        builder:
                            (BuildContext context, bool value, Widget child) {
                          return ITextField(
                            key: ValueKey<String>("${itemModel.path}"),
//                      maxLength: itemModel.length??5,
                            keyboardType: ITextInputType.number,
                            inputText: provider.dynamicDataModel.inputValue(
                                itemPath: itemPath, path: itemModel.path),
                            focusNode: FocusNode(),
                            inputBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                            fieldCallBack: (value, key) {
                              ///这里做校验
                              print(
                                  "ITextField value:${value} key:${(key as ValueKey).value}");
                              if (value != null &&
                                      value.isNotEmpty &&
                                      0 > double.parse(value) ||
                                  double.parse(value) > 108) {
                                ToastUtil.makeToast("不在标准范围内",
                                    toastType: ToastType.WARN,
                                    gravity: ToastGravity.CENTER);
                                provider.dynamicDataModel.setInputValue(
                                    itemPath: itemPath,
                                    path: (key as ValueKey).value,
                                    value: "");
                                provider.notifyChangeInput();
                              } else {
                                provider.dynamicDataModel.setInputValue(
                                    itemPath: itemPath,
                                    path: (key as ValueKey).value,
                                    value: value);
                              }
                            },
                            textStyle: TextStyle(
                                color: Colors.green,
                                fontSize:
                                    provider.fontScale * KFont.fontSizeItem,
                                height: lineHeight),
                          );
                        }))));
          } else if (tag == "image") {
            children.add(ImageSpan(ExtendedNetworkImageProvider(
                "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2346951131,4212949701&fm=26&gp=0.jpg",
                cache: true),imageWidth: provider.contentImageWidth * itemModel.widthpercent,imageHeight:provider.contentImageWidth * itemModel.heightpercent ));
          }
          widgets.add(TextSpan(children: children));
          break;
        case "hide":
          //可隐藏块
          widgets.add(WidgetSpan(
              child: JcHideArea(
                  widgets: createParagraph(
                      itemPath, provider, itemModel, contentWidth, inputWidth,
                      textStyle: textStyle))));
          break;
        case "para":
          widgets.add(createParagraph(
              itemPath, provider, itemModel, contentWidth, inputWidth,
              textStyle: textStyle));
          break;
        default:
          switch (tag) {
            case "radio":
              widgets.add(WidgetSpan(
                  child: ValueListenableBuilder(
                      valueListenable: provider.radioChangeListener,
                      builder:
                          (BuildContext context, bool value, Widget child) {
                        return CustomRadio(
                          dbId: itemModel.dbId,
                          group: itemModel.group,
                          radioWidth: KSize.jcSignItemCheckWidth*provider.fontScale,
                          radioValue: provider.dynamicDataModel.radioValue(
                              itemPath: itemPath, group: itemModel.group),
                          radioChange: (group, dbId) {
                            if (provider.dynamicDataModel.radioValue(
                                    itemPath: itemPath, group: group) !=
                                dbId) {
                              provider.dynamicDataModel.setRadioValue(
                                  itemPath: itemPath,
                                  group: group,
                                  value: dbId);
                              provider.notifyChangeRadio();
                            }else{
                              provider.dynamicDataModel.setRadioValue(
                                  itemPath: itemPath, group: group, value: "");
                              provider.notifyChangeRadio();
                            }
                          },
                        );
                      })));
              break;
            case "checkbox":
              widgets.add(WidgetSpan(
                  child: ValueListenableBuilder(
                valueListenable: provider.checkChangeListener,
                builder: (BuildContext context, bool value, Widget child) {
                  return CustomCheck(
                    dbId: itemModel.dbId,
                    checkValue: provider.dynamicDataModel
                        .checkValue(itemPath: itemPath, dbId: itemModel.dbId),
                    checkedChange: (dbId, value) {
                      provider.dynamicDataModel.setCheckValue(
                          itemPath: itemPath, dbId: dbId, value: value);
                    },
                    checkWidth: KSize.jcSignItemCheckWidth*provider.fontScale,
                  );
                },
              )));
              break;
            case "table":
              widgets.add(WidgetSpan(
                  child: XmlConvertedTable(
                itemModel,
                tableWidth: (itemModel as TableModel).width.toDouble(),
                viewPortWidth: contentWidth,
              )));
              widgets.add(WidgetSpan(
                  child: SizedBox(
                height: ScreenUtil().setHeight(20),
                width: contentWidth,
              )));
              break;
          }
          break;
      }
    }
    return WidgetSpan(
        child: Container(
      width: contentWidth,
      child: RichText(
        text: TextSpan(children: widgets),textAlign: _textAlign,
      ),
    ));
  }

  static InlineSpan createItem(
      itemPath, JcSignModel provider, contentWidth, JcModel jcModel, inputWidth,
      {TextStyle textStyle}) {
    String tag = jcModel.tag;
    switch (tag) {
      case "para":
        ParagraphModel paragraphModel = jcModel as ParagraphModel;
        return createParagraph(
            itemPath, provider, paragraphModel, contentWidth, inputWidth,
            textStyle: textStyle);
        break;
      case "eff":
        EffModel effModel = jcModel as EffModel;
        return WidgetSpan(
            child: JcEffArea(
                isSwitch: !effModel.available,
                widgets: createParagraph(
                    itemPath, provider, effModel, contentWidth, inputWidth,
                    textStyle: textStyle)));
        break;
      case "hide":
        HideModel hideModel = jcModel as HideModel;
        return WidgetSpan(
            child: JcHideArea(
                widgets: createParagraph(
                    itemPath, provider, hideModel, contentWidth, inputWidth,
                    textStyle: textStyle)));
        break;
      case "image":
        ImageModel imageModel = jcModel as ImageModel;
         return WidgetSpan(child: Container(width: contentWidth,alignment:imageModel.alignment,child: ExtendedText.rich(ImageSpan(ExtendedNetworkImageProvider(
             "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2346951131,4212949701&fm=26&gp=0.jpg",
             cache: true),imageWidth: provider.contentImageWidth * imageModel.widthpercent,imageHeight:provider.contentImageWidth * imageModel.heightpercent )),));

        break;
      case "checkbox":
        CheckboxModel checkboxModel = jcModel as CheckboxModel;
        return WidgetSpan(
            child: ValueListenableBuilder(
          valueListenable: provider.checkChangeListener,
          builder: (BuildContext context, bool value, Widget child) {
            return CustomCheck(
              dbId: checkboxModel.dbId,
              checkValue: provider.dynamicDataModel
                  .checkValue(itemPath: itemPath, dbId: checkboxModel.dbId),
              checkedChange: (dbId, value) {
                provider.dynamicDataModel.setCheckValue(
                    itemPath: itemPath, dbId: dbId, value: value);
              },
              checkWidth: KSize.jcSignItemCheckWidth*provider.fontScale,
            );
          },
        ));
        break;
      case "table":
        TableModel tableModel = jcModel as TableModel;
        double width = (tableModel.width != null)
            ? tableModel.width.toDouble()
            : double.parse(tableModel.widthPercent) * contentWidth;
        return WidgetSpan(
            child: XmlConvertedTable(tableModel,
                tableWidth: width, viewPortWidth: contentWidth));
        break;
      case "radio":
        RadioModel radioModel = jcModel as RadioModel;
        return WidgetSpan(
            child: ValueListenableBuilder(
                valueListenable: provider.radioChangeListener,
                builder: (BuildContext context, bool value, Widget child) {
                  return CustomRadio(
                    dbId: radioModel.dbId,
                    group: radioModel.group,
                    radioWidth: KSize.jcSignItemCheckWidth*provider.fontScale,
                    radioValue: provider.dynamicDataModel.radioValue(
                        itemPath: itemPath, group: radioModel.group),
                    radioChange: (group, dbId) {
                      if (provider.dynamicDataModel
                              .radioValue(itemPath: itemPath, group: group) !=
                          dbId) {
                        provider.dynamicDataModel.setRadioValue(
                            itemPath: itemPath, group: group, value: dbId);
                        provider.notifyChangeRadio();
                      }else{
                        provider.dynamicDataModel.setRadioValue(
                            itemPath: itemPath, group: group, value: "");
                        provider.notifyChangeRadio();
                      }
                    },
                  );
                }));
        break;
    }
    return WidgetSpan(child: Container());
  }
}
