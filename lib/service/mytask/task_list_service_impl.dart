///我的任务列表数据
import 'package:lop/config/configure.dart';

import 'package:lop/network/element.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/mytask/task_list_service.dart';
import 'package:lop/config/enum_config.dart';
import 'package:lop/model/task_state_list_model.dart';

class TaskListServiceImpl extends BaseService implements TaskListService{

  @override
  Future<NetworkResponse> fetchTaskList(String state,int page ,int row) async{
    Map<String,dynamic> params = new Map();
    params.addAll({Element.PAGE:page});
    params.addAll({Element.ROWS:row});
    params.addAll({Element.SORT:''});
    params.addAll({Element.ORDER:'desc'});
    params.addAll({Element.STATE:state});

    NetworkResponse networkResponse = await networkRequest.request<TaskStateListModel>(NetworkRequest.networkMethod_GET, NetServicePath.getTaskListByState,params: params);
    return networkResponse;
  }

}