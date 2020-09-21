import 'dart:core';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/config/global.dart';
import 'package:lop/network/network_config.dart';
import 'package:lop/router/application.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../config/configure.dart';
import '../config/global.dart';
import 'entity/base_entity.dart';
import 'entity/base_list_entity.dart';
import 'entity/error_entity.dart';

class DioManager{
  static final DioManager _shared = DioManager._internal();
  factory DioManager() => _shared;
  Dio dio;
  CookieJar cookieJar;

  DioManager._internal() {
    if(dio == null){
      BaseOptions options = BaseOptions(
        baseUrl: NetworkConfig.getServerUrl(),
        receiveDataWhenStatusError: false,
        connectTimeout: 20000,
        receiveTimeout: 20000,
        sendTimeout: 20000,
        contentType: Headers.formUrlEncodedContentType

      );
      dio = Dio(options);
      cookieJar = new CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));


      //拦截器
      dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        var op = options;

        var userID = Global.userId;
        var token = Global.token;

        if (userID == null) {
          userID = '';
        }
        if (token == null || options.path == NetServicePath.loginRequest){
          token = '';
        }

        options.path = options.path + '?RBQ=XJSON&udfuserid='+ userID + '&token=' + token;

        //print("请求Param: "+options.queryParameters.toString());
        //print('请求Path: '+options.path);

