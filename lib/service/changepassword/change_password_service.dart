///修改密码
import 'package:lop/network/network_response.dart';

abstract class ChangePasswordService{

  Future<NetworkResponse> change(String oldPwd, String newPwd);
}