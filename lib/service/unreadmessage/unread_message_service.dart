import 'package:lop/network/network_response.dart';
abstract class UnreadMessageService{
  Future<NetworkResponse> unreadMessage();
}