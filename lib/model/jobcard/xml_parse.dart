import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import 'jc_body_model.dart';
import 'jc_checkbox_model.dart';
import 'jc_figure_model.dart';
import 'jc_header_model.dart';
import 'jc_image_model.dart';
import 'jc_input_model.dart';
import 'jc_model.dart';
import 'jc_para_model.dart';
import 'jc_radio_model.dart';
import 'jc_table_model.dart';
import 'jc_text_model.dart';
import 'job_card_model.dart';

class XMLParse {
  Future<JobCardModel> parseXmlFile(String fileName) async {
//    int timeLoadStart = new DateTime.now().millisecondsSinceEpoch;
    String valueStr = await rootBundle.loadString(fileName);
    return xmlParseHoleJobCard(valueStr, needRawStr: true);
  }

  Future<JobCardModel> xmlParseHoleJobCard(String xmlStr,
      {bool needRawStr = false}) async {
    if (xmlStr == null) return null;
    JobCardModel jobCardModel;
    String resource = await formatString(xmlStr);
    XmlDocument xmlDocument = parse(resource);
    if (xmlDocument == null || xmlDocument.document.children.isEmpty) {
      return null;
    }
    XmlElement jobCardElement;
    for (XmlNode xmlNode in xmlDocument.children) {
      if (xmlNode is XmlElement) {
        XmlElement element = xmlNode;
        if (element.name.toString() == 'jobcard') {
          jobCardElement = element;
          break;
        }
      }
    }

    ///解析工卡内容部分
    jobCardModel = JobCardModel();
    if (jobCardElement != null && jobCardElement.children.isNotEmpty) {
      //三个块：header、body、figure
      for (XmlNode node in jobCardElement.children) {
        if (node is XmlElement) {
          XmlElement element = node;
          String name = element.name.toString();
          if (name == 'header') {
            jobCardModel.headerModel =
                _parseXmlHeader(element, needRawStr: needRawStr);
          } else if (name == 'body') {
            jobCardModel.bodyModel =
                _parseXmlBody(element, needRawStr: needRawStr);
          } else if (name == 'figure') {
            jobCardModel.figureModel =
                _parseFigureModel(element, needRawStr: needRawStr);
          }
        }
      }
    }
    print('***** 解析完成');
    return jobCardModel;
  }

  ///
  /// 解析工卡的header数据(直接通过原始的header字符串)
  ///
  HeaderModel parseXmlHeader(String headerStr) {
    XmlDocument xmlDocument = parse(headerStr);
    XmlElement rootElement = xmlDocument.firstChild;
    return _parseXmlHeader(rootElement);
  }

  ///
  /// 解析工卡的header数据
  ///
  HeaderModel _parseXmlHeader(XmlElement headerElement,
      {bool needRawStr = false}) {
    HeaderModel headerModel =
        HeaderModel().parseAttributes(headerElement.attributes);
    if (needRawStr) {
      headerModel.rawData = headerElement.toString();
    }
    if (headerElement.children != null && headerElement.children.isNotEmpty) {
      for (XmlNode node in headerElement.children) {
        if (node is XmlElement) {
          XmlElement element = node;
          JcModel jcModel;
          String name = element.name.toString();
          switch (name) {
            case 'note':
              jcModel = _parseLanguageModel(NoteModel(), node);
              break;
            case 'caution':
              jcModel = _parseLanguageModel(CautionModel(), node);
              break;
            case 'explain':
              ExplainModel explainModel =
                  ExplainModel().parseAttributes(node.attributes);
              jcModel = _parseJcHeaderExplain(node.children, explainModel);
              break;
            case 'taiwan':
              jcModel = _parseJcListModel(node.children, TaiWanModel());
              break;
            default:
              jcModel = _parseAllElement(element); //解析未识别的节点
              break;
          } //end_switch
          if (jcModel != null) {
            headerModel.addChild(jcModel);
          }
        } //end_if-(node is XmlElement)
      } //end_for
    } //end_if
    return headerModel;
  }

