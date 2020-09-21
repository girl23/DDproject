import 'dart:math';

import 'package:flutter/services.dart';

import '../../config/configure.dart';
import '../../model/jobcard/net_jc_module_info_model.dart';
import '../../network/network_request.dart';
import '../../network/network_response.dart';
import '../../network/element.dart';
import '../base_service.dart';
import 'job_card_service.dart';

class JobCardServiceImpl extends BaseService implements JobCardService {
  ///
  /// 获取工卡模块化的内容
  ///
  @override
  Future<NetworkResponse> getJcModuleInfo(
      {int jcId, String jcVersion}) async {
    if (jcId == null) {
      print('jcId为null');
    }
    Map<String, dynamic> params = new Map();
    params.addAll({
      Element.JC_ID: jcId,
      Element.JC_VERSION: (jcVersion == null ? '' : jcVersion)
    });
//    NetworkResponse networkResponse =
//        await networkRequest.request<NetJcModuleInfoModel>(
//            NetworkRequest.networkMethod_GET, NetServicePath.getJcModuleInfo,
//            params: params);


    String data =
    await rootBundle.loadString('assets/testxml/CA320_3LM_New.xml');
    String newVersion = '1.0.${Random().nextInt(100)}';
    NetJcModuleInfoModel netJcModuleInfoModel = NetJcModuleInfoModel.fromJson({
      'jcVersion':newVersion,
      'xmlContent':data
    });

    NetworkResponse networkResponse = NetworkResponse();
    networkResponse.isSuccess = true;
    networkResponse.data = netJcModuleInfoModel;

    return networkResponse;
  }
}
