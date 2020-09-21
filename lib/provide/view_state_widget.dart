import 'package:flutter/material.dart';
import 'package:lop/service/entity/error_entity.dart';
import '../utils/Icon_util.dart';
import '../generated/l10n.dart';

///加载中
class ViewStateLoadingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(),);
  }
}
/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget image;

  ViewStateWidget(
      {Key key,
        this.image,
        this.title,
        this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.subhead.copyWith(color: Colors.grey);
    var messageStyle = titleStyle.copyWith(
        color: titleStyle.color.withOpacity(0.7), fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image ?? Icon(IconUtil.pageError, size: 80, color: Colors.grey[500]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, minHeight: 150),
                child: SingleChildScrollView(
                  child: Text(message ?? '', style: messageStyle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  final ErrorEntity error;
  final String message;
  final Widget image;

  const ViewStateErrorWidget({
    Key key,
    @required this.error,
    this.image,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage;
    var defaultTitle;
    switch (error.code) {
      case -1:
        defaultImage = Transform.translate(
          offset: Offset(-50, 0),
          child: const Icon(IconUtil.pageNetworkError,
              size: 100, color: Colors.grey),
        );
        defaultTitle = S.of(context).viewStateMessageNetworkError;
        // errorMessage = ''; // 网络异常移除message提示
        break;
      default:
        defaultImage =
        const Icon(IconUtil.pageError, size: 100, color: Colors.grey);
        defaultTitle = S.of(context).viewStateMessageError;
        break;
    }

    return ViewStateWidget(
      image: image ?? defaultImage,
      message: message ?? defaultTitle
    );
  }
}
/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String message;
  final Widget image;

  const ViewStateEmptyWidget(
      {Key key,
        this.image,
        this.message,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      image: image ??
          const Icon(IconUtil.pageEmpty, size: 100, color: Colors.grey),
      title: message ?? S.of(context).viewStateMessageEmpty,
    );
  }
}