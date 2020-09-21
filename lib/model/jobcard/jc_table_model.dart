import 'package:xml/xml.dart';

import 'jc_model.dart';

class TableHeaderModel extends JcListModel {
  String tag = 'thead';
}

class TableBodyModel extends JcListModel {
  String tag = 'tbody';
}

class TableFooterModel extends JcListModel {
  String tag = 'tfoot';
}

///
/// 表格模型<table/>
///
class TableModel extends JcModel {
  String tag = 'table';
  double width;
  String widthPercent;
  String name;

  TableHeaderModel tableHeaderModel; //TODO:复杂header没有解析
  TableBodyModel tableBodyModel;
  TableFooterModel tableFooterModel;

  TableModel parseAttributes(List<XmlAttribute> attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      for (XmlAttribute attribute in attributes) {
        String name = attribute.name.toString();
        String value = attribute.value;
        if (name == 'width') {
          width = double.tryParse(value);
        }else if(name == 'name'){
          this.name = value;
        }else if(name == 'widthpercent'){
          if(value != null){
            if(value.endsWith('%')){
              this.widthPercent = (double.parse(value.substring(0,value.length-1))/100.0).toString();
            }else{
              this.widthPercent = value;
            }
          }

        }
      }
    }
    return this;
  }
}

///
/// 表格行数据<tr/>
///
class TableRowModel extends JcListModel {
  String tag = 'tr';
  int rowIndex; //行标，从0开始
  int minHeight;

  TableRowModel parseAttributes(List<XmlAttribute> attributes) {
    if (attributes != null && attributes.isNotEmpty) {
      for (XmlAttribute attribute in attributes) {
        String name = attribute.name.toString();
        String value = attribute.value;
        if (name == 'minheight') {
          minHeight = int.parse(value);
        }
      }
    }
    return this;
  }
}

///
/// 表格数据<td/>
///
class TableDataModel extends JcListModel {
  String tag = 'td';
  VerticalAlignment vAlignment = VerticalAlignment.center;
  HorizontalAlignment hAlignment = HorizontalAlignment.center;
  int width;
  bool _border;
  bool _borderLeft;
  bool _borderTop;
  bool _borderRight;
  bool _borderBottom;
  int colSpan = 1;
  int rowSpan = 1;
  int col = 1;
  int row = 1;

  bool get _hadBorder => (_border == null) ? false : _border;

  bool get borderLeft => (_borderLeft == null) ? _hadBorder : _borderLeft;
  bool get borderTop => (_borderTop == null) ? _hadBorder : _borderTop;
  bool get borderRight => (_borderRight == null) ? _hadBorder : _borderRight;
  bool get borderBottom => (_borderBottom == null) ? _hadBorder : _borderBottom;


  @override
  String toString() {
    return 'TableDataModel{tag: $tag, width: $width, col:$col, row:$row, colSpan: $colSpan, rowSpan: $rowSpan, children:${children.toString()}';
  }

  TableDataModel parseAttributes(List<XmlAttribute> attributes) {
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
      case 'valign':
        _translateVerticalAlign(int.parse(value));
        break;
      case 'halign':
        _translateHorizontalAlign(int.parse(value));
        break;
      case 'width':
        width = int.parse(value);
        break;
      case 'border':
        _border = ('1' == value) ? true : false;
        break;
      case 'borderleft':
        _borderLeft = ('1' == value) ? true : false;
        break;
      case 'bordertop':
        _borderTop = ('1' == value) ? true : false;
        break;
      case 'borderright':
        _borderRight = ('1' == value) ? true : false;
        break;
      case 'borderbottom':
        _borderBottom = ('1' == value) ? true : false;
        break;
      case 'colspan':
        colSpan = int.parse(value);
        break;
      case 'rowspan':
        rowSpan = int.parse(value);
        break;
    }
  }

  void _translateVerticalAlign(int align) {
    if (align == 0) {
      vAlignment = VerticalAlignment.center;
    } else if (align == 1) {
      vAlignment = VerticalAlignment.top;
    } else if (align == 2) {
      vAlignment = VerticalAlignment.bottom;
    }
  }

  void _translateHorizontalAlign(int align) {
    if (align == 0) {
      hAlignment = HorizontalAlignment.center;
    } else if (align == 1) {
      hAlignment = HorizontalAlignment.left;
    } else if (align == 2) {
      hAlignment = HorizontalAlignment.right;
    }
  }
}