        return op; //continue
      }, onResponse: (Response response) {

            // Do something with response data
        if(response.headers.toString().contains("JSESSIONID")){

        }

        //print(response.data);
        return response; // continue

      }, onError: (DioError e) {

        print('-- error: ' + e.toString());
        print('-- error path: ${e.request.path}');
        //Fluttertoast.showToast(msg: createErrorEntity(e).message, gravity: ToastGravity.CENTER,);
        return e; //continue
      }));


    }
  }

  void addOtherParameters(Map<String, dynamic> params){

    params.addAll(otherParameters);

    if(Global.userId == null){
      return;
    }

    //获取登录状态
     params.addAll(
          {
            "udfuserid":Global.userId,
            "token":Global.token
          }
      );

  }

  /*请求，返回T
   * method 请求方法 如post等
   * path：请求路径 定义在servicePath中
   * content: 上下文 用于获取中英翻译和provider状态信息
   * params请求参数
   * success:请求成功回调
   * error:请求失败回调
   */
  Future request<T>(httpMethod method,String path,BuildContext context,{Map<String, dynamic> params, Function(T) success, void Function(ErrorEntity) error}) async{
      try{

        addOtherParameters(params);
       // await Future.delayed(Duration(microseconds: 10000000));

        Response response = await dio.request(path,queryParameters: params,options: Options(method:methodValues[method]));

        if (response != null) {
          //异机登录判断，此功能后台后续接口需进行修改
         await  _remoteLogin(context,response.data);
//         LogUtil.e("\n===path:${path}\n====param:${params}\n========responsedata${response.data}>>>>>>>>>>>>>>");
          BaseEntity entity = BaseEntity<T>.fromJson(response.data);

         if(entity.errorId != null){
            //后端异常报错
            error(ErrorEntity(code: -1, message: "errorId:${entity.errorId}\n errorMsg:${entity.errorMsg}"));
            return;
          }

          success(entity.data);
        } else {
          error(ErrorEntity(code: -1, message: "未知错误"));
        }
      } on DioError catch(e) {
        error(createErrorEntity(e));
      }

      }

  // 请求，返回参数为 List<T>
  // method：请求方法，POST等
  // path：请求地址
  //content: 上下文 用于获取中英翻译和provide状态信息
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future requestList<T>(httpMethod method, String path,BuildContext context, {Map<String, dynamic> params, Function(List<T>) success, Function(ErrorEntity) error}) async {
    try {
      addOtherParameters(params);

      Response response = await dio.request(path, queryParameters: params, options: Options(method: methodValues[method]));
      if (response != null) {
        //异机登录判断，此功能后台后续接口需进行修改
        _remoteLogin(context,response.data);

        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);

        if(entity.errorId != null){
          //后端异常报错
          error(ErrorEntity(code: -1, message: "errorId:${entity.errorId}\n errorMsg:${entity.errorMsg}"));
          return;
        }

        success(entity.data);
      } else {
        error(ErrorEntity(code: -1, message: "未知错误"));
      }

    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }


  Future uploadMultiFile<T>(String path,BuildContext context,{FormData data, Function(T) success, Function(ErrorEntity) error}) async{
    try{
      Map<String, dynamic> params = new Map();
      addOtherParameters(params);

      Response response = await dio.post(path,data: data,
          queryParameters: params);

      if (response != null) {
        //异机登录判断，此功能后台后续接口需进行修改
        await  _remoteLogin(context,response.data);

        BaseEntity entity = BaseEntity<T>.fromJson(response.data);

        if(entity.errorId != null){
          //后端异常报错
          error(ErrorEntity(code: -1, message: "errorId:${entity.errorId}\n errorMsg:${entity.errorMsg}"));
          return;
        }

        success(entity.data);
      } else {
        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }

  }

  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:{
        return ErrorEntity(code: -1, message: "请求取消");
      }
      break;
      case DioErrorType.CONNECT_TIMEOUT:{
        return ErrorEntity(code: -1, message: "连接超时");
      }
      break;
      case DioErrorType.SEND_TIMEOUT:{
        return ErrorEntity(code: -1, message: "请求超时");
      }
      break;
      case DioErrorType.RECEIVE_TIMEOUT:{
        return ErrorEntity(code: -1, message: "响应超时");
      }
      break;
      case DioErrorType.RESPONSE:{
        try {
          int errCode = error.response.statusCode;
          String errMsg = error.response.statusMessage;
          return ErrorEntity(code: errCode, message: errMsg);
//          switch (errCode) {
//            case 400: {
//              return ErrorEntity(code: errCode, message: "请求语法错误");
//            }
//            break;
//            case 403: {
//              return ErrorEntity(code: errCode, message: "服务器拒绝执行");
//            }
//            break;
//            case 404: {
//              return ErrorEntity(code: errCode, message: "无法连接服务器");
//            }
//            break;
//            case 405: {
//              return ErrorEntity(code: errCode, message: "请求方法被禁止");
//            }
//            break;
//            case 500: {
//              return ErrorEntity(code: errCode, message: "服务器内部错误");
//            }
//            break;
//            case 502: {
//              return ErrorEntity(code: errCode, message: "无效的请求");
//            }
//            break;
//            case 503: {
//              return ErrorEntity(code: errCode, message: "服务器挂了");
//            }
//            break;
//            case 505: {
//              return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
//            }
//            break;
//            default: {
//              return ErrorEntity(code: errCode, message: "未知错误");
//            }
//          }
        } on Exception catch(_) {
          return ErrorEntity(code: -1, message: "未知错误");
        }
      }
      break;
      default: {
        return ErrorEntity(code: -1, message: error.message);
      }
    }
  }

  Future<bool> _remoteLogin(BuildContext context, data)async {

    if("其他人登录此账号，请重新登录" == data.toString()){
      if(Global.userId == null){
        return false;
      }
      Global.userId = null;
      Global.token = null;
      Provider.of<UserViewModel>(context,listen: false).clear();
     return await showDialog<bool>(
        context: context,
        barrierDismissible:false,
        builder: (context) => new AlertDialog(
          title: new Text('请注意！'),
          content: new Text('其他人登录此账号，请重新登录'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                //退出登录
                Application.router
                    .navigateTo(context, "/", clearStack: true,transition: TransitionType.fadeIn);
              },
              child: new Text('确认'),
            ),
          ],
        ),
      );

    }

  }

}