import 'package:lop/config/configure.dart';
import 'package:lop/network/network_request.dart';
import 'package:lop/network/network_response.dart';
import 'package:lop/service/base_service.dart';


import 'package:lop/model/task_state_num_model.dart';
import 'package:lop/service/mytask/task_info_new_service.dart';

class TaskInfoNewServiceImpl extends BaseService implements TaskInfoNewService{

  Future<NetworkResponse> fetchTaskInfoNew() async{
    NetworkResponse networkResponse = await networkRequest.request<TaskStateNumModel>(NetworkRequest.networkMethod_POST, NetServicePath.fetchMyTaskInfoNew);
    return networkResponse;
  }
}