import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' as refresh;
import 'package:lop/utils/translations.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/router/application.dart';
import '../dd_list_item.dart';
import '../component/dd_component.dart';
import 'package:lop/page/dd/operation_button_util.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/page/dd/dd_drawer_widget.dart';
class DDListPage extends StatefulWidget {
  @override
  _DDListPageState createState() => _DDListPageState();
}
class _DDListPageState extends State<DDListPage> {
  //焦点
  FocusNode _numberFocusNode = new FocusNode();
  FocusNode _planeNoFocusNode = new FocusNode();
  FocusNode _stateNode = new FocusNode();
  //控制器
  TextEditingController _numberController = new TextEditingController();
  TextEditingController _planeNoController = new TextEditingController();
  //下拉
  String _dropValueForState;
  List _textFieldNodes;
  String ddState;
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  //body
  Widget temporaryDDBody(){
//   List stateList=['待批准','未关闭','待排故','待检验','已转办','已延期','已关闭','已删除','延期关闭'];
   List stateList=[
     "to_Audit",
     "un_close",
     "forTroubleShooting",
     "for_inspection",
     "have_transfer",
     "has_delay",
     "closed",
     "deleted",
     "delay_close",
   ];
  return Column(
    children: <Widget>[
      Expanded(
        child:refresh.EasyRefresh(
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
          child:Column(
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 9,
                  itemBuilder: (BuildContext context,int index){
                    return DDListItem(temporaryDDNumber: '${Translations.of(context).text('dd_number')}：LN23048751',planeNumber:'${Translations.of(context).text('dd_planeNo')}：B-1244' ,temporaryDDState:stateList[index] ,itemClick: (){
                      //dd详情
                      //      toAudit,//待批准
                      //      unClose,//未关闭
                      //      forTroubleshooting,//待排故
                      //      forInspection,//待检验
                      //      haveTransfer,//已转办
                      //  hasDelay,//已延期
                      //  closed,//已关闭
                      //  deleted,//已删除
                      //  delayClose//延期关闭
                      ddState='unClose';
                      switch(index){
                        case 0 :
                          ddState='toAudit';
                          break;
                        case 1 :
                          ddState='unClose';
                          break;
                        case 2 :
                          ddState='forTroubleshooting';
                          break;
                        case 3 :
                          ddState='forInspection';
                          break;
                        case 4 :
                          ddState='haveTransfer';
                          break;
                        case 5 :
                          ddState='hasDelay';
                          break;
                        case 6 :
                          ddState='closed';
                          break;
                        case 7 :
                          ddState='deleted';
                          break;
                        case 8 :
                          ddState='delayClose';
                          break;
                        default:
                          ddState='unClose';
                          break;
                      }
                      Application.router.navigateTo(
                          context,
                          "/dDDDetailPage/"+ddState+"/"+ddState+"",
                          transition: TransitionType.fadeIn);

                    },);
                  }
              ),
            ],
          ),
          onRefresh: () async {
          },
          onLoad: null,
        ),
      )

    ],
  );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textFieldNodes=[_numberFocusNode,_planeNoFocusNode,_stateNode];

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title:Text(Translations.of(context).text('dd_list_page'), style: TextThemeStore.textStyleAppBar,),
        actions: <Widget>[
          Container(

            width: 35,
            height: 35,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon:ImageIcon(AssetImage('assets/images/sou.png')), //Icon(Icons.search),
              onPressed: () {
                _scaffoldkey.currentState.openEndDrawer();
              },
            ) ,),
          Container(
//                color:Colors.green,
              width: 35,
              height: 35,
              child:IconButton(
                splashColor: Colors.transparent,
                highlightColor:Colors.transparent,
                icon:ImageIcon(AssetImage('assets/images/xinjian.png')),//Icon(Icons.create_new_folder),
                onPressed: (){
                  //新建DD
                  Application.router.navigateTo(context, Routes.addDDPage, transition: TransitionType.fadeIn);
                },
              )
          ),
          SizedBox(width: 10),
        ],
      ),
      endDrawer:new Drawer(
        child: DDDrawerWidget(textFieldNodes: this._textFieldNodes,numberFocusNode: _numberFocusNode,numberController: _numberController,
          planeNoFocusNode: _planeNoFocusNode,planeNoController: _planeNoController,valueChanged: (val){
            _dropValueForState=val;
          },)//temporaryDDDrawer(),
      ),
      body:temporaryDDBody(),
        //autoListView(),//manuallyListView(),
    ) ;
  }
}


