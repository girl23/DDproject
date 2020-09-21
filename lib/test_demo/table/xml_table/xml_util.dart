import 'package:flutter/services.dart';
import '../data_model/numlitem_model.dart';

import 'package:xml/xml.dart' as xml;
import 'package:xml/src/xml/nodes/document.dart';
import 'package:xml/src/xml/utils/node_list.dart';
import 'package:xml/src/xml/utils/node_type.dart';
import 'package:xml/src/xml/nodes/element.dart';

import '../data_model/image_model.dart';
import '../data_model/para_model.dart';
import '../data_model/table_body_model.dart';
import '../data_model/table_cell_model.dart';
import '../data_model/table_header_model.dart';
import '../data_model/table_model.dart';
import '../data_model/table_row_model.dart';
import '../data_model/text_model.dart';
import '../data_model/title_model.dart';
import '../data_model/unlitem_model.dart';

class XmlParseUtil{


  Future<List> parseXmlFile(String fileName) async{
    int timeLoadStart = new DateTime.now().millisecondsSinceEpoch;
    String valueStr = await rootBundle.loadString(fileName);
    int timeStart = new DateTime.now().millisecondsSinceEpoch;
    List dataList = parseXml(valueStr);
    int timeEnd = new DateTime.now().millisecondsSinceEpoch;
//    print("加载文件耗时：${timeStart - timeLoadStart},解析xml，耗时 ${timeEnd - timeStart}");
    return dataList;
  }

  List parseXml(String source) {
    String value = source;
    value = value.replaceAll("\r\n", "");
    value = value.replaceAll("\t", "");
    XmlDocument xmlDocument = xml.parse(value);
    XmlNodeList<xml.XmlNode> children = xmlDocument.children;
    XmlElement duNode = children.first;
    if (duNode.name.toString() == 'du') {
      print("parse tree du");
    }
    XmlNodeList<xml.XmlNode> duChildren = duNode.children;
    return parseXmlChildren(duChildren);
  }

  List parseXmlChildren(XmlNodeList<xml.XmlNode> children){
    List dataList = [];
    for (xml.XmlNode node in children) {
      dynamic model = parseXmlNode(node);
      if(model != null){
        dataList.add(model);
      }
    }
    return dataList;
  }

  /// 解析通用的数据
  dynamic parseXmlNode(xml.XmlNode node){
    dynamic dataModel;
    if(node.nodeType == XmlNodeType.ELEMENT){
      XmlElement xmlElement = node;
      String name = xmlElement.name.toString();
      if (name == 'title') {
        dataModel = this.parseTitle(node);
      } else if (name == 'para') {
        dataModel = this.parsePara(node);
      } else if (name == 'table') {
        int timeStart = new DateTime.now().millisecondsSinceEpoch;
        dataModel = this.parseTable(node);
        int timeEnd = new DateTime.now().millisecondsSinceEpoch;
//        print("解析table标签，耗时 ${timeEnd - timeStart}");
      } else if (name == 'text'){
        dataModel = this.parseText(node);
      } else if (name == 'unlitem'){
        dataModel = this.parseUnlItem(node);
      } else if (name == 'image'){
        dataModel = this.parseImageModel(node);
      } else if(name == 'numlitem'){
        dataModel = this.parseNumlItem(node);
      }
    }
    return dataModel;
  }

  ///解析标题title
  TitleModel parseTitle(xml.XmlNode node) {
    print('解析title节点');
    TitleModel titleModel = TitleModel();
    XmlElement element = node;
    if (node.children.length == 1) {
      XmlNodeList<xml.XmlNode> list = element.children;
      xml.XmlNode xmlNode = list.first;
      if (xmlNode.nodeType == XmlNodeType.TEXT) {
        xml.XmlText xmlText = xmlNode;
        titleModel.title = xmlText.text;
      }
    }
    return titleModel;
  }

