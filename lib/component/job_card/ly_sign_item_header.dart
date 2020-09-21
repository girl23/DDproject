import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:lop/model/jc_sign_model.dart';
import 'package:lop/router/application.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/xy_dialog_util.dart';

import '../dashed_decoration.dart';
import '../sheet_widget.dart';
import '../sheet_widget_item.dart';
import '../xy_dialog_widget.dart';
import 'package:provider/provider.dart';

import 'ly_image_gallery.dart';

class LySignItemHeader extends StatefulWidget {
  final itemData;
  final double width;

  const LySignItemHeader({Key key, this.itemData, this.width})
      : super(key: key);

  @override
  _LySignItemHeaderState createState() => _LySignItemHeaderState();
}

class _LySignItemHeaderState extends State<LySignItemHeader> {
  bool _isNormalCheck = false;
  bool _isNaCheck = false;
  bool _isShowImages = false;

  @override
  void initState() {
    super.initState();
    _isNaCheck = Provider
        .of<JcSignModel>(context, listen: false)
        .naSignChoose
        .contains(widget.itemData.path);
    _isNormalCheck = Provider
        .of<JcSignModel>(context, listen: false)
        .normalSignChoose
        .contains(widget.itemData.path);
    if (!_isNaCheck && !_isNormalCheck && !widget.itemData.available) {
      _isNaCheck = true;
      Future.delayed(Duration(milliseconds: 300), () {
        Provider.of<JcSignModel>(context, listen: false)
            .naSignChooseChange(widget.itemData.path, _isNaCheck);
      });
    }
  }

