///
import 'package:lop/network/network_response.dart';

abstract class DealResultService{
  Future<NetworkResponse> result(String ddId,String dealRes);
}