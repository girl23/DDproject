import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:lop/model/airline_photo.dart';
import 'package:lop/provide/image_list_state_dart.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/device_info_util.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../config/configure.dart';

class ImageSingleViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageSingleViewPageSate();
}

class _ImageSingleViewPageSate extends State<ImageSingleViewPage> {
  AirLinePhoto _image;

  bool get isUpload => _image.dbId == 0;

  @override
  void initState() {
    //_image = Provider.of<ImageListStateProvide>(context,listen: false).showPhoto;

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
      body: _imageViewWidget(),
    );
  }

  Widget _imageViewWidget() {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 10,
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Hero(
                    tag: _image.dbId,
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      imageProvider: _image.imageProvider,
                      enableRotation: true,
                    )),
              )),
          Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
                padding: EdgeInsets.all(10),
                child: isUpload
                    ? RaisedButton(
                        child: Text(
                          '后台上传',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _upLoadFileBackground();
                          Application.router.navigateTo(
                              context, Routes.taskPage,
                              transition: TransitionType.fadeIn);
                        },
                      )
                    : null,
              ))
        ],
      ),
      onTap: () {
        if (!isUpload) {
          Navigator.maybePop(context);
        }
        //Application.router.navigateTo(context, Routes.taskPage,transition: TransitionType.fadeIn);
      },
    );
  }

  void _upLoadFileBackground() async {
    //压缩图片
    File compressedFile = await FlutterNativeImage.compressImage(
        _image.file.path,
        quality: 50,
        percentage: 100);

    //int size = await uploadFile.length();
    DioManager().uploadMultiFile(NetServicePath.uploadJcFile, context,
        data: FormData.fromMap({
          "size": compressedFile.lengthSync(),
          "type": 'image/jpeg',
          "userid": Provider.of<UserViewModel>(context, listen: false).info.userId,
          "jcid": 90007183,
          "taskid": 231627,
          "file": await MultipartFile.fromFile(compressedFile.path,
              filename: 'upload.jpg'),
        }), success: (data) {
      print(data);
    }, error: (error) {
      print('error code = ${error.code} message = ${error.message}');
    });
  }
}
