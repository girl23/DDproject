


import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:lop/config/configure.dart';
import 'package:lop/config/global.dart';
import 'package:lop/config/package_config.dart';
import 'package:lop/network/network_config.dart';

class AirLinePhoto{

  int _dbId = 0;

  ImageProvider _imageProvider;

  File _file;

  int get dbId => _dbId;


  ImageProvider get imageProvider{
    if(_imageProvider != null){
      return _imageProvider;
    }

    if(_file != null){
      return FileImage(_file);
    }

    if(_dbId > 0){
      return NetworkImage('${NetworkConfig.getServerUrl()}${NetServicePath.downloadPhoto}?blobid=$_dbId');

    }
    //返回本地空图放在asset下，还未找到合适的图；
    return null;
  }
  File get file => _file;

  AirLinePhoto(this._dbId);

  AirLinePhoto.formFile(this._file);


}