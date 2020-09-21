import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';

import 'package:lop/config/configure.dart';
import 'package:lop/config/global.dart';
import 'package:lop/network/network_config.dart';


Future request(url,{FormData formData})async{

  try{
    Response response;

    Dio dio = new Dio();
    dio.options.baseUrl = NetworkConfig.getServerUrl();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    //application/x-www-form-urlencoded
    dio.options.contentType = Headers.formUrlEncodedContentType;

    //拦截器
    dio.interceptors.add(InterceptorsWrapper(
        onRequest:(RequestOptions options) async {
          // 在请求被发送之前做一些事情
          return options; //continue
          // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
          // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
          //
          // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
          // 这样请求将被中止并触发异常，上层catchError会被调用。
        },
        onResponse:(Response response) async {
          // 在返回响应数据之前做一些预处理
          return response; // continue
        },
        onError: (DioError e) async {
          // 当请求失败时做一些预处理
          //
          print(e.toString());
          return e;//continue
        }
    ));

    print('url:${url}');

    var otherParameters = {
      "REQ":"XJSON"
    };

    if(formData == null){
      response = await dio.post(url,queryParameters: otherParameters);
    }else{
      response = await dio.post(url,data: formData,queryParameters:otherParameters);
    }

    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception('后端接口请求错误');
    }

  }catch(e){
    return print('errpr:::${e}');
    //throw e;
  }


}