  ///解析段落para
  ParaModel parsePara(xml.XmlNode node) {
    ParaModel paraModel = ParaModel();
    XmlElement element = node;
    XmlNodeList<xml.XmlNode> list = element.children;
    for (xml.XmlNode childNode in list) {
      dynamic model = parseXmlNode(childNode);
      if(model != null)
      paraModel.children.add(model);
    }
    return paraModel;
  }

  ///解析文本text
  TextModel parseText(xml.XmlNode node) {
    XmlNodeList<xml.XmlNode> list = node.children;
    if (list.length != 1) {
      return null;
    }
    xml.XmlNode child = list.first;
    TextModel textModel;
    if (child.nodeType == XmlNodeType.ELEMENT) {
      XmlElement childElement = child;
      textModel = parseText(childElement);
      if (childElement.name.toString() == 'b') {
        textModel.isBold = true;
      }else if(childElement.name.toString() == 'bu'){
        textModel.isBu = true;
      }
    } else if (child.nodeType == XmlNodeType.TEXT) {
      xml.XmlText xmlText = child;
      textModel = TextModel(xmlText.text);
    }
    return textModel;
  }

  NumlItemModel parseNumlItem(xml.XmlNode node){
    NumlItemModel numlItemModel = NumlItemModel();
    ///解析属性
    if(node.attributes.isNotEmpty){
      List<xml.XmlAttribute> attributes = node.attributes;
      for(xml.XmlAttribute attribute in attributes){
        String name = attribute.name.toString();
        if('linestartserialid' == name){
          numlItemModel.lineStartSerialId = attribute.value;
        }else if('linestartsign' == name){
          numlItemModel.lineStartSign = attribute.value;
        }else if('tag' == name){
          numlItemModel.tag = attribute.value;
        }else{
          print("非法属性<${name}>进入<unlitem>标签中");
        }
      }
    }

    ///解析內容
    if(node.children.isNotEmpty){
      List<xml.XmlNode> xmlNodes = node.children;
      for(xml.XmlNode xmlNode in xmlNodes){
        if (xmlNode.nodeType == XmlNodeType.TEXT) {
          xml.XmlText xmlText = xmlNode;
          numlItemModel.text = xmlText.text;
        }
      }
    }
    return numlItemModel;
  }

  ///解析unlitem节点数据
  UnlItemModel parseUnlItem(xml.XmlNode node){
    UnlItemModel unlItemModel = UnlItemModel();
    ///解析属性
    if(node.attributes.isNotEmpty){
      List<xml.XmlAttribute> attributes = node.attributes;
      for(xml.XmlAttribute attribute in attributes){
        String name = attribute.name.toString();
        if('linestartserialid' == name){
          unlItemModel.lineStartSerialId = attribute.value;
        }else if('linestartsign' == name){
          unlItemModel.lineStartSign = attribute.value;
        }else{
          print("非法属性<${name}>进入<unlitem>标签中");
        }
      }
    }
    ///解析內容
    if(node.children.isNotEmpty){
      List<xml.XmlNode> xmlNodes = node.children;
      for(xml.XmlNode xmlNode in xmlNodes){
        if (xmlNode.nodeType == XmlNodeType.TEXT) {
          xml.XmlText xmlText = xmlNode;
          unlItemModel.text = xmlText.text;
        }
      }
    }
    return unlItemModel;
  }

  ///图片只有属性
  ImageModel parseImageModel(xml.XmlNode node){
    if(node.attributes.isNotEmpty){
      ImageModel imageModel = ImageModel();
      List<xml.XmlAttribute> attributes = node.attributes;
      for(xml.XmlAttribute attribute in attributes){
        String name = attribute.name.toString();
        if('align' == name){
          imageModel.align = this.parseIntValue(attribute.value);
        }else if('id' == name){
          imageModel.id = this.parseIntValue(attribute.value);
        }else if('src' == name){
          if(attribute.value == null || attribute.value == ''){
            print('属性值不完整<image>的src属性');
          } else {
            imageModel.src = attribute.value;
          }
        }else{
          print("非法属性<${name}>进入<image>标签中");
        }
      }
      return imageModel;
    }else{
      return null;
    }
  }

