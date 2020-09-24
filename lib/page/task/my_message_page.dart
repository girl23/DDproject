import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/model/message_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' as refresh;
import 'package:lop/page/search/search_widget.dart';
import 'package:lop/provide/task_index_provide.dart';
import 'package:lop/router/application.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/index.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:provider/provider.dart';
import 'package:lop/component/no_more_data_widget.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/viewmodel/search_my_message_viewmodel.dart';
class MyMessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage> {

  final controller = TextEditingController();
  SearchMessageModel _searchMessageModel;
  @override
  initState() {
    super.initState();
    //初始化数据
    _searchMessageModel=Provider.of<SearchMessageModel>(context,listen: false);
    _searchMessageModel.searchMessage(controller.text);
  }
  //访问数据接口
  _searchMessage(String title)async{
    bool success = await _searchMessageModel.searchMessage(title);
  }
  //构建视图
  @override
  Widget build(BuildContext context) {
    return Selector<TaskIndexProvide, int>(
      shouldRebuild: (o, n) => n == 3,
      selector: (context, state) => state.currentIndex,
      builder: (context, state, _) {
        print('刷新列表');
//        _searchMessage(controller.text);
        return GestureDetector(
          //点击空白处收回虚拟键盘
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: PreferredSize(
              child: new AppBar(
                title: new Text(
                  Translations.of(context).text('task_home_page_my_message'),
                  style: TextThemeStore.textStyleAppBar,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
            ),
            body: _myBody(),
          ),
        );
      },
    );
  }

//构建（搜索+列表）
  Widget _myBody() {
    return new Column(children: [
      Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setSp(10), right: ScreenUtil().setSp(10)),
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: SearchField(
          hintText: Translations.of(context).text("search_hint_message"),
          controller: controller,
          onSubmitted: (v) {
           _searchMessage(controller.text);
          },
          onClear: () {
          _searchMessage(controller.text);
          },
        ),
      ),
      _messageList(),
    ]);
  }
  //封装无数据列表视图
  Widget _noDataView(){
    return Expanded(
        child:
        refresh.EasyRefresh(
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
          child: new Center(
            child: NoMoreDataWidget(),
          ),
          onRefresh: () async {
            print('刷新');
            _searchMessage(controller.text);
          },
          onLoad: null,
        ),
      );
  }
  //封装有数据列表视图
  Widget _hasDataView(){
    return  Expanded(
      child:
      refresh.EasyRefresh(
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
        child: ListView.separated(
            itemCount:Provider.of<SearchMessageModel>(context).messageList.unReadData.length+Provider.of<SearchMessageModel>(context).messageList.readData.length,//_searchMessageModel.messageList.unReadData.length + _searchMessageModel.messageList.readData.length,
            itemBuilder: (context, index) {
              return _messageItemView(index);
            },
            separatorBuilder: (BuildContext context,int index){
              return Divider(color: KColor.dividerColor,height: KSize.dividerSize,);
            },
          ),
        onRefresh: () async {
          _searchMessage(controller.text);
        },
        onLoad: null,
      ),
    );
  }
  //封装列表项视图（返回已读未读视图）
  Widget _messageItemView(int index) {
    int unreadLength = Provider.of<SearchMessageModel>(context).messageList.unReadData.length;//_searchMessageModel.messageList.unReadData.length;
    //未读消息
    if(index < unreadLength){
      MessageModel message =Provider.of<SearchMessageModel>(context).messageList.unReadData[index];// _searchMessageModel.messageList.unReadData[index];
      return _messageItem(message, false);
    }else{
      MessageModel message =Provider.of<SearchMessageModel>(context).messageList.readData[index-unreadLength];// _searchMessageModel.messageList.readData[index - unreadLength];
      return _messageItem(message, true);
    }
  }
  //根据参数封装具体列表项 ItemWidget
  Widget _messageItem(MessageModel message, bool isRead) {
    //分割数据
    String tempStr =message.content;
    List msgContents = tempStr.split(',');
    List afterDealContents=new List();

    for (int i=0;i<msgContents.length;i++){
          String dealStr=msgContents[i];
          dealStr=dealStr.trim();
       if(dealStr.startsWith("\n")){
         dealStr=dealStr.replaceRange(0, 1, "");
        }
        if(dealStr.endsWith("\n")){
          dealStr=dealStr.replaceRange(tempStr.length-2, tempStr.length-1, "");
        }
        afterDealContents.add(dealStr);
    }
    String msg1;
    String msg2;
    List msg1List = afterDealContents.sublist(
        0,afterDealContents.length>1? afterDealContents.length - 1:1);
    msg1= msg1List.join(',');

    if (afterDealContents.length > 1) {
      msg2 = afterDealContents.last;
    }
    //选中效果Matrial,ink,inkwell
    return Material(
        child: Ink(
            color: Colors.white,
            child: InkWell(
                onTap: () async {
                  await Application.router.navigateTo(
                      context,
                      "/msg/detail/" + message.messageRecieveId + "/" + message.read + "/" + message.title + "/" + message.content+"/" + controller.text,
                      transition: TransitionType.fadeIn);
                  FocusScope.of(context).unfocus();
                },
                child: Card(
                    borderOnForeground: false,
                    elevation: 0.0,
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: KSize.commonPadding2 * 2,
                          top: KSize.commonPadding2,
                          right: KSize.commonPadding2,
                          bottom: KSize.commonPadding2),
                      child: Column(children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 14,
                              height: 14,
                              alignment: Alignment.center,
                              decoration: new BoxDecoration(
                                  color: !isRead ? Colors.red : null,
                                  borderRadius: BorderRadius.all(
                                    //圆角角度
                                    Radius.circular(7),
                                  )),
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                          text: message.title,
                                          style: TextThemeStore.textStyleCard_1,
                                          children: [
                                            TextSpan(
                                                text: "  ${message.sendTime}",
                                                style: TextStyle(
                                                  fontSize: TextThemeStore.textStyleCard_1.fontSize,
                                                  color: TextThemeStore
                                                      .textTheme_2
                                                      .display1
                                                      .color,
                                                ) //TextThemeStore.textTheme_2.display1,
                                            )
                                          ]),
                                    ),
                                  ),
                                  Container(
//                                    margin: EdgeInsets.only(bottom: 2),
                                    alignment: Alignment.centerLeft,
                                    child:msg1!=null&&msg1.length>0?
                                    RichText(
                                        text: TextSpan(
                                            text: msg1, // message.content,
                                            style: TextThemeStore.textStyleCard_2)):null,
                                  ),
                                  Container(
//                                    margin: EdgeInsets.only(bottom: 6),
                                    alignment: Alignment.centerLeft,
                                    child: msg2!=null&& msg2.length > 0
                                        ? RichText(
                                        text: TextSpan(
                                            text: msg2,
                                            style: TextThemeStore.textStyleCard_2))
                                        : null,
                                  )
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: KColor.textColor_99,
                              size: KSize.messageCardRightArrowSize,
                            )
                          ],
                        ),
                      ]),
                    )))));
  }
  //列表messageListWidget
  Widget _messageList() {
//      print('unread${Provider.of<SearchMessageModel>(context).messageList.unReadData}====${Provider.of<SearchMessageModel>(context).messageList.readData}');
    return Consumer<SearchMessageModel>(
      builder: (context,message,_){
        return (Provider.of<SearchMessageModel>(context).messageList.unReadData.length>0||Provider.of<SearchMessageModel>(context).messageList.readData.length>0)?_hasDataView():_noDataView();
      },
    );

  }
}


