import 'package:xml/xml.dart';

import 'jc_model.dart';

///
/// 工卡Header中的Note节点
///
class NoteModel extends JcLanguageModel {
  String tag = 'note';
  @override
  String toString() {
    return '<note>' + super.toString() + '</note>';
  }
}

///
/// 工卡Header中的caution节点
///
class CautionModel extends JcLanguageModel {
  String tag = 'caution';
  @override
  String toString() {
    return '<caution>' + super.toString() + '</caution>';
  }
}

///
/// 工卡Header中的explain节点
///
class ExplainModel extends JcListModel {
  String tag = 'explain';
  String titleCn;
  String titleEn;

  ExplainModel parseAttributes(List<XmlAttribute> attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      for (XmlAttribute attribute in attributes) {
        String name = attribute.name.toString();
        String value = attribute.value;
        if(name == 'titlecn'){
          this.titleCn = value;
        }else if(name == 'titleen'){
          this.titleEn = value;
        }
      }
    }
    return this;
  }

  @override
  String toString() {
    return '<explain>' + super.toString() + '</explain>';
  }
}
///
/// 工卡header中的explain节点下的<item/>
///
class ExplainItemModel extends JcLanguageModel{
  String tag = 'item';
  String path;
  String no;

  ExplainItemModel parseAttributes(List<XmlAttribute> attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      for (XmlAttribute attribute in attributes) {
        String name = attribute.name.toString();
        String value = attribute.value;
        if(name == 'path'){
          this.path = value;
        }else if(name == 'no'){
          this.no = value;
        }
      }
    }
    return this;
  }
}


///
/// 台湾标签
class TaiWanModel extends JcListModel {
  String tag = 'taiwan';
  @override
  String toString() {
    return '<taiwan>' + super.toString() + '</taiwan>';
  }
}

///
/// 工卡Header数据
///
class HeaderModel extends JcListModel {
  String tag = 'header';
  String acReg;
  String flightNo;
  String issueDate;
  String logo;
  String version;
  String rawData;//原始header节点数据

  HeaderModel parseAttributes(List<XmlAttribute> attributes) {
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
      case 'acreg':
        acReg = value;
        break;
      case 'flightno':
        flightNo = value;
        break;
      case 'issuedate':
        issueDate = value;
        break;
      case 'logo':
        logo = value;
        break;
      case 'version':
        version = value;
        break;
    }
  }

  @override
  String toString() {
    if(rawData != null){
      return rawData;
    }
    return '<header acreg="${acReg == null ? "" : acReg}" '
            'flightno="${flightNo == null ? "" : flightNo}"'
            'issuedate="${issueDate == null ? "" : issueDate}"'
            'logo="${logo == null ? "" : logo}"'
            'version="${version == null ? "" : version}"'
            '>' +
        super.toString() +
        '</header>';
  }
}
