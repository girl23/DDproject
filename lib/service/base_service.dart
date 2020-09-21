
//static HttpManager http;
import 'package:lop/network/network_request.dart';

//
//static init() async {
//  http = HttpManager.getInstance();
//  await http.init();
//}

class BaseService{

  NetworkRequest networkRequest;

  BaseService(){
    print("BaseService init()");
    networkRequest = new NetworkRequest();
  }

}