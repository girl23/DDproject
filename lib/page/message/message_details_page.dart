import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:flutter/material.dart';
import 'package:lop/model/message_model.dart';
import 'package:lop/model/message_list_model.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/utils/device_info_util.dart';

import 'package:provider/provider.dart';
import 'package:lop/viewmodel/unread_message_viewmodel.dart';
import 'package:lop/viewmodel/search_my_message_viewmodel.dart';
import 'package:lop/model/message_list_model.dart';
import 'package:lop/viewmodel/set_message_read_viewmodel.dart';
import 'package:lop/viewmodel/set_message_read_viewmodel.dart';
import 'package:provider/provider.dart';
class MsgDetailsPage extends StatefulWidget {
  @override
  final MessageModel message = new MessageModel();
  String _searchTitle;
  //创建消息详情数据
  MsgDetailsPage(String msgId, String read, String title, String content,String searchTitle) {
    message.messageRecieveId = msgId;
    message.read = read;
    message.title = title;
    message.content = content;
    _searchTitle=searchTitle;
  }
  State<StatefulWidget> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MsgDetailsPage> {

SetMessageReadViewModel _setMessageReadViewModel;

  @override
  void initState() {
    super.initState();
    _setMessageReadViewModel=Provider.of<SetMessageReadViewModel>(context,listen: false);
    if (widget.message.read == "0") {
     _setMessageRead();
    }
  }
  void _setMessageRead() async{
    _setMessageReadViewModel.setMessageRead(widget.message.messageRecieveId);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        child: new AppBar(
          centerTitle: true,
          title: new Text(
            "消息内容",
            style: TextThemeStore.textStyleAppBar,
          ),
        ),
        preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
      ),
      body: new Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
//              color: Colors.red,
              child: Text(
                widget.message.title,
                style: new TextStyle(
                  fontSize: KFont.fontSizeItem_1,
                ),
              ),
            ),
            Divider(
              height: ScreenUtil().setHeight(1.0),
              indent: ScreenUtil().setWidth(30.0),
              endIndent: ScreenUtil().setWidth(30.0),
              color: Colors.black,
            ),
            Expanded(
              child: Container(
//                color: Colors.red,
                  padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                    child: Text(
                      widget.message.content,
                      style: new TextStyle(
                          fontSize: KFont.fontSizeItem_2,
                      ),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
