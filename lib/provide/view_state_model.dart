import 'package:flutter/material.dart';
import 'package:lop/service/entity/error_entity.dart';
import 'package:lop/utils/toast_util.dart';
import 'view_state.dart';

class ViewStateModel with ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;
  /// 当前的页面状态,默认为busy,可在viewModel的构造方法中指定;
  ViewState _viewState;
  /// 根据状态构造
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.busy);
  ViewStateModel({ViewState viewState})
      : _viewState = viewState ?? ViewState.idle {
    debugPrint('ViewStateModel---constructor--->$runtimeType');
  }
  /// ViewState
  ViewState get viewState => _viewState;
  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
    notifyListeners();
  }
  /// ViewStateError
  ErrorEntity _viewStateError;
  ErrorEntity get viewStateError => _viewStateError;
  /// 不严谨写法
  /// get
  bool get isLoading => viewState == ViewState.loading;
  bool get isIdle => viewState == ViewState.idle;
  bool get isEmpty => viewState == ViewState.empty;
  bool get isError => viewState == ViewState.error;
  /// set
  void setIdle() {
    viewState = ViewState.idle;
  }
  void setLoading() {
    viewState = ViewState.loading;
  }
  void setEmpty() {
    viewState = ViewState.empty;
  }

  void setError(ErrorEntity entity) {
    _viewStateError = entity;
    viewState = ViewState.error;
    printErrorStack(entity.code, entity.message);
    onError(viewStateError);
  }
  void onError(ErrorEntity viewStateError) {}
  /// 显示错误消息
  showErrorMessage(context, {String message}) {
    if (viewStateError != null || message != null) {
      Future.microtask(() {
        ToastUtil.makeToast(message??viewStateError.message,toastType: ToastType.ERROR);
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    debugPrint('view_state_model dispose -->$runtimeType');
    super.dispose();
  }
}

/// [e]为错误类型 :可能为 Error , Exception ,String
/// [s]为堆栈信息
printErrorStack(e, s) {
  debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
  if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
}
