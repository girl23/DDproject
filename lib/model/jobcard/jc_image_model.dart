import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

import 'jc_model.dart';

class ImageModel extends JcModel {
  String tag = 'image';
  String id;

  String dbId;
  int border = 0;
  int width = 0;
  int height = 0;
  double widthpercent = 0.0;
  double heightpercent = 0.0;
  Alignment alignment = Alignment.centerLeft;

  ImageModel parseAttributes(List<XmlAttribute> attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      for (XmlAttribute attribute in attributes) {
        String name = attribute.name.toString();
        String value = attribute.value;
        _setValue(name, value);
      }
    }
    return this;
  }

  void _setValue(String key, String value) {
    if (key == 'id') {
      id = value;
    } else if (key == 'dbid') {
      dbId = value;
    }else if (key == 'width') {
      width = int.tryParse(value);
    }else if (key == 'height') {
      height = int.tryParse(value);
    }else if (key == 'widthpercent') {
      widthpercent = double.tryParse(value.replaceAll("%", ""))/100;
    }else if (key == 'heightpercent') {
      heightpercent = double.tryParse(value.replaceAll("%", ""))/100;
    }else if (key == 'align') {
      _translateAlign(int.parse(value));
    }else if (key == 'border') {
      border = int.tryParse(value);
    }
  }
  void _translateAlign(int align) {
    if(align == 0){
      alignment = Alignment.centerLeft;
    }else if(align == 1){
      alignment = Alignment.center;
    }else if(align == 2){
      alignment = Alignment.centerRight;
    }

  }

  @override
  String toString() {
    return '<image id="$id" dbid="$dbId"/>';

  }
}
