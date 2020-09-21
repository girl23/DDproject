import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/model/airline_photo.dart';
import 'package:lop/model/user_model.dart';
import 'package:lop/provide/image_list_state_dart.dart';
import 'package:lop/provide/task_detail_state_provide.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/alert_dialog_util.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../config/configure.dart';

/// 上传图片的选择页面/删除页面

class ImageViewHomePage extends StatefulWidget {
  final String _taskId;
  final String _acrJcId;

  ImageViewHomePage(this._taskId, this._acrJcId);

  @override
  State<StatefulWidget> createState() =>
      _ImageViewHomePageState(_taskId, _acrJcId);
}

class _ImageViewHomePageState extends State<ImageViewHomePage> {
  UserModel _userInfo;
  bool _isUpload;
  String _taskId;
  String _acrJcId;

  _ImageViewHomePageState(this._taskId, this._acrJcId);

  @override
  void initState() {
    _taskId =
        Provider.of<TaskDetailStateProvide>(context, listen: false).taskId;
    _userInfo = Provider.of<UserViewModel>(context, listen: false).info;
    _isUpload =
        Provider.of<ImageListStateProvide>(context, listen: false).isUpload();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.fromHeight(DeviceInfoUtil.appBarHeight),
      ),
      backgroundColor: Colors.white,
      body: ImageViewWidget(),
      floatingActionButton: Selector<ImageListStateProvide, int>(
        selector: (context, imageState) => imageState.curPage,
        builder: (context, curPage, child) {
          return curPage >= 0
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(_isUpload ? '上传' : '删除'),
                  onPressed: () async {
                    _didImageClick(context, curPage);
                  },
                )
              : Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _didImageClick(BuildContext context, int index) {
    List<AirLinePhoto> imageList =
        Provider.of<ImageListStateProvide>(context, listen: false).imageList;

    if (_isUpload) {
      //后台上传全部
      _upLoadFileBackground(imageList);
      Navigator.of(context).pop();
    } else {
      //删除当前这一个
      AlertDialogUtil.openOkCancelAlertDialog(
          context, "确认删除此图片？", () => _deleteFile(imageList, imageList[index]));
    }
  }

  void _upLoadFileBackground(List<AirLinePhoto> imageList) async {
    bool completeSuccess = true;

    for (int i = 0; i < imageList.length; i++) {
      //压缩图片
      File compressedFile = await FlutterNativeImage.compressImage(
          imageList[i].file.path,
          quality: 50,
          percentage: 100);

      //int size = await uploadFile.length();
      DioManager().uploadMultiFile(NetServicePath.uploadJcFile, context,
          data: FormData.fromMap({
            "size": compressedFile.lengthSync(),
            "type": 'image/jpeg',
            "userid": _userInfo.userId,
            'taskid': _taskId,
            'jcid': _acrJcId,
            "file": await MultipartFile.fromFile(compressedFile.path,
                filename: 'upload.jpg'),
          }), success: (data) {
        print(data);
      }, error: (error) {
        ToastUtil.makeToast('上传失败：${error.message}',
            toastType: ToastType.ERROR);
        completeSuccess = false;
        print('error code = ${error.code} message = ${error.message}');
      });
    }
    if (completeSuccess) {
      ToastUtil.makeToast('图片上传成功');
    }
  }

  _deleteFile(List<AirLinePhoto> imageList, AirLinePhoto delImage) async {
    DioManager().request(httpMethod.GET, NetServicePath.delPhoto, context,
        params: {'userid': _userInfo.userId, 'blobid': delImage.dbId},
        success: (data) {
      if (data['result'] == 'success') {
        Provider.of<ImageListStateProvide>(context, listen: false)
            .removePhoto(delImage);
        if (imageList.length == 0) {
          Navigator.of(context).pop();
          //Application.router.pop(context);
        }
      } else {
        //提示
        AlertDialogUtil.openOkAlertDialog(
            context, "删除失败：" + data['info'], () {});
      }
    }, error: (error) {
      ToastUtil.makeToast('删除失败：${error.message}', toastType: ToastType.ERROR);
      print('error code = ${error.code} message = ${error.message}');
    });
  }
}

class ImageViewWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> {
  PageController _pageController;

  double _viewPortFraction = 0.9;

  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0, viewportFraction: _viewPortFraction)
          ..addListener(() {
            setState(() {
              _pageOffset = _pageController.page;
            });
          });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ImageListStateProvide, int>(
        selector: (context, selector) => selector.imageList.length,
        builder: (context, length, child) {
          return PageView.builder(
              physics: new AlwaysScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: length,
              onPageChanged: (int index) {
                Provider.of<ImageListStateProvide>(context, listen: false)
                    .changePage(index);
              },
              itemBuilder: (context, index) {
                double scale = max(_viewPortFraction,
                    (1 - (_pageOffset - index).abs()) + _viewPortFraction);

                double angle = (_pageOffset - index).abs();

                if (angle > 0.5) {
                  angle = 1 - angle;
                }

                return Container(
                  padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(5),
                    left: ScreenUtil().setWidth(5),
                    top: ScreenUtil().setHeight(100 - scale * 50),
                    bottom: ScreenUtil().setHeight(200),
                  ),
                  child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '${index + 1}/$length',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: KFont.fontSizeCommon_1,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 25,
                            child: Card(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(20)),
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              child: Image(
                                  image: Provider.of<ImageListStateProvide>(
                                          context,
                                          listen: false)
                                      .imageList[index]
                                      .imageProvider,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Image.asset(
                                        "assets/double_ring_loading_io.gif",
                                        scale: 1.5,
                                      ),
                                    );
                                  }),
                            ),
                            /*Positioned(
                    bottom: 60,
                    left: 20,
                    child: AnimatedOpacity(
                      opacity: angle == 0 ? 1 : 0,
                      duration: Duration(
                        milliseconds: 200,
                      ),
                      child: Text(
                        _list[index].name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  )*/
                          )
                        ],
                      )),
                );
              });
        });
  }
}
