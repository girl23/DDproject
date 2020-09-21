

import 'package:lop/network/network_response.dart';

abstract class MaterialSearchService{

  Future<NetworkResponse> searchMatList(String matpn);
}