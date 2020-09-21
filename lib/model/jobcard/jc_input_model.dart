import 'package:xml/xml.dart';

import 'jc_model.dart';

class InputModel extends JcModel {
  String tag = 'input';
  int length;
  String location;
  int max;
  int min;
  String path;

  InputModel parseAttributes(List<XmlAttribute> attributes) {
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
      case 'length':
        length = int.parse(value);
        break;
      case 'location':
        location = value;
        break;
      case 'min':
        min = int.parse(value);
        break;
      case 'max':
        max = int.parse(value);
        break;
      case 'path':
        path = value;
        break;
    }
  }
  @override
  String toString() {
   return '<input length="$length" location="$location" max="$max" min="$min"/>';

  }
}