  ///
  /// 解析工卡的body节点
  ///
  /// <body/>节点下有节点<model/>模块(或者未识别的)
  ///
  BodyModel _parseXmlBody(XmlElement bodyElement, {bool needRawStr = false}) {
    BodyModel bodyModel = BodyModel();
    if (bodyElement.children != null && bodyElement.children.isNotEmpty) {
      for (XmlNode node in bodyElement.children) {
        if (node is XmlElement) {
          XmlElement element = node;
          JcModel jcModel;
          String name = element.name.toString();
          if (name == 'model') {
            jcModel = _parseModuleModel(element, needRawStr: needRawStr); //模块
          } else {
            jcModel = _parseAllElement(element); //解析未识别的节点
          }
          if (jcModel != null) {
            bodyModel.addChild(jcModel);
          }
        } //end_if-(node is XmlElement)
      } //end_for
    } //end_if
    return bodyModel;
  }

  ///
  /// 解析模块节点<model/>（通过原始字符串）
  ///
  ModuleModel parseModuleModel(String moduleStr) {
    XmlDocument xmlDocument = parse(moduleStr);
    XmlElement rootElement = xmlDocument.firstChild;
    return _parseModuleModel(rootElement);
  }

  ///
  /// 解析模块节点<model/>
  ///
  /// <model/>节点下有节点<pos/>或者其他未识别
  ///
  ModuleModel _parseModuleModel(XmlElement moduleElement,
      {bool needRawStr = false}) {
    ModuleModel moduleModel =
        ModuleModel().parseAttributes(moduleElement.attributes);
    if (needRawStr) {
      moduleModel.rawData = moduleElement.toString();
    }
    if (moduleElement.children != null && moduleElement.children.isNotEmpty) {
      for (XmlNode node in moduleElement.children) {
        if (node is XmlElement) {
          XmlElement element = node;
          JcModel jcModel;
          String name = element.name.toString();
          if (name == 'pos') {
            jcModel = _parseProcedureModel(element); //工序
          } else {
            jcModel = _parseAllElement(element); //解析未识别的节点
          }
          if (jcModel != null) {
            moduleModel.addChild(jcModel);
          }
        } //end_if-(node is XmlElement)
      } //end_for
    } //end_if
    return moduleModel;
  }

  ///
  /// 解析工序节点<pos/>
  ///
  /// <pos/>节点下有节点<item/>或者其他未识别
  ///
  ProcedureModel _parseProcedureModel(XmlElement procedureElement) {
    ProcedureModel procedureModel =
        ProcedureModel().parseAttributes(procedureElement.attributes);
    if (procedureElement.children != null &&
        procedureElement.children.isNotEmpty) {
      for (XmlNode node in procedureElement.children) {
        if (node is XmlElement) {
          XmlElement element = node;
          JcModel jcModel;
          String name = element.name.toString();
          if (name == 'item') {
            jcModel = _parseProItemModel(element); //条目
          } else {
            jcModel = _parseAllElement(element); //解析未识别的节点
          }
          if (jcModel != null) {
            procedureModel.addChild(jcModel);
          }
        } //end_if-(node is XmlElement)
      } //end_for
    } //end_if
    return procedureModel;
  }

  ///
  /// 解析工序的条目节点<item/>
  ///
  ProItemModel _parseProItemModel(XmlElement proItemElement) {
    ProItemModel proItemModel =
        ProItemModel().parseAttributes(proItemElement.attributes);
    _parseLanguageModel(proItemModel, proItemElement);
    return proItemModel;
  }

  ///
  /// 解析工卡的附图节点<figure/>
  ///
  FigureModel parseFigureModel(String figureStr) {
    XmlDocument xmlDocument = parse(figureStr);
    XmlElement rootElement = xmlDocument.firstChild;
    return _parseFigureModel(rootElement);
  }

