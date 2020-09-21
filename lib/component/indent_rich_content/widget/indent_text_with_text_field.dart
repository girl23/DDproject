
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../layout_helper.dart';
import 'indent_rich_widget.dart';

class IndentTextWithTextField extends IndentRichWidget {

  ///string 或者 IndentTextFieldSizeBox
  final List<Object> contentList;
  final double indent;
  final TextStyle style;

  IndentTextWithTextField({
    @required this.contentList,
    @required NonFinalSize size,
    @required this.indent,
    @required this.style
}): super(size:size);

  @override
  _IndentTextWithTextFieldState createState() => _IndentTextWithTextFieldState();
}

class _IndentTextWithTextFieldState extends State<IndentTextWithTextField> {

  List<Widget> _children;
  bool allCacheDone = false;
  Rect layoutCache = Rect.zero;

  @override
  Widget build(BuildContext context) {
    _children = [];
    Widget child = RichText(
      text: TextSpan(
        style: widget.style,
          children: widget.contentList.map((item){
            if(item.runtimeType == String){
              return TextSpan(text: item);
            }else{
              return WidgetSpan(child: item);
            }}).toList()
      ),
    );
    _children.add(
        LayoutId(id: 0, child: child)
    );

    return Container(
      child: CustomMultiChildLayout(
        delegate: _IndentTextFieldDelegate(this),
        children: _children,
      ),
    );
  }
}

class _IndentTextFieldDelegate extends MultiChildLayoutDelegate {

  _IndentTextWithTextFieldState state;
  _IndentTextFieldDelegate(this.state);

  @override
  void performLayout(Size size) {
//    print('indent text with textfield performLayout: $size');
    //仅有一个元素, RichText
    if(state.allCacheDone == false){
      for(LayoutId item in state._children){
        RichText rt = item.child;
//        print('indent: ${state.widget.indent}, width:${state.widget.size.width}');
        Size _size = LayoutHelper.richTextSize(rt, state.widget.size.width - state.widget.indent - 20);
        state.widget.size.height = _size.height;
        state.layoutCache = Rect.fromLTWH(0, 0, _size.width, _size.height);
        layoutChild(0, BoxConstraints(
            minWidth: 0,
            maxWidth: 0,
            minHeight: 0,
            maxHeight: 0
        ));
        positionChild(0, Offset(0, 0));
      }
      state.allCacheDone = true;
    }else{
      BoxConstraints boxConstraints = BoxConstraints(
          minWidth: (state.widget.contentList.length == 1 && state.widget.contentList.first.runtimeType == IndentTextFieldSizeBox) ?
          size.width : state.layoutCache.width < 0 ? 0 : state.layoutCache.width,
          maxWidth: (state.widget.contentList.length == 1 && state.widget.contentList.first.runtimeType == IndentTextFieldSizeBox) ?
          size.width : state.layoutCache.width < 0 ?  0 : state.layoutCache.width,
          minHeight: state.layoutCache.height,
          maxHeight: state.layoutCache.height
      );
      layoutChild(0, boxConstraints);
      positionChild(0, Offset(state.layoutCache.left, state.layoutCache.top));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}


const double paddingBtm = 15;
const double fixWidth = 100;

class IndentTextFieldSizeBox extends StatelessWidget {

  final TextStyle style;
  final TextEditingController controller;

  Size get size => Size(fixWidth, style.fontSize + paddingBtm);

  IndentTextFieldSizeBox({
    this.style,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    Widget sizeBox = SizedBox(
      width: fixWidth,
      height: style.fontSize + paddingBtm, //避免输入区展示不全
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: paddingBtm, left: 5)
        ),
        style: style,
        controller: controller,
      ),
    );

    return sizeBox;
  }
}
