import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart' as refresh;
import 'package:lop/model/dd/dd_list_model.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/router/application.dart';
import '../dd_list_item.dart';
import 'package:lop/style/theme/text_theme.dart';
import 'package:lop/page/dd/dd_drawer_widget.dart';
import 'package:lop/viewmodel/dd/ddlist_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lop/utils/date_util.dart';
import 'package:lop/component/no_more_data_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:lop/utils/loading_dialog_util.dart';
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
  var _scaffoldkey = new GlobalKey<ScaffoldState>();//解决抽屉弹出问题
  refresh.EasyRefreshController _refreshController;
  DDListViewModel _listVM;
  int currentPage=1;
  ProgressDialog _loadingDialog;
  //body
  //处理状态，控制列表文字颜色显示，和中英文字显示
  String dealState(String state){
    if(state=="0"||state=="9"){
      return "un_close";
    }else if(state=="1"){
      return "closed";
    }else if(state=="2"){
      return "deleted";
    } else{
      return  "un_close";
    }
  }
  Widget temporaryDDBody(){
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
            currentPage=1;
            _listVM.getList('LB',page: '1',ddNo: _numberController.text,acReg: _planeNoController.text,state: _dropValueForState);
          },
          onLoad:() async{
            if(_listVM.pageCount>currentPage){
              currentPage+=1;
              _listVM.getList('LB',page: currentPage.toString(),ddNo: _numberController.text,acReg: _planeNoController.text,state: _dropValueForState);
            }
          },
        ),
      );
    }
    //封装有数据列表视图
    Widget _hasDataView(){
      return  Consumer<DDListViewModel>(builder: (context, DDListViewModel model,_) {
        return  Expanded(child:
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
            controller: _refreshController,
            child:
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index,){
                DDListItemModel model=Provider.of<DDListViewModel>(context).ddList[index];
                String stateStr=dealState(model.ddState) ;
                String bgdate=DateUtil.formateYMD_seconds(model.zzbgdt);

                return DDListItem(temporaryDDNumber:model.zzblno??'',planeNumber:model.zzmsgrp??'',createDate: bgdate ,temporaryDDState:stateStr,itemClick: (){

                  Application.router.navigateTo(
                      context,
                      "/temporaryDDDetailPage/"+stateStr+"/"+model.ddid.toString(),
                      transition: TransitionType.fadeIn);
                },
                );
              },
              itemCount:Provider.of<DDListViewModel>(context).ddList.length,// listData.length,
            ),

            onRefresh: () async {
              //下拉请求新数据
              currentPage=1;
              _listVM.getList('LB',page: '1',ddNo: _numberController.text,acReg: _planeNoController.text,state: _dropValueForState);

            },
            onLoad:()async{
              //上拉增加新数据
              if(_listVM.pageCount>currentPage){
                currentPage+=1;
                _listVM.getList('LB',page: currentPage.toString(),ddNo: _numberController.text,acReg: _planeNoController.text,state: _dropValueForState);
              }
            }// null,
        ));
      }
      );
    }
  return
    Column(
    children: <Widget>[
      SizedBox(height: 15,),
      ((Provider.of<DDListViewModel>(context).ddList!=null)?(Provider.of<DDListViewModel>(context).ddList.length):0)>0?_hasDataView():_noDataView(),
    ],
  );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textFieldNodes=[_numberFocusNode,_planeNoFocusNode,_stateNode];
    _refreshController= refresh.EasyRefreshController();
    _listVM=Provider.of<DDListViewModel>(context,listen: false);
    _listVM.getList('LB',page: currentPage.toString());
  }
  @override
  Widget build(BuildContext context) {
    return
     new Scaffold(
       key: _scaffoldkey,
      appBar: AppBar(
        title:Text(Translations.of(context).text('temporary_dd_list_page'), style: TextThemeStore.textStyleAppBar,),
        actions: <Widget>[
          //抽屉
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
          //新建
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
        child: DDDrawerWidget('LB',textFieldNodes: this._textFieldNodes,numberFocusNode: _numberFocusNode,numberController: _numberController,
        planeNoFocusNode: _planeNoFocusNode,planeNoController: _planeNoController,valueChanged: (val){
            _dropValueForState=val;
          },sureBtnClick: ()async{
          //确认搜索
            if (_loadingDialog == null) {
              _loadingDialog = LoadingDialogUtil.createProgressDialog(context);
            }
            await _loadingDialog.show();
            //确认搜索
            _listVM=Provider.of<DDListViewModel>(context,listen: false);
            bool success=await _listVM.getList('LB',all:false,page:this.currentPage.toString(),ddNo:_numberController.text,acReg: _planeNoController.text,state:_dropValueForState) ;
            if(success){
              _loadingDialog.hide().whenComplete((){
                Navigator.pop(context);
              });
            }else{
              _loadingDialog.hide();
            }
          },)//temporaryDDDrawer(),
      ),
      body:temporaryDDBody(),
        //autoListView(),//manuallyListView(),
    ) ;
  }
}


