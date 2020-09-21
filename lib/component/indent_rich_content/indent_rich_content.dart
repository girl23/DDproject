import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double aIndentWidth = 20;

class IndentRichContent extends MultiChildRenderObjectWidget {
  final double fixWidth;

  IndentRichContent({@required this.fixWidth, @required List<Widget> children})
      : super(children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _IndentRichContentRenderBox(fixWidth);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {}
}

class _IndentRichContentRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _IndentRichContentParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _IndentRichContentParentData> {
  final double fixWidth;
  _IndentRichContentRenderBox(this.fixWidth);

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _IndentRichContentParentData) {
      child.parentData = _IndentRichContentParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox child = firstChild;
    double offsetY = 0;
    while (child != null) {
      _IndentRichContentParentData childParentData = child.parentData;
      child.layout(constraints, parentUsesSize: true);
      offsetY += child.size.height;
      child = childParentData.nextSibling;
    }
    size = constraints.tighten(width: fixWidth, height: offsetY).smallest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class _IndentRichContentParentData extends ContainerBoxParentData<RenderBox> {

}

//  typedef DidLayoutCallBack = void Function(double height);
//
//  ///用于展示每个 td 的内容
//  class IndentRichContent extends StatefulWidget {
//    final double givenWidth;
//    final double lineSpace;
//    final TableCellModel tdModel;
//    final DidLayoutCallBack layoutCallBack;
//    final EdgeInsets parentPadding;
//
//    IndentRichContent({
//      this.givenWidth,
//      this.lineSpace = 4,
//      this.layoutCallBack,
//      this.tdModel,
//      this.parentPadding,
//    });
//
//    @override
//    _IndentRichContentState createState() => _IndentRichContentState();
//  }
//
//  class _IndentRichContentState extends State<IndentRichContent> {
//
//    List<IndentRichContentModel> _rtModels;
//    List<IndentRichContentModel> _flatModelsResult = [];
//    List<Widget> _children = [];
//    ///每行段落的缩进值
//    double aIndentWidth = 15;
//    ///每个内容条目的 Y 轴偏移值,最大值为此内容条目的高度
//    double totalOffsetY = 0;
//    ///所有数据是否计算缓存完成
//    bool allCacheDone = false;
//
//    @override
//    void initState() {
//      processTdModelToUiModel();
//      _flatModels(_rtModels, _flatModelsResult);
//      _parseDataToWidget(_children);
//      super.initState();
//    }
//
//    //TODO 待数据结构确认后再写转化方法
//    void processTdModelToUiModel(){
//      this._rtModels = fakeData();
//    }
//
//    @override
//    Widget build(BuildContext context) {
//      return Container(
//        width: fixWidth,
//        height: totalOffsetY + widget.parentPadding.vertical,
//        child: CustomMultiChildLayout(
//          delegate: _IndentLayoutDelegate(_flatModelsResult,this,(){
//          }),
//          children: _children,
//        ),
//      );
//    }
//
//    void _flatModels(List<IndentRichContentModel> models, List<IndentRichContentModel> result){
//      if(models == null || models.length == 0) return;
//      for(IndentRichContentModel model in models){
//        result.add(model);
//        _flatModels(model.children, result);
//      }
//    }
//
//    void _parseDataToWidget(List<Widget> children){
//      _flatModelsResult.forEach((IndentRichContentModel model){
//        children.add(
//          LayoutId(id: model.id, child: model.content)
//        );
//      });
//    }
//
//    List<IndentRichContentModel> fakeData(){
//      TextStyle textStyle = TextStyle(fontSize: fontSize,color: Colors.black);
//      return [
//        IndentRichContentModel(
//            content: IndentTextWithTextField(
//                contentList: ['除下列情况外，活门打开：'],
//                size: NonFinalSize(fixWidth, 0), indent: 0, style: textStyle), id: 0, level: 0, children: [
//          IndentRichContentModel(content: IndentTextWithTextField(
//              contentList: ['快递费大会上飞机上的痕迹', IndentTextFieldSizeBox(style: textStyle,)],
//              size: NonFinalSize(fixWidth, 0), indent: aIndentWidth, style: textStyle), id: 1, level: 1, children: [
//          ]),
//          IndentRichContentModel(content: IndentTextWithTextField(
//              contentList: ['大手大脚水电费时间点发货的时间发货刷卡缴费和思考发货时间客户:'],
//              size: NonFinalSize(fixWidth, 0), indent: aIndentWidth, style: textStyle), id: 2, level: 1, children: [
//          ]),
//          IndentRichContentModel(content: IndentTextWithTextField(
//              contentList: ['第三方电费时间点'],
//              size: NonFinalSize(fixWidth, 0), indent: aIndentWidth, style: textStyle), id: 3, level: 1, children: [
//            IndentRichContentModel(content: IndentTextWithTextField(
//                contentList: ['胜多负少的方式大手大脚水电费时间点发货的时间发货刷卡缴费和思考发货时间客户科技胜多负少的健康'],
//                size: NonFinalSize(fixWidth, 0), indent: aIndentWidth*2, style: textStyle), id: 4, level: 2, children: [
//            ]),
//            IndentRichContentModel(content: IndentTextWithTextField(
//                contentList: ['Xi an University of Technology (XUT) is a comprehensive public university featuring mainly in science and technology, which is jointly constructed by the Shaan''xi provincial and central government. Our university was founded in 1949, and has a history of 64 years so far. It was known as Shaanxi Institute of Mechanical Engineering before January 1994, which was established by combining Beijing Institute of Mechanical Engineering and Shaanxi Polytechnic University in 1972.'],
//                size: NonFinalSize(fixWidth, 0), indent: aIndentWidth*2, style: textStyle), id: 5, level: 2, children: [
//            ]),
//          ]),
//          IndentRichContentModel(content: IndentTextWithTextField(
//              contentList: ['结婚登记skdfhsdhfj jhdsfjhsdk '],
//              size: NonFinalSize(fixWidth, 0), indent: 0, style: textStyle), id: 6, level: 2, children: [
//          ]),
//          IndentRichContentModel(content: IndentTextWithTextField(
//              contentList: ['sfhjsdkhfk 收到反馈时都会发生 看电视机房快速减肥是否健康和实际得分灰色空间'],
//              size: NonFinalSize(fixWidth, 0), indent: aIndentWidth*2, style: textStyle), id: 7, level: 1, children: [
//          ]),
//          IndentRichContentModel(content: IndentTextWithTextField(
//              contentList: ['大手大脚水电费时间点发货的时间发货刷卡缴费和思考发货时间客户'],
//              size: NonFinalSize(fixWidth, 0), indent: aIndentWidth*1, style: textStyle), id: 8, level: 1, children: [
//          ]),
//
//          IndentRichContentModel(content: IndentTextWithTextField(
//            size: NonFinalSize(fixWidth, 0),
//            indent: aIndentWidth * 1,
//            style: TextStyle(fontSize: fontSize, color: Colors.black),
//            contentList: [
//              IndentTextFieldSizeBox(
//                style: TextStyle(fontSize: fontSize),
//              ),
//            ],
//          ), id: 9, level: 1, children: [
//            IndentRichContentModel(content: IndentCheckBox(contentMap: {
//              1:'书法家适得府君书的',
//              2:'独守空房',
//              3:'卡及时发货的接是否还上班簇的数据发布的就是福建省电话费技术大会发布会上打瞌睡复活甲萨克',
//              4:'看看书'
//            },
//              size: NonFinalSize(fixWidth, 0),
//              indent: aIndentWidth * 1,
//              onValueChange: (values){
//                print('复选框: value:$values');
//              },
//              commonTextStyle: TextStyle(fontSize: fontSize, color: Colors.black,),
//            ), id: 10, level: 1, children: []),
//
//            IndentRichContentModel(content: IndentTextWithTextField(
//              size: NonFinalSize(fixWidth, 0),
//              indent: aIndentWidth * 1,
//              style: TextStyle(fontSize: fontSize, color: Colors.black),
//              contentList: [
//                '如果发动机起动时交叉引气活门打开，两个组件流量控制活门关闭。',
//                IndentTextFieldSizeBox(
//                  style: TextStyle(fontSize: fontSize),
//                ),
//                '但是房价开始发货时间发货时间点发货速度快',
//                IndentTextFieldSizeBox(
//                  style: TextStyle(fontSize: fontSize),
//                ),
//              ],
//            ),id: 11, level: 1, children: [
//              IndentRichContentModel(
//                  content: IndentImage(size: NonFinalSize(fixWidth,0), indent: aIndentWidth * 2, image: Image.asset('assets/timg.jpeg'), didClickImage: (image){
//                    print('click image');
//                  },),
//                  id: 12, level: 2, children: [])
//            ]),
//
//            IndentRichContentModel(
//                content: Text('当 MODE 选择器调到 IGN （或CRK）位，如果交叉引气活门关闭，位于起动的发动机一侧的活门立即关闭。',
//                    style: TextStyle(fontSize: fontSize)), id: 13, level: 0, children: [
//            ])
//          ]),
//        ]),
//      ];
//    }
//  }
//
//
//  class _IndentLayoutDelegate extends MultiChildLayoutDelegate{
//
//    final List<IndentRichContentModel> models;
//    final _IndentRichContentState state;
//    final void Function() layoutCacheCallBack;
//
//    _IndentLayoutDelegate(this.models,this.state,this.layoutCacheCallBack);
//
//    @override
//    void performLayout(Size size) {
//      state.totalOffsetY = 0;
////      print('indent rich content performLayout: $size');
//      if(state.allCacheDone == false){
//        for(IndentRichContentModel model in models){
//          model.tdContentWidth = size.width;
//          if(model.didCacheLayout == false){
//            ///先布局 child 让每个 child 内部根据数据去计算布局,然后缓存.且利用子控件的布局去计算父控件的宽高
//            layoutChild(
//                model.id,
//                BoxConstraints(
//                    minWidth: 0,
//                    maxWidth: 0,
//                    minHeight: 0,
//                    maxHeight: 0
//                )
//            );
//            positionChild(
//                model.id,
//                Offset(
//                    0,
//                    0
//                )
//            );
//
//            Widget child = model.content;
//            double offsetX = (state.aIndentWidth * (model.level + 1));
//            double width = state.fixWidth - offsetX;
//
//            Size _size = Size.zero;
//            Rect rect = Rect.zero;
//
//            ///这里布局子控件的真实宽高
//            if(child.runtimeType == Text){
//              _size = LayoutHelper.textSize(child,width);
//            }else if(child.runtimeType == RichText) {
//              _size = LayoutHelper.richTextSize(child, width);
//            }else if(child is IndentRichWidget){
//              _size = Size(child.size.width, child.size.height);
//            }
//
//            rect = Rect.fromLTWH(
//                offsetX, state.totalOffsetY, _size.width, _size.height);
//            model.layoutRect = rect;
//            state.totalOffsetY += _size.height + state.widget.lineSpace;
//
//            model.didCacheLayout = true;
//            if(layoutCacheCallBack != null){
//              layoutCacheCallBack();
//            }
//          }
//        }
//        state.allCacheDone = true;
//      }else{
//
//        for(IndentRichContentModel model in models){
//          state.totalOffsetY += model.layoutRect.height + state.widget.lineSpace;
//          layoutChild(
//              model.id,
//              BoxConstraints(
//                  minWidth: model.layoutRect.width,
//                  maxWidth: model.layoutRect.width,
//                  minHeight: model.layoutRect.height,
//                  maxHeight: model.layoutRect.height
//              )
//          );
//          positionChild(
//              model.id,
//              Offset(
//                  model.layoutRect.left,
//                  model.layoutRect.top
//              )
//          );
//        }
//      }
//
//      if(state.widget.layoutCallBack != null){
//        state.widget.layoutCallBack(state.totalOffsetY + state.widget.parentPadding.vertical);
//      }
//    }
//
//    @override
//    bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
//      return true;
//    }
//  }
