import 'package:dio/dio.dart';
import 'network_client.dart';
import 'network_response.dart';
import 'network_util.dart';
import '../service/entity/base_entity.dart';
import '../service/entity/error_entity.dart';
import '../service/entity/base_list_entity.dart';
import 'dart:convert';

class NetworkRequest {

  static const String networkMethod_GET = "get";
  static const String networkMethod_POST = "post";

  Future<NetworkResponse> request<T>(String method, String path,
      {Map<String, dynamic> params,
      CancelToken cancelToken}) async {
    print('path====$path');
    NetworkResponse  networkResponse = NetworkResponse();
    networkResponse.isSuccess = false;
    print('====${params.toString()}');

    ErrorEntity errorEntity;
    try {
      Response response = await NetWorkClient.instance
          .request(method, path, parameters: params);
      errorEntity = _doResponseError(response);
      if(errorEntity == null){
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.errorId != null) {
          //后端异常报错
          errorEntity = ErrorEntity(
              code: -1,
              message:
              "errorId:${entity.errorId},errorMsg:${entity.errorMsg}");
        } else {
          networkResponse.isSuccess = true;
          networkResponse.data = entity.data;
        }
      }
    } on DioError catch (e) {
      errorEntity = NetworkUtil.createErrorEntity(e);
    }
    networkResponse.errorEntity = errorEntity;
    return networkResponse;
  }

  Future<NetworkResponse> requestList<T>(String method, String path,
      {Map<String, dynamic> params,
      CancelToken cancelToken}) async {

    NetworkResponse networkResponse = NetworkResponse();
    networkResponse.isSuccess = false;
    ErrorEntity errorEntity;
    try {
      Response response = await NetWorkClient.instance
          .request(method, path, parameters: params);
      errorEntity = _doResponseError(response);
      if(errorEntity == null){
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.errorId != null) {
          //后端异常报错
          errorEntity = ErrorEntity(
              code: -1,
              message:
              "errorId:${entity.errorId}\nerrorMsg:${entity.errorMsg}");
        } else {
          networkResponse.isSuccess = true;
          networkResponse.dataList = entity.data;
        }
      }else{
        errorEntity = errorEntity;
      }
    } on DioError catch (e) {
      errorEntity = NetworkUtil.createErrorEntity(e);
    }
    networkResponse.errorEntity = errorEntity;
    return networkResponse;
  }

  Future uploadMultiFile<T>(String path,{FormData data}) async{
    NetworkResponse networkResponse = NetworkResponse();
    networkResponse.isSuccess = false;
    ErrorEntity errorEntity;
    try {
      Response response = await NetWorkClient.instance.postForm(path, data);
      errorEntity = _doResponseError(response);
      if(errorEntity == null){
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.errorId != null) {
          //后端异常报错
          errorEntity = ErrorEntity(
              code: -1,
              message:
              "errorId:${entity.errorId}\nerrorMsg:${entity.errorMsg}");
        } else {
          networkResponse.isSuccess = true;
          networkResponse.data = entity.data;
        }
      }else{
        errorEntity = errorEntity;
      }
    } on DioError catch (e) {
      errorEntity = NetworkUtil.createErrorEntity(e);
    }
    networkResponse.errorEntity = errorEntity;
    return networkResponse;
  }

  ErrorEntity _doResponseError(Response response){
    if (response != null) {
      if (NetworkUtil.isRemoteLogin(response.data)) {
        return ErrorEntity(code: ErrorEntity.errorCodeLogin, message: response.data);
      } else {
        return null;
      }
    } else {
      return ErrorEntity(code: -1, message: "未知错误");
    }
  }

}
