
import 'package:lop/network/network_response.dart';

abstract class AllTaskService {


  Future<NetworkResponse> onLoadData(Map<String,dynamic> param, bool resetList);

}