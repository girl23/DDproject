import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' as refresh;
import 'package:lop/utils/translations.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/router/application.dart';
import '../dd_list_item.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/page/dd/dd_drawer_widget.dart';
class TemporaryDDListPage extends StatefulWidget {
  @override
  _TemporaryDDListPageState createState() => _TemporaryDDListPageState();
}
class _TemporaryDDListPageState extends State<TemporaryDDListPage> {
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
    List stateList=[Translations.of(context).text("un_close"),Translations.of(context).text("closed"),Translations.of(context).text("deleted")];
  return Column(
    children: <Widget>[
      SizedBox(height: 15,),
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
                  itemCount: 3,
                  itemBuilder: (BuildContext context,int index){
                    return DDListItem(temporaryDDNumber: 'LN23048751',planeNumber:'B-1244' ,temporaryDDState:stateList[index],itemClick: (){
                      //新建临保
                      ddState='unClose';
                      switch(index){
                        case 0 :
                          ddState='unClose';
                          break;
                        case 1 :
                          ddState='closed';
                          break;
                        case 2 :
                          ddState='deleted';
                          break;
                        default:
                          ddState='unClose';
                          break;
                      }
                      Application.router.navigateTo(
                          context,
                          "/temporaryDDDetailPage/"+ddState,
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

    return
     new Scaffold(
       key: _scaffoldkey,
      appBar: AppBar(
        title:Text(Translations.of(context).text('temporary_dd_list_page'), style: TextThemeStore.textStyleAppBar,),
        actions: <Widget>[
          Container(
            width: 35,
            height: 35,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon:ImageIcon(AssetImage('assets/images/sou.png')),
              onPressed: () {
                _scaffoldkey.currentState.openEndDrawer();
              },
            ) ,),
          Container(
            width: 35,
            height: 35,
            child:IconButton(
              splashColor: Colors.transparent,
              highlightColor:Colors.transparent,
              icon:ImageIcon(AssetImage('assets/images/xinjian.png')),//Icon(Icons.create_new_folder),
              onPressed: (){
                //新建临保
                Application.router
                    .navigateTo(context, Routes.addTemporaryDDPage, transition: TransitionType.fadeIn);
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


