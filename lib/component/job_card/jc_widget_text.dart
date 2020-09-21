import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:lop/component/easy_rich_text/easy_rich_text.dart';
import 'package:lop/component/easy_rich_text/easy_rich_text_pattern.dart';
import '../../model/jobcard/jc_text_model.dart';
import 'package:lop/style/size.dart';
class JcWidgetText extends StatefulWidget {
  final TextModel data;
  final TextStyle style;

  JcWidgetText({Key key, @required this.data, @required this.style})
      : assert(data != null, 'JcWidgetText: data不能为null!'),
        assert(style != null && style.fontSize != null && style.color != null,
            'JcWidgetText: style不能为null , style.fontSize和style.color必须赋值！'),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _JcWidgetTextState();
  }
}

class _JcWidgetTextState extends State<JcWidgetText> {
  double lineHeight = KSize.jcSignItemTextHeight;
  @override
  Widget build(BuildContext context) {
    //字体背景色
    Color backGroundColor =widget.data.bgColor??Color.fromRGBO(255, 255, 255, 1);
    //字体颜色
    Color color =
        widget.data.color == null ? widget.style.color : widget.data.color;
    //粗体
    FontWeight weight =
        widget.data.isBold ? FontWeight.bold : widget.style.fontWeight;
    //斜体
    FontStyle style =
        widget.data.isItalics ? FontStyle.italic : widget.style.fontStyle;
    //下划线
    TextDecoration decoration = widget.data.hasUnderline
        ? TextDecoration.underline
        : widget.style.decoration;
    //字体大小（用户放大缩小，直接传过来的是字体*放大倍数）
    double size=widget.style.fontSize;
    String fontFamily = widget.data.fontName != null? widget.data.fontName:widget.style.fontFamily;
    if(fontFamily != null){
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

    String text = widget.data.text == null ? '' : widget.data.text;
    if(widget.data.isSuber||widget.data.isSuper){
      List<InlineSpan> children = List<InlineSpan>();
      children.add(
          WidgetSpan(
              child: EasyRichText(
                text,
                defaultStyle: _textStyle,
                patternList: [
                  EasyRichTextPattern(
                      targetString: widget.data.text,
                      superScript: widget.data.isSuper,
                      subScript: widget.data.isSuber,
                      matchWordBoundaries: false),
                ],
              )));
      return
        Container(
        padding: EdgeInsets.only(top: 8),
        child:
        RichText(
          text: TextSpan(children: children),
        ),
      );
//        RichText(
//          text: TextSpan(children: children),
//        );
    }else{
      return  Text(text, style: _textStyle);
    }

  }
}
