import 'package:flutter/cupertino.dart';
import 'package:lop/component/sheet_widget.dart';
import 'package:lop/component/sheet_widget_item.dart';
import 'package:lop/component/xy_dialog_widget.dart';
import 'package:lop/model/airline_photo.dart';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/Media.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/model/airline_photo.dart';
import 'package:lop/provide/image_list_state_dart.dart';
import 'package:lop/router/application.dart';
import 'package:lop/router/routes.dart';
import 'package:lop/service/dio_manager.dart';
import 'package:lop/style/color.dart';
import 'package:lop/style/font.dart';
import 'package:lop/style/size.dart';
import 'package:lop/utils/translations.dart';
import 'package:lop/utils/alert_dialog_util.dart';
import 'package:lop/utils/toast_util.dart';
import 'package:lop/utils/xy_dialog_util.dart';
import 'package:lop/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';
class ImageListStateProvide with ChangeNotifier{

  List<AirLinePhoto> _list = new List();
  int _curPage = 0;
  int get curPage => _curPage;

  changePage(int page){
    _curPage = page;
    notifyListeners();
  }



  bool  isUpload(){
    if(_list.length == 0){
      return true;
    }

    if(_list[0].dbId > 0){
      return false;
    }
    return true;
  }

  List<AirLinePhoto> get imageList => _list;

  removePhoto(AirLinePhoto airLinePhoto){
    _list.remove(airLinePhoto);
    notifyListeners();
  }

  add(AirLinePhoto airLinePhoto){
    _list.add(airLinePhoto);
  }

  clear(){
    _list.clear();
    notifyListeners();
  }


  static void uploadPhoto(BuildContext context,String taskId,String acrJcId){


    SheetWidget sw = SheetWidget(context,
      KFont.fontSizeSheetItem,
      itemHeight: KSize.sheetItemHeight,
      cancelTitle: Translations.of(context).text('cancel'),
      children: <SheetWidgetItem>[
        //拍照
        SheetWidgetItem(Translations.of(context).text('tast_detail_page_camera'), () async {
          await ImagePickers.openCamera().then((Media media) {
            /// media 包含照片路径信息 Include photo path information
            Provider.of<ImageListStateProvide>(context, listen: false)
                .clear();
            Provider.of<ImageListStateProvide>(context, listen: false)
                .add(AirLinePhoto.formFile(File(media.path)));
            Application.router.navigateTo(context, "image/$taskId/$acrJcId", transition: TransitionType.fadeIn);
          });
        },textColor: KColor.sheetItemColor),
        //相册
        SheetWidgetItem(Translations.of(context).text('tast_detail_page_album'), () async {
          List<Media> _listImagePaths = await ImagePickers.pickerPaths(
              galleryMode: GalleryMode.image,
              selectCount: 9,
              showCamera: false,
              compressSize: 500,
              uiConfig:
              UIConfig(uiThemeColor: Theme
                  .of(context)
                  .primaryColor));

          Provider.of<ImageListStateProvide>(context, listen: false)
              .clear();
          for (int i = 0; i < _listImagePaths.length; i++) {
            Provider.of<ImageListStateProvide>(context, listen: false)
                .add(
                AirLinePhoto.formFile(File(_listImagePaths[i].path)));
          }
          Application.router.navigateTo(context, "image/$taskId/$acrJcId",
              transition: TransitionType.fadeIn);
        },textColor: KColor.sheetItemColor),

      ],

    );
    sw.showSheet();
//    showDialog<bool>(
//      context: context,
//      barrierDismissible: true,
//      builder: (context) {
//        return new AlertDialog(
//          title: new Text(Translations.of(context).text('tast_detail_page_upload_page_title')),
//          content: new Text(Translations.of(context).text('tast_detail_page_upload_page_content')),
//          actions: <Widget>[
//            FlatButton(
//              onPressed: () async {
//                // var image = await imagePicker.ImagePicker.pickImage(source: imagePicker.ImageSource.camera);
//                await ImagePickers.openCamera().then((Media media) {
//                  /// media 包含照片路径信息 Include photo path information
//                  Provider.of<ImageListStateProvide>(context, listen: false)
//                      .clear();
//                  Provider.of<ImageListStateProvide>(context, listen: false)
//                      .add(AirLinePhoto.formFile(File(media.path)));
//                  Application.router.navigateTo(context, "image/$taskId/$acrJcId",
//                      replace: true, transition: TransitionType.fadeIn);
//                });
//              },
//              child: Text(Translations.of(context).text('tast_detail_page_camera')),
//            ),
//            FlatButton(
//              onPressed: () async {
//                List<Media> _listImagePaths = await ImagePickers.pickerPaths(
//                    galleryMode: GalleryMode.image,
//                    selectCount: 9,
//                    showCamera: false,
//                    compressSize: 500,
//                    uiConfig:
//                    UIConfig(uiThemeColor: Theme
//                        .of(context)
//                        .primaryColor));
//
//                Provider.of<ImageListStateProvide>(context, listen: false)
//                    .clear();
//                for (int i = 0; i < _listImagePaths.length; i++) {
//                  Provider.of<ImageListStateProvide>(context, listen: false)
//                      .add(
//                      AirLinePhoto.formFile(File(_listImagePaths[i].path)));
//                }
//                Application.router.navigateTo(context, "image/$taskId/$acrJcId",
//                    replace: true, transition: TransitionType.fadeIn);
//              },
//              child:  Text(Translations.of(context).text('tast_detail_page_album')),
//            ),
//            FlatButton(
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//              child: Text(Translations.of(context).text('cancel')),
//            ),
//          ],
//        );
//      },
//    );
  }

  static void downloadPhoto(BuildContext context,String taskId,String acrJcId, bool isCheck) {
    Provider.of<ImageListStateProvide>(context, listen: false)
        .clear();
    //查看上传图片
    DioManager()
        .request(httpMethod.GET, NetServicePath.getPhotoInfo, context, params: {
      'taskid': taskId,
      'jcid': acrJcId,
      'userid':
      Provider.of<UserViewModel>(context, listen: false).info.userId,
      'ischeck':isCheck.toString()
    }, success: (data) {
      print(data);
      if (data != null && data['result'] == 'success') {
        var dataId = data['blobid'].toString().split(',');
        for (int i = 0; i < dataId.length; i++) {
          Provider.of<ImageListStateProvide>(context, listen: false)
              .add(AirLinePhoto(int.parse(dataId[i])));
        }
        Application.router.navigateTo(context, "image/$taskId/$acrJcId",
            replace: false, transition: TransitionType.fadeIn);
      } else {
        //提示未上传图片
        AlertDialogUtil.openOkAlertDialog(context,
            "未上传图片！",(){});
      }
    });

  }

}