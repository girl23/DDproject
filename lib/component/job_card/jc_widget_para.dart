import 'package:flutter/cupertino.dart';
import 'jc_widget_util.dart';
import '../../model/jobcard/jc_model.dart';
import '../../model/jobcard/jc_para_model.dart';
import 'package:lop/component/easy_rich_text/easy_rich_text.dart';
import 'package:lop/component/easy_rich_text/easy_rich_text_pattern.dart';
import 'package:lop/style/size.dart';
import '../../model/jobcard/jc_text_model.dart';

//class JcWidgetParagraph extends StatefulWidget {
//  final ParagraphModel data;
//  final TextStyle textStyle;
//
//  JcWidgetParagraph({Key key, @required this.data, @required this.textStyle})
//      : assert(data != null, 'JcWidgetParagraph: data不能为null!'),
//        super(key: key);
//
//  @override
//  State<StatefulWidget> createState() {
//    return _JcWidgetParagraphState();
//  }
//}
//
//class _JcWidgetParagraphState extends State<JcWidgetParagraph> {
//  @override
//  Widget build(BuildContext context) {
//    if (widget.data.children == null || widget.data.children.isEmpty) {
//      return Container();
//    } else {
//      List<Widget> children = [];
//      for (JcModel jcModel in widget.data.children) {
//
//        Widget _widget =
//            JcWidgetUtil.createWidget(jcModel, textStyle: widget.textStyle);
//        if (_widget != null) {
//          children.add(_widget);
//        }
//      }
//      if (children.isEmpty) {
//        return Container();
//      } else {
//        CrossAxisAlignment crossAxisAlignment =
//            (widget.data.hAlignment == HorizontalAlignment.right)
//                ? CrossAxisAlignment.end
//                : (widget.data.hAlignment == HorizontalAlignment.left)
//                    ? CrossAxisAlignment.start
//                    : CrossAxisAlignment.center;
//
//        return Container(
//          child: Wrap(
//            children: children,
//          ),
//        );
//      }
//    }
//  }
//}


class JcWidgetParagraph extends StatefulWidget {
  final ParagraphModel data;
  final TextStyle textStyle;

  JcWidgetParagraph({Key key, @required this.data, @required this.textStyle})
      : assert(data != null, 'JcWidgetParagraph: data不能为null!'),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _JcWidgetParagraphState();
  }
}

class _JcWidgetParagraphState extends State<JcWidgetParagraph> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.children == null || widget.data.children.isEmpty) {
      return Container();
    } else {
      List<InlineSpan> children = List<InlineSpan>();
      for (JcModel jcModel in widget.data.children) {
        TextModel data=jcModel;
        //字体背景色
        Color backGroundColor = data.bgColor ??
            Color.fromRGBO(255, 255, 255, 1);
        //字体颜色
        Color color =
        data.color == null ? widget.textStyle.color : data.color;
        //粗体
        FontWeight weight =
        data.isBold ? FontWeight.bold : widget.textStyle.fontWeight;
        //斜体
        FontStyle style =
        data.isItalics ? FontStyle.italic : widget.textStyle.fontStyle;
        //下划线
        TextDecoration decoration = data.hasUnderline
            ? TextDecoration.underline
            : widget.textStyle.decoration;
        //字体大小（用户放大缩小，直接传过来的是字体*放大倍数）
        double size = widget.textStyle.fontSize;
        String fontFamily = data.fontName != null ? data.fontName : widget.textStyle
            .fontFamily;
        if (fontFamily != null) {
          print(fontFamily);
        }

        TextStyle _textStyle = TextStyle(
            backgroundColor: backGroundColor,
            color: color,
            fontWeight: weight,
            fontSize: size,
            fontStyle: style,
            decoration: decoration,
            decorationColor: color,
            decorationStyle: TextDecorationStyle.solid,
            fontFamily: fontFamily,
            height: 1.5);

        String text = data.text == null ? '' : data.text;

        if (data.isSuber || data.isSuper) {

          children.add(
              WidgetSpan(
                  child: EasyRichText(
                    text,
                    defaultStyle: _textStyle,
                    patternList: [
                      EasyRichTextPattern(
                          targetString: data.text,
                          superScript: data.isSuper,
                          subScript: data.isSuber,
                          matchWordBoundaries: false),
                    ],
                  )));
        }
        else{
          children.add(TextSpan(text: data.text,style: _textStyle));
        }
      }//for
      return Container(
        child: RichText(text: TextSpan(children:children ),),
      );
    }
  }
}