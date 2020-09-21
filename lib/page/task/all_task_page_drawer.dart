import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/page/search/search_widget.dart';
import 'package:lop/page/task/all_task_public_key.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/device_info_util.dart';

TargetPlatform defaultTargetPlatform = TargetPlatform.iOS;
typedef drawerStateCallBack = void Function(bool isOpen);
typedef filterActionCall = void Function();
typedef resetActionCall = void Function();
const double spacing = 30;

class SmartDrawer extends Drawer {
  final double elevation;
  final String semanticLabel;
  final drawerStateCallBack stateCallBack;
  final double widthPercent;
  final filterActionCall filterAction;
  final resetActionCall resetAction;
  final Map<String, TextEditingController> textEditingControllers;
  final Map<String, FocusNode> textEdtingFocusNode;
  final Map<String,String> textEdtingTitle;
  final Map<String, String> searchHistoryMap;


  const SmartDrawer({
    Key key,
    this.elevation = 16.0,
    this.semanticLabel,
    this.stateCallBack,
    this.widthPercent = 0.7,
    this.filterAction,
    this.resetAction,
    this.textEditingControllers,
    this.textEdtingFocusNode,
    this.textEdtingTitle,
    this.searchHistoryMap
  }) :
  ///new start
        assert(widthPercent!=null&&widthPercent<1.0&&widthPercent>0.0)
  ///new end
  ,super(key: key);


  @override
  Widget build(BuildContext context) {
    ///new end
    return SmartDrawerListener(
        elevation,
        child,
        semanticLabel,
        widthPercent,
        stateCallBack,
        resetAction,
        filterAction,
        textEditingControllers,
        textEdtingFocusNode,
        textEdtingTitle,
        searchHistoryMap
    );
  }
}

class SmartDrawerListener extends StatefulWidget {

  final double elevation;
  final Widget child;
  final String semanticLabel;
  final double widthPercent;
  final drawerStateCallBack stateCallBack;
  final filterActionCall filterAction;
  final resetActionCall resetAction;
  final Map<String, TextEditingController> textEditingControllers;
  final Map<String, FocusNode> textEdtingFocusNode;
  final Map<String,String> textEdtingTitle;
  final Map<String, String> searchHistoryMap;

  SmartDrawerListener(
      this.elevation,
      this.child,
      this.semanticLabel,
      this.widthPercent,
      this.stateCallBack,
      this.resetAction,
      this.filterAction,
      this.textEditingControllers,
      this.textEdtingFocusNode,
      this.textEdtingTitle,
      this.searchHistoryMap
      );

  @override
  _SmartDrawerListenerState createState() => _SmartDrawerListenerState();
}

class _SmartDrawerListenerState extends State<SmartDrawerListener> {

  _SmartDrawerListenerState();
  bool isBuildDone = false;

