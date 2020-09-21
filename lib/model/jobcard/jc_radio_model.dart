

import 'jc_model.dart';
import 'package:xml/xml.dart';

class RadioModel extends JcListModel{
  String tag = 'radio';
  String location;
  String dbId;
  String group;
  RadioModel parseAttributes(List<XmlAttribute> attributes) {
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
    if(key == 'location'){
      location = value;
    }else if(key == "dbid"){
      dbId = value;
    }else if(key == "group"){
      group = value;
    }
  }
}