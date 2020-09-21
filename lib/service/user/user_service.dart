

import 'package:lop/network/network_response.dart';

abstract class UserService{

  Future<NetworkResponse> login(String username,String password,String macAddress);
  Future<NetworkResponse> checkVersion(String platForm,String version);
}