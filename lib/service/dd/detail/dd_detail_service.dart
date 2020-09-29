///
import 'package:lop/network/network_response.dart';

abstract class DDDetailService{
  Future<NetworkResponse> fetchDetail(String ddId);
}