import '../config/package_config.dart';

class NetworkConfig{



  static String testServerUrl = 'http://wechattest.ameco.com.cn:8090/xmis/';//服务器测试地址

  static String productionServerUrl = 'http://wechattest.ameco.com.cn:8090/xmis/';//服务器生产环境地址

  static int timeOut = 2000;//网络请求超时时间：连接、发送消息、接收消息



  //测试地址
  static const debugUrl = {
    //114测试服务
    "testServer":"http://wechattest.ameco.com.cn:8090/xmis/",
    //云测试服务
    "testServer2":"http://lopapp.ameco.com.cn:80/xmis/"
  };

  //生成地址
  static const releaseUrl = {
    "releaseServer01":"http://wechattest.ameco.com.cn:8090/xmis/",
    "releaseServer02":"http://wechattest.ameco.com.cn:8090/xmis/",
    "guiyangServer":"http://wechattest.ameco.com.cn:8090/xmis/",
  };

  static String getServerUrl(){
    if(PackageConfig.isProduction){
      return NetworkConfig.productionServerUrl;
    }else{
      return NetworkConfig.testServerUrl;
    }
  }
}