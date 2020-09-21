

import 'jc_model.dart';
import 'package:xml/xml.dart';

class CheckboxModel extends JcListModel{
  String tag = 'checkbox';
  String location;
  String dbId;

  CheckboxModel parseAttributes(List<XmlAttribute> attributes) {
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
    }
  }
}