  ///
  /// 解析工卡的附图节点<figure/>
  ///
  FigureModel _parseFigureModel(XmlElement figureElement,
      {bool needRawStr = false}) {
    if (figureElement.children != null && figureElement.children.isNotEmpty) {
      FigureModel figureModel = FigureModel();
      figureModel.rawData = figureElement.toString();
      return _parseJcListModel(figureElement.children, figureModel);
    } else {
      return null;
    }
  }

  ///
  /// 解析有语言子节点的数据节点()
  ///
  /// 语言节点只有三个子节点<cn/>,<en/>,<mix/>.
  /// 包含语言节点的数据节点有以下：
  /// header: <note/>,<caution/>,<explain/>
  /// body: <item/>(条目)
  ///
  JcLanguageModel _parseLanguageModel(
      JcLanguageModel languageModel, XmlNode node) {
    JcLanguageModel sLanguageModel =
        languageModel == null ? JcLanguageModel() : languageModel;
    for (XmlNode childNode in node.children) {
      if (childNode is XmlElement) {
        XmlElement xmlElement = childNode;
        String name = xmlElement.name.toString();
        if (name == 'cn') {
          sLanguageModel.cnLanguageModel = _parseLanguageMetaModel(xmlElement);
        } else if (name == 'en') {
          sLanguageModel.enLanguageModel = _parseLanguageMetaModel(xmlElement);
        } else if (name == 'mix') {
          sLanguageModel.mixLanguageModel = _parseLanguageMetaModel(xmlElement);
        }
      } //end_if
    } //end_for
    return sLanguageModel;
  }

  ///
  /// 解析单个语言节点数据(过渡)
  ///
  JcLanguageMetaModel _parseLanguageMetaModel(XmlElement element) {
    if (element.children == null || element.children.isEmpty) {
      return null;
    } else {
      return _parseJcListModel(element.children, JcLanguageMetaModel());
    }
  }

  ///
  /// 解析多条model数据，用list存放
  ///
  JcListModel _parseJcListModel(List<XmlNode> nodeList,
      [JcListModel jcListModel]) {
    if (nodeList == null || nodeList.isEmpty) {
      return jcListModel;
    }
    JcListModel pJcListModel =
        (jcListModel == null) ? JcListModel() : jcListModel;
    int length = nodeList.length;
    for (int i = 0; i < length; i++) {
      XmlNode node = nodeList[i];
      if (node is XmlElement) {
        XmlElement xmlElement = node;
        JcModel jcModel = _parseAllElement(xmlElement, i);
        if (jcModel != null) {
          pJcListModel.addChild(jcModel);
        }
      } //end_if
    } //end_for
    return pJcListModel;
  }

  ///
  /// 解析header中的<explain/>节点
  ///
  ExplainModel _parseJcHeaderExplain(
      List<XmlNode> nodeList, ExplainModel explainModel) {
    for (XmlNode node in nodeList) {
      if (node is XmlElement) {
        ExplainItemModel explainItemModel =
            ExplainItemModel().parseAttributes(node.attributes);
        _parseLanguageModel(explainItemModel, node);
        explainModel.addChild(explainItemModel);
      }
    }
    return explainModel;
  }

  JcModel _parseAllElement(XmlElement element, [int index]) {
    JcModel jcModel;
    String name = element.name.toString();
    switch (name) {
      case 'para':
        jcModel = _parseParagraphModel(element);
        break;
      case 'text':
        jcModel = _parseTextModel(element);
        break;
      case 'image':
        jcModel = _parseImageModel(element);
        break;
      case 'eff':
        jcModel = _parseEffModel(element);
        break;
      case 'hide':
        jcModel = _parseHideModel(element);
        break;
      case 'input':
        jcModel = _parseInputModel(element);
        break;
      case 'table':
        jcModel = _parseTableModel(element);
        break;
      case 'tr':
        jcModel = _parseTableRowModel(element, index);
        break;
      case 'td':
        jcModel = _parseTableDataModel(element);
        break;
      case 'th':
        jcModel = _parseTableDataModel(element);
        break;
      case 'checkbox':
        jcModel = _parseCheckboxModel(element);
        break;
      case 'radio':
        jcModel = _parseRadioModel(element);
        break;
      default: //解析未识别的节点
        jcModel = _parseUnrecognized(element);
        break;
    }
    return jcModel;
  }

