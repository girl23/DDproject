import 'package:flutter/material.dart';
import '../indent_rich_content/widget/indent_check_box.dart';
import 'widget/indent_text_with_text_field.dart';

class LayoutHelper extends Object {
  static Size richTextSize(RichText richText, double minWidth){
    TextPainter textPainter = TextPainter(
      text: richText.text,
      textAlign: richText.textAlign ?? TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    List<PlaceholderDimensions> dimensions = [];
    richText.children.forEach((widget){
      Size size = Size.zero;
      ///这里的 size 代表每块内容的宽高且会决定整个td 内容的宽高
      if(widget.runtimeType == IndentTextFieldSizeBox) {
        size = Size((widget as IndentTextFieldSizeBox).size.width, (widget as IndentTextFieldSizeBox).size.height);
      }else if (widget.runtimeType == Container){
        size = Size((widget as Container).constraints.minWidth, (widget as Container).constraints.minHeight);
      }else if(widget.runtimeType == IndentCheckBox){
        size = Size((widget as IndentCheckBox).size.width, (widget as IndentCheckBox).size.height);
      }else if (widget.runtimeType == SizedBox){
        size = Size((widget as SizedBox).width, (widget as SizedBox).height);
      }else{
        assert(false, 'all kind of widget(except Text and RichText) must calculate its size before layout textPainter');
      }
      dimensions.add(PlaceholderDimensions(size: size, alignment: PlaceholderAlignment.baseline));
    });
    textPainter.setPlaceholderDimensions(dimensions);

    textPainter.layout(minWidth: minWidth,maxWidth: minWidth);
    return textPainter.size;
  }

  static Size textSize(Text textWidget, double minWidth){
    TextSpan textSpan = TextSpan(
        text: textWidget.data,
        style: textWidget.style
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: textWidget.textAlign ?? TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: minWidth,maxWidth: minWidth);
    return Size(textPainter.size.width, textPainter.size.height);
  }
}

class NonFinalSize extends Object{
  double width;
  double height;

  NonFinalSize(this.width,this.height);

  static NonFinalSize fromSize(Size size){
    return NonFinalSize(size.width, size.height);
  }

  Size toSize(){
    return Size(this.width, this.height);
  }

  @override
  String toString() {
    return 'Size(width:$width, Height:$height)';
  }
}