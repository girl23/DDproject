import 'package:flutter/material.dart';
import '../widget/indent_rich_widget.dart';
import '../layout_helper.dart';

///复选框和文本的间距
const double spacing = 10;

class IndentCheckBox extends IndentRichWidget{
  ///map<id:文本> 后续是否选中的值可以用 id 号获取
  final Map< dynamic, String> contentMap;

  ///记录此表格项的缩进值,将用于调整表格项的宽度以自适应高度
  final double indent;
  final TextStyle commonTextStyle;
  final void Function(Map<dynamic, bool> values) onValueChange;

  IndentCheckBox({
    @required this.contentMap,
    @required NonFinalSize size,
    @required this.indent,
    @required this.onValueChange,
    @required this.commonTextStyle
}):super(size:size);

  @override
  _IndentCheckBoxState createState() => _IndentCheckBoxState();
}

class _IndentCheckBoxState extends State<IndentCheckBox> {
  List<LayoutId> _children = [];
  List<IndentCheckBoxItemModel> _models = [];
  double _offsetY = 0;
  bool calculateCache = false;

  @override
  void initState() {
    _contentMapToWidget();
    super.initState();
  }

  void _contentMapToWidget(){
    widget.contentMap.forEach((id,value){
      IndentCheckBoxItemModel model = IndentCheckBoxItemModel(
          id,
          value,
          widget.commonTextStyle,
          RichText(text: TextSpan()),
      );
      _models.add(model);

    });
  }

  @override
  Widget build(BuildContext context) {
    _children = _models.map((model){
      RichText child = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
            children: [
              WidgetSpan(child: Container(
                width: widget.commonTextStyle.fontSize * 2,
                height: widget.commonTextStyle.fontSize,
                padding: EdgeInsets.only(right: spacing),
                child:  Checkbox(value: model.checkValue, onChanged: (v){
                setState(() {
                  model.checkValue = v;
                  Map<dynamic, bool> tempMap = {};
                  _models.forEach((IndentCheckBoxItemModel model){
                    tempMap[model.id] = model.checkValue;
                  });
                  if(widget.onValueChange != null){
                    widget.onValueChange(tempMap);
                  }
                });
              }),)),
              TextSpan(text: model.text, style: widget.commonTextStyle)
            ]
        ),
      );

      model.childToCalculateLayout = child;

      return LayoutId(
        id: model.id,
        child: child
      );
    }).toList();

    return Container(
      child: CustomMultiChildLayout(
        delegate: _IndentCheckBoxLayoutDelegate(this),
        children: _children,
      ),
    );
  }
}

class _IndentCheckBoxLayoutDelegate extends MultiChildLayoutDelegate {
  double endSpacing = 10;
  _IndentCheckBoxState state;
  _IndentCheckBoxLayoutDelegate(this.state);

  @override
  void performLayout(Size size) {
    state._offsetY = 0;
//    print('check box performLayout: $size');
    if(state.calculateCache == false){
      for(IndentCheckBoxItemModel model in state._models){

        Size itemSize = LayoutHelper.richTextSize(model.childToCalculateLayout, state.widget.size.width - state.widget.indent);
        model.layoutCacheRect = Rect.fromLTWH(0, state._offsetY, itemSize.width - state.widget.indent - endSpacing, itemSize.height);
        state._offsetY += itemSize.height;
        state.widget.size.height = state._offsetY;

        layoutChild(
            model.id,
            BoxConstraints(
              minWidth: 0,
              maxWidth: 0,
              minHeight: 0,
              maxHeight: 0,
            )
        );

        positionChild(
            model.id,
            Offset(
                0,
                0)
        );
      }
      state.calculateCache = true;
    }else{

      for(IndentCheckBoxItemModel model in state._models){
        layoutChild(
            model.id,
            BoxConstraints(
              minWidth: model.layoutCacheRect.width,
              maxWidth: model.layoutCacheRect.width,
              minHeight: model.layoutCacheRect.height,
              maxHeight: model.layoutCacheRect.height,
            )
        );

        positionChild(
            model.id,
            Offset(
                model.layoutCacheRect.left,
                model.layoutCacheRect.top)
        );
      }
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class IndentCheckBoxItemModel extends Object {
  final dynamic id;
  final String text;
  final TextStyle style;
  ///child 的指向 仅用于计算布局用
  RichText childToCalculateLayout;
  bool checkValue = false;
  bool layoutDone = false;
  Rect layoutCacheRect = Rect.zero;

  IndentCheckBoxItemModel(this.id, this.text, this.style,this.childToCalculateLayout);
}


