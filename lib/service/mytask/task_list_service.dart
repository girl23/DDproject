///我的任务列表数据
import 'package:lop/network/network_response.dart';
import 'package:lop/config/enum_config.dart';
abstract class TaskListService{

  Future<NetworkResponse> fetchTaskList(String state,int page,int row);
}