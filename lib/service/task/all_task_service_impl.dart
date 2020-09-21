
import 'package:lop/config/configure.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';
import 'package:lop/service/task/all_task_service.dart';
import 'package:lop/model/task_state_list_model.dart';

class AllTaskServiceImpl extends BaseService implements AllTaskService {

  Future<NetworkResponse> onLoadData(Map<String,dynamic> param, bool resetList) async{

    NetworkResponse response = await networkRequest.request<TaskStateListModel>(NetworkRequest.networkMethod_POST, NetServicePath.getAllTaskList,params: param);

    return response;
  }

}