import 'para_model.dart';
import 'text_model.dart';
import 'unlitem_model.dart';

class TableCellModel{

  int row;
  int column;

  int colspan = 1;
  int rowspan = 1;
  int valign = 1;
  int align = 1;

  int border = 1;
  ///宽度
  ///
  /// [isPercent]=true,表示width是比例值；
  /// [isPercent]=false,表示width是固定宽度值
  double width;
  ///控制宽度是否是百分比
  bool isPercent = false;

  ///文本样式属性
  double fontSize = 23;

  List children = [];


  @override
  String toString() {
    return '<td colspan="$colspan", rowspan="$rowspan">row:$row, col:$column, $textContentList</td>';
  }

  List<String> _contentList = [];

  List<String> get textContentList{

    if (_contentList.length != 0){
      return _contentList;
    }

    ///para 与 text 的层级关系没有在此体现出来
    children.forEach((element){
      if(element.runtimeType == ParaModel){
        ParaModel para = element;
        para.children.forEach((subElem){
          if(subElem.runtimeType == TextModel){
            _contentList.add((subElem as TextModel).text);
          }
        });
      }else if(element.runtimeType == TextModel){
        _contentList.add((element as TextModel).text);
      }else if (element.runtimeType == UnlItemModel){
        _contentList.add((element as UnlItemModel).text);
      }
    });

    return _contentList;
  }

}