  ///
  /// 解析表格<table/>
  ///
  TableModel _parseTableModel(XmlElement element) {
    TableModel tableModel = TableModel().parseAttributes(element.attributes);
    for (XmlNode node in element.children) {
      if (node is XmlElement) {
        XmlElement tElement = node;
        String name = tElement.name.toString();
        if (name == 'thead') {
          tableModel.tableHeaderModel = _parseTableHeaderModel(tElement);
        } else if (name == 'tbody') {
          tableModel.tableBodyModel = _parseTableBodyModel(tElement);
        } else if (name == 'tfoot') {
          tableModel.tableFooterModel = _parseTableFooterModel(tElement);
        }
      }
    }
    return tableModel;
  }

  ///
  /// 解析表格头部<thead/>
  /// 没有详细的格式内容解析细节
  ///
  TableHeaderModel _parseTableHeaderModel(XmlElement element) {
    if (element.children != null && element.children.isNotEmpty) {
      return _parseJcListModel(element.children, TableHeaderModel());
    } else {
      return null;
    }
  }

  ///
  /// 解析表格头部<tfoot/>
  /// 没有详细的格式内容解析细节
  ///
  TableFooterModel _parseTableFooterModel(XmlElement element) {
    if (element.children != null && element.children.isNotEmpty) {
      return _parseJcListModel(element.children, TableFooterModel());
    } else {
      return null;
    }
  }

  ///
  /// 解析表格内容区域<tbody/>
  ///
  TableBodyModel _parseTableBodyModel(XmlElement element) {
    if (element.children != null && element.children.isNotEmpty) {
      return _parseJcListModel(element.children, TableBodyModel());
    } else {
      return null;
    }
  }

  ///
  /// 解析表格行<tr/>
  ///
  TableRowModel _parseTableRowModel(XmlElement element, [int index]) {
    TableRowModel tableRowModel =
        TableRowModel().parseAttributes(element.attributes);
    if (element.children != null && element.children.isNotEmpty) {
      _parseJcListModel(element.children, tableRowModel);
    }
    if (index != null) {
      tableRowModel.rowIndex = index;
    }
    return tableRowModel;
  }

  ///
  /// 解析表格行<td/>
  ///
  TableDataModel _parseTableDataModel(XmlElement element) {
    TableDataModel tableDataModel =
        TableDataModel().parseAttributes(element.attributes);
    if (element.children != null && element.children.isNotEmpty) {
      _parseJcListModel(element.children, tableDataModel);
      //将td的横向布局属性放入到内部的para标签中
      if (tableDataModel.children != null &&
          tableDataModel.children.isNotEmpty) {
        tableDataModel.children.forEach((jcModel) {
          if (jcModel is ParagraphModel) {
            ParagraphModel paragraphModel = jcModel;
            paragraphModel.hAlignment = tableDataModel.hAlignment;
          }
        });
      }
    }
    return tableDataModel;
  }

  ///
  /// 解析适用性节点<eff/>
  ///
  EffModel _parseEffModel(XmlElement element) {
    EffModel effModel = EffModel().parseAttributes(element.attributes);
    if (element.children != null && element.children.isNotEmpty) {
      effModel = _parseJcListModel(element.children, effModel);
    }
    return effModel;
  }

  ///
  /// 解析隐藏节点<hide/>
  ///
  HideModel _parseHideModel(XmlElement element) {
    if (element.children != null && element.children.isNotEmpty) {
      return _parseJcListModel(element.children, HideModel());
    }
    return null;
  }