  @override
  void didUpdateWidget(LySignItemHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isNaCheck = Provider
        .of<JcSignModel>(context, listen: false)
        .naSignChoose
        .contains(widget.itemData.path);
    _isNormalCheck = Provider
        .of<JcSignModel>(context, listen: false)
        .normalSignChoose
        .contains(widget.itemData.path);
    if (!_isNaCheck && !_isNormalCheck && !widget.itemData.available) {
      _isNaCheck = true;
      Future.delayed(Duration(milliseconds: 300), () {
        Provider.of<JcSignModel>(context, listen: false)
            .naSignChooseChange(widget.itemData.path, _isNaCheck);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width == 0
            ? MediaQuery
            .of(context)
            .size
            .width
            : widget.width,
//        color: Colors.black26,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//          padding: EdgeInsets.only(
//              top: KSize.commonPadding1, bottom: KSize.commonPadding1),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[

                      ///图片
                      Offstage(
                          offstage: !widget.itemData.photo,
                          child: Stack(children: <Widget>[
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  _isShowImages = !_isShowImages;
                                });
                              },
                              iconSize: KSize.jcSignItemIconSize,
                              icon: Icon(Icons.image),
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                            Positioned(
                                right: KSize.jcSignItemSubscriptPadding,
                                top: KSize.jcSignItemSubscriptPadding,
                                child: Offstage(
                                    offstage: false,
                                    child: Container(
                                        width: KSize.jcSignItemSubscriptSize,
                                        height: KSize.jcSignItemSubscriptSize,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(KSize
                                                    .jcSignItemSubscriptSize *
                                                    0.5))),
                                        child: Text(
                                          "2",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              KFont.fontSizeItemSubscript),
                                        ))))
                          ])),
                      Offstage(
                        offstage: !widget.itemData.photo,
                        child: IconButton(
                          onPressed: () {
                            if (checkSign(context)) {
                              SheetWidget sw = SheetWidget(
                                context,
                                18,
                                itemHeight: KSize.jcSignCountHeight,
                                children: <SheetWidgetItem>[
                                  //拍照
                                  SheetWidgetItem("拍照", () async {
                                    await ImagePickers.openCamera()
                                        .then((Media media) {
                                      print("openCamera media:${media.path}");

                                      /// media 包含照片路径信息 Include photo path information
                                    });
                                  }, textColor: Colors.black87),
                                  //相册
                                  SheetWidgetItem("相册", () async {
                                    List<Media> _listImagePaths =
                                    await ImagePickers.pickerPaths(
                                        galleryMode: GalleryMode.image,
                                        selectCount: 9,
                                        showCamera: false,
                                        compressSize: 500,
                                        uiConfig: UIConfig(
                                            uiThemeColor: Theme
                                                .of(context)
                                                .primaryColor));
                                    _listImagePaths.forEach((media) {
                                      print("choose pickerPaths:${media.path}");
                                    });
                                  }, textColor: Colors.black87),
                                ],
                              );
                              sw.showSheet();
                            }
                          },
                          iconSize: KSize.jcSignItemIconSize,
                          icon: Icon(Icons.camera_alt),
                          color: Theme
                              .of(context)
                              .primaryColor,
                        ),
                      ),
                      Offstage(
                        offstage: !widget.itemData.appendix,
                        child: IconButton(
                          onPressed: () {
                            singleButtonListDialog(context,
                                height: 200.0, items: _buildPdfs(context),
                                onClickItemListener: (String key) {
                                  Application.router.navigateTo(context,
                                      "/jobCard/modulesign/pdfscreen/${Uri
                                          .encodeComponent(key)}",
                                      transition: TransitionType.fadeIn);
                                }, buttonText: "取消");
                          },
                          iconSize: KSize.jcSignItemIconSize,
                          icon: Icon(Icons.attach_file),
                          color: Theme
                              .of(context)
                              .primaryColor,
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable:
                    Provider
                        .of<JcSignModel>(context, listen: false)
                        .signChangeListener,
                    builder: (BuildContext context, bool value, Widget child) {
                      return Row(
                        children: <Widget>[
                          Offstage(
                            offstage: !Provider
                                .of<JcSignModel>(context,
                                listen: false)
                                .signPics
                                .containsKey(widget.itemData.path) ||
                                widget.itemData.path != "000001000001000001",
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.orangeAccent),
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Center(
                                  child: Text("N/A"),
                                ),
                              ),
                            ),
                          ),
                          Offstage(
                            offstage:
                            Provider
                                .of<JcSignModel>(context, listen: false)
                                .signPics
                                .containsKey(widget.itemData.path),
                            child: Row(
                              children: <Widget>[
                                _buildButton(_isNaCheck ? "取消N/A" : "N/A", () {
                                  if (checkPhoto(context)) {
                                    setState(() {
                                      _isNormalCheck = false;
                                      _isNaCheck = !_isNaCheck;
                                      Provider.of<JcSignModel>(context,
                                          listen: false)
                                          .naSignChooseChange(
                                          widget.itemData.path, _isNaCheck);
                                    });
                                  }
                                },
                                    _isNaCheck
                                        ? KColor.primaryColor_2
                                        : KColor.primaryColor_1),
                                SizedBox(
                                  width: 10,
                                ),
                                _buildButton(_isNormalCheck ? "取消选择" : "确认",
                                        () {
                                      if (checkPhoto(context)) {
                                        if (widget.itemData.available ||
                                            _isNormalCheck) {
                                          setState(() {
                                            _isNaCheck = false;
                                            _isNormalCheck = !_isNormalCheck;
                                            Provider.of<JcSignModel>(context,
                                                listen: false)
                                                .normalSignChooseChange(
                                                widget.itemData.path,
                                                _isNormalCheck);
                                          });
                                        } else {
                                          horizontalDoubleButtonDialog(context,
                                              title: "提示",
                                              info: "此条目不适用于本架飞机，是否确认操作？",
                                              leftText: "取消",
                                              rightText: "确认",
                                              onTapRight: () {
                                                setState(() {
                                                  _isNaCheck = false;
                                                  _isNormalCheck =
                                                  !_isNormalCheck;
                                                  Provider.of<JcSignModel>(
                                                      context,
                                                      listen: false)
                                                      .normalSignChooseChange(
                                                      widget.itemData.path,
                                                      _isNormalCheck);
                                                });
                                              });
                                        }
                                      }
                                    },
                                    _isNormalCheck
                                        ? KColor.primaryColor_2
                                        : KColor.primaryColor_1),
                              ],
                            ),
                          ),
                          Offstage(
                              offstage: !Provider
                                  .of<JcSignModel>(context,
                                  listen: false)
                                  .signPics
                                  .containsKey(widget.itemData.path),
                              child: InkWell(
                                onTap: () {
                                  horizontalDoubleButtonDialog(context,
                                      title: "提示",
                                      info: "修改或删除签名？",
                                      leftText: "修改",
                                      rightText: "删除",
                                      onTapLeft: () {
                                        Provider.of<JcSignModel>(context,
                                            listen: false)
                                            .modifySign(widget.itemData.path);
                                      },
                                      onTapRight: () {
                                        Provider.of<JcSignModel>(context,
                                            listen: false)
                                            .deleteSign(widget.itemData.path);
                                      });
                                },
                                child: Provider
                                    .of<JcSignModel>(context,
                                    listen: false)
                                    .signPics[widget.itemData.path] ==
                                    null
                                    ? Container()
                                    : Container(
                                  decoration: DashedDecoration(
                                    dashedColor: Colors.orangeAccent,
                                    borderRadius:
                                    BorderRadius.circular(5),
                                  ),
                                  height: 35,
                                  width: 92,
                                  child: Image.memory(
                                    base64Decode(Provider
                                        .of<JcSignModel>(
                                        context,
                                        listen: false)
                                        .signPics[widget.itemData.path]),
                                    height: 35,
                                    width: 92,
                                  ),
                                ),
                              ))
                        ],
                      );
                    },
                  ),
                ],
              ),
              Offstage(
                offstage: !_isShowImages,
                child: LyImageGallery(
                  imageList: [
                    {
                      "id": "${widget.itemData.path}1",
                      "url":
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591246881289&di=d325bb0819d57f05f9bd6bfa662ca634&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"
                    },
                    {
                      "id": "${widget.itemData.path}2",
                      "url":
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591246881289&di=d325bb0819d57f05f9bd6bfa662ca634&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"
                    },
                    {
                      "id": "${widget.itemData.path}3",
                      "url":
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591246881289&di=d325bb0819d57f05f9bd6bfa662ca634&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"
                    },
                    {
                      "id": "${widget.itemData.path}4",
                      "url":
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591246881289&di=d325bb0819d57f05f9bd6bfa662ca634&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"
                    },
                    {
                      "id": "${widget.itemData.path}5",
                      "url":
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1591246881289&di=d325bb0819d57f05f9bd6bfa662ca634&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"
                    }
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  bool checkPhoto(BuildContext context) {
    if (widget.itemData.photo) {
      if ("000001000001000001" == widget.itemData.path) {
        horizontalSingleButtonDialog(
            context, title: "提示", info: "您还没有上传图片！", buttonText: "确定");
        return false;
      }
      return true;
    }
    return true;
  }

  bool checkSign(BuildContext context) {
    if (Provider.of<JcSignModel>(context,listen: false).signPics.containsKey(widget.itemData.path)) {
      horizontalSingleButtonDialog(
          context, title: "提示", info: "已经签署的条目不允许拍照！", buttonText: "确定");
      return false;
    }
    return true;
  }

  List<ListTileItem> _buildPdfs(BuildContext context) {
    List<ListTileItem> items = List();
    for (int i = 0; i < 4; i++) {
      var value = "https://pdfkit.org/docs/guide.pdf";
      items.add(ListTileItem(
          key: value,
          text: "手册$i",
          color: Colors.black87,
          fontSize: 16.0,
          fontWeight: FontWeight.normal));
    }
    return items;
  }

  Widget _buildButton(text,
      onTap,
      color,) {
    return MaterialButton(
      onPressed: () {
        onTap();
      },
      padding: EdgeInsets.zero,
      minWidth: KSize.jcSignItemButtonWidth,
      elevation: 0.0,
      height: KSize.jcSignItemButtonHeight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      color: color,
      highlightColor: Colors.lightBlueAccent,
      child: Text(
        text,
        style:
        TextStyle(color: Colors.white, fontSize: KFont.fontSizeItemButton),
      ),
    );
  }
}
