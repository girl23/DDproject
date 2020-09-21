import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/page/dd/dd_textfield_util.dart';
import 'package:lop/utils/translations.dart';

class XYDialog {
  List<Widget> widgetList = []; //弹窗内部所有组件
  BuildContext context; //弹窗上下文
  static BuildContext _context; //弹窗上下文
  double width; //弹窗宽度
  double height; //弹窗高度
  Duration duration = Duration(milliseconds: 250); //弹窗动画出现的时间
  Gravity gravity = Gravity.center; //弹窗出现的位置
  bool gravityAnimationEnable = false; //弹窗出现的位置带有的默认动画是否可用
  Color barrierColor = Colors.black.withOpacity(.3); //弹窗外的背景色
  BoxConstraints constraints; //弹窗约束
  Function(Widget child, Animation<double> animation) animatedFunc; //弹窗出现的动画
  bool barrierDismissible = true; //是否点击弹出外部消失
  EdgeInsets margin = EdgeInsets.all(0.0); //弹窗布局的外边距

  Decoration decoration; //弹窗内的装饰，与backgroundColor和borderRadius互斥
  Color backgroundColor = Colors.white; //弹窗内的背景色
  double borderRadius = 0.0; //弹窗圆角

  Function() showCallBack; //展示的回调
  Function() dismissCallBack; //消失的回调

  get isShowing => _isShowing; //当前 弹窗是否可见
  bool _isShowing = false;

  TextEditingController _inputController;
  FocusNode _inputFocus;
  static void init(BuildContext ctx) {
    _context = ctx;
  }
  XYDialog build({BuildContext ctx}) {
    this._inputController = new TextEditingController();
    this._inputFocus = new FocusNode();
    if (ctx == null && _context != null) {
      this.context = _context;
      return this;
    }
    this.context = ctx;
    return this;
  }

  XYDialog widget(Widget child) {
    this.widgetList.add(child);
    return this;
  }