  ParagraphModel _parseParagraphModel(XmlElement element) {
    ParagraphModel paragraphModel =
        ParagraphModel().parseAttributes(element.attributes);
    if (element.children != null && element.children.isNotEmpty) {
      for (XmlNode node in element.children) {
        if (node is XmlElement) {
          XmlElement subElement = node;
          JcModel jcModel = _parseAllElement(subElement);
          if (jcModel != null) {
            paragraphModel.addChild(jcModel);
          }
        } //end_if-(node is XmlElement)
      } //end_for
    } //end_if

    ///
    ///***** 对<para/>节点的子数据进行优化显示 *****
    ///目的：children中包含连续的<text/>节点时，比较TextModel的属性是否一致，如果一致则合并为一个新的TextModel
    /// 、、、
    ///   <text>文本一</text>
    ///   <text>文本二</text>
    ///   <text style='1'>文本三</text>
    ///   =>
    ///   <text>文本一文本二</text>
    ///   <text style='1'>文本三</text>
    /// 、、、
    ///
    if (paragraphModel.children != null && paragraphModel.children.length > 1) {
      int length = paragraphModel.children.length;
      for (int i = length - 1; i >= 1;) {
        JcModel currentModel = paragraphModel.children[i];
        if (currentModel is TextModel) {
          JcModel preModel = paragraphModel.children[i - 1];
          if (preModel is TextModel) {
            TextModel cTextModel = currentModel;
            TextModel pTextModel = preModel;
            if (_sameStyleText(cTextModel, pTextModel)) {
              //两个一样，则开始合并，往上合并
              pTextModel.text = pTextModel.text + currentModel.text;
              paragraphModel.children.removeAt(i); //移除被合并的TextModel
            }
            i--; //以上i-1作为参考，往前比较
          } else {
            i = (i - 2); //前一个不是TextModel类型，直接跳过
          }
        } else {
          i--;
        }
      } //end_for
    }

    ///
    ///拆分textModel节点，根据textModel中是否有\r\n标签进行拆分。
    ///缘由：由于text的内容可能含有\r\n符，在text有样式的情况下，可能会导致在换行后含有样式内容(比如背景色)
    ///思路：
    ///   1、判断是否包含\r\n字符；
    ///   2、通过\r\n对text进行拆分；
    ///   3、拆分后的字符串数组：每段字符串，去除后面的空格。
    ///
    if (paragraphModel.children != null && paragraphModel.children.length > 0) {
      List<JcModel> children = [];
      for (JcModel jcModel in paragraphModel.children) {
        if (jcModel is TextModel) {
          TextModel textModel = jcModel;
          String text = textModel.text;
          if (text != null && text.contains('\r\n')) {
            //根据换行符拆分
            List<String> subStrings = text.split('\r\n');
            int length = subStrings.length;
            for (int i = 0; i < length; i++) {
              String subStr = subStrings[i];
              subStr = subStr.trimRight(); //去除后面的空格

              if (subStr.length > 0) {
                //有内容
                TextModel subTextModel = _copyTextModel(textModel);
                subTextModel.text = subStr;
                children.add(subTextModel);
              }
              if (i != length - 1) {
                //换行，不作任何样式控制
                TextModel breakModel = TextModel();
                breakModel.text = '\r\n';
                children.add(breakModel);
              }
            }
          } else {
            children.add(jcModel);
          }
        } else {
          if (jcModel is CheckboxModel || jcModel is RadioModel) {
            /// TODO:处理为checkbox(radioButton)的情况下，如果实现checkbox(radioButton)与text关联
            print('jcModel is checkbox or radioButton');
          }
          children.add(jcModel);
        }
      } //end_for
      paragraphModel.children = children;
    }

    return paragraphModel;
  }

