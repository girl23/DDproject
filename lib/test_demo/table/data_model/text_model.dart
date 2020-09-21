class TextModel{

  String text;

  ///是否是粗体
  bool isBold = false;
  ///含义暂时未知
  bool isBu = false;
  ///font size
  double fontSize;

  TextModel(this.text);

  @override
  String toString() {
    return 'text:$text';
  }
}