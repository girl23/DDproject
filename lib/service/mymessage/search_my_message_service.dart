///搜索我的消息
import 'package:lop/network/network_response.dart';

abstract class SearchMyMessage{

  Future<NetworkResponse> searchMessage(String title);
}