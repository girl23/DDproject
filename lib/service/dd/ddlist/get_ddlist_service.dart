///dd列表
import 'package:lop/network/network_response.dart';

abstract class GetDDListService{
  Future<NetworkResponse> getList(String ddLB,{bool all,String ddNo, String acReg, String state});
}