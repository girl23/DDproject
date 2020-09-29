import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../config/configure.dart';
import '../config/global.dart';
import 'element.dart';

import 'network_config.dart';

class NetWorkClient {
// 通过工厂模式创建单例模式
  static NetWorkClient _instance;
  factory NetWorkClient() => _getInstance();
  static NetWorkClient get instance => _getInstance();

  static NetWorkClient _getInstance() {
    if (_instance == null) {
      _instance = NetWorkClient._internal();
    }
    return _instance;
  }

  Dio _dio;
  CookieJar _cookieJar;

  /// 初始化网络请求配置信息
  NetWorkClient._internal() {
    //基本配置信息
    BaseOptions options = BaseOptions(
        receiveDataWhenStatusError: false,
        connectTimeout: NetworkConfig.timeOut,
        receiveTimeout: NetworkConfig.timeOut,
        sendTimeout: NetworkConfig.timeOut,
        contentType: Headers.formUrlEncodedContentType);
    //网络请求地址
    options.baseUrl = NetworkConfig.getServerUrl();
    _dio = Dio(options);
    _addInterceptors();
  }

  void resetUrl() {
    if (_dio != null) {
      _dio.options.baseUrl = NetworkConfig.getServerUrl();
    }
  }

  /// 添加拦截器
  void _addInterceptors() {
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));
    //请求添加默认属性
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      String extendPath = _extendPath(options);
      options.path = options.path + '?' + extendPath;
      print("请求Param: ${options.queryParameters.toString()}");
      //print('请求Path: '+options.path);
      return options; //continue
    }, onResponse: (Response response) {
      // Do something with response data
      if (response.headers.toString().contains(Element.JSESSION_ID)) {}
      //print(response.data);
      return response; // continue
    }, onError: (DioError e) {
      //不做处理，交由request处理，统一抛给UI层
      return e; //continue
    }));
  }

  /// 在请求地址追加用户信息，对'登录'请求做特殊处理
  String _extendPath(RequestOptions options) {
    var userId = (Global.userId == null) ? '' : Global.userId;
    //登录接口默认token为空
    var token = Global.token;
    if (token == null || options.path == NetServicePath.loginRequest) {
      token = '';
    }
    String extendPath =
        '${Element.RBQ}=${Element.XJSON}&${Element.UDF_USER_ID}=$userId&${Element.TOKEN}=$token';

    return extendPath;
  }

  Future request(String method, String path,
      {Map<String, dynamic> parameters,data}) async {
    try {
      if (parameters == null) {
        parameters = {};
      }
      _addBasicParameters(parameters);
      Response response = await _dio.request(path,
          queryParameters: parameters, data:data,options: Options(method: method));
      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  Future postForm(String path, FormData data) async {
    try {
      Map<String, dynamic> parameters = {};
      _addBasicParameters(parameters);
      Response response =
          await _dio.post(path, data: data, queryParameters: parameters);
      return response;
    } on DioError catch (e) {
      throw e;
    }
  }

  void _addBasicParameters(Map<String, dynamic> params) {
    params.addAll({Element.REQ: Element.XJSON});
    if (Global.userId == null) {
      return;
    }
    //获取登录状态
    params.addAll(
        {Element.UDF_USER_ID: Global.userId, Element.TOKEN: Global.token});
  }
}