  ///解析表格table
  ///
  /// 标准子节点：thead和tbody；
  /// 可以没有thead和tbody，只有tr标签，解析过程中增加tbody，将tr放入tbody中
  TableModel parseTable(xml.XmlNode node){
    XmlNodeList<xml.XmlNode> list = node.children;
    ///说明
    ///
    /// table有两种模式：
    /// 1、含有tbody模式，这种表示table的下一级标签只允许出现thead或者tbody；
    /// 2、含有tr模式，这种table的下一级标签只允许出现tr标签。
    if(list.isNotEmpty){
      xml.XmlNode firstNode = list.first;
      if(firstNode.nodeType == XmlNodeType.ELEMENT){
        ///判断类型
        int type = 0;
        XmlElement element = firstNode;
        String name = element.name.toString();
        if('thead' == name || 'tbody' == name){
          type = 1;
        }else if('tr' == name){
          type = 2;
        }else{
          print("非法标签<${name}>进入<table>标签中");
          return null;
        }
        ///根据类型解析
        TableModel tableModel = TableModel();
        if(type == 1){
          for(xml.XmlNode xmlNode in list){
            XmlElement xElement = xmlNode;
            String eName = xElement.name.toString();
            if('thead' == eName){
              tableModel.headerModel = parseTableHeader(xElement);
            }else if('tbody' == eName){
              tableModel.bodyModel = parseTableBody(xElement.children);
            }
          }
        }else if(type == 2){
          tableModel.bodyModel = parseTableBody(list);
        }
        return tableModel;
      }else{
        print("标签类型进入<table>标签中，${firstNode.nodeType}");
        return null;
      }
    }else {
      print("标签<table>下无任何数据");
      return null;
    }
  }

  ///解析table的head
  TableHeaderModel parseTableHeader(XmlElement element){
    if(element.children.isEmpty){
      return null;
    }
    return TableHeaderModel();
  }

  ///解析表格的tablebody
  ///
  /// trList是table中的所有tr数据，需要计算每个td的位置信息
  TableBodyModel parseTableBody(List<xml.XmlNode> trList){
    TableBodyModel tableBodyModel = TableBodyModel();
    int rowLength = trList.length;///行的个数
    ///
    List<List<int>> matrix;
    int columnLength = 0;
    for(int rowIndex = 0; rowIndex < rowLength; rowIndex ++){
      ///转换td
      TableRowModel tableRowModel= TableRowModel();
      tableRowModel.row = rowIndex;
      xml.XmlNode rowNode = trList[rowIndex];
      List<xml.XmlNode> tdList = rowNode.children;
      for(int tdIndex = 0; tdIndex < tdList.length; tdIndex++){
        xml.XmlNode tdNode = tdList[tdIndex];
        TableCellModel tableCellModel = parseTableCellModel(tdNode);
        tableRowModel.children.add(tableCellModel);
        if(rowIndex == 0){
          columnLength += tableCellModel.colspan;
        }
      }
      ///创建原始矩阵，rowLength x columnLength，每个值默认是-1
      if(matrix == null){
        tableBodyModel.totalCol = columnLength;
        tableBodyModel.totalRow = rowLength;
        matrix= List.generate(rowLength, (int index)=>(List.generate(columnLength, (int index) => -1)));
      }
      ///获取当前行的矩阵
      List<int> curTrMatrix = matrix[rowIndex];
      for(int i = 0,j = 0; (i < columnLength) & (j < tdList.length); i++){
        //i：列号；j：td节点在当前行的编号
        int tdNo = curTrMatrix[i];
        if(tdNo >= 0){//表示这一列已经被占用
          continue;
        }else{
          TableCellModel tableCellModel = tableRowModel.children[j];
          tableCellModel.row = rowIndex;
          tableCellModel.column = i;
          ///将矩阵中此td所占的位置都标注,标记为行号+列号
          int tag = (rowIndex<<8) + i;
          ///根据这个控件的跨度，将跨度范围内的所有矩阵点都标记
          for(int m = rowIndex; m < (rowIndex+tableCellModel.rowspan);m++){
            List<int> trMatrix = matrix[m];
            for(int n = i; n < (i+tableCellModel.colspan);n++){
              trMatrix[n] = tag;
            }
          }
          j++;
        }
      }
      tableBodyModel.children.add(tableRowModel);
    }



//
//    XmlNodeList<xml.XmlNode> trList = element.children;
//    if(trList.isNotEmpty){
//      for(xml.XmlNode trNode in trList){
//        XmlElement element = trNode;
//        String name = element.name.toString();
//        if('tr' == name){
//          TableRowModel tableRowModel = parseTableRow(trNode);
//          tableBodyModel.children.add(tableRowModel);
//        }else{
//          print("非法标签${name}进入<table><tbody>标签中");
//        }
//      }
//    }

    return tableBodyModel;
  }