  TextModel _copyTextModel(TextModel resource) {
    TextModel textModel = TextModel();
    textModel.style = resource.style;
    textModel.color = resource.color;
    textModel.bgColor = resource.bgColor;
    textModel.isBold = resource.isBold;
    textModel.isItalics = resource.isItalics;
    textModel.hasUnderline = resource.hasUnderline;
    textModel.isSuber = resource.isSuber;
    textModel.isSuper = resource.isSuper;
    textModel.fontName = resource.fontName;
    textModel.href = resource.href;
    textModel.rotateDegree = resource.rotateDegree;
    textModel.isLineStartType = resource.isLineStartType;
    textModel.lineStartSign = resource.lineStartSign;

    return textModel;
  }

  ///
  ///解析<text/>节点
  ///
  TextModel _parseTextModel(XmlElement element) {
    TextModel textModel = TextModel().parseAttributes(element.attributes);
    XmlNode firstChild = element.firstChild;
    if (firstChild != null && firstChild.nodeType == XmlNodeType.TEXT) {
      XmlText xmlText = firstChild;
      textModel.text = xmlText.text;
    }
    return textModel;
  }

  ///
  /// 解析<image/>节点
  ///
  ImageModel _parseImageModel(XmlElement element) {
    ImageModel imageModel = ImageModel().parseAttributes(element.attributes);
    return imageModel;
  }

  ///
  /// 解析<input/>节点
  ///
  InputModel _parseInputModel(XmlElement element) {
    InputModel inputModel = InputModel().parseAttributes(element.attributes);
    return inputModel;
  }

  ///
  ///
  /// 解析<checkbox/>节点
  CheckboxModel _parseCheckboxModel(XmlElement element) {
    CheckboxModel checkboxModel =
        CheckboxModel().parseAttributes(element.attributes);
    if (element.children != null && element.children.isNotEmpty) {
      _parseJcListModel(element.children, checkboxModel);
    }
    return checkboxModel;
  }

  ///
  ///
  /// 解析<radio/>节点
  RadioModel _parseRadioModel(XmlElement element) {
    RadioModel radioModel = RadioModel().parseAttributes(element.attributes);
    if (element.children != null && element.children.isNotEmpty) {
      _parseJcListModel(element.children, radioModel);
    }
    return radioModel;
  }

  ///
  /// 解析未识别的节点
  ///
  JcModel _parseUnrecognized(XmlElement element) {
    if (element.children != null && element.children.isNotEmpty) {
      return _parseJcListModel(element.children);
    } else {
      //直到识别不了，直接返回一个文本模型TextModel
      TextModel textModel = TextModel();
      textModel.text = element.toString();
      return textModel;
    }
  }

  Future<String> formatString(String resource) {
    String newStr = resource;
    newStr = newStr.replaceAll("\n\t", "");
    newStr = newStr.replaceAll("\t", "");
    return Future.value(newStr);
  }

  bool _sameStyleText(TextModel textModel1, TextModel textModel2) {
    if (textModel1.style == textModel2.style &&
        textModel1.isBold == textModel2.isBold &&
        textModel1.isItalics == textModel2.isItalics &&
        textModel1.hasUnderline == textModel2.hasUnderline &&
        textModel1.isSuber == textModel2.isSuber &&
        textModel1.isSuper == textModel2.isSuper &&
        textModel1.fontName == textModel2.fontName &&
        _sameColor(textModel1.color, textModel2.color) &&
        _sameColor(textModel1.bgColor, textModel2.bgColor)) {
      return true;
    } else {
      return false;
    }
  }

  //同色
  bool _sameColor(Color color1, Color color2) {
    bool color1Null = ((color1 == null) ? true : false);
    bool color2Null = ((color2 == null) ? true : false);
    if ((color1Null && color2Null) ||
        (!color1Null && !color2Null && (color1.hashCode == color2.hashCode))) {
      return true;
    } else {
      return false;
    }
  }
}
