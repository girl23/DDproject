
import '../service/entity/error_entity.dart';

/// 网络请求统一响应数据处理后的返回
class NetworkResponse<T>{
  /// 请求是否成功，包括数据解析成功
  bool isSuccess;
  /// 错误状态内容：网络、解析数据
  ErrorEntity errorEntity;
  /// model数据
  T data;
  /// model的列表数据
  List<T> dataList;

  NetworkResponse({this.isSuccess, this.errorEntity, this.data, this.dataList});


}