import 'package:xml/xml.dart';

import 'jc_model.dart';

///
/// 工卡的body模型
///
class BodyModel extends JcListModel {
  String tag = 'body';
  @override
  String toString() {
    return '<body>' + super.toString() + '</body>';
  }
}

///
/// 模块、工序的数据基类
///
class ModuleProcedureBaseModel extends JcListModel {
  String titleCn;
  String titleEn;
  String no;
  String path;
  String rawData;

  ModuleProcedureBaseModel parseAttributes(List<XmlAttribute> attributes) {
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
      case 'titlecn':
        titleCn = value;
        break;
      case 'titleen':
        titleEn = value;
        break;
      case 'no':
        no = value;
        break;
      case 'path':
        path = value;
        break;
    }
  }

  @override
  String toString() {
    if(rawData != null){
      return rawData;
    }
    return 'cn="$titleCn" en="$titleEn" no="$no" path="$path">' + super.toString();
  }
}

///
/// 工卡的模块数据模型
///
class ModuleModel extends ModuleProcedureBaseModel {
  String tag = 'model';
  @override
  String toString() {
    return '<model>' + super.toString() + '</model>';
  }
}

///
/// 工序的数据模型
///
class ProcedureModel extends ModuleProcedureBaseModel {
  String tag = 'pos';
  ///所属的模块 index
  int modelIndex;

  @override
  String toString() {
    return '<pos>' + super.toString() + '</pos>';
  }
}

///
/// 工序的条目模型
///
class ProItemModel extends JcLanguageModel {
  String tag = 'item';
  String no;
  String path;
  bool available = true; //是否适用
  bool appendix = false; //是否有附件
  bool photo = false; //是否需要上传图片
  String trade; //适用的工种
  String credential; //适用的资质要求

  ProItemModel parseAttributes(List<XmlAttribute> attributes) {
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
      case 'no':
        no = value;
        break;
      case 'path':
        path = value;
        break;
      case 'available':
        available = (value == 'true') ? true : false;
        break;
      case 'appendix':
        appendix = (value == 'true') ? true : false;
        break;
      case 'photo':
        photo = (value == 'true') ? true : false;
        break;
      case 'trade':
        trade = value;
        break;
      case 'credential':
        credential = value;
        break;
    }
  }

  @override
  String toString() {
    return '<item no="$no" path="$path" available="$available" appendix="$appendix"'
            'photo="$photo" trade="${trade == null ? "" : trade}"'
            ' credential="${credential == null ? "" : credential}"' +
        super.toString() +
        '</pos>';
  }
}
