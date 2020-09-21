import 'package:xml/xml.dart';

///
/// 工卡数据模型的基类
///
class JcModel{
  String tag='JcModel';
}

///
/// 拥有列表数据的JcModel
class JcListModel extends JcModel {
  String tag='JcListModel';
  List<JcModel> children;
  void addChild(JcModel jcModel) {
    if (jcModel == null) {
      throw Exception('节点数据不能为null');
    }
    if (children == null) {
      children = [];
    }
    children.add(jcModel);
  }

  @override
  String toString() {
    String value = '';
    if(children != null){
      for (JcModel jcModel in children) {
        value += (jcModel.toString() + '\r\n');
      }
    }
    return value;
  }
}

///
/// 工卡数据模型，语言标签元类
///
class JcLanguageMetaModel extends JcListModel {
  String tag='JcLanguageMetaModel';
}

///
/// 工卡数据模型，含有语言数据标签的基类
///
class JcLanguageModel extends JcModel {
  String tag='JcLanguageModel';
  JcLanguageMetaModel cnLanguageModel; //中文标签
  JcLanguageMetaModel enLanguageModel; //英文标签
  JcLanguageMetaModel mixLanguageModel; //混合标签

  @override
  String toString() {
    String value = '';
    if (cnLanguageModel != null) {
      value += ('<cn>\r\n' + cnLanguageModel.toString() + '\r\n</cn>\r\n');
    }
    if (enLanguageModel != null) {
      value += ('<en>\r\n' + enLanguageModel.toString() + '\r\n</en>\r\n');
    }
    if (mixLanguageModel != null) {
      value += ('<mix>\r\n' + mixLanguageModel.toString() + '\r\n</mix>\r\n');
    }
    return value;
  }
}

///
///适用性节点<eff/>
///
class EffModel extends JcListModel {
  String tag='eff';
  bool available = true; //适用性属性，默认true(适用)

  EffModel parseAttributes(List<XmlAttribute> attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      for (XmlAttribute attribute in attributes) {
        String name = attribute.name.toString();
        String value = attribute.value;
        if (name == 'available') {
          available = (value == 'true') ? true : false;
        }
      }
    }
    return this;
  }

  @override
  String toString() {
    return '<eff available="$available">' + super.toString() + '</eff>';
  }
}

///
///可隐藏节点<hide/>
///
class HideModel extends JcListModel {
  String tag = 'hide';
  @override
  String toString() {
    return '<hide>' + super.toString() + '</hide>';
  }
}

enum HorizontalAlignment { left, center, right }

enum VerticalAlignment { top, center, bottom }
