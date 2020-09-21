
import 'package:xml/xml.dart';

import 'jc_model.dart';


class ParagraphModel extends JcListModel{
  String tag = 'para';
  HorizontalAlignment hAlignment = HorizontalAlignment.left;


  ParagraphModel parseAttributes(List<XmlAttribute> attributes) {
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
    switch (key) {
      case 'align':
        _translateAlign(int.parse(value));
        break;
    }
  }

  void _translateAlign(int align) {
    if(align == 0){
      hAlignment = HorizontalAlignment.left;
    }else if(align == 1){
      hAlignment = HorizontalAlignment.center;
    }else if(align == 2){
      hAlignment = HorizontalAlignment.right;
    }

  }

  @override
  String toString() {
    String value = '<para align=';
    if(hAlignment == HorizontalAlignment.left){
      value += '"0"';
    }else if(hAlignment == HorizontalAlignment.center){
      value += '"1"';
    }else if(hAlignment == HorizontalAlignment.right){
      value += '"2"';
    }
    value += '>\r\n';
    value += '' +super.toString();
    value += "</para>";
    return value;
  }
}