///我的消息详情页
import 'package:lop/network/network_response.dart';

abstract class SetMessageRead{

  Future<NetworkResponse> setMessageRead(String msgId);
}