import 'package:lop/network/network_response.dart';

abstract class CloseDDService{
  Future<NetworkResponse> close(String ddId);
}