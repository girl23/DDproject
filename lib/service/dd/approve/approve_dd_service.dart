///
import 'package:lop/network/network_response.dart';

abstract class ApproveDDService{
  Future<NetworkResponse> approve(String ddId,String approvedDate);
}