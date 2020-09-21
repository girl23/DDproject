import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lop/model/jc_sign_model.dart';
import '../../../component/xml_table/xml_converted_table.dart';
import 'package:provider/provider.dart';

import 'ITextField.dart';
import 'ly_check_list.dart';
import 'ly_expandable_text.dart';
import 'ly_local_text.dart';
import 'ly_radio_list.dart';

class LySignItemContent extends StatefulWidget {
  final itemData;
  final itemWidth;
  final itemId;
  final TextType textType;

  const LySignItemContent(
      {Key key, this.itemId,this.itemData, this.itemWidth, this.textType})
      : super(key: key);

  @override
  _LySignItemContentState createState() => _LySignItemContentState();
}

class _LySignItemContentState extends State<LySignItemContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JcSignModel>(builder: (context, provider, child) {
      return Center(
          child: RichText(
        text: TextSpan(children: _buildWidgets(provider)),
      ));
    });
  }

  List<InlineSpan> _buildPara(provider, items, surWidth,dataIndex) {
    List<InlineSpan> widgets = List();//所有列组件
    List<Widget> rowWidgets = List();//所有行组件
    double inputWidth = 120;
    double surWidth1 = surWidth;
    double totalHeight = 0.0;
    double lineHeight;
    double lastTextWidth = 0.0;
    String lastText; //上一段文字剩余没有显示的文字
    double rowWidth = 0.0; //行控件所占宽度
    for (int i = 0;i<items.length;i++) {
      var item = items[i];
      if (item["type"] == "text") {
//        List<List<int>> strInexs = ItemIndexUtls.getIndex(widget.itemId, dataIndex, i);
//        if(strInexs.isNotEmpty){
//
//        }else{
          TextStyle style = TextStyle(fontWeight: item["textFont"],color: item["textColor"],fontSize: provider.fontScale);
          //段落基本信息
          ui.ParagraphStyle paragraphStyle = ui.ParagraphStyle(textAlign: TextAlign.left, fontWeight: style.fontWeight, fontStyle: style.fontStyle, fontSize: style.fontSize,);
          ui.ParagraphBuilder pb = ui.ParagraphBuilder(paragraphStyle);
          pb.pushStyle(ui.TextStyle(fontWeight: item["textFont"],color: item["textColor"],fontSize: provider.fontScale));
          var holeText = item["text"];
          if (rowWidgets.isNotEmpty) {
            double contentWidth = surWidth1 - rowWidth;
            pb.addText(holeText);
            ui.ParagraphConstraints pc2 = ui.ParagraphConstraints(width: contentWidth);
            ui.Paragraph paragraph2 = pb.build()..layout(pc2);
            List<ui.LineMetrics> list2 = paragraph2.computeLineMetrics();
            if (list2.length > 1) {
              TextRange range = paragraph2.getLineBoundary(TextPosition(offset: 0));
              var firstText = holeText.substring(range.start, range.end); //截取第一段文字
//              ItemIndexUtls.pushInex(widget.itemId, dataIndex, i,range.start,range.end);
              holeText = holeText.substring(range.end, holeText.length - 1);
//              ItemIndexUtls.pushInex(widget.itemId, dataIndex, i,range.end,holeText.length - 1);
              rowWidgets.add(Text(firstText, style: style,));
              widgets.add(WidgetSpan(child: Row(children: rowWidgets,)));
              rowWidgets = [];
              rowWidth = 0;
              contentWidth = surWidth1;
              pb.addText(holeText);
              ui.ParagraphConstraints pc =
              ui.ParagraphConstraints(width: contentWidth);
              ui.Paragraph paragraph = pb.build()..layout(pc);
              List<ui.LineMetrics> list = paragraph.computeLineMetrics();
              totalHeight = paragraph.height + totalHeight;
              ui.LineMetrics lastMetric = list.last;
              lineHeight = lastMetric.height;
              lastTextWidth = lastMetric.width;
              if(list.length > 1){
                TextRange range = paragraph.getLineBoundary(TextPosition(offset: holeText.length - 1));
                lastText = holeText.substring(range.start, range.end);
                var subText = holeText.substring(0, range.start); //
                widgets.add(WidgetSpan(child: Text(subText, style: style,)));
                rowWidgets.add(Text(lastText, style: style,));
              }else{
                rowWidgets.add(Text(holeText, style: style,));
              }
              rowWidth += lastTextWidth;
            } else {
              rowWidgets.add(Text(holeText, style: style,));
              rowWidth += lastTextWidth;
            }
          }else{
            double contentWidth = surWidth1;
            //1、计算第一段文字
            pb.addText(holeText);
            ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: contentWidth);
            ui.Paragraph paragraph = pb.build()..layout(pc);
            List<ui.LineMetrics> list = paragraph.computeLineMetrics();
            totalHeight = paragraph.height + totalHeight;
            ui.LineMetrics lastMetric = list.last;
            lineHeight = lastMetric.height;
            lastTextWidth = lastMetric.width;
            if(list.length > 1){
              TextRange range = paragraph.getLineBoundary(TextPosition(offset: holeText.length - 1));
              lastText = holeText.substring(range.start, range.end);
              var subText = holeText.substring(0, range.start); //
              widgets.add(WidgetSpan(child: Text(subText, style: style,)));
              rowWidgets.add(Text(lastText, style: style,));
            }else{
              rowWidgets.add(Text(holeText, style: style,));
            }
            rowWidth += lastTextWidth;
          }
//        }
      } else if (item["type"] == "input") {
        if (rowWidgets.isNotEmpty) {
          if (surWidth1 - rowWidth < inputWidth) {
            widgets.add(WidgetSpan(
                child: Row(
              children: rowWidgets,
            )));
            rowWidgets = [];
            rowWidgets.add(Container(
              width: inputWidth,
              height: lineHeight??20,
              child: ITextField(
                inputBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1)),
                fieldCallBack: (value) {
                  print("ITextField value:${value}");
                },
                textStyle: TextStyle(color: Colors.green, fontSize: 14),
              ),
            ));
            rowWidth = inputWidth;
          } else {
            rowWidgets.add(Container(
              width: inputWidth,
              height: lineHeight??20,
              child: ITextField(
                inputBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1)),
                fieldCallBack: (value) {
                  print("ITextField value:${value}");
                },
                textStyle: TextStyle(color: Colors.green, fontSize: 14),
              )
            ));
            rowWidth += inputWidth;
          }
        } else {
          rowWidgets.add(Container(
            width: inputWidth,
            height: lineHeight??20,
            child: ITextField(
              inputBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1)),
              fieldCallBack: (value) {
                print("ITextField value:${value}");
              },
              textStyle: TextStyle(color: Colors.green, fontSize: 14),
            ),
          ));
          rowWidth = inputWidth;
        }
      } else {
        if (rowWidgets.isNotEmpty) {
          widgets.add(WidgetSpan(
              child: Row(
            children: rowWidgets,
          )));
          rowWidgets = [];
          rowWidth = 0;
        }
        if (item["type"] == "image") {
          widgets.add(WidgetSpan(
              child: Container(
                width: widget.itemWidth,
                child: Image.network(item["imageUrl"]),
              )));
          rowWidth = 0;
        } else if (item["type"] == "radio") {
          widgets.add(WidgetSpan(
              child: Container(
                  width: widget.itemWidth,
                  child: LyRadioList(
                    radios: item["stringList"],
                    callBack: (value) {
                      print("radio value:${value}");
                    },
                  ))));
          rowWidth = 0;
        } else if (item["type"] == "check") {
          widgets.add(WidgetSpan(
              child: Container(
                  width: widget.itemWidth,
                  child: LyCheckList(
                    checks: item["stringList"],
                    callBack: (value) {
                      print("checked value:${value}");
                    },
                  ))));
          rowWidth = 0;
        } else if (item["type"] == "expandabletext") {
          widgets.add(WidgetSpan(
              child: LyExpandableText(
                item["text"],
                expandText: "更多",
                collapseText: "收起",
                maxLines: 1,
                linkColor: Colors.blue,
              )));
          rowWidth = 0;
        } else if(item["type"] == "table"){
//          print(item["tables"]);
//          widgets.add(WidgetSpan(
//              child:Container(
//                color: Colors.red,
//                child: item["tables"].length == 0?Text("null"):XmlConvertedTable(item["tables"][0],MediaQuery.of(context).size.width,padding: EdgeInsets.all(3),),
//              )));
          rowWidth = 0;

        }
      }
    }
    return widgets;
  }

  ///

  List<InlineSpan> _buildWidgets(provider) {
    List<InlineSpan> widgets = List<InlineSpan>();
    int dataLength = widget.itemData.length;
    for (int i=0; i < dataLength;i++) {
      var item = widget.itemData[i];
//      for(var item in items){
        if(item["type"] == "para"){
          widgets.addAll(_buildPara(provider, item["items"], widget.itemWidth,i));
        }else if(item["type"] == "image"){
          widgets.add(WidgetSpan(
              child: Container(
                width: widget.itemWidth,
                child: Image.network(item["items"]["imageUrl"]),
              )));
        }else if(item["type"] == "expandable"){
          widgets.add(WidgetSpan(
              child: LyExpandableText(
                item["items"]["text"],
                expandText: "更多",
                collapseText: "收起",
                maxLines: 1,
                linkColor: Colors.blue,
              )));
        }else if(item["type"] == "radio"){
          widgets.add(WidgetSpan(
              child: Container(
                  width: widget.itemWidth,
                  child: LyRadioList(
                    radios: item["items"]["stringList"],
                    callBack: (value) {
                      print("radio value:${value}");
                    },
                  ))));
        }
        else if(item["type"] == "check"){
          widgets.add(WidgetSpan(
              child: Container(
                  width: widget.itemWidth,
                  child: LyCheckList(
                    checks: item["items"]["stringList"],
                    callBack: (value) {
                      print("checked value:${value}");
                    },
                  ))));
        }else if(item["type"] == "table"){
//          widgets.add(WidgetSpan(
//              child:item["items"]["tables"].length == 0?Text("null"):XmlConvertedTable(item["items"]["tables"][0],widget.itemWidth,padding: EdgeInsets.all(3),)));

        }
//      }
    }
    return widgets;
  }
}
