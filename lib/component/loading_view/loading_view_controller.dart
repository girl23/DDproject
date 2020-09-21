import 'package:flutter/cupertino.dart';

enum LoadingState {
  ///加载中，显示Loading页面
  loading,

  ///加载成功，显示传入的contentWidget
  success,

  ///显示空数据页面
  empty,

  ///显示错误页面
  error,

  ///显示网络错误页面
  errorNetwork,

  ///显示customWidget
  custom
}

class LoadingViewValue {
  final LoadingState state;

  LoadingViewValue(this.state) : assert(state != null);
}

class LoadingViewController extends ValueNotifier<LoadingViewValue> {
  LoadingViewController({LoadingState state}) : super(state == null?LoadingViewValue(LoadingState.loading):LoadingViewValue(LoadingState.loading));


  LoadingState get state => value.state;

  set state(LoadingState state){
    if(value.state != state){
      value = LoadingViewValue(state);
    }
  }
}