  @override
  void initState() {
    if(widget.stateCallBack != null){
      widget.stateCallBack(true);
    }

    isBuildDone = false;

    WidgetsBinding.instance.addPostFrameCallback((_){
      //build 结束时回调
      isBuildDone = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    if(widget.stateCallBack != null){
      widget.stateCallBack(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = widget.semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = widget.semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = widget.semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }
    ///new start
    final double _width = MediaQuery.of(context).size.width * widget.widthPercent;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        ///edit start
        constraints: BoxConstraints.expand(width: _width),
        ///edit end
        child: Material(
          color: Colors.white,
          elevation: widget.elevation,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: ScreenUtil().setHeight(80)),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: DeviceInfoUtil.appBarHeight + ScreenUtil.statusBarHeight,
                  child: Container(
                    margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
                    child: Center(
                      child: Text(
                        Translations.of(context).text('all_task_page_search_title'),
                        style: TextStyle(
                            color: Colors.white, fontSize: KFont.fontSizeAppBarTitle, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(spacing),
              ),

              simpleTextField(
                  AllTaskFileterKey.actypeKey,
                  ' '),

              SizedBox(
                height: ScreenUtil().setHeight(spacing),
              ),

              simpleTextField(
                  AllTaskFileterKey.acRegKey,
                  ' '),

              SizedBox(
                height: ScreenUtil().setHeight(spacing),
              ),

              simpleTextField(
                  AllTaskFileterKey.flightNumKey,
                  ' '),

              SizedBox(
                height: ScreenUtil().setHeight(spacing),
              ),

              simpleTextField(
                  AllTaskFileterKey.taskTypeKey,
                  ' '),

              SizedBox(
                height: ScreenUtil().setHeight(spacing),
              ),

              simpleTextField(
                  AllTaskFileterKey.acArriveKey,
                  ' '),

              SizedBox(
                height: ScreenUtil().setHeight(spacing),
              ),

              simpleTextField(
                  AllTaskFileterKey.acLeaveKey,
                  ' '),

              SizedBox(
                height: ScreenUtil().setHeight(spacing),
              ),
              Container(
                height: ScreenUtil().setHeight(140),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(40),
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30)
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: ScreenUtil().setHeight(150),
                        child: RaisedButton(
                          onPressed: widget.resetAction,
                          child: Text(
                            Translations.of(context).text('all_task_page_reset_filter'),
                            style: TextStyle(
                                color: Colors.white, fontSize: KFont.fontSizeBtn_2),
                          ),
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: ScreenUtil().setWidth(spacing),
                    ),

                    Expanded(
                      flex:1,
                      child: Container(
                        height: ScreenUtil().setHeight(150),
                        child: RaisedButton(
                          onPressed: widget.filterAction,
                          child: Text(
                            Translations.of(context).text('all_task_page_search'),
                            style: TextStyle(
                                color: Colors.white, fontSize: KFont.fontSizeBtn_2),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget simpleTextField(String key, String hintText) {

    String fieldName = Translations.of(context).text(widget.textEdtingTitle[key]);
    TextEditingController controller = widget.textEditingControllers[key];
    FocusNode focusNode = widget.textEdtingFocusNode[key];
    String history = widget.searchHistoryMap[key];
    controller.text = isBuildDone ? controller.text : (history ?? '');
    bool isClear = false;
    controller.addListener((){
      if(controller.text.length > 0) {
        isClear = true;
      }else{
        isClear = false;
      }
    });

    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25), right: ScreenUtil().setWidth(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(0)),
              child: titleWidget(fieldName,KFont.fontSizeItem_1,Colors.grey)
            ),
            Container(
              height: ScreenUtil().setHeight(100),
              color: Colors.white,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(fontSize: TextThemeStore.textStyleSearch.fontSize,),
                      focusNode: focusNode,
                      controller: controller,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_){
                        focusNode.unfocus();
                      },
                      decoration: InputDecoration(
                          filled:true,
                          fillColor: KColor.textColor_f5,
                          contentPadding:EdgeInsets.only(left: 12, top: 0,bottom: 0,right: 20),
                          enabledBorder: OutlineInputBorder(
                            /*边角*/
                            borderRadius: BorderRadius.all(
                              Radius.circular(4), //边角
                            ),
                            borderSide: BorderSide(
                              color: KColor.borderColor, //边线颜色
                              width: 0.5, //边线宽度
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4), //边角
                              ),
                              borderSide: BorderSide(
                                color: KColor.borderColor, //边框颜色
                                width: 0.5, //宽度
                              )),
//                          suffix: GestureDetector(
//                            child: Icon(Icons.cancel),
//                            onTap: (){
//                              WidgetsBinding.instance.addPostFrameCallback((_){
//                                controller.clear();
//                              });
//                            },
//                          )
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }

  Widget titleWidget(String title,double fontSize,Color color){
    return Container(
//    color: Colors.red,
      padding: EdgeInsets.only(bottom: 5),
      alignment: Alignment.centerLeft,
      child:  Text(
        title,
        style: TextStyle(
            fontSize: KFont.fontSizeItem_2,
            color: color
        ),
      ),
    );
  }
}