  XYDialog text(
      {title,
      titleFontSize,
      titleFontWeight,
      titleColor,
      titlePadding,
      text,
      color,
      padding,
      fontSize,
      alignment,
      textAlign,
      maxLines,
      textDirection,
      overflow,
      fontWeight,
      fontFamily}) {
    return this.widget(
      Align(
        alignment: alignment ?? Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Offstage(
              offstage: title == null || title.isEmpty,
              child: Padding(
                padding: titlePadding,
                child: Text(
                  title ?? "",
                  textAlign: textAlign,
                  maxLines: maxLines,
                  textDirection: textDirection,
                  overflow: overflow,
                  style: TextStyle(
                    color: titleColor ?? Colors.black,
                    fontSize: titleFontSize ?? 16.0,
                    fontWeight: titleFontWeight,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
            Offstage(
                offstage: text == null || text.isEmpty,
                child: Padding(
                  padding: padding,
                  child: Text(
                    text ?? "",
                    textAlign: textAlign,
                    maxLines: maxLines,
                    textDirection: textDirection,
                    overflow: overflow,
                    style: TextStyle(
                      color: color ?? Colors.black,
                      fontSize: fontSize ?? 14.0,
                      fontWeight: fontWeight,
                      fontFamily: fontFamily,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  XYDialog richText(
      {title,
      titleFontSize,
      titleFontWeight,
      titleColor,
      titlePadding,
      infoLeft,
      richText,
      infoRight,
      color,
      richColor,
      padding,
      fontSize,
      alignment,
      textAlign,
      maxLines,
      textDirection,
      overflow,
      fontWeight,
      fontFamily}) {
    return this.widget(
      Align(
        alignment: alignment ?? Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Offstage(
              offstage: title == null || title.isEmpty,
              child: Padding(
                padding: titlePadding,
                child: Text(
                  title ?? "",
                  textAlign: textAlign,
                  maxLines: maxLines,
                  textDirection: textDirection,
                  overflow: overflow,
                  style: TextStyle(
                    color: titleColor ?? Colors.black,
                    fontSize: titleFontSize ?? 16.0,
                    fontWeight: titleFontWeight,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
            Padding(
              padding: padding,
              child: RichText(
                text: TextSpan(
                  text: infoLeft??"",
                  style: TextStyle(
                    color: color ?? Colors.black,
                    fontSize: fontSize ?? 14.0,
                    fontWeight: fontWeight,
                    fontFamily: fontFamily,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: richText??"",
                      style: TextStyle(
                        color: richColor ?? Colors.red,
                        fontSize: fontSize ?? 14.0,
                        fontWeight: fontWeight,
                        fontFamily: fontFamily,
                      )
                    ),
                    TextSpan(
                      text: infoRight??"",
                    )
                  ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  XYDialog inputText(
      {title,
      titleFontSize,
      titleFontWeight,
      titleColor,
      titlePadding,
      text,
      color,
      padding,
      borderRaduis,
      borderColor,
      borderSize,
      fontSize,
      minTextHeight,
      alignment,
      textAlign,
      maxLines,
      textDirection,
      overflow,
      fontWeight,
      disable,
      fontFamily}) {
    if (disable) {
      _inputController.text = text;
    }

    return this.widget(
      Align(
        alignment: alignment ?? Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Offstage(
              offstage: title == null || title.isEmpty,
              child: Padding(
                padding: titlePadding,
                child: Text(
                  title ?? "",
                  textAlign: textAlign,
                  maxLines: maxLines,
                  textDirection: textDirection,
                  overflow: overflow,
                  style: TextStyle(
                    color: titleColor ?? Colors.black,
                    fontSize: titleFontSize ?? 16.0,
                    fontWeight: titleFontWeight,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
            Padding(
              padding: padding,
              child: Container(
                height: minTextHeight,
                padding: EdgeInsets.only(top: 8),
                decoration: ShapeDecoration(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRaduis),
                        borderSide:
                            BorderSide(color: borderColor, width: borderSize))),
                child: TextField(
                  enableInteractiveSelection: !disable,
                  focusNode: _inputFocus,
                  onTap: () {
                    if (disable) {
                      _inputFocus.unfocus();
                    }
                  },
                  autofocus: !disable,
                  keyboardType: TextInputType.multiline,
                  controller: _inputController,
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: backgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      isDense: true,
                      border: InputBorder.none),
                  style: TextStyle(
                    color: color ?? Colors.black,
                    fontSize: fontSize ?? 14.0,
                    fontWeight: fontWeight,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  XYDialog doubleButton(
      {padding,
      gravity,
      height,
      width,
      isClickAutoDismiss = true, //点击按钮后自动关闭
      withDivider = false, //中间分割线
      text1,
      color1,
      fontSize1,
      fontWeight1,
      fontFamily1,
      VoidCallback onTap1,
      text2,
      color2,
      fontSize2,
      fontWeight2,
      leftBgColor,
      leftBgColorH,
      rightBgColor,
      rightBgColorH,
      shapeRadius,
      borderColor,
      fontFamily2,
      onTap2,
      dividerWidth,
      dividerColor}) {
    return this.widget(
      SizedBox(
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: getRowMainAxisAlignment(gravity),
            children: <Widget>[
              Container(
                  height: height,
                  width: width,
                  child: FlatButton(
                    color: leftBgColor,
                    highlightColor: leftBgColorH,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(shapeRadius),
                        side: BorderSide(color: borderColor)),
                    onPressed: () {
                      if (isClickAutoDismiss) {
                        dismiss();
                      }
                      if (onTap1 != null) onTap1();
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      text1 ?? "",
                      style: TextStyle(
                        color: color1 ?? null,
                        fontSize: fontSize1 ?? null,
                        fontWeight: fontWeight1,
                        fontFamily: fontFamily1,
                      ),
                    ),
                  )),
              Visibility(
                visible: withDivider,
                child: VerticalDivider(
                  width: dividerWidth,
                  color: dividerColor,
                ),
              ),
              Container(
                  height: height,
                  width: width,
                  child: FlatButton(
                    color: rightBgColor,
                    highlightColor: rightBgColorH,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(shapeRadius),
                    ),
                    onPressed: () {
                      if (isClickAutoDismiss) {
                        dismiss();
                      }
                      if (onTap2 != null) onTap2();
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      text2 ?? "",
                      style: TextStyle(
                        color: color2 ?? Colors.black,
                        fontSize: fontSize2 ?? 14.0,
                        fontWeight: fontWeight2,
                        fontFamily: fontFamily2,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  XYDialog doubleInputButton(
      {padding,
      gravity,
      height,
      width,
      isClickAutoDismiss = true, //点击按钮后自动关闭
      withDivider = false, //中间分割线
      text1,
      color1,
      fontSize1,
      fontWeight1,
      fontFamily1,
      VoidCallback onTap1,
      text2,
      color2,
      fontSize2,
      fontWeight2,
      leftBgColor,
      leftBgColorH,
      rightBgColor,
      rightBgColorH,
      shapeRadius,
      borderColor,
      fontFamily2,
      onTap2,
      dividerWidth,
      dividerColor,
      disable}) {
    return this.widget(
      SizedBox(
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: getRowMainAxisAlignment(gravity),
            children: <Widget>[
              Offstage(
                offstage: disable,
                child: Container(
                    height: height,
                    width: width,
                    child: FlatButton(
                      color: leftBgColor,
                      highlightColor: leftBgColorH,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(shapeRadius),
                          side: BorderSide(color: borderColor)),
                      onPressed: () {
                        if (isClickAutoDismiss) {
                          dismiss();
                        }
                        if (onTap1 != null) onTap1();
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        text1 ?? "",
                        style: TextStyle(
                          color: color1 ?? null,
                          fontSize: fontSize1 ?? null,
                          fontWeight: fontWeight1,
                          fontFamily: fontFamily1,
                        ),
                      ),
                    )),
              ),
              Visibility(
                visible: withDivider,
                child: VerticalDivider(
                  width: dividerWidth,
                  color: dividerColor,
                ),
              ),
              Container(
                  height: height,
                  width: width,
                  child: FlatButton(
                    color: rightBgColor,
                    highlightColor: rightBgColorH,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(shapeRadius),
                    ),
                    onPressed: () {
                      if (isClickAutoDismiss) {
                        dismiss();
                      }
                      if (onTap2 != null) onTap2(_inputController.text);
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      text2 ?? "",
                      style: TextStyle(
                        color: color2 ?? Colors.black,
                        fontSize: fontSize2 ?? 14.0,
                        fontWeight: fontWeight2,
                        fontFamily: fontFamily2,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  XYDialog textFieldArea(
      { padding,
        tagName,
        textFieldNodes,
        node,
        controller,
        borderColor}) {
    return this.widget(
        Container(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  Translations.of(context).text(tagName),
                  style: TextStyle(fontSize: KFont.formTitle)
              ),
              SizedBox(height: 10,),
              DDTextFieldUtil.ddTextField(context,tag:tagName,textFieldNodes: textFieldNodes,
                  node: node,
                  controller:controller,
                  multiline: true
              ) ,
            ],
          ),
        )
    );
  }
  XYDialog singleButton(
      {padding,
      gravity,
      height,
      width,
      isClickAutoDismiss = true, //点击按钮后自动关闭
      withDivider = false, //中间分割线
      text,
      color,
      fontSize,
      fontWeight,
      fontFamily,
      onTap,
      bgColor,
      bgColorH,
      shapeRadius,
      borderColor}) {
    return this.widget(
      SizedBox(
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: getRowMainAxisAlignment(gravity),
            children: <Widget>[
              Container(
                  height: height,
                  width: width,
                  child: FlatButton(
                    color: bgColor,
                    highlightColor: bgColorH,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(shapeRadius),
                    ),
                    onPressed: () {
                      if (isClickAutoDismiss) {
                        dismiss();
                      }
                      if (onTap != null) onTap();

                    },
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      text ?? "",
                      style: TextStyle(
                        color: color ?? Colors.black,
                        fontSize: fontSize ?? 14.0,
                        fontWeight: fontWeight,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  XYDialog listViewOfListTile({
    List<ListTileItem> items,
    double height,
    dividerColor,
    padding,
    highlightColor,
    isClickAutoDismiss = true,
    Function(String) onClickItemListener,
  }) {
    return this.widget(
      Container(
        height: height,
        padding: padding,
        child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
              return Material(
//              color: Colors.white,
                child: InkWell(
                  highlightColor: highlightColor,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          if (isClickAutoDismiss) {
                            dismiss();
                          }
                          if (onClickItemListener != null) {
                            onClickItemListener(items[index].key);
                          }
                        },
                        contentPadding: items[index].padding ?? EdgeInsets.all(0.0),
                        leading: items[index].leading,
                        title: Text(
                          items[index].text ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: items[index].color ?? null,
                            fontSize: items[index].fontSize ?? null,
                            fontWeight: items[index].fontWeight,
                            fontFamily: items[index].fontFamily,
                          ),
                        ),
                      ),
                      Divider(color: dividerColor,height: 1,)
                    ],
                  ),
                ),
              );
          },
        ),
      ),
    );
  }

  XYDialog circularProgress(
      {padding, backgroundColor, valueColor, strokeWidth}) {
    return this.widget(Padding(
      padding: padding,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 4.0,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor),
      ),
    ));
  }

  XYDialog divider({color, height}) {
    return this.widget(
      Divider(
        color: color ?? Colors.black26,
        height: height ?? 0.1,
      ),
    );
  }

  ///  x坐标
  ///  y坐标
  void show([x, y]) {
    var mainAxisAlignment = getColumnMainAxisAlignment(gravity);
    var crossAxisAlignment = getColumnCrossAxisAlignment(gravity);
    if (x != null && y != null) {
      gravity = Gravity.leftTop;
      margin = EdgeInsets.only(left: x, top: y);
    }
    CustomDialog(
      gravity: gravity,
      gravityAnimationEnable: gravityAnimationEnable,
      context: this.context,
      barrierColor: barrierColor,
      animatedFunc: animatedFunc,
      barrierDismissible: barrierDismissible,
      duration: duration,
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: MaterialType.transparency,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                dismiss();
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Padding(
                padding: margin,
                child: Column(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment,
                  children: <Widget>[
                    Material(
                      clipBehavior: Clip.antiAlias,
                      type: MaterialType.transparency,
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: width ?? null,
                          height: height ?? null,
                          decoration: decoration ??
                              BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                                color: backgroundColor,
                              ),
                          constraints: constraints ?? BoxConstraints(),
                          child: CustomDialogChildren(
                            widgetList: widgetList,
                            isShowingChange: (bool isShowingChange) {
                              // showing or dismiss Callback
                              if (isShowingChange) {
                                if (showCallBack != null) {
                                  showCallBack();
                                }
                              } else {
                                if (dismissCallBack != null) {
                                  dismissCallBack();
                                }
                              }
                              _isShowing = isShowingChange;
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dismiss() {
    if (_isShowing) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  getColumnMainAxisAlignment(gravity) {
    var mainAxisAlignment = MainAxisAlignment.start;
    switch (gravity) {
      case Gravity.bottom:
      case Gravity.leftBottom:
      case Gravity.rightBottom:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case Gravity.top:
      case Gravity.leftTop:
      case Gravity.rightTop:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Gravity.left:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.right:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.center:
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }
    return mainAxisAlignment;
  }

  getColumnCrossAxisAlignment(gravity) {
    var crossAxisAlignment = CrossAxisAlignment.center;
    switch (gravity) {
      case Gravity.bottom:
        break;
      case Gravity.top:
        break;
      case Gravity.left:
      case Gravity.leftTop:
      case Gravity.leftBottom:
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case Gravity.right:
      case Gravity.rightTop:
      case Gravity.rightBottom:
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      default:
        break;
    }
    return crossAxisAlignment;
  }

  getRowMainAxisAlignment(gravity) {
    var mainAxisAlignment = MainAxisAlignment.start;
    switch (gravity) {
      case Gravity.bottom:
        break;
      case Gravity.top:
        break;
      case Gravity.left:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Gravity.right:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case Gravity.center:
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }
    return mainAxisAlignment;
  }
}

///弹窗的内容作为可变组件
class CustomDialogChildren extends StatefulWidget {
  final List<Widget> widgetList; //弹窗内部所有组件
  final Function(bool) isShowingChange;

  CustomDialogChildren({this.widgetList = const [], this.isShowingChange});

  @override
  CustomDialogChildState createState() => CustomDialogChildState();
}

class CustomDialogChildState extends State<CustomDialogChildren> {
  @override
  Widget build(BuildContext context) {
    widget.isShowingChange(true);
    return Column(
      children: widget.widgetList,
    );
  }

  @override
  void dispose() {
    widget.isShowingChange(false);
    super.dispose();
  }
}

///弹窗API的封装
class CustomDialog {
  BuildContext _context;
  Widget _child;
  Duration _duration;
  Color _barrierColor;
  RouteTransitionsBuilder _transitionsBuilder;
  bool _barrierDismissible;
  Gravity _gravity;
  bool _gravityAnimationEnable;
  Function _animatedFunc;

  CustomDialog({
    @required Widget child,
    @required BuildContext context,
    Duration duration,
    Color barrierColor,
    RouteTransitionsBuilder transitionsBuilder,
    Gravity gravity,
    bool gravityAnimationEnable,
    Function animatedFunc,
    bool barrierDismissible,
  })  : _child = child,
        _context = context,
        _gravity = gravity,
        _gravityAnimationEnable = gravityAnimationEnable,
        _duration = duration,
        _barrierColor = barrierColor,
        _animatedFunc = animatedFunc,
        _transitionsBuilder = transitionsBuilder,
        _barrierDismissible = barrierDismissible {
    this.show();
  }

  show() {
    //fix transparent error
    if (_barrierColor == Colors.transparent) {
      _barrierColor = Colors.white.withOpacity(0.0);
    }

    showGeneralDialog(
      context: _context,
      barrierColor: _barrierColor ?? Colors.black.withOpacity(.3),
      barrierDismissible: _barrierDismissible ?? true,
      barrierLabel: "",
      transitionDuration: _duration ?? Duration(milliseconds: 250),
      transitionBuilder: _transitionsBuilder ?? _buildMaterialDialogTransitions,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(
          builder: (BuildContext context) {
            return _child;
          },
        );
      },
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    Animation<Offset> custom;
    switch (_gravity) {
      case Gravity.top:
      case Gravity.leftTop:
      case Gravity.rightTop:
        custom = Tween<Offset>(
          begin: Offset(0.0, -1.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.left:
        custom = Tween<Offset>(
          begin: Offset(-1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.right:
        custom = Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.bottom:
      case Gravity.leftBottom:
      case Gravity.rightBottom:
        custom = Tween<Offset>(
          begin: Offset(0.0, 1.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
      case Gravity.center:
      default:
        custom = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(animation);
        break;
    }

    //自定义动画
    if (_animatedFunc != null) {
      return _animatedFunc(child, animation);
    }

    //不需要默认动画
    if (!_gravityAnimationEnable) {
      custom = Tween<Offset>(
        begin: Offset(0.0, 0.0),
        end: Offset(0.0, 0.0),
      ).animate(animation);
    }

    return SlideTransition(
      position: custom,
      child: child,
    );
  }
}

enum Gravity {
  left,
  top,
  bottom,
  right,
  center,
  rightTop,
  leftTop,
  rightBottom,
  leftBottom,
}

class ListTileItem {
  ListTileItem(
      {this.padding,
      this.leading,
      this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.fontFamily,
      this.key});

  EdgeInsets padding;
  Widget leading;
  String text;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  String fontFamily;
  String key;
}

class RadioItem {
  RadioItem({
    this.padding,
    this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.onTap,
  });

  EdgeInsets padding;
  String text;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  Function(int) onTap;
}
