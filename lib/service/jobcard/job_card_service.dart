import '../../network/network_response.dart';

abstract class JobCardService {
  Future<NetworkResponse> getJcModuleInfo(
      {int jcId, String jcVersion});
}
