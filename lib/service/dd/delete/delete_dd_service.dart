///
import 'package:lop/network/network_response.dart';

abstract class DeleteDDService{
  Future<NetworkResponse> delete(String ddId);
}