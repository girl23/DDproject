import 'package:flutter/cupertino.dart';

import 'loading_view_controller.dart';
import 'loading_view_empty.dart';
import 'loading_view_error.dart';
import 'loading_view_loading.dart';

// ignore: must_be_immutable
class LoadingView extends StatefulWidget {
  LoadingState _initialState;
  final LoadingViewController controller;

  ///加载成功后，显示的页面
  final Widget contentWidget;

  ///传入的自定义布局，当state = custom时显示该控件
  final Widget customWidget;

  ///所有页面点击重新加载回调，如果单个页面单独设置了则会调用单独设置的回调
  final GestureTapCallback allRetryListener;

  ///空页面点击重新加载回调
  final GestureTapCallback emptyRetryListener;

  ///错误页面、或者网络异常点击重新加载回调
  final GestureTapCallback errorRetryListener;

  ///背景色
  final Color bgColor;

  LoadingView(
      {Key key,
      this.controller,
      LoadingState initialState,
      this.contentWidget,
      this.customWidget,
      this.allRetryListener,
      this.emptyRetryListener,
      this.errorRetryListener,
      this.bgColor})
      : assert(initialState == null || controller == null),
        super(key: key) {
    _initialState = initialState ?? controller.state;
  }

  @override
  State<StatefulWidget> createState() {
    return _LoadingViewState();
  }
}

class _LoadingViewState extends State<LoadingView> {
  LoadingState _state;

  @override
  void initState() {
    super.initState();
    _state = widget._initialState;
    if (widget.controller != null) {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    _state = widget.controller.state;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('LoadingView build');
    Widget subWidget;
    switch (_state) {
      case LoadingState.loading:
        subWidget = LoadingViewLoading();
        break;
      case LoadingState.success:
        subWidget = widget.contentWidget;
        break;
      case LoadingState.empty:
        subWidget = LoadingViewEmpty(widget.emptyRetryListener != null
            ? widget.emptyRetryListener
            : widget.allRetryListener);
        break;
      case LoadingState.error:
      case LoadingState.errorNetwork:
        subWidget = LoadingViewError(
            _state,
            widget.errorRetryListener != null
                ? widget.errorRetryListener
                : widget.allRetryListener);
        break;
      case LoadingState.custom:
        subWidget = widget.customWidget;
        break;
      default: //默认页面设置为错误页面，只有在 state 传入为 null 时候显示
        subWidget = LoadingViewError(
            LoadingState.error,
            widget.errorRetryListener != null
                ? widget.errorRetryListener
                : widget.allRetryListener);
        break;
    }
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
        child: subWidget,
        color: widget.bgColor ?? Color.fromARGB(255, 248, 248, 248),
      ),
    );
  }
}
