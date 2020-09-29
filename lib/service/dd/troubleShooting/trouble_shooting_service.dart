import 'package:lop/network/network_response.dart';

abstract class TroubleShootingService{
  Future<NetworkResponse> shooting(String ddId);
}