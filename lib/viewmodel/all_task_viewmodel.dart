
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:lop/config/global.dart';
import 'package:lop/model/task_model.dart';
import 'package:lop/model/task_state_list_model.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/page/task/all_task_public_key.dart';
import 'package:lop/service/task/all_task_service_impl.dart';
import 'package:lop/viewmodel/base_viewmodel.dart';

class AllTaskViewModel extends BaseViewModel with ChangeNotifier{

  AllTaskServiceImpl _allTaskServiceImpl = AllTaskServiceImpl();
  TaskStateListModel taskList;
  Map<String, String> searchHistoryMap;
  BuildContext context;
  int pages = 1;  //page = 0 与 page = 1 返回相同的内容
  int rowPerPage = 10;

  TextEditingController searchBarController;
  EasyRefreshController controller;
  TextEditingController acTypeController;
  TextEditingController acRegController;
  TextEditingController flightNumController;
  TextEditingController taskTypeController;
  TextEditingController acArriveController;
  TextEditingController acLeaveController;

  FocusNode acTypeFn;
  FocusNode acRegFn;
  FocusNode flightNumFn;
  FocusNode taskTypeFn;
  FocusNode acArriveFn;
  FocusNode acLeaveFn;

  static String acTypeTitle = 'all_task_page_actype';
  static String acRegTitle = 'all_task_page_acreg';
  static String flightNumTitle = 'all_task_page_flightNo';
  static String taskTypeTitle = 'all_task_page_tasktype';
  static String acArriveTitle = 'all_task_page_arrivePlace';
  static String acLeaveTitle = 'all_task_page_leavePlace';

  Map<String, TextEditingController> textEditingControllers;
  Map<String, FocusNode> textEditingFocusNode;
  Map<String,String> textEditingTitle;

  AllTaskViewModel(){
    this.searchBarController = TextEditingController();
     this.acTypeController = new TextEditingController();
     this.acRegController = new TextEditingController();
     this.flightNumController = new TextEditingController();
     this.taskTypeController = new TextEditingController();
     this.acArriveController = new TextEditingController();
     this.acLeaveController = new TextEditingController();

     this.acTypeFn = new FocusNode();
     this.acRegFn = new FocusNode();
     this.flightNumFn = new FocusNode();
     this.taskTypeFn = new FocusNode();
     this.acArriveFn = new FocusNode();
     this.acLeaveFn = new FocusNode();

     this.textEditingControllers = {
       AllTaskFileterKey.actypeKey: acTypeController,
       AllTaskFileterKey.acRegKey: acRegController,
       AllTaskFileterKey.flightNumKey: flightNumController,
       AllTaskFileterKey.taskTypeKey: taskTypeController,
       AllTaskFileterKey.acArriveKey: acArriveController,
       AllTaskFileterKey.acLeaveKey: acLeaveController
     };

     this.textEditingFocusNode = {
       AllTaskFileterKey.actypeKey: acTypeFn,
       AllTaskFileterKey.acRegKey: acRegFn,
       AllTaskFileterKey.flightNumKey: flightNumFn,
       AllTaskFileterKey.taskTypeKey: taskTypeFn,
       AllTaskFileterKey.acArriveKey: acArriveFn,
       AllTaskFileterKey.acLeaveKey: acLeaveFn
     };

     this.textEditingTitle = {
       AllTaskFileterKey.actypeKey: acTypeTitle,
       AllTaskFileterKey.acRegKey: acRegTitle,
       AllTaskFileterKey.flightNumKey: flightNumTitle,
       AllTaskFileterKey.taskTypeKey: taskTypeTitle,
       AllTaskFileterKey.acArriveKey: acArriveTitle,
       AllTaskFileterKey.acLeaveKey: acLeaveTitle
     };

     searchHistoryMap = Map();
  }

  Future<bool> loadData(int page, int row, bool resetList, {String acType, String acReg, String flightNum, String taskType, String arrivePort, String leavePort}) async{

    var userID = Global.userId;
    var token = Global.token;

    Map<String, dynamic> params = {
      'page': page,
      'rows': row,
      'sort': '',
      'order': 'desc',
      'acreg': acReg,
      'flightno': flightNum,
      'tasktype': taskType,
      'actype': acType,
      'acplacearrive': arrivePort,
      'acplaceleave': leavePort,
      'udfuserid':userID,
      'token':token,
      'isshiftto':'0'
    };

   NetworkResponse response = await _allTaskServiceImpl.onLoadData(params,resetList);

    if (response.data == null) {
      return false;
    }

    TaskStateListModel responseData = response.data;

    if (resetList) {
      taskList = responseData;
    } else {

      if(responseData.isEmpty() || responseData.page >= responseData.pageCount){
        controller.finishLoad(noMore: true,success: true);
      }else{
        controller.finishLoad(noMore: false,success: true);
      }

      if(responseData.data.isNotEmpty && taskList.data.length < responseData.total){
        taskList.data.addAll(responseData.data);
      }
    }
    return true;
  }
}