  ///解析tr标签
  ///
  /// tr标签只允许存在tr标签
  TableRowModel parseTableRow(XmlElement element){
    XmlNodeList<xml.XmlNode> tdList = element.children;
    if(tdList.isEmpty){
      return null;
    }
    TableRowModel tableRowModel= TableRowModel();
    for(xml.XmlNode tdNode in tdList){
      tableRowModel.children.add(parseTableCellModel(tdNode));
    }
    return tableRowModel;
  }
  ///解析td标签
  ///
  ///td标签中可以有任何不同的标签，交给通用解析
  TableCellModel parseTableCellModel(xml.XmlNode tdNode){
    if(tdNode.nodeType == XmlNodeType.ELEMENT){
      XmlElement tdElement = tdNode;

      TableCellModel tableCellModel = TableCellModel();
      ///解析td的属性
      XmlNodeList<xml.XmlAttribute> attributes = tdElement.attributes;
      for(xml.XmlAttribute attribute in attributes){
        String attributeName = attribute.name.toString();
        if('rowspan' == attributeName){
          int rowspan = parseIntValue(attribute.value);
          if(rowspan > 0){
            tableCellModel.rowspan = rowspan;
          }else{
            print('rowspan用了非法数值${attribute.value}');
          }
        }else if('colspan' == attributeName){
          int colspan = parseIntValue(attribute.value);
          if(colspan > 0){
            tableCellModel.colspan = colspan;
          }else{
            print('colspan用了非法数值${attribute.value}');
          }
        }else if('valign' == attributeName){
          int valign = parseIntValue(attribute.value);
          if(valign > 0){
            tableCellModel.valign = valign;
          }else{
            print('valign用了非法数值${attribute.value}');
          }
        }else if('width' == attributeName){
          String value = attribute.value;
          if(value.endsWith('%')){
            tableCellModel.isPercent = true;
            tableCellModel.width = parseIntValue(value.substring(0,value.length-1)).toDouble();
          }else{
            tableCellModel.isPercent = false;
            tableCellModel.width = parseIntValue(value).toDouble();
          }
        }else if('border' == attributeName){
          tableCellModel.border = parseIntValue(attribute.value);
        }
      }
      ///解析子节点
      XmlNodeList<xml.XmlNode> tdChildren = tdElement.children;
      if(tdChildren.isNotEmpty){
        for(xml.XmlNode node in tdChildren){
          //解析td节点中的子节点
          if(node.nodeType == XmlNodeType.ELEMENT){
            tableCellModel.children.add(parseXmlNode(node));
          }
        }
      }
      return tableCellModel;
    }
    return null;
  }

  int parseIntValue(String value){
    if(value == null || '' == value){
      return 0;
    }else{
      return int.parse(value);
    }
  }

}